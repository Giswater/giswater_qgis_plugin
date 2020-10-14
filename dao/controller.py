"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsMessageLog, QgsCredentials, QgsProject, QgsDataSourceUri, QgsVectorLayer, QgsPointLocator, \
    QgsSnappingConfig, QgsRectangle
from qgis.PyQt.QtCore import QCoreApplication, QRegExp, QSettings, Qt, QTranslator
from qgis.PyQt.QtGui import QTextCharFormat, QFont, QColor
from qgis.PyQt.QtSql import QSqlDatabase
from qgis.PyQt.QtWidgets import QCheckBox, QGroupBox, QLabel, QMessageBox, QPushButton, QRadioButton, QTabWidget, \
    QToolBox

import configparser
import json
import os
from collections import OrderedDict
from functools import partial
import inspect
import traceback
import sys

from .. import global_vars
from .pg_dao import PgDao
from .logger import Logger
from ..lib import tools_os, tools_qt
from ..core.ui.ui_manager import DialogTextUi, DockerUi
from ..lib.tools_qgis import qgis_get_layer_by_tablename, qgis_get_layer_source, qgis_get_layer_source_table_name, \
    qgis_get_layer_primary_key, qgis_get_layers, resetRubberbands, snap_to_layer, get_snapping_options, \
    set_snapping_mode
from ..core.utils.tools_giswater import get_parser_value, set_parser_value, manage_actions, draw, create_body
from ..core.utils.layer_tools import delete_layer_from_toc, populate_vlayer, categoryze_layer, create_qml, \
    from_postgres_to_toc


