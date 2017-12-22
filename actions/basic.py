"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QSettings
import os
import sys

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.multirow_selector import Multirow_selector         
from ui.db_login import DbLogin

from parent import ParentAction


class Basic(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """
        self.minor_version = "3.0"
        self.search_plus = None
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.logged = False
        self.login_file = os.path.join(self.plugin_dir, 'config', 'login.auth')        
        

    def set_giswater(self, giswater):
        self.giswater = giswater
        
        
    def set_project_type(self, project_type):
        self.project_type = project_type


    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """
        
        # Check if user is already logged
        if not self.logged:
            if not self.manage_login():
                return
                
        self.dlg = Multirow_selector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.setWindowTitle("Explotation selector")
        tableleft = "exploitation"
        tableright = "selector_expl"
        field_id_left = "expl_id"
        field_id_right = "expl_id"
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
        self.dlg.exec_()


    def basic_state_selector(self):
        """ Button 48: State selector """

        # Check if user is already logged
        if not self.logged:
            if not self.manage_login():
                return
            
        # Create the dialog and signals
        self.dlg = Multirow_selector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.setWindowTitle("State selector")
        tableleft = "value_state"
        tableright = "selector_state"
        field_id_left = "id"
        field_id_right = "state_id"
        self.dlg.txt_name.setVisible(False)
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
        self.dlg.exec_()
        

    def basic_search_plus(self):   
        """ Button 32: Open search plus dialog """
        
        # Check if user is already logged
        if not self.logged:
            if not self.manage_login():
                return
                
        try:
            if self.search_plus is not None:  
                if self.search_plus.dlg.tab_main.count() > 0:
                    # Manage 'i18n' of the form and make it visible
                    self.controller.translate_form(self.search_plus.dlg, 'search_plus')                            
                    self.search_plus.dock_dialog()
                else:
                    message = "Search Plus: Any layer has been found. Check parameters in table 'config_param_system'"
                    self.controller.show_warning(message, duration=20)   
        except RuntimeError:
            pass
        
        
    def manage_login(self):
        """ Manage username and his permissions """
                    
        # Check if file that contains login parameters for current user already exists       
        status = False 
        if os.path.exists(self.login_file):
            # Get username and password from this file
            login_settings = QSettings(self.login_file, QSettings.IniFormat)
            login_settings.setIniCodec(sys.getfilesystemencoding())
            username = login_settings.value('username')
            password = login_settings.value('password')             
                   
            # Connect to database
            status = self.connect_to_database(username, password)  
            if not status:
                # Open dialog asking for username and password
                self.show_login_dialog()
            
        else:       
            message = "Login file not found"
            self.controller.log_info(message, parameter=self.login_file)                 
            # Open dialog asking for username and password
            self.show_login_dialog()
        
        return status
    
    
    def show_login_dialog(self):
        """ Show login dialog either because login_file not found 
            or because login is not valid 
        """
        # Open dialog asking for username and password
        self.dlg_db = DbLogin()
        utils_giswater.setDialog(self.dlg_db)        
        self.dlg_db.btn_accept.pressed.connect(self.manage_login_accept)      
        self.dlg_db.exec_()    
                    
        
    def manage_login_accept(self):
        """ Get username and password from dialog. 
            Connect to database and check permissions 
        """      
        
        # Get username and password from dialog
        username = utils_giswater.getWidgetText("username")
        password = utils_giswater.getWidgetText("password")
        
        # Connect to database
        status = self.connect_to_database(username, password)               
        if status:                
            f = open(self.login_file, "w")                             
            f.write("username=" + str(username) + "\n")  
            f.write("password=" + str(password))  
            f.close()  
            # Close login dialog
            self.close_dialog(self.dlg_db)  
        else:
            # Prompt for new login parameters
            utils_giswater.setWidgetText("password", "")                         
        
        
    def connect_to_database(self, username, password):
        """ Connect to database with selected @username and @password 
            host, port and db will be get from layer 'version'
        """
        
        # Get database parameters from layer 'version'
        layer = self.controller.get_layer_by_layername("version")
        if not layer:
            self.controller.show_warning("Layer not found", parameter="version")
            return False
        
        # Connect to database
        layer_source = self.controller.get_layer_source(layer)
        connection_status = self.controller.connect_to_database(layer_source['host'], layer_source['port'], layer_source['db'], username, password)
        if not connection_status:
            msg = self.controller.last_error  
            self.controller.show_warning(msg, 15) 
            return False
        
        # Check roles of this user to show or hide toolbars        
        self.check_user_roles()
        
        self.logged = True   
        
        return True      
        
        
    def check_user_roles(self):
        """ Check roles of this user to show or hide toolbars """
        
        #role_epa = self.controller.check_role_user("rol_epa", username)
        role_admin = False
        role_master = True
        role_epa = True
        role_edit = True
        role_om = True
        
        if role_admin:
            pass
        elif role_master:
            self.giswater.enable_toolbar("master")
            self.giswater.enable_toolbar("epa")
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
            if self.giswater.wsoftware == 'ws':            
                self.giswater.enable_toolbar("om_ws")
            elif self.wsoftware == 'ud':                
                self.giswater.enable_toolbar("om_ud")
        elif role_epa:
            self.giswater.enable_toolbar("epa")
        elif role_edit:
            self.giswater.enable_toolbar("edit")
            self.giswater.enable_toolbar("cad")
        elif role_om:
            if self.giswater.wsoftware == 'ws':            
                self.giswater.enable_toolbar("om_ws")
            elif self.wsoftware == 'ud':                
                self.giswater.enable_toolbar("om_ud")
        
