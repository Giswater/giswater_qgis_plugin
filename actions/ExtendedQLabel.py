"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
from qgis.PyQt.QtWidgets import QLabel
from qgis.PyQt.QtCore import pyqtSignal
 
 
class ExtendedQLabel(QLabel):
    clicked = pyqtSignal()
    
    def __init(self, parent):
        QLabel.__init__(self, parent)
 
    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        
