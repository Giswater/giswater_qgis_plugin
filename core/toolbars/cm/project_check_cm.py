"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

import platform
import os

from qgis.PyQt.QtCore import pyqtSignal
from qgis.PyQt.QtWidgets import QCheckBox, QTextEdit
from qgis.core import Qgis, QgsTask

from ...threads.task import GwTask
from ...utils import tools_gw
from ....libs import lib_vars, tools_qgis, tools_log, tools_qt, tools_os


class GwProjectCheckCMTask(GwTask):
    """
    Task to check project health in the background for Campaign Management.
    It executes a database function and passes the result back.
    """
    task_started = pyqtSignal()
    task_finished = pyqtSignal()

    def __init__(self, description, params=None):
        super().__init__(description)
        self.params = params if params else {}
        self.dialog = self.params.get('dialog')
        self.log_widget = self.params.get('log_widget')
        self.result_data = None

    def run(self):
        """
        Executes the main task.
        """
        super().run()
        self.task_started.emit()
        try:
            # Prepare the data and execute the database function to check the project.
            # Use hardcoded parameters based on user's working SQL call.
            project_type = "cm"
            function_fid = 0

            extras = (
                f'"parameters": {{"functionFid": {function_fid}, "project_type": "{project_type}"}}'
            )
            body = tools_gw.create_body(extras=extras)
            json_result = tools_gw.execute_procedure('gw_fct_setcheckproject_cm', body, schema_name='cm', conn=self.aux_conn)

            if json_result and isinstance(json_result, list):
                self.result_data = json_result[0]
                return True
            else:
                self.exception = "Invalid response from database function."
                return False

        except Exception as e:
            self.exception = e
            return False

    def finished(self, result):
        """
        Handles the task completion.
        """
        if result and not self.isCanceled() and self.result_data and self.log_widget:
            self.log_widget.clear()  # Clear previous logs
            checks = self.result_data.get('checks', [])
            if not checks:
                self.log_widget.setText("Project check returned no results.")
            else:
                for check in checks:
                    check_name = check.get('checkName', 'Unnamed Check')
                    # The result data is nested twice
                    inner_result = check.get('result', {}).get('result', [])
                    
                    if not inner_result:
                        self.log_widget.append(f"<b>{check_name}:</b> OK")
                    else:
                        self.log_widget.append(f"<b>{check_name}:</b>")
                        for item in inner_result:
                            self.log_widget.append(f"- {item}")
                    self.log_widget.append("") # Add a blank line for readability
        elif not self.log_widget:
            print("FATAL ERROR: Log widget object was not passed to the task.")

        # Let the parent class handle logging, connection closing, etc.
        super().finished(result)

        # Notify the UI that the task is completely finished
        self.task_finished.emit()

    def fill_check_project_table(self, layers, init_project):
        """ Fill table 'audit_check_project' table with layers data """

        fields = '"fields":[  '
        for layer in layers:
            if layer is None:
                continue
            if not tools_qgis.check_query_layer(layer):
                continue
            if layer.providerType() != 'postgres':
                continue
            layer_source = tools_qgis.get_layer_source(layer)
            if layer_source['schema'] is None:
                continue
            layer_source['schema'] = layer_source['schema'].replace('"', '')
            if layer_source.get('schema') != lib_vars.schema_name:
                continue

            schema_name = layer_source['schema']
            if schema_name is not None:
                schema_name = schema_name.replace('"', '')
                table_name = layer_source['table']
                db_name = layer_source['db']
                host_name = layer_source['host']
                table_user = layer_source['user']
                fields += f'{{"table_schema":"{schema_name}", '
                fields += f'"table_id":"{table_name}", '
                fields += f'"table_dbname":"{db_name}", '
                fields += f'"table_host":"{host_name}", '
                fields += '"fid":101, '
                fields += f'"table_user":"{table_user}"}}, '
        fields = fields[:-2] + ']'
        print("hooola")
        # Execute function 'gw_fct_setcheckproject'
        self.result = self._execute_check_project_function(init_project, fields)

        return True, self.result

    # region private functions

    def _execute_check_project_function(self, init_project, fields_to_insert):
        """ Execute function 'gw_fct_setcheckproject' with checkbox selections passed from project_check_btn.py """
        # Retrieve checkbox values from params
        show_versions = self.params.get("show_versions", False)
        show_qgis_project = self.params.get("show_qgis_project", False)

        # Get project variables
        add_schema = lib_vars.project_vars['add_schema']
        main_schema = lib_vars.project_vars['main_schema']
        project_role = lib_vars.project_vars['project_role']
        info_type = lib_vars.project_vars['info_type']
        project_type = lib_vars.project_vars['project_type']

        plugin_version, message = tools_qgis.get_plugin_version()
        if plugin_version is None:
            if message:
                tools_qgis.show_warning(message)

        # Get log folder size
        log_folder_volume = 0
        if lib_vars.user_folder_dir:
            log_folder = f"{lib_vars.user_folder_dir}{os.sep}core{os.sep}log"
            size = tools_os.get_folder_size(log_folder)
            log_folder_volume = f"{round(size / (1024 * 1024), 2)} MB"

        extras = f'"version":"{plugin_version}"'
        extras += ', "fid":101'
        extras += f', "initProject":{init_project}'
        extras += f', "addSchema":"{add_schema}"'
        extras += f', "mainSchema":"{main_schema}"'
        extras += f', "projecRole":"{project_role}"'
        extras += f', "infoType":"{info_type}"'
        extras += f', "logFolderVolume":"{log_folder_volume}"'
        extras += f', "projectType":"{project_type}"'
        extras += f', "qgisVersion":"{Qgis.QGIS_VERSION}"'
        extras += f', "osVersion":"{platform.system()} {platform.release()}"'
        extras += f', {fields_to_insert}'
        if show_versions or show_qgis_project:
            extras += f', "parameters": {{"showVersions": {str(show_versions).lower()}, "showQgisProject": {str(show_qgis_project).lower()}}}'

        # Execute procedure
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setcheckproject_cm', body, is_thread=True, aux_conn=self.aux_conn)
        print(result)
        if result:
            open_curselectors = tools_gw.get_config_parser('dialogs_actions', 'curselectors_open_loadproject', "user", "init")
            open_curselectors = tools_os.set_boolean(open_curselectors, False)
            tools_gw.manage_current_selections_docker(result, open=open_curselectors)
        try:
            if not result or (result['body']['variables']['hideForm'] is True):
                return result
        except KeyError as e:
            msg = "EXCEPTION: {0}, {1}"
            msg_params = (type(e).__name__, e,)
            tools_log.log_warning(msg, msg_params=msg_params)
            return result

        return result

    def _show_check_project_result(self, result):
        """ Show dialog with audit check project results """

        # Handle failed results
        if not result or result.get('status') == 'Failed':
            tools_gw.manage_json_exception(result)
            return False

        # Extract and combine all log messages from the different categories
        log_data = result['body']['data']
        all_logs = []
        for category in ['info', 'point', 'line', 'polygon']:
            if category in log_data and log_data[category]:
                all_logs.extend(log_data[category])

        # Call `fill_tab_log()` with the combined list of logs
        tools_gw.fill_tab_log(self.dlg_audit_project, all_logs, reset_text=False)

    def _add_selected_layers(self, dialog, m_layers):
        """ Receive a list of layers, look for the checks associated with each layer and if they are checked,
            load the corresponding layer and put styles
        :param dialog: Dialog where to look for QCheckBox (QDialog)
        :param m_layers: List with the information of the missing layers (list)[{...}, {...}, {...}, ...]
        :return:
        """

        for layer_info in m_layers:
            if layer_info == {}:
                continue

            check = dialog.findChild(QCheckBox, layer_info['layer'])
            if check.isChecked():
                geom_field = layer_info['geom_field']
                pkey_field = layer_info['pkey_field']
                group = layer_info['group_layer'] if layer_info['group_layer'] is not None else 'GW Layers'
                style_id = layer_info['style_id']

                tools_gw.add_layer_database(layer_info['layer'], geom_field, pkey_field, group=group)
                layer = None
                qml = None
                if style_id is not None:
                    layer = tools_qgis.get_layer_by_tablename(layer_info['layer'])
                    if layer:
                        extras = f'"style_id":"{style_id}"'
                        body = tools_gw.create_body(extras=extras)
                        style = tools_gw.execute_procedure('gw_fct_getstyle', body)
                        if not style or style['status'] == 'Failed':
                            return
                        if 'styles' in style['body']:
                            if 'style' in style['body']['styles']:
                                qml = style['body']['styles']['style']
                            tools_qgis.create_qml(layer, qml)
                tools_qgis.set_layer_visible(layer)

        tools_gw.close_dialog(self.dlg_audit_project)

    # endregion
