"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-


from .. import global_vars
from ..lib import tools_qgis, tools_log, tools_db
from ..core.utils import tools_gw


class DaoController:

    def __init__(self, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """

        self.postgresql_version = None

        if create_logger:
            tools_log.set_logger(self, logger_name)


    def execute_insert_or_update(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute INSERT or UPDATE sentence. Used for PostgreSQL database versions <9.5 """

        # Check if we have to perform an INSERT or an UPDATE
        if unique_value != 'current_user':
            unique_value = "'" + unique_value + "'"
        sql = ("SELECT * FROM " + tablename + ""
               " WHERE " + str(unique_field) + " = " + unique_value)
        row = tools_db.get_row(sql, commit=commit)

        # Get fields
        sql_fields = ""
        for fieldname in fields:
            sql_fields += fieldname + ", "

        # Get values
        sql_values = ""
        for value in values:
            if value != 'current_user':
                if value != '':
                    sql_values += "'" + value + "', "
                else:
                    sql_values += "NULL, "
            else:
                sql_values += value + ", "

        # Perform an INSERT
        if not row:
            # Set SQL for INSERT
            sql = " INSERT INTO " + tablename + "(" + unique_field + ", "
            sql += sql_fields[:-2] + ") VALUES ("

            # Manage value 'current_user'
            if unique_value != 'current_user':
                unique_value = "'" + unique_value + "'"
            sql += unique_value + ", " + sql_values[:-2] + ");"

        # Perform an UPDATE
        else:
            # Set SQL for UPDATE
            sql = ("UPDATE " + tablename + ""
                   " SET (" + sql_fields[:-2] + ") = (" + sql_values[:-2] + ")"
                   " WHERE " + unique_field + " = " + unique_value)
        sql = sql.replace("''", "'")

        # Execute sql
        tools_log.log_info(sql, stack_level_increase=1)
        result = global_vars.dao.execute_sql(sql, commit)
        global_vars.last_error = global_vars.dao.last_error
        if not result:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_gw.manage_exception(global_vars.last_error, sql, schema_name=global_vars.schema_name)

        return result


    def execute_upsert(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute UPSERT sentence """

        # Check PostgreSQL version
        if not self.postgresql_version:
            tools_db.get_postgresql_version()

        if int(self.postgresql_version) < 90500:
            self.execute_insert_or_update(tablename, unique_field, unique_value, fields, values, commit)
            return True

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
        global_vars.last_error = global_vars.dao.last_error
        if not result:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_gw.manage_exception_db(global_vars.last_error, sql, schema_name=global_vars.schema_name)

        return result
