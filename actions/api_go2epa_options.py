"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-



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
import subprocess

from collections import OrderedDict
from functools import partial

import utils_giswater

from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import WSoptions


class Go2EpaOptions(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa_options(self):
        """ Button 23: Open form to set INP, RPT and project """
        # TODO habilitar esta llamada  Edgar acabe el giswater_java en python
        #self.get_last_gsw_file()


        # Create dialog
        self.dlg_options = WSoptions()
        self.load_settings(self.dlg_options)
        #self.dlg_go2epa.setFixedSize(620, 300)

        # TODO habilitar todos estos widgets cuando Edgar acabe el giswater_java en python
        """
        # Set widgets
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)
        self.dlg_go2epa.txt_result_name.setText(self.project_name)

        # Hide checkboxes
        self.dlg_go2epa.chk_export.setVisible(False)
        self.dlg_go2epa.chk_export_subcatch.setVisible(False)
        self.dlg_go2epa.chk_exec.setVisible(False)
        self.dlg_go2epa.chk_import.setVisible(False)
        """
        grl_general_1 = self.dlg_options.findChild(QGridLayout, 'grl_general_1')
        grl_general_2 = self.dlg_options.findChild(QGridLayout, 'grl_general_2')
        grl_hyd_3 = self.dlg_options.findChild(QGridLayout, 'grl_hyd_3')
        grl_hyd_4 = self.dlg_options.findChild(QGridLayout, 'grl_hyd_4')
        grl_quality_5 = self.dlg_options.findChild(QGridLayout, 'grl_quality_5')
        grl_quality_6 = self.dlg_options.findChild(QGridLayout, 'grl_quality_6')
        grl_statu_7 = self.dlg_options.findChild(QGridLayout, 'grl_statu_7')
        grl_statu_8 = self.dlg_options.findChild(QGridLayout, 'grl_statu_8')
        grl_crm_9 = self.dlg_options.findChild(QGridLayout, 'grl_crm_9')
        grl_crm_10 = self.dlg_options.findChild(QGridLayout, 'grl_crm_10')
        grl_date_11 = self.dlg_options.findChild(QGridLayout, 'grl_date_11')
        grl_date_12 = self.dlg_options.findChild(QGridLayout, 'grl_date_12')

        body = '"client":{"device":3, "infoType":100, "lang":"ES"}, '
        body += '"form":{"formName":"epaoptions"}, '
        body += '"feature":{}, '
        body += '"data":{}'

        # Get layers under mouse clicked
        sql = ("SELECT " + self.schema_name + ".gw_api_getconfig($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.construct_form_param_user(self.dlg_options, complet_result[0]['body']['form']['formTabs'], 0, False)
        self.dlg_options.show()


