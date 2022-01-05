"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import re
from functools import partial

from qgis.PyQt.QtGui import QRegExpValidator, QStandardItemModel
from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtWidgets import QTableView
from qgis.PyQt.QtWidgets import QDialog, QLabel, QLineEdit, QPlainTextEdit

from ..dialog import GwAction
from ..utilities.toolbox_btn import GwToolBoxButton
from ...ui.ui_manager import GwDscenarioManagerUi, GwDscenarioUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db


class GwDscenarioManagerButton(GwAction):
    """ Button 215: Dscenario manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_dscenario_manager()


    # region private functions

    def _open_dscenario_manager(self):
        """ Open dscenario manager """

        # Main dialog
        self.dlg_dscenario_manager = GwDscenarioManagerUi()
        tools_gw.load_settings(self.dlg_dscenario_manager)

        # Manage active buttons depending on project type
        self._manage_active_functions()

        # Apply filter validator
        self.filter_name = self.dlg_dscenario_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Fill table
        self.tbl_dscenario = self.dlg_dscenario_manager.findChild(QTableView, 'tbl_dscenario')
        self._fill_tbl()

        # Connect main dialog signals
        self.dlg_dscenario_manager.txt_name.textChanged.connect(partial(self._fill_tbl))
        self.dlg_dscenario_manager.btn_execute.clicked.connect(partial(self._open_toolbox_function, None))
        self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_selected_dscenario))
        self.tbl_dscenario.doubleClicked.connect(self._open_dscenario)

        # selection_model = self.dlg_dscenario_manager.tbl_dscenario.selectionModel()
        # selection_model.selectionChanged.connect(partial(self._fill_info))
        # self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_workspace))

        self.dlg_dscenario_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_dscenario_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_dscenario_manager, 'dscenario_manager')


    def _manage_active_functions(self):

        values = [[3042, "Manage values"]]
        if global_vars.project_type == 'ws':
            values.append([3110, "Create from CRM"])
            values.append([3112, "Create demand from ToC"])
            values.append([3108, "Create from ToC"])
        if global_vars.project_type == 'ud':
            values.append([3118, "Create from ToC"])
        tools_qt.fill_combo_values(self.dlg_dscenario_manager.cmb_actions, values, index_to_show=1)


    def _open_dscenario(self, index):

        # Get selected dscenario_id
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(self.tbl_dscenario, 'dscenario_id')
        dscenario_id = index.sibling(row, column_index).data()

        # Create dialog
        self.dlg_dscenario = GwDscenarioUi()
        tools_gw.load_settings(self.dlg_dscenario)

        # Select all dscenario views
        sql = f"SELECT table_name FROM INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false)) " \
              f"AND table_name LIKE 'v_edit_inp_dscenario%'"
        rows = tools_db.get_rows(sql)
        if rows:
            views = [x[0] for x in rows]
            for view in views:
                qtableview = QTableView()
                complet_list = self._get_list(view, filter_id=f"{dscenario_id}")
                if complet_list is False:
                    continue
                for field in complet_list['body']['data']['fields']:
                    if 'hidden' in field and field['hidden']: continue
                    model = qtableview.model()
                    if model is None:
                        model = QStandardItemModel()
                        qtableview.setModel(model)
                    model.removeRows(0, model.rowCount())

                    if field['value']:
                        qtableview = tools_gw.add_tableview_header(qtableview, field)
                        qtableview = tools_gw.fill_tableview_rows(qtableview, field)
                    tools_qt.set_tableview_config(qtableview)
                self.dlg_dscenario.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")

        tools_gw.open_dialog(self.dlg_dscenario, 'dscenario')


    def _delete_selected_dscenario(self):

        # Get selected row
        selected_list = self.tbl_dscenario.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Get selected dscenario id
        index = self.tbl_dscenario.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 1).data())
        if answer:
            sql = f"DELETE FROM v_edit_cat_dscenario WHERE dscenario_id = {value}"
            tools_db.execute_sql(sql)

            self._fill_tbl(self.filter_name.text())
        pass


    def _get_list(self, table_name='v_edit_cat_dscenario', filter_name="", filter_id=None):
        """ Mount and execute the query for gw_fct_getlist """

        feature = f'"tableName":"{table_name}"'
        filter_fields = f'"limit": -1, "name": {{"filterSign":"ILIKE", "value":"{filter_name}"}}'
        if filter_id is not None:
            filter_fields += f', "dscenario_id": {{"filterSign":"=", "value":"{filter_id}"}}'
        body = tools_gw.create_body(feature=feature, filter_fields=filter_fields)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list


    def _fill_tbl(self, filter_name=""):
        """ Fill table with initial data into QTableView """

        complet_list = self._get_list("v_edit_cat_dscenario", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue
            model = self.tbl_dscenario.model()
            if model is None:
                model = QStandardItemModel()
                self.tbl_dscenario.setModel(model)
            model.removeRows(0, model.rowCount())

            if field['value']:
                self.tbl_dscenario = tools_gw.add_tableview_header(self.tbl_dscenario, field)
                self.tbl_dscenario = tools_gw.fill_tableview_rows(self.tbl_dscenario, field)
            # TODO: config_form_tableview
            # widget = tools_gw.set_tablemodel_config(self.dlg_dscenario_manager, self.tbl_dscenario, 'tbl_dscenario', 1, True)
            tools_qt.set_tableview_config(self.tbl_dscenario)

        return complet_list


    def _open_toolbox_function(self, function=None):

        if function is None:
            function = tools_qt.get_combo_value(self.dlg_dscenario_manager, 'cmb_actions')

        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        toolbox_btn.open_function_by_id(function)
        return

    # endregion
