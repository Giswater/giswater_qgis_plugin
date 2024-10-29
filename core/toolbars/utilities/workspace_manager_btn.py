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
from qgis.PyQt.QtCore import QRegExp, QItemSelectionModel
from qgis.PyQt.QtWidgets import QDialog, QLabel, QLineEdit, QPlainTextEdit, QCheckBox, QAbstractItemView, QTableView, QApplication

from ..dialog import GwAction
from ...ui.ui_manager import GwWorkspaceManagerUi, GwCreateWorkspaceUi, GwGo2EpaOptionsUi
from ...utils import tools_gw
from .... import global_vars
from ....libs import tools_qgis, tools_qt, tools_db


class GwWorkspaceManagerButton(GwAction):
    """ Button 214: Workspace manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_workspace_manager()


    # region private functions

    def _open_workspace_manager(self):
        """ Open workspace manager """

        # Main dialog
        self.dlg_workspace_manager = GwWorkspaceManagerUi(self)
        tools_gw.load_settings(self.dlg_workspace_manager)

        self.filter_name = self.dlg_workspace_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Fill table
        self.tbl_wrkspcm = self.dlg_workspace_manager.findChild(QTableView, 'tbl_wrkspcm')
        self._fill_tbl()
        self._set_labels_current_workspace(dialog=self.dlg_workspace_manager, from_open_dialog=True)

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_workspace_manager)

        # Connect main dialog signals
        self.dlg_workspace_manager.txt_name.textChanged.connect(partial(self._fill_tbl))
        self.dlg_workspace_manager.btn_create.clicked.connect(partial(self._open_create_workspace_dlg))
        self.dlg_workspace_manager.btn_current.clicked.connect(partial(self._set_current_workspace))
        self.dlg_workspace_manager.btn_toggle_privacy.clicked.connect(partial(self._toggle_privacy_workspace))
        self.dlg_workspace_manager.btn_update.clicked.connect(partial(self._open_update_workspace_dlg))
        selection_model = self.dlg_workspace_manager.tbl_wrkspcm.selectionModel()
        selection_model.selectionChanged.connect(partial(self._fill_info))
        self.dlg_workspace_manager.btn_delete.clicked.connect(partial(self._delete_workspace))

        self.dlg_workspace_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_workspace_manager))
        self.dlg_workspace_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_workspace_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_workspace_manager, 'workspace_manager')


    def _open_update_workspace_dlg(self):

        # Create workspace dialog
        self.dlg_create_workspace = GwCreateWorkspaceUi(self)
        self.new_workspace_name = self.dlg_create_workspace.findChild(QLineEdit, 'txt_workspace_name')
        self.new_workspace_descript = self.dlg_create_workspace.findChild(QPlainTextEdit, 'txt_workspace_descript')
        self.new_workspace_chk = self.dlg_create_workspace.findChild(QCheckBox, 'chk_workspace_private')

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_create_workspace)

        # Connect create workspace dialog signals
        self.dlg_create_workspace.btn_accept.clicked.connect(partial(self._update_workspace))
        self.dlg_create_workspace.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_workspace))

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_workspace_manager)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        sql = (f"SELECT name, descript, private FROM cat_workspace WHERE id = {value}")
        row = tools_db.get_row(sql)

        tools_qt.set_widget_text(self.dlg_create_workspace, self.new_workspace_name, row['name'])
        tools_qt.set_widget_text(self.dlg_create_workspace, self.new_workspace_descript, row['descript'])
        tools_qt.set_checked(self.dlg_create_workspace, self.new_workspace_chk, row['private'])

        # Open the dialog
        tools_gw.open_dialog(self.dlg_create_workspace, 'workspace_create', stay_on_top=True)


    def _open_create_workspace_dlg(self):

        # Create workspace dialog
        self.dlg_create_workspace = GwCreateWorkspaceUi(self)
        self.new_workspace_name = self.dlg_create_workspace.findChild(QLineEdit, 'txt_workspace_name')
        self.new_workspace_descript = self.dlg_create_workspace.findChild(QPlainTextEdit, 'txt_workspace_descript')
        self.new_workspace_chk = self.dlg_create_workspace.findChild(QCheckBox, 'chk_workspace_private')

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_create_workspace)

        # Connect create workspace dialog signals
        self.new_workspace_name.textChanged.connect(partial(self._check_exists))
        self.dlg_create_workspace.btn_accept.clicked.connect(partial(self._create_workspace))
        self.dlg_create_workspace.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_workspace))

        # Open the dialog
        tools_gw.open_dialog(self.dlg_create_workspace, 'workspace_create', stay_on_top=True)


    def _get_list(self, table_name='v_ui_workspace', filter_name=""):
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

        complet_list = self._get_list("v_ui_workspace", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if field.get('hidden'): continue
            model = self.tbl_wrkspcm.model()
            if model is None:
                model = QStandardItemModel()
                self.tbl_wrkspcm.setModel(model)
            model.removeRows(0, model.rowCount())

            if field['value']:
                self.tbl_wrkspcm = tools_gw.add_tableview_header(self.tbl_wrkspcm, field)
                self.tbl_wrkspcm = tools_gw.fill_tableview_rows(self.tbl_wrkspcm, field)
            # TODO: config_form_tableview
            # widget = tools_gw.set_tablemodel_config(self.dlg_workspace_manager, self.tbl_wrkspcm, 'tbl_wrkspcm', 1, True)
            tools_qt.set_tableview_config(self.tbl_wrkspcm, selectionMode=QAbstractItemView.SingleSelection)

        return complet_list


    def _fill_info(self, selected, deselected):
        """
        Fill info text area with details from selected workspace.

        Note: The parameters come from the selectionChanged signal.
        """

        # Get id of selected workspace
        cols = selected.indexes()
        if not cols:
            if deselected.indexes():
                self.dlg_workspace_manager.tbl_wrkspcm.selectionModel().select(deselected, QItemSelectionModel.Select)
                return
            tools_qt.set_widget_text(self.dlg_workspace_manager, 'txt_infolog', "")
            return
        col_ind = tools_qt.get_col_index_by_col_name(self.dlg_workspace_manager.tbl_wrkspcm, 'id')
        workspace_id = json.loads(cols[col_ind].data())

        action = "INFO"
        extras = f'"action":"{action}", "id":"{workspace_id}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body)

        if result and result['status'] == "Accepted":
            tools_gw.fill_tab_log(self.dlg_workspace_manager, result['body']['data'],
                                  force_tab=False, call_set_tabs_enabled=False, close=False)


    def _create_workspace(self):
        """ Create a workspace """

        name = self.new_workspace_name.text()
        descript = self.new_workspace_descript.toPlainText()
        if descript == '':
            descript = 'null'
        else:
            descript = f'"{descript}"'
            descript = descript.replace("\n", "\\n")
        if len(name) == 0:
            tools_qt.set_stylesheet(self.new_workspace_name)
            return
        private = self.new_workspace_chk.isChecked()
        action = "CREATE"

        extras = f'"action":"{action}", "name":"{name}", "descript":{descript}, "private":"{private}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body)

        if result and result['status'] == "Accepted":
            tools_gw.fill_tab_log(self.dlg_create_workspace, result['body']['data'])
            self._fill_tbl(self.filter_name.text())
            self._set_labels_current_workspace(dialog=self.dlg_workspace_manager, from_open_dialog=True)

    def _set_labels_current_workspace(self, dialog, from_open_dialog=False, result=None):
        """Set label for the current workspace."""
        print("entro1")
        if from_open_dialog:
            print("entro2")
            # Prepare the JSON body to get the current workspace information
            extras = '"type": "workspace"'
            body = tools_gw.create_body(extras=extras)

            # Execute the stored procedure to retrieve the current workspace information
            result = tools_gw.execute_procedure("gw_fct_set_current", body)

            # Check if the stored procedure returned a successful status
            if result.get("status") != "Accepted":
                print("Failed to retrieve current workspace name")
                return

        try:
            name_value = result["body"]["data"]["name"]
            tools_qt.set_widget_text(dialog, 'lbl_vdefault_workspace', name_value)
        except KeyError:
            print("Error: 'name' field is missing in the result")


    def _set_current_workspace(self):
        """ Set the selected workspace as the current one """
        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "No record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_workspace_manager)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        workspace_id = index.sibling(index.row(), 0).data()

        # Prepare the JSON body for `gw_fct_set_current`
        extras = f'"type": "workspace", "id": "{workspace_id}"'
        body = tools_gw.create_body(extras=extras)

        # Execute the stored procedure
        result = tools_gw.execute_procedure("gw_fct_set_current", body)

        # Check if the stored procedure returned a successful status
        if result.get("status") == "Accepted":
            # Update label
            self._set_labels_current_workspace(self.dlg_workspace_manager, result=result)
        else:
            # If the procedure fails, show a warning
            tools_qgis.show_warning("Failed to set workspace", dialog=self.dlg_workspace_manager)

        # Re-open the dialog
        tools_gw.open_dialog(self.dlg_workspace_manager, 'workspace_manager')


    def _check_goe2pa_options(self, tab_name=None):
        """ Refreshes the selectors' UI if it's open """

        # Get the selector UI if it's open
        windows = [x for x in QApplication.allWidgets() if getattr(x, "isVisible", False)
                and (issubclass(type(x), GwGo2EpaOptionsUi))]
        if windows:
            try:
                dialog = windows[0]
                go2epa = dialog.property('GwGo2EpaButton')
                go2epa._refresh_go2epa_options(go2epa.dlg_go2epa_options)
            except Exception:
                pass


    def _toggle_privacy_workspace(self):
        """ Set the selected workspace as public/private """

        action = "TOGGLE"

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_workspace_manager)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        extras = f'"action":"{action}", "id": "{value}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_workspacemanager', body)

        if result and result['status'] == "Accepted":
            message = result.get('message')
            if message:
                tools_qgis.show_message(message['text'], message['level'], dialog=self.dlg_workspace_manager)
            self._fill_tbl(self.filter_name.text())


    def _update_workspace(self):
        """ Reset the values of the selected workspace """

        action = "UPDATE"

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_workspace_manager)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        name = self.new_workspace_name.text()
        descript = self.new_workspace_descript.toPlainText()
        if descript == '':
            descript = 'null'
        else:
            descript = f'"{descript}"'
            descript = descript.replace("\n", "\\n")
        if len(name) == 0:
            tools_qt.set_stylesheet(self.new_workspace_name)
            return
        private = self.new_workspace_chk.isChecked()

        message = "Are you sure you want to override the configuration of this workspace?"
        answer = tools_qt.show_question(message, "Update configuration", index.sibling(index.row(), 1).data())
        if answer:
            extras = f'"action":"{action}", "name":"{name}", "descript":{descript}, "private":"{private}", "id": "{value}"'
            body = tools_gw.create_body(extras=extras)
            result = tools_gw.execute_procedure('gw_fct_workspacemanager', body)

            if result and result['status'] == "Accepted":
                message = result.get('message')
                if message:
                    tools_qgis.show_message(message['text'], message['level'], dialog=self.dlg_workspace_manager)

                tools_gw.fill_tab_log(self.dlg_create_workspace, result['body']['data'])
                self._fill_tbl(self.filter_name.text())
                self._set_labels_current_workspace(dialog=self.dlg_workspace_manager, from_open_dialog=True)


    def _delete_workspace(self):
        """ Delete the selected workspace """

        action = "DELETE"

        # Get selected row
        selected_list = self.tbl_wrkspcm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_workspace_manager)
            return

        # Get selected workspace id
        index = self.tbl_wrkspcm.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        message = "Are you sure you want to delete these records?"
        sql = f"SELECT value FROM config_param_user WHERE parameter='utils_workspace_vdefault' AND cur_user = current_user"
        row = tools_db.get_row(sql)
        if row and row[0]:
            if row[0] == f'{value}':
                message = f"WARNING: This will remove the 'utils_workspace_vdefault' variable for your user!\n{message}"

        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 1).data())
        if answer:
            extras = f'"action":"{action}", "id": "{value}"'
            body = tools_gw.create_body(extras=extras)
            result = tools_gw.execute_procedure('gw_fct_workspacemanager', body)

            if result and result['status'] == "Accepted":
                message = result.get('message')
                if message:
                    tools_qgis.show_message(message['text'], message['level'], dialog=self.dlg_workspace_manager)

            self._fill_tbl(self.filter_name.text())
            self._set_labels_current_workspace(dialog=self.dlg_workspace_manager, from_open_dialog=True)


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

    # endregion
