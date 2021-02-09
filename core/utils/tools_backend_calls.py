"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMessageBox, QWidget
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsMessageLog, QgsLayerTreeLayer, QgsProject, \
    QgsVectorLayer, QgsVectorLayerExporter, QgsDataSourceUri

from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_log, tools_os, tools_db


def set_layer_index(**kwargs):
    """ Force reload dataProvider of layer """
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Get list of layer names
    layers_name_list = kwargs['tableName']
    if not layers_name_list:
        return
    if type(layers_name_list) == str:
        tools_qgis.set_layer_index(layers_name_list)
    if type(layers_name_list) == list:
        for layer_name in layers_name_list:
            tools_qgis.set_layer_index(layer_name)


def refresh_attribute_table(**kwargs):
    """ Set layer fields configured according to client configuration.
        At the moment manage:
            Column names as alias, combos and typeahead as ValueMap"""
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Get list of layer names
    layers_name_list = kwargs['tableName']
    if not layers_name_list:
        return

    for layer_name in layers_name_list:
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer:
            msg = f"Layer {layer_name} does not found, therefore, not configured"
            tools_log.log_info(msg)
            continue

        # Get sys variale
        qgis_project_infotype = tools_qgis.get_plugin_settings_value('infoType')

        feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
        extras = f'"infoType":"{qgis_project_infotype}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
        if not result:
            continue
        for field in result['body']['data']['fields']:
            _values = {}
            # Get column index
            field_idx = layer.fields().indexFromName(field['columnname'])

            # Hide selected fields according table config_form_fields.hidden
            if 'hidden' in field:
                kwargs = {"layer": layer, "field": field['columnname'], "hidden": field['hidden']}
                set_column_visibility(**kwargs)

            # Set multiline fields according table config_form_fields.widgetcontrols['setQgisMultiline']
            if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
                set_column_multiline(**kwargs)
            # Set alias column
            if field['label']:
                layer.setFieldAlias(field_idx, field['label'])

            # Set field constraints
            if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                if field['widgetcontrols']['setQgisConstraints'] is True:
                    layer.setFieldConstraint(field_idx, QgsFieldConstraints.ConstraintNotNull,
                                             QgsFieldConstraints.ConstraintStrengthSoft)
                    layer.setFieldConstraint(field_idx, QgsFieldConstraints.ConstraintUnique,
                                             QgsFieldConstraints.ConstraintStrengthHard)

            # Manage editability
            kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
            set_read_only(**kwargs)

            # Manage fields
            if field['widgettype'] == 'combo':
                if 'comboIds' in field:
                    for i in range(0, len(field['comboIds'])):
                        _values[field['comboNames'][i]] = field['comboIds'][i]
                # Set values into valueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            elif field['widgettype'] == 'text':
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            elif field['widgettype'] == 'check':
                config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            elif field['widgettype'] == 'datetime':
                config = {'allow_null': True,
                          'calendar_popup': True,
                          'display_format': 'yyyy-MM-dd',
                          'field_format': 'yyyy-MM-dd',
                          'field_iso_format': False}
                editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            else:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)


def refresh_canvas(**kwargs):
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
    # self.canvas.refreshAllLayers()
    # Get list of layer names
    try:
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        if type(layers_name_list) == str:
            layer = tools_qgis.get_layer_by_tablename(layers_name_list)
            layer.triggerRepaint()
        elif type(layers_name_list) == list:
            for layer_name in layers_name_list:
                tools_qgis.set_layer_index(layer_name)
    except:
        all_layers = tools_qgis.get_project_layers()
        for layer in all_layers:
            layer.triggerRepaint()


def set_column_visibility(**kwargs):
    """ Hide selected fields according table config_form_fields.hidden """

    try:
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        col_name = kwargs["field"]
        hidden = kwargs["hidden"]
    except Exception as e:
        tools_log.log_info(f"{kwargs}-->{type(e).__name__} --> {e}")
        return

    config = layer.attributeTableConfig()
    columns = config.columns()
    for column in columns:
        if column.name == str(col_name):
            column.hidden = hidden
            break
    config.setColumns(columns)
    layer.setAttributeTableConfig(config)


