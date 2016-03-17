# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport

from dao.pg_dao import PgDao


class DaoController():
    
    
    def getDao(self):
        return self.dao
        
    def getLastError(self):
        return self.last_error
        
    def getSchemaName(self):
        return self.schema_name
           
    def tr(self, message):
        return QCoreApplication.translate(self.plugin_name, message)                
    
    
    def setSettings(self, settings, plugin_name):
        self.settings = settings
        self.plugin_name = plugin_name
                
    
    def setDatabaseConnection(self):
        """ Look for connection data in QGIS configuration (if exists) """    
        
        # Initialize variables
        self.dao = None 
        self.last_error = None        
        self.connection_name = self.settings.value('db/connection_name', self.plugin_name)
        self.schema_name = self.settings.value('db/schema_name', 'ws')
        
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
       
        return status    
    
    