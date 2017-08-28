'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QCoreApplication, QSettings, Qt 
from PyQt4.QtGui import QCheckBox, QLabel, QMessageBox, QPushButton
from PyQt4.QtSql import QSqlDatabase
from qgis.core import QgsMessageLog

import subprocess
from functools import partial

from pg_dao import PgDao


class DaoController():
    
    def __init__(self, settings, plugin_name, iface):
        self.settings = settings      
        self.plugin_name = plugin_name               
        self.iface = iface               
        
    def set_schema_name(self, schema_name):
        self.schema_name = schema_name  
    
    def tr(self, message, context_name=None):
        if context_name is None:
            context_name = self.plugin_name
        return QCoreApplication.translate(context_name, message)                            
    
    def set_qgis_settings(self, qgis_settings):
        self.qgis_settings = qgis_settings       
        
    def set_plugin_name(self, plugin_name):
        self.plugin_name = plugin_name
        
    def plugin_settings_value(self, key, default_value=""):
        key = self.plugin_name+"/"+key
        value = self.qgis_settings.value(key, default_value)
        return value    

    def plugin_settings_set_value(self, key, value):
        self.qgis_settings.setValue(self.plugin_name+"/"+key, value)            
    
    def set_actions(self, actions):
        self.actions = actions      
        
    def check_actions(self, check=True):
        ''' Utility to check/uncheck all actions '''
        for action_index, action in self.actions.iteritems():   #@UnusedVariable
            action.setChecked(check)    
                           
    def check_action(self, check=True, index=1):
        ''' Check/Uncheck selected action '''
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
        ''' Ser database connection '''
        
        # Initialize variables
        self.dao = None 
        self.last_error = None      
        self.connection_name = self.settings.value('db/connection_name', self.plugin_name)
        self.schema_name = self.plugin_settings_value('schema_name')
        self.log_codes = {}
        
        # Look for connection data in QGIS configuration (if exists)    
        connection_settings = QSettings()       
        root_conn = "/PostgreSQL/connections/"          
        connection_settings.beginGroup(root_conn);           
        groups = connection_settings.childGroups();                                 
        if self.connection_name in groups:      
        
            root = self.connection_name+"/"  
            host = connection_settings.value(root+"host", '')
            port = connection_settings.value(root+"port", '')            
            db = connection_settings.value(root+"database", '')
            self.user = connection_settings.value(root+"username", '')
            pwd = connection_settings.value(root+"password", '') 
                        
            # We need to create this connections for Table Views
            self.db = QSqlDatabase.addDatabase("QPSQL")
            self.db.setHostName(host)
            self.db.setPort(int(port))
            self.db.setDatabaseName(db)
            self.db.setUserName(self.user)
            self.db.setPassword(pwd)
            status = self.db.open() 
            
            # Connect to Database 
            self.dao = PgDao()     
            self.dao.set_params(host, port, db, self.user, pwd)
            status = self.dao.init_db()                 
            if not status:
                msg = "Database connection error. Please check connection parameters"
                self.last_error = self.tr(msg)
                return False           
        else:
            msg = "Database connection name not found. Please check configuration file 'giswater.config'"
            self.last_error = self.tr(msg)
            return False   
       
        return status    
    
    
    def get_error_message(self, log_code_id):    
        ''' Get error message from selected error code '''
        
        if self.schema_name is None:
            return       

        sql = "SELECT error_message"
        sql+= " FROM "+self.schema_name+".audit_cat_error"
        sql+= " WHERE id = "+str(log_code_id)
        result = self.dao.get_row(sql)  
        if result:
            self.log_codes[log_code_id] = result[0]    
        else:
            self.log_codes[log_code_id] = "Error message not found in the database: "+str(log_code_id)
        
    
    def show_message(self, text, message_level=1, duration=5, context_name=None):
        ''' Show message to the user with selected message level
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.iface.messageBar().pushMessage("", self.tr(text, context_name), message_level, duration)
        #QMessageBox.about(None, 'Ok', str(text))
            
    def show_info(self, text, duration=5, context_name=None):
        ''' Show information message to the user '''
        self.show_message(text, 0, duration, context_name)
        #QMessageBox.information(None, self.tr('Info', context_name), self.tr(text, context_name))

    def show_warning(self, text, duration=5, context_name=None):
        ''' Show warning message to the user '''
        self.show_message(text, 1, duration, context_name)
        #QMessageBox.warning(None, self.tr('Warning', context_name), self.tr(text, context_name))

    def show_warning_detail(self, text, detail_text, context_name=None):
        ''' Show warning message with a button to show more details '''  
        inf_text = "Press 'Show Me' button to get more details..."
        widget = self.iface.messageBar().createMessage(self.tr(text, context_name), self.tr(inf_text))
        button = QPushButton(widget)
        button.setText(self.tr("Show Me"))
        button.pressed.connect(partial(self.show_details, detail_text, self.tr('Warning details')))
        widget.layout().addWidget(button)
        self.iface.messageBar().pushWidget(widget, 1)        
    
    
    def show_details(self, detail_text, title=None, inf_text=None):
        ''' Shows a message box with detail information '''
        self.iface.messageBar().clearWidgets()        
        msg_box = QMessageBox()
        msg_box.setText(detail_text)
        if title is not None:
            msg_box.setWindowTitle(title);        
        if inf_text is not None:
            msg_box.setInformativeText(inf_text);    
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)        
        msg_box.exec_()                      
        
        
    def ask_question(self, text, title=None, inf_text=None, context_name=None):
        ''' Ask question to the user '''   

        msg_box = QMessageBox()
        msg_box.setText(self.tr(text, context_name))
        if title is not None:
            msg_box.setWindowTitle(title);        
        if inf_text is not None:
            msg_box.setInformativeText(inf_text);        
        msg_box.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        msg_box.setDefaultButton(QMessageBox.No)  
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        ret = msg_box.exec_()
        if ret == QMessageBox.Ok:
            return True
        elif ret == QMessageBox.Discard:
            return False      
        
        
    def show_info_box(self, text, title=None, inf_text=None, context_name=None):
        ''' Ask question to the user '''   

        msg_box = QMessageBox()
        msg_box.setText(self.tr(text, context_name))
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        if title is not None:
            msg_box.setWindowTitle(title);        
        if inf_text is not None:
            msg_box.setInformativeText(inf_text);        
        msg_box.setDefaultButton(QMessageBox.No)        
        ret = msg_box.exec_()   #@UnusedVariable
                          
            
    def get_row(self, sql, search_audit=True):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        result = self.dao.get_row(sql)
        self.dao.commit()        
        if result is None:
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))  
            return False
        elif result != 0:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit()
          
        return True  
    
    
    def get_rows(self, sql):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        rows = self.dao.get_rows(sql)   		

        return rows  
    
            
    def execute_sql(self, sql, search_audit=True):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        result = self.dao.execute_sql(sql)
        if not result:
            self.show_warning_detail(self.log_codes[-1], str(self.dao.last_error))    
            return False
        else:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit()    

        return True
    
    
    def get_error_from_audit(self):
        ''' Get last error from audit tables that has not been showed to the user '''
        
        if self.schema_name is None:
            return                  
        
        sql = "SELECT audit_function_actions.id, error_message, log_level, show_user "
        sql+= " FROM "+self.schema_name+".audit_function_actions"
        sql+= " INNER JOIN "+self.schema_name+".audit_cat_error ON audit_function_actions.audit_cat_error_id = audit_cat_error.id"
        sql+= " WHERE audit_cat_error.id != 0 AND debug_info is null"
        sql+= " ORDER BY audit_function_actions.id DESC LIMIT 1"
        result = self.dao.get_row(sql)
        if result is not None:
            if result['log_level'] <= 2:
                sql = "UPDATE "+self.schema_name+".audit_function_actions"
                sql+= " SET debug_info = 'showed'"
                sql+= " WHERE id = "+str(result['id'])
                self.dao.execute_sql(sql)
                if result['show_user']:
                    self.show_message(result['error_message'], result['log_level'])
                return False    
            elif result['log_level'] == 3:
                # Debug message
                pass
            
        return True
        
        
    def translate_form(self, dialog, context_name):
        ''' Translate widgets of the form to current language '''
        
        # Get objects of type: QLabel
        widget_list = dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
        # Get objects of type: QCheckBox
        widget_list = dialog.findChildren(QCheckBox)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
            
    def translate_widget(self, context_name, widget):
        ''' Translate widget text '''
        
        if widget:
            widget_name = widget.objectName()
            text = self.tr(widget_name, context_name)
            if text != widget_name:
                widget.setText(text)    
                
                        
    def start_program(self, program):     
        ''' Start an external program (hidden) '''
           
        SW_HIDE = 0
        info = subprocess.STARTUPINFO()
        info.dwFlags = subprocess.STARTF_USESHOWWINDOW
        info.wShowWindow = SW_HIDE
        subprocess.Popen(program, startupinfo=info)   
        
        
    def get_layer_source(self, layer):
        ''' Get database, schema and table or view name of selected layer '''

        # Initialize variables
        layer_source = {'db': None, 'schema': None, 'table': None, 'host': None, 'username': None}
        
        # Get database name, host and port
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini_db = uri.find('dbname=')
        pos_ini_host = uri.find(' host=')
        pos_ini_port = uri.find(' port=')
        if pos_ini_db <> -1 and pos_ini_host <> -1:
            uri_db = uri[pos_ini_db + 8:pos_ini_host - 1]
            layer_source['db'] = uri_db     
        if pos_ini_host <> -1 and pos_ini_port <> -1:
            uri_host = uri[pos_ini_host + 6:pos_ini_port]     
            layer_source['host'] = uri_host       
         
        # Get schema and table or view name     
        pos_ini_table = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini_table <> -1 and pos_fi <> -1:
            uri_schema = uri[pos_ini_table + 6:pos_end_schema]
            uri_table = uri[pos_end_schema + 2:pos_fi]
            layer_source['schema'] = uri_schema            
            layer_source['table'] = uri_table            

        return layer_source                                                             
    
      
    def get_layer_source_table_name(self, layer):
        ''' Get table or view name of selected layer '''

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
        
        
    def get_layer_primary_key(self):
        ''' Get primary key of selected layer '''
        
        uri_pk = None
        layer = self.iface.activeLayer()  
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('key=')
        pos_end = uri.rfind('srid=')
        if pos_ini <> -1:
            uri_pk = uri[pos_ini + 5:pos_end-2]

        return uri_pk
        
   
    def get_project_user(self):
        ''' Set user '''

        user = None
        #self.canvas = self.iface.mapCanvas() 
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        
        # Control current layer (due to QGIS bug in snapping system)
        #if self.canvas.currentLayer() == None:
        #    self.iface.setActiveLayer(layers[0])
        #layer = self.iface.activeLayer()  
        #uri = layer.dataProvider().dataSourceUri().lower()
        uri = layers[0].dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('user=')
        pos_end_schema = uri.rfind('password=')
        if pos_ini <> -1:
            user = uri[pos_ini + 6:pos_end_schema-2]

        return self.user   
    

    def log_message(self, text=None, message_level=0, context_name=None, 
                    log_to_file=True, stack_level=0, parameter=None):
        ''' Write message into QGIS Log Messages Panel with selected message level
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        msg = None
        if text is not None:
            msg = self.tr(text, context_name)
            if parameter is not None:
                msg+= ": "+parameter            
        QgsMessageLog.logMessage(msg, self.plugin_name, message_level)
        

    def log_info(self, text=None, context_name=None, stack_level=0, parameter=None):
        ''' Write information message into QGIS Log Messages Panel
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.log_message(text, 0, context_name, stack_level=stack_level, parameter=parameter)      


    def log_warning(self, text=None, context_name=None, stack_level=0, parameter=None):
        ''' Write warning message into QGIS Log Messages Panel
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.log_message(text, 1, context_name, stack_level=stack_level, parameter=parameter)          
        
            