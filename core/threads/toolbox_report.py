"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDoubleSpinBox, QSpinBox, QWidget, QLineEdit
from qgis.PyQt.QtCore import pyqtSignal
from qgis.gui import QgsDateTimeEdit

from .task import GwTask
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_log, tools_qt, tools_qgis


class GwReportTask(GwTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()
    finished_execute = pyqtSignal(bool, dict)

    def __init__(self, description, dialog, function_selected, queryAdd, timer=None):

        super().__init__(description)
        self.function_selected = function_selected
        self.dialog = dialog
        self.body = None
        self.json_result = None
        self.exception = None
        self.function_name = 'gw_fct_getreport'
        self.queryAdd = queryAdd
        self.timer = timer


    def run(self):

        super().run()

        extras = f'"filterText":null, "listId":"{self.function_selected}"'
        if self.queryAdd:
            extras += f', "queryAdd": "{self.queryAdd}"'
        self.body = tools_gw.create_body(extras=extras)
        self.json_result = tools_gw.execute_procedure('gw_fct_getreport', self.body, is_thread=True, aux_conn=self.aux_conn)
        if not self.json_result or self.json_result['status'] == 'Failed':
            self.finished_execute.emit(False, self.json_result)
            return False
        self.finished_execute.emit(True, self.json_result)

        if self.isCanceled():
            return False
        if self.json_result['status'] == 'Failed':
            return False
        if not self.json_result or self.json_result is None:
            return False

        return True


    def finished(self, result):

        super().finished(result)

        sql = f"SELECT {self.function_name}("
        if self.body:
            sql += f"{self.body}"
        sql += f");"
        tools_log.log_info(f"Task 'Toolbox report' manage json response with parameters: '{self.json_result}', '{sql}', 'None'")
        tools_gw.manage_json_response(self.json_result, sql, None)

        tools_qt.set_widget_enabled(self.dialog, 'btn_export', True)
        tools_qt.set_widget_enabled(self.dialog, 'btn_close', True)
        self.dialog.progressBar.setVisible(False)
        if self.timer:
            self.timer.stop()
        if self.isCanceled():
            return

        if result is False and self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)
        # If database fail
        elif result is False and global_vars.session_vars['last_error_msg'] is not None:
            tools_qt.show_exception_message(msg=global_vars.session_vars['last_error_msg'])
        # If sql function return null
        elif result is False:
            msg = f"Database returned null. Check postgres function 'gw_fct_getinfofromid'"
            tools_log.log_warning(msg)


    def cancel(self):

        if self.timer:
            self.timer.stop()

        super().cancel()
