# -*- coding: utf-8 -*-
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QDialog
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'price_management.ui'))


class PriceManagement(QDialog, FORM_CLASS):

    def __init__(self, parent=None):
        """ Constructor """
        super(PriceManagement, self).__init__(parent)
        self.setupUi(self)

