# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

# Folder that contains UI files
# In this file we will add all classes currently located in that folder
ui_path = os.path.dirname(__file__) + os.sep + 'ui'


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_doc.ui'))
class AddDoc(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_element.ui'))
class AddElement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_visit.ui'))
class AddVisit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

