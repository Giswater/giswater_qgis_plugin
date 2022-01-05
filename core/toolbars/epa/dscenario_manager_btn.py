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
from ...ui.ui_manager import GwDscenarioManagerUi
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
        self._manage_active_buttons()

        # Apply filter validator
        self.filter_name = self.dlg_dscenario_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Fill table
        self.tbl_dscenario = self.dlg_dscenario_manager.findChild(QTableView, 'tbl_dscenario')
        self._fill_tbl()

        # Connect main dialog signals
        self.dlg_dscenario_manager.txt_name.textChanged.connect(partial(self._fill_tbl))
        self.dlg_dscenario_manager.btn_manage_values.clicked.connect(partial(self._open_toolbox_function, "3042"))
        self.dlg_dscenario_manager.btn_create_crm.clicked.connect(partial(self._open_toolbox_function, "3110"))
        self.dlg_dscenario_manager.btn_create_d_toc.clicked.connect(partial(self._open_toolbox_function, "3112"))
        self.dlg_dscenario_manager.btn_create_toc.clicked.connect(partial(self._open_toolbox_function, "3108"))

        # selection_model = self.dlg_dscenario_manager.tbl_dscenario.selectionModel()
        # selection_model.selectionChanged.connect(partial(self._fill_info))
        # self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_workspace))

        self.dlg_dscenario_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_dscenario_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_dscenario_manager, 'dscenario_manager')


    def _manage_active_buttons(self):

        if global_vars.project_type == 'ud':
            self.dlg_dscenario_manager.btn_create_crm.setVisible(False)
            self.dlg_dscenario_manager.btn_create_d_toc.setVisible(False)


    def _open_dscenario(self):

        # Build dialog with tabs
        return

    def _open_create_workspace_dlg(self):

        # Create workspace dialog
        self.dlg_create_workspace = GwCreateWorkspaceUi()
        self.new_workspace_name = self.dlg_create_workspace.findChild(QLineEdit, 'txt_workspace_name')
        self.new_workspace_descript = self.dlg_create_workspace.findChild(QPlainTextEdit, 'txt_workspace_descript')

        # Connect create workspace dialog signals
        self.new_workspace_name.textChanged.connect(partial(self._check_exists))
        self.dlg_create_workspace.btn_accept.clicked.connect(partial(self._create_workspace))
        self.dlg_create_workspace.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_workspace))

        # Open the dialog
        tools_gw.open_dialog(self.dlg_create_workspace, 'workspace_create', stay_on_top=True)


    def _get_list(self, table_name='cat_dscenario', filter_name=""):
        """ Mount and execute the query for gw_fct_getlist """

        feature = f'"tableName":"{table_name}"'
        filter_fields = f'"limit": -1, "name": {{"filterSign":"ILIKE", "value":"{filter_name}"}}'
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

        complet_list = self._get_list("cat_dscenario", filter_name)

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


    def _open_toolbox_function(self, function):

        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        toolbox_btn.open_function_by_id(function)
        return


    def _check_exists(self, name=""):
        sql = f"SELECT name FROM cat_workspace WHERE name = '{name}'"
        row = tools_db.get_row(sql, log_info=False)
        if row:
            self.dlg_create_workspace.btn_accept.setEnabled(False)
            tools_qt.set_stylesheet(self.new_workspace_name)
            self.new_workspace_name.setToolTip("Workspace already exists")
            return
        self.dlg_create_workspace.btn_accept.setEnabled(True)
        tools_qt.set_stylesheet(self.new_workspace_name, style="")
        self.new_workspace_name.setToolTip("")


    def _set_labels_current_workspace(self, value="", name=None, result=None):
        """ Set the current workspace label with @value """

        if name is None:
            sql = (f"SELECT name FROM cat_workspace "
                   f" WHERE id='{value}'")
            row = tools_db.get_row(sql)
            if not row:
                return
            name = row[0]
        text = f"{name}"
        tools_qt.set_widget_text(self.dlg_workspace_manager, 'lbl_vdefault_workspace', text)
        if result:
            tools_gw.manage_current_selections_docker(result)

    # endregion
