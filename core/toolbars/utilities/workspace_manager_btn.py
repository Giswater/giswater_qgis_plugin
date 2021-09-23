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

from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtWidgets import QTableView
from qgis.PyQt.QtWidgets import QDialog, QLabel, QLineEdit, QPlainTextEdit

from ..dialog import GwAction
from ...ui.ui_manager import GwWorkspaceManagerUi, GwCreateWorkspaceUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db


class GwWorkspaceManagerButton(GwAction):
    """ Button 100: Workspace manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_workspace_manager()


    # region private functions

    def _open_workspace_manager(self):
        # Main dialog
        self.dlg_workspace_manager = GwWorkspaceManagerUi()
        tools_gw.load_settings(self.dlg_workspace_manager)

        self.filter_name = self.dlg_workspace_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Create workspace dialog
        self.dlg_create_workspace = GwCreateWorkspaceUi()
        self.new_workspace_name = self.dlg_create_workspace.findChild(QLineEdit, 'txt_workspace_name')
        self.new_workspace_descript = self.dlg_create_workspace.findChild(QPlainTextEdit, 'txt_workspace_descript')

        # Connect create workspace dialog signals
        self.dlg_create_workspace.btn_accept.clicked.connect(partial(self._create_workspace))
        self.dlg_create_workspace.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_workspace))

        # Fill table
        self.tbl_wrkspcm = self.dlg_workspace_manager.findChild(QTableView, 'tbl_wrkspcm')
        self._fill_tbl()

        # Connect main dialog signals
        self.dlg_workspace_manager.txt_name.textChanged.connect(partial(self._update_tbl))
        self.dlg_workspace_manager.btn_create.clicked.connect(partial(tools_gw.open_dialog, self.dlg_create_workspace))
        self.dlg_workspace_manager.btn_current.clicked.connect(partial(self._set_current_workspace))
        self.dlg_workspace_manager.btn_reset.clicked.connect(partial(self._reset_workspace))
        self.dlg_workspace_manager.btn_delete.clicked.connect(partial(self._delete_workspace))

        self.dlg_workspace_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_workspace_manager))
        self.dlg_workspace_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_workspace_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_workspace_manager)


    def _get_list(self, table_name='v_ui_workspace', filter_name=""):
        """ Mount and execute the query for gw_fct_getlist """

        feature = f'"tableName":"{table_name}"'
        filter_fields = f'"name": {{"filterSign":"ILIKE", "value":"{filter_name}"}}'
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

        complet_list = self._get_list("v_ui_workspace", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue

            self.tbl_wrkspcm = tools_gw.add_tableview_header(self.tbl_wrkspcm, field)
            self.tbl_wrkspcm = tools_gw.fill_tableview_rows(self.tbl_wrkspcm, field)
            # TODO: config_form_tableview
            # widget = tools_gw.set_tablemodel_config(self.dlg_workspace_manager, self.tbl_wrkspcm, 'tbl_wrkspcm', 1, True)
            tools_qt.set_tableview_config(self.tbl_wrkspcm)

        return complet_list


    def _update_tbl(self, filter_name=""):
        """ Update the table with the filter """

        complet_list = self._get_list("v_ui_workspace", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue

            model = self.tbl_wrkspcm.model()
            model.removeRows(0, model.rowCount())

            if field['value'] is None:
                continue
            self.tbl_wrkspcm = tools_gw.fill_tableview_rows(self.tbl_wrkspcm, field)
            tools_qt.set_tableview_config(self.tbl_wrkspcm)

        return complet_list


    def _create_workspace(self):

        name = self.new_workspace_name.text()
        descript = self.new_workspace_descript.toPlainText()
        action = "CREATE"

        extras = f'"action":"{action}", "name":"{name}", "descript":"{descript}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body, log_sql=True)

        if result and result['status'] == "Accepted":
            self._update_tbl(self.filter_name.text())
            tools_gw.close_dialog(self.dlg_create_workspace)


    def _set_current_workspace(self):

        action = "CURRENT"

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        extras = f'"action":"{action}", "id": "{value}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body, log_sql=True)

        self._set_label_current_workspace(value)


    def _reset_workspace(self):

        action = "RESET"

        extras = f'"action":"{action}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body, log_sql=True)

        if result and result['status'] == "Accepted":
            if 'message' in result and result['message']:
                message = result['message']
                tools_qgis.show_message(message['text'], message['level'])
            self._update_tbl(self.filter_name.text())


    def _delete_workspace(self):

        action = "DELETE"

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        # TODO: Check if is current workspace or is used by others

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 1).data())
        if answer:
            extras = f'"action":"{action}", "id": "{value}"'
            body = tools_gw.create_body(extras=extras)
            result = tools_gw.execute_procedure('gw_fct_workspacemanager', body, log_sql=True)

            if result and result['status'] == "Accepted":
                if 'message' in result and result['message']:
                    message = result['message']
                    tools_qgis.show_message(message['text'], message['level'])

            self._update_tbl(self.filter_name.text())


    def _set_label_current_workspace(self, value):

        sql = (f"SELECT name FROM cat_workspace "
               f" WHERE id='{value}'")
        row = tools_db.get_row(sql)
        if not row:
            return
        text = f"Selected workspace: {row[0]}"
        tools_qt.set_widget_text(self.dlg_workspace_manager, 'lbl_vdefault_workspace', text)

    # endregion
