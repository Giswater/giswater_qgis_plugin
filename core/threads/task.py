"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from time import sleep

from qgis.PyQt.QtCore import pyqtSignal, QObject
from qgis.core import QgsTask

from ... import global_vars
from ...lib import tools_log, tools_db


class GwTask(QgsTask, QObject):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, duration=0):

        QObject.__init__(self)
        super().__init__(description, QgsTask.CanCancel)

        self.exception = None
        self.duration = duration


    def run(self):
        global_vars.session_vars['threads'].append(self)
        tools_log.log_info(f"Started task {self.description()}")
        

    def finished(self, result):
        global_vars.session_vars['threads'].remove(self)

        if result:
            tools_log.log_info(f"Task {self.description()} completed")
        else:
            if self.exception is None:
                tools_log.log_info(f"Task {self.description()} not successful but without exception")
            else:
                tools_log.log_info(f"Task {self.description()} Exception: {self.exception}")
                raise self.exception


    def cancel(self):
        pid = global_vars.dao.conn.get_backend_pid()
        if isinstance(pid, int):
            result = tools_db.cancel_pid(pid)
            if result['last_error'] is not None:
                tools_log.log_warning(result['last_error'])
            global_vars.dao.rollback()
        tools_log.log_info(f"Task {self.description()} was cancelled")
        super().cancel()