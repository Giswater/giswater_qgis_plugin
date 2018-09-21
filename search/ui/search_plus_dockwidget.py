# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4 import  uic
    from PyQt4.QtGui import QDockWidget    
else:
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
    
 