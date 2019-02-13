"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
from PyQt4.QtCore import QSize
from PyQt4.QtGui import QDialog
from PyQt4.QtGui import QItemSelectionModel

try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4 import QtCore, QtNetwork
    from PyQt4.QtCore import Qt, QDate, QPoint, QUrl
    from PyQt4.QtWebKit import QWebView, QWebSettings, QWebPage
    from PyQt4.QtGui import QIntValidator, QDoubleValidator, QMenu, QApplication, QSpinBox, QDoubleSpinBox
    from PyQt4.QtGui import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, QDateEdit
    from PyQt4.QtGui import QGridLayout, QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QListWidget
    from PyQt4.QtGui import QTableView, QListWidgetItem, QStandardItemModel, QStandardItem, QTabWidget
    from PyQt4.QtGui import QAbstractItemView, QPrinter, QTreeWidgetItem
    from PyQt4.QtSql import QSqlTableModel
    import urlparse
    import win32gui

else:
    from qgis.PyQt import QtCore
    from qgis.PyQt.QtCore import Qt, QDate, QStringListModel,QPoint
    from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator, QStandardItem, QStandardItemModel
    from qgis.PyQt.QtWebKit import QWebView, QWebSettings, QWebPage
    from qgis.PyQt.QtWidgets import QTreeWidgetItem, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox
    from qgis.PyQt.QtWidgets import QGridLayout, QSpacerItem, QSizePolicy, QCompleter, QTableView, QListWidget
    from qgis.PyQt.QtWidgets import QTabWidget, QAbstractItemView, QMenu,  QApplication,QSpinBox, QDoubleSpinBox
    from qgis.PyQt.QtSql import QSqlTableModel, QListWidgetItem
    import urllib.parse as urlparse


from qgis.core import QgsMapLayerRegistry, QgsProject
import json
import sys
import operator

from collections import OrderedDict
from datetime import datetime
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import ApiDlgToolbox, ApiFunctionTb


class GwToolBox(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.function_list = []
        self.rbt_checked = {}

    def set_project_type(self, project_type):
        self.project_type = project_type


    def open_toolbox(self):
        self.dlg_toolbox = ApiDlgToolbox()
        self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dlg_toolbox)
        self.dlg_toolbox.trv.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.dlg_toolbox.trv.setHeaderHidden(True)
        body = self.create_body()
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['data'])
        self.dlg_toolbox.txt_filter.textChanged.connect(partial(self.filter_functions))
        self.dlg_toolbox.trv.doubleClicked.connect(partial(self.open_function))
        self.dlg_toolbox.show()


    def filter_functions(self, text):
        extras = '"filterText":"' + text + '"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['data'])


    def open_function(self, index):
        # this '0' refers to the index of the item in the selected row (alias in this case)
        alias_function = index.sibling(index.row(), 0).data()
        self.dlg_functions = ApiFunctionTb()
        extras = '"filterText":"' + alias_function + '"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.populate_functions_dlg(self.dlg_functions, complet_result[0]['body']['data'])

        self.dlg_functions.rbt_previous.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_previous))
        self.dlg_functions.rbt_layer.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_layer))
        self.dlg_functions.rbt_previous.setChecked(True)
        self.dlg_functions.btn_run.clicked.connect(partial(self.execute_function, self.dlg_functions,
                                                   self.dlg_functions.cmb_layers, complet_result[0]['body']['data']))
        self.dlg_functions.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_functions))
        self.dlg_functions.show()


    def rbt_state(self, rbt, state):
        if rbt.objectName() == 'rbt_previous' and state is True:
            self.rbt_checked['widget'] = 'rbt_previous'
        elif rbt.objectName() == 'rbt_layer' and state is True:
            self.rbt_checked['widget'] = 'rbt_layer'

        self.rbt_checked['value'] = state


    def execute_function(self, dialog, combo, result):

        layer_name = utils_giswater.get_item_data(dialog, combo, 1)
        extras = ""
        for group, function in result['fields'].items():
            if len(function) != 0:
                extras = '"functionName":"' + function[0]['functionname'] + '"'
                extras += ', "sys_role_id":"' + function[0]['sys_role_id'] + '"'
                extras += ', "layer_name":"' + layer_name + '"'
                break

        # Find if radiobutton was added to self.function_list
        index = -1
        for _index, d in enumerate(self.function_list):
            if d['widget'] == 'rbt_previous' or d['widget'] == 'rbt_layer':
                index = _index
                break

        # If the radiobutton was not added, it is added, and if it was added, its value is modified
        if index == -1:
            self.function_list.append(self.rbt_checked)
        else:
            self.function_list[index]['widget'] = self.rbt_checked['widget']

        # Convert list to json
        my_json = json.dumps(self.function_list)

        extras += ', "fields":' + my_json + ''
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")

        self.controller.log_info(str(sql))


    def populate_functions_dlg(self, dialog, result):
        for group, function in result['fields'].items():
            if len(function) != 0:
                dialog.setWindowTitle(function[0]['alias'])
                self.construct_form_param_user(dialog, function, 0, self.function_list, False)
                dialog.txt_info.setText(str(function[0]['descript']))

                # TODO controlar la progresbar
                if function[0]['function_type_']['durationType'] == 'short':
                    self.controller.log_info(str("IS SHORT"))

                self.populate_layer_combo(function[0]['function_type_']['featureType'])


    def populate_layer_combo(self, geom_type):
        self.layers = []
        self.layers = self.controller.get_group_layers(geom_type)

        layers = [['', '']]
        for layer in self.layers:
            if layer in self.iface.legendInterface().layers():
                elem = []
                layer_name = self.controller.get_layer_source_table_name(layer)
                elem.append(layer.name())
                elem.append(layer_name)
                layers.append(elem)
        utils_giswater.set_item_data(self.dlg_functions.cmb_layers, layers)


    def populate_trv(self, trv_widget, result):

        model = QStandardItemModel()
       # model.setHorizontalHeaderLabels(['Toolbox'])

        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)

        for group, functions in result['fields'].items():
            parent1 = QStandardItem('{}'.format(group))
            for function in functions:
                label = QStandardItem('{}'.format(function['alias']))
                func_name = QStandardItem('{}'.format(function['functionname']))
                parent1.appendRow([label, func_name])
            model.appendRow(parent1)
            index = model.indexFromItem(parent1)
            trv_widget.expand(index)

