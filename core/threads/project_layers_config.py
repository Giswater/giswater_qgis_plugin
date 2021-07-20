"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints

from .task import GwTask
from ..utils import tools_gw
from ...lib import tools_log, tools_qgis, tools_qt, tools_db


class GwProjectLayersConfig(GwTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, params):

        super().__init__(description)
        self.exception = None
        self.message = None
        self.available_layers = None
        self.project_type = params['project_type']
        self.schema_name = params['schema_name']
        self.qgis_project_infotype = params['qgis_project_infotype']
        self.db_layers = params['db_layers']
        self.body = None
        self.json_result = None


    def run(self):

        super().run()
        self.setProgress(0)
        self._get_layers_to_config()
        self._set_layer_config(self.available_layers)
        self.setProgress(100)

        return True


    def finished(self, result):

        super().finished(result)

        sql = f"SELECT gw_fct_getinfofromid("
        if self.body:
            sql += f"{self.body}"
        sql += f");"
        tools_gw.manage_json_response(self.json_result, sql, None)

        # If user cancel task
        if self.isCanceled():
            return

        if result:
            return

        # If sql function return null
        if result is False:
            msg = f"Database returned null. Check postgres function 'gw_fct_getinfofromid'"
            tools_log.log_warning(msg)

        if self.exception:
            tools_log.log_info(f"Task aborted: {self.description()}")
            tools_log.log_warning(f"Exception: {self.exception}")
            raise self.exception


    # region private functions


    def _get_layers_to_config(self):
        """ Get available layers to be configured """

        self.available_layers = [layer[0] for layer in self.db_layers]

        self._set_form_suppress(self.available_layers)
        all_layers_toc = tools_qgis.get_project_layers()
        for layer in all_layers_toc:
            layer_source = tools_qgis.get_layer_source(layer)
            # Filter to take only the layers of the current schema
            if 'schema' in layer_source:
                schema = layer_source['schema']
                if schema and schema.replace('"', '') == self.schema_name:
                    table_name = f"{tools_qgis.get_layer_source_table_name(layer)}"
                    if table_name not in self.available_layers: self.available_layers.append(table_name)

    def _set_form_suppress(self, layers_list):
        """ Set form suppress on "Hide form on add feature (global settings) """

        for layer_name in layers_list:
            layer = tools_qgis.get_layer_by_tablename(layer_name)
            if layer is None: continue
            config = layer.editFormConfig()
            config.setSuppress(0)
            layer.setEditFormConfig(config)


    def _set_layer_config(self, layers):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos as ValueMap, typeahead as textedit"""

        # Check only once if function 'gw_fct_getinfofromid' exists
        row = tools_db.check_function('gw_fct_getinfofromid')
        if row in (None, ''):
            tools_qgis.show_warning("Function not found in database", parameter='gw_fct_getinfofromid')
            return False

        msg_failed = ""
        msg_key = ""
        total_layers = len(layers)
        layer_number = 0
        for layer_name in layers:

            if self.isCanceled():
                return False

            layer = tools_qgis.get_layer_by_tablename(layer_name)
            if not layer:
                continue

            layer_number = layer_number + 1
            self.setProgress((layer_number * 100) / total_layers)

            feature = f'"tableName":"{layer_name}", "isLayer":true'
            self.body = self._create_body(feature=feature)
            self.json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', self.body, aux_conn=self.aux_conn,
                                                          is_thread=True, check_function=False)
            if not self.json_result:
                continue
            if 'status' not in self.json_result:
                continue
            if self.json_result['status'] == 'Failed':
                continue
            if 'body' not in self.json_result:
                tools_log.log_info("Not 'body'")
                continue
            if 'data' not in self.json_result['body']:
                tools_log.log_info("Not 'data'")
                continue

            for field in self.json_result['body']['data']['fields']:
                valuemap_values = {}

                # Get column index
                field_index = layer.fields().indexFromName(field['columnname'])

                # Hide selected fields according table config_form_fields.hidden
                if 'hidden' in field:
                    self._set_column_visibility(layer, field['columnname'], field['hidden'])

                # Set alias column
                if field['label']:
                    layer.setFieldAlias(field_index, field['label'])

                # widgetcontrols
                if 'widgetcontrols' in field:

                    # Set field constraints
                    if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                        if field['widgetcontrols']['setQgisConstraints'] is True:
                            layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintNotNull,
                                                     QgsFieldConstraints.ConstraintStrengthSoft)
                            layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintUnique,
                                                     QgsFieldConstraints.ConstraintStrengthHard)

                if 'ismandatory' in field and not field['ismandatory']:
                    layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintNotNull,
                                             QgsFieldConstraints.ConstraintStrengthSoft)

                # Manage editability
                self._set_read_only(layer, field, field_index)

                # delete old values on ValueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)

                # Manage new values in ValueMap
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        # Set values
                        for i in range(0, len(field['comboIds'])):
                            valuemap_values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)
                elif field['widgettype'] == 'check':
                    config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                    editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)
                elif field['widgettype'] == 'datetime':
                    config = {'allow_null': True,
                              'calendar_popup': True,
                              'display_format': 'yyyy-MM-dd',
                              'field_format': 'yyyy-MM-dd',
                              'field_iso_format': False}
                    editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)
                elif field['widgettype'] == 'textarea':
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)
                else:
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'False'})
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)

                # multiline: key comes from widgecontrol but it's used here in order to set false when key is missing
                if field['widgettype'] == 'text':
                    self._set_column_multiline(layer, field, field_index)

        if msg_failed != "":
            tools_qt.show_exception_message("Execute failed.", msg_failed)

        if msg_key != "":
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg_key)


    def _set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_form_fields (field 'iseditable') """

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


    def _set_column_visibility(self, layer, col_name, hidden):
        """ Hide selected fields according table config_form_fields.hidden """

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def _set_column_multiline(self, layer, field, field_index):
        """ Set multiline selected fields according table config_form_fields.widgetcontrols['setMultiline'] """

        if field['widgetcontrols'] and 'setMultiline' in field['widgetcontrols']:
            editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': field['widgetcontrols']['setMultiline']})
        else:
            editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': False})
        layer.setEditorWidgetSetup(field_index, editor_widget_setup)


    def _create_body(self, form='', feature='', filter_fields='', extras=None):
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

    # endregion