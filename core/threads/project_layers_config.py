"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

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
        self.vr_errors = None
        self.vr_missing = None


    def run(self):

        super().run()
        self.setProgress(0)
        self.vr_errors = set()
        self.vr_missing = set()
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
            if self.exception:
                if self.message:
                    tools_log.log_warning(f"{self.message}")
            return

        # If sql function return null
        if result is False:
            msg = f"Task failed: {self.description()}. This is probably a DB error, check postgres function" \
                  f" 'gw_fct_getinfofromid'."
            tools_log.log_warning(msg)

        if self.exception:
            tools_log.log_info(f"Task aborted: {self.description()}")
            tools_log.log_warning(f"Exception: {self.exception}")


    # region private functions


    def _get_layers_to_config(self):
        """ Get available layers to be configured """

        self.available_layers = [layer[0] for layer in self.db_layers]

        self._set_form_suppress(self.available_layers)
        all_layers_toc = tools_qgis.get_project_layers()
        for layer in all_layers_toc:
            layer_source = tools_qgis.get_layer_source(layer)
            # Filter to take only the layers of the current schema
            schema = layer_source.get('schema')
            if schema and schema.replace('"', '') == self.schema_name:
                table_name = f"{tools_qgis.get_layer_source_table_name(layer)}"
                if table_name not in self.available_layers:
                    self.available_layers.append(table_name)


    def _set_form_suppress(self, layers_list):
        """ Set form suppress on "Hide form on add feature (global settings) """

        for layer_name in layers_list:
            layer = tools_qgis.get_layer_by_tablename(layer_name)
            if layer is None:
                continue
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
            self.body = tools_gw.create_body(feature=feature)
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

            tools_gw.config_layer_attributes(self.json_result, layer, layer_name, thread=self)

        if msg_failed != "":
            tools_qt.show_exception_message("Execute failed.", msg_failed)

        if msg_key != "":
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg_key)

    # endregion
