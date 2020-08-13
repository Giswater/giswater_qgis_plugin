"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints

import os

from ..actions.api_parent import ApiParent


class GwInfoTools(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control functions called from data base """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def set_layer_index(self, **kwargs):
        """ Force reload dataProvider of layer """
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        if type(layers_name_list) == str:
            self.controller.set_layer_index(layers_name_list)
        if type(layers_name_list) == list:
            for layer_name in layers_name_list:
                self.controller.set_layer_index(layer_name)


    def refresh_attribute_table(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos and typeahead as ValueMap"""

        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return

        for layer_name in layers_name_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                msg = f"Layer {layer_name} does not found, therefore, not configured"
                self.controller.log_info(msg)
                continue

            # get sys variale
            self.qgis_project_infotype = self.controller.plugin_settings_value('infoType')

            feature = '"tableName":"' + str(layer_name) + '", "id":""'
            extras = f'"infoType":"{self.qgis_project_infotype}"'
            body = self.create_body(feature=feature, extras=extras)
            result = self.controller.get_json('gw_fct_getinfofromid', body, is_notify=True, log_sql=True)
            if not result:
                continue
            for field in result['body']['data']['fields']:
                _values = {}
                # Get column index
                field_idx = layer.fields().indexFromName(field['columnname'])
                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    kwargs = {"layer": layer, "field": field['columnname'], "hidden": field['hidden']}
                    self.set_column_visibility(**kwargs)

                # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                    kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
                    self.set_column_multiline(**kwargs)
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
                self.set_read_only(**kwargs)

                # Manage fields
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        for i in range(0, len(field['comboIds'])):
                            _values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                    layer.setEditorWidgetSetup(field_idx, editor_widget_setup)


    def refresh_canvas(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

        # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
        # self.canvas.refreshAllLayers()
        all_layers = self.controller.get_layers()
        for layer in all_layers:
            layer.triggerRepaint()


    def set_column_visibility(self, **kwargs):
        """ Hide selected fields according table config_api_form_fields.hidden """

        try:
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            col_name = kwargs["field"]
            hidden = kwargs["hidden"]
        except Exception as e:
            self.controller.log_info(f"{kwargs}-->{type(e).__name__} --> {e}")
            return

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, **kwargs):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        try:
            field = kwargs["field"]
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            field_index = kwargs["fieldIndex"]
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")
            return

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup(
                    'TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)


    def set_read_only(self, **kwargs):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable') """

        try:
            field = kwargs["field"]
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            field_index = kwargs["fieldIndex"]
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")
            return
        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError as e:
            # Control if key 'iseditable' not exist
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def load_qml(self, **kwargs):
        """ Apply QML style located in @qml_path in @layer
        :param params:[{"funcName": "load_qml",
                        "params": {"layerName": "v_edit_arc",
                        "qmlPath": "C:\\xxxx\\xxxx\\xxxx\\qml_file.qml"}}]
        :return: Boolean value
        """

        # Get layer
        layer = self.controller.get_layer_by_tablename(kwargs['layerName']) if 'layerName' in kwargs else None
        if layer is None:
            return False

        # Get qml path
        qml_path = kwargs['qmlPath'] if 'qmlPath' in kwargs else None

        if not os.path.exists(qml_path):
            self.controller.log_warning("File not found", parameter=qml_path)
            return False

        if not qml_path.endswith(".qml"):
            self.controller.log_warning("File extension not valid", parameter=qml_path)
            return False

        layer.loadNamedStyle(qml_path)
        layer.triggerRepaint()

        return True
