"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from functools import partial
import configparser


from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtWidgets import QToolBar, QActionGroup, QDockWidget, QMenu, QComboBox, QTableView, QAbstractItemView, \
    QTableWidgetItem, QPushButton
from qgis.PyQt.QtGui import QIcon

from .ui.ui_manager import GwLoadMenuUi
from .toolbars import buttons
from .. import global_vars
from ..lib import tools_os, tools_qt
from .utils import tools_gw


class GwLoadMenu(QObject):

    def __init__(self):
        """ Class to manage layers. Refactor code from main.py """

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.plugin_dir = global_vars.plugin_dir

        self.roaming_path_folder = os.path.join(tools_os.get_datadir(), global_vars.roaming_user_dir)
        self.list_values = []



    def menu_read(self, show_warning=True):
        main_menu = QMenu("&Giswater", self.iface.mainWindow().menuBar())

        actions = self.iface.mainWindow().menuBar().actions()
        lastAction = actions[-1]

        # region Toolbars
        toolbars_menu = QMenu(f"Toolbars", self.iface.mainWindow().menuBar())
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + 'icons' + os.sep + 'dialogs' + os.sep \
                    + '20x20' + os.sep + '36.png'
        toolbars_icon = QIcon(icon_path)
        toolbars_menu.setIcon(toolbars_icon)
        main_menu.addMenu(toolbars_menu)
        for toolbar in global_vars.settings.value(f"toolbars/list_toolbars"):
            toolbar_submenu = QMenu(f"{toolbar}", self.iface.mainWindow().menuBar())
            toolbars_menu.addMenu(toolbar_submenu)
            buttons_toolbar = global_vars.settings.value(f"toolbars/{toolbar}")
            for index_action in buttons_toolbar:
                icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + 'icons' + os.sep + 'toolbars' + os.sep \
                            + str(toolbar) + os.sep + str(index_action) + '.png'
                icon = QIcon(icon_path)
                button_def = global_vars.settings.value(f"buttons_def/{index_action}")
                text = ""
                if button_def:
                    text = self.translate(f'{index_action}_text')
                parent = self.iface.mainWindow()
                ag = QActionGroup(parent)
                ag.setProperty('gw_name', 'gw_QActionGroup')
                if button_def is None:
                    continue

                action_function = getattr(buttons, button_def)(icon_path, button_def, text, None, ag)
                action = toolbar_submenu.addAction(icon, f"{text}")
                action.triggered.connect(partial(self.clicked_event, action_function))

        # endregion
        # region Roaming
        roaming_menu = QMenu(f"Roaming", self.iface.mainWindow().menuBar())
        main_menu.addMenu(roaming_menu)
        icon_path = os.path.dirname(__file__) + os.sep + '..' + os.sep + 'icons' + os.sep + 'toolbars' + os.sep \
                    + 'utilities' + os.sep + '99.png'
        roaming_icon = QIcon(icon_path)
        roaming_menu.setIcon(roaming_icon)
        action_open_path = roaming_menu.addAction(f"Open folder")
        action_open_path.triggered.connect(self.open_roaming_path)

        action_manage_file = roaming_menu.addAction(f"Manage Files")
        action_manage_file.triggered.connect(self.open_manage_file)
        # endregion

        self.iface.mainWindow().menuBar().insertMenu(lastAction, main_menu)


    def clicked_event(self, action_function):
        action_function.clicked_event()


    def open_roaming_path(self):
        path = os.path.realpath(self.roaming_path_folder)
        os.startfile(path)


    def translate(self, message):
        return tools_qt.tr(message, aux_context='ui_message')



    def open_manage_file(self):
        """ Manage files dialog:: """
        self.dlg_manage_menu = GwLoadMenuUi()

        # Manage widgets
        self.cmb_config_files = self.dlg_manage_menu.findChild(QComboBox, 'cmb_config_files')
        self.tbl_config_files = self.dlg_manage_menu.findChild(QTableView, 'tbl_config_files')
        self.btn_save = self.dlg_manage_menu.findChild(QPushButton, 'btn_save')
        self.btn_close = self.dlg_manage_menu.findChild(QPushButton, 'btn_close')

        # Popualte cmb_config_files
        files = [f for f in os.listdir(f"{self.roaming_path_folder}{os.sep}config")]
        for file in files:
            self.cmb_config_files.addItem(f"{file}")

        # Get values
        self.get_config_file_values()

        # Fill table_config_files
        self.fill_tbl_config_files(self.tbl_config_files)

        # Listeners
        self.cmb_config_files.currentIndexChanged.connect(self.get_config_file_values)
        self.cmb_config_files.currentIndexChanged.connect(partial(self.fill_tbl_config_files, self.tbl_config_files))
        self.btn_save.clicked.connect(partial(self.save_config_files))
        self.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_manage_menu))

        # Open dialog
        self.dlg_manage_menu.open()


    def get_config_file_values(self):

        # Get values
        self.list_values = []
        values = {}
        path = f"{self.roaming_path_folder}{os.sep}config{os.sep}{tools_qt.get_text(self.dlg_manage_menu, self.cmb_config_files)}"

        if not os.path.exists(path):
            return None

        parser = configparser.ConfigParser()
        parser.read(path)
        for section in parser.sections():
            for parameter in parser[section]:
                values["Section"] = section
                values["Parameter"] = parameter
                values["Value"] = parser[section][parameter]
                self.list_values.append(values)
                values = {}


    def fill_tbl_config_files(self, table):

        row_count = (len(self.list_values))
        column_count = (len(self.list_values[0]))

        table.setColumnCount(column_count)
        table.setRowCount(row_count)

        table.setHorizontalHeaderLabels((list(self.list_values[0].keys())))

        for row in range(row_count):  # add items from array to QTableWidget
            for column in range(column_count):
                item = (list(self.list_values[row].values())[column])
                table.setItem(row, column, QTableWidgetItem(item))


    def save_config_files(self):

        row_count = self.tbl_config_files.rowCount()
        filename = tools_qt.get_text(self.dlg_manage_menu, self.cmb_config_files).replace(".config", "")
        for row in range(row_count):
            section = self.tbl_config_files.item(row, 0).text()
            parameter = self.tbl_config_files.item(row, 1).text()
            value = self.tbl_config_files.item(row, 2).text()

            tools_gw.set_config_parser(f"{section}", f"{parameter}",f"{value}",
                                       file_name=filename, prefix=False)

