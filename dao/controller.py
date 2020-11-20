"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import inspect
import os

from qgis.PyQt.QtCore import QCoreApplication, QRegExp, QSettings, Qt, QTranslator
from qgis.PyQt.QtGui import QTextCharFormat, QFont, QColor
from qgis.PyQt.QtSql import QSqlDatabase
from qgis.core import QgsMessageLog, QgsCredentials, QgsProject, QgsDataSourceUri, QgsVectorLayer, QgsPointLocator, \
    QgsSnappingConfig, QgsRectangle

from .. import global_vars
from ..core.ui.ui_manager import DockerUi
from ..core.utils import tools_gw
from ..lib import tools_os, tools_qgis, tools_config, tools_log
from ..lib.tools_pgdao import PgDao


class DaoController:

    def __init__(self, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """

        self.settings = global_vars.settings
        self.plugin_name = plugin_name
        self.iface = iface
        self.translator = None
        self.plugin_dir = None
        self.logged = False
        self.postgresql_version = None
        self.logger = None
        self.schema_name = None
        self.dao = None
        self.credentials = None
        self.current_user = None
        self.last_error = None
        self.dlg_docker = None
        self.docker_type = None
        self.show_docker = None
        self.prev_maptool = None
        self.gw_infotools = None
        self.dlg_info = None
        self.show_db_exception = True
        self.is_inserting = False

        if create_logger:
            tools_log.set_logger(self, logger_name)


    def close_db(self):
        """ Close database connection """

        if self.dao:
            if not self.dao.close_db():
                tools_log.log_info(str(self.last_error))
            del self.dao

        self.current_user = None


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
        self.last_error = None
        self.logged = False
        self.current_user = None

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
            self.last_error = tools_gw.tr(message)
            return False

        # Update current user
        global_vars.user = user
        self.current_user = user

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL", self.plugin_name)
        self.db.setHostName(host)
        if port != '':
            self.db.setPort(int(port))
        self.db.setDatabaseName(db)
        self.db.setUserName(user)
        self.db.setPassword(pwd)
        status = self.db.open()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            self.last_error = tools_gw.tr(message)
            details = self.db.lastError().databaseText()
            tools_log.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_params(host, port, db, user, pwd, sslmode)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            self.last_error = tools_gw.tr(message)
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
        self.db = QSqlDatabase.addDatabase("QPSQL", self.plugin_name)
        self.db.setConnectOptions(conn_string)
        status = self.db.open()
        if not status:
            message = "Database connection error (QSqlDatabase). Please open plugin log file to get more details"
            self.last_error = tools_gw.tr(message)
            details = self.db.lastError().databaseText()
            tools_log.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_conn_string(conn_string)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error (PgDao). Please open plugin log file to get more details"
            self.last_error = tools_gw.tr(message)
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


    def get_conn_encoding(self):
        return self.dao.get_conn_encoding()


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
        self.last_error = self.dao.last_error
        if not row:
            # Check if any error has been raised
            if self.last_error:
                self.manage_exception_db(self.last_error, sql)
            elif self.last_error is None and log_info:
                tools_log.log_info("Any record found", parameter=sql, stack_level_increase=1)

        return row


    def get_rows(self, sql, log_info=True, log_sql=False, commit=True, params=None, add_empty_row=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        sql = self.get_sql(sql, log_sql, params)
        rows = None
        rows2 = self.dao.get_rows(sql, commit)
        self.last_error = self.dao.last_error
        if not rows2:
            # Check if any error has been raised
            if self.last_error:
                self.manage_exception_db(self.last_error, sql)
            elif self.last_error is None and log_info:
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
        self.last_error = self.dao.last_error
        if not result:
            if log_error:
                tools_log.log_info(sql, stack_level_increase=1)
            self.manage_exception_db(self.last_error, sql, filepath=filepath)
            return False

        return True


    def execute_returning(self, sql, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            tools_log.log_info(sql, stack_level_increase=1)
        value = self.dao.execute_returning(sql, commit)
        self.last_error = self.dao.last_error
        if not value:
            if log_error:
                tools_log.log_info(sql, stack_level_increase=1)
            self.manage_exception_db(self.last_error, sql)
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
        self.last_error = self.dao.last_error
        if not result:
            # Check if any error has been raised
            if self.last_error:
                self.manage_exception_db(self.last_error, sql)

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
        self.last_error = self.dao.last_error
        if not result:
            # Check if any error has been raised
            if self.last_error:
                self.manage_exception_db(self.last_error, sql)

        return result


    def get_layer_by_tablename(self, tablename, show_warning=False, log_info=False, schema_name=None):
        """ Iterate over all layers and get the one with selected @tablename """

        return tools_qgis.qgis_get_layer_by_tablename(tablename, show_warning, log_info, schema_name)


    def get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        return tools_qgis.qgis_get_layer_source(layer)


    def get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        return tools_qgis.qgis_get_layer_source_table_name(layer)


    def get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """

        return tools_qgis.qgis_get_layer_primary_key(layer)


    def add_translator(self, locale_path, log_info=False):
        """ Add translation file to the list of translation files to be used for translations """

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)
            if log_info:
                tools_log.log_info("Add translator", parameter=locale_path)
        else:
            if log_info:
                tools_log.log_info("Locale not found", parameter=locale_path)


    def manage_translation(self, context_name, dialog=None, log_info=False):
        """ Manage locale and corresponding 'i18n' file """

        # Get locale of QGIS application
        try:
            locale = QSettings().value('locale/userLocale').lower()
        except AttributeError:
            locale = "en"

        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'

        # If user locale file not found, set English one by default
        locale_path = os.path.join(self.plugin_dir, 'i18n', f'giswater_{locale}.qm')
        if not os.path.exists(locale_path):
            if log_info:
                tools_log.log_info("Locale not found", parameter=locale_path)
            locale_default = 'en'
            locale_path = os.path.join(self.plugin_dir, 'i18n', f'giswater_{locale_default}.qm')
            # If English locale file not found, exit function
            # It means that probably that form has not been translated yet
            if not os.path.exists(locale_path):
                if log_info:
                    tools_log.log_info("Locale not found", parameter=locale_path)
                return

        # Add translation file
        self.add_translator(locale_path)

        # If dialog is set, then translate form
        if dialog:
            tools_gw.translate_form(dialog, context_name)


    def get_project_type(self, schemaname=None):
        """ Get project type from table 'version' """

        # init variables
        project_type = None
        if schemaname is None:
            schemaname = self.schema_name

        # start process
        tablename = "sys_version"
        exists = self.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT lower(project_type) FROM " + schemaname + "." + tablename + " ORDER BY id ASC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_type = row[0]
        else:
            tablename = "version"
            exists = self.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT lower(wsoftware) FROM " + schemaname + "." + tablename + " ORDER BY id ASC LIMIT 1")
                row = self.get_row(sql)
                if row:
                    project_type = row[0]
            else:
                tablename = "version_tm"
                exists = self.check_table(tablename, schemaname)
                if exists:
                    project_type = "tm"

        return project_type


    def get_project_version(self, schemaname=None):
        """ Get project version from table 'version' """

        if schemaname is None:
            schemaname = self.schema_name

        project_version = None
        tablename = "sys_version"
        exists = self.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT giswater FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_version = row[0]
        else:
            tablename = "version"
            exists = self.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT giswater FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = self.get_row(sql)
                if row:
                    project_version = row[0]

        return project_version


    def get_project_language(self, schemaname=None):
        """ Get project langugage from table 'version' """

        if schemaname is None:
            schemaname = self.schema_name

        project_language = None
        tablename = "sys_version"
        exists = self.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT language FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_language = row[0]
        else:
            tablename = "version"
            exists = self.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT language FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = self.get_row(sql)
                if row:
                    project_language = row[0]

        return project_language


    def get_project_epsg(self, schemaname=None):
        """ Get project epsg from table 'version' """

        if schemaname is None:
            schemaname = self.schema_name

        project_epsg = None
        tablename = "sys_version"
        exists = self.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT epsg FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_epsg = row[0]
        else:
            tablename = "version"
            exists = self.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT epsg FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = self.get_row(sql)
                if row:
                    project_epsg = row[0]

        return project_epsg


    def get_project_sample(self, schemaname=None):
        """ Get if project is sample from table 'version' """

        if schemaname is None:
            schemaname = self.schema_name

        project_sample = None
        tablename = "sys_version"
        exists = self.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT sample FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_sample = row[0]
        else:
            tablename = "version"
            exists = self.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT language FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = self.get_row(sql)
                if row:
                    project_sample = row[0]

        return project_sample


    def check_schema(self, schemaname=None):
        """ Check if selected schema exists """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = "SELECT nspname FROM pg_namespace WHERE nspname = %s"
        params = [schemaname]
        row = self.get_row(sql, params=params)
        return row


    def check_table(self, tablename, schemaname=None):
        """ Check if selected table exists in selected schema """

        if schemaname is None:
            schemaname = self.schema_name
            if schemaname is None:
                tools_gw.get_layer_source_from_credentials()
                schemaname = self.schema_name
                if schemaname is None:
                    return None

        schemaname = schemaname.replace('"', '')
        sql = "SELECT * FROM pg_tables WHERE schemaname = %s AND tablename = %s"
        params = [schemaname, tablename]
        row = self.get_row(sql, log_info=False, params=params)
        return row


    def check_view(self, viewname, schemaname=None):
        """ Check if selected view exists in selected schema """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT * FROM pg_views "
               "WHERE schemaname = %s AND viewname = %s ")
        params = [schemaname, viewname]
        row = self.get_row(sql, log_info=False, params=params)
        return row


    def check_column(self, tablename, columname, schemaname=None):
        """ Check if @columname exists table @schemaname.@tablename """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT * FROM information_schema.columns "
               "WHERE table_schema = %s AND table_name = %s AND column_name = %s")
        params = [schemaname, tablename, columname]
        row = self.get_row(sql, log_info=False, params=params)
        return row


    def get_group_layers(self, geom_type):
        """ Get layers of the group @geom_type """

        list_items = []
        sql = ("SELECT child_layer "
               "FROM cat_feature "
               "WHERE upper(feature_type) = '" + geom_type.upper() + "' "
               "UNION SELECT DISTINCT parent_layer "
               "FROM cat_feature "
               "WHERE upper(feature_type) = '" + geom_type.upper() + "';")
        rows = self.get_rows(sql)
        if rows:
            for row in rows:
                layer = self.get_layer_by_tablename(row[0])
                if layer:
                    list_items.append(layer)

        return list_items


    def check_role(self, role_name):
        """ Check if @role_name exists """

        sql = f"SELECT * FROM pg_roles WHERE rolname = '{role_name}'"
        row = self.get_row(sql, log_info=False)
        return row


    def check_role_user(self, role_name, username=None):
        """ Check if current user belongs to @role_name """

        # Check both @role_name and @username exists
        if not self.check_role(role_name):
            return False

        if username is None:
            username = global_vars.user

        if not self.check_role(username):
            return False

        sql = ("SELECT pg_has_role('" + username + "', '" + role_name + "', 'MEMBER');")
        row = self.get_row(sql)
        if row:
            return row[0]
        else:
            return False


    def get_current_user(self):
        """ Get current user connected to database """

        if self.current_user:
            return self.current_user

        sql = "SELECT current_user"
        row = self.get_row(sql)
        cur_user = ""
        if row:
            cur_user = str(row[0])
        self.current_user = cur_user
        return cur_user


    def get_rolenames(self):
        """ Get list of rolenames of current user """

        super_users = self.settings.value('system_variables/super_users')
        if global_vars.user in super_users:
            roles = "('role_admin', 'role_basic', 'role_edit', 'role_epa', 'role_master', 'role_om')"
        else:
            sql = ("SELECT rolname FROM pg_roles "
                   " WHERE pg_has_role(current_user, oid, 'member')")
            rows = self.get_rows(sql)
            if not rows:
                return None

            roles = "("
            for i in range(0, len(rows)):
                roles += "'" + str(rows[i][0]) + "', "
            roles = roles[:-2]
            roles += ")"

        return roles


    def get_columns_list(self, tablename, schemaname=None):
        """ Return list of all columns in @tablename """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT column_name FROM information_schema.columns "
               "WHERE table_schema = %s AND table_name = %s "
               "ORDER BY ordinal_position")
        params = [schemaname, tablename]
        column_names = self.get_rows(sql, params=params)
        return column_names


    def get_srid(self, tablename, schemaname=None):
        """ Find SRID of selected schema """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        srid = None
        sql = "SELECT Find_SRID(%s, %s, 'the_geom');"
        params = [schemaname, tablename]
        row = self.get_row(sql, params=params)
        if row:
            srid = row[0]

        return srid


    def get_log_folder(self):
        """ Return log folder """
        return self.logger.log_folder



    """  Functions related with Qgis versions """

    def is_layer_visible(self, layer):
        """ Is layer visible """

        visible = False
        if layer:
            visible = QgsProject.instance().layerTreeRoot().findLayer(layer.id()).itemVisibilityChecked()

        return visible


    def set_layer_visible(self, layer, recursive=True, visible=True):
        """ Set layer visible """

        if layer:
            if recursive:
                QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityCheckedParentRecursive(visible)
            else:
                QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(visible)


    def get_layers(self):
        """ Return layers in the same order as listed in TOC """

        return tools_qgis.qgis_get_layers()


    def set_search_path(self, schema_name):
        """ Set parameter search_path for current QGIS project """

        sql = f"SET search_path = {schema_name}, public;"
        self.execute_sql(sql)
        self.dao.set_search_path = sql


    def set_path_from_qfiledialog(self, qtextedit, path):

        if path[0]:
            qtextedit.setText(path[0])


    def get_restriction(self, qgis_project_role):

        role_edit = False
        role_om = False
        role_epa = False
        role_basic = False

        role_master = self.check_role_user("role_master")
        if not role_master:
            role_epa = self.check_role_user("role_epa")
            if not role_epa:
                role_edit = self.check_role_user("role_edit")
                if not role_edit:
                    role_om = self.check_role_user("role_om")
                    if not role_om:
                        role_basic = self.check_role_user("role_basic")
        super_users = self.settings.value('system_variables/super_users')

        # Manage user 'postgres'
        if global_vars.user == 'postgres' or global_vars.user == 'gisadmin':
            role_master = True

        # Manage super_user
        if super_users is not None:
            if global_vars.user in super_users:
                role_master = True

        if role_basic or qgis_project_role == 'role_basic':
            return 'role_basic'
        elif role_om or qgis_project_role == 'role_om':
            return 'role_om'
        elif role_edit or qgis_project_role == 'role_edit':
            return 'role_edit'
        elif role_epa or qgis_project_role == 'role_epa':
            return 'role_epa'
        elif role_master or qgis_project_role == 'role_master':
            return 'role_master'
        else:
            return 'role_basic'


    def get_values_from_dictionary(self, dictionary):
        """ Return values from @dictionary """

        list_values = iter(dictionary.values())
        return list_values


    def check_python_function(self, object_, function_name):

        object_functions = [method_name for method_name in dir(object_) if callable(getattr(object_, method_name))]
        return function_name in object_functions


    def get_config(self, parameter='', columns='value', table='config_param_user', sql_added=None, log_info=True):

        sql = f"SELECT {columns} FROM {table} WHERE parameter = '{parameter}' "
        if sql_added:
            sql += sql_added
        if table == 'config_param_user':
            sql += " AND cur_user = current_user"
        sql += ";"
        row = self.get_row(sql, log_info=log_info)
        return row


    def set_layer_index(self, layer_name):
        """ Force reload dataProvider of layer """

        layer = self.get_layer_by_tablename(layer_name)
        if layer:
            layer.dataProvider().forceReload()
            layer.triggerRepaint()



    def manage_exception_db(self, exception=None, sql=None, stack_level=2, stack_level_increase=0, filepath=None):
        """ Manage exception in database queries and show information to the user """

        show_exception_msg = True
        description = ""
        if exception:
            description = str(exception)
            if 'unknown error' in description:
                show_exception_msg = False

        try:
            stack_level += stack_level_increase
            module_path = inspect.stack()[stack_level][1]
            file_name = tools_os.get_relative_path(module_path, 2)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]

            # Set exception message details
            msg = ""
            msg += f"File name: {file_name}\n"
            msg += f"Function name: {function_name}\n"
            msg += f"Line number: {function_line}\n"
            if exception:
                msg += f"Description:\n{description}\n"
            if filepath:
                msg += f"SQL file:\n{filepath}\n\n"
            if sql:
                msg += f"SQL:\n {sql}\n\n"
            msg += f"Schema name: {self.schema_name}"

            # Show exception message in dialog and log it
            if show_exception_msg:
                title = "Database error"
                tools_gw.show_exceptions_msg(title, msg)
            else:
                tools_log.log_warning("Exception message not shown to user")
            tools_log.log_warning(msg, stack_level_increase=2)

        except Exception:
            tools_gw.manage_exception("Unhandled Error")


    def set_text_bold(self, widget, pattern=None):
        """ Set bold text when word match with pattern
        :param widget: QTextEdit
        :param pattern: Text to find used as pattern for QRegExp (String)
        :return:
        """

        if not pattern:
            pattern = "File\sname:|Function\sname:|Line\snumber:|SQL:|SQL\sfile:|Detail:|Context:|Description|Schema name"
        cursor = widget.textCursor()
        format = QTextCharFormat()
        format.setFontWeight(QFont.Bold)
        regex = QRegExp(pattern)
        pos = 0
        index = regex.indexIn(widget.toPlainText(), pos)
        while index != -1:
            # Set cursor at begin of match
            cursor.setPosition(index, 0)
            pos = index + regex.matchedLength()
            # Set cursor at end of match
            cursor.setPosition(pos, 1)
            # Select the matched text and apply the desired format
            cursor.mergeCharFormat(format)
            # Move to the next match
            index = regex.indexIn(widget.toPlainText(), pos)


    def show_dlg_info(self):
        """ Show dialog with exception message generated in function show_exceptions_msg """

        if self.dlg_info:
            self.dlg_info.show()


    def dock_dialog(self, dialog):

        positions = {8: Qt.BottomDockWidgetArea, 4: Qt.TopDockWidgetArea,
                     2: Qt.RightDockWidgetArea, 1: Qt.LeftDockWidgetArea}
        try:
            self.dlg_docker.setWindowTitle(dialog.windowTitle())
            self.dlg_docker.setWidget(dialog)
            self.dlg_docker.setWindowFlags(Qt.WindowContextHelpButtonHint)
            self.iface.addDockWidget(positions[self.dlg_docker.position], self.dlg_docker)
        except RuntimeError as e:
            tools_log.log_warning(f"{type(e).__name__} --> {e}")


    def init_docker(self, docker_param='qgis_info_docker'):
        """ Get user config parameter @docker_param """

        self.show_docker = True
        if docker_param == 'qgis_main_docker':
            # Show 'main dialog' in docker depending its value in user settings
            self.qgis_main_docker = tools_config.get_user_setting_value(docker_param, 'true')
            value = self.qgis_main_docker.lower()
        else:
            # Show info or form in docker?
            row = self.get_config(docker_param)
            if not row:
                self.dlg_docker = None
                self.docker_type = None
                return None
            value = row[0].lower()

        # Check if docker has dialog of type 'form' or 'main'
        if docker_param == 'qgis_info_docker':
            if self.dlg_docker:
                if self.docker_type:
                    if self.docker_type != 'qgis_info_docker':
                        self.show_docker = False
                        return None

        if value == 'true':
            self.close_docker()
            self.docker_type = docker_param
            self.dlg_docker = DockerUi()
            self.dlg_docker.dlg_closed.connect(self.close_docker)
            self.manage_docker_options()
        else:
            self.dlg_docker = None
            self.docker_type = None

        return self.dlg_docker


    def close_docker(self):
        """ Save QDockWidget position (1=Left, 2=Right, 4=Top, 8=Bottom),
            remove from iface and del class
        """
        try:
            if self.dlg_docker:
                if not self.dlg_docker.isFloating():
                    docker_pos = self.iface.mainWindow().dockWidgetArea(self.dlg_docker)
                    widget = self.dlg_docker.widget()
                    if widget:
                        widget.close()
                        del widget
                        self.dlg_docker.setWidget(None)
                        self.docker_type = None
                        tools_gw.set_parser_value('docker_info', 'position', f'{docker_pos}')
                    self.iface.removeDockWidget(self.dlg_docker)
                    self.dlg_docker = None
        except AttributeError:
            self.docker_type = None
            self.dlg_docker = None


    def manage_docker_options(self):
        """ Check if user want dock the dialog or not """

        # Load last docker position
        try:
            # Docker positions: 1=Left, 2=Right, 4=Top, 8=Bottom
            pos = int(tools_gw.get_parser_value('docker_info', 'position'))
            self.dlg_docker.position = 2
            if pos in (1, 2, 4, 8):
                self.dlg_docker.position = pos
        except:
            self.dlg_docker.position = 2


    def layer_manager(self, json_result):
        """
        Manage options for layers (active, visible, zoom and indexing)
        :param json_result: Json result of a query (Json)
        :return: None
        """

        try:
            layermanager = json_result['body']['form']['layerManager']
        except KeyError:
            return
        # Get a list of layers names force reload dataProvider of layer
        if 'index' in layermanager:
            for layer_name in layermanager['index']:
                self.set_layer_index(layer_name)
                layer = self.get_layer_by_tablename(layer_name)

        # Get a list of layers names, but obviously it will stay active the last one
        if 'active' in layermanager:
            for layer_name in layermanager['active']:
                layer = self.get_layer_by_tablename(layer_name)
                if layer:
                    self.iface.setActiveLayer(layer)

        # Get a list of layers names and set visible
        if 'visible' in layermanager:
            for layer_name in layermanager['visible']:
                layer = self.get_layer_by_tablename(layer_name)
                if layer:
                    self.set_layer_visible(layer)

        # Get a list of layers names, but obviously remain zoomed to the last
        if 'zoom' in layermanager:
            for layer_name in layermanager['zoom']:
                layer = self.get_layer_by_tablename(layer_name)
                if layer:
                    prev_layer = self.iface.activeLayer()
                    self.iface.setActiveLayer(layer)
                    self.iface.zoomToActiveLayer()
                    if prev_layer:
                        self.iface.setActiveLayer(prev_layer)
