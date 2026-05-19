"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt, pyqtSignal

from .task import GwTask
from ..utils import tools_gw
from ...libs import tools_qt, tools_log, tools_db

# Avoid circular import by using TYPE_CHECKING and runtime import
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..admin.admin_btn import GwAdminButton


class GwUpdateSchemaTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params, timer=None):

        super().__init__(description)
        self.admin: GwAdminButton = admin
        self.params = params
        self.dict_folders_process = {}
        self.db_exception = None
        self.result = None
        self.timer = timer

        # Manage buttons & other dlg-related widgets
        self.admin.dlg_readsql_show_info.btn_update.hide()
        self._btn_close_text = self.admin.dlg_readsql_show_info.btn_close.text()
        try:
            self.admin.dlg_readsql_show_info.btn_close.clicked.disconnect()
        except TypeError:
            pass
        self.admin.dlg_readsql_show_info.btn_close.setEnabled(True)
        self.admin.dlg_readsql_show_info.btn_close.setText(tools_qt.tr("Cancel"))
        self.admin.dlg_readsql_show_info.btn_close.clicked.connect(
            partial(self.admin.cancel_task, 'task_update_schema'))
        try:
            self.admin.dlg_readsql_show_info.key_escape.disconnect()
        except TypeError:
            pass

        # Disable red 'X' from dlg_readsql_show_info
        self.admin.dlg_readsql_show_info.setWindowFlag(Qt.WindowType.WindowCloseButtonHint, False)
        self.admin.dlg_readsql_show_info.show()

    def run(self):

        super().run()
        self.dict_folders_process = {}
        self.admin.current_sql_file = 0
        self.admin.progress_value = 0
        self.admin.progress_ratio = 0.8
        self.admin.total_sql_files = self.admin.count_load_updates_sql_files(self.params['project_type'])
        msg = "Number of SQL files 'TOTAL': {0}"
        msg_params = (self.admin.total_sql_files,)
        tools_log.log_info(msg, msg_params=msg_params)
        msg = "Task '{0}' execute function '{1}'"
        msg_params = ("Update schema", "main_execution",)
        tools_log.log_info(msg, msg_params=msg_params)
        status = self.main_execution()
        if not status:
            msg = "Function '{0}' returned False"
            msg_params = ("main_execution",)
            tools_log.log_info(msg, msg_params=msg_params)
            return False
        return True

    def finished(self, result):

        super().finished(result)
        try:
            if self.isCanceled():
                tools_db.dao.rollback(aux_conn=self.aux_conn)
                self._show_infolog()
                if self.db_exception and self.db_exception[0]:
                    error, sql, filepath = self.db_exception
                    tools_qt.manage_exception_db(error, sql, filepath=filepath)
                return

            if self.exception is not None:
                tools_db.dao.rollback(aux_conn=self.aux_conn)
                msg = f'''<b>{tools_qt.tr('key')}: </b>{self.exception}<br>'''
                msg += f'''<b>{tools_qt.tr('key container')}: </b>'body/data/ <br>'''
                msg += f'''<b>{tools_qt.tr('Python file')}: </b>{__name__} <br>'''
                msg += f'''<b>{tools_qt.tr('Python function')}:</b> {self.__class__.__name__} <br>'''
                title = "Key on returned json from ddbb is missed."
                tools_qt.show_exception_message(title, msg)
                self._show_infolog()
                return

            status = (
                self.admin.error_count == 0
                and self.result not in (False, None)
            )
            if status:
                tools_db.dao.commit(aux_conn=self.aux_conn)
            else:
                tools_db.dao.rollback(aux_conn=self.aux_conn)

            self.admin._manage_result_message(status, parameter="Update project")
            if status:
                self.admin._set_info_project()
            self._show_infolog()

            if status and isinstance(self.result, dict) and 'body' in self.result:
                tools_gw.fill_tab_log(
                    self.admin.dlg_readsql_show_info, self.result['body']['data'], True, True, 1)
            elif status:
                msg = "Key not found: '{0}'"
                msg_params = ("body",)
                tools_log.log_warning(msg, msg_params=msg_params)
        finally:
            self._restore_dialog()
            if self.timer:
                self.timer.stop()
            self.admin.error_count = 0
            self.setProgress(100)

    def set_progress(self, value) -> None:

        self.setProgress(value)

    def _show_infolog(self):

        if hasattr(self.admin, 'infolog_updates') and self.admin.infolog_updates:
            self.admin.infolog_updates.setText(self.admin.message_infolog)

    def _restore_dialog(self):

        dlg = self.admin.dlg_readsql_show_info
        dlg.btn_close.setEnabled(True)
        dlg.setWindowFlag(Qt.WindowType.WindowCloseButtonHint, True)
        try:
            dlg.btn_close.clicked.disconnect()
        except TypeError:
            pass
        dlg.btn_close.clicked.connect(partial(self.admin._close_dialog_admin, dlg))
        dlg.btn_close.setText(self._btn_close_text)
        dlg.btn_update.show()
        dlg.show()

    def main_execution(self):
        """ Main common execution """

        schema_name = self.admin._get_schema_name()
        sql = f"DELETE FROM {schema_name}.audit_check_data WHERE fid = 133 AND cur_user = current_user;"
        tools_db.execute_sql(sql, commit=False, is_thread=True, aux_conn=self.aux_conn)
        # Get all updates folders, to update
        self.dict_folders_process['updates'] = self.admin.folder_updates
        self.result = self.admin.load_updates(
            self.params['project_type'],
            update_changelog=True,
            schema_name=schema_name,
            progress_task=self,
            aux_conn=self.aux_conn,
        )
        return self.result is not False and self.result is not None
