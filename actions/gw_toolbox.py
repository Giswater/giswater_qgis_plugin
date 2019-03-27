"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()

# -*- coding: latin-1 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

import os
import json

from qgis.PyQt.QtCore import Qt, QDate, QPoint, QUrl, QThread, pyqtSignal, QVariant
from qgis.PyQt.QtGui import QColor, QIcon
from qgis.PyQt.QtWidgets import QMenu, QApplication, QSpinBox, QDoubleSpinBox, QTextEdit
from qgis.PyQt.QtWidgets import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, QDateEdit
from qgis.PyQt.QtWidgets import QGridLayout, QSpacerItem, QSizePolicy, QCompleter, QListWidget
from qgis.PyQt.QtWidgets import QTableView, QListWidgetItem, QTabWidget, QRadioButton
from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QAbstractItemView, QTreeWidgetItem

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsMapLayerRegistry, QgsProject, QgsDataSourceURI as QgsDataSourceUri
else:
    from qgis.core import QgsProject, QgsDataSourceUri

from qgis.core import QgsPoint, QgsFeature, QgsGeometry
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
        self.no_clickable_items = ['Giswater']

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
        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['data'], expand=True)


    def open_function(self, index):
        self.is_paramtetric = True
        # this '0' refers to the index of the item in the selected row (alias in this case)
        self.alias_function = index.sibling(index.row(), 0).data()

        # Control no clickable items
        if self.alias_function in self.no_clickable_items:
            return

        self.dlg_functions = ApiFunctionTb()
        self.load_settings(self.dlg_functions)
        self.dlg_functions.progressBar.setVisible(True)
        self.dlg_functions.progressBar.setValue(0)
        self.dlg_functions.progressBar.setMaximum(100)

        self.dlg_functions.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, self.dlg_functions,
                                                                          self.dlg_functions.cmb_layers))
        self.dlg_functions.rbt_previous.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_previous))
        self.dlg_functions.rbt_layer.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_layer))
        self.dlg_functions.rbt_layer.setChecked(True)

        extras = '"filterText":"' + self.alias_function + '"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        status = self.populate_functions_dlg(self.dlg_functions, complet_result[0]['body']['data'])

        if not status:
            self.alias_function = index.sibling(index.row(), 1).data()
            msg = "Function not found"
            self.controller.show_message(msg, parameter=self.alias_function)
            return

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


    def check_exist_function(self, func_name):
        status = False
        sql = ("SELECT routines.routine_name FROM information_schema.routines"
               " WHERE routines.specific_schema='"+self.schema_name.replace('"', '')+"'"
               " AND routines.routine_name ='"+str(func_name)+"'"
               " ORDER BY routines.routine_name;")
        rows = self.controller.get_rows(sql, log_sql=False)
        for row in rows:
            if func_name in row['routine_name']:
                status = True
        return status


    def load_settings_values(self, dialog, function):
        """ Load QGIS settings related with csv options """

        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']

        if self.controller.plugin_settings_value(str(function_name) + "_" + cur_user + "_chk_save") == 'true':
            dialog.chk_save.setChecked(True)

        if self.controller.plugin_settings_value(str(function_name)+"_" + cur_user + "_rbt_previous") == 'true':
            dialog.rbt_previous.setChecked(True)
        else:
            dialog.rbt_layer.setChecked(True)


    def save_settings_values(self, dialog, function):
        """ Save QGIS settings related with toolbox options """
        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']
        self.controller.plugin_settings_set_value(str(function_name)+"_" + cur_user + "_rbt_previous",
                                                  dialog.rbt_previous.isChecked())
        self.controller.plugin_settings_set_value(str(function_name)+"_" + cur_user + "_chk_save",
                                                  dialog.chk_save.isChecked())


    def execute_function(self, dialog, combo, result):

        dialog.progressBar.setValue(0)
        dialog.progressBar.setVisible(True)
        # Check if time functions is short or long, activate and set undetermined  if not short
        for group, function in list(result['fields'].items()):
            if len(function) != 0:
                self.save_settings_values(dialog, function)
                function_name = function[0]['functionname']
                if 'input_params' in function[0]:
                    if 'featureType' in function[0]['input_params']:
                        feature_type = function[0]['input_params']['featureType']
                    if 'durationType' in function[0]['input_params']:
                        if function[0]['input_params']['durationType'] != 'short':
                            dialog.progressBar.setMaximum(0)
                            dialog.progressBar.setMinimum(0)
                break

        # If function is not parametrized, call function(old) without json
        if self.is_paramtetric is False:
            self.execute_no_parametric(dialog, function_name)
            return

        layer_name = utils_giswater.get_item_data(dialog, combo, 1)
        if layer_name != -1:
            layer = self.set_selected_layer(dialog, combo)

            # if layer is None:
            #     return
        selection_mode = self.rbt_checked['widget']
        extras = '"selectionMode":"'+selection_mode+'",'
        # Check selection mode and get (or not get) all feature id
        feature_id_list = '"id":['
        if (selection_mode == 'wholeSelection') or(selection_mode == 'previousSelection' and layer is None):
            feature_id_list += ']'
        elif selection_mode == 'previousSelection' and layer is not None:
            features = layer.selectedFeatures()
            for feature in features:
                feature_id = feature.attribute(feature_type+"_id")
                feature_id_list += '"'+feature_id+'", '
            if len(features) > 0:
                feature_id_list = feature_id_list[:-2] + ']'
            else:
                feature_id_list += ']'


        feature_field = ''
        if layer_name != -1:
            feature_field = '"tableName":"' + layer_name + '", '
        feature_field += feature_id_list
        widget_list = dialog.grb_parameters.findChildren(QWidget)
        widget_is_void = False
        extras += '"parameters":{'
        for group, function in list(result['fields'].items()):
            if len(function) != 0:
                if function[0]['return_type'] not in (None, ''):
                    for field in function[0]['return_type']:
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

        dialog.progressBar.setFormat("Running function: " + str(function_name))
        dialog.progressBar.setAlignment(Qt.AlignCenter)

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
            return True

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.add_temp_layer(dialog, complet_result[0]['body']['data'], self.alias_function)

        dialog.progressBar.setFormat("Function " + str(function_name) + " has finished.")
        dialog.progressBar.setAlignment(Qt.AlignCenter)


    def execute_no_parametric(self, dialog, function_name):
        dialog.progressBar.setMinimum(0)
        dialog.progressBar.setFormat("Running function: " + str(function_name))
        dialog.progressBar.setAlignment(Qt.AlignCenter)
        dialog.progressBar.setMaximum(100)
        dialog.progressBar.setValue(0)
        dialog.progressBar.setFormat("")

        sql = ("SELECT " + self.schema_name + "." + str(function_name) + "()::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if not row or row[0] is None:
            self.controller.show_message("Function : " + str(function_name) + " executed with no result ", 3)
            return True

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.add_temp_layer(dialog, complet_result[0]['body']['data'], self.alias_function)
        dialog.progressBar.setFormat("Function " + str(function_name) + " has finished.")
        dialog.progressBar.setAlignment(Qt.AlignCenter)
        return True


    def populate_functions_dlg(self, dialog, result):
        status = False
        for group, function in result['fields'].items():
            if len(function) != 0:

                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))
                if str(function[0]['isparametric']) in ('false', 'False', False, 'None',  None, 'null'):
                    self.is_paramtetric = False
                    self.control_isparametric(dialog)
                    self.load_settings_values(dialog, function)
                    if str(function[0]['isnotparammsg']) is not None:
                        layout = dialog.findChild(QGridLayout, 'grl_option_parameters')
                        if layout is None:
                            status = True
                            break
                        label = QLabel()
                        label.setWordWrap(True)
                        label.setText("Info: " + str(function[0]['isnotparammsg']))
                        layout.addWidget(label, 0, 0)

                    status = True
                    break

                self.populate_layer_combo(function[0]['input_params']['featureType'])
                self.construct_form_param_user(dialog, function, 0, self.function_list, False)

                self.load_settings_values(dialog, function)

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


        dialog.grb_input_layer.setVisible(False)
        dialog.grb_selection_type.setVisible(False)
        dialog.rbt_previous.setChecked(False)
        dialog.rbt_layer.setChecked(True)
        dialog.chk_save.setChecked(True)
        dialog.chk_save.setEnabled(False)

        dialog.grb_parameters.setEnabled(False)
        dialog.grb_parameters.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

        dialog.txt_info.setReadOnly(True)
        dialog.txt_info.setStyleSheet("QWidget { background: rgb(255, 255, 255); color: rgb(10, 10, 10)}")


    def populate_layer_combo(self, geom_type):
        self.layers = []
        self.layers = self.controller.get_group_layers(geom_type)
        layers = []
        legend_layers = self.controller.get_layers()
        for layer in self.layers:
            if layer in legend_layers:
                elem = []
                layer_name = self.controller.get_layer_source_table_name(layer)
                elem.append(layer.name())
                elem.append(layer_name)
                layers.append(elem)
        utils_giswater.set_item_data(self.dlg_functions.cmb_layers, layers)


    def populate_trv(self, trv_widget, result, expand=False):
        model = QStandardItemModel()
        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)
        main_parent = QStandardItem('{}'.format('Giswater'))
        self.icon_folder = self.plugin_dir + '/icons/'
        path_icon_blue = self.icon_folder + '36.png'
        path_icon_red = self.icon_folder + '100.png'
        if os.path.exists(path_icon_blue):
            icon = QIcon(path_icon_blue)
            main_parent.setIcon(icon)

        for group, functions in result['fields'].items():
            parent1 = QStandardItem('{}   [{} Giswater algorithm]'.format(group, len(functions)))

            self.no_clickable_items.append('{}'.format(group))
            functions.sort(key=self.sort_list, reverse=False)
            for function in functions:
                func_name = QStandardItem('{}'.format(function['functionname']))
                label = QStandardItem('{}'.format(function['alias']))
                status = self.check_exist_function(function['functionname'])
                if status is False:
                    if os.path.exists(path_icon_red):
                        icon = QIcon(path_icon_red)
                        label.setIcon(icon)
                        label.setForeground(QColor(255, 0, 0))
                        label.setToolTip('Function configured on the table audit_cat_function, '
                                         'but not found in the data base')
                        self.no_clickable_items.append('{}'.format(function['alias']))
                else:
                    if os.path.exists(path_icon_blue):
                        icon = QIcon(path_icon_blue)
                        label.setIcon(icon)
                        label.setToolTip(function['functionname'])
                parent1.appendRow([label, func_name])
            main_parent.appendRow(parent1)
        model.appendRow(main_parent)
        index = model.indexFromItem(main_parent)
        trv_widget.expand(index)
        if expand:
            trv_widget.expandAll()


    def sort_list(self, json):
        try:
            return json['alias'].upper()
        except KeyError:
            return 0


    def add_temp_layer(self, dialog, result, function_name):

        self.delete_layer_from_toc(function_name)

        counter = len(result['result'])
        dialog.progressBar.setMaximum(counter+1)
        dialog.progressBar.setValue(0)
        srid = self.controller.plugin_settings_value('srid')

        virtual_layer = QgsVectorLayer('Point?crs=epsg:' + str(srid) + '', function_name, "memory")

        if counter > 0:
            if 'the_geom' in result['result'][0]:
                the_geom = result['result'][0]['the_geom']
                sql = ("SELECT St_AsText('" + str(the_geom) + "')")
                row = self.controller.get_row(sql, log_sql=False)
                sql = ("SELECT ST_GeometryType(ST_GeomFromText('"+str(row[0])+"'))")
                geom_type = self.controller.get_row(sql, log_sql=False)
                # create layer
                if 'ST_LineString' in str(geom_type):
                    virtual_layer = QgsVectorLayer('LineString?crs=epsg:' + str(srid) + '', function_name, "memory")
                elif 'ST_Point' in str(geom_type):
                    virtual_layer = QgsVectorLayer('Point?crs=epsg:' + str(srid) + '', function_name, "memory")

        prov = virtual_layer.dataProvider()

        # Enter editing mode
        virtual_layer.startEditing()
        if counter > 0:
            for key, value in list(result['result'][0].items()):
                # add columns
                if str(key) != 'the_geom':
                    prov.addAttributes([QgsField(str(key), QVariant.String)])

        x = 1
        # Add features
        for item in result['result']:
            x += 1
            dialog.progressBar.setValue(x)
            attributes = []
            fet = QgsFeature()
            for k, v in list(item.items()):
                if str(k) != 'the_geom':
                    attributes.append(v)
                if str(k) in ('the_geom'):
                    sql = ("SELECT St_AsText('"+str(v)+"')")
                    row = self.controller.get_row(sql, log_sql=False)
                    geometry = QgsGeometry.fromWkt(str(row[0]))
                    fet.setGeometry(geometry)
            fet.setAttributes(attributes)
            prov.addFeatures([fet])
        dialog.progressBar.setValue(x)

        # Commit changes
        virtual_layer.commitChanges()
        if Qgis.QGIS_VERSION_INT < 29900:
            QgsMapLayerRegistry.instance().addMapLayer(virtual_layer, False)
        else:
            QgsProject.instance().addMapLayer(virtual_layer, False)

        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup('GW Functions results')

        if my_group is None:
            my_group = root.insertGroup(0, 'GW Functions results')

        my_group.insertLayer(0, virtual_layer)

