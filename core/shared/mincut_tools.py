"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import datetime
from functools import partial

from qgis.PyQt.QtCore import QStringListModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QTableView, QLineEdit, QCompleter, QAbstractItemView

from ..shared.selector import GwSelector
from ..ui.ui_manager import GwSelectorUi, GwMincutManagerUi
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_db


class GwMincutTools:

    def __init__(self, mincut):

        self.mincut = mincut
        self.canvas = global_vars.canvas
        self.plugin_dir = global_vars.plugin_dir
        self.schema_name = global_vars.schema_name
        self.settings = global_vars.giswater_settings


    def set_dialog(self):
        self.dlg_mincut_man = GwMincutManagerUi()


    def get_mincut_manager(self):

        self.action = "manage_mincuts"

        # Create the dialog and signals
        tools_gw.load_settings(self.dlg_mincut_man)
        tools_gw.set_dates_from_to(self.dlg_mincut_man.date_from, self.dlg_mincut_man.date_to, 'om_mincut',
                                   'forecast_start, exec_start', 'forecast_end, exec_end')
        self.dlg_mincut_man.date_from.setEnabled(False)
        self.dlg_mincut_man.date_to.setEnabled(False)
        tools_gw.add_icon(self.dlg_mincut_man.btn_selector_mincut, "191")

        self.tbl_mincut_edit = self.dlg_mincut_man.findChild(QTableView, "tbl_mincut_edit")
        self.txt_mincut_id = self.dlg_mincut_man.findChild(QLineEdit, "txt_mincut_id")
        self.tbl_mincut_edit.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.txt_mincut_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_mincut WHERE id > 0 "
        rows = tools_db.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_mincut_man.date_from.dateChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_mincut_man.date_to.dateChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_mincut_man.cmb_expl.currentIndexChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit))
        self.dlg_mincut_man.spn_next_days.setRange(-9999, 9999)
        self.dlg_mincut_man.btn_next_days.clicked.connect(self.filter_by_days)
        self.dlg_mincut_man.spn_next_days.valueChanged.connect(self.filter_by_days)
        self.dlg_mincut_man.btn_cancel_mincut.clicked.connect(self.set_state_cancel_mincut)
        self.dlg_mincut_man.tbl_mincut_edit.doubleClicked.connect(self.open_mincut)
        self.dlg_mincut_man.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_mincut_man))
        self.dlg_mincut_man.rejected.connect(partial(tools_gw.close_dialog, self.dlg_mincut_man))
        self.dlg_mincut_man.btn_delete.clicked.connect(partial(
            self.delete_mincut_management, self.tbl_mincut_edit, "om_mincut", "id"))
        self.dlg_mincut_man.btn_selector_mincut.clicked.connect(partial(
            self.mincut_selector, self.tbl_mincut_edit, 'id'))

        self.populate_combos()
        self.dlg_mincut_man.state_edit.activated.connect(partial(self.filter_by_id, self.tbl_mincut_edit))

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".v_ui_mincut")
        tools_gw.set_tablemodel_config(self.dlg_mincut_man, self.tbl_mincut_edit, "v_ui_mincut", sort_order=1)

        # self.mincut.tools_gw.set_tablemodel_config(self.tbl_mincut_edit, "v_ui_mincut")

        # Open the dialog
        tools_gw.open_dialog(self.dlg_mincut_man, dlg_name='mincut_manager')


    def set_state_cancel_mincut(self):

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
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
        answer = tools_qt.show_question(message, title, inf_text)
        if answer:
            sql = (f"UPDATE om_mincut SET mincut_state = 3 "
                   f" WHERE id::text IN ({list_id})")
            tools_db.execute_sql(sql, log_sql=False)
            self.tbl_mincut_edit.model().select()


    def mincut_selector(self, qtable, field_id):
        """ Manage mincut selector """

        model = qtable.model()
        selected_mincuts = []
        for x in range(0, model.rowCount()):
            i = int(model.fieldIndex(field_id))
            value = model.data(model.index(x, i))
            selected_mincuts.append(value)

        if len(selected_mincuts) == 0:
            msg = "There are no visible mincuts in the table. Try a different filter or make one"
            tools_qgis.show_message(msg)
            return
        selector_values = f'"selector_mincut", "ids":{selected_mincuts}'
        mincut_selector = GwSelector()


        self.dlg_selector = GwSelectorUi()
        tools_gw.load_settings(self.dlg_selector)
        current_tab = tools_gw.get_config_parser('dialogs_tab', f"{self.dlg_selector.objectName()}_mincut", "user", "session")
        self.dlg_selector.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_selector))
        self.dlg_selector.rejected.connect(partial(tools_gw.save_settings, self.dlg_selector))
        self.dlg_selector.rejected.connect(partial(tools_gw.save_current_tab, self.dlg_selector, self.dlg_selector.main_tab, 'mincut'))

        selector_vars = {}
        mincut_selector.get_selector(self.dlg_selector, selector_values, current_tab=current_tab, selector_vars=selector_vars)

        tools_gw.open_dialog(self.dlg_selector, dlg_name='selector', maximize_button=False)


    def populate_combos(self):

        # Fill ComboBox state
        sql = ("SELECT id, idval "
               "FROM om_typevalue WHERE typevalue = 'mincut_state' "
               "ORDER BY id")
        rows = tools_db.get_rows(sql, add_empty_row=True)
        tools_qt.fill_combo_values(self.dlg_mincut_man.state_edit, rows, 1)

        # Fill ComboBox exploitation
        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id > 0 ORDER BY name"
        rows = tools_db.get_rows(sql, add_empty_row=True)
        tools_qt.fill_combo_values(self.dlg_mincut_man.cmb_expl, rows, 1)


    def open_mincut(self):
        """ Open mincut form with selected record of the table """

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()

        # Get mincut_id from selected row
        result_mincut_id = self.tbl_mincut_edit.model().record(row).value("id")

        # Close this dialog and open selected mincut
        tools_gw.close_dialog(self.dlg_mincut_man)
        self.mincut.is_new = False
        self.mincut.set_dialog()
        self.mincut.init_mincut_form()
        self.mincut.load_mincut(result_mincut_id)
        self.mincut.manage_docker()
        self.mincut.set_visible_mincut_layers(True)


    def filter_by_days(self):

        date_from = datetime.datetime.now()
        days_added = self.dlg_mincut_man.spn_next_days.text()
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
        id_ = tools_qt.get_text(self.dlg_mincut_man, self.dlg_mincut_man.txt_mincut_id, False, False)
        state_id = tools_qt.get_combo_value(self.dlg_mincut_man, self.dlg_mincut_man.state_edit, 0)
        state_text = tools_qt.get_combo_value(self.dlg_mincut_man, self.dlg_mincut_man.state_edit, 1)
        expl = tools_qt.get_combo_value(self.dlg_mincut_man, self.dlg_mincut_man.cmb_expl, 1)
        dates_filter = ""
        if state_id == '':
            self.dlg_mincut_man.date_from.setEnabled(False)
            self.dlg_mincut_man.date_to.setEnabled(False)
        else:
            self.dlg_mincut_man.date_from.setEnabled(True)
            self.dlg_mincut_man.date_to.setEnabled(True)

            # Get selected dates
            visit_start = self.dlg_mincut_man.date_from.date()
            visit_end = self.dlg_mincut_man.date_to.date()
            date_from = visit_start.toString('yyyyMMdd 00:00:00')
            date_to = visit_end.toString('yyyyMMdd 23:59:59')
            if date_from > date_to:
                message = "Selected date interval is not valid"
                tools_qgis.show_warning(message)
                return

            # Create interval dates
            format_low = 'yyyy-MM-dd 00:00:00.000'
            format_high = 'yyyy-MM-dd 23:59:59.999'
            interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"
            if str(state_id) in ('0', '3'):
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_from, 'Date from: forecast_start')
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_to, 'Date to: forecast_end')
                dates_filter = f"AND (forecast_start BETWEEN {interval}) AND (forecast_end BETWEEN {interval})"
            elif str(state_id) in ('1', '2'):
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_from, 'Date from: exec_start')
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_to, 'Date to: exec_end')
                dates_filter = f"AND (exec_start BETWEEN {interval}) AND (exec_end BETWEEN {interval})"
            else:
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_from, 'Date from:')
                tools_qt.set_widget_text(self.dlg_mincut_man, self.dlg_mincut_man.lbl_date_to, 'Date to:')

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
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.sort(0, 1)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)


    def delete_mincut_management(self, widget, table_name, column_id):
        """ Delete selected elements of the table (by id) """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
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
        answer = tools_qt.show_question(message, title, inf_text)
        if answer:
            sql = (f"DELETE FROM {table_name}"
                   f" WHERE {column_id} IN ({list_id})")
            tools_db.execute_sql(sql)
            widget.model().select()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut_node')
            if layer is not None:
                layer.triggerRepaint()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut_connec')
            if layer is not None:
                layer.triggerRepaint()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut_arc')
            if layer is not None:
                layer.triggerRepaint()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut_valve')
            if layer is not None:
                layer.triggerRepaint()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut')
            if layer is not None:
                layer.triggerRepaint()
            layer = tools_qgis.get_layer_by_tablename('v_om_mincut_hydrometer')
            if layer is not None:
                layer.triggerRepaint()
