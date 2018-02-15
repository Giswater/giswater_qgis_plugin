from PyQt4.QtGui import QLabel
from PyQt4.QtGui import *
from PyQt4.QtCore import *
 
class ExtendedQLabel(QLabel):
    clicked = pyqtSignal()
    
    def __init(self, parent):
        QLabel.__init__(self, parent)
 
    def mouseReleaseEvent(self, ev):
        #self.emit(SIGNAL('clicked()'))
        self.clicked.emit()
        
