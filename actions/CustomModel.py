from PyQt4.QtGui import QLabel
from PyQt4.QtCore import pyqtSignal
from PyQt4.QtSql import QSqlTableModel
from PyQt4 import QtCore, QtGui


class CustomSqlModel(QSqlTableModel):
    def __init__(self, parent=None):
        QSqlTableModel.__init__(self, parent=parent)
    #
    def data(self, QModelIndex, role):

        if role == QtCore.Qt.BackgroundRole:
            # if QModelIndex.row() in [1, 3]:
            #     return QtGui.QBrush(QtCore.Qt.yellow)
            # else:
            #     return QtGui.QBrush(QtCore.Qt.red)

            value = QModelIndex.data()
            print(value)
            print(type(value))
            if value in ('2020', '135'):
                return QtGui.QBrush(QtCore.Qt.yellow)
            else:
                return QtGui.QBrush(QtCore.Qt.red)
        return QSqlTableModel.data(self, QModelIndex, role)

    # def setData(self, QModelIndex, p_object, role=None):
    #     if role == QtCore.Qt.BackgroundRole:
    #         return QtGui.QColor(p_object)
    #
    #     return QSqlTableModel.data(self, QModelIndex, role)


    # def data(self, index, role):
    #     if role==QtCore.Qt.BackgroundColorRole:
    #         value = self.data(index, QtCore.Qt.DisplayRole)
    #         if value.data() > 2000:
    #             return QtGui.QBrush(QtCore.Qt.green)
    #         else:
    #             return QtGui.QBrush(QtCore.Qt.blue)
    #     return QSqlTableModel.data(self, index, role)