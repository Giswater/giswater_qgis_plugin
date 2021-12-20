"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMessageBox
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsMessageLog, QgsLayerTreeLayer, QgsVectorLayer, QgsDataSourceUri

from ... import global_vars
from ..utils import tools_gw
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


def set_style_mapzones(**kwargs):
    """ A bridge function to call tools_gw->set_style_mapzones """
    """ Function called in def get_actions_from_json(...) --> getattr(tools_backend_calls, f"{function_name}")(**params) """

    tools_gw.set_style_mapzones()


def add_query_layer(**kwargs):
    """ Create and add a QueryLayer to ToC """
    """ Function called in def get_actions_from_json(...) --> getattr(tools_backend_calls, f"{function_name}")(**params) """

    query = kwargs['query']
    layer_name = kwargs['layerName'] if 'layerName' in kwargs else 'QueryLayer'
    group = kwargs['group'] if 'group' in kwargs else 'GW Layers'

    uri = tools_db.get_uri()

    querytext = f"(SELECT row_number() over () AS _uid_,* FROM ({query}) AS query_table)"
    pk = '_uid_'

    uri.setDataSource("", querytext, None, "", pk)
    vlayer = QgsVectorLayer(uri.uri(False), f'{layer_name}', "postgres")

    if vlayer.isValid():
        tools_qt.add_layer_to_toc(vlayer, group)


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
        qgis_project_infotype = global_vars.project_vars['info_type']

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

            # Set multiline fields according table config_form_fields.widgetcontrols['setMultiline']
            if field['widgetcontrols'] is not None and 'setMultiline' in field['widgetcontrols'] and field['widgetcontrols']['setMultiline']:
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
    except Exception:
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
    """ Set multiline selected fields according table config_form_fields.widgetcontrols['setMultiline'] """

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
        if field['widgetcontrols'] and 'setMultiline' in field['widgetcontrols'] and field['widgetcontrols']['setMultiline']:
            editor_widget_setup = QgsEditorWidgetSetup(
                'TextEdit', {'IsMultiline': field['widgetcontrols']['setMultiline']})
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


def update_catfeaturevalues(**kwargs):
    """
    Reload global_vars.feature_cat

    Called from PostgreSQL -> PERFORM pg_notify(v_channel, '{"functionAction":{"functions":[
                              {"name":"update_catfeaturevalues", "parameters":{}}]} ,
                              "user":"'||current_user||'","schema":"'||v_schemaname||'"}');
                IN TRIGGER -> gw_trg_cat_feature
    """
    global_vars.feature_cat = tools_gw.manage_feature_cat()


def open_url(widget):
    """ Function called in def add_hyperlink(field): -->
        widget.clicked.connect(partial(getattr(tools_backend_calls, func_name), widget)) """

    status, message = tools_os.open_file(widget.text())
    if status is False and message is not None:
        tools_qgis.show_warning(message, parameter=widget.text())


def get_selector(**kwargs):
    """
    Refreshes the selectors if the selector dialog is open

    Called form PostgreSQL -> PERFORM pg_notify(v_channel,
                              '{"functionAction":{"functions":[
                              {"name":"get_selector","parameters":{"tab":"tab_psector"}}]}
                              ,"user":"'||current_user||'", "schema":"'||v_schemaname||'"}');
    Function connected -> global_vars.signal_manager.refresh_selectors.connect(tools_gw.refresh_selectors)
    """

    tab_name = kwargs['tab'] if 'tab' in kwargs else None
    global_vars.signal_manager.refresh_selectors.emit(tab_name)


def show_message(**kwargs):
    """
    Shows a message in the message bar.

    Called from PostgreSQL -> PERFORM pg_notify(v_channel,
                              '{"functionAction":{"functions":[{"name":"show_message", "parameters":
                              {"level":1, "duration":10, "text":"Current psector have been selected"}}]}
                              ,"user":"'||current_user||'", "schema":"'||v_schemaname||'"}');
    Function connected -> global_vars.signal_manager.show_message.connect(tools_qgis.show_message)
    """

    text = kwargs['text'] if 'text' in kwargs else 'No message found'
    level = kwargs['level'] if 'level' in kwargs else 1
    duration = kwargs['duration'] if 'duration' in kwargs else 10

    global_vars.signal_manager.show_message.emit(text, level, duration)


# region unused functions atm

def get_all_layers(group, all_layers):

    for child in group.children():
        if isinstance(child, QgsLayerTreeLayer):
            all_layers.append(child.layer().name())
            child.layer().name()
        else:
            get_all_layers(child)

# endregion
