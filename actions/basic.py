"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

import os
import sys

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.multirow_selector import Multirow_selector       

from parent import ParentAction


class Basic(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        self.search_plus = None
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """
        
        dlg_multiexp = Multirow_selector()
        utils_giswater.setDialog(dlg_multiexp)
        dlg_multiexp.btn_ok.pressed.connect(dlg_multiexp.close)
        dlg_multiexp.setWindowTitle("Explotation selector")
        tableleft = "exploitation"
        tableright = "selector_expl"
        field_id_left = "expl_id"
        field_id_right = "expl_id"
        self.multi_row_selector(dlg_multiexp, tableleft, tableright, field_id_left, field_id_right)
        dlg_multiexp.exec_()


    def basic_state_selector(self):
        """ Button 48: State selector """

        # Create the dialog and signals
        dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(dlg_psector_sel)
        dlg_psector_sel.btn_ok.pressed.connect(dlg_psector_sel.close)
        dlg_psector_sel.setWindowTitle("State selector")
        tableleft = "value_state"
        tableright = "selector_state"
        field_id_left = "id"
        field_id_right = "state_id"
        dlg_psector_sel.txt_name.setVisible(False)
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.exec_()
        

    def basic_search_plus(self):   
        """ Button 32: Open search plus dialog """
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)
        
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
        
