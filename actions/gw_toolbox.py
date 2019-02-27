"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
import os
import json
import sys
import operator

import re
from PyQt4.QtCore import QVariant
from PyQt4.QtGui import QIcon

try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4 import QtCore, QtNetwork
    from PyQt4.QtCore import Qt, QDate, QPoint, QUrl
    from PyQt4.QtWebKit import QWebView, QWebSettings, QWebPage
    from PyQt4.QtGui import QIntValidator, QDoubleValidator, QMenu, QApplication, QSpinBox, QDoubleSpinBox, QTextEdit
    from PyQt4.QtGui import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, QDateEdit
    from PyQt4.QtGui import QGridLayout, QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QListWidget
    from PyQt4.QtGui import QTableView, QListWidgetItem, QStandardItemModel, QStandardItem, QTabWidget, QRadioButton
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
    from qgis.PyQt.QtWidgets import QGridLayout, QSpacerItem, QSizePolicy, QCompleter, QTableView, QListWidget, QTextEdit
    from qgis.PyQt.QtWidgets import QTabWidget, QAbstractItemView, QMenu,  QApplication,QSpinBox, QDoubleSpinBox, QRadioButton
    from qgis.PyQt.QtSql import QSqlTableModel, QListWidgetItem
    import urllib.parse as urlparse


