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
from ...lib import tools_qt
from ... import global_vars


class GwCopySchemaTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, admin, description, params, timer=None):

        super().__init__(description)
        self.admin = admin
        self.params = params
        self.dict_folders_process = {}
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.status = False
        self.timer = timer

        # Manage buttons & other dlg-related widgets
        self.admin.dlg_readsql_copy.schema_rename_copy.setEnabled(False)
        # Disable dlg_readsql_copy buttons
        self.admin.dlg_readsql_copy.btn_accept.hide()
        self.admin.dlg_readsql_copy.btn_cancel.setEnabled(False)
        try:
            self.admin.dlg_readsql_copy.key_escape.disconnect()
        except TypeError:
            pass

        # Disable red 'X' from dlg_readsql_copy
        self.admin.dlg_readsql_copy.setWindowFlag(Qt.WindowCloseButtonHint, False)
        self.admin.dlg_readsql_copy.show()


    def run(self):

        super().run()

        schema = self.params.get('schema')
        new_schema_name = tools_qt.get_text(self.admin.dlg_readsql_copy, self.admin.dlg_readsql_copy.schema_rename_copy)
        self.new_schema_name = new_schema_name

        extras = f'"parameters":{{"source_schema":"{schema}", "dest_schema":"{new_schema_name}"}}'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_admin_schema_clone', body, schema, commit=False,
                                            is_thread=True, aux_conn=self.aux_conn)
        if not result or result['status'] == 'Failed':
            return False

        # Show message
        status = (self.admin.error_count == 0)
        if status:
            global_vars.dao.commit(aux_conn=self.aux_conn)
        else:
            global_vars.dao.rollback(aux_conn=self.aux_conn)

        # Reset count error variable to 0
        self.admin.error_count = 0
        self.status = status
        return status


    def finished(self, result):

        super().finished(result)
        # Enable dlg_readsql_show_info buttons
        self.admin.dlg_readsql_copy.btn_cancel.setEnabled(True)
        # Enable red 'X' from dlg_readsql_show_info
        self.admin.dlg_readsql_copy.setWindowFlag(Qt.WindowCloseButtonHint, True)
        self.admin.dlg_readsql_copy.show()

        if self.timer:
            self.timer.stop()

        if self.status:
            self.admin._populate_data_schema_name(self.admin.cmb_project_type)
            tools_qt.set_widget_text(self.admin.dlg_readsql, self.admin.dlg_readsql.project_schema_name, str(self.new_schema_name))
            # Set info project
            self.admin._set_info_project()
            self.admin._close_dialog_admin(self.admin.dlg_readsql_copy)

        # Reset count error variable to 0
        self.admin.error_count = 0

        self.setProgress(100)
