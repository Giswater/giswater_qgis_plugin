from PyQt4.QtGui import QLabel
 
 
class ExtendedQLabel(QLabel):
    
    def __init(self, parent):
        QLabel.__init__(self, parent)
 
    def mouseReleaseEvent(self, ev):
        self.emit(SIGNAL('clicked()'))
        
