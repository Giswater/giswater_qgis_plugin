"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QRegExp
from PyQt4.QtGui import QRegExpValidator

try:
    from qgis.core import Qgis as Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import QDate
    from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QSpacerItem, QSizePolicy, QLineEdit
    from PyQt4.QtGui import QGridLayout, QWidget, QLabel
else:
    from qgis.PyQt.QtCore import QDate
    from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QSpacerItem, QSizePolicy, QLineEdit, QGridLayout, QWidget, QLabel

import csv
import json
import os


from collections import OrderedDict
from functools import partial

import utils_giswater

from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import EpaOptions


class Go2EpaOptions(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.epa_options_json = {}
        self.epa_options_list = []

    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa_options(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Create dialog
        self.dlg_options = EpaOptions()
        self.load_settings(self.dlg_options)


        reg_exp = QRegExp("[ \\d]{3}:[0-2][0-3]:[0-5][0-9]:[0-5][0-9]")  # para dias:horas:minutos:segundos
        reg_exp = QRegExp("[\\d]+:[0-5][0-9]:[0-5][0-9]")  # para horas:minutos:segundos
        # self.dlg_options.line_1.setInputMask("009:99:99")
        self.dlg_options.line_1.setValidator(QRegExpValidator(reg_exp))

        form = '"formName":"epaoptions"'
        body = self.create_body(form=form)
        # Get layers under mouse clicked
        sql = ("SELECT " + self.schema_name + ".gw_api_getconfig($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        # TODO controllar si row tiene algo
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.construct_form_param_user(self.dlg_options, complet_result[0]['body']['form']['formTabs'], 0, self.epa_options_list, False)

        self.dlg_options.btn_accept.clicked.connect(partial(self.update_values, self.epa_options_list))
        self.dlg_options.show()


    def update_values(self, _json):
        my_json = json.dumps(_json)
        form = '"formName":"epaoptions"'
        extras = '"fields":' + my_json + ''
        body = self.create_body(form=form, extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_setconfig($${" + body + "}$$)")
        self.controller.execute_sql(sql, log_sql=True)
        message = "Values has been updated"
        self.controller.show_info(message)
        # Close dialog
        self.close_dialog(self.dlg_options)