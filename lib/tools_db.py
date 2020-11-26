"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import inspect

from .. import global_vars
from ..core.utils import tools_gw
from . import tools_os, tools_log


def make_list_for_completer(sql):
    """ Prepare a list with the necessary items for the completer
    :param sql: Query to be executed, where will we get the list of items (string)
    :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
    """

    rows = global_vars.controller.get_rows(sql)
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
    row = global_vars.controller.get_row(sql, log_info=False, params=params)
    return row


def check_view(viewname, schemaname=None):
    """ Check if selected view exists in selected schema """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    sql = ("SELECT * FROM pg_views "
           "WHERE schemaname = %s AND viewname = %s ")
    params = [schemaname, viewname]
    row = global_vars.controller.get_row(sql, log_info=False, params=params)
    return row


def check_column(tablename, columname, schemaname=None):
    """ Check if @columname exists table @schemaname.@tablename """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    sql = ("SELECT * FROM information_schema.columns "
           "WHERE table_schema = %s AND table_name = %s AND column_name = %s")
    params = [schemaname, tablename, columname]
    row = global_vars.controller.get_row(sql, log_info=False, params=params)
    return row


def check_role(role_name):
    """ Check if @role_name exists """

    sql = f"SELECT * FROM pg_roles WHERE rolname = '{role_name}'"
    row = global_vars.controller.get_row(sql, log_info=False)
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
    row = global_vars.controller.get_row(sql)
    if row:
        return row[0]
    else:
        return False


def get_current_user():
    """ Get current user connected to database """

    if global_vars.current_user:
        return global_vars.current_user

    sql = "SELECT current_user"
    row = global_vars.controller.get_row(sql)
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
    column_names = global_vars.controller.get_rows(sql, params=params)
    return column_names


def get_srid(tablename, schemaname=None):
    """ Find SRID of selected schema """

    if schemaname is None:
        schemaname = global_vars.schema_name

    schemaname = schemaname.replace('"', '')
    srid = None
    sql = "SELECT Find_SRID(%s, %s, 'the_geom');"
    params = [schemaname, tablename]
    row = global_vars.controller.get_row(sql, params=params)
    if row:
        srid = row[0]

    return srid


