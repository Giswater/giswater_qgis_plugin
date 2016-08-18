# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport

from dao.pg_dao import PgDao


class DaoController():
    
    def __init__(self, settings, plugin_name, iface):
        self.settings = settings      
        self.plugin_name = plugin_name               
        self.iface = iface               
        
    def getDao(self):
        return self.dao
        
    def get_last_error(self):
        return self.last_error
        
    def get_schema_name(self):
        return self.schema_name
        
    def set_schema_name(self, schema_name):
        self.schema_name = schema_name
    
    def tr(self, message):
        return QCoreApplication.translate(self.plugin_name, message)                
    
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
            user = qgis_settings.value(root+"username", '')
            pwd = qgis_settings.value(root+"password", '') 
        else:
            msg = "Database connection name '"+self.connection_name+"' not set in QGIS. Please define it or check parameter 'configuration_name' in file 'giswater.config'"
            self.last_error = self.tr(msg)
            return False
    
        # Connect to Database 
        self.dao = PgDao()     
        self.dao.set_params(host, port, db, user, pwd)
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
        
    
    def show_message(self, text, message_level=1, duration=5):
        ''' Show message to the user.
        message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3} '''
        self.iface.messageBar().pushMessage("", text, message_level, duration)      
                            
            
    def get_row(self, sql):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        #self.logger.info(sql)
        result = self.dao.get_row(sql)
        self.dao.commit()        
        if result is None:
            self.show_message(self.log_codes[-1], 2)   
            return False
        elif result != 0:
            # If we have found an error, then get last record from audit tables
            return self.get_error_from_audit()
          
        return True  
    
            
    def execute_sql(self, sql):
        ''' Execute SQL. Check its result in log tables, and show it to the user '''
        
        result = self.dao.execute_sql(sql)
        if not result:            
            self.show_message(self.log_codes[-1], 2)   
            return False
        else:
            # Get last record from audit tables (searching for a possible error)
            return self.get_error_from_audit()    
    
    
    def get_error_from_audit(self):
        ''' Get last error from audit tables '''
        
        if self.schema_name is None:
            return                  
        
        sql = "SELECT audit_cat_error.id, error_message, log_level, show_user "
        sql+= " FROM "+self.schema_name+".audit_function_actions"
        sql+= " INNER JOIN "+self.schema_name+".audit_cat_error ON audit_function_actions.audit_cat_error_id = audit_cat_error.id"
        sql+= " ORDER BY audit_function_actions.id DESC LIMIT 1"
        result = self.dao.get_row(sql)
        if result is None:
            self.show_message(self.log_codes[-1], 2)
            return False    
        else:        
            if result['log_level'] <= 2:
                if result['show_user']:
                    self.show_message(result['message'], result['log_level'])
                return False    
            elif result['log_level'] == 3:
                # Debug message
                pass
        
        return True
        
    