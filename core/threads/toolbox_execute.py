"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDoubleSpinBox, QSpinBox, QWidget, QLineEdit
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsTask
from qgis.gui import QgsDateTimeEdit

from ..utils import tools_gw
from ...lib import tools_log, tools_qt
from .task import GwTask


class GwToolBoxTask(GwTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, toolbox, description, dialog, combo, result):

        super().__init__(description, QgsTask.CanCancel)
        self.toolbox = toolbox
        self.dialog = dialog
        self.combo = combo
        self.result = result
        self.json_result = None
        self.exception = None


    def run(self):
        extras = ''
        feature_field = ''

        # Get function name
        function = None
        function_name = None
        for group, function in list(self.result['fields'].items()):
            if len(function) != 0:
                self.toolbox.save_settings_values(self.dialog, function)
                self.toolbox.save_parametric_values(self.dialog, function)
                function_name = function[0]['functionname']
                break

        if function_name is None:
            return False

        if function[0]['input_params']['featureType']:
            layer = None

            layer_name = tools_qt.get_combo_value(self.dialog, self.combo, 1)
            if layer_name != -1:
                layer = self.toolbox.set_selected_layer(self.dialog, self.combo)
                if not layer:
                    return False


            selection_mode = self.toolbox.rbt_checked['widget']
            extras += f'"selectionMode":"{selection_mode}",'
            # Check selection mode and get (or not get) all feature id
            feature_id_list = '"id":['
            if (selection_mode == 'wholeSelection') or (selection_mode == 'previousSelection' and layer is None):
                feature_id_list += ']'
            elif selection_mode == 'previousSelection' and layer is not None:
                features = layer.selectedFeatures()
                feature_type = tools_qt.get_combo_value(self.dialog, self.dialog.cmb_geom_type, 0)
                for feature in features:
                    feature_id = feature.attribute(feature_type + "_id")
                    feature_id_list += f'"{feature_id}", '
                if len(features) > 0:
                    feature_id_list = feature_id_list[:-2] + ']'
                else:
                    feature_id_list += ']'

            if layer_name != -1:
                feature_field = f'"tableName":"{layer_name}", '
                feature_type = tools_qt.get_combo_value(self.dialog, self.dialog.cmb_geom_type, 0)
                feature_field += f'"featureType":"{feature_type}", '
            feature_field += feature_id_list

        widget_list = self.dialog.grb_parameters.findChildren(QWidget)
        widget_is_void = False
        extras += '"parameters":{'
        for group, function in list(self.result['fields'].items()):
            if len(function) != 0:
                if function[0]['return_type'] not in (None, ''):
                    for field in function[0]['return_type']:
                        widget = self.dialog.findChild(QWidget, field['widgetname'])
                        param_name = widget.objectName()
                        if type(widget) in ('', QLineEdit):
                            widget.setStyleSheet(None)
                            value = tools_qt.get_text(self.dialog, widget, False, False)
                            extras += f'"{param_name}":"{value}", '.replace('""', 'null')
                            if value is '' and widget.property('ismandatory'):
                                widget_is_void = True
                                widget.setStyleSheet("border: 1px solid red")
                        elif type(widget) in ('', QSpinBox, QDoubleSpinBox):
                            value = tools_qt.get_text(self.dialog, widget, False, False)
                            if value == '':
                                value = 0
                            extras += f'"{param_name}":"{value}", '
                        elif type(widget) in ('', QComboBox):
                            value = tools_qt.get_combo_value(self.dialog, widget, 0)
                            extras += f'"{param_name}":"{value}", '
                        elif type(widget) in ('', QCheckBox):
                            value = tools_qt.is_checked(self.dialog, widget)
                            extras += f'"{param_name}":"{str(value).lower()}", '
                        elif type(widget) in ('', QgsDateTimeEdit):
                            value = tools_qt.get_calendar_date(self.dialog, widget)
                            if value == "" or value is None:
                                extras += f'"{param_name}":null, '
                            else:
                                extras += f'"{param_name}":"{value}", '
        if widget_is_void:
            message = "This param is mandatory. Please, set a value"
            tools_log.log_info(message, parameter='')
            return False

        if len(widget_list) > 0:
            extras = extras[:-2] + '}'
        else:
            extras += '}'
        body = tools_gw.create_body(feature=feature_field, extras=extras)
        self.json_result = tools_gw.execute_procedure(function_name, body, log_sql=True, is_thread=True)
        if self.json_result['status'] == 'Failed': return False
        if not self.json_result or self.json_result is None: return False

        try:
            # getting simbology capabilities
            if 'setStyle' in self.json_result['body']['data']:
                set_sytle = self.json_result['body']['data']['setStyle']
                if set_sytle == "Mapzones":
                    # call function to simbolize mapzones
                    tools_gw.set_style_mapzones()

        except KeyError as e:
            self.exception = e
            return False

        return True


    def finished(self, result):
        self.dialog.btn_cancel.setEnabled(False)
        self.dialog.progressBar.setVisible(False)
        if result is False and self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)
        else:
            tools_gw.fill_tab_log(self.dialog, self.json_result['body']['data'], True, True, 1, True)


    def cancel(self):
        self.toolbox.remove_layers()
        super().cancel()