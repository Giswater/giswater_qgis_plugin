# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4 import uic
    from PyQt4.QtGui import QDialog      
else:
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
    
