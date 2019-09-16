"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import subprocess

from PyQt4.QtCore import Qt
from PyQt4.QtGui import QTableView, QPushButton, QLineEdit, QStringListModel, QCompleter, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel

import datetime
import utils_giswater
from functools import partial

from giswater.ui_manager import Multirow_selector
from giswater.ui_manager import Mincut_edit
from giswater.actions.parent import ParentAction


class MincutConfig(ParentAction):
    
    def __init__(self, mincut):
        """ Class constructor """
        self.mincut = mincut
        self.canvas = mincut.canvas
        self.plugin_dir = mincut.plugin_dir
        self.controller = self.mincut.controller
        self.schema_name = self.controller.schema_name
        self.settings = self.mincut.settings


    def mg_mincut_management(self):
        """ Button 27: Mincut management """

        self.action = "mg_mincut_management"

        # Create the dialog and signals
        self.dlg_min_edit = Mincut_edit()
        self.load_settings(self.dlg_min_edit)
        self.set_icon(self.dlg_min_edit.btn_selector_mincut, "191")

        self.tbl_mincut_edit = self.dlg_min_edit.findChild(QTableView, "tbl_mincut_edit")
        self.txt_mincut_id = self.dlg_min_edit.findChild(QLineEdit, "txt_mincut_id")
        self.tbl_mincut_edit.setSelectionBehavior(QAbstractItemView.SelectRows)        
        
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.txt_mincut_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".v_ui_anl_mincut_result_cat "
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "v_ui_anl_mincut_result_cat"))

        self.dlg_min_edit.tbl_mincut_edit.doubleClicked.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.rejected.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.btn_delete.clicked.connect(partial(self.delete_mincut_management, self.tbl_mincut_edit, "v_ui_anl_mincut_result_cat", "id"))
        self.dlg_min_edit.btn_selector_mincut.clicked.connect(partial(self.mincut_selector))
        self.btn_notify = self.dlg_min_edit.findChild(QPushButton, "btn_notify")
        self.btn_notify.clicked.connect(partial(self.get_clients_codes, self.dlg_min_edit.tbl_mincut_edit))
        self.set_icon(self.btn_notify, "307")

        btn_visible = self.settings.value('customized_actions/show_mincut_sms', 'FALSE')
        if btn_visible.upper() == 'TRUE':
            self.btn_notify.setVisible(True)
        else:
            self.btn_notify.setVisible(False)

        # Fill ComboBox state
        sql = ("SELECT name"
               " FROM " + self.schema_name + ".anl_mincut_cat_state"
               " ORDER BY name")
        rows = self.controller.get_rows(sql, commit=True)
        utils_giswater.fillComboBox(self.dlg_min_edit, "state_edit", rows)
        self.dlg_min_edit.state_edit.activated.connect(partial(self.filter_by_state, self.tbl_mincut_edit, self.dlg_min_edit.state_edit, "v_ui_anl_mincut_result_cat"))

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".v_ui_anl_mincut_result_cat")
        self.set_table_columns(self.dlg_min_edit, self.tbl_mincut_edit, "v_ui_anl_mincut_result_cat")

        #self.mincut.set_table_columns(self.tbl_mincut_edit, "v_ui_anl_mincut_result_cat")

        # Open the dialog
        self.dlg_min_edit.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_min_edit.show()


    def get_clients_codes(self, qtable):
        field_code = self.settings.value('customized_actions/field_code', 'code')
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = "Are you sure you want to send smd to this clients?"
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable.model().record(row).value(str('id'))
            inf_text += "\n\nMincut: " + str(id_) + ""
            sql = ("SELECT t3." + str(field_code) + ", t2.forecast_start, t2.forecast_end, anl_cause "
                   "FROM " + self.schema_name + ".anl_mincut_result_hydrometer AS t1 "
                   "JOIN " + self.schema_name + ".ext_rtc_hydrometer AS t3 ON t1.hydrometer_id::bigint = t3.id::bigint "
                   "JOIN " + self.schema_name + ".anl_mincut_result_cat AS t2 ON t1.result_id = t2.id "
                   "WHERE result_id = " + str(id_))

            rows = self.controller.get_rows(sql, commit=True, log_sql=True)
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
        path = self.settings.value('customized_actions/path_sms_script')
        if path is None or not os.path.exists(path):
            self.controller.show_warning("File not found", parameter=path)
            return
        field_code = self.settings.value('customized_actions/field_code', 'code')
        selected_list = qtable.selectionModel().selectedRows()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable.model().record(row).value(str('id'))
            sql = ("SELECT t3." + str(field_code) + ", t2.forecast_start, t2.forecast_end, anl_cause, notified "
                   "FROM " + self.schema_name + ".anl_mincut_result_hydrometer AS t1 "
                   "JOIN " + self.schema_name + ".ext_rtc_hydrometer AS t3 ON t1.hydrometer_id::bigint = t3.id::bigint "
                   "JOIN " + self.schema_name + ".anl_mincut_result_cat AS t2 ON t1.result_id = t2.id "
                   "WHERE result_id = " + str(id_))

            rows = self.controller.get_rows(sql, commit=True, log_sql=True)
            if not rows:
                print("NOT ROWS")
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
            status_code = subprocess.call([path, _cause, from_date, to_date, list_clients])

            # Update table with results
            _date_sended = datetime.datetime.now().strftime('%d/%m/%Y %H:%M')
            sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat ")
            if row[4] is None:
                sql += ("SET notified = ('[{\"code\":\""+str(status_code)+"\",\"date\":\""+str(_date_sended)+"\"}]') ")
            else:
                sql += ("SET notified= concat(replace(notified::text,']',','),'{\"code\":\""+str(status_code)+"\",\"date\":\""+str(_date_sended)+"\"}]')::json ")
            sql += ("WHERE id = '"+str(id_)+"'")
            row = self.controller.execute_sql(sql, commit=True, log_sql=True)

            # Set a model with selected filter. Attach that model to selected table
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".v_ui_anl_mincut_result_cat")
            self.set_table_columns(self.dlg_min_edit, self.tbl_mincut_edit, "v_ui_anl_mincut_result_cat")


    def mincut_selector(self):
        self.dlg_mincut_sel = Multirow_selector()
        self.load_settings(self.dlg_mincut_sel)

        self.dlg_mincut_sel.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_mincut_sel))
        self.dlg_mincut_sel.rejected.connect(partial(self.close_dialog, self.dlg_mincut_sel))
        self.dlg_mincut_sel.setWindowTitle("Mincut selector")
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_filter', self.controller.tr('Filter by: Mincut id', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_unselected', self.controller.tr('Unselected mincut', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_selected', self.controller.tr('Selected mincut', context_name='labels'))

        tableleft = "v_ui_anl_mincut_result_cat"
        tableright = "anl_mincut_result_selector"
        field_id_left = "id"
        field_id_right = "result_id"
        index = [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
        self.multi_row_selector(self.dlg_mincut_sel, tableleft, tableright, field_id_left, field_id_right, index=index)
        self.dlg_mincut_sel.btn_select.clicked.connect(partial(self.mincut.set_visible_mincut_layers))
        # Open dialog
        self.open_dialog(self.dlg_mincut_sel, maximize_button=False)


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
        self.mincut.init_mincut_form()
        self.mincut.load_mincut(result_mincut_id)
        self.mincut.is_new = False


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(self.dlg_min_edit, widget_txt)
        if id_ != 'null':
            expr = " id = '" + id_ + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def filter_by_state(self, table, widget, tablename):
        
        state = utils_giswater.getWidgetText(self.dlg_min_edit, widget)
        if state != 'null':
            expr_filter = " state = '" + str(state) + "'"
            # Refresh model with selected expr_filter
            table.model().setFilter(expr_filter)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def fill_table_mincut_management(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
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
            inf_text+= str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE " + column_id + " IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            widget.model().select()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_node')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_connec')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_arc')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_valve')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_cat')
            if layer is not None:
                layer.triggerRepaint()
            layer = self.controller.get_layer_by_tablename('v_anl_mincut_result_hydrometer')
            if layer is not None:
                layer.triggerRepaint()