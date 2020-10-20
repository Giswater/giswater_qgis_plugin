"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import Qgis
from qgis.PyQt.QtWidgets import QCheckBox, QGridLayout, QLabel, QSizePolicy

import platform
from functools import partial

from .. import global_vars
from .utils.tools_giswater import load_settings, open_dialog, save_settings, close_dialog, get_plugin_version, \
    create_body, from_postgres_to_toc, create_qml, add_temp_layer
from .ui.ui_manager import ProjectCheckUi
from ..lib.tools_qt import hide_void_groupbox


class GwProjectCheck:

    def __init__(self):
        """ Class to control Composer button """

        self.controller = global_vars.controller
        self.schema_name = global_vars.schema_name


    def populate_audit_check_project(self, layers, init_project):
        """ Fill table 'audit_check_project' with layers data """

        fields = '"fields":[  '
        for layer in layers:
            if layer is None:
                continue
            if layer.providerType() != 'postgres':
                continue
            layer_source = self.controller.get_layer_source(layer)
            if layer_source['schema'] is None:
                continue
            layer_source['schema'] = layer_source['schema'].replace('"', '')
            if 'schema' not in layer_source or layer_source['schema'] != self.schema_name:
                continue
            # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
            uri = layer.dataProvider().dataSourceUri()
            if 'SELECT row_number() over ()' in str(uri):
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
        result = self.execute_audit_check_project(init_project, fields)

        return True, result


    def execute_audit_check_project(self, init_project, fields_to_insert):
        """ Execute function 'gw_fct_setcheckproject' """

        # get project variables
        add_schema = self.controller.plugin_settings_value('gwAddSchema')
        main_schema = self.controller.plugin_settings_value('gwMainSchema')
        project_role = self.controller.plugin_settings_value('gwProjecRole')
        info_type = self.controller.plugin_settings_value('gwInfoType')
        project_type = self.controller.plugin_settings_value('gwProjectType')

        version = get_plugin_version()
        extras = f'"version":"{version}"'
        extras += f', "fid":101'
        extras += f', "initProject":{init_project}'
        extras += f', "addSchema":"{add_schema}"'
        extras += f', "mainSchema":"{main_schema}"'
        extras += f', "projecRole":"{project_role}"'
        extras += f', "infoType":"{info_type}"'
        extras += f', "projectType":"{project_type}"'
        extras += f', "qgisVersion":"{Qgis.QGIS_VERSION}"'
        extras += f', "osVersion":"{platform.system()} {platform.release()}"'
        extras += f', {fields_to_insert}'
        body = create_body(extras=extras)
        result = self.controller.get_json('gw_fct_setcheckproject', body)
        try:
            if not result or (result['body']['variables']['hideForm'] == True):
                return result
        except KeyError as e:
            self.controller.log_warning(f"EXCEPTION: {type(e).__name__}, {e}")
            return result

        # Show dialog with audit check project result
        self.show_check_project_result(result)

        return result


    def show_check_project_result(self, result):
        """ Show dialog with audit check project result """

        # Create dialog
        self.dlg_audit_project = ProjectCheckUi()
        load_settings(self.dlg_audit_project)
        self.dlg_audit_project.rejected.connect(partial(save_settings, self.dlg_audit_project))

        # Populate info_log and missing layers
        critical_level = 0
        text_result = add_temp_layer(self.dlg_audit_project, result['body']['data'],
            'gw_fct_setcheckproject_result', True, False, 0, True, disable_tabs=False)

        if 'missingLayers' in result['body']['data']:
            critical_level = self.get_missing_layers(self.dlg_audit_project,
                result['body']['data']['missingLayers'], critical_level)

        hide_void_groupbox(self.dlg_audit_project)

        if int(critical_level) > 0 or text_result:
            self.dlg_audit_project.btn_accept.clicked.connect(partial(self.add_selected_layers, self.dlg_audit_project,
                                                                      result['body']['data']['missingLayers']))
            self.dlg_audit_project.chk_hide_form.stateChanged.connect(partial(self.update_config))
            open_dialog(self.dlg_audit_project, dlg_name='project_check')


    def update_config(self, state):
        """ Set qgis_form_initproject_hidden True or False into config_param_user """

        value = {0: "False", 2: "True"}
        sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
               f" VALUES('qgis_form_initproject_hidden', '{value[state]}', current_user) "
               f" ON CONFLICT  (parameter, cur_user) "
               f" DO UPDATE SET value='{value[state]}'")
        self.controller.execute_sql(sql)


    def get_missing_layers(self, dialog, m_layers, critical_level):

        grl_critical = dialog.findChild(QGridLayout, "grl_critical")
        grl_others = dialog.findChild(QGridLayout, "grl_others")
        for pos, item in enumerate(m_layers):
            try:
                if not item:
                    continue
                widget = dialog.findChild(QCheckBox, f"{item['layer']}")
                # If it is the case that a layer is necessary for two functions,
                # and the widget has already been put in another iteration
                if widget:
                    continue
                label = QLabel()
                label.setObjectName(f"lbl_{item['layer']}")
                label.setText(f'<b>{item["layer"]}</b><font size="2";> {item["qgis_message"]}</font>')

                critical_level = int(item['criticity']) if int(
                    item['criticity']) > critical_level else critical_level
                widget = QCheckBox()
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                widget.setObjectName(f"{item['layer']}")

                if int(item['criticity']) == 3:
                    grl_critical.addWidget(label, pos, 0)
                    grl_critical.addWidget(widget, pos, 1)
                else:
                    grl_others.addWidget(label, pos, 0)
                    grl_others.addWidget(widget, pos, 1)
            except KeyError:
                description = "Key on returned json from ddbb is missed"
                self.controller.manage_exception(None, description)

        return critical_level


    def add_selected_layers(self, dialog, m_layers):
        """ Receive a list of layers, look for the checks associated with each layer and if they are checked,
            load the corresponding layer and put styles
        :param dialog: Dialog where to look for QCheckBox (QDialog)
        :param m_layers: List with the information of the missing layers (list)[{...}, {...}, {...}, ...]
        :return:
        """

        for layer_info in m_layers:
            if layer_info == {}: continue

            check = dialog.findChild(QCheckBox, layer_info['layer'])
            if check.isChecked():
                geom_field = layer_info['geom_field']
                pkey_field = layer_info['pkey_field']
                group = layer_info['group_layer'] if layer_info['group_layer'] is not None else 'GW Layers'
                style_id = layer_info['style_id']

                from_postgres_to_toc(layer_info['layer'], geom_field, pkey_field, None, group=group)
                layer = None
                qml = None
                if style_id is not None:
                    layer = self.controller.get_layer_by_tablename(layer_info['layer'])
                    if layer:
                        extras = f'"style_id":"{style_id}"'
                        body = create_body(extras=extras)
                        style = self.controller.get_json('gw_fct_getstyle', body)
                        if style['status'] == 'Failed': return
                        if 'styles' in style['body']:
                            if 'style' in style['body']['styles']:
                                qml = style['body']['styles']['style']
                            create_qml(layer, qml)
                self.controller.set_layer_visible(layer)

        close_dialog(self.dlg_audit_project)

