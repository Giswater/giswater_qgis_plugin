"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 21400 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QApplication, QAction
else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtWidgets import QApplication, QAction

import os
from functools import partial

import utils_giswater
from giswater.ui_manager import Multirow_selector
from giswater.actions.api_cf import ApiCF
from giswater.actions.api_search import ApiSearch
from giswater.actions.parent import ParentAction



class Basic(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.logged = False
        self.login_file = os.path.join(self.plugin_dir, 'config', 'login.auth')


    def set_giswater(self, giswater):
        self.giswater = giswater


    def set_project_type(self, project_type):
        self.project_type = project_type


    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """

        self.controller.restore_info()
        self.dlg_expoitation = Multirow_selector()
        self.load_settings(self.dlg_expoitation)

        self.dlg_expoitation.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_expoitation))
        self.dlg_expoitation.rejected.connect(partial(self.close_dialog, self.dlg_expoitation))
        self.dlg_expoitation.setWindowTitle("Explotation selector")
        utils_giswater.setWidgetText(self.dlg_expoitation, self.dlg_expoitation.lbl_filter, self.controller.tr('Filter by: Exploitation name', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_expoitation, self.dlg_expoitation.lbl_unselected, self.controller.tr('Unselected exploitations', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_expoitation, self.dlg_expoitation.lbl_selected, self.controller.tr('Selected exploitations', context_name='labels'))

        tableleft = "exploitation"
        tableright = "selector_expl"
        field_id_left = "expl_id"
        field_id_right = "expl_id"
        self.multi_row_selector(self.dlg_expoitation, tableleft, tableright, field_id_left, field_id_right)

        # Open dialog
        self.open_dialog(self.dlg_expoitation, maximize_button=False)


    def basic_state_selector(self):
        """ Button 48: State selector """
        self.controller.restore_info()
        # Create the dialog and signals
        self.dlg_state = Multirow_selector()
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
        """ Button 51: Hydrometer selector """
        self.controller.restore_info()
        # Create the dialog and signals
        self.dlg_hydro_state = Multirow_selector()
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
        """ Button 32: SearchPlus """
        self.controller.restore_info()
        self.api_search = ApiSearch(self.iface, self.settings, self.controller, self.plugin_dir)
        self.api_search.api_search()


    def basic_api_info(self):
        """ Button 37: ApiCf """
        self.controller.restore_epa_info()
        if self.controller.basic_api_cf is not None:
            self.controller.restore_basic_info()
            return

        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        self.controller.basic_api_cf = self.api_cf
        self.controller.api_on = True
        self.api_cf.api_info()

    # def go2epa_api_info(self):
    #     """ Button 199: Epa INP info """
    #     self.controller.restore_basic_info()
    #     if self.controller.epa_api_cf is not None:
    #         self.controller.restore_epa_info()
    #         return
    #
    #     self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
    #     self.controller.epa_api_cf = self.api_cf
    #     self.controller.api_on = True
    #     self.api_cf.api_info()

    def close_dialog(self, dlg):
        ParentAction.close_dialog(self, dlg)


