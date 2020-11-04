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


class GwTask(QgsTask, QObject):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, duration=0, controller=None):

        QObject.__init__(self)
        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.duration = duration
        self.controller = controller


    def run(self):

        self.manage_message(f"Started task {self.description()}")

        if self.duration is 0:
            if self.isCanceled():
                return False
            if self.progress() >= 100:
                return True
            return True
        else:
            wait_time = self.duration / 100
            sleep(wait_time)
            for i in range(100):
                sleep(wait_time)
                self.setProgress(i)
                if self.isCanceled():
                    return False

            return True


    def finished(self, result):

        if result:
            self.manage_message(f"Task {self.description()} completed")
        else:
            if self.exception is None:
                self.manage_message(f"Task {self.description()} not successful but without exception")
            else:
                self.manage_message(f"Task {self.description()} Exception: {self.exception}")
                raise self.exception


    def cancel(self):

        self.manage_message(f"Task {self.description()} was cancelled")
        super().cancel()


    def manage_message(self, msg):

        if self.controller:
            self.controller.log_info(msg)

