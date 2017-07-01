from PyQt4.QtGui import *
from PyQt4.QtCore import *
 
class ExtendedQLabel(QLabel):
    
    def __init(self, parent):
        QLabel.__init__(self, parent)
        
        #self.setScaledContents(True)
 
    def mouseReleaseEvent(self, ev):
        self.emit(SIGNAL('clicked()'))
        
    '''
    clicked = Signal()
 
    def mouseReleaseEvent(self, e):
        QLabel.mouseReleaseEvent(self, e)
        self.clicked.emit() 
    '''