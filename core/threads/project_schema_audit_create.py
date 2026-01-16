"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

import os

from .task import GwTask
from ...libs import tools_qt, tools_os, tools_db


class GwCreateSchemaAuditTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, timer=None, list_process=None):

        super().__init__(description)
        self.admin = admin
        self.dict_folders_process = {}
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.timer = timer
        self.list_process = list_process
        # Disable dlg_readsql buttons
        self.admin.dlg_readsql.btn_close.setEnabled(False)

    def run(self):

        super().run()
        self.finish_execution = {'import_data': False}
        self.dict_folders_process = {}
        self.admin.total_sql_files = 0
        self.admin.current_sql_file = 0
        self.admin.progress_value = 0
        status = self.main_execution()
        if not tools_os.set_boolean(status, False):
            return False
        return True

    def finished(self, result):

        super().finished(result)
        # Disable dlg_readsql buttons
        self.admin.dlg_readsql.btn_close.setEnabled(True)

        if self.isCanceled():
            if self.timer:
                self.timer.stop()
            self.setProgress(100)
            # Handle db exception
            if self.db_exception is not None:
                error, sql, filepath = self.db_exception
                tools_qt.manage_exception_db(error, sql, filepath=filepath)
                tools_db.dao.rollback()
            return

        # Handle exception
        if self.exception is not None:
            msg = f'''<b>{tools_qt.tr('key')}: </b>{self.exception}<br>'''
            msg += f'''<b>{tools_qt.tr('key container')}: </b>'body/data/ <br>'''
            msg += f'''<b>{tools_qt.tr('Python file')}: </b>{__name__} <br>'''
            msg += f'''<b>{tools_qt.tr('Python function')}:</b> {self.__class__.__name__} <br>'''
            title = "Key on returned json from ddbb is missed."
            tools_qt.show_exception_message(title, msg)

        if self.timer:
            self.timer.stop()

        self.admin.manage_other_process_result()
        self.setProgress(100)

    def set_progress(self, value):

        self.setProgress(value)

    def main_execution(self):
        """Main common execution"""
        self.admin.progress_ratio = 0.8
        self.admin.total_sql_files = self.calculate_number_of_files()
        for process in self.list_process:
            status = self.admin.load_sql_folder(self.dict_folders_process[process])
            if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
                    or self.isCanceled():
                return False
        return True

    def calculate_number_of_files(self):
        """Calculate total number of SQL to execute"""
        total_sql_files = 0
        dict_process = {}

        for process_name in self.list_process:
            dict_folders, total = self.get_number_of_files_process(process_name)
            total_sql_files += total
            dict_process[process_name] = total
            self.dict_folders_process[process_name] = dict_folders

        return total_sql_files

    def get_number_of_files_process(self, process_name: str):
        """Calculate number of files of all folders of selected @process_name"""
        dict_folders = self.get_folders_process(process_name)
        if dict_folders is None:
            return dict_folders, 0

        number_of_files = 0
        for folder in dict_folders.keys():
            file_count = sum(len(files) for _, _, files in os.walk(folder))
            number_of_files += file_count
            dict_folders[folder] = file_count

        return dict_folders, number_of_files

    def get_folders_process(self, process_name):
        """Get list of folders related with this @process_name"""
        dict_folders = {}
        if process_name == 'load_audit_structure':
            dict_folders[self.admin.folder_audit_structure] = 0

        elif process_name == 'load_audit_activation':
            dict_folders[self.admin.folder_audit_activate] = 0

        return dict_folders

