"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtWidgets import QAbstractItemView
from qgis.PyQt.QtGui import QRegExpValidator

from ..dialog_button import GwDialogButton
from ...ui.ui_manager import EpaManagerUi
from ...utils import tools_gw
from ....lib import tools_qt, tools_db, tools_qgis


class GwGo2EpaManagerButton(GwDialogButton):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        # Create the dialog
        self.dlg_manager = EpaManagerUi()
        tools_gw.load_settings(self.dlg_manager)

        # Manage widgets
        reg_exp = QRegExp("^[A-Za-z0-9_]{1,16}$")
        self.dlg_manager.txt_result_id.setValidator(QRegExpValidator(reg_exp))

        # Fill combo box and table view
        self.fill_combo_result_id()
        self.dlg_manager.tbl_rpt_cat_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        message = tools_qt.fill_table(self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_manager, self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')

        # Set signals
        self.dlg_manager.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.dlg_manager.tbl_rpt_cat_result,
                                                            'rpt_cat_result', 'result_id'))
        self.dlg_manager.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_manager))
        self.dlg_manager.rejected.connect(partial(tools_gw.close_dialog, self.dlg_manager))
        self.dlg_manager.txt_result_id.editTextChanged.connect(self.filter_by_result_id)

        # Open form
        tools_gw.open_dialog(self.dlg_manager, dlg_name='go2epa_manager')


    def fill_combo_result_id(self):

        sql = "SELECT result_id FROM v_ui_rpt_cat_result ORDER BY result_id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(self.dlg_manager, self.dlg_manager.txt_result_id, rows)


    def filter_by_result_id(self):

        table = self.dlg_manager.tbl_rpt_cat_result
        widget_txt = self.dlg_manager.txt_result_id
        tablename = 'v_ui_rpt_cat_result'
        result_id = tools_qt.get_text(self.dlg_manager, widget_txt)
        if result_id != 'null':
            expr = f" result_id ILIKE '%{result_id}%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            message = tools_qt.fill_table(table, tablename)
            if message:
                tools_qgis.show_warning(message)


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

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
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = tools_qt.ask_question(message, title, inf_text)
        if answer:
            sql = f"DELETE FROM {table_name}"
            sql += f" WHERE {column_id} IN ({list_id})"
            tools_db.execute_sql(sql)
            widget.model().select()
