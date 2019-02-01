"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis
    
if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtGui import QLabel
    from PyQt4.QtCore import pyqtSignal
else:
    from qgis.PyQt.QtCore import pyqtSignal
    from qgis.PyQt.QtWidgets import QLabel


class HyperLinkLabel(QLabel):
    clicked = pyqtSignal()

    def __init__(self):
        QLabel.__init__(self)
        self.setStyleSheet("QLabel{color:blue; text-decoration: underline;}")

    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        self.setStyleSheet("QLabel{color:purple; text-decoration: underline;}")
        
        