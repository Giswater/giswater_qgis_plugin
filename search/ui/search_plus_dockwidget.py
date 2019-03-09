# -*- coding: utf-8 -*-
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QDockWidget
import os


FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'search_plus_dialog.ui'))


class SearchPlusDockWidget(QDockWidget, FORM_CLASS):
    
    def __init__(self, parent=None):
        """ Constructor """
        super(SearchPlusDockWidget, self).__init__(parent)
        
        # Set up the user interface from Designer.
        self.setupUi(self)
        
        
    def initGui(self):
        pass   