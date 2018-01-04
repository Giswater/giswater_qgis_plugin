"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QTableView, QMenu, QPushButton, QLineEdit, QStringListModel, QCompleter, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.mincut_selector import Multi_selector                   
from ui.mincut_edit import Mincut_edit                        


class MincutConfig():
    
    def __init__(self, mincut):
        """ Class constructor """
        self.mincut = mincut
        self.controller = self.mincut.controller
        self.schema_name = self.controller.schema_name
        

    def config(self):
        """ B5-99: Config """
        
        # Dialog multi_selector
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)

        self.tbl_config = self.dlg_multi.findChild(QTableView, "tbl")
        self.btn_insert = self.dlg_multi.findChild(QPushButton, "btn_insert")
        self.btn_delete = self.dlg_multi.findChild(QPushButton, "btn_delete")
        
        table = "anl_mincut_selector_valve"
        self.menu_valve = QMenu()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table))
        
        btn_cancel = self.dlg_multi.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(self.dlg_multi.close)
        
        self.menu_valve.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_valve)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records_config, self.tbl_config, table))

        self.fill_table_config(self.tbl_config, self.schema_name + "." + table)
        
        # Open form
        self.dlg_multi.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_multi.open()


    def fill_insert_menu(self, table):
        """ Insert menu on QPushButton->QMenu """
        
        self.menu_valve.clear()
        node_type = "VALVE"
        sql = ("SELECT id FROM " + self.schema_name + ".node_type"
               " WHERE type = '" + node_type + "' ORDER BY id")
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        # Fill menu
        for row in rows:
            elem = row[0]
            # If not exist in table _selector_state insert to menu
            # Check if we already have data with selected id
            sql = "SELECT id FROM " + self.schema_name + "." + table + " WHERE id = '" + elem + "'"
            rows = self.controller.get_rows(sql)
            if not rows:
                self.menu_valve.addAction(elem, partial(self.insert, elem, table))


    def insert(self, id_action, table):
        """ On action(select value from menu) execute SQL """

        # Insert value into database
        sql = "INSERT INTO " + self.schema_name + "." + table + " (id) VALUES ('" + id_action + "')"
        self.controller.execute_sql(sql)
        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)


    def fill_table_config(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model) 
        
        
    def delete_records_config(self, widget, table_name):
        """ Delete selected elements of the table """

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
            id_ = widget.model().record(row).value("id")
            inf_text += str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE id IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            widget.model().select()
            
                    
    def mg_mincut_management(self):
        """ Button 27: Mincut management """

        self.action = "mg_mincut_management"

        # Create the dialog and signals
        self.dlg_min_edit = Mincut_edit()
        utils_giswater.setDialog(self.dlg_min_edit)

        self.tbl_mincut_edit = self.dlg_min_edit.findChild(QTableView, "tbl_mincut_edit")
        self.txt_mincut_id = self.dlg_min_edit.findChild(QLineEdit, "txt_mincut_id")
        self.tbl_mincut_edit.setSelectionBehavior(QAbstractItemView.SelectRows)        
        
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.txt_mincut_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".anl_mincut_result_cat "
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "anl_mincut_result_cat"))

        self.dlg_min_edit.btn_accept.pressed.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.pressed.connect(self.dlg_min_edit.close)
        self.dlg_min_edit.btn_delete.clicked.connect(partial(self.delete_mincut_management, self.tbl_mincut_edit, "anl_mincut_result_cat", "id"))

        # Fill ComboBox state
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".anl_mincut_cat_state"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_edit", rows)
        self.dlg_min_edit.state_edit.activated.connect(partial(self.filter_by_state, self.tbl_mincut_edit, self.dlg_min_edit.state_edit, "anl_mincut_result_cat"))

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".anl_mincut_result_cat")
        self.mincut.set_table_columns(self.tbl_mincut_edit, "anl_mincut_result_cat")

        self.dlg_min_edit.show()


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
        self.dlg_min_edit.close()
        self.mincut.init_mincut_form()
        self.mincut.activate_actions_custom_mincut()
        self.mincut.load_mincut(result_mincut_id)


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(widget_txt)
        if id_ != 'null':
            expr = " id = '" + id_ + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def filter_by_state(self, table, widget, tablename):
        
        state = utils_giswater.getWidgetText(widget)
        if state != 'null':
            expr_filter = " mincut_state = '" + str(state) + "'"
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
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE " + column_id + " IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            widget.model().select()
                    
                