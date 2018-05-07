"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os

import utils_giswater
from ui_manager import Multirow_selector
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
                
        self.dlg = Multirow_selector()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)

        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.rejected.connect(self.close_dialog)
        self.dlg.setWindowTitle("Explotation selector")
        utils_giswater.setWidgetText(self.dlg.lbl_filter, self.controller.tr('Filter by: Exploitation name', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg.lbl_unselected, self.controller.tr('Unselected exploitations', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg.lbl_selected, self.controller.tr('Selected exploitations', context_name='labels'))

        tableleft = "exploitation"
        tableright = "selector_expl"
        field_id_left = "expl_id"
        field_id_right = "expl_id"
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)

        # Open dialog
        self.open_dialog(self.dlg, maximize_button=False)


    def basic_state_selector(self):
        """ Button 48: State selector """
            
        # Create the dialog and signals
        self.dlg = Multirow_selector()
        self.load_settings(self.dlg)
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.rejected.connect(self.close_dialog)
        self.dlg.txt_name.setVisible(False)
        self.dlg.setWindowTitle("State selector")
        utils_giswater.setWidgetText(self.dlg.lbl_unselected, self.controller.tr('Unselected states', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg.lbl_selected, self.controller.tr('Selected states', context_name='labels'))
        tableleft = "value_state"
        tableright = "selector_state"
        field_id_left = "id"
        field_id_right = "state_id"
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
        
        # Open dialog
        self.open_dialog(self.dlg, maximize_button=False)
        

    def basic_search_plus(self):   
        """ Button 32: Open search plus dialog """
                
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
     
     
    def close_dialog(self):   
        
        ParentAction.close_dialog(self)
        self.search_plus.refresh_data()
        