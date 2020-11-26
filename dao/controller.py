"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtSql import QSqlDatabase

from .. import global_vars
from ..core.utils import tools_gw
from ..lib import tools_qgis, tools_log, tools_db
from ..lib.tools_pgdao import PgDao


class DaoController:

    def __init__(self, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """

        self.settings = global_vars.settings
        global_vars.plugin_name = plugin_name
        global_vars.iface = iface
        self.plugin_dir = None
        self.logged = False
        self.postgresql_version = None
        self.logger = None
        self.schema_name = None
        self.dao = None
        self.credentials = None
        self.prev_maptool = None
        self.gw_infotools = None
        self.is_inserting = False

        if create_logger:
            tools_log.set_logger(self, logger_name)


    def close_db(self):
        """ Close database connection """

        if self.dao:
            if not self.dao.close_db():
                tools_log.log_info(str(global_vars.last_error))
            del self.dao

        global_vars.current_user = None


    def set_schema_name(self, schema_name):
        self.schema_name = schema_name


    def set_plugin_dir(self, plugin_dir):
        self.plugin_dir = plugin_dir
        tools_log.log_info(f"Plugin folder: {self.plugin_dir}")


    def close_logger(self):
        """ Close logger file """

        if self.logger:
            self.logger.close_logger()
            del self.logger


    def set_database_connection(self):
        """ Set database connection """

        # Initialize variables
        self.dao = None
        global_vars.last_error = None
        self.logged = False
        global_vars.current_user = None

        self.layer_source, not_version = tools_gw.get_layer_source_from_credentials()
        if self.layer_source:
            if self.layer_source['service'] is None and (self.layer_source['db'] is None
                    or self.layer_source['host'] is None or self.layer_source['user'] is None
                    or self.layer_source['password'] is None or self.layer_source['port'] is None):
                return False, not_version
        else:
            return False, not_version

        self.logged = True

        return True, not_version


    def connect_to_database(self, host, port, db, user, pwd, sslmode):
        """ Connect to database with selected parameters """

        # tools_log.log_info(f"connect_to_database - sslmode: {sslmode}")

        # Check if selected parameters is correct
        if None in (host, port, db, user, pwd):
            message = "Database connection error. Please check your connection parameters."
            global_vars.last_error = tools_gw.tr(message)
            return False

        # Update current user
        global_vars.user = user
        self.current_user = user

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL", global_vars.plugin_name)
        self.db.setHostName(host)
        if port != '':
            self.db.setPort(int(port))
        self.db.setDatabaseName(db)
        self.db.setUserName(user)
        self.db.setPassword(pwd)
        status = self.db.open()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            global_vars.last_error = tools_gw.tr(message)
            details = self.db.lastError().databaseText()
            tools_log.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_params(host, port, db, user, pwd, sslmode)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            global_vars.last_error = tools_gw.tr(message)
            tools_log.log_warning(str(self.dao.last_error))
            return False

        return status


    def connect_to_database_service(self, service, sslmode=None):
        """ Connect to database trough selected service
        This service must exist in file pg_service.conf """

        conn_string = f"service={service}"
        if sslmode:
            conn_string += f" sslmode={sslmode}"

        tools_log.log_info(f"connect_to_database_service: {conn_string}")

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL", global_vars.plugin_name)
        self.db.setConnectOptions(conn_string)
        status = self.db.open()
        if not status:
            message = "Database connection error (QSqlDatabase). Please open plugin log file to get more details"
            global_vars.last_error = tools_gw.tr(message)
            details = self.db.lastError().databaseText()
            tools_log.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_conn_string(conn_string)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error (PgDao). Please open plugin log file to get more details"
            global_vars.last_error = tools_gw.tr(message)
            tools_log.log_warning(str(self.dao.last_error))
            return False

        return status


    def check_db_connection(self):
        """ Check database connection. Reconnect if needed """

        opened = True
        try:
            opened = self.db.isOpen()
            if not opened:
                opened = self.db.open()
                if not opened:
                    details = self.db.lastError().databaseText()
                    tools_log.log_warning(f"check_db_connection not opened: {details}")
        except Exception as e:
            tools_log.log_warning(f"check_db_connection Exception: {e}")
        finally:
            return opened


    def get_postgresql_version(self):
        """ Get PostgreSQL version (integer value) """

        self.postgresql_version = None
        sql = "SELECT current_setting('server_version_num');"
        row = self.dao.get_row(sql)
        if row:
            self.postgresql_version = row[0]

        return self.postgresql_version


    def get_postgis_version(self):
        """ Get Postgis version (integer value) """

        self.postgis_version = None
        sql = "SELECT postgis_lib_version()"
        row = self.dao.get_row(sql)
        if row:
            self.postgis_version = row[0]

        return self.postgis_version


    def get_sql(self, sql, log_sql=False, params=None):
        """ Generate SQL with params. Useful for debugging """

        if params:
            sql = self.dao.mogrify(sql, params)
        if log_sql:
            tools_log.log_info(sql, stack_level_increase=2)

        return sql


    def get_row(self, sql, log_info=True, log_sql=False, commit=True, params=None):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        sql = self.get_sql(sql, log_sql, params)
        row = self.dao.get_row(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not row:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_db.manage_exception_db(global_vars.last_error, sql)
            elif global_vars.last_error is None and log_info:
                tools_log.log_info("Any record found", parameter=sql, stack_level_increase=1)

        return row


    def get_rows(self, sql, log_info=True, log_sql=False, commit=True, params=None, add_empty_row=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        sql = self.get_sql(sql, log_sql, params)
        rows = None
        rows2 = self.dao.get_rows(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not rows2:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_db.manage_exception_db(global_vars.last_error, sql)
            elif global_vars.last_error is None and log_info:
                tools_log.log_info("Any record found", parameter=sql, stack_level_increase=1)
        else:
            if add_empty_row:
                rows = [('', '')]
                rows.extend(rows2)
            else:
                rows = rows2

        return rows


    def execute_sql(self, sql, log_sql=False, log_error=False, commit=True, filepath=None):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            tools_log.log_info(sql, stack_level_increase=1)
        result = self.dao.execute_sql(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not result:
            if log_error:
                tools_log.log_info(sql, stack_level_increase=1)
            tools_db.manage_exception_db(global_vars.last_error, sql, filepath=filepath)
            return False

        return True


    def execute_returning(self, sql, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            tools_log.log_info(sql, stack_level_increase=1)
        value = self.dao.execute_returning(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not value:
            if log_error:
                tools_log.log_info(sql, stack_level_increase=1)
            tools_db.manage_exception_db(global_vars.last_error, sql)
            return False

        return value


    def execute_insert_or_update(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute INSERT or UPDATE sentence. Used for PostgreSQL database versions <9.5 """

        # Check if we have to perform an INSERT or an UPDATE
        if unique_value != 'current_user':
            unique_value = "'" + unique_value + "'"
        sql = ("SELECT * FROM " + tablename + ""
               " WHERE " + str(unique_field) + " = " + unique_value)
        row = self.get_row(sql, commit=commit)

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
        result = self.dao.execute_sql(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not result:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_db.manage_exception_db(global_vars.last_error, sql)

        return result


    def execute_upsert(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute UPSERT sentence """

        # Check PostgreSQL version
        if not self.postgresql_version:
            self.get_postgresql_version()

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
        result = self.dao.execute_sql(sql, commit)
        global_vars.last_error = self.dao.last_error
        if not result:
            # Check if any error has been raised
            if global_vars.last_error:
                tools_db.manage_exception_db(global_vars.last_error, sql)

        return result


    def get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        return tools_qgis.get_layer_source(layer)


    def get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        return tools_qgis.qgis_get_layer_source_table_name(layer)


    def get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """

        return tools_qgis.get_primary_key(layer)


    def get_log_folder(self):
        """ Return log folder """
        return self.logger.log_folder



    """  Functions related with Qgis versions """

    def get_layers(self):
        """ Return layers in the same order as listed in TOC """

        return tools_qgis.get_project_layers()


    def set_search_path(self, schema_name):
        """ Set parameter search_path for current QGIS project """

        sql = f"SET search_path = {schema_name}, public;"
        self.execute_sql(sql)
        self.dao.set_search_path = sql
