"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import Qt, pyqtSignal

from .task import GwTask
from ..utils import tools_gw
from ...lib import tools_qt, tools_log, tools_db


class GwUpdateSchemaTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params, timer=None):

        super().__init__(description)
        self.admin = admin
        self.params = params
        self.dict_folders_process = {}
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.timer = timer

        # Manage buttons & other dlg-related widgets
        # Disable dlg_readsql_show_info buttons
        self.admin.dlg_readsql_show_info.btn_update.hide()
        self.admin.dlg_readsql_show_info.btn_close.setEnabled(False)
        try:
            self.admin.dlg_readsql_show_info.key_escape.disconnect()
        except TypeError:
            pass

        # Disable red 'X' from dlg_readsql_create_project
        self.admin.dlg_readsql_show_info.setWindowFlag(Qt.WindowCloseButtonHint, False)
        self.admin.dlg_readsql_show_info.show()


    def run(self):

        super().run()
        self.dict_folders_process = {}
        self.admin.total_sql_files = 0
        self.admin.current_sql_file = 0
        self.admin.progress_value = 0
        tools_log.log_info(f"Task 'Update schema' execute function 'def main_execution'")
        status = self.main_execution()
        if not status:
            tools_log.log_info("Function main_execution returned False")
            return False
        return True


    def finished(self, result):

        super().finished(result)
        # Enable dlg_readsql_show_info buttons
        self.admin.dlg_readsql_show_info.btn_close.setEnabled(True)
        # Enable red 'X' from dlg_readsql_show_info
        self.admin.dlg_readsql_show_info.setWindowFlag(Qt.WindowCloseButtonHint, True)
        self.admin.dlg_readsql_show_info.show()

        if self.timer:
            self.timer.stop()

        if self.status:
            # Show message
            status = (self.admin.error_count == 0)
            self.admin._manage_result_message(status, parameter="Update project")
            # Set info project
            self.admin._set_info_project()
            if 'body' in self.status:
                tools_gw.fill_tab_log(self.admin.dlg_readsql_show_info, self.status['body']['data'], True, True, 1)
            else:
                tools_log.log_warning(f"Key not found: 'body'")

        # Reset count error variable to 0
        self.admin.error_count = 0

        if self.isCanceled():
            self.setProgress(100)
            # Handle db exception
            if self.db_exception is not None:
                error, sql, filepath = self.db_exception
                tools_qt.manage_exception_db(error, sql, filepath=filepath)
            return

        # Handle exception
        if self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)

        self.setProgress(100)


    def main_execution(self):
        schema_name = self.admin._get_schema_name()
        sql = f"DELETE FROM {schema_name}.audit_check_data WHERE fid = 133 AND cur_user = current_user;"
        tools_db.execute_sql(sql)
        self.status = self.admin.load_updates(self.params['project_type'], update_changelog=True, schema_name=schema_name)
        return True
