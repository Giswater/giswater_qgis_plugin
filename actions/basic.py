"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from PyQt4.QtGui import QTableView, QAbstractItemView
from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel

import os
import sys
from functools import partial



plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater


from ..ui.multirow_selector import Multirow_selector       # @UnresolvedImport

from parent import ParentAction


class Basic(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type

    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])
    
    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """
        dlg_multiexp = Multirow_selector()
        utils_giswater.setDialog(dlg_multiexp)
        dlg_multiexp.btn_ok.pressed.connect(dlg_multiexp.close)
        dlg_multiexp.setWindowTitle("Explotation selector")
        tableleft = "exploitation"
        tableright = "selector_expl"
        field_id_left = "expl_id"
        field_id_right = "expl_id"

        self.multi_row_selector(dlg_multiexp, tableleft, tableright, field_id_left, field_id_right)
        dlg_multiexp.exec_()


    def basic_state_selector(self):
        """ Button 48: State selector """

        # Create the dialog and signals
        dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(dlg_psector_sel)
        dlg_psector_sel.btn_ok.pressed.connect(dlg_psector_sel.close)
        dlg_psector_sel.setWindowTitle("State selector")
        tableleft = "value_state"
        tableright = "selector_state"
        field_id_left = "id"
        field_id_right = "state_id"
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.exec_()




    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right):
        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT * FROM " + self.controller.schema_name + "." + tableleft + " WHERE name NOT IN ("
        sql += "SELECT name FROM " + self.controller.schema_name + "." + tableleft + "  RIGTH JOIN "
        sql += self.controller.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        sql += " WHERE cur_user = current_user)"
        self.fill_table_by_query(tbl_all_rows, sql)
        self.hide_colums(tbl_all_rows, [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        tbl_all_rows.setColumnWidth(1, 200)
        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT name, cur_user, " + tableleft + "." + field_id_left + ", "+ tableright + "." + field_id_right + " FROM " + self.controller.schema_name + "." + tableleft
        sql += " JOIN " + self.controller.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        sql += " WHERE cur_user=current_user"
        self.fill_table_by_query(tbl_selected_rows, sql)
        self.hide_colums(tbl_selected_rows, [1, 2, 3])
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        query_left = "SELECT * FROM " + self.controller.schema_name + "." + tableleft + " WHERE name NOT IN "
        query_left += "(SELECT name FROM " + self.controller.schema_name + "." + tableleft
        query_left += " RIGHT JOIN " + self.controller.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_left += " WHERE cur_user = current_user)"

        query_right = "SELECT name, cur_user, " + tableleft + "." + field_id_left + " FROM " + self.controller.schema_name + "." + tableleft
        query_right += " JOIN " + self.controller.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_right += " WHERE cur_user = current_user"
        dialog.btn_select.pressed.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright, "id", query_left, query_right, field_id_right))

        # Button unselect
        query_delete = "DELETE FROM " + self.controller.schema_name + "." + tableright
        query_delete += " WHERE current_user = cur_user AND " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.pressed.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right, field_id_right))
        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog.txt_name, tbl_all_rows, tableleft, tableright, field_id_right))

    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)
        self.iface.mapCanvas().refresh()

    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right, field_id):
        """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        :param query_right:
        :param query_left:
        :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(" + id_des + ", cur_user)"
            sql += " FROM " + self.schema_name+"." + tablename_des
            sql += " WHERE " + id_des + " = '" + str(expl_id[i])
            row = self.dao.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id "+str(expl_id[i])+" is already selected!", "Info")
            else:
                sql = 'INSERT INTO '+self.schema_name+'.'+tablename_des+' ('+field_id+', cur_user) '
                sql += " VALUES ("+str(expl_id[i])+", current_user)"
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.iface.mapCanvas().refresh()

    def fill_table(self, widget, table_name):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        widget.setModel(model)

    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()


    def query_like_widget_text(self, text_line, qtable, tableleft, tableright, field_id):
        """ Fill the QTableView by filtering through the QLineEdit"""
        query = text_line.text()
        sql = "SELECT * FROM " + self.controller.schema_name + "." + tableleft + " WHERE name NOT IN "
        sql += "(SELECT name FROM " + self.controller.schema_name + "." + tableleft
        sql += " RIGHT JOIN " + self.controller.schema_name + "." + tableright + " ON " + tableleft + "." + field_id + " = " + tableright + "." + field_id
        sql += " WHERE cur_user = current_user) AND name LIKE '%" + query + "%'"
        self.fill_table_by_query(qtable, sql)
