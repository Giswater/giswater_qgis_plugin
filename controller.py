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
        self.schema_name = self.settings.value('db/schema_name', 'ws')
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
            self.last_error = self.tr('Database connection name not found. Please check configuration file')
            return False
    
        # Connect to Database 
        self.dao = PgDao()     
        self.dao.set_params(host, port, db, user, pwd)
        self.dao.set_schema_name(self.schema_name)
        status = self.dao.init_db()
        
        # Cache error message with log_code = -1 (uncatched error)
        self.get_error_message(-1)
        
        # TODO: Get postgresql data folder
       
        return status    
    
    
    def get_error_message(self, log_code_id):    
        ''' Get error message from selected error code '''
        sql = "SELECT message FROM "+self.schema_name+"_audit.log_code WHERE id = "+str(log_code_id)
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
        
        sql = "SELECT log_code.id, log_code.message, log_code.log_level, log_code.show_user "
        sql+= " FROM "+self.schema_name+"_audit.log_detail"
        sql+= " INNER JOIN "+self.schema_name+"_audit.log_code ON log_detail.log_code_id = log_code.id"
        sql+= " ORDER BY log_detail.id DESC LIMIT 1"
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
        
    