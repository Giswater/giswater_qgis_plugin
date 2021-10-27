"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json

from functools import partial

from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtWidgets import QAbstractItemView
from qgis.PyQt.QtGui import QRegExpValidator

from ..dialog import GwAction
from ...ui.ui_manager import GwEpaManagerUi
from ...utils import tools_gw
from ....lib import tools_qt, tools_db, tools_qgis


class GwGo2EpaManagerButton(GwAction):
    """ Button 25: Go2epa maanger """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._manage_go2epa()


    # region private functions

    def _manage_go2epa(self):

        # Create the dialog
        self.dlg_manager = GwEpaManagerUi()
        tools_gw.load_settings(self.dlg_manager)

        # Manage widgets
        reg_exp = QRegExp("^[A-Za-z0-9_]{1,16}$")
        self.dlg_manager.txt_result_id.setValidator(QRegExpValidator(reg_exp))

        # Fill combo box and table view
        self._fill_combo_result_id()
        self.dlg_manager.tbl_rpt_cat_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        message = tools_qt.fill_table(self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_manager, self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')

        # Set signals
        self.dlg_manager.btn_delete.clicked.connect(partial(self._multi_rows_delete, self.dlg_manager.tbl_rpt_cat_result,
                                                            'rpt_cat_result', 'result_id'))
        selection_model = self.dlg_manager.tbl_rpt_cat_result.selectionModel()
        selection_model.selectionChanged.connect(partial(self._fill_txt_infolog))
        self.dlg_manager.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_manager))
        self.dlg_manager.rejected.connect(partial(tools_gw.close_dialog, self.dlg_manager))
        self.dlg_manager.txt_result_id.editTextChanged.connect(self._filter_by_result_id)

        # Open form
        tools_gw.open_dialog(self.dlg_manager, dlg_name='go2epa_manager')

    def _fill_txt_infolog(self, selected):
        """
        Fill txt_infolog from epa_result_manager form with current data selected for columns:
            'export_options'
            'network_stats'
            'inp_options'
        """

        # Get id of selected row
        row = selected.indexes()
        if not row:
            return

        msg = ""

        # Get column index for column export_options
        col_ind = tools_qt.get_col_index_by_col_name(self.dlg_manager.tbl_rpt_cat_result, 'export_options')
        export_options = json.loads(row[col_ind].data())

        # Get column index for column network_stats
        col_ind = tools_qt.get_col_index_by_col_name(self.dlg_manager.tbl_rpt_cat_result, 'network_stats')
        network_stats = json.loads(row[col_ind].data())

        # Get column index for column inp_options
        col_ind = tools_qt.get_col_index_by_col_name(self.dlg_manager.tbl_rpt_cat_result, 'inp_options')
        inp_options = json.loads(row[col_ind].data())

        # Construct message with all data rows
        msg += f"<b>Export Options: </b> <br>"
        for text in export_options:
            msg += f"{text} : {export_options[text]} <br>"

        msg += f" <br> <b>Network Status: </b> <br>"
        for text in network_stats:
            msg += f"{text} : {network_stats[text]} <br>"

        msg += f" <br> <b>Inp Options: </b> <br>"
        for text in inp_options:
            msg += f"{text} : {inp_options[text]} <br>"

        # Set message text into widget
        tools_qt.set_widget_text(self.dlg_manager, 'txt_infolog', msg)


    def _fill_combo_result_id(self):

        sql = "SELECT result_id FROM v_ui_rpt_cat_result ORDER BY result_id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(self.dlg_manager, self.dlg_manager.txt_result_id, rows)


    def _filter_by_result_id(self):

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


    def _multi_rows_delete(self, widget, table_name, column_id):
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
        answer = tools_qt.show_question(message, title, inf_text)
        if answer:
            sql = f"DELETE FROM {table_name}"
            sql += f" WHERE {column_id} IN ({list_id})"
            tools_db.execute_sql(sql)
            widget.model().select()

    # endregion