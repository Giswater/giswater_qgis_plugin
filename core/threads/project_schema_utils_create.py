"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ...lib import tools_qt, tools_db, tools_log


class GwCreateSchemaUtilsTask(GwTask):
    """ This shows how to subclass QgsTask """

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params):

        super().__init__(description)
        self.admin = admin
        self.params = params



    def run(self):
        """"""

        super().run()
        self.is_test = self.params['is_test']
        schema_version = self.params['schema_version']

        self.finish_execution = {'import_data': False}
        try:
            # Common execution
            status = self.admin._load_base_utils()
            if not status and self.admin.dev_commit is False:
                return False
            status = self.admin._update_utils_schema(schema_version)
            if not status and self.admin.dev_commit is False:
                return False

            # After create schema utils:
            # execute gw_fct_admin_schema_utils_fk for mains schema
            sql = f"SELECT {self.params['schema_ws']}.gw_fct_admin_schema_utils_fk();"
            tools_log.log_info(f"Task 'Create schema' execute sql: '{sql}'")
            tools_db.execute_sql(sql)
            tools_log.log_info(f"Task 'Create schema' execute sql: '{sql}'")
            sql = f"SELECT {self.params['schema_ud']}.gw_fct_admin_schema_utils_fk();"
            tools_db.execute_sql(sql)

            # Insert into config_param_system utils schema version
            sql = f"INSERT INTO utils.config_param_system (id, parameter, value, data_type, descript)" \
                  f" VALUES (10, 'utils_version', '{self.params['main_project_version']}', 'text', 'UTILS')"
            tools_log.log_info(f"Task 'Create schema' execute sql: '{sql}'")
            tools_db.execute_sql(sql)

            return True

        except KeyError as e:
            print(f"{type(e).__name__} --> {e}")
            self.exception = e
            return False


    def finished(self, result):

        super().finished(result)
        self.setProgress(100)
        if self.isCanceled():
            return

        # Handle exception
        if self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)

        self.admin.manage_process_result(self.params['project_name_schema'], self.params['project_type'], is_utils=True)

