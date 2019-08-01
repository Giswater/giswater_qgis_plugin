"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel

from qgis.core import QgsExpression, QgsFeatureRequest
from qgis.PyQt.QtCore import Qt, QDate
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QCompleter
from ui_manager import DelFeature
from functools import partial

from .. import utils_giswater
from .parent_manage import ParentManage
from ..ui_manager import WorkcatEnd, NewWorkcat
from ..ui_manager import WorkcatEndList


class DeleteFeature(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_delete_feature(self):

        # Create the dialog and signals
        self.dlg_delete_feature = DelFeature()
        self.load_settings(self.dlg_delete_feature)


        # Set listeners
        self.dlg_delete_feature.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_delete_feature))

        # Open dialog
        self.open_dialog(self.dlg_delete_feature)

