"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QStringListModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QTableView, QMenu, QPushButton, QLineEdit, QCompleter, QAbstractItemView

import datetime
import json
import os
import subprocess

from collections import OrderedDict
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent
from .parent import ParentAction
from ..ui_manager import SelectorUi, MincutManagerUi


class MincutConfig(ParentAction):
    
    def __init__(self, mincut):
        """ Class constructor """

        self.mincut = mincut
        self.canvas = mincut.canvas
        self.plugin_dir = mincut.plugin_dir
        self.controller = self.mincut.controller
        self.schema_name = self.controller.schema_name
        self.settings = self.mincut.settings
        self.api_parent = ApiParent(mincut.iface, self.settings, self.controller, self.plugin_dir)


    def mg_mincut_management(self):
        """ Button 27: Mincut management """

        self.action = "mg_mincut_management"

        # Create the dialog and signals
        self.dlg_min_edit = MincutManagerUi()
        self.load_settings(self.dlg_min_edit)
        self.set_dates_from_to(self.dlg_min_edit.date_from, self.dlg_min_edit.date_to, 'om_mincut',
            'forecast_start, exec_start', 'forecast_end, exec_end')
        self.dlg_min_edit.date_from.setEnabled(False)
        self.dlg_min_edit.date_to.setEnabled(False)
        self.set_icon(self.dlg_min_edit.btn_selector_mincut, "191")
        
        self.tbl_mincut_edit = self.dlg_min_edit.findChild(QTableView, "tbl_mincut_edit")
        self.txt_mincut_id = self.dlg_min_edit.findChild(QLineEdit, "txt_mincut_id")
        self.tbl_mincut_edit.setSelectionBehavior(QAbstractItemView.SelectRows)        
        
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.txt_mincut_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_mincut WHERE id > 0 "
        rows = self.controller.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_min_edit.date_from.dateChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_min_edit.date_to.dateChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_min_edit.cmb_expl.currentIndexChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_min_edit.spn_next_days.setRange(-9999, 9999)
        self.dlg_min_edit.btn_next_days.clicked.connect(self.filter_by_days)
        self.dlg_min_edit.spn_next_days.valueChanged.connect(self.filter_by_days)
        self.dlg_min_edit.btn_cancel_mincut.clicked.connect(self.set_state_cancel_mincut)
        self.dlg_min_edit.tbl_mincut_edit.doubleClicked.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.rejected.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.btn_delete.clicked.connect(partial(
            self.delete_mincut_management, self.tbl_mincut_edit, "om_mincut", "id"))
        self.dlg_min_edit.btn_selector_mincut.clicked.connect(partial(
            self.mincut_selector, self.tbl_mincut_edit, 'id'))
        self.btn_notify = self.dlg_min_edit.findChild(QPushButton, "btn_notify")
        self.btn_notify.clicked.connect(partial(self.get_clients_codes, self.dlg_min_edit.tbl_mincut_edit))
        self.set_icon(self.btn_notify, "307")

        try:
            row = self.controller.get_config('om_mincut_enable_alerts', 'value', 'config_param_system')
            if row:
                self.custom_action_sms = json.loads(row[0], object_pairs_hook=OrderedDict)
                self.btn_notify.setVisible(self.custom_action_sms['show_mincut_sms'])
        except KeyError:
            self.btn_notify.setVisible(False)

        self.populate_combos()
        self.dlg_min_edit.state_edit.activated.connect(partial(self.filter_by_id, self.tbl_mincut_edit))

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".v_ui_mincut")
        self.set_table_columns(self.dlg_min_edit, self.tbl_mincut_edit, "v_ui_mincut")

        #self.mincut.set_table_columns(self.tbl_mincut_edit, "v_ui_mincut")

        # Open the dialog
        self.open_dialog(self.dlg_min_edit, dlg_name='mincut_manager')


    def get_clients_codes(self, qtable):

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        field_code = self.custom_action_sms['field_code']
        inf_text = "Are you sure you want to send smd to this clients?"
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable.model().record(row).value(str('id'))
            inf_text += f"\n\nMincut: {id_}"
            sql = (f"SELECT t3.{field_code}, t2.forecast_start, t2.forecast_end, anl_cause "
                   f"FROM om_mincut_hydrometer AS t1 "
                   f"JOIN ext_rtc_hydrometer AS t3 ON t1.hydrometer_id::bigint = t3.id::bigint "
                   f"JOIN om_mincut AS t2 ON t1.result_id = t2.id "
                   f"WHERE result_id = {id_}")
            rows = self.controller.get_rows(sql, log_sql=True)
            if not rows:
                inf_text += "\nClients: None(No messages will be sent)"
                continue

            inf_text += "\nClients: \n"
            for row in rows:
                inf_text += str(row[0]) + ", "

        inf_text = inf_text[:-2]
        inf_text += "\n"
        answer = self.controller.ask_question(str(inf_text))
        if answer:
            self.call_sms_script(qtable)


    def call_sms_script(self, qtable):

        path = self.custom_action_sms['path_sms_script']
        if path is None or not os.path.exists(path):
            self.controller.show_warning("File not found", parameter=path)
            return

        selected_list = qtable.selectionModel().selectedRows()
        field_code = self.custom_action_sms['field_code']

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable.model().record(row).value(str('id'))
            sql = (f"SELECT t3.{field_code}, t2.forecast_start, t2.forecast_end, anl_cause, notified  "
                   f"FROM om_mincut_hydrometer AS t1 "
                   f"JOIN ext_rtc_hydrometer AS t3 ON t1.hydrometer_id::bigint = t3.id::bigint "
                   f"JOIN om_mincut AS t2 ON t1.result_id = t2.id "
                   f"WHERE result_id = {id_}")
            rows = self.controller.get_rows(sql, log_sql=True)
            if not rows:
                continue

            from_date = ""
            if rows[0][1] is not None:
                from_date = str(rows[0][1].strftime('%d/%m/%Y %H:%M'))

            to_date = ""
            if rows[0][2] is not None:
                to_date = str(rows[0][2].strftime('%d/%m/%Y %H:%M'))

            _cause = ""
            if rows[0][3] is not None:
                _cause = rows[0][3]

            list_clients = ""
            for row in rows:
                list_clients += str(row[0]) + ", "
            if len(list_clients) != 0:
                list_clients = list_clients[:-2]

            # Call script
            result = subprocess.call([path, _cause, from_date, to_date, list_clients])

            _date_sended = datetime.datetime.now().strftime('%d/%m/%Y %H:%M')
            sql = ("UPDATE " + self.schema_name + ".om_mincut ")
            if row[4] is None:
                sql += f"SET notified = ('[{{\"code\":\"{result[0]}\",\"date\":\"{_date_sended}\",\"avisats\":\"{result[1]}\",\"afectats\":\"{result[2]}\"}}]') "
            else:
                sql += f"SET notified= concat(replace(notified::text,']',','),'{{\"code\":\"{result[0]}\",\"date\":\"{_date_sended}\",\"avisats\":\"{result[1]}\",\"afectats\":\"{result[2]}\"}}]')::json "
            sql += f"WHERE id = '{id_}'"
            row = self.controller.execute_sql(sql)

            # Set a model with selected filter. Attach that model to selected table
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".v_ui_mincut")
            self.set_table_columns(self.dlg_min_edit, self.tbl_mincut_edit, "v_ui_mincut")


    def set_state_cancel_mincut(self):

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_mincut_edit.model().record(row).value("id")
            inf_text += f"{id_}, "
            list_id += f"'{id_}', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to cancel these mincuts?"
        title = "Cancel mincuts"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = (f"UPDATE om_mincut SET mincut_state = 3 "
                   f" WHERE id::text IN ({list_id})")
            self.controller.execute_sql(sql, log_sql=False)
            self.tbl_mincut_edit.model().select()


    def mincut_selector(self, qtable, field_id):
        """ Manage mincut selector """

        model = qtable.model()
        selected_mincuts = []
        for x in range(0, model.rowCount()):
            i = int(model.fieldIndex(field_id))
            value = model.data(model.index(x, i))
            selected_mincuts.append(value)
        selector_values = f'{{"mincut": {{"ids":{selected_mincuts}, "filter":""}}}}'
        self.dlg_selector = SelectorUi()
        self.load_settings(self.dlg_selector)
        self.dlg_selector.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_selector))
        self.dlg_selector.rejected.connect(partial(self.save_settings, self.dlg_selector))
        self.dlg_selector.txt_filter.textChanged.connect(
            partial(self.api_parent.get_selector, self.dlg_selector, selector_values, filter=True))

        self.api_parent.get_selector(self.dlg_selector, selector_values)

        self.open_dialog(self.dlg_selector, dlg_name='selector', maximize_button=False)


    def populate_combos(self):

        # Fill ComboBox state
        sql = ("SELECT id, idval "
               "FROM om_typevalue WHERE typevalue = 'mincut_state' "
               "ORDER BY id")
        rows = self.controller.get_rows(sql, add_empty_row=True)
        utils_giswater.set_item_data(self.dlg_min_edit.state_edit, rows, 1)

        # Fill ComboBox exploitation
        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id > 0 ORDER BY name"
        rows = self.controller.get_rows(sql, add_empty_row=True)
        utils_giswater.set_item_data(self.dlg_min_edit.cmb_expl, rows, 1)


    def open_mincut(self):
        """ Open mincut form with selected record of the table """

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()

        # Get mincut_id from selected row
        result_mincut_id = self.tbl_mincut_edit.model().record(row).value("id")

        # Close this dialog and open selected mincut
        self.close_dialog(self.dlg_min_edit)
        self.mincut.is_new = False
        self.mincut.init_mincut_form()
        self.mincut.load_mincut(result_mincut_id)
        self.mincut.manage_docker()


    def filter_by_days(self):

        date_from = datetime.datetime.now()
        days_added = self.dlg_min_edit.spn_next_days.text()
        date_to = datetime.datetime.now()
        date_to += datetime.timedelta(days=int(days_added))

        # If the date_to is less than the date_from, you have to exchange them or the interval will not work
        if date_to < date_from:
            aux = date_from
            date_from = date_to
            date_to = aux

        format_low = '%Y-%m-%d 00:00:00.000'
        format_high = '%Y-%m-%d 23:59:59.999'
        interval = f"'{date_from.strftime(format_low)}'::timestamp AND '{date_to.strftime(format_high)}'::timestamp"

        expr = f"(forecast_start BETWEEN {interval})"
        self.tbl_mincut_edit.model().setFilter(expr)
        self.tbl_mincut_edit.model().select()


    def filter_by_id(self, qtable):

        expr = ""
        id_ = utils_giswater.getWidgetText(self.dlg_min_edit, self.dlg_min_edit.txt_mincut_id, False, False)
        state_id = utils_giswater.get_item_data(self.dlg_min_edit, self.dlg_min_edit.state_edit, 0)
        state_text = utils_giswater.get_item_data(self.dlg_min_edit, self.dlg_min_edit.state_edit, 1)
        expl = utils_giswater.get_item_data(self.dlg_min_edit, self.dlg_min_edit.cmb_expl, 1)
        dates_filter = ""
        if state_id == '':
            self.dlg_min_edit.date_from.setEnabled(False)
            self.dlg_min_edit.date_to.setEnabled(False)
        else:
            self.dlg_min_edit.date_from.setEnabled(True)
            self.dlg_min_edit.date_to.setEnabled(True)

            # Get selected dates
            visit_start = self.dlg_min_edit.date_from.date()
            visit_end = self.dlg_min_edit.date_to.date()
            date_from = visit_start.toString('yyyyMMdd 00:00:00')
            date_to = visit_end.toString('yyyyMMdd 23:59:59')
            if date_from > date_to:
                message = "Selected date interval is not valid"
                self.controller.show_warning(message)
                return

            # Create interval dates
            format_low = 'yyyy-MM-dd 00:00:00.000'
            format_high = 'yyyy-MM-dd 23:59:59.999'
            interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"
            if str(state_id) in ('0', '3'):
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_from, 'Date from: forecast_start')
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_to, 'Date to: forecast_end')
                dates_filter = f"AND (forecast_start BETWEEN {interval}) AND (forecast_end BETWEEN {interval})"
            elif str(state_id) in ('1', '2'):
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_from, 'Date from: exec_start')
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_to, 'Date to: exec_end')
                dates_filter = f"AND (exec_start BETWEEN {interval}) AND (exec_end BETWEEN {interval})"
            else:
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_from, 'Date from:')
                utils_giswater.setWidgetText(self.dlg_min_edit, self.dlg_min_edit.lbl_date_to, 'Date to:')

        expr += f" (id::text ILIKE '%{id_}%'"
        expr += f" OR work_order::text ILIKE '%{id_}%')"
        expr += f" {dates_filter}"
        if state_text != '':
            expr += f" AND state::text ILIKE '%{state_text}%' "
        expr += f" AND (exploitation::text ILIKE '%{expl}%' OR exploitation IS null)"

        # Refresh model with selected filter
        qtable.model().setFilter(expr)
        qtable.model().select()


    def fill_table_mincut_management(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.sort(0, 1)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)


    def delete_mincut_management(self, widget, table_name, column_id):
        """ Delete selected elements of the table (by id) """
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += f"{id_}, "
            list_id += f"'{id_}', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these mincuts?"
        title = "Delete mincut"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = (f"DELETE FROM {table_name}"
                   f" WHERE {column_id} IN ({list_id})")
            self.controller.execute_sql(sql)
            widget.model().select()
            layer = self.controller.get_layer_by_tablename('v_om_mincut_node')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_om_mincut_connec')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_om_mincut_arc')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_om_mincut_valve')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_om_mincut')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_om_mincut_hydrometer')
            if layer is not None:
                layer.triggerRepaint()
