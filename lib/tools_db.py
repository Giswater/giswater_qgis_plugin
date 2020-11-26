"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import inspect

from qgis.PyQt.QtSql import QSqlDatabase

from .. import global_vars
from ..core.utils import tools_gw
from . import tools_os, tools_log
from ..lib.tools_pgdao import PgDao


def make_list_for_completer(sql):
    """ Prepare a list with the necessary items for the completer
    :param sql: Query to be executed, where will we get the list of items (string)
    :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
    """

    rows = get_rows(sql)
    list_items = []
    if rows:
        for row in rows:
            list_items.append(str(row[0]))
    return list_items


def check_table(tablename, schemaname=None):
    """ Check if selected table exists in selected schema """

    if schemaname is None:
        schemaname = global_vars.schema_name
        if schemaname is None:
            tools_gw.get_layer_source_from_credentials()
            schemaname = global_vars.schema_name
            if schemaname is None:
                return None

    schemaname = schemaname.replace('"', '')
    sql = "SELECT * FROM pg_tables WHERE schemaname = %s AND tablename = %s"
    params = [schemaname, tablename]
    row = get_row(sql, log_info=False, params=params)
    return row


def check_view(viewname, schemaname=None):
    """ Check if selected view exists in selected schema """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    sql = ("SELECT * FROM pg_views "
           "WHERE schemaname = %s AND viewname = %s ")
    params = [schemaname, viewname]
    row = get_row(sql, log_info=False, params=params)
    return row


def check_column(tablename, columname, schemaname=None):
    """ Check if @columname exists table @schemaname.@tablename """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    sql = ("SELECT * FROM information_schema.columns "
           "WHERE table_schema = %s AND table_name = %s AND column_name = %s")
    params = [schemaname, tablename, columname]
    row = get_row(sql, log_info=False, params=params)
    return row


def check_role(role_name):
    """ Check if @role_name exists """

    sql = f"SELECT * FROM pg_roles WHERE rolname = '{role_name}'"
    row = get_row(sql, log_info=False)
    return row


def check_role_user(role_name, username=None):
    """ Check if current user belongs to @role_name """

    # Check both @role_name and @username exists
    if not check_role(role_name):
        return False

    if username is None:
        username = global_vars.user

    if not check_role(username):
        return False

    sql = ("SELECT pg_has_role('" + username + "', '" + role_name + "', 'MEMBER');")
    row = get_row(sql)
    if row:
        return row[0]
    else:
        return False


def get_current_user():
    """ Get current user connected to database """

    if global_vars.current_user:
        return global_vars.current_user

    sql = "SELECT current_user"
    row = get_row(sql)
    cur_user = ""
    if row:
        cur_user = str(row[0])
    global_vars.current_user = cur_user
    return cur_user


def get_columns_list(tablename, schemaname=None):
    """ Return list of all columns in @tablename """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    sql = ("SELECT column_name FROM information_schema.columns "
           "WHERE table_schema = %s AND table_name = %s "
           "ORDER BY ordinal_position")
    params = [schemaname, tablename]
    column_names = get_rows(sql, params=params)
    return column_names


def get_srid(tablename, schemaname=None):
    """ Find SRID of selected schema """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    srid = None
    sql = "SELECT Find_SRID(%s, %s, 'the_geom');"
    params = [schemaname, tablename]
    row = get_row(sql, params=params)
    if row:
        srid = row[0]

    return srid

def set_database_connection():
    """ Set database connection """

    # Initialize variables
    global_vars.dao = None
    global_vars.last_error = None
    global_vars.logged = False
    global_vars.current_user = None

    layer_source, not_version = tools_gw.get_layer_source_from_credentials()
    if layer_source:
        if layer_source['service'] is None and (layer_source['db'] is None
                or layer_source['host'] is None or layer_source['user'] is None
                or layer_source['password'] is None or layer_source['port'] is None):
            return False, not_version
    else:
        return False, not_version

    global_vars.logged = True

    return True, not_version


def check_db_connection():
    """ Check database connection. Reconnect if needed """

    opened = True
    try:
        opened = global_vars.db.isOpen()
        if not opened:
            opened = global_vars.db.open()
            if not opened:
                details = global_vars.db.lastError().databaseText()
                tools_log.log_warning(f"check_db_connection not opened: {details}")
    except Exception as e:
        tools_log.log_warning(f"check_db_connection Exception: {e}")
    finally:
        return opened


def get_postgresql_version():
    """ Get PostgreSQL version (integer value) """

    global_vars.postgresql_version = None
    sql = "SELECT current_setting('server_version_num');"
    row = get_row(sql)
    if row:
        global_vars.postgresql_version = row[0]

    return global_vars.postgresql_version


