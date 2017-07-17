# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os
from qgis.core import QgsMessageLog
from PyQt4.QtGui import QSizePolicy

'''
FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'dimensions.ui'))




class DimensionsForm(QtGui.QDialog, FORM_CLASS):

    def __init__(self, parent=None):
        """ Constructor """
        super(DimensionsForm, self).__init__(parent)
        # Set up the user interface from Designer.
        # After setupUI you can access any designer object by doing
        # self.<objectname>, and you can use autoconnect slots - see
        # http://qt-project.org/doc/qt-4.8/designer-using-a-ui-file.html
        # #widgets-and-dialogs-with-auto-connect
        self.setupUi(self)
        
        
    def initGui(self):
        pass
		
'''	
		
def form_open(dialog, layer, feature):
    QgsMessageLog.logMessage(str(dialog))
    dialog.parent().setFixedWidth(200)
    dialog.parent().setFixedHeight(200)
    dialog.parent().setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)