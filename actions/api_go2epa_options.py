"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QGroupBox, QSpacerItem, QSizePolicy, QGridLayout, QWidget, QComboBox

import json
from collections import OrderedDict
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent
from ..ui_manager import ApiEpaOptions


class Go2EpaOptions(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.epa_options_list = []


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa_options(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Clear list
        self.epa_options_list = []
        
        # Create dialog
        self.dlg_options = ApiEpaOptions()
        self.load_settings(self.dlg_options)

        form = '"formName":"epaoptions"'
        body = self.create_body(form=form)
        # Get layers under mouse clicked
        sql = f"SELECT gw_api_getconfig($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.construct_form_param_user(self.dlg_options, complet_result[0]['body']['form']['formTabs'], 0, self.epa_options_list)
        grbox_list = self.dlg_options.findChildren(QGroupBox)
        for grbox in grbox_list:
            widget_list = grbox.findChildren(QWidget)
            if len(widget_list) == 0:
                grbox.setVisible(False)
            else:
                gridlist = grbox.findChildren(QGridLayout)
                for grl in gridlist:
                    spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                    grl.addItem(spacer)

        # Event on change from combo parent
        self.get_event_combo_parent(complet_result)
        self.dlg_options.btn_accept.clicked.connect(partial(self.update_values, self.epa_options_list))
        self.dlg_options.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_options))

        self.open_dialog(self.dlg_options)


    def update_values(self, _json):

        my_json = json.dumps(_json)
        form = '"formName":"epaoptions"'
        extras = f'"fields":{my_json}'
        body = self.create_body(form=form, extras=extras)
        sql = f"SELECT gw_api_setconfig($${{{body}}}$$)"
        self.controller.execute_sql(sql, log_sql=True, commit=True)
        message = "Values has been updated"
        self.controller.show_info(message)
        # Close dialog
        self.close_dialog(self.dlg_options)


    def get_event_combo_parent(self, complet_result):
        # complet_result[0]['body']['form']['formTabs']
        for field in complet_result[0]['body']['form']['formTabs'][0]["fields"]:
            if field['isparent']:
                widget = self.dlg_options.findChild(QComboBox, field['widgetname'])
                widget.currentIndexChanged.connect(partial(self.fill_child, widget))


    def fill_child(self, widget):

        combo_parent = widget.objectName()
        combo_id = utils_giswater.get_item_data(self.dlg_options, widget)
        sql = f"SELECT gw_api_get_combochilds('epaoptions', '', '', '{combo_parent}', '{combo_id}', '')"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.manage_child(widget, combo_child)


    def manage_child(self, combo_parent, combo_child):
        child = self.dlg_options.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            child.setEnabled(True)
            self.populate_combo(child, combo_child)
            utils_giswater.set_combo_itemData(child, combo_child['selectedId'], 1)
            if 'editability' not in combo_child:
                return
            if int(utils_giswater.get_item_data(self.dlg_options, combo_parent, 0)) in combo_child['editability']['trueWhenParentIn']:
                child.setEnabled(True)
            else:
                child.setEnabled(False)


