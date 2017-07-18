'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction

from functools import partial

import utils_giswater
from parent_init import ParentDialog

from PyQt4 import QtGui, uic
import os
from qgis.core import QgsMessageLog
from PyQt4.QtGui import QSizePolicy

		
def formOpen(dialog, layer, feature):
    QgsMessageLog.logMessage(str(dialog))
    dialog.parent().setFixedWidth(319)
    dialog.parent().setFixedHeight(604)
    dialog.parent().setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
    
    global feature_dialog
    utils_giswater.setDialog(dialog)