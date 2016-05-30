# -*- coding: utf-8 -*-
from PyQt4 import QtGui
from ui.search_plus_dialog_base_ui import Ui_searchPlusDockWidget

# cannot apply dynaic loading because cannot promote widget 
# belongin to othe modules
# import os
# from PyQt4 import uic
# FORM_CLASS, _ = uic.loadUiType(os.path.join(
#     os.path.dirname(__file__), 'ui', 'search_plus_dialog_base.ui'))
# class SearchPlusDockWidget(QtGui.QDockWidget, FORM_CLASS):

class SearchPlusDockWidget(QtGui.QDockWidget, Ui_searchPlusDockWidget):
    
    def __init__(self, parent=None):
        ''' Constructor '''
        super(SearchPlusDockWidget, self).__init__(parent)
        
        # Set up the user interface from Designer.
        self.setupUi(self)