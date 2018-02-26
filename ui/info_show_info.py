# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

form_name = 'info_show_info.ui'
FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), form_name))


class InfoShowInfo(QtGui.QDialog, FORM_CLASS):

    def __init__(self):
        """ Constructor """
        QtGui.QDialog.__init__(self)
        self.setupUi(self)