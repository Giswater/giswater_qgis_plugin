'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from qgis.utils import iface

from functools import partial
import os.path
import sys  

from controller import DaoController

from dao.pg_dao import PgDao
import os.path

from controller import DaoController
from PyQt4.QtCore import QSettings, Qt
from qgis.gui import QgsMessageBar


class ProjectCheck():   
    
    def __init__(self, iface, settings , controller, plugin_dir):
        ''' Constructor class '''   
        
        
        ''' Class to control Management toolbar actions '''    
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao             
        self.schema_name = self.controller.schema_name    
 
        self.init_config()
        
        
    def init_config(self):    
     
        # Initialize plugin directory
        print "project check init config"
        
            
    def check_layers(self):
        ''' Check if selected table exists in selected schema '''    
        # Get objects of type: QLabel
        print "call function check table"
        self.table_junction = 'man_junction'
        self.version = 'version'
        print self.schema_name
        print self.table_junction

        exist_table_junction = self.dao.check_table(self.schema_name, self.table_junction)
        
        if exist_table_junction:
            print "table junction EXIST"
        else:
            print "table junction DONT EXIST"
        
        exist_version = self.dao.check_table(self.schema_name, self.version)
        if exist_version:
            print "table version EXIST"
        else:
            print "table version DONT EXIST"
            
            
        if exist_table_junction == True and exist_version == True:
            print "all table exists"
        elif exist_table_junction == False and exist_version == False:
            print "user searching other project"
        else:
            # Show Message
            print "To use this project with Giswater layers man_junction and version must exist. Please check your project !"