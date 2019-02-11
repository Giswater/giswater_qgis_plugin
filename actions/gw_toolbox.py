"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
from PyQt4.QtCore import QSize
from PyQt4.QtGui import QDialog

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
    from PyQt4.QtGui import QAbstractItemView, QPrinter
    from PyQt4.QtSql import QSqlTableModel
    import urlparse
    import win32gui

else:
    from qgis.PyQt import QtCore
    from qgis.PyQt.QtCore import Qt, QDate, QStringListModel,QPoint
    from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator, QStandardItem, QStandardItemModel
    from qgis.PyQt.QtWebKit import QWebView, QWebSettings, QWebPage
    from qgis.PyQt.QtWidgets import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox
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
        self.dlg_toolbox.show()

        # self.page = QWebPage()
        # self.p = QPrinter(QPrinter.HighResolution)
        # self.p.setOutputFormat(QPrinter.PdfFormat)
        # self.p.setOutputFileName("nestor_out.pdf")
        # text = "<html> <body> coucou <br>coucou br>coucou <br>coucou <br>coucou <br>coucou <br>coucou </body> </html>";
        # self.page.mainFrame().setHtml(text)
        # self.page.setViewportSize(QSize(2000,2000))
        # self.page.mainFrame().print_(self.p)

        self.web = QWebView()
        self.web.settings().setAttribute(QWebSettings.PluginsEnabled, True)
        # self.web.settings().setAttribute(QWebSettings.AutoLoadImages, True)
        # self.web.settings().setAttribute(QWebSettings.PrivateBrowsingEnabled, True)
        # self.web.settings().setAttribute(QWebSettings.DeveloperExtrasEnabled, True)
        # self.web.settings().setAttribute(QWebSettings.LocalContentCanAccessFileUrls, True)
        #self.web.load(QUrl('file:///C:/Users/user/.qgis2/python/plugins/giswater/png/ud_arc_es.pdf'))
        #self.web.setUrl(QUrl('file:///C:/Users/user/.qgis2/python/plugins/giswater/png/ud_arc_es.pdf'))
        self.web.load(QUrl('C:/Users/user/.qgis2/python/plugins/giswater/png/ud_section_semielliptical.png'))

        #self.web.load(QUrl('C:/Users/user/.qgis2/python/plugins/giswater/png/ud_arc_es.pdf'))
        #self.web.setHtml('<h1>HTML normal</h1><p><a href="file://C:/Users/user/.qgis2/python/plugins/giswater/png/ud_arc_es.pdf">http://investor.google.com/pdf/2007_google_annual_report.pdf</a></p>');
        #self.web.setContent('C:/Users/user/.qgis2/python/plugins/giswater/png/ud_section_semielliptical.png', "application/pdf")
        self.web.show()

        # self.web.load(QUrl('file:///C:/Users/user/.qgis2/python/plugins/giswater/png/ud_arc_es.pdf'))
        self.web2 = QWebView()
        self.web2.settings().setAttribute(QWebSettings.PluginsEnabled, True)

        self.web2.show()
        self.web2.load(QUrl("https://bmaps.bgeo.es/dev/demo/"))


