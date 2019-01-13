from PyQt4.QtGui import QLabel
from PyQt4.QtCore import pyqtSignal
from PyQt4.QtSql import QSqlTableModel
from PyQt4 import QtCore, QtGui


class CustomSqlModel(QSqlTableModel):
    def __init__(self, parent=None):
        QSqlTableModel.__init__(self, parent=parent)

    def data(self, index, role):
        if role == QtCore.Qt.BackgroundRole:
            return QtGui.QBrush(QtCore.Qt.yellow)
        return QSqlTableModel.data(self, index, role)
