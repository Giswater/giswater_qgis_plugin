"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import Qt, pyqtSignal

import glob
import os

from .task import GwTask
from ..utils import tools_gw
from ...libs import tools_qt, tools_log, tools_os, tools_db, tools_qgis


class GwCreateSchemaTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params, timer=None):

        super().__init__(description)
        self.admin = admin
        self.params = params
        self.dict_folders_process = {}
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.timer = timer

        # Manage buttons & other dlg-related widgets
        # Disable dlg_readsql_create_project buttons
        self.admin.dlg_readsql_create_project.btn_cancel_task.show()
        self.admin.dlg_readsql_create_project.btn_accept.hide()
        self.admin.dlg_readsql_create_project.btn_close.setEnabled(False)
        try:
            self.admin.dlg_readsql_create_project.key_escape.disconnect()
        except TypeError:
            pass

        # Disable red 'X' from dlg_readsql_create_project
        self.admin.dlg_readsql_create_project.setWindowFlag(Qt.WindowCloseButtonHint, False)
        self.admin.dlg_readsql_create_project.show()
        # Disable dlg_readsql buttons
        self.admin.dlg_readsql.btn_close.setEnabled(False)


    def run(self):

        super().run()
        self.is_test = self.params['is_test']
        self.finish_execution = {'import_data': False}
        self.dict_folders_process = {}
        self.admin.total_sql_files = 0
        self.admin.current_sql_file = 0
        self.admin.progress_value = 0
        tools_log.log_info(f"Task 'Create schema' execute function 'def main_execution'")
        status = self.main_execution()
        if not tools_os.set_boolean(status, False):
            tools_log.log_info("Function main_execution returned False")
            return False
        tools_log.log_info(f"Task 'Create schema' execute function 'def custom_execution'")
        self.custom_execution()
        return True


    def finished(self, result):

        super().finished(result)
        # Enable dlg_readsql_create_project buttons
        self.admin.dlg_readsql_create_project.btn_cancel_task.hide()
        self.admin.dlg_readsql_create_project.btn_accept.show()
        self.admin.dlg_readsql_create_project.btn_close.setEnabled(True)
        # Enable red 'X' from dlg_readsql_create_project
        self.admin.dlg_readsql_create_project.setWindowFlag(Qt.WindowCloseButtonHint, True)
        self.admin.dlg_readsql_create_project.show()
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

        if self.finish_execution['import_data']:
            tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_inp', prefix=False)
            msg = ("The base schema have been correctly executed."
                   "\nNow will start the import process. It is experimental and it may crash."
                   "\nIf this happens, please notify it by send a e-mail to info@giswater.org.")
            tools_qt.show_info_box(msg, "Info")
            self.admin.execute_import_inp_data(self.params['project_name_schema'], self.params['project_type'])
        else:
            self.admin.manage_process_result(self.params['project_name_schema'], self.params['project_type'],
                                             is_test=self.is_test)
        self.setProgress(100)


    def set_progress(self, value):

        if not self.is_test:
            self.setProgress(value)


    def main_execution(self):
        """ Main common execution """

        project_type = self.params['project_type']
        exec_last_process = self.params['exec_last_process']
        project_name_schema = self.params['project_name_schema']
        project_locale = self.params['project_locale']
        project_srid = self.params['project_srid']

        self.admin.progress_ratio = 0.8
        tools_log.log_info(f"Task 'Create schema' execute function 'def calculate_number_of_files'")
        self.admin.total_sql_files = self.calculate_number_of_files()
        tools_log.log_info(f"Number of SQL files 'TOTAL': {self.admin.total_sql_files}")

        status = self.admin.load_base(self.dict_folders_process['load_base'])
        if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
                or self.isCanceled():
            return False

        status = self.admin.load_locale()
        if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
                or self.isCanceled():
            return False

        status = self.admin.update_dict_folders(True, project_type, dict_update_folders=self.dict_folders_process['update_35to39'])
        if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
                or self.isCanceled():
            return False

        # status = self.admin.load_childviews()
        # if (not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.admin.dev_commit, False) is False) \
        #         or self.isCanceled():
        #     return False

        json_result = None
        if exec_last_process:
            tools_log.log_info("Execute function 'gw_fct_admin_schema_lastprocess'")
            json_result = self.admin.execute_last_process(True, project_name_schema, self.admin.schema_type,
                                                     project_locale, project_srid)
        if (not json_result or json_result['status'] == 'Failed' and tools_os.set_boolean(self.admin.dev_commit, False) is False) or self.isCanceled():
            return False

        return True


    def custom_execution(self):
        """ Custom execution """

        project_type = self.params['project_type']
        example_data = self.params['example_data']

        tools_log.log_info("Execute 'custom_execution'")
        self.admin.current_sql_file = 85
        self.admin.total_sql_files = 100
        self.admin.progress_ratio = 1.0

        if self.admin.rdb_inp.isChecked():
            self.finish_execution['import_data'] = True
        elif self.admin.rdb_sample_inv.isChecked() and example_data:
            tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_sample_full', prefix=False)
            self.admin.load_sample_data(project_type=project_type)
            self.admin.load_inv_data(project_type=project_type)
        elif self.admin.rdb_sample_full.isChecked() and example_data:
            tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_sample_full', prefix=False)
            self.admin.load_sample_data(project_type=project_type)
        elif self.admin.rdb_empty.isChecked():
            tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_empty', prefix=False)


    def calculate_number_of_files(self):
        """ Calculate total number of SQL to execute """

        total_sql_files = 0
        dict_process = {}
        list_process = ['load_base', 'load_locale', 'update_35to39']

        for process_name in list_process:
            #tools_log.log_info(f"Task 'Create schema' execute function 'def get_number_of_files_process' with parameters: '{process_name}'")
            dict_folders, total = self.get_number_of_files_process(process_name)
            total_sql_files += total
            tools_log.log_info(f"Number of SQL files '{process_name}': {total}")
            dict_process[process_name] = total
            self.dict_folders_process[process_name] = dict_folders

        return total_sql_files


    def get_number_of_files_folder_update_minor(self, folder_update_minor):

        project_type = self.params['project_type']
        files_project_type = list(glob.iglob(folder_update_minor + f'**/**/{project_type}/*.sql', recursive=True))
        files_utils = list(glob.iglob(folder_update_minor + '**/**/utils/*.sql', recursive=True))
        files_i18n = list(glob.iglob(folder_update_minor + '**/**/i18n/**/*.sql', recursive=True))
        total = len(files_project_type) + len(files_utils) + len(files_i18n)

        return total


    def get_number_of_files_process(self, process_name: str):
        """ Calculate number of files of all folders of selected @process_name """

        #tools_log.log_info(f"Task 'Create schema' execute function 'def get_folders_process' with parameters: '{process_name}'")
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
            dict_folders[os.path.join(self.admin.folder_utils, self.admin.file_pattern_ddl)] = 0
            dict_folders[os.path.join(self.admin.folder_utils, self.admin.file_pattern_fct)] = 0
            dict_folders[os.path.join(self.admin.folder_utils, self.admin.file_pattern_ftrg)] = 0
            dict_folders[os.path.join(self.admin.folder_software, self.admin.file_pattern_fct)] = 0
            dict_folders[os.path.join(self.admin.folder_software, self.admin.file_pattern_ftrg)] = 0
            dict_folders[os.path.join(self.admin.folder_software, self.admin.file_pattern_schema_model)] = 0

        elif process_name == 'load_locale':
            dict_folders[self.admin.folder_locale] = 0

        elif process_name == 'update_35to39':
            dict_folders[os.path.join(self.admin.folder_updates, '36')] = 0

        return dict_folders

