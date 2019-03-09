# -*- coding: utf-8 -*-QDialog
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QDialog
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'hydro_info.ui'))


class HydroInfo(QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        """ Constructor """
        super(HydroInfo, self).__init__(parent)

        # Set up the user interface from Designer.
        self.setupUi(self)

    def initGui(self):
        pass