class DaoController:

    def __init__(self, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """

        self.settings = global_vars.settings
        self.qgis_settings = global_vars.qgis_settings
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
        self.min_log_level = 20
        self.min_message_level = 0
        self.last_error = None
        self.user = None
        self.user_settings = None
        self.user_settings_path = None
        self.dlg_docker = None
        self.docker_type = None
        self.show_docker = None
        self.prev_maptool = None
        self.gw_infotools = None

        if create_logger:
            self.set_logger(logger_name)


    def close_db(self):
        """ Close database connection """

        if self.dao:
            if not self.dao.close_db():
                self.log_info(str(self.last_error))
            del self.dao

        self.current_user = None


    def set_schema_name(self, schema_name):
        self.schema_name = schema_name


    def set_plugin_dir(self, plugin_dir):
        self.plugin_dir = plugin_dir
        self.log_info(f"Plugin folder: {self.plugin_dir}")


    def set_logger(self, logger_name=None):
        """ Set logger class """

        if self.logger is None:
            if logger_name is None:
                logger_name = 'plugin'

            self.min_log_level = int(self.settings.value('status/log_level'))
            log_suffix = self.settings.value('status/log_suffix')
            self.logger = Logger(self, logger_name, self.min_log_level, log_suffix)

            if self.min_log_level == 10:
                self.min_message_level = 0
            elif self.min_log_level == 20:
                self.min_message_level = 0
            elif self.min_log_level == 30:
                self.min_message_level = 1
            elif self.min_log_level == 40:
                self.min_message_level = 2


    def close_logger(self):
        """ Close logger file """

        if self.logger:
            self.logger.close_logger()
            del self.logger


    def tr(self, message, context_name=None):
        """ Translate @message looking it in @context_name """

        if context_name is None:
            context_name = self.plugin_name

        value = None
        try:
            value = QCoreApplication.translate(context_name, message)
        except TypeError:
            value = QCoreApplication.translate(context_name, str(message))
        finally:
            # If not translation has been found, check into 'ui_message' context
            if value == message:
                value = QCoreApplication.translate('ui_message', message)

        return value


    def plugin_settings_value(self, key, default_value=""):

        key = self.plugin_name + "/" + key
        value = self.qgis_settings.value(key, default_value)
        return value


    def plugin_settings_set_value(self, key, value):
        self.qgis_settings.setValue(self.plugin_name + "/" + key, value)


    def set_database_connection(self):
        """ Set database connection """

        # Initialize variables
        self.dao = None
        self.last_error = None
        self.logged = False
        self.current_user = None

        self.layer_source, not_version = self.get_layer_source_from_credentials()
        if self.layer_source:
            if self.layer_source['service'] is None and (self.layer_source['db'] is None
                    or self.layer_source['host'] is None or self.layer_source['user'] is None
                    or self.layer_source['password'] is None or self.layer_source['port'] is None):
                return False, not_version
        else:
            return False, not_version

        self.logged = True

        return True, not_version


    def check_user_settings(self, parameter, value=None, section='system'):
        """ Check if @section and @parameter exists in user settings file. If not add them with @value """

        # Check if @section exists
        if not self.user_settings.has_section(section):
            self.user_settings.add_section(section)
            self.user_settings.set(section, parameter, value)
            self.save_user_settings()

        # Check if @parameter exists
        if not self.user_settings.has_option(section, parameter):
            self.user_settings.set(section, parameter, value)
            self.save_user_settings()


    def get_user_setting_value(self, parameter, default_value=None, section='system'):
        """ Get value from user settings file of selected @parameter located in @section """

        value = default_value
        if self.user_settings is None:
            return value

        self.check_user_settings(parameter, value)
        value = self.user_settings.get(section, parameter).lower()

        return value


    def set_user_settings_value(self, parameter, value, section='system'):
        """ Set @value from user settings file of selected @parameter located in @section """

        if self.user_settings is None:
            return value

        self.check_user_settings(parameter, value)
        self.user_settings.set(section, parameter, value)
        self.save_user_settings()


    def save_user_settings(self):
        """ Save user settings file """

        try:
            with open(self.user_settings_path, 'w') as configfile:
                self.user_settings.write(configfile)
                configfile.close()
        except Exception as e:
            self.log_warning(str(e))


    def manage_user_config_file(self):
        """ Manage user configuration file """

        if self.user_settings:
            return

        self.user_settings = configparser.ConfigParser(comment_prefixes='/', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), self.plugin_name)
        config_folder = main_folder + os.sep + "config" + os.sep
        self.user_settings_path = config_folder + 'user.config'
        if not os.path.exists(self.user_settings_path):
            self.log_info(f"File not found: {self.user_settings_path}")
            self.save_user_settings()
        else:
            self.log_info(f"User settings file: {self.user_settings_path}")

        # Open file
        self.user_settings.read(self.user_settings_path)


    def get_layer_source_from_credentials(self):
        """ Get database parameters from layer 'v_edit_node' or  database connection settings """

        # Get layer 'v_edit_node'
        layer = self.get_layer_by_tablename("v_edit_node")

        # Get database connection settings
        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")

        if layer is None and settings is None:
            not_version = False
            self.log_warning("Layer 'v_edit_node' is None and settings is None")
            self.last_error = self.tr("Layer not found") + ": 'v_edit_node'"
            return None, not_version

        # Get sslmode from user config file
        self.manage_user_config_file()
        sslmode = self.get_user_setting_value('sslmode', 'disable')
        # self.log_info(f"sslmode user config file: {sslmode}")

        credentials = None
        not_version = True
        if layer:
            not_version = False
            credentials = self.get_layer_source(layer)
            credentials['sslmode'] = sslmode
            self.schema_name = credentials['schema']
            conn_info = QgsDataSourceUri(layer.dataProvider().dataSourceUri()).connectionInfo()
            status, credentials = self.connect_to_database_credentials(credentials, conn_info)
            if not status:
                self.log_warning("Error connecting to database (layer)")
                self.last_error = self.tr("Error connecting to database")
                return None, not_version

            # Put the credentials back (for yourself and the provider), as QGIS removes it when you "get" it
            QgsCredentials.instance().put(conn_info, credentials['user'], credentials['password'])

        elif settings:
            not_version = True
            default_connection = settings.value('selected')
            settings.endGroup()
            credentials = {'db': None, 'schema': None, 'table': None, 'service': None,
                           'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}
            if default_connection:
                settings.beginGroup("PostgreSQL/connections/" + default_connection)
                if settings.value('host') in (None, ""):
                    credentials['host'] = 'localhost'
                else:
                    credentials['host'] = settings.value('host')
                credentials['port'] = settings.value('port')
                credentials['db'] = settings.value('database')
                credentials['user'] = settings.value('username')
                credentials['password'] = settings.value('password')
                credentials['sslmode'] = sslmode
                settings.endGroup()
                status, credentials = self.connect_to_database_credentials(credentials, max_attempts=0)
                if not status:
                    self.log_warning("Error connecting to database (settings)")
                    self.last_error = self.tr("Error connecting to database")
                    return None, not_version
            else:
                self.log_warning("Error getting default connection (settings)")
                self.last_error = self.tr("Error getting default connection")
                return None, not_version

        self.credentials = credentials

        return credentials, not_version


    def connect_to_database_credentials(self, credentials, conn_info=None, max_attempts=2):
        """ Connect to database with selected database @credentials """

        # Check if credential parameter 'service' is set
        if 'service' in credentials and credentials['service']:
            logged = self.connect_to_database_service(credentials['service'], credentials['sslmode'])
            return logged, credentials

        attempt = 0
        logged = False
        while not logged and attempt <= max_attempts:
            attempt += 1
            if conn_info and attempt > 1:
                (success, credentials['user'], credentials['password']) = \
                    QgsCredentials.instance().get(conn_info, credentials['user'], credentials['password'])
            logged = self.connect_to_database(credentials['host'], credentials['port'], credentials['db'],
                credentials['user'], credentials['password'], credentials['sslmode'])

        return logged, credentials


    def connect_to_database(self, host, port, db, user, pwd, sslmode):
        """ Connect to database with selected parameters """

        # self.log_info(f"connect_to_database - sslmode: {sslmode}")

        # Check if selected parameters is correct
        if None in (host, port, db, user, pwd):
            message = "Database connection error. Please check your connection parameters."
            self.last_error = self.tr(message)
            return False

        # Update current user
        self.user = user
        self.current_user = user

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL")
        self.db.setHostName(host)
        if port != '':
            self.db.setPort(int(port))
        self.db.setDatabaseName(db)
        self.db.setUserName(user)
        self.db.setPassword(pwd)
        status = self.db.open()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            self.last_error = self.tr(message)
            details = self.db.lastError().databaseText()
            self.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_params(host, port, db, user, pwd, sslmode)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error. Please open plugin log file to get more details"
            self.last_error = self.tr(message)
            self.log_warning(str(self.dao.last_error))
            return False

        return status


    def connect_to_database_service(self, service, sslmode=None):
        """ Connect to database trough selected service
        This service must exist in file pg_service.conf """

        conn_string = f"service={service}"
        if sslmode:
            conn_string += f" sslmode={sslmode}"

        self.log_info(f"connect_to_database_service: {conn_string}")

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL")
        self.db.setConnectOptions(conn_string)
        status = self.db.open()
        if not status:
            message = "Database connection error (QSqlDatabase). Please open plugin log file to get more details"
            self.last_error = self.tr(message)
            details = self.db.lastError().databaseText()
            self.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_conn_string(conn_string)
        status = self.dao.init_db()
        if not status:
            message = "Database connection error (PgDao). Please open plugin log file to get more details"
            self.last_error = self.tr(message)
            self.log_warning(str(self.dao.last_error))
            return False

        return status


    def check_db_connection(self):
        """ Check database connection. Reconnect if needed """

        opened = True
        try:
            opened = self.db.isOpen()
            if not opened:
                self.db.open()
        except Exception:
            pass
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


    def show_message(self, text, message_level=1, duration=10, context_name=None, parameter=None, title=""):
        """ Show message to the user with selected message level
        message_level: {INFO = 0(blue), WARNING = 1(yellow), CRITICAL = 2(red), SUCCESS = 3(green)} """

        msg = None
        if text:
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)
        try:
            self.iface.messageBar().pushMessage(title, msg, message_level, duration)
        except AttributeError:
            pass


    def show_info(self, text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
        """ Show information message to the user """

        self.show_message(text, 0, duration, context_name, parameter, title)
        if self.logger and logger_file:
            self.logger.info(text)


    def show_warning(self, text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
        """ Show warning message to the user """

        self.show_message(text, 1, duration, context_name, parameter, title)
        if self.logger and logger_file:
            self.logger.warning(text)


    def show_critical(self, text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
        """ Show warning message to the user """

        self.show_message(text, 2, duration, context_name, parameter, title)
        if self.logger and logger_file:
            self.logger.critical(text)


    def show_warning_detail(self, text, detail_text, context_name=None):
        """ Show warning message with a button to show more details """

        inf_text = "Press 'Show Me' button to get more details..."
        widget = self.iface.messageBar().createMessage(self.tr(text, context_name), self.tr(inf_text))
        button = QPushButton(widget)
        button.setText(self.tr("Show Me"))
        button.clicked.connect(partial(self.show_details, detail_text, self.tr('Warning details')))
        widget.layout().addWidget(button)
        self.iface.messageBar().pushWidget(widget, 1)

        if self.logger:
            self.logger.warning(text + "\n" + detail_text)


    def show_details(self, detail_text, title=None, inf_text=None):
        """ Shows a message box with detail information """

        self.iface.messageBar().clearWidgets()
        msg_box = QMessageBox()
        msg_box.setText(detail_text)
        if title:
            title = self.tr(title)
            msg_box.setWindowTitle(title)
        if inf_text:
            inf_text = self.tr(inf_text)
            msg_box.setInformativeText(inf_text)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)
        msg_box.exec_()


    def show_warning_open_file(self, text, inf_text, file_path, context_name=None):
        """ Show warning message with a button to open @file_path """

        widget = self.iface.messageBar().createMessage(self.tr(text, context_name), self.tr(inf_text))
        button = QPushButton(widget)
        button.setText(self.tr("Open file"))
        button.clicked.connect(partial(tools_os.open_file, file_path))
        widget.layout().addWidget(button)
        self.iface.messageBar().pushWidget(widget, 1)


    def ask_question(self, text, title=None, inf_text=None, context_name=None, parameter=None):
        """ Ask question to the user """

        msg_box = QMessageBox()
        msg = self.tr(text, context_name)
        if parameter:
            msg += ": " + str(parameter)
        msg_box.setText(msg)
        if title:
            title = self.tr(title, context_name)
            msg_box.setWindowTitle(title)
        if inf_text:
            inf_text = self.tr(inf_text, context_name)
            msg_box.setInformativeText(inf_text)
        msg_box.setStandardButtons(QMessageBox.Cancel | QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        ret = msg_box.exec_()
        if ret == QMessageBox.Ok:
            return True
        elif ret == QMessageBox.Discard:
            return False


    def show_info_box(self, text, title=None, inf_text=None, context_name=None, parameter=None):
        """ Show information box to the user """

        msg = ""
        if text:
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)

        msg_box = QMessageBox()
        msg_box.setText(msg)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        if title:
            title = self.tr(title, context_name)
            msg_box.setWindowTitle(title)
        if inf_text:
            inf_text = self.tr(inf_text, context_name)
            msg_box.setInformativeText(inf_text)
        msg_box.setDefaultButton(QMessageBox.No)
        msg_box.exec_()


    def get_conn_encoding(self):
        return self.dao.get_conn_encoding()


    def get_sql(self, sql, log_sql=False, params=None):
        """ Generate SQL with params. Useful for debugging """

        if params:
            sql = self.dao.mogrify(sql, params)
        if log_sql:
            self.log_info(sql, stack_level_increase=2)

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
                self.log_info("Any record found", parameter=sql, stack_level_increase=1)

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
                self.log_info("Any record found", parameter=sql, stack_level_increase=1)
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
            self.log_info(sql, stack_level_increase=1)
        result = self.dao.execute_sql(sql, commit)
        self.last_error = self.dao.last_error
        if not result:
            if log_error:
                self.log_info(sql, stack_level_increase=1)
            self.manage_exception_db(self.last_error, sql, filepath=filepath)
            return False

        return True


    def execute_returning(self, sql, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            self.log_info(sql, stack_level_increase=1)
        value = self.dao.execute_returning(sql, commit)
        self.last_error = self.dao.last_error
        if not value:
            if log_error:
                self.log_info(sql, stack_level_increase=1)
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
        self.log_info(sql, stack_level_increase=1)
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
        self.log_info(sql, stack_level_increase=1)
        result = self.dao.execute_sql(sql, commit)
        self.last_error = self.dao.last_error
        if not result:
            # Check if any error has been raised
            if self.last_error:
                self.manage_exception_db(self.last_error, sql)

        return result


    def get_json(self, function_name, parameters=None, schema_name=None, commit=True, log_sql=False,
                 log_result=False, json_loads=False, is_notify=False, rubber_band=None):
        """ Manage execution API function
        :param function_name: Name of function to call (text)
        :param parameters: Parameters for function (json) or (query parameters)
        :param commit: Commit sql (bool)
        :param log_sql: Show query in qgis log (bool)
        :return: Response of the function executed (json)
        """

        # Check if function exists
        row = self.check_function(function_name, schema_name, commit)
        if not row:
            self.show_warning("Function not found in database", parameter=function_name)
            return None

        # Execute function. If failed, always log it
        if schema_name:
            sql = f"SELECT {schema_name}.{function_name}("
        else:
            sql = f"SELECT {function_name}("
        if parameters:
            sql += f"{parameters}"
        sql += f");"

        row = self.get_row(sql, commit=commit, log_sql=log_sql)
        if not row or not row[0]:
            self.log_warning(f"Function error: {function_name}")
            self.log_warning(sql)
            return None

        # Get json result
        if json_loads:
            # If content of row[0] is not a to json, cast it
            json_result = json.loads(row[0], object_pairs_hook=OrderedDict)
        else:
            json_result = row[0]

        # Log result
        if log_result:
            self.log_info(json_result, stack_level_increase=1)

        # If failed, manage exception
        if 'status' in json_result and json_result['status'] == 'Failed':
            self.manage_exception_api(json_result, sql, is_notify=is_notify)
            return json_result

        try:
            # Layer styles
            self.manage_return_manager(json_result, sql, rubber_band)
            self.manage_layer_manager(json_result, sql)
            manage_actions(json_result, sql)
        except Exception:
            pass

        return json_result


    def translate_tooltip(self, context_name, widget, idx=None):
        """ Translate tooltips widgets of the form to current language
            If we find a translation, it will be put
            If the object does not have a tooltip we will put the object text itself as a tooltip
        """

        if type(widget) is QTabWidget:
            widget_name = widget.widget(idx).objectName()
            tooltip = self.tr(f'tooltip_{widget_name}', context_name)
            if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
                widget.setTabToolTip(idx, tooltip)
            elif widget.toolTip() in ("", None):
                widget.setTabToolTip(idx, widget.tabText(idx))
        else:
            widget_name = widget.objectName()
            tooltip = self.tr(f'tooltip_{widget_name}', context_name)
            if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
                widget.setToolTip(tooltip)
            elif widget.toolTip() in ("", None):
                if type(widget) is QGroupBox:
                    widget.setToolTip(widget.title())
                else:
                    widget.setToolTip(widget.text())


    def translate_form(self, dialog, context_name):
        """ Translate widgets of the form to current language """
        type_widget_list = [QCheckBox, QGroupBox, QLabel, QPushButton, QRadioButton, QTabWidget]
        for widget_type in type_widget_list:
            widget_list = dialog.findChildren(widget_type)
            for widget in widget_list:
                self.translate_widget(context_name, widget)

        # Translate title of the form
        text = self.tr('title', context_name)
        if text != 'title':
            dialog.setWindowTitle(text)


    def translate_widget(self, context_name, widget):
        """ Translate widget text """

        if not widget:
            return

        widget_name = ""
        try:
            if type(widget) is QTabWidget:
                num_tabs = widget.count()
                for i in range(0, num_tabs):
                    widget_name = widget.widget(i).objectName()
                    text = self.tr(widget_name, context_name)
                    if text not in (widget_name, None, 'None'):
                        widget.setTabText(i, text)
                    else:
                        widget_text = widget.tabText(i)
                        text = self.tr(widget_text, context_name)
                        if text != widget_text:
                            widget.setTabText(i, text)
                    self.translate_tooltip(context_name, widget, i)
            elif type(widget) is QToolBox:
                num_tabs = widget.count()
                for i in range(0, num_tabs):
                    widget_name = widget.widget(i).objectName()
                    text = self.tr(widget_name, context_name)
                    if text not in (widget_name, None, 'None'):
                        widget.setItemText(i, text)
                    else:
                        widget_text = widget.itemText(i)
                        text = self.tr(widget_text, context_name)
                        if text != widget_text:
                            widget.setItemText(i, text)
                    self.translate_tooltip(context_name, widget.widget(i))
            elif type(widget) is QGroupBox:
                widget_name = widget.objectName()
                text = self.tr(widget_name, context_name)
                if text not in (widget_name, None, 'None'):
                    widget.setTitle(text)
                else:
                    widget_title = widget.title()
                    text = self.tr(widget_title, context_name)
                    if text != widget_title:
                        widget.setTitle(text)
                self.translate_tooltip(context_name, widget)
            else:
                widget_name = widget.objectName()
                text = self.tr(widget_name, context_name)
                if text not in (widget_name, None, 'None'):
                    widget.setText(text)
                else:
                    widget_text = widget.text()
                    text = self.tr(widget_text, context_name)
                    if text != widget_text:
                        widget.setText(text)
                self.translate_tooltip(context_name, widget)

        except Exception as e:
            self.log_info(f"{widget_name} --> {type(e).__name__} --> {e}")


    def get_layer_by_layername(self, layername, log_info=False):
        """ Get layer with selected @layername (the one specified in the TOC) """

        layer = QgsProject.instance().mapLayersByName(layername)
        if layer:
            layer = layer[0]
        elif not layer and log_info:
            layer = None
            self.log_info("Layer not found", parameter=layername)

        return layer


    def get_layer_by_tablename(self, tablename, show_warning=False, log_info=False):
        """ Iterate over all layers and get the one with selected @tablename """

        return qgis_get_layer_by_tablename(tablename, show_warning, log_info)


    def get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        return qgis_get_layer_source(layer)


    def get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        return qgis_get_layer_source_table_name(layer)


    def get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """

        return qgis_get_layer_primary_key(layer)


    def get_project_user(self):
        """ Set user """
        return self.user


    def qgis_log_message(self, text=None, message_level=0, context_name=None, parameter=None, tab_name=None):
        """ Write message into QGIS Log Messages Panel with selected message level
            @message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3, NONE = 4}
        """

        msg = None
        if text:
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)

        if tab_name is None:
            tab_name = self.plugin_name

        if message_level >= self.min_message_level:
            QgsMessageLog.logMessage(msg, tab_name, message_level)

        return msg


    def log_message(self, text=None, message_level=0, context_name=None, parameter=None, logger_file=True,
                    stack_level_increase=0, tab_name=None):
        """ Write message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, message_level, context_name, parameter, tab_name)
        if self.logger and logger_file:
            if message_level == 0:
                self.logger.info(msg, stack_level_increase=stack_level_increase)
            elif message_level == 1:
                self.logger.warning(msg, stack_level_increase=stack_level_increase)
            elif message_level == 2:
                self.logger.error(msg, stack_level_increase=stack_level_increase)
            elif message_level == 4:
                self.logger.debug(msg, stack_level_increase=stack_level_increase)


    def log_debug(self, text=None, context_name=None, parameter=None, logger_file=True,
                  stack_level_increase=0, tab_name=None):
        """ Write debug message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, 0, context_name, parameter, tab_name)
        if self.logger and logger_file:
            self.logger.debug(msg, stack_level_increase=stack_level_increase)


    def log_info(self, text=None, context_name=None, parameter=None, logger_file=True,
                 stack_level_increase=0, tab_name=None, level=0):
        """ Write information message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, level, context_name, parameter, tab_name)
        if self.logger and logger_file:
            self.logger.info(msg, stack_level_increase=stack_level_increase)


    def log_warning(self, text=None, context_name=None, parameter=None, logger_file=True,
                    stack_level_increase=0, tab_name=None):
        """ Write warning message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, 1, context_name, parameter, tab_name)
        if self.logger and logger_file:
            self.logger.warning(msg, stack_level_increase=stack_level_increase)


    def log_error(self, text=None, context_name=None, parameter=None, logger_file=True,
                  stack_level_increase=0, tab_name=None):
        """ Write error message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, 2, context_name, parameter, tab_name)
        if self.logger and logger_file:
            self.logger.error(msg, stack_level_increase=stack_level_increase)


    def add_translator(self, locale_path, log_info=False):
        """ Add translation file to the list of translation files to be used for translations """

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)
            if log_info:
                self.log_info("Add translator", parameter=locale_path)
        else:
            if log_info:
                self.log_info("Locale not found", parameter=locale_path)


    def manage_translation(self, locale_name, dialog=None, log_info=False):
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
                self.log_info("Locale not found", parameter=locale_path)
            locale_default = 'en'
            locale_path = os.path.join(self.plugin_dir, 'i18n', f'giswater_{locale_default}.qm')
            # If English locale file not found, exit function
            # It means that probably that form has not been translated yet
            if not os.path.exists(locale_path):
                if log_info:
                    self.log_info("Locale not found", parameter=locale_path)
                return

        # Add translation file
        self.add_translator(locale_path)

        # If dialog is set, then translate form
        if dialog:
            self.translate_form(dialog, locale_name)


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


    def check_function(self, function_name, schema_name=None, commit=True):
        """ Check if @function_name exists in selected schema """

        if schema_name is None:
            schema_name = self.schema_name

        schema_name = schema_name.replace('"', '')
        sql = ("SELECT routine_name FROM information_schema.routines "
               "WHERE lower(routine_schema) = %s "
               "AND lower(routine_name) = %s")
        params = [schema_name, function_name]
        row = self.get_row(sql, params=params, commit=commit)
        return row


    def check_table(self, tablename, schemaname=None):
        """ Check if selected table exists in selected schema """

        if schemaname is None:
            schemaname = self.schema_name
            if schemaname is None:
                self.get_layer_source_from_credentials()
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
            username = self.user

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
        if self.user in super_users:
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


    def set_layer_visible(self, layer, visible=True):
        """ Set layer visible """

        if layer:
            if visible:
                QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityCheckedParentRecursive(visible)
            else:
                QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(visible)


    def get_layers(self):
        """ Return layers in the same order as listed in TOC """

        return qgis_get_layers()


    def set_search_path(self, schema_name):
        """ Set parameter search_path for current QGIS project """

        sql = f"SET search_path = {schema_name}, public;"
        self.execute_sql(sql)


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
        if self.user == 'postgres' or self.user == 'gisadmin':
            role_master = True

        # Manage super_user
        if super_users is not None:
            if self.user in super_users:
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


    def manage_exception(self, title=None, description=None, sql=None):
        """ Manage exception and show information to the user """

        # Get traceback
        trace = traceback.format_exc()
        exc_type, exc_obj, exc_tb = sys.exc_info()
        path = exc_tb.tb_frame.f_code.co_filename
        file_name = os.path.split(path)[1]
        #folder_name = os.path.dirname(path)

        # Set exception message details
        msg = ""
        msg += f"Error type: {exc_type}\n"
        msg += f"File name: {file_name}\n"
        msg += f"Line number: {exc_tb.tb_lineno}\n"
        msg += f"{trace}\n"
        if description:
            msg += f"Description: {description}\n"
        if sql:
            msg += f"SQL:\n {sql}\n"

        # Show exception message in dialog and log it
        self.show_exceptions_msg(title, msg)
        self.log_warning(msg)


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
            file_name = tools_os.get_file_with_parents(module_path, 2)
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
                msg += f"SQL:\n{sql}\n"

            # Show exception message in dialog and log it
            if show_exception_msg:
                title = "Database error"
                self.show_exceptions_msg(title, msg)
            else:
                self.log_warning("Exception message not shown to user")
            self.log_warning(msg, stack_level_increase=2)

        except Exception:
            self.manage_exception("Unhandled Error")


    def set_text_bold(self, widget, pattern=None):
        """ Set bold text when word match with pattern
        :param widget: QTextEdit
        :param pattern: Text to find used as pattern for QRegExp (String)
        :return:
        """

        if not pattern:
            pattern = "File\sname:|Function\sname:|Line\snumber:|SQL:|SQL\sfile:|Detail:|Context:|Description"
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


    def manage_exception_api(self, json_result, sql=None, stack_level=2, stack_level_increase=0, is_notify=False):
        """ Manage exception in JSON database queries and show information to the user """

        try:

            if 'message' in json_result:

                parameter = None
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                if 'text' in json_result['message']:
                    msg = json_result['message']['text']
                else:
                    parameter = 'text'
                    msg = "Key on returned json from ddbb is missed"
                if is_notify is True:
                    self.log_info(msg, parameter=parameter, level=level)
                else:
                    self.show_message(msg, level, parameter=parameter)

            else:

                stack_level += stack_level_increase
                module_path = inspect.stack()[stack_level][1]
                file_name = tools_os.get_file_with_parents(module_path, 2)
                function_line = inspect.stack()[stack_level][2]
                function_name = inspect.stack()[stack_level][3]

                # Set exception message details
                title = "Database API execution failed"
                msg = ""
                msg += f"File name: {file_name}\n"
                msg += f"Function name: {function_name}\n"
                msg += f"Line number: {function_line}\n"
                if 'SQLERR' in json_result:
                    msg += f"Detail: {json_result['SQLERR']}\n"
                elif 'NOSQLERR' in json_result:
                    msg += f"Detail: {json_result['NOSQLERR']}\n"
                if 'SQLCONTEXT' in json_result:
                    msg += f"Context: {json_result['SQLCONTEXT']}\n"
                if sql:
                    msg += f"SQL: {sql}"

                # Show exception message in dialog and log it
                self.show_exceptions_msg(title, msg)
                self.log_warning(msg, stack_level_increase=2)

        except Exception:
            self.manage_exception("Unhandled Error")


    def show_exceptions_msg(self, title=None, msg="", window_title="Information about exception"):
        """ Show exception message in dialog """

        self.dlg_info = DialogTextUi()
        self.dlg_info.btn_accept.setVisible(False)
        self.dlg_info.btn_close.clicked.connect(lambda: self.dlg_info.close())
        self.dlg_info.setWindowTitle(window_title)
        if title:
            self.dlg_info.lbl_text.setText(title)
        tools_qt.setWidgetText(self.dlg_info, self.dlg_info.txt_infolog, msg)
        self.dlg_info.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.set_text_bold(self.dlg_info.txt_infolog)
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
            self.log_warning(f"{type(e).__name__} --> {e}")


    def init_docker(self, docker_param='qgis_info_docker'):
        """ Get user config parameter @docker_param """

        self.show_docker = True
        if docker_param == 'qgis_main_docker':
            # Show 'main dialog' in docker depending its value in user settings
            self.qgis_main_docker = self.get_user_setting_value(docker_param, 'true')
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
                        set_parser_value('docker_info', 'position', f'{docker_pos}')
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
            pos = int(get_parser_value('docker_info', 'position'))
            if pos in (1, 2, 4, 8):
                self.dlg_docker.position = pos
        except:
            self.dlg_docker.position = 2

        # TODO: Check this
        # If user want to dock the dialog, we reset rubberbands for each info
        # For the first time, cf_info does not exist, therefore we cannot access it and reset rubberbands
        try:
            resetRubberbands()
        except AttributeError:
            pass


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


    def manage_return_manager(self, json_result, sql, rubber_band=None):
        """
        Manage options for layers (active, visible, zoom and indexing)
        :param json_result: Json result of a query (Json)
        :param sql: query executed (String)
        :return: None
        """

        try:
            return_manager = json_result['body']['returnManager']
        except KeyError:
            return
        srid = global_vars.srid
        try:
            margin = None
            opacity = 100

            if 'zoom' in return_manager and 'margin' in return_manager['zoom']:
                margin = return_manager['zoom']['margin']

            if 'style' in return_manager and 'ruberband' in return_manager['style']:
                # Set default values
                width = 3
                color = QColor(255, 0, 0, 125)
                if 'transparency' in return_manager['style']['ruberband']:
                    opacity = return_manager['style']['ruberband']['transparency'] * 255
                if 'color' in return_manager['style']['ruberband']:
                    color = return_manager['style']['ruberband']['color']
                    color = QColor(color[0], color[1], color[2], opacity)
                if 'width' in return_manager['style']['ruberband']:
                    width = return_manager['style']['ruberband']['width']
                draw(json_result, rubber_band, margin, color=color, width=width)

            else:

                for key, value in list(json_result['body']['data'].items()):
                    if key.lower() in ('point', 'line', 'polygon'):
                        if key not in json_result['body']['data']:
                            continue
                        if 'features' not in json_result['body']['data'][key]:
                            continue
                        if len(json_result['body']['data'][key]['features']) == 0:
                            continue

                        layer_name = f'{key}'
                        if 'layerName' in json_result['body']['data'][key]:
                            if json_result['body']['data'][key]['layerName']:
                                layer_name = json_result['body']['data'][key]['layerName']

                        delete_layer_from_toc(layer_name)

                        # Get values for create and populate layer
                        counter = len(json_result['body']['data'][key]['features'])
                        geometry_type = json_result['body']['data'][key]['geometryType']
                        v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')

                        populate_vlayer(v_layer, json_result['body']['data'], key, counter)

                        # Get values for set layer style
                        opacity = 100
                        style_type = json_result['body']['returnManager']['style']
                        if 'style' in return_manager and 'transparency' in return_manager['style'][key]:
                            opacity = return_manager['style'][key]['transparency'] * 255

                        if style_type[key]['style'] == 'categorized':
                            color_values = {}
                            for item in json_result['body']['returnManager']['style'][key]['values']:
                                color = QColor(item['color'][0], item['color'][1], item['color'][2], opacity * 255)
                                color_values[item['id']] = color
                            cat_field = str(style_type[key]['field'])
                            size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                            categoryze_layer(v_layer, cat_field, size, color_values)

                        elif style_type[key]['style'] == 'random':
                            size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                            if geometry_type == 'Point':
                                v_layer.renderer().symbol().setSize(size)
                            else:
                                v_layer.renderer().symbol().setWidth(size)
                            v_layer.renderer().symbol().setOpacity(opacity)

                        elif style_type[key]['style'] == 'qml':
                            style_id = style_type[key]['id']
                            extras = f'"style_id":"{style_id}"'
                            body = create_body(extras=extras)
                            style = global_vars.controller.get_json('gw_fct_getstyle', body)
                            if style['status'] == 'Failed': return
                            if 'styles' in style['body']:
                                if 'style' in style['body']['styles']:
                                    qml = style['body']['styles']['style']
                                    create_qml(v_layer, qml)

                        elif style_type[key]['style'] == 'unique':
                            color = style_type[key]['values']['color']
                            size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                            color = QColor(color[0], color[1], color[2])
                            if key == 'point':
                                v_layer.renderer().symbol().setSize(size)
                            elif key in ('line', 'polygon'):
                                v_layer.renderer().symbol().setWidth(size)
                            v_layer.renderer().symbol().setColor(color)
                            v_layer.renderer().symbol().setOpacity(opacity)

                        global_vars.iface.layerTreeView().refreshLayerSymbology(v_layer.id())
                        self.set_margin(v_layer, margin)

        except Exception as e:
            global_vars.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)


    def manage_layer_manager(self, json_result, sql):
        """
        Manage options for layers (active, visible, zoom and indexing)
        :param json_result: Json result of a query (Json)
        :return: None
        """

        try:
            layermanager = json_result['body']['layerManager']
        except KeyError:
            return

        try:

            # force visible and in case of does not exits, load it
            if 'visible' in layermanager:
                for lyr in layermanager['visible']:
                    layer_name = [key for key in lyr][0]
                    layer = global_vars.controller.get_layer_by_tablename(layer_name)
                    if layer is None:
                        the_geom = lyr[layer_name]['geom_field']
                        field_id = lyr[layer_name]['pkey_field']
                        if lyr[layer_name]['group_layer'] is not None:
                            group = lyr[layer_name]['group_layer']
                        else:
                            group = "GW Layers"
                        style_id = lyr[layer_name]['style_id']
                        from_postgres_to_toc(layer_name, the_geom, field_id, group=group, style_id=style_id)
                    global_vars.controller.set_layer_visible(layer)

            # force reload dataProvider in order to reindex.
            if 'index' in layermanager:
                for lyr in layermanager['index']:
                    layer_name = [key for key in lyr][0]
                    layer = global_vars.controller.get_layer_by_tablename(layer_name)
                    if layer:
                        global_vars.controller.set_layer_index(layer)

            # Set active
            if 'active' in layermanager:
                layer = global_vars.controller.get_layer_by_tablename(layermanager['active'])
                if layer:
                    global_vars.iface.setActiveLayer(layer)

            # Set zoom to extent with a margin
            if 'zoom' in layermanager:
                layer = global_vars.controller.get_layer_by_tablename(layermanager['zoom']['layer'])
                if layer:
                    prev_layer = global_vars.iface.activeLayer()
                    global_vars.iface.setActiveLayer(layer)
                    global_vars.iface.zoomToActiveLayer()
                    margin = layermanager['zoom']['margin']
                    self.set_margin(layer, margin)
                    if prev_layer:
                        global_vars.iface.setActiveLayer(prev_layer)

            # Set snnaping options
            if 'snnaping' in layermanager:
                for layer_name in layermanager['snnaping']:
                    layer = global_vars.controller.get_layer_by_tablename(layer_name)
                    if layer:
                        QgsProject.instance().blockSignals(True)
                        layer_settings = snap_to_layer(layer, QgsPointLocator.All, True)
                        if layer_settings:
                            layer_settings.setType(2)
                            layer_settings.setTolerance(15)
                            layer_settings.setEnabled(True)
                        else:
                            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
                        snapping_config = get_snapping_options()
                        snapping_config.setIndividualLayerSettings(layer, layer_settings)
                        QgsProject.instance().blockSignals(False)
                        QgsProject.instance().snappingConfigChanged.emit(
                            snapping_config)
                set_snapping_mode()


        except Exception as e:
            global_vars.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)


    def set_margin(self, layer, margin):

        extent = QgsRectangle()
        extent.setMinimal()
        extent.combineExtentWith(layer.extent())
        xmax = extent.xMaximum() + margin
        xmin = extent.xMinimum() - margin
        ymax = extent.yMaximum() + margin
        ymin = extent.yMinimum() - margin
        extent.set(xmin, ymin, xmax, ymax)
        global_vars.iface.mapCanvas().setExtent(extent)
        global_vars.iface.mapCanvas().refresh()