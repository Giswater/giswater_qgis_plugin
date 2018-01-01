"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
from parent import ParentAction
from actions.manage_visit import ManageVisit
from ui.config_om import ConfigOm


class Om(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)        


    def set_project_type(self, project_type):     
        self.project_type = project_type


    def om_add_visit(self):
        """ Button 64: Add visit """
        self.manage_visit.manage_visit()               


    def om_visit_management(self):
        """ Button 65: Visit management """
        # TODO:
        self.controller.log_info("om_visit_management")        


    def om_config(self):
        """ Button 96, 97: Config om """
            
        # Create the dialog and signals
        self.dlg = ConfigOm()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.om_config_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))
         
        if self.project_type == 'ws':
            self.dlg.tab_config.removeTab(2)
        elif self.project_type == 'ud':
            self.dlg.tab_config.removeTab(1)        

        self.dlg.exec_()             
        
    
    def om_config_accept(self):
        
        self.controller.log_info("om_config_accept")    
        
