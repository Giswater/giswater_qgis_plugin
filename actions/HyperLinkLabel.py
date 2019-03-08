"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QLabel
from qgis.PyQt.QtCore import pyqtSignal


class HyperLinkLabel(QLabel):
    clicked = pyqtSignal()

    def __init__(self):
        QLabel.__init__(self)
        self.setStyleSheet("QLabel{color:blue; text-decoration: underline;}")

    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        self.setStyleSheet("QLabel{color:purple; text-decoration: underline;}")
        
        