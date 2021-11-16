"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ..utils import tools_gw
from ...lib import tools_qt


class GwCreateSchemaTask(GwTask):
    """ This shows how to subclass QgsTask """

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params):

        super().__init__(description)
        self.admin = admin
        self.params = params


    def run(self):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """

        super().run()
        self.admin.dlg_readsql_create_project.btn_cancel_task.show()
        self.admin.dlg_readsql_create_project.btn_accept.hide()
        self.is_test = self.params['is_test']
        project_type = self.params['project_type']
        exec_last_process = self.params['exec_last_process']
        project_name_schema = self.params['project_name_schema']
        project_locale = self.params['project_locale']
        project_srid = self.params['project_srid']
        example_data = self.params['example_data']

        self.finish_execution = {'import_data': False}
        try:
            # Common execution
            status = self.admin._load_base(project_type=project_type)
            if not status and self.admin.dev_commit is False:
                return False

            self.set_progress(10)
            status = self.admin._update_30to31(new_project=True, project_type=project_type)
            if not status and self.admin.dev_commit is False:
                return False

            self.set_progress(20)
            status = self.admin._load_views(project_type=project_type)
            if not status and self.admin.dev_commit is False:
                return False

            self.set_progress(30)
            status = self.admin._load_trg(project_type=project_type)
            if not status and self.admin.dev_commit is False:
                return False

            self.set_progress(40)
            status = self.admin._update_31to39(new_project=True, project_type=project_type)
            if not status and self.admin.dev_commit is False:
                return False

            self.set_progress(60)

            status = True
            if exec_last_process:
                status = self.admin._execute_last_process(True, project_name_schema, self.admin.schema_type,
                                                          project_locale, project_srid)

            if not status and self.admin.dev_commit is False:
                return False

            # Custom execution
            if self.admin.rdb_import_data.isChecked():
                self.finish_execution['import_data'] = True
                # TODO:
                self.set_progress(90)
                return True
            elif self.admin.rdb_sample.isChecked() and example_data:
                self.set_progress(80)
                tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_sample', prefix=False)
                self.admin._load_sample_data(project_type=project_type)
            elif self.admin.rdb_sample_dev.isChecked():
                self.set_progress(80)
                tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_sample_dev', prefix=False)
                self.admin._load_sample_data(project_type=project_type)
                self.set_progress(90)
                self.admin._load_dev_data(project_type=project_type)
            elif self.admin.rdb_data.isChecked():
                tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_data', prefix=False)

            return True

        except KeyError as e:
            print(f"{type(e).__name__} --> {e}")
            self.exception = e
            return False


    def finished(self, result):

        super().finished(result)
        self.admin.dlg_readsql_create_project.btn_cancel_task.hide()
        self.admin.dlg_readsql_create_project.btn_accept.show()
        if self.isCanceled():
            self.setProgress(100)
            return

        # Handle exception
        if self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)

        if self.finish_execution['import_data']:
            tools_gw.set_config_parser('btn_admin', 'create_schema_type', 'rdb_import_data', prefix=False)
            msg = ("The base schema have been correctly executed."
                   "\nNow will start the import process. It is experimental and it may crash."
                   "\nIf this happens, please notify it by send a e-mail to info@giswater.org.")
            tools_qt.show_info_box(msg, "Info")
            self.admin._execute_import_data(self.params['project_name_schema'], self.params['project_type'])
        else:
            self.admin._manage_process_result(self.params['project_name_schema'], self.params['project_type'],
                                              is_test=self.is_test)
        self.setProgress(100)


    def set_progress(self, value):

        if not self.is_test:
            self.setProgress(value)