from qgis.core import QgsMapLayerRegistry, QgsProject, QgsPoint, QgsFeature, QgsGeometry, QgsDataSourceURI
from qgis.core import QgsVectorLayer, QgsLayerTreeLayer, QgsField

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
        self.is_paramtetric = True

    def set_project_type(self, project_type):
        self.project_type = project_type


    def open_toolbox(self):
        self.dlg_toolbox = ApiDlgToolbox()
        self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dlg_toolbox)
        self.dlg_toolbox.trv.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.dlg_toolbox.trv.setHeaderHidden(True)
        body = self.create_body()
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
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
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['data'])


    def open_function(self, index):
        # this '0' refers to the index of the item in the selected row (alias in this case)
        alias_function = index.sibling(index.row(), 0).data()
        self.controller.log_info(str(index.sibling(index.row(), 1).data()))
        # Control no clickable items
        if alias_function in ('Giswater', 'edit', 'master', 'admin'):
            return

        self.dlg_functions = ApiFunctionTb()
        self.dlg_functions.progressBar.setVisible(True)
        self.dlg_functions.progressBar.setValue(0)
        self.dlg_functions.progressBar.setMaximum(100)

        extras = '"filterText":"' + alias_function + '"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        status = self.populate_functions_dlg(self.dlg_functions, complet_result[0]['body']['data'])
        if not status:
            alias_function = index.sibling(index.row(), 1).data()
            msg = "Function not found"
            self.controller.show_message(msg, parameter=alias_function)
            return

        self.dlg_functions.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, self.dlg_functions,
                                                                          self.dlg_functions.cmb_layers))
        self.dlg_functions.rbt_previous.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_previous))
        self.dlg_functions.rbt_layer.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_layer))
        self.dlg_functions.rbt_previous.setChecked(True)
        self.dlg_functions.btn_run.clicked.connect(partial(self.execute_function, self.dlg_functions,
                                                   self.dlg_functions.cmb_layers, complet_result[0]['body']['data']))
        self.dlg_functions.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_functions))
        self.dlg_functions.show()


    def set_selected_layer(self, dialog, combo):
        layer_name = utils_giswater.get_item_data(dialog, combo, 1)
        layer = self.controller.get_layer_by_tablename(layer_name)
        if layer is None:
            self.controller.show_warning("Layer not found", parameter=layer_name)
            return None
        self.iface.setActiveLayer(layer)
        return layer


    def rbt_state(self, rbt, state):
        if rbt.objectName() == 'rbt_previous' and state is True:
            self.rbt_checked['widget'] = 'previousSelection'
        elif rbt.objectName() == 'rbt_layer' and state is True:
            self.rbt_checked['widget'] = 'wholeSelection'

        self.rbt_checked['value'] = state


    def execute_function(self, dialog, combo, result):
        print(datetime.now())
        dialog.progressBar.setValue(0)
        dialog.progressBar.setVisible(True)
        layer_name = utils_giswater.get_item_data(dialog, combo, 1)
        layer = self.set_selected_layer(dialog, combo)
        selection_mode = self.rbt_checked['widget']
        if layer is None:
            return
        function_name = ''
        extras = '"selectionMode":"'+selection_mode+'",'

        # Check if time functions is short or long, activate and set undetermined  if not short
        for group, function in result['fields'].items():
            if len(function) != 0:
                if 'durationType' in function[0]['function_type']:
                    if function[0]['function_type']['durationType'] != 'short':
                        dialog.progressBar.setMaximum(0)
                        dialog.progressBar.setMinimum(0)
                function_name = function[0]['functionname']
                feature_type = function[0]['function_type']['featureType']
                break

        if self.is_paramtetric is False:
            sql = ("SELECT " + self.schema_name + "." + str(function_name) + "()")
            self.controller.execute_sql(sql, log_sql=True)
            return

        # Check selection mode and get (or not get) all feature id
        feature_id_list = '"id":['
        if selection_mode == 'wholeSelection':
            feature_id_list += ']'
        elif selection_mode == 'previousSelection':
            features = layer.selectedFeatures()
            for feature in features:
                feature_id = feature.attribute(feature_type+"_id")
                feature_id_list += '"'+feature_id+'", '
            if len(features) > 0:
                feature_id_list = feature_id_list[:-2] + ']'
            else:
                feature_id_list += ']'
        feature_field = '"tableName":"' + layer_name + '", ' + feature_id_list



        # # Find if radiobutton was added to self.function_list
        # index = -1
        # for _index, d in enumerate(self.function_list):
        #     if d['widget'] == 'previousSelection' or d['widget'] == 'wholeSelection':
        #         index = _index
        #         break
        #
        # # If the radiobutton was not added, it is added, and if it was added, its value is modified
        # if index == -1:
        #     self.function_list.append(self.rbt_checked)
        # else:
        #     self.function_list[index]['widget'] = self.rbt_checked['widget']

        # Convert list to json
        # TODO no podemos hacerlo como el config (widget": "xxxxxx", "value": "xx")?
        # TODO con estas dos lineas bastaria
        # my_json = json.dumps(self.function_list)
        # extras += '"fields":' + my_json + ''


        widget_list = dialog.grb_parameters.findChildren(QWidget)
        widget_is_void = False
        extras += '"parameters":{'
        for group, function in result['fields'].items():
            if len(function) != 0:
                for field in function[0]['input_params']:
                    widget = dialog.findChild(QWidget, field['widgetname'])
                    param_name = widget.objectName()
                    if type(widget) in ('', QLineEdit):
                        widget.setStyleSheet("border: 1px solid gray")
                        value = utils_giswater.getWidgetText(dialog, widget, False, False)
                        extras += '"' + param_name + '":"' + str(value) + '", '
                        if value is '':
                            widget_is_void = True
                            widget.setStyleSheet("border: 1px solid red")
                    elif type(widget) in ('', QSpinBox, QDoubleSpinBox):
                        value = utils_giswater.getWidgetText(dialog, widget, False, False)
                        if value == '':
                            value = 0
                        extras += '"' + param_name + '":"' + str(value) + '", '
                    elif type(widget) in ('', QComboBox):
                        value = utils_giswater.get_item_data(dialog, widget, 0)
                        extras += '"' + param_name + '":"' + str(value).lower() + '", '

        if widget_is_void:
            message = "This paramater is mandatory. Please, set a value"
            self.controller.show_warning(message, parameter='')
            return
        if len(widget_list) > 0:
            extras = extras[:-2] + '}'
        else:
            extras += '}'
        extras += ', "saveOnDatabase":' + str(utils_giswater.isChecked(dialog, dialog.chk_save)).lower()
        body = self.create_body(feature=feature_field, extras=extras)
        sql = ("SELECT " + self.schema_name + "."+str(function_name)+"($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("Function : " + str(function_name)+" executed with no result ", 3)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.add_void_layer(dialog, complet_result[0]['body']['data'])
        print(datetime.now())


    def populate_functions_dlg(self, dialog, result):
        status = False
        for group, function in result['fields'].items():
            if len(function) != 0:
                self.populate_layer_combo(function[0]['function_type']['featureType'])
                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))
                self.construct_form_param_user(dialog, function, 0, self.function_list, False)

                if 'durationType' in function[0]['function_type']:
                    if function[0]['function_type']['durationType'] == 'short':
                        dialog.progressBar.setVisible(False)
                print(function[0]['isparametric'])
                if str(function[0]['isparametric']) in ('false', False, 'None',  None, 'null'):
                    self.is_paramtetric = False
                    self.control_isparametric(dialog)

                status = True
                break
        return status


    def control_isparametric(self, dialog):
        """ Control if the function is not parameterized whit a json, is old and we need disable all widgets """
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit):
                widget.setReadOnly(True)
                widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
            elif type(widget) in (QCheckBox, QComboBox, QRadioButton):
                    widget.setEnabled(False)


    def populate_layer_combo(self, geom_type):
        self.layers = []
        self.layers = self.controller.get_group_layers(geom_type)

        #layers = [['', '']]
        layers = []
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
        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)
        main_parent = QStandardItem('{}'.format('Giswater'))
        self.icon_folder = self.plugin_dir + '/icons/'
        icon_path = self.icon_folder + '36.png'

        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            main_parent.setIcon(icon)

        for group, functions in sorted(result['fields'].items()):
            parent1 = QStandardItem('{}'.format(group))
            functions.sort(key=self.sort_list, reverse=False)
            for function in functions:
                label = QStandardItem('{}'.format(function['alias']))
                if os.path.exists(icon_path):
                    label.setIcon(icon)
                func_name = QStandardItem('{}'.format(function['functionname']))
                parent1.appendRow([label, func_name])
            main_parent.appendRow(parent1)
        model.appendRow(main_parent)
        index = model.indexFromItem(main_parent)
        trv_widget.expand(index)


    def sort_list(self, json):
        try:
            return json['alias'].upper()
        except KeyError:
            return 0




    def add_void_layer(self, dialog, result):
        self.delete_layer_from_toc('temp_result')

        counter = len(result['result'])
        dialog.progressBar.setMaximum(counter)
        srid = self.controller.plugin_settings_value('srid')
        the_geom = result['result'][0]['the_geom']
        sql = ("SELECT St_AsText('" + str(the_geom) + "')")
        row = self.controller.get_row(sql, log_sql=False)
        sql = ("SELECT ST_GeometryType(ST_GeomFromText('"+str(row[0])+"'))")
        geom_type = self.controller.get_row(sql, log_sql=False)
        # create layer
        virtual_layer = QgsVectorLayer('LineString?crs=epsg:' + str(srid) + '', 'temp_result', "memory")
        if 'ST_LineString' in str(geom_type):
            virtual_layer = QgsVectorLayer('LineString?crs=epsg:' + str(srid) + '', 'temp_result', "memory")
        elif 'ST_Point' in str(geom_type):
            virtual_layer = QgsVectorLayer('Point?crs=epsg:' + str(srid) + '', 'temp_result', "memory")

        prov = virtual_layer.dataProvider()

        # Enter editing mode
        virtual_layer.startEditing()

        for key, value in result['result'][0].items():
            # add columns
            prov.addAttributes([QgsField(str(key), QVariant.String)])
        x = 0
        # Add features
        for item in result['result']:
            x += 1
            dialog.progressBar.setValue(x)
            attributes = []
            fet = QgsFeature()
            for k, v in item.items():
                attributes.append(v)
                if str(k) in ('the_geom'):
                    sql = ("SELECT St_AsText('"+str(v)+"')")
                    row = self.controller.get_row(sql, log_sql=False)
                    geometry = QgsGeometry.fromWkt(str(row[0]))
                    fet.setGeometry(geometry)
            fet.setAttributes(attributes)
            prov.addFeatures([fet])

        # Commit changes
        virtual_layer.commitChanges()

        QgsMapLayerRegistry.instance().addMapLayer(virtual_layer)


    def add_table_from_pg(self, schema_name, table_name, field_id, group_to_be_inserted=None):

        #self.add_table_from_pg(schema_name, 'temp_csv2pg', 'id', 'EPANET')
        layer = self.controller.get_layer_by_tablename(table_name)
        if layer is not None:
            return

        layer = self.controller.get_layer_by_tablename("version")
        credentials = self.controller.get_layer_source(layer)
        #self.controller.log_info(str(credentials))

        foreign_uri = QgsDataSourceURI()
        foreign_uri.setConnection(credentials['host'], credentials['port'], credentials['db'], credentials['user'], credentials['password'])
        foreign_uri.setDataSource(schema_name, table_name, None, "", field_id)
        new_layer = QgsVectorLayer(foreign_uri.uri(), table_name, "postgres")

        if group_to_be_inserted is None:
            QgsMapLayerRegistry.instance().addMapLayer(new_layer)
            return

        root = QgsProject.instance().layerTreeRoot()
        mygroup = root.findGroup(group_to_be_inserted)
        QgsMapLayerRegistry.instance().addMapLayer(new_layer, False)
        mygroup.insertLayer(0, new_layer)