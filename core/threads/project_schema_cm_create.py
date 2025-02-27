"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ...libs import tools_qt, tools_db, tools_log


class GwCreateSchemaCmTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, timer=None):

        super().__init__(description)
        self.admin = admin
        self.dict_folders_process = {}
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.timer = timer

        # Manage buttons & other dlg-related widgets
        # Disable dlg_readsql_create_asset_project buttons
        self.admin.dlg_readsql_create_asset_project.btn_cancel_task.show()
        self.admin.dlg_readsql_create_asset_project.btn_accept.hide()
        self.admin.dlg_readsql_create_asset_project.btn_close.setEnabled(False)
        try:
            self.admin.dlg_readsql_create_asset_project.key_escape.disconnect()
        except TypeError:
            pass

        # Disable red 'X' from dlg_readsql_create_asset_project
        self.admin.dlg_readsql_create_asset_project.setWindowFlag(Qt.WindowCloseButtonHint, False)
        self.admin.dlg_readsql_create_asset_project.show()
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
        # Enable dlg_readsql_create_asset_project buttons
        self.admin.dlg_readsql_create_asset_project.btn_cancel_task.hide()
        self.admin.dlg_readsql_create_asset_project.btn_accept.show()
        self.admin.dlg_readsql_create_asset_project.btn_close.setEnabled(True)
        # Enable red 'X' from dlg_readsql_create_asset_project
        self.admin.dlg_readsql_create_asset_project.setWindowFlag(Qt.WindowCloseButtonHint, True)
        self.admin.dlg_readsql_create_asset_project.show()
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
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)

        if self.timer:
            self.timer.stop()

        self.admin.manage_asset_process_result()
        self.setProgress(100)


    def set_progress(self, value):

        self.setProgress(value)


    def main_execution(self):
        """ Main common execution """

        self.admin.progress_ratio = 0.8
        self.admin.total_sql_files = self.calculate_number_of_files()
        for process in ['load_base', 'load_i18n', 'load_updates']:
            status = self.admin.load_asset_folder(self.dict_folders_process[process])
            if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
                    or self.isCanceled():
                return False
        return True


    def calculate_number_of_files(self):
        """ Calculate total number of SQL to execute """

        total_sql_files = 0
        dict_process = {}
        list_process = ['load_base', 'load_i18n', 'load_updates']

        for process_name in list_process:
            dict_folders, total = self.get_number_of_files_process(process_name)
            total_sql_files += total
            dict_process[process_name] = total
            self.dict_folders_process[process_name] = dict_folders

        return total_sql_files


    def get_number_of_files_process(self, process_name: str):
        """ Calculate number of files of all folders of selected @process_name """

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
        """ Get list of folders related with this @process_name """

        dict_folders = {}
        if process_name == 'load_base':
            dict_folders[self.admin.folder_base] = 0

        elif process_name == 'load_i18n':
            dict_folders[self.admin.folder_i18n] = 0

        elif process_name == 'load_updates':
            dict_folders[os.path.join(self.admin.folder_asset_updates, '2023-05')] = 0
            dict_folders[os.path.join(self.admin.folder_asset_updates, '2024-01')] = 0
            dict_folders[os.path.join(self.admin.folder_asset_updates, '2024-01','i18n')] = 0

        return dict_folders

