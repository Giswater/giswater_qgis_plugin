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

from .api_parent import ApiParent
from ..ui_manager import ProjectCheckUi


class CheckProjectResult(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Composer button """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def populate_audit_check_project(self, layers, init_project):
        """ Fill table 'audit_check_project' with layers data """

        sql = ("DELETE FROM audit_check_project "
               "WHERE user_name = user_name AND fprocesscat_id = 1")
        self.controller.execute_sql(sql)
        sql = ""
        for layer in layers:
            if layer is None: continue
            if layer.providerType() != 'postgres': continue
            layer_source = self.controller.get_layer_source(layer)
            layer_source['schema'] = layer_source['schema'].replace('"', '')
            # if 'schema' not in layer_source or layer_source['schema'] != self.schema_name: continue
            # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
            uri = layer.dataProvider().dataSourceUri()
            if 'SELECT row_number() over ()' in str(uri): continue
            schema_name = layer_source['schema']
            if schema_name is not None:
                schema_name = schema_name.replace('"', '')
                table_name = layer_source['table']
                db_name = layer_source['db']
                host_name = layer_source['host']
                table_user = layer_source['user']
                sql += ("\nINSERT INTO audit_check_project "
                        "(table_schema, table_id, table_dbname, table_host, fprocesscat_id, table_user) "
                        "VALUES ('" + str(schema_name) + "', '" + str(table_name) + "', '" + str(
                    db_name) + "', '" + str(host_name) + "', 1, '" + str(table_user) + "');")
        status = self.controller.execute_sql(sql)
        if not status:
            return False, None

        # Execute function 'gw_fct_audit_check_project'
        result = self.execute_audit_check_project(init_project)

        return True, result


    def execute_audit_check_project(self, init_project):
        """ Execute function 'gw_fct_audit_check_project' """

        version = self.get_plugin_version()
        extras = f'"version":"{version}"'
        extras += f', "fprocesscat_id":1'
        extras += f', "initProject":{init_project}'
        extras += f', "qgisVersion":"{Qgis.QGIS_VERSION}"'
        extras += f', "osVersion":"{platform.system()} {platform.release()}"'
        	
        body = '$${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.038", "fprocesscat_id":1}}$$'	
		
        result = self.controller.get_json('gw_fct_audit_check_project', body, log_sql=True)
        try:
            if not result or (result['body']['actions']['hideForm'] == True):
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
        self.load_settings(self.dlg_audit_project)
        self.dlg_audit_project.rejected.connect(partial(self.save_settings, self.dlg_audit_project))

        # Populate info_log and missing layers
        critical_level = 0
        text_result = self.add_layer.add_temp_layer(self.dlg_audit_project, result['body']['data'],
            'gw_fct_audit_check_project_result', True, False, 0, True)

        if 'missingLayers' in result['body']['data']:
            critical_level = self.get_missing_layers(self.dlg_audit_project,
                result['body']['data']['missingLayers'], critical_level)

        self.hide_void_groupbox(self.dlg_audit_project)

        if int(critical_level) > 0 or text_result:
            self.dlg_audit_project.btn_accept.clicked.connect(partial(self.add_selected_layers))
            self.dlg_audit_project.chk_hide_form.stateChanged.connect(partial(self.update_config))
            self.open_dialog(self.dlg_audit_project, dlg_name='project_check')


    def update_config(self, state):
        """ Set qgis_form_initproject_hidden True or False into config_param_user """

        value = {0:"False", 2:"True"}
        sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
               f" VALUES('qgis_form_initproject_hidden', '{value[state]}', current_user) "
               f" ON CONFLICT  (parameter, cur_user) "
               f" DO UPDATE SET value='{value[state]}'")
        self.controller.execute_sql(sql, log_sql=True)


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
                widget.setProperty('field_id', item['id'])
                widget.setProperty('field_the_geom', item['field_the_geom'])

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


    def add_selected_layers(self):

        checks = self.dlg_audit_project.scrollArea.findChildren(QCheckBox)
        schemaname = self.schema_name.replace('"', '')
        for check in checks:
            if check.isChecked():
                try:
                    the_geom = check.property('field_the_geom')
                except KeyError:
                    sql = (f"SELECT attname FROM pg_attribute a "
                           f" JOIN pg_class t on a.attrelid = t.oid "
                           f" JOIN pg_namespace s on t.relnamespace = s.oid "
                           f" WHERE a.attnum > 0  AND NOT a.attisdropped  AND t.relname = '{check.objectName()}' "
                           f" AND s.nspname = '{schemaname}' "
                           f" AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)='geometry' "
                           f" ORDER BY a.attnum limit 1")
                    the_geom = self.controller.get_row(sql)
                if not the_geom:
                    the_geom = None
                self.add_layer.from_postgres_to_toc(check.objectName(), the_geom, check.property('field_id'), None)

        self.close_dialog(self.dlg_audit_project)

