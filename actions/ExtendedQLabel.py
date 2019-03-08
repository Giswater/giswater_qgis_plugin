from qgis.PyQt.QtWidgets import QLabel
from qgis.PyQt.QtCore import pyqtSignal
 
 
class ExtendedQLabel(QLabel):
    clicked = pyqtSignal()
    
    def __init(self, parent):
        QLabel.__init__(self, parent)
 
    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        
