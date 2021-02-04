# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from weakref import WeakKeyDictionary
from ... import global_vars
from ...lib import tools_db, tools_log, tools_qt, tools_qgis


class GwGenericDescriptor(object):
    """A descriptor that set getter and setter. class example from:
    http://nbviewer.jupyter.org/urls/gist.github.com/ChrisBeaumont/5758381/raw/descriptor_writeup.ipynb"""

    def __init__(self, default):
        self.default = default
        self.data = WeakKeyDictionary()

    def __get__(self, instance, owner):
        # we get here when someone calls x.d, and d is a NonNegative instance
        # instance = x
        # owner = type(x)
        return self.data.get(instance, self.default)

    def __set__(self, instance, value):
        # we get here when someone calls x.d = val
        # instance = x
        # value = val
        self.data[instance] = value


class GwTable(object):
    """Base class representing a table. Assume it have to be used as a pure virtual."""

    def __init__(self, table_name, pk):
        self.__table_name = table_name
        self.__pk = pk


    def table_name(self):
        return self.__table_name

    def pk(self):
        return self.__pk


    def field_names(self):
        """Return the list of field names composing the table.
        Names are that exposed in the class not derived from the db table."""

        fields = list(vars(self.__class__).keys())
        # remove all _<classname>__<name> or __<names>__ vars, e.g. private vars
        fields = [x for x in fields if "__" not in x]
        return fields


    def fetch(self, commit=True):
        """retrieve a record with a specified primary key id."""

        if not getattr(self, self.pk()):
            message = "No primary key value set"
            tools_qgis.show_info(message, parameter=self.pk)
            return False

        fields = list(vars(self.__class__).keys())
        # remove all _<classname>__<name> or __<names>__ vars, e.g. private vars
        fields = [x for x in fields if "__" not in x]

        sql = "SELECT {0} FROM {1} WHERE {2} = '{3}'".format(
            ", ".join(fields),
            self.table_name(),
            self.pk(),
            getattr(self, self.pk()))
        row = tools_db.get_row(sql, commit=commit)
        if not row:
            return False

        # set values of the current Event get from row values
        for field, value in zip(fields, row):
            setattr(self, field, value)

        return True


    def upsert(self, commit=True):
        """Save current event state in the DB as new record.
        Eventually add the record if it is not available"""

        fields = list(vars(self.__class__).keys())
        # remove all _<classname>__<name> or __<names>__ vars, e.g. private vars
        fields = [x for x in fields if (("__" not in x) and (x != self.pk()))]
        values = [getattr(self, field) for field in fields]

        # Set '' for void values
        for index, value in enumerate(values):
            if value in (None, '', 'null', 'NULL'):
                values[index] = ''

        values = [str(x) for x in values]
        current_pk = getattr(self, self.pk())
        status = self.execute_upsert(
            self.table_name(), self.pk(), str(current_pk), fields, values, commit=commit)
        if status:
            message = "Values has been updated"
            tools_qgis.show_info(message)
            return status

        # get new added id in case of an insert
        pk = getattr(self, self.pk())
        if not pk or pk < 0:
            value = self.currval(commit=commit)
            setattr(self, self.pk(), value)

        return True


    def nextval(self, commit=True):
        """Get the next id for the __pk. that will be used for the next insert.
        BEWARE that this call increment the sequence at each call."""

        sql = "SELECT nextval(pg_get_serial_sequence('{}', '{}'))".format(
            self.table_name(), self.pk())
        row = tools_db.get_row(sql, commit=commit)
        if row:
            return row[0]
        else:
            return None


    def currval(self, commit=True):
        """Get the current id for the __pk. that is the id of the last insert."""

        # get latest updated sequence ASSUMED a sequence is available!
        # using lastval can generate problems in case of parallel inserts
        # sql = ("SELECT lastval()")
        sql = "SELECT currval(pg_get_serial_sequence('{}', '{}'))".format(
            self.table_name(), self.pk())
        row = tools_db.get_row(sql, commit=commit)
        if row:
            return row[0]
        else:
            # serial not yet defined in the current session
            return None


    def max_pk(self, commit=True):
        """Retrive max value of the primary key (if numeric)."""

        # doe not use DB nextval function becouse each call it is incremented
        sql = "SELECT MAX({1}) FROM {0}".format(
            self.table_name(), self.pk())
        row = tools_db.get_row(sql, commit=commit)
        if not row or not row[0]:
            return 0
        else:
            return row[0]


    def pks(self, commit=True):
        """Fetch all pk values."""

        sql = "SELECT {1} FROM {0} ORDER BY {1}".format(
            self.table_name(), self.pk())
        rows = tools_db.get_rows(sql, commit=commit)
        return rows


    def delete(self, pks=[], all_records=False, where_clause='', commit=True):
        """Delete all listed records with specified pks.
        If not ids are specified and not remove all => del current record."""

        sql = "DELETE FROM {0}".format(self.table_name())
        if not all_records:
            if not where_clause:
                # if ampty list of ids => get the current id of the record
                if not pks:
                    pks = [getattr(self, self.pk())]
                # add records to delete
                pks = [str(x) for x in pks]
                sql += " WHERE {0} IN ({1})".format(self.pk(), ','.join(pks))
            else:
                sql += " WHERE {}".format(where_clause)

        return tools_db.execute_sql(sql, commit=commit)


    def execute_upsert(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute UPSERT sentence """

        # Check PostgreSQL version
        if not global_vars.session_vars['pg_version']:
            tools_db.get_pg_version()

        # Set SQL for INSERT
        sql = "INSERT INTO " + tablename + "(" + unique_field + ", "

        # Iterate over fields
        sql_fields = ""
        for fieldname in fields:
            sql_fields += fieldname + ", "
        sql += sql_fields[:-2] + ") VALUES ("

        # Manage value 'current_user'
        if unique_value != 'current_user':
            unique_value = "$$" + unique_value + "$$"

        # Iterate over values
        sql_values = ""
        for value in values:
            if value != 'current_user':
                if value != '':
                    sql_values += "$$" + value + "$$, "
                else:
                    sql_values += "NULL, "
            else:
                sql_values += value + ", "
        sql += unique_value + ", " + sql_values[:-2] + ")"

        # Set SQL for UPDATE
        sql += (" ON CONFLICT (" + unique_field + ") DO UPDATE"
                " SET (" + sql_fields[:-2] + ") = (" + sql_values[:-2] + ")"
                " WHERE " + tablename + "." + unique_field + " = " + unique_value)

        # Execute UPSERT
        tools_log.log_info(sql, stack_level_increase=1)
        result = global_vars.dao.execute_sql(sql, commit)
        global_vars.session_vars['last_error'] = global_vars.dao.last_error
        if not result:
            # Check if any error has been raised
            if global_vars.session_vars['last_error']:
                tools_qt.manage_exception_db(global_vars.session_vars['last_error'], sql, schema_name=global_vars.schema_name)

        return result
