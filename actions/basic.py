"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from functools import partial

from .. import utils_giswater
from ..ui_manager import Multirow_selector, SelectorUi
from .api_search import ApiSearch
from .api_parent import ApiParent


class Basic(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """

        self.minor_version = "3.0"
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.login_file = os.path.join(self.plugin_dir, 'config', 'login.auth')
        self.logged = False
        self.api_search = None


    def set_giswater(self, giswater):
        self.giswater = giswater


    def set_project_type(self, project_type):
        self.project_type = project_type


    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """

        selector_values = f'{{"exploitation": {{"ids":[]}}}}'
        self.dlg_selector = SelectorUi()
        self.load_settings(self.dlg_selector)
        self.dlg_selector.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_selector))
        self.dlg_selector.rejected.connect(partial(self.save_settings, self.dlg_selector))
        self.get_selector(self.dlg_selector, selector_values)
        self.open_dialog(self.dlg_selector, dlg_name='selector', maximize_button=False)
		
		# call dynamic mapzones repaint
        row = self.controller.get_config('mapzones_dynamic_symbology', 'value', 'config_param_system')
        if row and row[0].lower() == 'true':
            if field_id_right == "expl_id":
                self.set_layer_simbology_polcategorized('v_edit_dma', 'name', 0.5)
                self.set_layer_simbology_polcategorized('v_edit_dqa', 'name', 0.5)
                self.set_layer_simbology_polcategorized('v_edit_presszone', 'descript', 0.5)

        self.refresh_map_canvas()


    def basic_state_selector(self):
        """ Button 48: State selector """
            
        # Create the dialog and signals
        self.dlg_state = Multirow_selector('state')
        self.load_settings(self.dlg_state)
        self.dlg_state.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_state))
        self.dlg_state.rejected.connect(partial(self.close_dialog, self.dlg_state))
        self.dlg_state.txt_name.setVisible(False)
        self.dlg_state.setWindowTitle("State selector")
        utils_giswater.setWidgetText(self.dlg_state, self.dlg_state.lbl_unselected, self.controller.tr('Unselected states', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_state, self.dlg_state.lbl_selected, self.controller.tr('Selected states', context_name='labels'))
        tableleft = "value_state"
        tableright = "selector_state"
        field_id_left = "id"
        field_id_right = "state_id"
        self.multi_row_selector(self.dlg_state, tableleft, tableright, field_id_left, field_id_right)
        
        # Open dialog
        self.open_dialog(self.dlg_state, maximize_button=False)


    def basic_hydrometer_state_selector(self):
        """ Button 86: Hydrometer selector """

        # Create the dialog and signals
        self.dlg_hydro_state = Multirow_selector('hydrometer')
        self.load_settings(self.dlg_hydro_state)
        self.dlg_hydro_state.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_hydro_state))
        self.dlg_hydro_state.rejected.connect(partial(self.close_dialog, self.dlg_hydro_state))
        self.dlg_hydro_state.txt_name.setVisible(False)
        self.dlg_hydro_state.setWindowTitle("Hydrometer selector")
        utils_giswater.setWidgetText(self.dlg_hydro_state, self.dlg_hydro_state.lbl_unselected, self.controller.tr('Unselected hydrometers', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_hydro_state, self.dlg_hydro_state.lbl_selected, self.controller.tr('Selected hydrometers', context_name='labels'))
        tableleft = "ext_rtc_hydrometer_state"
        tableright = "selector_hydrometer"
        field_id_left = "id"
        field_id_right = "state_id"
        self.multi_row_selector(self.dlg_hydro_state, tableleft, tableright, field_id_left, field_id_right)

        # Open dialog
        self.open_dialog(self.dlg_hydro_state, maximize_button=False)


    def basic_api_search(self):
        """ Button 32: ApiSearch """

        if self.api_search is None:
            self.api_search = ApiSearch(self.iface, self.settings, self.controller, self.plugin_dir)

        self.api_search.api_search()

