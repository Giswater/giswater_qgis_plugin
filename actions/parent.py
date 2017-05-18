'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCursor, QFileDialog

import os
import sys
import webbrowser

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater    


class ParentAction():


    def __init__(self, iface, settings, controller, plugin_dir):  
        ''' Class constructor '''

        # Initialize instance attributes
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao         
        self.schema_name = self.controller.schema_name  
          
        # Get files to execute giswater jar              
        self.gsw_file = self.controller.plugin_settings_value('gsw_file')   
       
       
    def get_java_exe(self):
        ''' Get executable Java file from windows registry '''

        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\JavaSoft\Java Runtime Environment"
        reg_name = "CurrentVersion"
        java_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        
        # Check if java version exists
        if java_version is None:
            message = "Cannot get current Java version from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None
      
        reg_path+= "\\"+java_version
        reg_name = "JavaHome"
        java_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if java_folder is None:
            message = "Cannot get Java folder from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None         

        # Check if java folder exists
        if not os.path.exists(java_folder):
            message = "Java folder not found at: "+java_folder
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None  

        # Check if java executable file exists
        java_exe = java_folder+"/bin/java.exe"
        if not os.path.exists(java_exe):
            message = "Java executable file not found at: "+java_exe
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None  
                
        return java_exe
    

    def execute_giswater(self, parameter, index_action):
        ''' Executes giswater with selected parameter '''

        # Get giswater information from windows registry
        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\\Giswater\\2.1"
        reg_name = "InstallFolder"
        giswater_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if giswater_folder is None:
            message = "Cannot get giswater folder from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return
            
        # Check if giswater folder exists
        if not os.path.exists(giswater_folder):
            message = "Giswater folder not found at: "+giswater_folder
            self.controller.show_warning(message, 10, context_name='ui_message')
            return          
            
        # Check if giswater executable file file exists
        giswater_jar = giswater_folder+"\giswater.jar"
        if not os.path.exists(giswater_jar):
            message = "Giswater executable file not found at: "+giswater_jar
            self.controller.show_warning(message, 10, context_name='ui_message')
            return      
        
        # Get executable Java file from windows registry
        java_exe = self.get_java_exe()
        if java_exe is None:
            return       
        
        # Check if gsw file exists. If not giswater will open with the last .gsw file
        if self.gsw_file != "" and not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.gsw_file
            self.controller.show_info(message, 10, context_name='ui_message')
            self.gsw_file = ""          
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, index_action)                
        
        # Start program     
        aux = '"'+giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            program = [java_exe, "-jar", giswater_jar, self.gsw_file, parameter]
        else:
            program = [java_exe, "-jar", giswater_jar, "", parameter]
            
        self.controller.start_program(program)               
        
        # Show information message    
        message = "Executing... "+aux
        self.controller.show_info(message, context_name='ui_message')
        
        
    def open_web_browser(self, widget):
        ''' Display url using the default browser '''
        
        url = utils_giswater.getWidgetText(widget) 
        if url == 'null':
            url = 'www.giswater.org'
            webbrowser.open(url)
        else:
            webbrowser.open(url)        
                
                
    def open_file_dialog(self, widget):
        ''' Open File Dialog '''
        
        # Get default value from widget
        file_path = utils_giswater.getWidgetText(widget)

        # Set default value if necessary
        if file_path == 'null': 
            file_path = self.plugin_dir
                
        # Check if file exists
        if not os.path.exists(file_path):
            message = "File path doesn't exist"
            self.controller.show_warning(message, 10, context_name='ui_message')
            file_path = self.plugin_dir
                
        # Get directory of that file
        folder_path = os.path.dirname(file_path)
        self.controller.show_warning("folder_path: "+folder_path)
        os.chdir(folder_path)
        msg = "Select file"
        file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "")

        # Separate path to components
        abs_path = os.path.split(file_path)

        # Set text to QLineEdit
        widget.setText(abs_path[0]+'/')
                        
