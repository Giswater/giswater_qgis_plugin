"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QGroupBox, QSpacerItem, QSizePolicy, QGridLayout, QWidget, QComboBox

import json
from functools import partial

from ...lib import tools_qt
from ..utils.tools_giswater import create_body, close_dialog, load_settings, open_dialog
from ..ui.ui_manager import Go2EpaOptionsUi
from ... import global_vars
from ...lib.tools_qt import manage_child, construct_form_param_user


class GwGo2EpaOptions:

    def __init__(self):
        """ Class to control toolbar 'go2epa' """
        self.epa_options_list = []
        self.controller = global_vars.controller


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa_options(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Clear list
        self.epa_options_list = []

        # Create dialog
        self.dlg_options = Go2EpaOptionsUi()
        load_settings(self.dlg_options)

        form = '"formName":"epaoptions"'
        body = create_body(form=form)
        json_result = self.controller.get_json('gw_fct_getconfig', body)
        if not json_result:
            return False

        construct_form_param_user(
            self.dlg_options, json_result['body']['form']['formTabs'], 0, self.epa_options_list)
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
        self.get_event_combo_parent(json_result)
        self.dlg_options.btn_accept.clicked.connect(partial(self.update_values, self.epa_options_list))
        self.dlg_options.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_options))

        open_dialog(self.dlg_options, dlg_name='go2epa_options')


    def update_values(self, _json):

        my_json = json.dumps(_json)
        form = '"formName":"epaoptions"'
        extras = f'"fields":{my_json}'
        body = create_body(form=form, extras=extras)
        json_result = self.controller.get_json('gw_fct_setconfig', body)
        if not json_result:
            return False

        message = "Values has been updated"
        self.controller.show_info(message)
        # Close dialog
        close_dialog(self.dlg_options)


    def get_event_combo_parent(self, complet_result):

        for field in complet_result['body']['form']['formTabs'][0]["fields"]:
            if field['isparent']:
                widget = self.dlg_options.findChild(QComboBox, field['widgetname'])
                if widget:
                    widget.currentIndexChanged.connect(partial(self.fill_child, self.dlg_options, widget))


    def fill_child(self, dialog, widget):

        combo_parent = widget.objectName()
        combo_id = tools_qt.get_item_data(self.dlg_options, widget)
        json_result = self.controller.get_json('gw_fct_getcombochilds', f"'epaoptions', '', '', '{combo_parent}', '{combo_id}', ''")
        if not json_result:
            return False

        for combo_child in json_result['fields']:
            if combo_child is not None:
                manage_child(dialog, widget, combo_child)

