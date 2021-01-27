"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import os
from functools import partial

from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtGui import QIcon, QKeySequence
from qgis.PyQt.QtWidgets import QActionGroup, QMenu, QComboBox, QTableView, QTableWidgetItem, QPushButton, QTreeWidget, QTreeWidgetItem

from .toolbars import buttons
from .ui.ui_manager import GwLoadMenuUi
from .utils import tools_gw
from .. import global_vars
from ..lib import tools_log, tools_qt


class GwMenuLoad(QObject):

    def __init__(self):
        """ Class to manage layers. Refactor code from main.py """

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.plugin_dir = global_vars.plugin_dir

        self.user_folder_dir = global_vars.user_folder_dir

        self.list_values = []


    def read_menu(self):
        """  """

        actions = self.iface.mainWindow().menuBar().actions()
        last_action = actions[-1]

        self.main_menu = QMenu("&Giswater", self.iface.mainWindow().menuBar())
        tools_gw.set_config_parser("menu", "load", "true", "project", "init")

        # region Toolbar
        toolbars_menu = QMenu(f"Toolbar", self.iface.mainWindow().menuBar())
        icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}dialogs{os.sep}20x20{os.sep}36.png"
        toolbars_icon = QIcon(icon_path)
        toolbars_menu.setIcon(toolbars_icon)
        self.main_menu.addMenu(toolbars_menu)
        for toolbar in global_vars.settings.value(f"toolbars/list_toolbars"):
            toolbar_submenu = QMenu(f"{toolbar}", self.iface.mainWindow().menuBar())
            toolbars_menu.addMenu(toolbar_submenu)
            buttons_toolbar = global_vars.settings.value(f"toolbars/{toolbar}")
            for index_action in buttons_toolbar:
                icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}toolbars{os.sep}{toolbar}{os.sep}{index_action}.png"
                icon = QIcon(icon_path)
                button_def = global_vars.settings.value(f"buttons_def/{index_action}")
                text = ""
                if button_def:
                    text = self._translate(f'{index_action}_text')
                parent = self.iface.mainWindow()
                ag = QActionGroup(parent)
                ag.setProperty('gw_name', 'gw_QActionGroup')
                if button_def is None:
                    continue

                action_function = getattr(buttons, button_def)(icon_path, button_def, text, None, ag)
                action = toolbar_submenu.addAction(icon, f"{text}")
                shortcut_key = tools_gw.get_config_parser("action_shortcuts", f"{index_action}", "user", "init", prefix=False)
                if shortcut_key:
                    action.setShortcuts(QKeySequence(f"{shortcut_key}"))
                    global_vars.session_vars['shortcut_keys'].append(shortcut_key)

                action.triggered.connect(partial(self._clicked_event, action_function))

        # endregion
        # region Config
        config_menu = QMenu(f"Config", self.iface.mainWindow().menuBar())
        self.main_menu.addMenu(config_menu)
        icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}toolbars{os.sep}utilities{os.sep}99.png"
        config_icon = QIcon(icon_path)
        config_menu.setIcon(config_icon)

        action_manage_file = config_menu.addAction(f"Manage Files")
        action_manage_file.triggered.connect(self._open_manage_file)
        # endregion

        # region User folder
        config_menu = QMenu(f"User folder", self.iface.mainWindow().menuBar())
        self.main_menu.addMenu(config_menu)
        icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}toolbars{os.sep}utilities{os.sep}99.png"
        config_icon = QIcon(icon_path)
        config_menu.setIcon(config_icon)
        action_open_path = config_menu.addAction(f"Open folder")
        action_open_path.triggered.connect(self._open_config_path)
        # endregion

        self.iface.mainWindow().menuBar().insertMenu(last_action, self.main_menu)


    def _clicked_event(self, action_function):
        """  """
        action_function.clicked_event()


    def _translate(self, message):
        """ Calls on tools_qt to translate parameter message. """
        return tools_qt.tr(message, aux_context='ui_message')

    # region private functions
    def _open_config_path(self):
        """ Opens the OS-specific Config directory. """
        path = os.path.realpath(self.user_folder_dir)
        os.startfile(path)


    def _open_manage_file(self):
        """ Manage files dialog:: """
        self.dlg_manage_menu = GwLoadMenuUi()

        # Manage widgets
        self.tree_config_files = self.dlg_manage_menu.findChild(QTreeWidget, 'tree_config_files')
        self.btn_save = self.dlg_manage_menu.findChild(QPushButton, 'btn_save')
        self.btn_close = self.dlg_manage_menu.findChild(QPushButton, 'btn_close')
        self.btn_reset_dialog = self.dlg_manage_menu.findChild(QPushButton, 'btn_reset_dialog')

        # Fill table_config_files
        self._fill_tbl_config_files(self.tree_config_files)

        # Listeners
        self.btn_save.clicked.connect(partial(self._save_config_files))
        self.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_manage_menu))
        self.btn_reset_dialog.clicked.connect(partial(self._reset_position_dialog))

        # Open dialog
        self.dlg_manage_menu.open()


    def _reset_position_dialog(self):
        """ Reset position dialog x/y """

        try:
            parser = configparser.ConfigParser(comment_prefixes='/', inline_comment_prefixes='/', allow_no_value=True)
            config_folder = f"{self.user_folder_dir}{os.sep}config{os.sep}"
            if not os.path.exists(config_folder):
                os.makedirs(config_folder)
            path = config_folder + f"session.config"
            parser.read(path)

            # Check if section exists in file
            if "dialogs_position" in parser:
                parser.remove_section("dialogs_position")

            msg = "Reset position form done successfully."
            tools_qt.show_info_box(msg, "Info")

            with open(path, 'w') as configfile:
                parser.write(configfile)
                configfile.close()
        except Exception as e:
            tools_log.log_warning(f"set_config_parser exception [{type(e).__name__}]: {e}")
            return


    def _get_config_file_values(self, file_name):
        """ Populates a variable with a list of values parsed from a configuration file. """
        # Get values
        self.list_values = []
        values = {}
        path = f"{self.user_folder_dir}{os.sep}config{os.sep}{file_name}"
        project_types = tools_gw.get_config_parser('system', 'project_types_dev', "project", "init")
        if not os.path.exists(path):
            return None

        parser = configparser.ConfigParser()
        parser.read(path)
        for section in parser.sections():
            for parameter in parser[section]:
                if parameter[0:2] in project_types and tools_gw.get_project_type() != parameter[0:2]:
                    continue
                values["Section"] = section
                values["Parameter"] = parameter
                values["Value"] = parser[section][parameter]
                self.list_values.append(values)
                values = {}


    def _fill_tbl_config_files(self, tree):
        """ Fills a UI table with the local list of values variable. """

        files = [f for f in os.listdir(f"{self.user_folder_dir}{os.sep}config")]

        for file in files:
            self._get_config_file_values(file)
            item = QTreeWidgetItem([f"{file}"])

            row_count = len(self.list_values)
            for row in range(row_count):
                item_child = QTreeWidgetItem([f"{self.list_values[row]['Section']}", f"{self.list_values[row]['Parameter']}", f"{self.list_values[row]['Value']}"])
                # item_child.doubleClicked.connect(partial(self._onDoubleClick))
                item.addChild(item_child)

            tree.resize(500, 200)
            tree.setColumnCount(3)
            tree.setHeaderLabels(["Section", "Parameter", "Value"])
            tree.addTopLevelItem(item)


    def _save_config_files(self):
        """ Writes the list of values into a persistant configuration file. """
        return
        row_count = self.tbl_config_files.rowCount()
        filename = tools_qt.get_text(self.dlg_manage_menu, self.cmb_config_files).replace(".config", "")
        for row in range(row_count):
            section = self.tbl_config_files.item(row, 0).text()
            parameter = self.tbl_config_files.item(row, 1).text()
            value = self.tbl_config_files.item(row, 2).text()
            tools_gw.set_config_parser(f"{section}", f"{parameter}", f"{value}", file_name=filename, prefix=False)


    def _onDoubleClick(self, index):

        item = self.currentItem()
        item.setFlags(item.flags() | QtCore.Qt.ItemIsEditable)
        if index.column() != 0:
            item.setFlags(item.flags() & ~QtCore.Qt.ItemIsEditable)
    # endregion
