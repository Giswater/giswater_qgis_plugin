"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsTask


class GwConfigLayerTask(QgsTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, controller):

        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.controller = controller
        self.message = None
        self.available_layers = None
        self.get_layers = True
        self.project_type = None
        self.schema_name = None
        self.qgis_project_infotype = None


    def run(self):

        self.controller.log_info(f"Task started: {self.description()}")

        self.setProgress(0)
        if self.get_layers:
            # self.controller.log_info("get_layers_to_config")
            self.get_layers_to_config()
        self.set_layer_config(self.available_layers)
        self.setProgress(100)

        return True


    def finished(self, result):

        if result:
            self.controller.log_info(f"Task finished: {self.description()}")
            return

        if self.exception:
            self.controller.log_info(f"Task aborted: {self.description()}")
            self.controller.log_warning(f"Exception: {self.exception}")
            raise self.exception


    def cancel(self):

        self.controller.log_info(f"Task cancelled: {self.description()}")
        super().cancel()


    def set_params(self, project_type, schema_name, qgis_project_infotype, get_layers=True):

        self.project_type = project_type
        self.schema_name = schema_name
        self.qgis_project_infotype = qgis_project_infotype
        self.get_layers = get_layers


    def get_layers_to_config(self):
        """ Get available layers to be configured """

        schema_name = self.schema_name.replace('"', '')
        sql = (f"SELECT DISTINCT(parent_layer) FROM cat_feature "
              f"UNION "
              f"SELECT DISTINCT(child_layer) FROM cat_feature "
              f"WHERE child_layer IN ("
              f"     SELECT table_name FROM information_schema.tables"
              f"     WHERE table_schema = '{schema_name}')")
        rows = self.controller.get_rows(sql)
        self.available_layers = [layer[0] for layer in rows]

        self.set_form_suppress(self.available_layers)
        all_layers_toc = self.controller.get_layers()
        for layer in all_layers_toc:
            layer_source = self.controller.get_layer_source(layer)
            # Filter to take only the layers of the current schema
            if 'schema' in layer_source:
                schema = layer_source['schema']
                if schema and schema.replace('"', '') == self.schema_name:
                    table_name = f"{self.controller.get_layer_source_table_name(layer)}"
                    self.available_layers.append(table_name)


    def set_form_suppress(self, layers_list):
        """ Set form suppress on "Hide form on add feature (global settings) """

        for layer_name in layers_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if layer is None: continue
            config = layer.editFormConfig()
            config.setSuppress(0)
            layer.setEditFormConfig(config)


    def set_layer_config(self, layers):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos as ValueMap, typeahead as textedit"""

        self.controller.log_info("Start set_layer_config")

        msg_failed = ""
        msg_key = ""
        total_layers = len(layers)
        layer_number = 0
        for layer_name in layers:

            if self.isCanceled():
                return False

            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                continue

            layer_number = layer_number + 1
            self.setProgress((layer_number * 100) / total_layers)

            feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
            extras = f'"infoType":"{self.qgis_project_infotype}"'
            body = self.create_body(feature=feature, extras=extras)
            complet_result = self.controller.get_json('gw_fct_getinfofromid', body, log_sql=False)
            if not complet_result:
                continue

            # self.controller.log_info(str(complet_result))
            if not 'body' in complet_result:
                self.controller.log_info("Not 'body'")
                continue
            if not 'data' in complet_result['body']:
                self.controller.log_info("Not 'data'")
                continue

            # self.controller.log_info(complet_result['body']['data']['fields'])
            for field in complet_result['body']['data']['fields']:
                valuemap_values = {}

                # Get column index
                fieldIndex = layer.fields().indexFromName(field['columnname'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['columnname'], field['hidden'])

                # Set alias column
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                if 'widgetcontrols' in field:
                    # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                    if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                        self.set_column_multiline(layer, field, fieldIndex)

                    # Set field constraints
                    if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                        if field['widgetcontrols']['setQgisConstraints'] is True:
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                                QgsFieldConstraints.ConstraintStrengthSoft)
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintUnique,
                                QgsFieldConstraints.ConstraintStrengthHard)

                if 'ismandatory' in field and not field['ismandatory']:
                    layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                        QgsFieldConstraints.ConstraintStrengthSoft)

                # Manage editability
                self.set_read_only(layer, field, fieldIndex)

                # delete old values on ValueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)

                # Manage new values in ValueMap
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        # Set values
                        for i in range(0, len(field['comboIds'])):
                            valuemap_values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                elif field['widgettype'] == 'check':
                    config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                    editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                elif field['widgettype'] == 'datetime':
                    config = {'allow_null': True,
                              'calendar_popup': True,
                              'display_format': 'yyyy-MM-dd',
                              'field_format': 'yyyy-MM-dd',
                              'field_iso_format': False}
                    editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                else:
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)

        if msg_failed != "":
            self.controller.show_exceptions_msg("Execute failed.", msg_failed)

        if msg_key != "":
            self.controller.show_exceptions_msg("Key on returned json from ddbb is missed.", msg_key)

        self.controller.log_info("Finish set_layer_config")


    def set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable') """

        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError:
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def set_column_visibility(self, layer, col_name, hidden):
        """ Hide selected fields according table config_api_form_fields.hidden """

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, layer, field, fieldIndex):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
        form = '"form":{' + form + '}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body

