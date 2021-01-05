"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDockWidget


class GwDockerDialog(QDockWidget):
    dlg_closed = QtCore.pyqtSignal()


    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag


    def closeEvent(self, event):
        self.dlg_closed.emit()
        return super().closeEvent(event)