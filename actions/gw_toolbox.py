"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
from PyQt4.QtCore import QSize
from PyQt4.QtGui import QDialog
from PyQt4.QtGui import QItemSelectionModel

try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4 import QtCore, QtNetwork
    from PyQt4.QtCore import Qt, QDate, QPoint, QUrl
    from PyQt4.QtWebKit import QWebView, QWebSettings, QWebPage
    from PyQt4.QtGui import QIntValidator, QDoubleValidator, QMenu, QApplication, QSpinBox, QDoubleSpinBox
    from PyQt4.QtGui import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, QDateEdit
    from PyQt4.QtGui import QGridLayout, QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QListWidget
    from PyQt4.QtGui import QTableView, QListWidgetItem, QStandardItemModel, QStandardItem, QTabWidget
    from PyQt4.QtGui import QAbstractItemView, QPrinter, QTreeWidgetItem
    from PyQt4.QtSql import QSqlTableModel
    import urlparse
    import win32gui

else:
    from qgis.PyQt import QtCore
    from qgis.PyQt.QtCore import Qt, QDate, QStringListModel,QPoint
    from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator, QStandardItem, QStandardItemModel
    from qgis.PyQt.QtWebKit import QWebView, QWebSettings, QWebPage
    from qgis.PyQt.QtWidgets import QTreeWidgetItem, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox
    from qgis.PyQt.QtWidgets import QGridLayout, QSpacerItem, QSizePolicy, QCompleter, QTableView, QListWidget
    from qgis.PyQt.QtWidgets import QTabWidget, QAbstractItemView, QMenu,  QApplication,QSpinBox, QDoubleSpinBox
    from qgis.PyQt.QtSql import QSqlTableModel, QListWidgetItem
    import urllib.parse as urlparse

import json
import sys
import operator

from collections import OrderedDict
from datetime import datetime
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import TrvToolbox


class GwToolBox(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)

    def set_project_type(self, project_type):
        self.project_type = project_type

    def open_toolbox(self):
        self.dlg_toolbox = TrvToolbox()
        self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dlg_toolbox)
        form = '"formName":"epaoptions"'
        body = self.create_body(form=form)
        # Get layers under mouse clicked
        sql = ("SELECT " + self.schema_name + ".gw_api_getconfig($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        # TODO controllar si row tiene algo
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        self.populate_trv(self.dlg_toolbox.trv, complet_result[0]['body']['form']['formTabs'])
        self.dlg_toolbox.trv.doubleClicked.connect(partial(self.test))
        self.dlg_toolbox.show()

    def test(self, index):
        self.controller.log_info(str("TEST 10"))
        feature_id = index.sibling(index.row(), 1).data()
        self.controller.log_info(str(feature_id))
    def populate_trv(self, trv_widget, result):

        model = QStandardItemModel()
        #model.setHorizontalHeaderLabels(['col1', 'col2', 'col3'])
        trv_widget.setModel(model)
        trv_widget.setUniformRowHeights(False)

        for field in result[0]['fields']:
            parent1 = QStandardItem('Aqui deberia ir el grupo padre {}'.format("GRUPO PADRE"))
            self.controller.log_info(str(type(field)))
            for key, value in field.items():
                label = QStandardItem('{}'.format(key.capitalize()))
                func_name = QStandardItem('{}'.format(value))
                parent1.appendRow([label, func_name])
            model.appendRow(parent1)
            index = model.indexFromItem(parent1)
            trv_widget.expand(index)

        return
        # populate data
        for i in range(3):
            parent1 = QStandardItem('Family {}. Some long status text for sp'.format(i))
            for j in range(3):
                child1 = QStandardItem('Child {}'.format(i * 3 + j))
                child2 = QStandardItem('row: {}, col: {}'.format(i, j + 1))
                child3 = QStandardItem('row: {}, col: {}'.format(i, j + 2))
                parent1.appendRow([child1, child2, child3])
            model.appendRow(parent1)
            # span container columns
            trv_widget.setFirstColumnSpanned(i, trv_widget.rootIndex(), True)
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # expand third container
        index = model.indexFromItem(parent1)
        trv_widget.expand(index)
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # select last row
        selmod = trv_widget.selectionModel()
        index2 = model.indexFromItem(child3)
        selmod.select(index2, QItemSelectionModel.Select | QItemSelectionModel.Rows)
        # self.model = QStandardItemModel()
        #
        # topLevelParentItem = self.model.invisibleRootItem()
        #
        #
        # for item in data:
        #     splitName = item.split('/')
        #
        #     # first part of string is defo parent item
        #     # check to make sure not to add duplicate
        #     if len(self.model.findItems(splitName[0], flags=QtCore.Qt.MatchFixedString)) == 0:
        #         parItem = QStandardItem(splitName[0])
        #         topLevelParentItem.appendRow(parItem)
        #
        #
        #     def addItems(parent, elements):
        #         """
        #         This method recursively adds items to a QStandardItemModel from a list of paths.
        #         :param parent:
        #         :param elements:
        #         :return:
        #         """
        #
        #         for element in elements:
        #
        #             # first check if this element already exists in the hierarchy
        #             noOfChildren = parent.rowCount()
        #
        #             # if there are child objects under specified parent
        #             if noOfChildren != 0:
        #                 # create dict to store all child objects under parent for testing against
        #                 childObjsList = {}
        #
        #                 # iterate over indexes and get names of all child objects
        #                 for c in range(noOfChildren):
        #                     childObj = parent.child(c)
        #                     childObjsList[childObj.text()] = childObj
        #
        #                 if element in childObjsList.keys():
        #                     # only run recursive function if there are still elements to work on
        #                     if elements[1:]:
        #                         addItems(childObjsList[element], elements[1:])
        #
        #                     return
        #
        #                 else:
        #                     # item does not exist yet, create it and parent
        #                     newObj = QtGui.QStandardItem(element)
        #                     parent.appendRow(newObj)
        #
        #                     # only run recursive function if there are still elements to work on
        #                     if elements[1:]:
        #                         addItems(newObj, elements[1:])
        #
        #                     return
        #
        #             else:
        #                 # if there are no existing child objects, it's safe to create the item and parent it
        #                 newObj = QtGui.QStandardItem(element)
        #                 parent.appendRow(newObj)
        #
        #                 # only run recursive function if there are still elements to work on
        #                 if elements[1:]:
        #                     # now run the recursive function again with the latest object as the parent and
        #                     # the rest of the elements as children
        #                     addItems(newObj, elements[1:])
        #
        #                 return
        #
        #
        #     # call proc to add remaining items after toplevel item to the hierarchy
        #     print "### calling addItems({0}, {1})".format(parItem.text(), splitName[1:])
        #     addItems(parItem, splitName[1:])

        #     print 'done: ' + item + '\n'