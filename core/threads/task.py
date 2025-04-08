"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal, QObject
from qgis.core import QgsTask
from qgis.utils import iface

from ...libs import lib_vars, tools_log, tools_db


class GwTask(QgsTask, QObject):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, duration=0):

        QObject.__init__(self)
        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.duration = duration
        self.aux_conn = None

    def run(self) -> bool:

        lib_vars.session_vars['threads'].append(self)
        self.aux_conn = tools_db.dao.get_aux_conn()
        tools_log.log_info(f"Started task {self.description()}")
        iface.actionOpenProject().setEnabled(False)
        iface.actionNewProject().setEnabled(False)
        return True

    def finished(self, result):

        try:
            lib_vars.session_vars['threads'].remove(self)
        except ValueError:
            pass
        tools_db.dao.delete_aux_con(self.aux_conn)
        iface.actionOpenProject().setEnabled(True)
        iface.actionNewProject().setEnabled(True)
        if result:
            tools_log.log_info(f"Task '{self.description()}' completed")
        else:
            if self.exception is None:
                tools_log.log_info(f"Task '{self.description()}' not successful but without exception")
            else:
                tools_log.log_info(f"Task '{self.description()}' Exception: {self.exception}")

    def cancel(self):

        pid = self.aux_conn.get_backend_pid()
        if isinstance(pid, int):
            result = tools_db.cancel_pid(pid)
            if result['last_error'] is not None:
                tools_log.log_warning(result['last_error'])
            tools_db.dao.rollback(self.aux_conn)
        tools_log.log_info(f"Task '{self.description()}' was cancelled")
        super().cancel()