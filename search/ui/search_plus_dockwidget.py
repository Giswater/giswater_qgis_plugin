# -*- coding: utf-8 -*-
from PyQt4 import QtGui
from search.ui.search_plus_dialog import Ui_searchPlusDockWidget

# cannot apply dynamic loading because cannot promote widget 
# belongin to othe modules
# import os
# from PyQt4 import uic
# FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'ui', 'search_plus_dialog.ui'))
# class SearchPlusDockWidget(QtGui.QDockWidget, FORM_CLASS):

class SearchPlusDockWidget(QtGui.QDockWidget, Ui_searchPlusDockWidget):
    
    def __init__(self, parent=None):
        ''' Constructor '''
        super(SearchPlusDockWidget, self).__init__(parent)
        
        # Set up the user interface from Designer.
        self.setupUi(self)