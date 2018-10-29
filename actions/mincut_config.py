"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:  
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QTableView, QMenu, QPushButton, QLineEdit, QStringListModel, QCompleter, QAbstractItemView
    from PyQt4.QtSql import QSqlTableModel
else:
    from qgis.PyQt.QtCore import Qt, QStringListModel
    from qgis.PyQt.QtWidgets import QTableView, QMenu, QPushButton, QLineEdit, QCompleter, QAbstractItemView
    from qgis.PyQt.QtSql import QSqlTableModel

from functools import partial

import utils_giswater
from giswater.ui_manager import Multirow_selector
from giswater.ui_manager import Multi_selector
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
        

    def config(self):
        """ B5-99: Config """
        
        # Dialog multi_selector
        self.dlg_multi = Multi_selector()
        self.tbl_config = self.dlg_multi.findChild(QTableView, "tbl")
        self.btn_insert = self.dlg_multi.findChild(QPushButton, "btn_insert")
        self.btn_delete = self.dlg_multi.findChild(QPushButton, "btn_delete")
        
        table = "anl_mincut_selector_valve"
        self.menu_valve = QMenu()
        self.fill_insert_menu(table)

        self.dlg_multi.btn_insert.clicked.connect(partial(self.fill_insert_menu, table))
        btn_close = self.dlg_multi.findChild(QPushButton, "btn_close")
        btn_close.clicked.connect(partial(self.close_dialog, self.dlg_multi))

        self.dlg_multi.btn_insert.setMenu(self.menu_valve)
        self.dlg_multi.btn_delete.clicked.connect(partial(self.delete_records_config, self.tbl_config, table))

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
        self.fill_insert_menu(table)
        self.dlg_multi.btn_insert.setMenu(self.menu_valve)


    def fill_table_config(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(0, 0)
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
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE id IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            widget.model().select()
        self.fill_insert_menu('anl_mincut_selector_valve')


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

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".ve_ui_mincut_result_cat "
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "ve_ui_mincut_result_cat"))

        self.dlg_min_edit.tbl_mincut_edit.doubleClicked.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.rejected.connect(partial(self.close_dialog, self.dlg_min_edit))
        self.dlg_min_edit.btn_delete.clicked.connect(partial(self.delete_mincut_management, self.tbl_mincut_edit, "ve_ui_mincut_result_cat", "id"))
        self.dlg_min_edit.btn_selector_mincut.clicked.connect(partial(self.mincut_selector))

        # Fill ComboBox state
        sql = ("SELECT name"
               " FROM " + self.schema_name + ".anl_mincut_cat_state"
               " ORDER BY name")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_min_edit, "state_edit", rows)
        self.dlg_min_edit.state_edit.activated.connect(partial(self.filter_by_state, self.tbl_mincut_edit, self.dlg_min_edit.state_edit, "ve_ui_mincut_result_cat"))

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".ve_ui_mincut_result_cat")
        self.set_table_columns(self.dlg_min_edit, self.tbl_mincut_edit, "ve_ui_mincut_result_cat")

        #self.mincut.set_table_columns(self.tbl_mincut_edit, "ve_ui_mincut_result_cat")

        # Open the dialog
        self.dlg_min_edit.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_min_edit.show()


    def mincut_selector(self):
        
        self.dlg_mincut_sel = Multirow_selector()
        self.load_settings(self.dlg_mincut_sel)

        self.dlg_mincut_sel.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_mincut_sel))
        self.dlg_mincut_sel.rejected.connect(partial(self.close_dialog, self.dlg_mincut_sel))
        self.dlg_mincut_sel.setWindowTitle("Mincut selector")
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_filter', self.controller.tr('Filter by: Mincut id', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_unselected', self.controller.tr('Unselected mincut', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_mincut_sel, 'lbl_selected', self.controller.tr('Selected mincut', context_name='labels'))

        tableleft = "ve_ui_mincut_result_cat"
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
                
                