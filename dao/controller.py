"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QCoreApplication, QSettings, Qt, QTranslator 
from PyQt4.QtGui import QCheckBox, QLabel, QMessageBox, QPushButton, QTabWidget
from PyQt4.QtSql import QSqlDatabase
from qgis.core import QgsMessageLog, QgsMapLayerRegistry, QgsDataSourceURI, QgsCredentials

import os.path
import sys
import subprocess
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
from pg_dao import PgDao


class DaoController():
    
    def __init__(self, settings, plugin_name, iface):
        self.settings = settings      
        self.plugin_name = plugin_name               
        self.iface = iface               
        self.translator = None           
        self.plugin_dir = None           
        self.giswater = None                
        self.logged = False 
        self.postgresql_version = None
        
    def set_giswater(self, giswater):
        self.giswater = giswater
                
    def set_schema_name(self, schema_name):
        self.schema_name = schema_name
                
    def tr(self, message, context_name=None):
        if context_name is None:
            context_name = self.plugin_name
        value = QCoreApplication.translate(context_name, message)
        # If not translation has been found, check into 'ui_message' context
        if value == message:
            value = QCoreApplication.translate('ui_message', message)
        return value                            
    
    def set_qgis_settings(self, qgis_settings):
        self.qgis_settings = qgis_settings       
        
    def set_plugin_dir(self, plugin_dir):
        self.plugin_dir = plugin_dir       
                
    def set_plugin_name(self, plugin_name):
        self.plugin_name = plugin_name
        
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
        for action_index, action in self.actions.iteritems():   #@UnusedVariable
            action.setChecked(check)    
                           
    def check_action(self, check=True, index=1):
        """ Check/Uncheck selected action """
        key = index
        if type(index) is int:
            key = str(index).zfill(2)
        if key in self.actions:
            action = self.actions[key]
            action.setChecked(check)     
    
    def get_schema_name(self):
        self.schema_name = self.plugin_settings_value('schema_name')
        return self.schema_name
    
    
    def set_database_connection(self):
        """ Ser database connection """
        
        # Initialize variables
        self.dao = None 
        self.last_error = None      
        self.log_codes = {}
        
        layer_source = self.get_layer_source_from_credentials()
        if layer_source is None:
            return False
            
        # Connect to database
        self.logged = self.connect_to_database(layer_source['host'], layer_source['port'], 
                                               layer_source['db'], layer_source['user'], layer_source['password']) 
                       
        return self.logged    
    
    
    def get_layer_source_from_credentials(self):

        # Get database parameters from layer 'version'
        layer = self.get_layer_by_tablename("version")
        if not layer:
            self.last_error = self.tr("Layer not found") + ": 'version'"        
            return None
        
        layer_source = self.get_layer_source(layer)    
        self.schema_name = layer_source['schema']
               
        conn_info = QgsDataSourceURI(layer.dataProvider().dataSourceUri()).connectionInfo()
        (success, user, pwd) = QgsCredentials.instance().get(conn_info, None, None)  
        # Put the credentials back (for yourself and the provider), as QGIS removes it when you "get" it
        if success: 
            QgsCredentials.instance().put(conn_info, user, pwd)            
            layer_source['user'] = user            
            layer_source['password'] = pwd   
            return layer_source         
        else:
            self.log_info("Error getting credentials")
            self.last_error = "Error getting credentials"  
            return None
                
    
    def connect_to_database(self, host, port, db, user, pwd):
        """ Connect to database with selected parameters """
        
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
            msg = "Database connection error. Please check connection parameters"
            self.last_error = self.tr(msg)
            return False           
        
        # Connect to Database 
        self.dao = PgDao()     
        self.dao.set_params(host, port, db, user, pwd)
        status = self.dao.init_db()                 
        if not status:
            msg = "Database connection error. Please check connection parameters"
            self.last_error = self.tr(msg)
            return False    
        
        return status      
    
    
    def get_error_message(self, log_code_id):    
        """ Get error message from selected error code """
        
        if self.schema_name is None:
            return       

        sql = ("SELECT error_message"
               " FROM " + self.schema_name + ".audit_cat_error"
               " WHERE id = " + str(log_code_id))
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
        
    
    def show_message(self, text, message_level=1, duration=5, context_name=None, parameter=None):
        """ Show message to the user with selected message level
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} """
        
        msg = None        
        if text:        
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)             
        self.iface.messageBar().pushMessage("", msg, message_level, duration)
            

    def show_info(self, text, duration=5, context_name=None, parameter=None):
        """ Show information message to the user """
        self.show_message(text, 0, duration, context_name, parameter)


    def show_warning(self, text, duration=5, context_name=None, parameter=None):
        """ Show warning message to the user """
        self.show_message(text, 1, duration, context_name, parameter)
        

    def show_warning_detail(self, text, detail_text, context_name=None):
        """ Show warning message with a button to show more details """  
         
        inf_text = "Press 'Show Me' button to get more details..."
        widget = self.iface.messageBar().createMessage(self.tr(text, context_name), self.tr(inf_text))
        button = QPushButton(widget)
        button.setText(self.tr("Show Me"))
        button.pressed.connect(partial(self.show_details, detail_text, self.tr('Warning details')))
        widget.layout().addWidget(button)
        self.iface.messageBar().pushWidget(widget, 1)        
    
    
    def show_details(self, detail_text, title=None, inf_text=None):
        """ Shows a message box with detail information """
        
        self.iface.messageBar().clearWidgets()        
        msg_box = QMessageBox()
        msg_box.setText(detail_text)
        if title:
            title = self.tr(title)
            msg_box.setWindowTitle(title);        
        if inf_text:
            inf_text = self.tr(inf_text)            
            msg_box.setInformativeText(inf_text);    
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)        
        msg_box.exec_()                      
        
        
    def ask_question(self, text, title=None, inf_text=None, context_name=None, parameter=None):
        """ Ask question to the user """   

        msg_box = QMessageBox()
        msg = self.tr(text, context_name)
        if parameter:
            msg += ": " + str(parameter)          
        msg_box.setText(msg)
        if title:
            title = self.tr(title, context_name)
            msg_box.setWindowTitle(title);        
        if inf_text:
            inf_text = self.tr(inf_text, context_name)
            msg_box.setInformativeText(inf_text);        
        msg_box.setStandardButtons(QMessageBox.Cancel | QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)  
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        ret = msg_box.exec_()
        if ret == QMessageBox.Ok:
            return True
        elif ret == QMessageBox.Discard:
            return False      
        
        
    def show_info_box(self, text, title=None, inf_text=None, context_name=None, parameter=None):
        """ Ask question to the user """   

        if text:        
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)  
                
        msg_box = QMessageBox()
        msg_box.setText(msg)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        if title:
            title = self.tr(title, context_name)            
            msg_box.setWindowTitle(title);        
        if inf_text:
            inf_text = self.tr(inf_text, context_name)            
            msg_box.setInformativeText(inf_text);        
        msg_box.setDefaultButton(QMessageBox.No)        
        ret = msg_box.exec_()   #@UnusedVariable
                          
            
    def get_row(self, sql, log_info=True, log_sql=False, commit=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """
        
        if log_sql:
            self.log_info(sql)
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
                self.log_info("Any record found", parameter=sql)
          
        return row


    def get_rows(self, sql, log_info=True, log_sql=False, commit=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """
        
        if log_sql:
            self.log_info(sql)        
        rows = self.dao.get_rows(sql, commit=commit)   
        self.last_error = self.dao.last_error 
        if not rows:
            # Check if any error has been raised
            if self.last_error:                  
                self.show_warning_detail(self.log_codes[-1], str(self.last_error))  
            elif self.last_error is None and log_info:
                self.log_info("Any record found", parameter=sql)                      		

        return rows  
    
            
    def execute_sql(self, sql, search_audit=True, log_sql=False, log_error=False, commit=True):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            self.log_info(sql)        
        result = self.dao.execute_sql(sql, commit=commit)
        self.last_error = self.dao.last_error         
        if not result:
            if log_error:
                self.log_info(sql)
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))
            return False
        else:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit(commit=commit)

        return True


    def execute_returning(self, sql, search_audit=True, log_sql=False, log_error=False):
        """ Execute SQL. Check its result in log tables, and show it to the user """

        if log_sql:
            self.log_info(sql)
        value = self.dao.execute_returning(sql)
        self.last_error = self.dao.last_error
        if not value:
            if log_error:
                self.log_info(sql)
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))
            return False
        else:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit()

        return value
           
    def execute_insert_or_update(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute INSERT or UPDATE sentence. Used for PostgreSQL database versions <9.5 """
         
        # Check if we have to perfrom an INSERT or an UPDATE
        if unique_value != 'current_user':
            unique_value = "'" + unique_value + "'"
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        sql += " WHERE " + str(unique_field) + " = " + unique_value 
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
            sql = " INSERT INTO " + self.schema_name + "." + tablename + "(" + unique_field + ", "  
            sql += sql_fields[:-2] + ") VALUES ("   
              
            # Manage value 'current_user'   
            if unique_value != 'current_user':
                unique_value = "'" + unique_value + "'" 
            sql += unique_value + ", " + sql_values[:-2] + ");"         
        
        # Perform an UPDATE
        else: 
            # Set SQL for UPDATE
            sql = " UPDATE " + self.schema_name + "." + tablename
            sql += " SET ("
            sql += sql_fields[:-2] + ") = (" 
            sql += sql_values[:-2] + ")" 
            sql += " WHERE " + unique_field + " = " + unique_value          
            
        # Execute sql
        self.log_info(sql)
        result = self.dao.execute_sql(sql, commit=commit)
        self.last_error = self.dao.last_error         
        if not result:
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))    
            return False

        return True
               
            
    def execute_upsert(self, tablename, unique_field, unique_value, fields, values, commit=True):
        """ Execute UPSERT sentence """
         
        # Check PostgreSQL version
        if not self.postgresql_version:
            self.get_postgresql_version()

        if int(self.postgresql_version) < 90500:   
            self.execute_insert_or_update(tablename, unique_field, unique_value, fields, values, commit=commit)
            return True
         
        # Set SQL for INSERT               
        sql = " INSERT INTO " + self.schema_name + "." + tablename + "(" + unique_field + ", "  
        
        # Iterate over fields
        sql_fields = "" 
        for fieldname in fields:
            sql_fields += fieldname + ", "
        sql += sql_fields[:-2] + ") VALUES ("   
          
        # Manage value 'current_user'   
        if unique_value != 'current_user':
            unique_value = "'" + unique_value + "'" 
            
        # Iterate over values            
        sql_values = ""
        for value in values:
            if value != 'current_user':
                sql_values += "'" + value + "', "
            else:
                sql_values += value + ", "
        sql += unique_value + ", " + sql_values[:-2] + ")"         
        
        # Set SQL for UPDATE
        sql += " ON CONFLICT (" + unique_field + ") DO UPDATE"
        sql += " SET ("
        sql += sql_fields[:-2] + ") = (" 
        sql += sql_values[:-2] + ")" 
        sql += " WHERE " + tablename + "." + unique_field + " = " + unique_value          
        
        # Execute UPSERT
        self.log_info(sql)
        result = self.dao.execute_sql(sql, commit=commit)
        self.last_error = self.dao.last_error         
        if not result:
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))    
            return False

        return True
    
    
    def get_error_from_audit(self, commit=True):
        """ Get last error from audit tables that has not been showed to the user """
        
        if self.schema_name is None:
            return                  
        
        sql = ("SELECT audit_function_actions.id, error_message, log_level, show_user"
               " FROM " + self.schema_name + ".audit_function_actions"
               " INNER JOIN " + self.schema_name + ".audit_cat_error"
               " ON audit_function_actions.audit_cat_error_id = audit_cat_error.id"
               " WHERE audit_cat_error.id != 0 AND debug_info is null"
               " ORDER BY audit_function_actions.id DESC LIMIT 1")
        result = self.dao.get_row(sql, commit=commit)
        if result is not None:
            if result['log_level'] <= 2:
                sql = "UPDATE "+self.schema_name+".audit_function_actions"
                sql += " SET debug_info = 'showed'"
                sql+= " WHERE id = "+str(result['id'])
                self.dao.execute_sql(sql, commit=commit)
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
            
            
    def translate_widget(self, context_name, widget):
        """ Translate widget text """
        
        if not widget:
            return
        
        if type(widget) is QTabWidget:
            num_tabs = widget.count()
            for i in range(0, num_tabs):
                tab_page = widget.widget(i)
                widget_name = tab_page.objectName()                   
                text = self.tr(widget_name, context_name)  
                if text != widget_name:                              
                    widget.setTabText(i, text)
            
        else:  
            widget_name = widget.objectName()  
            text = self.tr(widget_name, context_name)
            if text != widget_name:
                widget.setText(text)    
                
                        
    def start_program(self, program):     
        """ Start an external program (hidden) """
           
        SW_HIDE = 0
        info = subprocess.STARTUPINFO()
        info.dwFlags = subprocess.STARTF_USESHOWWINDOW
        info.wShowWindow = SW_HIDE
        subprocess.Popen(program, startupinfo=info)   
        
        
    def get_layer_by_layername(self, layername, log_info=False):
        """ Get layer with selected @layername (the one specified in the TOC) """
        
        layer = QgsMapLayerRegistry.instance().mapLayersByName(layername)
        if layer:         
            layer = layer[0] 
        elif layer is None and log_info:
            self.log_info("Layer not found", parameter=layername)        
            
        return layer     
            
        
    def get_layer_by_tablename(self, tablename, show_warning=False, log_info=False):
        """ Iterate over all layers and get the one with selected @tablename """
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
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
    
        
    def get_layer_by_nodetype(self, nodetype_id, show_warning=False, log_info=False):
        """ Get layer related with selected @nodetype_id """
        
        layer = None
        sql = ("SELECT sys_feature_cat.tablename"
               " FROM " + self.schema_name + ".node_type"
               " INNER JOIN " + self.schema_name + ".sys_feature_cat"
               " ON node_type.type = sys_feature_cat.id"
               " WHERE node_type.id = '" + nodetype_id + "'")
        row = self.get_row(sql)
        if row:
            tablename = row[0]
            layer = self.get_layer_by_tablename(tablename)
        
        if layer is None and show_warning:
            self.show_warning("Layer not found", parameter=tablename)
                           
        if layer is None and log_info:
            self.log_info("Layer not found", parameter=tablename)
                                      
        return layer  
                     
        
    def get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        # Initialize variables
        layer_source = {'db': None, 'schema': None, 'table': None, 
                        'host': None, 'port': None, 'user': None, 'password': None}
        
        # Get dbname, host, port, user and password
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_db = uri.find('dbname=')
        pos_host = uri.find(' host=')
        pos_port = uri.find(' port=')
        pos_user = uri.find(' user=')
        pos_password = uri.find(' password=')
        pos_sslmode = uri.find(' sslmode=')        
        if pos_db <> -1 and pos_host <> -1:
            uri_db = uri[pos_db + 8:pos_host - 1]
            layer_source['db'] = uri_db     
        if pos_host <> -1 and pos_port <> -1:
            uri_host = uri[pos_host + 6:pos_port]     
            layer_source['host'] = uri_host     
        if pos_port <> -1:
            if pos_user <> -1:
                pos_end = pos_user
            elif pos_sslmode <> -1:
                pos_end = pos_sslmode
            uri_port = uri[pos_port + 6:pos_end]     
            layer_source['port'] = uri_port               
        if pos_user <> -1 and pos_password <> -1:
            uri_user = uri[pos_user + 7:pos_password - 1]
            layer_source['user'] = uri_user     
        if pos_password <> -1 and pos_sslmode <> -1:
            uri_password = uri[pos_password + 11:pos_sslmode - 1]     
            layer_source['password'] = uri_password                     
         
        # Get schema and table or view name     
        pos_table = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_table <> -1 and pos_fi <> -1:
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
        if pos_ini <> -1 and pos_fi <> -1:
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
        if pos_ini <> -1:
            uri_pk = uri[pos_ini + 5:pos_end-2]

        return uri_pk
        
   
    def get_project_user(self):
        """ Set user """
        return self.user   
    

    def log_message(self, text=None, message_level=0, context_name=None, parameter=None):
        """ Write message into QGIS Log Messages Panel with selected message level
            @message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} 
        """
        msg = None
        if text:
            msg = self.tr(text, context_name)
            if parameter:
                msg += ": " + str(parameter)            
        QgsMessageLog.logMessage(msg, self.plugin_name, message_level)
        

    def log_info(self, text=None, context_name=None, parameter=None):
        """ Write information message into QGIS Log Messages Panel """
        self.log_message(text, 0, context_name, parameter=parameter)      


    def log_warning(self, text=None, context_name=None, parameter=None):
        """ Write warning message into QGIS Log Messages Panel """
        self.log_message(text, 1, context_name, parameter=parameter)   
        
     
    def add_translator(self, locale_path):
        """ Add translation file to the list of translation files to be used for translations """
        
        if os.path.exists(locale_path):        
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)
            #self.log_info("Add translator", parameter=locale_path)
        else:
            self.log_info("Locale not found", parameter=locale_path)
            
                    
    def manage_translation(self, locale_name, dialog=None):  
        """ Manage locale and corresponding 'i18n' file """ 
        
        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'
            
        # If user locale file not found, set English one by default
        locale_path = os.path.join(self.plugin_dir, 'i18n', locale_name+'_{}.qm'.format(locale))
        if not os.path.exists(locale_path):
            self.log_info("Locale not found", parameter=locale_path)
            locale_default = 'en'
            locale_path = os.path.join(self.plugin_dir, 'i18n', locale_name+'_{}.qm'.format(locale_default))
            # If English locale file not found, just log it
            if not os.path.exists(locale_path):            
                self.log_info("Locale not found", parameter=locale_path)            
        
        # Add translation file
        self.add_translator(locale_path) 
        
        # If dialog is set, then translate form
        if dialog:
            self.translate_form(dialog, locale_name)                              
      
      
    def get_project_type(self):
        """ Get water software from table 'version' """
        
        project_type = None
        sql = ("SELECT lower(wsoftware)"
               " FROM " + self.schema_name + ".version ORDER BY id DESC LIMIT 1")
        row = self.get_row(sql)
        if row:
            project_type = row[0]
            
        return project_type
    
    
    def check_function(self, function_name):
        """ Check if @function_name exists """
        
        schema_name = self.schema_name.replace('"', '')
        sql = ("SELECT routine_name FROM information_schema.routines"
               " WHERE lower(routine_schema) = '" + schema_name + "'"
               " AND lower(routine_name) = '" + function_name + "'")
        row = self.get_row(sql, log_info=False)
        return row
    
    
    def check_table(self, tablename):
        """  Check if selected table exists in selected schema """
        return self.dao.check_table(self.schema_name, tablename)
    

    def get_group_layers(self, geom_type):
        """ Get layers of the group @geom_type """
        
        list_items = []        
        sql = ("SELECT tablename FROM " + self.schema_name + ".sys_feature_cat"
               " WHERE type = '" + geom_type.upper() + "'")
        rows = self.get_rows(sql)
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
    
    
    def check_role_user(self, role_name):
        """ Check if current user belongs to @role_name """
        
        if not self.check_role(role_name):
            return True
        
        sql = ("SELECT pg_has_role('" + self.user + "', '" + role_name + "', 'MEMBER');")
        row = self.get_row(sql)
        return row[0]
         
         
    def get_current_user(self):
        """ Get current user connected to database """
        
        sql = ("SELECT current_user")
        row = self.get_row(sql)
        cur_user = ""
        if row:
            cur_user = str(row[0])
            
        return cur_user
    
    
    def get_rolenames(self):
        """ Get list of rolenames of current user """
        
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
        
        role_admin = False
        role_master = self.check_role_user("rol_master")
        role_epa = self.check_role_user("rol_epa")
        role_edit = self.check_role_user("rol_edit")
        role_om = self.check_role_user("rol_om")
        
        if role_admin:
            pass
        elif role_master:
            self.giswater.enable_toolbar("utils")
            self.giswater.enable_toolbar("master")
            self.giswater.enable_toolbar("epa")
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
            if self.giswater.wsoftware == 'ws':            
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':                
                self.giswater.enable_toolbar("om_ud")
        elif role_epa:
            self.giswater.enable_toolbar("utils")            
            self.giswater.enable_toolbar("epa")
        elif role_edit:
            self.giswater.enable_toolbar("utils")            
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
        elif role_om:
            self.giswater.enable_toolbar("utils")            
            if self.giswater.wsoftware == 'ws':            
                self.giswater.enable_toolbar("om_ws")
            elif self.giswater.wsoftware == 'ud':                
                self.giswater.enable_toolbar("om_ud")
        
    
    def get_value_config_param_system(self, parameter, show_warning=True):
        """ Get value of @parameter from table 'config_param_system' """
        
        value = None
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_system"
               " WHERE parameter = '" + parameter + "'") 
        row = self.get_row(sql)
        if row:
            value = row[0]
        elif not row and show_warning:
            message = "Parameter not found in table 'config_param_system'"
            self.show_warning(message, parameter=parameter)
            return value           
        
        return value


    def get_columns_list(self, tablename):
        """  Return list of all columns in @tablename """
        sql = ("SELECT column_name FROM information_schema.columns"
               " WHERE table_name = '" + tablename + "'"
               " AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               " ORDER BY ordinal_position")
        column_name = self.get_rows(sql)
        return column_name
