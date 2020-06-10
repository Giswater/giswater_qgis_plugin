"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsMessageLog, QgsCredentials, QgsExpressionContextUtils, QgsProject, QgsDataSourceUri
from qgis.PyQt.QtCore import QCoreApplication, QRegExp, QSettings, Qt, QTranslator
from qgis.PyQt.QtGui import QTextCharFormat, QFont
from qgis.PyQt.QtWidgets import QCheckBox, QLabel, QMessageBox, QPushButton, QTabWidget, QToolBox
from qgis.PyQt.QtSql import QSqlDatabase

import configparser
import inspect
import json
import os
import sys
import traceback

from collections import OrderedDict
from functools import partial

from .pg_dao import PgDao
from .logger import Logger
from .. import utils_giswater
from .. import sys_manager
from ..ui_manager import BasicInfo


class DaoController(object):
    
    def __init__(self, settings, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """
        
        self.settings = settings      
        self.plugin_name = plugin_name               
        self.iface = iface               
        self.translator = None           
        self.plugin_dir = None           
        self.giswater = None
        self.logged = False
        self.postgresql_version = None
        self.logger = None
        self.schema_name = None
        self.dao = None
        self.credentials = None
        self.current_user = None
        self.min_log_level = 20
        self.min_message_level = 0
        self.user_settings = None
        self.user_settings_path = None

        if create_logger:
            self.set_logger(logger_name)
                
        
    def close_db(self):
        """ Close database connection """
                    
        if self.dao:
            if not self.dao.close_db():
                self.log_info(str(self.last_error))
            del self.dao
        
        
    def set_giswater(self, giswater):
        self.giswater = giswater
                

    def set_schema_name(self, schema_name):
        self.schema_name = schema_name
                

    def set_qgis_settings(self, qgis_settings):
        self.qgis_settings = qgis_settings       
        

    def set_plugin_dir(self, plugin_dir):
        self.plugin_dir = plugin_dir
        
        
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
        value = QCoreApplication.translate(context_name, message)
        # If not translation has been found, check into 'ui_message' context
        if value == message:
            value = QCoreApplication.translate('ui_message', message)
        return value                            
    
        
    def plugin_settings_value(self, key, default_value=""):
        key = self.plugin_name + "/" + key
        value = self.qgis_settings.value(key, default_value)
        return value    


    def plugin_settings_set_value(self, key, value):
        self.qgis_settings.setValue(self.plugin_name+"/"+key, value)            
    
    
    def set_actions(self, actions):
        self.actions = actions      
        
        
    def check_actions(self, check=True):
        """ Utility to check/uncheck all actions """
        for action_index, action in self.actions.items():   #@UnusedVariable
            action.setChecked(check)
    
    
    def set_database_connection(self):
        """ Set database connection """
        
        # Initialize variables
        self.dao = None 
        self.last_error = None      
        self.log_codes = {}
        self.logged = False
        
        self.layer_source, not_version = self.get_layer_source_from_credentials()
        if self.layer_source:
            if self.layer_source['db'] is None or self.layer_source['host'] is None or self.layer_source['user'] is None \
                    or self.layer_source['password'] is None or self.layer_source['port'] is None:
                return False, not_version
        else:
            return False, not_version

        self.logged = True
        return True, not_version
    

    def get_sslmode(self):
        """ Get sslmode for database connection """

        sslmode = 'disable'
        if self.user_settings is None:
            return sslmode

        if not self.user_settings.has_section('system'):
            self.user_settings.add_section('system')
            self.user_settings.set('system', 'sslmode', sslmode)
            self.save_user_settings()

        sslmode = self.user_settings.get('system', 'sslmode').lower()
        self.log_info(f"get_sslmode: {sslmode}")

        return sslmode


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

        self.manage_user_config_file()
        sslmode = self.get_sslmode()

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
            credentials = {'db': None, 'schema': None, 'table': None,
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
                status, credentials = self.connect_to_database_credentials(credentials)
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

        attempt = 0
        logged = False
        while not logged and attempt <= max_attempts:
            attempt += 1
            if conn_info and attempt > 1:
                (success, credentials['user'], credentials['password']) = QgsCredentials.instance().get(conn_info,
                    credentials['user'], credentials['password'])
            logged = self.connect_to_database(credentials['host'], credentials['port'], credentials['db'],
                credentials['user'], credentials['password'], credentials['sslmode'])

        return logged, credentials

    
    def connect_to_database(self, host, port, db, user, pwd, sslmode):
        """ Connect to database with selected parameters """
        
        # Check if selected parameters is correct
        if None in (host, port, db, user, pwd):
            message = "Database connection error. Please check your connection parameters."
            self.last_error = self.tr(message)
            return False

        # Update current user
        self.user = user
        
        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL")
        self.db.setHostName(host)
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


    def connect_to_database_service(self, service):
        """ Connect to database trough selected service
        This service must exist in file pg_service.conf """

        # We need to create this connections for Table Views
        self.db = QSqlDatabase.addDatabase("QPSQL")
        self.db.setConnectOptions(f"service={service}")
        status = self.db.open()
        if not status:
            message = "Database connection error (QSqlDatabase). Please open plugin log file to get more details"
            self.last_error = self.tr(message)
            details = self.db.lastError().databaseText()
            self.log_warning(str(details))
            return False

        # Connect to Database
        self.dao = PgDao()
        self.dao.set_service(service)
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


    def get_error_message(self, log_code_id):    
        """ Get error message from selected error code """
        
        if self.schema_name is None:
            return       

        sql = ("SELECT error_message "
               "FROM audit_cat_error "
               "WHERE id = " + str(log_code_id))
        result = self.dao.get_row(sql)  
        if result:
            self.log_codes[log_code_id] = result[0]    
        else:
            self.log_codes[log_code_id] = "Error message not found in the database: " + str(log_code_id)
            
            
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
        
    
    def show_message(self, text, message_level=1, duration=5, context_name=None, parameter=None):
        """ Show message to the user with selected message level
        message_level: {INFO = 0(blue), WARNING = 1(yellow), CRITICAL = 2(red), SUCCESS = 3(green)} """
        
        msg = None        
        if text:        
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)             
        self.iface.messageBar().pushMessage("", msg, message_level, duration)
            

    def show_info(self, text, duration=5, context_name=None, parameter=None, logger_file=True):
        """ Show information message to the user """

        self.show_message(text, 0, duration, context_name, parameter)
        if self.logger and logger_file:
            self.logger.info(text)            


    def show_warning(self, text, duration=5, context_name=None, parameter=None, logger_file=True):
        """ Show warning message to the user """

        self.show_message(text, 1, duration, context_name, parameter)
        if self.logger and logger_file:
            self.logger.warning(text)


    def show_critical(self, text, duration=5, context_name=None, parameter=None, logger_file=True):
        """ Show warning message to the user """

        self.show_message(text, 2, duration, context_name, parameter)
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
        button.clicked.connect(partial(sys_manager.open_file, file_path))
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

        
    def get_row(self, sql, log_info=True, log_sql=False, commit=False, params=None):
        """ Execute SQL. Check its result in log tables, and show it to the user """
        
        sql = self.get_sql(sql, log_sql, params)
        row = self.dao.get_row(sql, commit)   
        self.last_error = self.dao.last_error      
        if not row:
            # Check if any error has been raised
            if self.last_error:
                text = "Undefined error" 
                if '-1' in self.log_codes:   
                    text = self.log_codes[-1]
                self.show_warning_detail(text, str(self.last_error))
            elif self.last_error is None and log_info:
                self.log_info("Any record found", parameter=sql, stack_level_increase=1)
          
        return row


    def get_rows(self, sql, log_info=True, log_sql=False, commit=False, params=None, add_empty_row=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        sql = self.get_sql(sql, log_sql, params)
        rows = None
        rows2 = self.dao.get_rows(sql, commit)
        self.last_error = self.dao.last_error 
        if not rows2:
            # Check if any error has been raised
            if self.last_error:
                text = "Undefined error"
                if '-1' in self.log_codes:
                    text = self.log_codes[-1]
                self.show_warning_detail(text, str(self.dao.last_error))
            elif self.last_error is None and log_info:
                self.log_info("Any record found", parameter=sql, stack_level_increase=1)
        else:
            if add_empty_row:
                rows = [('', '')]
                rows.extend(rows2)
            else:
                rows = rows2

        return rows  
    
            
    def execute_sql(self, sql, search_audit=False, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            self.log_info(sql, stack_level_increase=1)        
        result = self.dao.execute_sql(sql, commit)
        self.last_error = self.dao.last_error         
        if not result:
            if log_error:
                self.log_info(sql, stack_level_increase=1)
            text = "Undefined error"
            if '-1' in self.log_codes:
                text = self.log_codes[-1]
            self.show_warning_detail(text, str(self.dao.last_error))
            return False
        else:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit(commit)

        return True


    def execute_returning(self, sql, search_audit=False, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            self.log_info(sql, stack_level_increase=1)
        value = self.dao.execute_returning(sql, commit)
        self.last_error = self.dao.last_error
        if not value:
            if log_error:
                self.log_info(sql, stack_level_increase=1)
            text = "Undefined error"
            if '-1' in self.log_codes:
                text = self.log_codes[-1]
            self.show_warning_detail(text, str(self.dao.last_error))
            return False
        else:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit(commit)

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
                sql_values += "'" + value + "', "
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
        sql = sql.replace("''","'")

        # Execute sql
        self.log_info(sql, stack_level_increase=1)
        result = self.dao.execute_sql(sql, commit)
        self.last_error = self.dao.last_error         
        if not result:
            text = "Undefined error"
            if '-1' in self.log_codes:
                text = self.log_codes[-1]
            self.show_warning_detail(text, str(self.dao.last_error))
            return False

        return True
               
            
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
                sql_values += "$$" + value + "$$, "
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
            text = "Undefined error"
            if '-1' in self.log_codes:
                text = self.log_codes[-1]
            self.show_warning_detail(text, str(self.dao.last_error))
            return False

        return True


    def execute_api_function(self, function_name, body):
        """ Manage execution API function
        :param function_name: Name of function to call (text)
        :param body: Parameter for function (json::text)
        :return: Response of the function executed (json)
        """

        # Check if function exists
        row = self.check_function(function_name)
        if not row:
            self.show_warning("Function not found in database", parameter=function_name)
            return None

        sql = f"SELECT {function_name} ($${{{body}}}$$)::text;"
        row = self.get_row(sql, log_sql=True)
        if not row:
            self.show_critical("NOT ROW FOR", parameter=sql)
            return None

        json_result = json.loads(row[0], object_pairs_hook=OrderedDict)

        if 'status' in json_result and json_result['status'] == 'Failed':
            try:
                title = "Execute failed."
                msg = f"<b>Error: </b>{json_result['SQLERR']}<br>"
                msg += f"<b>Context: </b>{json_result['SQLCONTEXT']} <br>"
            except KeyError as e:
                title = "Key on returned json from ddbb is missed."
                msg = f"<b>Key: </b>{e}<br>"
                msg += f"<b>Python file: </b>{__name__} <br>"
                msg += f"<b>Python function: </b>{self.execute_api_function.__name__} <br>"
            self.show_exceptions_msg(title, msg)
            return False

        return json_result


    def get_error_from_audit(self, commit=True):
        """ Get last error from audit tables that has not been showed to the user """
        
        if self.schema_name is None:
            return                  
        
        sql = ("SELECT audit_function_actions.id, error_message, log_level, show_user"
               " FROM audit_function_actions"
               " INNER JOIN audit_cat_error"
               " ON audit_function_actions.audit_cat_error_id = audit_cat_error.id"
               " WHERE audit_cat_error.id != 0 AND debug_info is null"
               " ORDER BY audit_function_actions.id DESC LIMIT 1")
        result = self.dao.get_row(sql, commit)
        if result:
            if result['log_level'] <= 2:
                sql = ("UPDATE audit_function_actions"
                       " SET debug_info = 'showed'"
                       " WHERE id = " + str(result['id']))
                self.dao.execute_sql(sql, commit)
                if result['show_user']:
                    self.show_message(result['error_message'], result['log_level'])
                return False    
            elif result['log_level'] == 3:
                # Debug message
                pass
            
        return True
        
        
    def translate_form(self, dialog, context_name):
        """ Translate widgets of the form to current language """
        
        # Get objects of type: QLabel
        widget_list = dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
        # Get objects of type: QCheckBox
        widget_list = dialog.findChildren(QCheckBox)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
             
        # Get objects of type: QTabWidget            
        widget_list = dialog.findChildren(QTabWidget)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
         
        # Translate title of the form   
        text = self.tr('title', context_name)
        dialog.setWindowTitle(text)
            

    def get_json(self, function_name, parameters=None, schema_name=None, commit=True, log_sql=False,
                 log_result=False, json_loads=False):
        """ Manage execution API function
        :param function_name: Name of function to call (text)
        :param body: Parameter for function (json)
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
            json_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        else:
            json_result = row[0]

        # Log result
        if log_result:
            self.log_info(json_result, stack_level_increase=1)

        # If failed, manage exception
        if 'status' in json_result and json_result['status'] == 'Failed':
            self.manage_exception_api(json_result, sql)
            return False

        return json_result 
 
    def translate_widget(self, context_name, widget):
        """ Translate widget text """
        
        if not widget:
            return

        try:
            if type(widget) is QTabWidget:
                num_tabs = widget.count()
                for i in range(0, num_tabs):
                    widget_name = widget.widget(i).objectName()
                    text = self.tr(widget_name, context_name)
                    if text != widget_name:
                        widget.setTabText(i, text)
                    else:
                        widget_text = widget.tabText(i)
                        text = self.tr(widget_text, context_name)
                        if text != widget_text:
                            widget.setTabText(i, text)

            elif type(widget) is QToolBox:
                num_tabs = widget.count()
                for i in range(0, num_tabs):
                    widget_name = widget.widget(i).objectName()
                    text = self.tr(widget_name, context_name)
                    if text != widget_name:
                        widget.setItemText(i, text)
                    else:
                        widget_text = widget.itemText(i)
                        text = self.tr(widget_text, context_name)
                        if text != widget_text:
                            widget.setItemText(i, text)
            else:
                widget_name = widget.objectName()
                text = self.tr(widget_name, context_name)
                if text != widget_name:
                    widget.setText(text)
                else:
                    widget_text = widget.text()
                    text = self.tr(widget_text, context_name)
                    if text != widget_text:
                        widget.setText(text)
        except:
            pass
        
        
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
        
        # Check if we have any layer loaded
        layers = self.get_layers()
        if len(layers) == 0:
            return None

        # Iterate over all layers
        layer = None
        for cur_layer in layers:
            uri_table = self.get_layer_source_table_name(cur_layer)
            if uri_table is not None and uri_table == tablename:
                layer = cur_layer
                break
        
        if layer is None and show_warning:
            self.show_warning("Layer not found", parameter=tablename)
                           
        if layer is None and log_info:
            self.log_info("Layer not found", parameter=tablename)
                                      
        return layer        

        
    def get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        # Initialize variables
        layer_source = {'db': None, 'schema': None, 'table': None, 
                        'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

        if layer is None:
            return layer_source

        # Get dbname, host, port, user and password
        uri = layer.dataProvider().dataSourceUri()
        pos_db = uri.find('dbname=')
        pos_host = uri.find(' host=')
        pos_port = uri.find(' port=')
        pos_user = uri.find(' user=')
        pos_password = uri.find(' password=')
        pos_sslmode = uri.find(' sslmode=')        
        pos_key = uri.find(' key=')        
        if pos_db != -1 and pos_host != -1:
            uri_db = uri[pos_db + 8:pos_host - 1]
            layer_source['db'] = uri_db     
        if pos_host != -1 and pos_port != -1:
            uri_host = uri[pos_host + 6:pos_port]     
            layer_source['host'] = uri_host     
        if pos_port != -1:
            if pos_user != -1:
                pos_end = pos_user
            elif pos_sslmode != -1:
                pos_end = pos_sslmode
            elif pos_key != -1:
                pos_end = pos_key
            else:
                pos_end = pos_port + 10
            uri_port = uri[pos_port + 6:pos_end]     
            layer_source['port'] = uri_port               
        if pos_user != -1 and pos_password != -1:
            uri_user = uri[pos_user + 7:pos_password - 1]
            layer_source['user'] = uri_user     
        if pos_password != -1 and pos_sslmode != -1:
            uri_password = uri[pos_password + 11:pos_sslmode - 1]     
            layer_source['password'] = uri_password                     
         
        # Get schema and table or view name     
        pos_table = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_table != -1 and pos_fi != -1:
            uri_schema = uri[pos_table + 6:pos_end_schema]
            uri_table = uri[pos_end_schema + 2:pos_fi]
            layer_source['schema'] = uri_schema            
            layer_source['table'] = uri_table            

        return layer_source                                                             
    
      
    def get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        if layer is None:
            return None
        
        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini != -1 and pos_fi != -1:
            uri_table = uri[pos_end_schema+2:pos_fi]

        return uri_table    
        
        
    def get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """
        
        uri_pk = None
        if layer is None:
            layer = self.iface.activeLayer()
        if layer is None:
            return uri_pk
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('key=')
        pos_end = uri.rfind('srid=')
        if pos_ini != -1:
            uri_pk = uri[pos_ini + 5:pos_end-2]

        return uri_pk
        
   
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
                 stack_level_increase=0, tab_name=None):
        """ Write information message into QGIS Log Messages Panel """

        msg = self.qgis_log_message(text, 0, context_name, parameter, tab_name)
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


    def get_locale(self):
        """ Get locale of QGIS application """

        locale = "en"
        try:
            locale = QSettings().value('locale/userLocale').lower()
        except AttributeError:
            pass
        finally:
            if locale == 'es_es' or locale == 'es':
                locale = 'es'
            elif locale == 'es_ca':
                locale = 'ca'
            elif locale == 'en_us':
                locale = 'en'
            return locale

                    
    def manage_translation(self, locale_name, dialog=None, log_info=False):  
        """ Manage locale and corresponding 'i18n' file """ 
        
        # Get locale of QGIS application
        locale = self.get_locale()
            
        # If user locale file not found, set English one by default
        locale_path = os.path.join(self.plugin_dir, 'i18n', locale_name+'_{}.qm'.format(locale))
        if not os.path.exists(locale_path):
            if log_info:
                self.log_info("Locale not found", parameter=locale_path)
            locale_default = 'en'
            locale_path = os.path.join(self.plugin_dir, 'i18n', locale_name+'_{}.qm'.format(locale_default))
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
        """ Get water software from table 'version' """

        if schemaname is None:
            schemaname = self.schema_name
            if schemaname is None:
                return None

        schemaname = schemaname.replace('"', '')

        project_type = None
        tablename = "version"
        exists = self.check_table(tablename)
        if exists:
            sql = ("SELECT lower(wsoftware) "
                   "FROM " + schemaname + "." + tablename + " "
                   "ORDER BY id ASC LIMIT 1")
            row = self.get_row(sql, commit=True)
            if row:
                project_type = row[0]
        else:
            tablename = "version_tm"
            exists = self.check_table(tablename)
            if exists:
                project_type = "tm"

        return project_type
    
      
    def get_project_version(self):
        """ Get project version from table 'version' """
        
        project_version = None
        tablename = "version"
        exists = self.check_table(tablename)
        if exists:
            sql = ("SELECT giswater "
                   "FROM " + tablename + " "
                   "ORDER BY id DESC LIMIT 1")
            row = self.get_row(sql)
            if row:
                project_version = row[0]
            
        return project_version    
    
    
    def check_schema(self, schemaname=None):
        """ Check if selected schema exists """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = "SELECT nspname FROM pg_namespace WHERE nspname = %s"
        params = [schemaname]
        row = self.get_row(sql, commit=True, params=params)
        return row
    
    
    def check_function(self, function_name, schema_name=None, commit=True):
        """ Check if @function_name exists in selected schema """

        if schema_name is None:
            schema_name = self.schema_name

        schema_name = schema_name.replace('"', '')
        sql = ("SELECT routine_name FROM information_schema.routines "
               "WHERE lower(routine_schema) = %s "
               "AND lower(routine_name) = %s ")
        params = [schema_name, function_name]
        row = self.get_row(sql, params=params, commit=commit)
        return row
    
    
    def check_table(self, tablename, schemaname=None):
        """ Check if selected table exists in selected schema """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT * FROM pg_tables "
               "WHERE schemaname = %s AND tablename = %s ")
        params = [schemaname, tablename]
        row = self.get_row(sql, log_info=False, commit=True, params=params)
        return row


    def check_view(self, viewname, schemaname=None):
        """ Check if selected view exists in selected schema """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT * FROM pg_views "
               "WHERE schemaname = %s AND viewname = %s ")
        params = [schemaname, viewname]
        row = self.get_row(sql, log_info=False, commit=True, params=params)
        return row
    
    
    def check_column(self, tablename, columname, schemaname=None):
        """ Check if @columname exists table @schemaname.@tablename """

        if schemaname is None:
            schemaname = self.schema_name

        schemaname = schemaname.replace('"', '')
        sql = ("SELECT * FROM information_schema.columns "
               "WHERE table_schema = %s AND table_name = %s AND column_name = %s ")
        params = [schemaname, tablename, columname]
        row = self.get_row(sql, log_info=False, commit=True, params=params)
        return row
    

    def get_group_layers(self, geom_type):
        """ Get layers of the group @geom_type """
        
        list_items = []        
        sql = ("SELECT child_layer "
               "FROM cat_feature "
               "WHERE upper(feature_type) = '" + geom_type.upper() + "'"
			   "UNION SELECT DISTINCT parent_layer "
               "FROM cat_feature "
               "WHERE upper(feature_type) = '" + geom_type.upper() + "'")
        rows = self.get_rows(sql, log_sql=True)
        if rows:
            for row in rows:
                layer = self.get_layer_by_tablename(row[0])
                if layer:
                    list_items.append(layer)
        
        return list_items


    def check_role(self, role_name):
        """ Check if @role_name exists """
        
        sql = ("SELECT * FROM pg_roles WHERE lower(rolname) = '" + role_name + "'")
        row = self.get_row(sql, log_info=False)
        return row
    
    
    def check_role_user(self, role_name, username=None):
        """ Check if current user belongs to @role_name """
        
        if not self.check_role(role_name):
            return False

        if username is None:
            username = self.user

        sql = ("SELECT pg_has_role('" + username + "', '" + role_name + "', 'MEMBER');")
        row = self.get_row(sql, commit=True)
        if row:
            return row[0]
        else:
            return False
         
         
    def get_current_user(self):
        """ Get current user connected to database """
        
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
             
        
    def check_user_roles(self):
        """ Check roles of this user to show or hide toolbars """
        
        restriction = self.get_restriction()

        if restriction == 'role_basic':
            pass
        elif restriction == 'role_om':
            if self.giswater.wsoftware == 'ws':
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':
                self.giswater.enable_toolbar("om_ud")
        elif restriction == 'role_edit':
            if self.giswater.wsoftware == 'ws':
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':
                self.giswater.enable_toolbar("om_ud")
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
        elif restriction == 'role_epa':
            if self.giswater.wsoftware == 'ws':
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':
                self.giswater.enable_toolbar("om_ud")
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
            self.giswater.enable_toolbar("epa")
            self.giswater.enable_toolbar("master")
            self.giswater.hide_action(False, 38)
            self.giswater.hide_action(False, 47)
            self.giswater.hide_action(False, 49)
            self.giswater.hide_action(False, 50)
        elif restriction == 'role_master':
            self.giswater.enable_toolbar("master")
            self.giswater.enable_toolbar("epa")
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
            if self.giswater.wsoftware == 'ws':
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':
                self.giswater.enable_toolbar("om_ud")


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
            QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(visible)


    def get_layers(self):
        """ Return layers in the same order as listed in TOC """

        layers = [layer.layer() for layer in QgsProject.instance().layerTreeRoot().findLayers()]

        return layers


    def set_search_path(self, dbname, schema_name):
        """ Set parameter search_path for current QGIS project """

        sql = ("SET search_path = " + str(schema_name) + ", public;")
        self.execute_sql(sql, log_sql=True)


    def set_path_from_qfiledialog(self, qtextedit, path):

        if path[0]:
            qtextedit.setText(path[0])


    def get_restriction(self):

        # Get project variable 'project_role'
        qgis_project_role = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('gwProjectRole')

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
        row = self.get_row(sql, commit=True, log_info=log_info)

        return row


    def indexing_spatial_layer(self, layer_name):
        """ Force reload dataProvider of layer """

        layer = self.get_layer_by_tablename(layer_name)
        if layer:
            layer.dataProvider().forceReload()


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


    def manage_exception_db(self, description=None, sql=None, stack_level=2, stack_level_increase=0):
        """ Manage exception in database queries and show information to the user """

        try:
            stack_level += stack_level_increase
            module_path = inspect.stack()[stack_level][1]
            file_name = sys_manager.get_file_with_parents(module_path, 2)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]

            # Set exception message details
            msg = ""
            msg += f"File name: {file_name}\n"
            msg += f"Function name: {function_name}\n"
            msg += f"Line number: {function_line}\n"
            if description:
                msg += f"Description:\n {description}\n"
            if sql:
                msg += f"SQL:\n {sql}\n"

            # Show exception message in dialog and log it
            title = "Database error"
            self.show_exceptions_msg(title, msg)
            self.log_warning(msg, stack_level_increase=2)

        except Exception as e:
            self.manage_exception("Unhandled Error")


    def set_text_bold(self, widget, pattern=None):
        """ Set bold text when word match with pattern
        :param widget:QTextEdit
        :param pattern: Text to find used as pattern for QRegExp (String)
        :return:
        """

        if not pattern:
            pattern = "File\sname:|Function\sname:|Line\snumber:|SQL:|Detail:|Context:"
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


    def manage_exception_api(self, json_result, sql=None, stack_level=2, stack_level_increase=0):
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
                self.show_message(msg, level, parameter=parameter)

            else:

                stack_level += stack_level_increase
                module_path = inspect.stack()[stack_level][1]
                file_name = sys_manager.get_file_with_parents(module_path, 2)
                function_line = inspect.stack()[stack_level][2]
                function_name = inspect.stack()[stack_level][3]

                # Set exception message details
                title = "Database API execution failed"
                msg = ""
                msg += f"File name: {file_name}\n"
                msg += f"Function name: {function_name}\n"
                msg += f"Line number:> {function_line}\n"
                if 'SQLERR' in json_result:
                    msg += f"Detail: {json_result['SQLERR']}\n"
                if 'SQLCONTEXT' in json_result:
                    msg += f"Context: {json_result['SQLCONTEXT']}\n"
                if sql:
                    msg += f"SQL: {sql}"

                # Show exception message in dialog and log it
                self.show_exceptions_msg(title, msg)
                self.log_warning(msg, stack_level_increase=2)

        except Exception as e:
            self.manage_exception("Unhandled Error")


    def show_exceptions_msg(self, title=None, msg="", window_title="Information about exception"):
        """ Show exception message in dialog """

        self.dlg_info = BasicInfo()
        self.dlg_info.btn_accept.setVisible(False)
        self.dlg_info.btn_close.clicked.connect(lambda: self.dlg_info.close())
        self.dlg_info.setWindowTitle(window_title)
        if title: self.dlg_info.lbl_title.setText(title)
        utils_giswater.setWidgetText(self.dlg_info, self.dlg_info.txt_infolog, msg)
        self.dlg_info.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.set_text_bold(self.dlg_info.txt_infolog)
        self.dlg_info.show()

