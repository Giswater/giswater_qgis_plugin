# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'psector_management.ui'))


class Psector_management(QtGui.QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        """ Constructor """
        super(Psector_management, self).__init__(parent)
        # Set up the user interface from Designer.
        # After setupUI you can access any designer object by doing
        # self.<objectname>, and you can use autoconnect slots - see
        # http://qt-project.org/doc/qt-4.8/designer-using-a-ui-file.html
        # #widgets-and-dialogs-with-auto-connect
        self.setupUi(self)

    def initGui(self):
        pass