def set_column_multiline(**kwargs):
    """ Set multiline selected fields according table config_form_fields.widgetcontrols['setQgisMultiline'] """

    try:
        field = kwargs["field"]
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        field_index = kwargs["fieldIndex"]
    except Exception as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return

    if field['widgettype'] == 'text':
        if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
            editor_widget_setup = QgsEditorWidgetSetup(
                'TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
            layer.setEditorWidgetSetup(field_index, editor_widget_setup)


def set_read_only(**kwargs):
    """ Set field readOnly according to client configuration into config_form_fields (field 'iseditable') """

    try:
        field = kwargs["field"]
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        field_index = kwargs["fieldIndex"]
    except Exception as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return
    # Get layer config
    config = layer.editFormConfig()
    try:
        # Set field editability
        config.setReadOnly(field_index, not field['iseditable'])
    except KeyError:
        # Control if key 'iseditable' not exist
        pass
    finally:
        # Set layer config
        layer.setEditFormConfig(config)


def load_qml(**kwargs):
    """ Apply QML style located in @qml_path in @layer
    :param kwargs:{"layerName": "v_edit_arc", "qmlPath": "C:\\xxxx\\xxxx\\xxxx\\qml_file.qml"}
    :return: Boolean value
    """

    # Get layer
    layer = tools_qgis.get_layer_by_tablename(kwargs['layerName']) if 'layerName' in kwargs else None
    if layer is None:
        return False

    # Get qml path
    qml_path = kwargs['qmlPath'] if 'qmlPath' in kwargs else None

    if not os.path.exists(qml_path):
        tools_log.log_warning("File not found", parameter=qml_path)
        return False

    if not qml_path.endswith(".qml"):
        tools_log.log_warning("File extension not valid", parameter=qml_path)
        return False

    layer.loadNamedStyle(qml_path)
    layer.triggerRepaint()

    return True


def open_url(widget):
    """ Function called in def add_hyperlink(field): -->
            widget.clicked.connect(partial(getattr(tools_backend_calls, func_name), widget))"""
    tools_os.open_url(widget)




# region unused functions atm
def show_message(**kwargs):

    """
    PERFORM pg_notify(current_user,
              '{"functionAction":{"functions":[{"name":"show_message","parameters":
              {"message":"line 1 \n line 2","tabName":"Notify channel",
              "styleSheet":{"level":1,"color":"red","bold":true}}}]},"user":"postgres","schema":"ws_sample"}');

    functions called in -> getattr(self, function_name)(**params):
    Show message in console log,
    :param kwargs: dict with all needed
        kwargs: ['message']: message to show
        kwargs: ['tabName']: tab where the info will be displayed
        kwargs: ['styleSheet']:  define text format (message type, color, and bold), 0 = Info(black),
                     1 = Warning(orange), 2 = Critical(red), 3 = Success(blue), 4 = None(black)
        kwargs: ['styleSheet']['level']: 0 = Info(black), 1 = Warning(orange), 2 = Critical(red), 3 = Success(blue),
                    4 = None(black)
        kwargs: ['styleSheet']['color']: can be like "red", "green", "orange", "pink"...typical html colors
        kwargs: ['styleSheet']['bold']: if is true, then print as bold
    :return:
    """

    # Set default styleSheet
    color = "black"
    level = 0
    bold = ''

    msg = kwargs['message'] if 'message' in kwargs else 'No message found'
    tab_name = kwargs['tabName'] if 'tabName' in kwargs else 'Notify channel'
    if 'styleSheet' in kwargs:
        color = kwargs['styleSheet']['color'] if 'color' in kwargs['styleSheet'] else "black"
        level = kwargs['styleSheet']['level'] if 'level' in kwargs['styleSheet'] else 0
        if 'bold' in kwargs['styleSheet']:
            bold = 'b' if kwargs['styleSheet']['bold'] else ''
        else:
            bold = ''

    msg = f'<font color="{color}"><{bold}>{msg}</font>'
    QgsMessageLog.logMessage(msg, tab_name, level)


def show_messagebox(**kwargs):
    """ Shows a message box with detail information """

    msg = kwargs['message'] if 'message' in kwargs else 'No message found'
    title = kwargs['title'] if 'title' in kwargs else 'New message'
    inf_text = kwargs['inf_text'] if 'inf_text' in kwargs else 'Info text'
    msg_box = QMessageBox()
    msg_box.setText(msg)
    if title:
        title = tools_qt.tr(title)
        msg_box.setWindowTitle(title)
    if inf_text:
        inf_text = tools_qt.tr(inf_text)
        msg_box.setInformativeText(inf_text)
    msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
    msg_box.setStandardButtons(QMessageBox.Ok)
    msg_box.setDefaultButton(QMessageBox.Ok)
    msg_box.open()


def raise_notice(**kwargs):
    """ Used to show raise notices sent by postgresql
    Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params)

    """

    msg_list = kwargs['msg']
    for msg in msg_list:
        tools_log.log_info(f"{msg}")


def get_all_layers(group, all_layers):

    for child in group.children():
        if isinstance(child, QgsLayerTreeLayer):
            all_layers.append(child.layer().name())
            child.layer().name()
        else:
            get_all_layers(child)

# endregion