"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsTask


class TaskConfigLayerFields(QgsTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()
    def __init__(self, description, controller):

        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.controller = controller
        self.error_msg = None
        self.message = None


    def run(self):

        self.controller.log_info(f"Task started: {self.description()}")
        return True


    def finished(self, result):

        if result:
            self.controller.log_info(f"Task finished: {self.description()}")
            return

        if self.error_msg:
            self.controller.log_info(f"Task aborted: {self.description()}")
            self.controller.log_warning(f"Exception description: {self.error_msg}")
            return

        if self.exception:
            self.controller.log_info(f"Task aborted: {self.description()}")
            self.controller.log_warning(f"Exception: {self.exception}")
            raise self.exception


    def cancel(self):

        self.controller.log_info(f"Task cancelled: {self.description()}")
        super().cancel()


    def isCanceled(self):
        pass


    def progress_changed(self, progress):
        self.controller.log_info(f"progressChanged: {progress}")

