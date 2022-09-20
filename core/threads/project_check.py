"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

import platform
from functools import partial
import os

from qgis.PyQt.QtCore import Qt, pyqtSignal
from qgis.PyQt.QtWidgets import QCheckBox, QGridLayout, QLabel, QSizePolicy
from qgis.core import Qgis

from .task import GwTask
from ..utils import tools_gw
from ..ui.ui_manager import GwProjectCheckUi
from ... import global_vars
from ...lib import tools_qgis, tools_log, tools_qt, tools_os


class GwProjectCheckTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, description='', params=None, timer=None):

        super().__init__(description)
        self.params = params
        self.result = None
        self.dlg_audit_project = None
        self.timer = timer


    def run(self):

        super().run()

        layers = self.params['layers']
        init_project = self.params['init_project']
        self.dlg_audit_project = self.params['dialog']
        tools_log.log_info(f"Task 'Check project' execute function 'fill_check_project_table'")
        status, self.result = self.fill_check_project_table(layers, init_project)
        if not status:
            tools_log.log_info("Function fill_check_project_table returned False")
            return False

        return True


    def finished(self, result):

        super().finished(result)

        self.dlg_audit_project.progressBar.setVisible(False)
        if self.timer:
            self.timer.stop()
        if self.isCanceled():
            self.setProgress(100)
            return

        # Handle exception
        if self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)
            return

        # Show dialog with audit check project result
        self._show_check_project_result(self.result)

        self.setProgress(100)


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
            if layer_source.get('schema') != global_vars.schema_name:
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
                fields += f'"fid":101, '
                fields += f'"table_user":"{table_user}"}}, '
        fields = fields[:-2] + ']'

        # Execute function 'gw_fct_setcheckproject'
        result = self._execute_check_project_function(init_project, fields)

        return True, result


    # region private functions


    def _execute_check_project_function(self, init_project, fields_to_insert):
        """ Execute function 'gw_fct_setcheckproject' """

        # Get project variables
        add_schema = global_vars.project_vars['add_schema']
        main_schema = global_vars.project_vars['main_schema']
        project_role = global_vars.project_vars['project_role']
        info_type = global_vars.project_vars['info_type']
        project_type = global_vars.project_vars['project_type']

        plugin_version, message = tools_qgis.get_plugin_version()
        if plugin_version is None:
            if message:
                tools_qgis.show_warning(message)

        # Get log folder size
        log_folder_volume = 0
        if global_vars.user_folder_dir:
            log_folder = f"{global_vars.user_folder_dir}{os.sep}core{os.sep}log"
            size = tools_os.get_folder_size(log_folder)
            log_folder_volume = f"{round(size / (1024*1024), 2)} MB"

        extras = f'"version":"{plugin_version}"'
        extras += f', "fid":101'
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

        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setcheckproject', body, is_thread=True, aux_conn=self.aux_conn)
        if result:
            open_curselectors = tools_gw.get_config_parser('dialogs_actions', 'curselectors_open_loadproject', "user", "init")
            open_curselectors = tools_os.set_boolean(open_curselectors, False)
            tools_gw.manage_current_selections_docker(result, open=open_curselectors)
        try:
            if not result or (result['body']['variables']['hideForm'] is True):
                return result
        except KeyError as e:
            tools_log.log_warning(f"EXCEPTION: {type(e).__name__}, {e}")
            return result

        return result


    def _show_check_project_result(self, result):
        """ Show dialog with audit check project results """

        # Populate info_log and missing layers
        critical_level = 0
        text_result = tools_gw.add_layer_temp(self.dlg_audit_project, result['body']['data'],
                                              'gw_fct_setcheckproject_result', True, False, 0, True,
                                              call_set_tabs_enabled=False)

        tools_qt.hide_void_groupbox(self.dlg_audit_project)
        if int(critical_level) > 0 or text_result:
            self.dlg_audit_project.btn_accept.clicked.connect(partial(self._add_selected_layers, self.dlg_audit_project,
                                                                      result['body']['data']['missingLayers']))


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
