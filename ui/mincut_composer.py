# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

form_name = 'mincut_composer.ui'
FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), form_name))


class MincutComposer(QtGui.QDialog, FORM_CLASS):

    def __init__(self, parent=None):
        """ Constructor """
        super(MincutComposer, self).__init__(parent)
        self.setupUi(self)