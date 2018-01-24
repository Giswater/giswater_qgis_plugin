# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

form_name = 'visit_management.ui'
FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), form_name))


class VisitManagement(FORM_CLASS):

    def __init__(self):
        """ Constructor """
        QtGui.QDialog.__init__(self)
        self.setupUi(self)
        
