# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
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

class GenericDescriptor(object):
    """A descriptor that set getter and setter.
    class example from: http://nbviewer.jupyter.org/urls/gist.github.com/ChrisBeaumont/5758381/raw/descriptor_writeup.ipynb"""
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


class Table(object):
    """Base class representing a table.
    Assume it have to be used as a pure virtual."""
    def __init__(self, controller, tableName, pk):
        self.__controller = controller
        self.__tableName = tableName
        self.__pk = pk


    def controller(self):
        return self.__controller


    def table_name(self):
        return self.__tableName


    def pk(self):
        return self.__pk


    def fetch(self, autocommit=True):
        """retrieve a record with a specified primary key id."""
        if not getattr(self, self.__pk):
            message = "No " + self.__pk + " primary key value set"
            self.__controller.show_info(message)
            return

        fields = vars(self.__class__).keys()
        # remove all _<classname>__<name> or __<names>__ vars, e.g. private vars
        fields = [x for x in fields if "__" not in x]
        
        sql = "SELECT {0} FROM {1}.{2} WHERE {3} = {4}".format(
            ", ".join(fields),
            self.__controller.schema_name,
            self.__tableName,
            self.__pk,
            getattr(self, self.__pk))
        row = self.__controller.get_row(sql, commit=autocommit)
        if not row:
            message = "No records of " + type(self).__name__ + " found with sql: " + sql
            self.__controller.show_info(message)
            return
        
        # set values of the current Event get from row values
        for field, value in zip(fields, row):
            setattr(self, field, value)


    def upsert(self, autocommit=True):
        """Save current event state in the DB as new record.
        Eventually add the record if it is not available"""
        fields = vars(self.__class__).keys()
        # remove all _<classname>__<name> or __<names>__ vars, e.g. private vars
        fields = [x for x in fields if (("__" not in x) and (x != self.__pk))]
        values = [ getattr(self, field) for field in fields]

        # remove all None elements
        noneIndexes = []
        for index, value in enumerate(values):
            if not value:
                noneIndexes.append(index)
        for index in reversed(noneIndexes): # reversed to avoid change of index
            del fields[index]
            del values[index]
        values = [str(x) for x in values]

        currentPk = getattr(self, self.__pk)
        status = self.__controller.execute_upsert(self.__tableName, self.__pk, str(currentPk), fields, values, autocommit=autocommit)
        if status:
            message = "Values has been added/updated"
            self.__controller.show_info(message)
            return status
        
        # get new added id in case of an insert
        pk = getattr(self, self.__pk)
        if not pk or pk < 0:
            value = self.currval(autocommit=autocommit)
            setattr(self, self.__pk, value)
        
        return True


    def nextval(self, autocommit=True):
        """Get the next id for the __pk. that will be used for the next insert.
        BEWARE that this call increment the sequence at each call."""
        sql = "SELECT nextval(pg_get_serial_sequence('{}.{}', '{}'))".format(self.__controller.schema_name, self.__tableName, self.__pk)
        row = self.__controller.get_row(sql, commit=autocommit)
        if row:
            return row[0]
        else:
            return None


    def currval(self, autocommit=True):
        """Get the current id for the __pk. that is the id of the last insert."""
        # get latest updated sequence ASSUMED a sequence is available!
        # using lastval can generate problems in case of parallel inserts
        # sql = ("SELECT lastval()")
        sql = "SELECT currval(pg_get_serial_sequence('{}.{}', '{}'))".format(self.__controller.schema_name, self.__tableName, self.__pk)
        row = self.__controller.get_row(sql, commit=autocommit)
        if row:
            return row[0]
        else:
            # serial not yet defined in the current session
            return None


    def maxPk(self, autocommit=True):
        """Retrive max value of the primary key (if numeric)."""
        # doe not use DB nextval function becouse each call it is incremented
        sql = "SELECT MAX({2}) FROM {0}.{1}".format(self.__controller.schema_name, self.__tableName, self.__pk)
        row = self.__controller.get_row(sql, commit=autocommit)
        if not row or not row[0]:
            return 0
        else:
            return row[0]


    def pks(self, autocommit=True):
        """Fetch all pk values."""
        sql = "SELECT {2} FROM {0}.{1} ORDER BY {2}".format(self.__controller.schema_name, self.__tableName, self.__pk)
        rows = self.__controller.get_rows(sql, autocommit=autocommit)
        return rows


    def delete(self, pks=[], allRecords=False, autocommit=True):
        """Delete all listed records with specified pks.
        If not ids are specified and not remove all => del current record."""
        sql = "DELETE FROM {0}.{1}".format(self.__controller.schema_name, self.__tableName)
        if not allRecords:
            # if ampty list of ids => get the current id of the record
            if not pks:
                pks = [getattr(self, self.__pk)]
            # add records to delete
            sql += " WHERE {0} IN ({1})".format(self.__pk, ','.join(pks))            
        self.__controller.execute_sql(sql, autocommit=autocommit)
