"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsProject
from qgis.gui import QgsDateTimeEdit
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor, QIcon, QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QSpinBox, QDoubleSpinBox, QTextEdit, QWidget, QLabel, QLineEdit, QComboBox, QCheckBox
from qgis.PyQt.QtWidgets import QGridLayout, QRadioButton, QAbstractItemView, QPushButton

import os
import json
from collections import OrderedDict
from functools import partial

from .. import utils_giswater
from .add_layer import AddLayer
from .api_parent import ApiParent
from ..ui_manager import ApiDlgToolbox, ApiFunctionTb


class GwToolBox(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.add_layer = AddLayer(iface, settings, controller, plugin_dir)
        self.function_list = []
        self.rbt_checked = {}
        self.is_paramtetric = True
        self.no_clickable_items = ['Giswater']


    def set_project_type(self, project_type):
        self.project_type = project_type


    def open_toolbox(self):

        function_name = "gw_api_gettoolbox"
        row = self.controller.check_function(function_name)
        if not row:
            self.controller.show_warning("Function not found in database", parameter=function_name)
            return

        self.dlg_toolbox = ApiDlgToolbox()
        self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dlg_toolbox)
        self.dlg_toolbox.trv.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.dlg_toolbox.trv.setHeaderHidden(True)
        extras = '"isToolbox":true'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_api_gettoolbox($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['data'])
        self.dlg_toolbox.txt_filter.textChanged.connect(partial(self.filter_functions))
        self.dlg_toolbox.trv.doubleClicked.connect(partial(self.open_function))


    def filter_functions(self, text):

        extras = f'"filterText":"{text}"'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_api_gettoolbox($${{{body}}}$$)::text"
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
        self.dlg_functions.progressBar.setVisible(False)

        self.dlg_functions.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, self.dlg_functions,
                                                                          self.dlg_functions.cmb_layers))
        self.dlg_functions.rbt_previous.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_previous))
        self.dlg_functions.rbt_layer.toggled.connect(partial(self.rbt_state, self.dlg_functions.rbt_layer))
        self.dlg_functions.rbt_layer.setChecked(True)

        extras = f'"filterText":"{self.alias_function}"'
        extras += ', "isToolbox":true'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_api_gettoolbox($${{{body}}}$$)::text"
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
        self.dlg_functions.btn_cancel.clicked.connect(partial(self.remove_layers))
        self.dlg_functions.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_functions))

        enable_btn_run = index.sibling(index.row(), 2).data()
        bool_dict = {"True": True, "true": True, "False": False, "false": False}
        self.dlg_functions.btn_run.setEnabled(bool_dict[enable_btn_run])
        self.open_dialog(self.dlg_functions)


    def remove_layers(self):
        root = QgsProject.instance().layerTreeRoot()
        layers_to_remove = []
        for layer in self.temp_layers_added:
            layers_to_remove.append(layer)
            demRaster = root.findLayer(layer.id())
            parentGroup = demRaster.parent()
            try:
                QgsProject.instance().removeMapLayer(layer.id())
            except Exception as e:
                pass

            if len(parentGroup.findLayers())== 0:
                root.removeChildNode(parentGroup)

        for layer in layers_to_remove:
            if layer in self.temp_layers_added: self.temp_layers_added.remove(layer)
        layers_to_remove.clear()

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


    def load_settings_values(self, dialog, function):
        """ Load QGIS settings related with toolbox options """

        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']
        geom_type = self.controller.plugin_settings_value(f"{function_name}_{cur_user}_cmb_geom_type")
        utils_giswater.set_combo_itemData(dialog.cmb_geom_type, geom_type, 0)
        layer = self.controller.plugin_settings_value(f"{function_name}_{cur_user}_cmb_layers")
        utils_giswater.set_combo_itemData(dialog.cmb_layers, layer, 0)
        if self.controller.plugin_settings_value(f"{function_name}_{cur_user}_rbt_previous") == 'true':
            dialog.rbt_previous.setChecked(True)
        else:
            dialog.rbt_layer.setChecked(True)


    def load_parametric_values(self, dialog, function):
        """ Load QGIS settings related with parametric toolbox options """
        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']
        layout = dialog.findChild(QWidget, 'grb_parameters')
        widgets = layout.findChildren(QWidget)
        for widget in widgets:
            if type(widget) not in (QCheckBox, QComboBox, QLineEdit):
                continue
            if type(widget) is QCheckBox:
                if self.controller.plugin_settings_value(f"{function_name}_{cur_user}_{widget.objectName()}"):
                    widget.setChecked(True)
                else:
                    widget.setChecked(False)
            elif type(widget) is QComboBox:
                value = self.controller.plugin_settings_value(f"{function_name}_{cur_user}_{widget.objectName()}")
                utils_giswater.set_combo_itemData(widget, value, 0)
            elif type(widget) in (QLineEdit, QSpinBox):
                value = self.controller.plugin_settings_value(f"{function_name}_{cur_user}_{widget.objectName()}")
                utils_giswater.setWidgetText(dialog, widget, value)


    def save_settings_values(self, dialog, function):
        """ Save QGIS settings related with toolbox options """

        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']
        geom_type = utils_giswater.get_item_data(dialog, dialog.cmb_geom_type, 0)
        self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_cmb_geom_type", geom_type)
        layer = utils_giswater.get_item_data(dialog, dialog.cmb_layers, 0)
        self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_cmb_layers", layer)
        self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_rbt_previous", dialog.rbt_previous.isChecked())


    def save_parametric_values(self, dialog, function):
        """ Save QGIS settings related with parametric toolbox options """
        cur_user = self.controller.get_current_user()
        function_name = function[0]['functionname']
        layout = dialog.findChild(QWidget, 'grb_parameters')
        widgets = layout.findChildren(QWidget)
        for widget in widgets:
            if type(widget) is QCheckBox:
                self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_{widget.objectName()}", widget.isChecked())
            elif type(widget) is QComboBox:
                value = utils_giswater.get_item_data(dialog, widget, 0)
                self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_{widget.objectName()}", value)
            elif type(widget) in (QLineEdit, QSpinBox):
                value = utils_giswater.getWidgetText(dialog, widget, False, False)
                self.controller.plugin_settings_set_value(f"{function_name}_{cur_user}_{widget.objectName()}", value)


    def execute_function(self, dialog, combo, result):

        dialog.progressBar.setMaximum(0)
        dialog.progressBar.setMinimum(0)
        dialog.progressBar.setVisible(True)
        extras = ''
        feature_field = ''
        # TODO Check if time functions is short or long, activate and set undetermined  if not short

        # Get function name
        function_name = None
        for group, function in list(result['fields'].items()):
            if len(function) != 0:
                self.save_settings_values(dialog, function)
                self.save_parametric_values(dialog, function)
                function_name = function[0]['functionname']
                break
        if function_name is None:
            return
        # If function is not parametrized, call function(old) without json
        if self.is_paramtetric is False:
            self.execute_no_parametric(dialog, function_name)
            dialog.progressBar.setVisible(False)
            dialog.progressBar.setMinimum(0)
            dialog.progressBar.setMaximum(1)
            dialog.progressBar.setValue(1)
            return

        if function[0]['input_params']['featureType']:
            layer_name = utils_giswater.get_item_data(dialog, combo, 1)
            if layer_name != -1:
                layer = self.set_selected_layer(dialog, combo)
                if not layer:
                    dialog.progressBar.setVisible(False)
                    dialog.progressBar.setMinimum(0)
                    dialog.progressBar.setMaximum(1)
                    dialog.progressBar.setValue(1)
                    return
            selection_mode = self.rbt_checked['widget']
            extras += f'"selectionMode":"{selection_mode}",'
            # Check selection mode and get (or not get) all feature id
            feature_id_list = '"id":['
            if (selection_mode == 'wholeSelection') or(selection_mode == 'previousSelection' and layer is None):
                feature_id_list += ']'
            elif selection_mode == 'previousSelection' and layer is not None:
                features = layer.selectedFeatures()
                feature_type = utils_giswater.get_item_data(dialog, dialog.cmb_geom_type, 0)
                for feature in features:
                    feature_id = feature.attribute(feature_type+"_id")
                    feature_id_list += f'"{feature_id}", '
                if len(features) > 0:
                    feature_id_list = feature_id_list[:-2] + ']'
                else:
                    feature_id_list += ']'

            if layer_name != -1:
                feature_field = f'"tableName":"{layer_name}", '
                feature_type = utils_giswater.get_item_data(dialog, dialog.cmb_geom_type, 0)
                feature_field += f'"featureType":"{feature_type}", '
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
                        if type(widget) in ('', QLineEdit, QPushButton):
                            widget.setStyleSheet("border: 1px solid gray")
                            value = utils_giswater.getWidgetText(dialog, widget, False, False)
                            extras += f'"{param_name}":"{value}", '.replace('""','null')
                            if value is '' and widget.property('is_mandatory'):
                                widget_is_void = True
                                widget.setStyleSheet("border: 1px solid red")
                        elif type(widget) in ('', QSpinBox, QDoubleSpinBox):
                            value = utils_giswater.getWidgetText(dialog, widget, False, False)
                            if value == '':
                                value = 0
                            extras += f'"{param_name}":"{value}", '
                        elif type(widget) in ('', QComboBox):
                            value = utils_giswater.get_item_data(dialog, widget, 0)
                            extras += f'"{param_name}":"{value}", '
                        elif type(widget) in ('', QCheckBox):
                            value = utils_giswater.isChecked(dialog, widget)
                            extras += f'"{param_name}":"{str(value).lower()}", '
                        elif type(widget) in ('', QgsDateTimeEdit):
                            value = utils_giswater.getCalendarDate(dialog, widget)
                            if value == "" or value is None:
                                extras += f'"{param_name}":null, '
                            else:
                                extras += f'"{param_name}":"{value}", '

        if widget_is_void:
            message = "This param is mandatory. Please, set a value"
            self.controller.show_warning(message, parameter='')
            dialog.progressBar.setVisible(False)
            dialog.progressBar.setMinimum(0)
            dialog.progressBar.setMaximum(1)
            dialog.progressBar.setValue(1)
            return

        dialog.progressBar.setFormat("Running function: " + str(function_name))
        dialog.progressBar.setAlignment(Qt.AlignCenter)

        if len(widget_list) > 0:
            extras = extras[:-2] + '}'
        else:
            extras += '}'

        body = self.create_body(feature=feature_field, extras=extras)
        sql = f"SELECT {function_name}($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_message(f"Function : {function_name} executed with no result ", 3)
            dialog.progressBar.setVisible(False)
            dialog.progressBar.setMinimum(0)
            dialog.progressBar.setMaximum(1)
            dialog.progressBar.setValue(1)
            return True

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.add_layer.add_temp_layer(dialog, complet_result[0]['body']['data'], self.alias_function,True, True, 1, True)

        dialog.progressBar.setFormat(f"Function {function_name} has finished.")
        dialog.progressBar.setAlignment(Qt.AlignCenter)
        dialog.progressBar.setMinimum(0)
        dialog.progressBar.setMaximum(1)
        dialog.progressBar.setValue(1)

        try:
            self.set_layers_visible(complet_result[0]['body']['data']['setVisibleLayers'])
        except KeyError as e:

            msg = f"<b>Key: </b>{e}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.execute_function.__name__} <br>"
            msg += f"<b>DB call: </b>{sql}<br>"
            self.show_exceptions_msg("Key on returned json from ddbb is missed.", msg)


    def execute_no_parametric(self, dialog, function_name):

        dialog.progressBar.setMinimum(0)
        dialog.progressBar.setFormat(f"Running function: {function_name}")
        dialog.progressBar.setAlignment(Qt.AlignCenter)
        dialog.progressBar.setFormat("")

        sql = f"SELECT {function_name}()::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if not row or row[0] is None:
            self.controller.show_message(f"Function : {function_name} executed with no result ", 3)
            return True

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.add_temp_layer(dialog, complet_result[0]['body']['data'], self.alias_function)
        dialog.progressBar.setFormat(f"Function {function_name} has finished.")
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
                if not function[0]['input_params']['featureType']:
                    dialog.grb_input_layer.setVisible(False)
                    dialog.grb_selection_type.setVisible(False)
                else:
                    feature_types = function[0]['input_params']['featureType']
                    self.populate_cmb_type(feature_types)
                    self.dlg_functions.cmb_geom_type.currentIndexChanged.connect(partial(self.populate_layer_combo))
                    self.populate_layer_combo()
                self.construct_form_param_user(dialog, function, 0, self.function_list)
                self.load_settings_values(dialog, function)
                self.load_parametric_values(dialog, function)
                status = True
                break

        return status

    def populate_cmb_type(self, feature_types):
        feat_types = []
        for item in feature_types:
            elem = []
            elem.append(item.upper())
            elem.append(item.upper())
            feat_types.append(elem)
        if feat_types and len(feat_types) <= 1:
            self.dlg_functions.cmb_geom_type.setVisible(False)
        utils_giswater.set_item_data(self.dlg_functions.cmb_geom_type, feat_types, 1)


    def get_all_group_layers(self, geom_type):

        list_items = []
        sql = ("SELECT tablename, type FROM "
               "(SELECT tablename, type, 1 as c FROM sys_feature_cat"
               " WHERE type = '" + geom_type.upper() + "'"
               " UNION SELECT DISTINCT(parent_layer), feature_type, 0 FROM cat_feature WHERE feature_type='" + geom_type.upper() + "'"
               " UNION SELECT child_layer, feature_type, 2 as c FROM cat_feature WHERE feature_type = '" + geom_type.upper() + "') as t "
               " ORDER BY c, tablename")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            for row in rows:
                layer = self.controller.get_layer_by_tablename(row[0])
                if layer:
                    elem = [row[1], layer]
                    list_items.append(elem)

        return list_items
    

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

        dialog.grb_parameters.setEnabled(False)
        dialog.grb_parameters.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

        dialog.txt_info.setReadOnly(True)
        dialog.txt_info.setStyleSheet("QWidget { background: rgb(255, 255, 255); color: rgb(10, 10, 10)}")


    def populate_layer_combo(self):
        geom_type = utils_giswater.get_item_data(self.dlg_functions, self.dlg_functions.cmb_geom_type, 0)
        self.layers = []
        self.layers = self.get_all_group_layers(geom_type)

        layers = []
        legend_layers = self.controller.get_layers()
        for geom_type, layer in self.layers:
            if layer in legend_layers:
                elem = []
                layer_name = self.controller.get_layer_source_table_name(layer)
                elem.append(layer.name())
                elem.append(layer_name)
                elem.append(geom_type)
                layers.append(elem)
        if not layers:
            elem = []
            elem.append(f"There is no layer related to {geom_type}.")
            elem.append(None)
            elem.append(None)
            layers.append(elem)

        utils_giswater.set_item_data(self.dlg_functions.cmb_layers, layers, sort_combo=False)


    def populate_trv(self, trv_widget, result, expand=False):

        model = QStandardItemModel()
        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)
        main_parent = QStandardItem('{}'.format('Giswater'))
        font = main_parent.font()
        font.setPointSize(8)
        main_parent.setFont(font)

        self.icon_folder = self.plugin_dir + os.sep + 'icons'
        path_icon_blue = self.icon_folder + os.sep + '36.png'
        path_icon_red = self.icon_folder + os.sep + '100.png'
        if os.path.exists(path_icon_blue):
            icon = QIcon(path_icon_blue)
            main_parent.setIcon(icon)

        for group, functions in result['fields'].items():
            parent1 = QStandardItem(f'{group}   [{len(functions)} Giswater algorithm]')
            self.no_clickable_items.append(f'{group}   [{len(functions)} Giswater algorithm]')
            functions.sort(key=self.sort_list, reverse=False)
            for function in functions:
                func_name = QStandardItem(str(function['functionname']))
                label = QStandardItem(str(function['alias']))
                font = label.font()
                font.setPointSize(8)
                label.setFont(font)
                row = self.controller.check_function(function['functionname'])
                if not row:
                    if os.path.exists(path_icon_red):
                        icon = QIcon(path_icon_red)
                        label.setIcon(icon)
                        label.setForeground(QColor(255, 0, 0))
                        msg = f"Function {function['functionname']} configured on the table audit_cat_function, but not found in the database"
                        label.setToolTip(msg)
                        self.no_clickable_items.append(str(function['alias']))
                else:
                    if os.path.exists(path_icon_blue):
                        icon = QIcon(path_icon_blue)
                        label.setIcon(icon)
                        label.setToolTip(function['functionname'])
                enable_run = QStandardItem("True")
                if function['input_params'] is not None:
                    if 'btnRunEnabled' in function['input_params']:
                        bool_dict = {True: "True",  False:"False"}
                        enable_run = QStandardItem(bool_dict[function['input_params']['btnRunEnabled']])

                parent1.appendRow([label, func_name, enable_run])
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



