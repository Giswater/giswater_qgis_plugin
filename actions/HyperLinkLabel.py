
from PyQt4.QtGui import QLabel
from PyQt4.QtCore import pyqtSignal



class HyperLinkLabel(QLabel):
    clicked = pyqtSignal()

    def __init__(self):
        QLabel.__init__(self)
        self.setStyleSheet("QLabel{color:blue; text-decoration: underline;}")

    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        self.setStyleSheet("QLabel{color:purple; text-decoration: underline;}")