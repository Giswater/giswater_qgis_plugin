"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import csv
import os
from functools import partial
import json
from sip import isdeleted
from time import time
from datetime import timedelta

from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtGui import QColor, QIcon, QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QSpinBox, QWidget, QLineEdit, QComboBox, QCheckBox, QRadioButton, QAbstractItemView, \
    QTreeWidget, QCompleter, QGridLayout, QHBoxLayout, QLabel, QTableWidgetItem, QFileDialog
from qgis.core import QgsApplication, QgsProject
from qgis.gui import QgsDateTimeEdit

from ..dialog import GwAction
from ...threads.toolbox_execute import GwToolBoxTask
from ...threads.toolbox_report import GwReportTask
from ...ui.ui_manager import GwToolboxUi, GwToolboxManagerUi, GwToolboxReportsUi
from ...utils import tools_gw, tools_backend_calls
from ....lib import tools_qt, tools_qgis, tools_db
from .... import global_vars


class GwToolBoxButton(GwAction):
    """ Button 206: Toolbox """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        if icon_path is not None:
            super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.function_list = []
        self.rbt_checked = {}
        self.no_clickable_items = ['Processes', 'Reports']
        self.temp_layers_added = []
        self.add_columns = {}
        self.queryAdd = None


    def clicked_event(self):

        self._open_toolbox()


    def open_function_by_id(self, func_id, connect_signal=None):

        self.dlg_functions = GwToolboxManagerUi()
        tools_gw.load_settings(self.dlg_functions)
        self.dlg_functions.progressBar.setVisible(False)
        self.dlg_functions.btn_cancel.hide()
        self.dlg_functions.btn_close.show()

        self.dlg_functions.btn_cancel.clicked.connect(self._cancel_task)
        self.dlg_functions.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, self.dlg_functions,
                                                                          self.dlg_functions.cmb_layers))
        self.dlg_functions.rbt_previous.toggled.connect(partial(self._rbt_state, self.dlg_functions.rbt_previous))
        self.dlg_functions.rbt_layer.toggled.connect(partial(self._rbt_state, self.dlg_functions.rbt_layer))
        self.dlg_functions.rbt_layer.setChecked(True)

        extras = f'"function":{func_id}'
        extras += ', "isToolbox":false'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_gettoolbox', body)
        if not json_result or json_result['status'] == 'Failed':
            return False
        sql = f"SELECT alias FROM config_toolbox WHERE id = {func_id}"
        self.function_selected = f"{tools_db.get_row(sql)[0]}"
        status = self._populate_functions_dlg(self.dlg_functions, json_result['body']['data']['processes'])
        if not status:
            message = "Function not found"
            tools_qgis.show_message(message, parameter=self.function_selected)
            return

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_functions)

        # Connect signals
        self.dlg_functions.mainTab.currentChanged.connect(partial(self._manage_btn_run))
        self.dlg_functions.btn_run.clicked.connect(partial(self._execute_function, self.function_selected,
                                                           self.dlg_functions, self.dlg_functions.cmb_layers,
                                                           json_result['body']['data']['processes']))
        self.dlg_functions.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_functions))
        self.dlg_functions.rejected.connect(partial(tools_gw.close_dialog, self.dlg_functions))
        self.dlg_functions.btn_cancel.clicked.connect(partial(self.remove_layers))
        if connect_signal:
            for signal in connect_signal:
                self.dlg_functions.finished.connect(signal)

        # Open form and set title
        self.dlg_functions.setWindowTitle(f"{self.function_selected}")
        tools_gw.open_dialog(self.dlg_functions, dlg_name='toolbox')
        return self.dlg_functions

    def remove_layers(self):

        root = QgsProject.instance().layerTreeRoot()
        for layer in reversed(self.temp_layers_added):
            self.temp_layers_added.remove(layer)
            # Possible QGIS bug: Instead of returning None because it is not found in the TOC, it breaks
            try:
                dem_raster = root.findLayer(layer.id())
            except RuntimeError:
                continue

            parent_group = dem_raster.parent()
            try:
                QgsProject.instance().removeMapLayer(layer.id())
            except Exception:
                pass

            if len(parent_group.findLayers()) == 0:
                root.removeChildNode(parent_group)

        global_vars.iface.mapCanvas().refresh()


    def set_selected_layer(self, dialog, combo):

        layer_name = tools_qt.get_combo_value(dialog, combo, 1)
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer is None:
            tools_qgis.show_warning("Layer not found", parameter=layer_name)
            return None
        global_vars.iface.setActiveLayer(layer)
        return layer


    def save_parametric_values(self, dialog, function):
        """ Save QGIS settings related with toolbox options """

        function_name = function[0]['functionname']
        layout = dialog.findChild(QWidget, 'grb_parameters')
        widgets = layout.findChildren(QWidget)
        for widget in widgets:
            if type(widget) is QCheckBox:
                tools_gw.set_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}",
                                           f"{widget.isChecked()}")
            elif type(widget) is QComboBox:
                value = tools_qt.get_combo_value(dialog, widget, 0)
                tools_gw.set_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}", f"{value}")
            elif type(widget) in (QLineEdit, QSpinBox):
                value = tools_qt.get_text(dialog, widget, False, False)
                tools_gw.set_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}", f"{value}")


    def save_settings_values(self, dialog, function):
        """ Save QGIS settings related with toolbox options """

        function_name = function[0]['functionname']
        feature_type = tools_qt.get_combo_value(dialog, dialog.cmb_feature_type, 0)
        tools_gw.set_config_parser('btn_toolbox', f"{function_name}_cmb_feature_type", f"{feature_type}")
        layer = tools_qt.get_combo_value(dialog, dialog.cmb_layers, 0)
        tools_gw.set_config_parser('btn_toolbox', f"{function_name}_cmb_layers", f"{layer}")
        tools_gw.set_config_parser('btn_toolbox', f"{function_name}_rbt_previous", f"{dialog.rbt_previous.isChecked()}")


    # region private functions

    def _open_toolbox(self):

        self.no_clickable_items = ['Processes', 'Reports']
        function_name = "gw_fct_gettoolbox"
        row = tools_db.check_function(function_name)
        if not row:
            tools_qgis.show_warning("Function not found in database", parameter=function_name)
            return

        self.dlg_toolbox = GwToolboxUi('toolbox')
        self.dlg_toolbox.trv.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.dlg_toolbox.trv.setHeaderHidden(True)

        extras = '"isToolbox":true'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_gettoolbox', body)
        if json_result and json_result['status'] != 'Failed':
            self._populate_trv(self.dlg_toolbox.trv, json_result['body']['data'])
            self.dlg_toolbox.txt_filter.textChanged.connect(partial(self._filter_functions))
            self.dlg_toolbox.trv.doubleClicked.connect(partial(self._open_function))
            tools_qt.manage_translation('toolbox_docker', self.dlg_toolbox)

        # Set shortcut keys
        self.dlg_toolbox.key_escape.connect(partial(tools_gw.close_docker))

        # Show form in docker
        tools_gw.init_docker('qgis_form_docker')
        if global_vars.session_vars['dialog_docker']:
            tools_gw.docker_dialog(self.dlg_toolbox)
        else:
            tools_gw.open_dialog(self.dlg_toolbox)


    def _filter_functions(self, text):

        extras = f'"filterText":"{text}"'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_gettoolbox', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        self._populate_trv(self.dlg_toolbox.trv, json_result['body']['data'], expand=True)


    def _open_function(self, index):

        # this '0' refers to the index of the item in the selected row
        self.function_selected = index.sibling(index.row(), 0).data()

        # Control no clickable items
        if self.function_selected in self.no_clickable_items:
            return

        if 'reports' in index.parent().parent().data().lower():

            # this '1' refers to the index of the item in the selected row
            function_name = index.sibling(index.row(), 0).data()
            self.function_selected = index.sibling(index.row(), 1).data()
            vdefault = index.sibling(index.row(), 2).data()
            self.queryAdd = None
            if vdefault:
                vdefault = json.loads(vdefault.replace("'", '"'))
                self.queryAdd = vdefault.get('queryAdd')

            self.dlg_reports = GwToolboxReportsUi()
            tools_gw.load_settings(self.dlg_reports)

            # Set description & query labels
            sql = f"SELECT alias, query_text, descript FROM config_report WHERE id = {self.function_selected}"
            row = tools_db.get_row(sql)
            if row:
                descript = row[2]
                if descript in (None, 'null', ''):
                    descript = row[0]
                tools_qt.set_widget_text(self.dlg_reports, 'lbl_descript', descript)
                tools_qt.set_widget_text(self.dlg_reports, 'lbl_query', row[1])

            # Set listeners
            self.dlg_reports.btn_export_path.clicked.connect(self._select_file_report)
            self.dlg_reports.btn_export.clicked.connect(partial(self._export_reports, self.dlg_reports, self.dlg_reports.tbl_reports, self.dlg_reports.txt_export_path))
            self.dlg_reports.rejected.connect(partial(tools_gw.close_dialog, self.dlg_reports))
            self.dlg_reports.btn_close.clicked.connect(self.dlg_reports.reject)

            # Disable buttons
            tools_qt.set_widget_enabled(self.dlg_reports, 'btn_export', False)
            tools_qt.set_widget_enabled(self.dlg_reports, 'btn_close', False)

            # Create timer
            self.t0 = time()
            self.timer = QTimer()
            self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_reports))
            self.timer.start(1000)

            # Create thread
            self.report_thread = GwReportTask(function_name, self.dlg_reports, self.function_selected, self.queryAdd, timer=self.timer)
            self.report_thread.finished_execute.connect(self._report_finished)
            QgsApplication.taskManager().addTask(self.report_thread)
            QgsApplication.taskManager().triggerTask(self.report_thread)

            self.dlg_reports.setWindowTitle(f"{function_name}")
            tools_gw.open_dialog(self.dlg_reports, dlg_name='reports')

        elif 'processes' in index.parent().parent().data().lower():

            self.dlg_functions = GwToolboxManagerUi()
            tools_gw.load_settings(self.dlg_functions)
            self.dlg_functions.progressBar.setVisible(False)
            self.dlg_functions.btn_cancel.hide()
            self.dlg_functions.btn_close.show()

            self.dlg_functions.btn_cancel.clicked.connect(self._cancel_task)
            self.dlg_functions.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, self.dlg_functions,
                                                                              self.dlg_functions.cmb_layers))
            self.dlg_functions.rbt_previous.toggled.connect(partial(self._rbt_state, self.dlg_functions.rbt_previous))
            self.dlg_functions.rbt_layer.toggled.connect(partial(self._rbt_state, self.dlg_functions.rbt_layer))
            self.dlg_functions.rbt_layer.setChecked(True)

            extras = f'"filterText":"{self.function_selected}"'
            extras += ', "isToolbox":true'
            body = tools_gw.create_body(extras=extras)
            json_result = tools_gw.execute_procedure('gw_fct_gettoolbox', body)
            if not json_result or json_result['status'] == 'Failed':
                return False
            status = self._populate_functions_dlg(self.dlg_functions, json_result['body']['data']['processes'])
            if not status:
                self.function_selected = index.sibling(index.row(), 1).data()
                message = "Function not found"
                tools_qgis.show_message(message, parameter=self.function_selected)
                return

            # Disable tab log
            tools_gw.disable_tab_log(self.dlg_functions)

            # Connect signals
            self.dlg_functions.mainTab.currentChanged.connect(partial(self._manage_btn_run))
            self.dlg_functions.btn_run.clicked.connect(partial(self._execute_function, self.function_selected,
                self.dlg_functions, self.dlg_functions.cmb_layers, json_result['body']['data']['processes']))
            self.dlg_functions.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_functions))
            self.dlg_functions.rejected.connect(partial(tools_gw.close_dialog, self.dlg_functions))
            self.dlg_functions.btn_cancel.clicked.connect(partial(self.remove_layers))

            # Open form and set title
            self.dlg_functions.setWindowTitle(f"{self.function_selected}")
            tools_gw.open_dialog(self.dlg_functions, dlg_name='toolbox')


    def _report_finished(self, status, json_result):
        if not status:
            return

        layout = self.dlg_reports.findChild(QGridLayout, 'lyt_filters')

        order = 0

        self.add_columns = {}
        for field in json_result['body']['data']['fields']:
            label = None
            widget = None

            if field.get('label'):
                label = QLabel()
                label.setObjectName('lbl_' + field['widgetname'])
                label.setText(field['label'].capitalize())
                if field.get('stylesheet') is not None and 'label' in field['stylesheet']:
                    label = tools_gw.set_stylesheet(field, label)
                if 'tooltip' in field:
                    label.setToolTip(field['tooltip'])
                else:
                    label.setToolTip(field['label'].capitalize())

            if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
                completer = QCompleter()
                widget = tools_gw.add_lineedit(field)
                widget = tools_gw.set_widget_size(widget, field)
                widget = tools_gw.set_data_type(field, widget)
                if field.get('filterDefault') is not None:
                    tools_qt.set_widget_text(self.dlg_reports, widget, field.get('filterDefault'))
                widget.textChanged.connect(partial(self._update_tbl_reports))
                if field['widgettype'] == 'typeahead':
                    widget = tools_gw.set_typeahead(field, self.dlg_reports, widget, completer)
            elif field['widgettype'] == 'combo':
                widget = tools_gw.add_combo(field)
                widget = tools_gw.set_widget_size(widget, field)
                widget.setProperty('filterSign', field.get('filterSign'))
                widget.setProperty('showOnTableModel', field.get('showOnTableModel'))
                if field.get('filterDefault') is not None:
                    tools_qt.set_widget_text(self.dlg_reports, widget, field.get('filterDefault'))
                widget.currentIndexChanged.connect(partial(self._update_tbl_reports))
            elif field['widgettype'] == 'check':
                widget = tools_gw.add_checkbox(field)
                if field.get('filterDefault') is not None:
                    tools_qt.set_widget_text(self.dlg_reports, widget, field.get('filterDefault'))
                widget.stateChanged.connect(partial(self._update_tbl_reports))
            elif field['widgettype'] == 'datetime':
                widget = tools_gw.add_calendar(self.dlg_reports, field)
                if field.get('filterDefault') is not None:
                    tools_qt.set_widget_text(self.dlg_reports, widget, field.get('filterDefault'))
                widget.valueChanged.connect(partial(self._update_tbl_reports))
            elif field['widgettype'] == 'list':
                if field['value'] is None:
                    msg = "No results found. Please check values set on selector of state and exploitation"
                    tools_qgis.show_warning(msg)
                    return
                numrows = len(field['value'])
                numcols = len(field['value'][0])

                self.dlg_reports.tbl_reports.setColumnCount(numcols)
                self.dlg_reports.tbl_reports.setRowCount(numrows)

                i = 0
                dict_keys = {}
                for key in field['value'][0].keys():
                    dict_keys[i] = f"{key}"
                    self.dlg_reports.tbl_reports.setHorizontalHeaderItem(i, QTableWidgetItem(f"{key}"))
                    i = i + 1

                for row in range(numrows):
                    for column in range(numcols):
                        column_name = dict_keys[column]
                        value = field['value'][row][column_name]
                        if value in (None, 'None'):
                            value = ''
                        # Create a QTableWidgetItem and then set the data so the sorting works properly
                        # with Strings, Integers and any other type
                        qtable_item = QTableWidgetItem()
                        qtable_item.setData(Qt.DisplayRole, value)
                        self.dlg_reports.tbl_reports.setItem(row, column, qtable_item)

                continue

            order = order + 1

            if label:
                layout.addWidget(label, 0, order)
            if widget:
                layout.addWidget(widget, 1, order)

            # Set scale-to-fit
            tools_qt.set_tableview_config(self.dlg_reports.tbl_reports, sectionResizeMode=0)

        # Update tbl in case filters have default value
        self._update_tbl_reports()


    def _update_tbl_reports(self):

        list_widgets = self.dlg_reports.findChildren(QWidget)
        filters = []
        for widget in list_widgets:
            if type(widget) is QLineEdit:
                value = tools_qt.get_text(self.dlg_reports, widget, return_string_null=False)
            elif type(widget) is QComboBox:
                value = tools_qt.get_combo_value(self.dlg_reports, widget)
            elif type(widget) is QCheckBox:
                value = widget.isChecked()
            elif type(widget) is QgsDateTimeEdit:
                value = tools_qt.get_calendar_date(self.dlg_reports, widget)
            else:
                continue
            if widget.property('showOnTableModel'):
                lbl = tools_qt.get_text(self.dlg_reports, f'lbl_{widget.objectName()}')
                position = json.loads(widget.property('showOnTableModel')).get('position')
                self.add_columns[position] = [lbl, value]
            filterSign = widget.property('filterSign')
            if filterSign is None:
                filterSign = '='
            _json = {"filterName": f"{widget.objectName()}", "filterValue": f"{value}", "filterSign": f"{filterSign}"}
            filters.append(_json)

        extras = f'"filter":{json.dumps(filters)}, "listId":"{self.function_selected}"'
        if self.queryAdd:
            extras += f', "queryAdd": "{self.queryAdd}"'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getreport', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        for field in json_result['body']['data']['fields']:

            if field['widgettype'] == 'list' and field.get('value') is not None:
                # Calculate max possible rows/cols for table
                numrows = len(field['value'])
                numcols = len(field['value'][0]) + len(self.add_columns)
                self.dlg_reports.tbl_reports.setColumnCount(numcols)
                self.dlg_reports.tbl_reports.setRowCount(numrows)

                i = 0
                tot_skipped = 0
                skipped_dict = {}
                dict_keys = {}
                # Set table headers
                for key in field['value'][0].keys():
                    # Add additional columns if needed
                    skipped = 0
                    while self.add_columns.get(i) is not None and self.add_columns.get(i)[0] not in skipped_dict:
                        if self.add_columns.get(i)[1] not in ('', 'null', None):
                            dict_keys[i-skipped] = self.add_columns.get(i)[1]
                            self.dlg_reports.tbl_reports.setHorizontalHeaderItem(i-skipped, QTableWidgetItem(f"{self.add_columns.get(i)[0]}"))
                        else:
                            skipped += 1
                            if self.add_columns.get(i)[0] not in skipped_dict:
                                tot_skipped += 1
                                skipped_dict[self.add_columns.get(i)[0]] = True
                        i += 1
                    # Subtract the additional columns whose filters that aren't used
                    i -= tot_skipped
                    numcols -= tot_skipped
                    tot_skipped = 0
                    # Add usual columns
                    dict_keys[i] = f"{key}"
                    self.dlg_reports.tbl_reports.setHorizontalHeaderItem(i, QTableWidgetItem(f"{key}"))
                    i = i + 1

                # Set actual rows/cols for table
                self.dlg_reports.tbl_reports.setColumnCount(numcols)
                self.dlg_reports.tbl_reports.setRowCount(numrows)

                # Fill in the cells
                for row in range(numrows):
                    for column in range(numcols):
                        column_name = dict_keys[column]
                        try:
                            item = field['value'][row][column_name]  # Usual column
                        except (KeyError, TypeError):
                            item = column_name  # Additional column
                        if item in (None, 'None'):
                            item = ''
                        # Create a QTableWidgetItem and then set the data so the sorting works properly
                        # with Strings, Integers and any other type
                        qtable_item = QTableWidgetItem()
                        qtable_item.setData(Qt.DisplayRole, item)
                        self.dlg_reports.tbl_reports.setItem(row, column, qtable_item)
            elif field['widgettype'] == 'list' and field.get('value') is None:
                self.dlg_reports.tbl_reports.setRowCount(0)


    def _rbt_state(self, rbt, state):

        if rbt.objectName() == 'rbt_previous' and state is True:
            self.rbt_checked['widget'] = 'previousSelection'
        elif rbt.objectName() == 'rbt_layer' and state is True:
            self.rbt_checked['widget'] = 'wholeSelection'

        self.rbt_checked['value'] = state


    def _load_parametric_values(self, dialog, function):
        """ Load QGIS settings related with toolbox options """

        function_name = function[0]['functionname']
        layout = dialog.findChild(QWidget, 'grb_parameters')
        widgets = layout.findChildren(QWidget)

        for widget in widgets:
            if type(widget) not in (QCheckBox, QComboBox, QLineEdit, QRadioButton):
                continue
            if type(widget) in (QCheckBox, QRadioButton):
                value = tools_gw.get_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}", "user",
                                                   "session")
                tools_qt.set_checked(dialog, widget, value)
            elif type(widget) is QComboBox and widget.property('selectedId') in (None,'','NULL'):
                value = tools_gw.get_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}", "user",
                                                   "session")
                if value in (None, '', 'NULL') and widget.property('selectedId') not in (None, '', 'NULL'):
                    value = widget.property('selectedId')
                tools_qt.set_combo_value(widget, value, 0)
            elif type(widget) in (QLineEdit, QSpinBox) and widget.property('value') in (None, ''):
                value = tools_gw.get_config_parser('btn_toolbox', f"{function_name}_{widget.objectName()}", "user",
                                                   "session")
                tools_qt.set_widget_text(dialog, widget, value)


    def _load_settings_values(self, dialog, function):
        """ Load QGIS settings related with toolbox options """

        function_name = function[0]['functionname']
        if dialog.cmb_feature_type.property('selectedId') in (None, '', 'NULL'):
            feature_type = tools_gw.get_config_parser('btn_toolbox', f"{function_name}_cmb_feature_type", "user",
                                                      "session")
        else:
            feature_type = dialog.cmb_feature_type.property('selectedId')
        tools_qt.set_combo_value(dialog.cmb_feature_type, feature_type, 0)
        if dialog.cmb_layers.property('selectedId') in (None, '', 'NULL'):
            layer = tools_gw.get_config_parser('btn_toolbox', f"{function_name}_cmb_layers", "user", "session")
        else:
            layer = dialog.cmb_layers.property('selectedId')
        tools_qt.set_combo_value(dialog.cmb_layers, layer, 0)

        if tools_gw.get_config_parser('btn_toolbox', f"{function_name}_rbt_previous", "user", "session") == 'True':
            tools_qt.set_checked(dialog, 'rbt_previous', True)
        else:
            tools_qt.set_checked(dialog, 'rbt_layer', True)


    def _execute_function(self, description, dialog, combo, result):

        # Manage if task is already running
        if hasattr(self, 'toolbox_task') and self.toolbox_task is not None:
            try:
                if self.toolbox_task.isActive():
                    message = "Toolbox task is already active!"
                    tools_qgis.show_warning(message)
                    return
            except RuntimeError:
                pass

        self.dlg_functions.btn_run.setEnabled(False)
        self.dlg_functions.btn_cancel.show()
        self.dlg_functions.btn_close.hide()
        dialog.progressBar.setRange(0, 0)
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setStyleSheet("QProgressBar {border: 0px solid #000000; border-radius: 5px; "
                                         "background-color: #E0E0E0;}"
                                         "QProgressBar::chunk {background-color:#0bd82c; width: 10 px; margin: 0.5px;}")

        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_functions))

        self.timer.start(1000)
        # Set background task 'GwToolBoxTask'
        self.toolbox_task = GwToolBoxTask(self, description, dialog, combo, result, timer=self.timer)
        QgsApplication.taskManager().addTask(self.toolbox_task)
        QgsApplication.taskManager().triggerTask(self.toolbox_task)


    def _calculate_elapsed_time(self, dialog):

        tf = time()  # Final time
        td = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

    def _update_time_elapsed(self, text, dialog):

        if isdeleted(dialog):
            self.timer.stop()
            return

        lbl_time = dialog.findChild(QLabel, 'lbl_time')
        lbl_time.setText(text)


    def _manage_btn_run(self, index):
        """
        Disable btn_accept when on tab info log and/or if toolbox_task is active
            :param index: tab index (passed by signal)
        """

        if index == 1:
            self.dlg_functions.btn_run.setEnabled(False)
        else:
            # Disable if task is active, enabled otherwise
            if hasattr(self, 'toolbox_task') and self.toolbox_task is not None:
                try:
                    if self.toolbox_task.isActive():
                        self.dlg_functions.btn_run.setEnabled(False)
                        return
                except RuntimeError:
                    pass
            self.dlg_functions.btn_run.setEnabled(True)


    def _populate_functions_dlg(self, dialog, result, module=tools_backend_calls):

        status = False

        for group, function in result['fields'].items():
            if len(function) != 0:
                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))

                if not function[0]['input_params']['featureType']:
                    dialog.grb_input_layer.setVisible(False)
                    dialog.grb_selection_type.setVisible(False)
                else:
                    feature_types = function[0]['input_params']['featureType']
                    self._populate_cmb_type(feature_types)
                    self.dlg_functions.cmb_feature_type.currentIndexChanged.connect(partial(self._populate_layer_combo))
                    self._populate_layer_combo()
                tools_gw.build_dialog_options(dialog, function, 0, self.function_list, self.temp_layers_added, module)
                self._load_settings_values(dialog, function)
                self._load_parametric_values(dialog, function)
                # Execute any connected signal
                widgets = function[0].get('return_type')
                if widgets:
                    for w in function[0]['return_type']:
                        signal = w.get('signal')
                        if signal:
                            getattr(module, signal)(dialog)

                # We configure functionparams in the table config_toolbox, if we do not find the key "selectionType" or
                # the length of the key is different from 1, we will do nothing, but if we find it and its length is 1,
                # it means that the user has configured it to show only one of the two radiobuttons, therefore, we will
                # hide the other and mark the one that the user tells us.
                # Options: "selectionType":"selected" //  "selectionType":"all"
                selectionType = function[0]['input_params'].get('selectionType')
                if selectionType:
                    if 'selected' in selectionType:
                        dialog.rbt_previous.setChecked(True)
                        dialog.rbt_layer.setVisible(False)
                    elif 'all' in selectionType:
                        dialog.rbt_layer.setChecked(True)
                        dialog.rbt_previous.setVisible(False)

                status = True
                break

        return status


    def _populate_cmb_type(self, feature_types):

        feat_types = []
        for item in feature_types:
            elem = [item.upper(), item.upper()]
            feat_types.append(elem)
        if feat_types and len(feat_types) <= 1:
            self.dlg_functions.cmb_feature_type.setVisible(False)
        tools_qt.fill_combo_values(self.dlg_functions.cmb_feature_type, feat_types, 1)


    def _get_all_group_layers(self, feature_type):

        list_items = []
        sql = (f"SELECT tablename, type FROM "
               f"(SELECT DISTINCT(parent_layer) AS tablename, feature_type as type, 0 as c FROM cat_feature "
               f"UNION SELECT child_layer, feature_type, 2 as c FROM cat_feature "
               F" UNION "
               f"SELECT concat('v_edit_',epa_table), feature_type as type, 4 as c FROM sys_feature_epa_type "
               f"WHERE epa_table IS NOT NULL AND epa_table NOT IN ('inp_virtualvalve', 'inp_inlet')"
			   f"UNION SELECT 'v_edit_inp_subcatchment', 'SUBCATCHMENT', 6"
			   f"UNION SELECT 'v_edit_raingage', 'RAINGAGE', 8 ) t "
               f" WHERE type = '{feature_type.upper()}' ORDER BY c, tablename")
        rows = tools_db.get_rows(sql)
        if rows:
            for row in rows:
                layer = tools_qgis.get_layer_by_tablename(row[0])
                if layer:
                    elem = [row[1], layer]
                    list_items.append(elem)

        return list_items


    def _populate_layer_combo(self):

        feature_type = tools_qt.get_combo_value(self.dlg_functions, self.dlg_functions.cmb_feature_type, 0)
        self.layers = []
        self.layers = self._get_all_group_layers(feature_type)

        layers = []
        legend_layers = tools_qgis.get_project_layers()
        for feature_type, layer in self.layers:
            if layer in legend_layers:
                elem = []
                layer_name = tools_qgis.get_layer_source_table_name(layer)
                elem.append(layer.name())
                elem.append(layer_name)
                elem.append(feature_type)
                layers.append(elem)
        if not layers:
            elem = [f"There is no layer related to {feature_type}.", None, None]
            layers.append(elem)

        tools_qt.fill_combo_values(self.dlg_functions.cmb_layers, layers, sort_combo=False)


    def _populate_trv(self, trv_widget, result, expand=False):

        model = QStandardItemModel()
        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)

        icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '24x24' + os.sep
        path_icon_blue = icon_folder + os.sep + '36.png'

        # Section Processes
        section_processes = QStandardItem('{}'.format('Processes'))
        for group, functions in result['processes']['fields'].items():
            parent1 = QStandardItem(f'{group} [{len(functions)}]')
            self.no_clickable_items.append(f'{group} [{len(functions)}]')
            functions.sort(key=self._sort_list, reverse=False)
            for function in functions:
                func_name = QStandardItem(str(function['functionname']))
                label = QStandardItem(str(function['alias']))
                font = label.font()
                font.setPointSize(8)
                label.setFont(font)
                if os.path.exists(path_icon_blue):
                    icon = QIcon(path_icon_blue)
                    label.setIcon(icon)
                    label.setToolTip(function['functionname'])

                parent1.appendRow([label, func_name])
            section_processes.appendRow(parent1)

        # Section Reports
        reports_processes = QStandardItem('{}'.format('Reports'))
        for group, functions in result['reports']['fields'].items():
            parent1 = QStandardItem(f'{group} [{len(functions)}]')
            self.no_clickable_items.append(f'{group} [{len(functions)}]')
            functions.sort(key=self._sort_list, reverse=False)
            for function in functions:
                func_name = QStandardItem(str(function['listname']))
                label = QStandardItem(str(function['alias']))
                vdefault = QStandardItem(str(function['addparam']))
                font = label.font()
                font.setPointSize(8)
                label.setFont(font)
                parent1.appendRow([label, func_name, vdefault])
                if os.path.exists(path_icon_blue):
                    icon = QIcon(path_icon_blue)
                    label.setIcon(icon)

            reports_processes.appendRow(parent1)

        if os.path.exists(path_icon_blue):
            icon = QIcon(path_icon_blue)
            section_processes.setIcon(icon)
            reports_processes.setIcon(icon)

        model.appendRow(section_processes)
        model.appendRow(reports_processes)

        section_index = model.indexFromItem(section_processes)
        reports_index = model.indexFromItem(reports_processes)

        trv_widget.expand(section_index)
        trv_widget.expand(reports_index)

        if expand:
            trv_widget.expandAll()


    def _sort_list(self, json_):

        try:
            return json_['alias'].upper()
        except KeyError:
            return 0


    def _cancel_task(self):

        if hasattr(self, 'toolbox_task'):
            self.toolbox_task.cancel()


    def _select_file_report(self):
        """ Select CSV file """

        file_report = tools_qt.get_text(self.dlg_reports, 'txt_export_path')
        # Set default value if necessary
        if file_report is None or file_report == '':
            file_report = global_vars.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(file_report)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_qt.tr("Save report file")
        file_report, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.csv')
        tools_qt.set_widget_text(self.dlg_reports, self.dlg_reports.txt_export_path, file_report)


    def _export_reports(self, dialog, table, path):

        folder_path = tools_qt.get_text(dialog, path)
        if folder_path is None or folder_path == 'null':
            path.setStyleSheet("border: 1px solid red")
            return

        path.setStyleSheet(None)
        if folder_path.find('.csv') == -1:
            folder_path += '.csv'
        if table:
            model = table.model()
        else:
            return

        # Convert qtable values into list
        all_rows = []
        headers = []
        for i in range(0, model.columnCount()):
            headers.append(str(model.headerData(i, Qt.Horizontal)))
        all_rows.append(headers)
        for rows in range(0, model.rowCount()):
            row = []
            for col in range(0, model.columnCount()):
                value = str(model.data(model.index(rows, col)))
                row.append(value)
            all_rows.append(row)

        # Write list into csv file
        try:
            if os.path.exists(folder_path):
                msg = "Are you sure you want to overwrite this file?"
                answer = tools_qt.show_question(msg, "Overwrite")
                if answer:
                    self._write_to_csv(folder_path, all_rows)
            else:
                self._write_to_csv(folder_path, all_rows)
        except Exception:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            tools_qgis.show_warning(msg)


    def _write_to_csv(self, folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, delimiter=';', lineterminator='\n')
            writer.writerows(all_rows)
        message = "The csv file has been successfully exported"
        tools_qgis.show_info(message)

    # endregion