def connect_to_database(host, port, db, user, pwd, sslmode):
    """ Connect to database with selected parameters """

    # tools_log.log_info(f"connect_to_database - sslmode: {sslmode}")

    # Check if selected parameters is correct
    if None in (host, port, db, user, pwd):
        message = "Database connection error. Please check your connection parameters."
        global_vars.last_error = tools_gw.tr(message)
        return False

    # Update current user
    global_vars.user = user
    global_vars.current_user = user

    # We need to create this connections for Table Views
    global_vars.db = QSqlDatabase.addDatabase("QPSQL", global_vars.plugin_name)
    global_vars.db.setHostName(host)
    if port != '':
        global_vars.db.setPort(int(port))
    global_vars.db.setDatabaseName(db)
    global_vars.db.setUserName(user)
    global_vars.db.setPassword(pwd)
    status = global_vars.db.open()
    if not status:
        message = "Database connection error. Please open plugin log file to get more details"
        global_vars.last_error = tools_gw.tr(message)
        details = global_vars.db.lastError().databaseText()
        tools_log.log_warning(str(details))
        return False

    # Connect to Database
    global_vars.dao = PgDao()
    global_vars.dao.set_params(host, port, db, user, pwd, sslmode)
    status = global_vars.dao.init_db()
    if not status:
        message = "Database connection error. Please open plugin log file to get more details"
        global_vars.last_error = tools_gw.tr(message)
        tools_log.log_warning(str(global_vars.dao.last_error))
        return False

    return status


def connect_to_database_service(service, sslmode=None):
    """ Connect to database trough selected service
    This service must exist in file pg_service.conf """

    conn_string = f"service={service}"
    if sslmode:
        conn_string += f" sslmode={sslmode}"

    tools_log.log_info(f"connect_to_database_service: {conn_string}")

    # We need to create this connections for Table Views
    global_vars.db = QSqlDatabase.addDatabase("QPSQL", global_vars.plugin_name)
    global_vars.db.setConnectOptions(conn_string)
    status = global_vars.db.open()
    if not status:
        message = "Database connection error (QSqlDatabase). Please open plugin log file to get more details"
        global_vars.last_error = tools_gw.tr(message)
        details = global_vars.db.lastError().databaseText()
        tools_log.log_warning(str(details))
        return False

    # Connect to Database
    global_vars.dao = PgDao()
    global_vars.dao.set_conn_string(conn_string)
    status = global_vars.dao.init_db()
    if not status:
        message = "Database connection error (PgDao). Please open plugin log file to get more details"
        global_vars.last_error = tools_gw.tr(message)
        tools_log.log_warning(str(global_vars.dao.last_error))
        return False

    return status


def get_postgis_version():
    """ Get Postgis version (integer value) """

    postgis_version = None
    sql = "SELECT postgis_lib_version()"
    row = global_vars.dao.get_row(sql)
    if row:
        postgis_version = row[0]

    return postgis_version


def get_sql(sql, log_sql=False, params=None):
    """ Generate SQL with params. Useful for debugging """

    if params:
        sql = global_vars.dao.mogrify(sql, params)
    if log_sql:
        tools_log.log_info(sql, stack_level_increase=2)

    return sql


def get_row( sql, log_info=True, log_sql=False, commit=True, params=None):
    """ Execute SQL. Check its result in log tables, and show it to the user """

    sql = get_sql(sql, log_sql, params)
    row = global_vars.dao.get_row(sql, commit)
    global_vars.last_error = global_vars.dao.last_error
    if not row:
        # Check if any error has been raised
        if global_vars.last_error:
            manage_exception_db(global_vars.last_error, sql)
        elif global_vars.last_error is None and log_info:
            tools_log.log_info("Any record found", parameter=sql, stack_level_increase=1)

    return row


def get_rows( sql, log_info=True, log_sql=False, commit=True, params=None, add_empty_row=False):
    """ Execute SQL. Check its result in log tables, and show it to the user """

    sql = get_sql(sql, log_sql, params)
    rows = None
    rows2 = global_vars.dao.get_rows(sql, commit)
    global_vars.last_error = global_vars.dao.last_error
    if not rows2:
        # Check if any error has been raised
        if global_vars.last_error:
            manage_exception_db(global_vars.last_error, sql)
        elif global_vars.last_error is None and log_info:
            tools_log.log_info("Any record found", parameter=sql, stack_level_increase=1)
    else:
        if add_empty_row:
            rows = [('', '')]
            rows.extend(rows2)
        else:
            rows = rows2

    return rows


def execute_sql(sql, log_sql=False, log_error=False, commit=True, filepath=None):
    """ Execute SQL. Check its result in log tables, and show it to the user """

    if log_sql:
        tools_log.log_info(sql, stack_level_increase=1)
    result = global_vars.dao.execute_sql(sql, commit)
    global_vars.last_error = global_vars.dao.last_error
    if not result:
        if log_error:
            tools_log.log_info(sql, stack_level_increase=1)
        manage_exception_db(global_vars.last_error, sql, filepath=filepath)
        return False

    return True


def execute_returning(sql, log_sql=False, log_error=False, commit=True):
    """ Execute SQL. Check its result in log tables, and show it to the user """

    if log_sql:
        tools_log.log_info(sql, stack_level_increase=1)
    value = global_vars.dao.execute_returning(sql, commit)
    global_vars.last_error = global_vars.dao.last_error
    if not value:
        if log_error:
            tools_log.log_info(sql, stack_level_increase=1)
        manage_exception_db(global_vars.last_error, sql)
        return False

    return value


def set_search_path(schema_name):
    """ Set parameter search_path for current QGIS project """

    sql = f"SET search_path = {schema_name}, public;"
    execute_sql(sql)
    global_vars.dao.set_search_path = sql
>>>>>>> Stashed changes
