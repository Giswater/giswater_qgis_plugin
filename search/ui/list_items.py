# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'list_items.ui'))


class ListItems(QtGui.QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        """ Constructor """
        super(ListItems, self).__init__(parent)

        # Set up the user interface from Designer.
        self.setupUi(self)

    def initGui(self):
        pass
