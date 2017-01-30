# -*- coding: utf-8 -*-
from PyQt4.QtCore import QCoreApplication, QSettings   
from PyQt4.QtGui import QCheckBox, QLabel, QMessageBox
from PyQt4.QtSql import QSqlDatabase

import subprocess

from dao.pg_dao import PgDao


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
    
    def set_settings(self, settings):
        self.settings = settings      
        
    def set_plugin_name(self, plugin_name):
        self.plugin_name = plugin_name
    
    
    def set_database_connection(self):
        
        # Initialize variables
        self.dao = None 
        self.last_error = None      
        self.connection_name = self.settings.value('db/connection_name', self.plugin_name)
        self.schema_name = self.settings.value('db/schema_name')
        self.log_codes = {}
        
        # Look for connection data in QGIS configuration (if exists)    
        qgis_settings = QSettings()     
        root_conn = "/PostgreSQL/connections/"          
        qgis_settings.beginGroup(root_conn);           
        groups = qgis_settings.childGroups();                                
        if self.connection_name in groups:      
            root = self.connection_name+"/"  
            host = qgis_settings.value(root+"host", '')
            port = qgis_settings.value(root+"port", '')            
            db = qgis_settings.value(root+"database", '')
            self.user = qgis_settings.value(root+"username", '')
            pwd = qgis_settings.value(root+"password", '') 
            # We need to create this connections for Table Views
            self.db = QSqlDatabase.addDatabase("QPSQL")
            self.db.setHostName(host)
            self.db.setPort(int(port))
            self.db.setDatabaseName(db)
            self.db.setUserName(self.user)
            self.db.setPassword(pwd)
            self.status = self.db.open()    
            if not self.status:
                msg = "Database connection error"
                self.last_error = self.tr(msg)           
        else:
            msg = "Database connection name '"+self.connection_name+"' not set in QGIS. Please define it or check parameter 'configuration_name' in file 'giswater.config'"
            self.last_error = self.tr(msg)
            return False
    
        # Connect to Database 
        self.dao = PgDao()     
        self.dao.set_params(host, port, db, self.user, pwd)
        status = self.dao.init_db()
        
        # TODO: Get postgresql data folder
       
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
        ''' Show message to the user.
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.iface.messageBar().pushMessage("", self.tr(text, context_name), message_level, duration)  
        
            
    def show_info(self, text, duration=5, context_name=None):
        ''' Show message to the user.
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.show_message(text, 0, duration, context_name)
        
        
    def show_warning(self, text, duration=5, context_name=None):
        ''' Show message to the user.
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.show_message(text, 1, duration, context_name)
     
     
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
        ret = msg_box.exec_()
        if ret == QMessageBox.Ok:
            return True
        elif ret == QMessageBox.Discard:
            return False      
        
        
    def show_info_box(self, text, title=None, inf_text=None, context_name=None):
        ''' Ask question to the user '''   

        msg_box = QMessageBox()
        msg_box.setText(self.tr(text, context_name))
        if title is not None:
            msg_box.setWindowTitle(title);        
        if inf_text is not None:
            msg_box.setInformativeText(inf_text);        
        #msg_box.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        msg_box.setDefaultButton(QMessageBox.No)        
        ret = msg_box.exec_()
        '''
        if ret == QMessageBox.Ok:
            return True
        elif ret == QMessageBox.Discard:
            return False  
        '''                               
            
    def get_row(self, sql, search_audit=True):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        result = self.dao.get_row(sql)
        self.dao.commit()        
        if result is None:
            self.show_message(self.log_codes[-1], 2)   
            return False
        elif result != 0:
            if search_audit:
                # Get last record from audit tables (searching for a possible error)
                return self.get_error_from_audit()
          
        return True  
    
    
    def get_rows(self, sql):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        rows = self.dao.get_rows(sql)      
        if rows is None:
            self.show_warning(str(self.dao.last_error))   
            return False

        return rows  
    
            
    def execute_sql(self, sql, search_audit=True):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        result = self.dao.execute_sql(sql)
        if not result:         
            self.show_message(self.log_codes[-1], 2)   
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
        ''' Start a minimized external program '''
           
        SW_MINIMIZE = 6
        SW_HIDE = 0
        info = subprocess.STARTUPINFO()
        info.dwFlags = subprocess.STARTF_USESHOWWINDOW
        info.wShowWindow = SW_HIDE
        subprocess.Popen(program, startupinfo=info)   
        
        
    def get_layer_source(self, layer):
        ''' Get table or view name of selected layer '''

        uri_schema = None
        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini <> -1 and pos_fi <> -1:
            uri_schema = uri[pos_ini + 6:pos_end_schema]
            uri_table = uri[pos_ini + 6:pos_fi + 1]

        return uri_schema, uri_table                                 
      
      
    def get_layer_source_table_name(self, layer):
        ''' Get table or view name of selected layer '''

        uri_schema = None
        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini <> -1 and pos_fi <> -1:
            uri_schema = uri[pos_ini + 6:pos_end_schema]
            uri_table = uri[pos_end_schema+2:pos_fi ]

        return uri_table    
        
        
    def get_layer_source_key(self):
        ''' Get table or view name of selected layer '''

        uri_schema = None
        layer = self.iface.activeLayer()  
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('key=')
        pos_end_schema = uri.rfind('srid=')
        #pos_fi = uri.find('" ')
        #if pos_ini <> -1 and pos_fi <> -1:
        if pos_ini <> -1:
            uri_schema = uri[pos_ini + 6:pos_end_schema-3]

        return uri_schema
    
    
        
    def set_project_user(self):
        # Set user
        sql = "UPDATE "+self.schema_name+".rpt_selector_result"
        sql+= " SET cur_user = '"+self.user+"'"
        sql+= " WHERE id = '1'" 
        print sql
        self.dao.execute_sql(sql)  
   



    