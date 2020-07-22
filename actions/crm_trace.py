"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from PyQt5.QtWidgets import QTabWidget, QPushButton
from qgis.core import QgsProject, QgsFeature, QgsGeometry, QgsVectorLayer, QgsField
from qgis.PyQt.QtCore import QVariant
from qgis.PyQt.QtGui import QColor

import json
import os
import subprocess
from collections import OrderedDict
from functools import partial

from .. import sys_manager
from .. import utils_giswater
from ..ui_manager import DlgTrace
from .api_parent import ApiParent


class CrmTrace(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Trace' of toolbar 'edit' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def manage_trace(self):

        self.controller.log_info("manage_trace")

        # Create the dialog and signals
        self.dlg_trace = DlgTrace()
        self.load_settings(self.dlg_trace)

        # Set listeners
        self.dlg_trace.btn_accept.clicked.connect(self.process)
        self.dlg_trace.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_trace))
        self.dlg_trace.rejected.connect(partial(self.save_settings, self.dlg_trace))

        # Fill combo 'exploitation'
        sql = "SELECT name FROM exploitation WHERE active = True ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_trace, 'cbo_expl', rows, allow_nulls=False)

        # Open dialog
        self.open_dialog(self.dlg_trace, dlg_name='crm_trace')


    def process(self):
        """ Main process """

        # Get selected 'exploitation'
        expl_name = utils_giswater.getWidgetText(self.dlg_trace, 'cbo_expl')
        self.controller.log_info(str(expl_name))

        # Execute synchronization script
        status = self.execute_script(expl_name)
        if status:
            # Execute PG function 'gw_fct_odbc2pg_main'
            self.execute_odbc2pg()


    def execute_script(self, expl_name=None):
        """ Execute synchronization script """

        self.controller.log_info("execute_script")

        if expl_name is None or expl_name == 'null':
            self.controller.show_warning("Any exploitation selected")
            return False

        # Get python synchronization script path
        row = self.controller.get_config('admin_crm_script_folderpath', 'value', 'config_param_system')
        if row:
            script_folder = row[0]
        else:
            script_folder = 'C:/gis/daily_script'

         # Check if script path exists
        script_path = script_folder + os.sep + 'main.py'
        if not os.path.exists(script_path):
            msg = "File not found: {}. Check config system parameter: '{}'".format(
                script_path, 'crm_daily_script_folderpath')
            self.controller.show_warning(msg, duration=20)
            return False

        # Get database current user
        cur_user = self.controller.get_current_user()

        # Get python folder path
        python_path = 'python'
        row = self.controller.get_config('admin_python_folderpath', 'value', 'config_param_system')
        if row:
            python_folderpath = row[0]
        else:
            python_folderpath = 'c:/program files/qgis 3.4/apps/python37'

        if os.path.exists(python_folderpath):
            python_path = python_folderpath + os.sep + python_path
        else:
            self.controller.log_warning("Folder not found", parameter=python_folderpath)

        # Get parameter 'buffer'
        buffer = utils_giswater.getWidgetText(self.dlg_trace, 'buffer', return_string_null=False)
        if buffer is None or buffer == "":
            buffer = str(10)

        # Execute script
        args = [python_path, script_path, expl_name, buffer, self.schema_name, cur_user]
        self.controller.log_info(str(args))
        status = True

        # Get script log file path
        log_file = sys_manager.manage_tstamp()
        log_path = script_folder + os.sep + "log" + os.sep + log_file
        self.controller.log_info(log_path)

        # Manage result
        try:
            result = subprocess.call(args)
            self.controller.log_info("result: " + str(result))
            if result != 0:
                # Show warning message with button to open script log file
                message = "Process finished with some errors"
                inf_msg = "Open script .log file to get more details"
                self.controller.show_warning_open_file(message, inf_msg, log_path)
                status = False
        except Exception as e:
            self.controller.show_warning(str(e))
            status = False
        finally:
            return status


    def execute_odbc2pg(self, function_name='gw_fct_odbc2pg_main'):
        """ Execute PG function @function_name """

        self.controller.log_info("execute_odbc2pg")
        exists = self.controller.check_function(function_name)
        if not exists:
            self.controller.show_warning("Function not found", parameter=function_name)
            return False

        # Get expl_id, year and period from table 'audit_log'
        sql = ("SELECT to_json(log_message) as log_message "
               "FROM utils.audit_log "
               "WHERE fid = 174 "
               "ORDER BY id DESC LIMIT 1")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_warning("Error getting data from audit table", parameter=sql)
            return False

        result = json.loads(row[0])
        expl_id = None
        year = None
        period = None
        if 'expl_id' in result:
            expl_id = result['expl_id']
        if 'year' in result:
            year = result['year']
        if 'period' in result:
            period = result['period']

        # Set function parameters
        client = '"client": {"device":4, "infoType":1, "lang":"ES"}, '
        feature = '"feature": {}, '
        data = f'"data": {{"parameters": {{"exploitation":"{expl_id}", "period":"{period}", "year":"{year}"}}}}'
        body = client + feature + data
        sql = f"SELECT {function_name}($${{{body}}}$$)::text"
        self.controller.log_info(sql)

        # Execute function and show results
        row = self.controller.get_row(sql)
        if not row or row[0] is None:
            self.controller.show_warning("Process failed", parameter=sql)
            return False

        # Process result
        result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.controller.log_info(str(row[0]))
        if 'status' not in result[0]:
            self.controller.show_warning("Parameter not found", parameter="status")
            return False
        if 'message' not in result[0]:
            self.controller.show_warning("Parameter not found", parameter="message")
            return False

        if result[0]['status'] == "Accepted":
            if 'body' in result[0]:
                if 'data' in result[0]['body']:
                    data = result[0]['body']['data']
                    self.add_layer.add_temp_layer(self.dlg_trace, data, function_name)

        message = result[0]['message']['text']
        msg = "Process executed successfully. Read 'Info log' for more details"
        self.controller.show_info(msg, parameter=message, duration=20)

        return True


    def add_temp_layer(self, dialog, tab_main, txt_infolog, data, function_name):
        """ Manage parameter 'data' from JSON response """

        self.delete_layer_from_toc(function_name)
        srid = self.controller.plugin_settings_value('srid')
        for k, v in list(data.items()):
            if str(k) == "info":
                self.controller.log_info("populate_info_text")
                self.populate_info_text(dialog, data)
            else:
                counter = len(data[k]['values'])
                if counter > 0:
                    geometry_type = data[k]['geometryType']
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", function_name, 'memory')
                    self.controller.log_info("populate_vlayer")
                    self.populate_vlayer(v_layer, data, k)
                    if 'qmlPath' in data[k]:
                        qml_path = data[k]['qmlPath']
                        self.add_layer.load_qml(v_layer, qml_path)
                    else:
                        if geometry_type == 'Point':
                            v_layer.renderer().symbol().setSize(3.5)
                            v_layer.renderer().symbol().setColor(QColor("red"))
                        elif geometry_type == 'LineString':
                            v_layer.renderer().symbol().setWidth(1.5)
                            v_layer.renderer().symbol().setColor(QColor("red"))
                    v_layer.renderer().symbol().setOpacity(0.7)
                else:
                    self.controller.log_info("No data found")


    def populate_vlayer(self, virtual_layer, data, layer_type):
        """ Populate @virtual_layer with contents get from JSON response """

        # Enter editing mode
        data_provider = virtual_layer.dataProvider()
        virtual_layer.startEditing()
        columns = data[layer_type]['values'][0]
        for key, value in list(columns.items()):
            # add columns
            if str(key) != 'the_geom':
                data_provider.addAttributes([QgsField(str(key), QVariant.String)])

        # Add features
        for item in data[layer_type]['values']:
            attributes = []
            fet = QgsFeature()
            for k, v in list(item.items()):
                if str(k) != 'the_geom':
                    attributes.append(v)
                if str(k) in 'the_geom':
                    sql = f"SELECT St_AsText('{v}')"
                    row = self.controller.get_row(sql, log_sql=False)
                    if row:
                        wkt = str(row[0])
                        geometry = QgsGeometry.fromWkt(wkt)
                        fet.setGeometry(geometry)
            fet.setAttributes(attributes)
            data_provider.addFeatures([fet])

        # Commit changes
        virtual_layer.commitChanges()
        QgsProject.instance().addMapLayer(virtual_layer, False)

        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup('GW Temporal Layers')
        if my_group is None:
            my_group = root.insertGroup(0, 'GW Temporal Layers')

        my_group.insertLayer(0, virtual_layer)


    def populate_info_text(self, dialog, data, force_tab=True, reset_text=True, tab_idx=1, disable_tabs=True):
        """ Populate txt_infolog QTextEdit widget
        :param dialog: QDialog
        :param data: Json
        :param force_tab: Force show tab (boolean)
        :param reset_text: Reset(or not) text for each iteration (boolean)
        :param tab_idx: index of tab to force (integer)
        :param disable_tabs: set all tabs, except the last, enabled or disabled (boolean)
        :return: Text received from data (String)
        """

        change_tab = False
        text = utils_giswater.getWidgetText(dialog, dialog.txt_infolog, return_string_null=False)

        if reset_text:
            text = ""
        for item in data['info']['values']:
            if 'message' in item:
                if item['message'] is not None:
                    text += str(item['message']) + "\n"
                    if force_tab:
                        change_tab = True
                else:
                    text += "\n"

        utils_giswater.setWidgetText(dialog, 'txt_infolog', text + "\n")
        qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
        if qtabwidget is not None:
            if change_tab and qtabwidget is not None:
                qtabwidget.setCurrentIndex(tab_idx)
            if disable_tabs:
                self.disable_tabs(dialog)

        return text


    def disable_tabs(self, dialog):
        """ Disable all tabs in the dialog except the log one and change the state of the buttons
        :param dialog: Dialog where tabs are disabled (QDialog)
        :return:
        """

        qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
        for x in range(0, qtabwidget.count() - 1):
            qtabwidget.widget(x).setEnabled(False)

        btn_accept = dialog.findChild(QPushButton, 'btn_accept')
        if btn_accept:
            btn_accept.hide()

        btn_cancel = dialog.findChild(QPushButton, 'btn_cancel')
        if btn_cancel:
            utils_giswater.setWidgetText(dialog, btn_accept, 'Close')

