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

from qgis.PyQt.QtCore import QObject, Qt
from qgis.PyQt.QtGui import QIcon, QKeySequence
from qgis.PyQt.QtWidgets import QActionGroup, QMenu, QPushButton, QTreeWidget, QTreeWidgetItem

from .toolbars import buttons
from .ui.ui_manager import GwLoadMenuUi
from .utils import tools_gw
from .. import global_vars
from ..lib import tools_log, tools_qt, tools_qgis, tools_os


class GwMenuLoad(QObject):

    def __init__(self):
        """ Class to manage layers. Refactor code from main.py """

        super().__init__()
        self.iface = global_vars.iface
        self.settings = global_vars.giswater_settings
        self.plugin_dir = global_vars.plugin_dir
        self.user_folder_dir = global_vars.user_folder_dir


    def read_menu(self):
        """  """

        actions = self.iface.mainWindow().menuBar().actions()
        last_action = actions[-1]

        self.main_menu = QMenu("&Giswater", self.iface.mainWindow().menuBar())
        self.main_menu.setObjectName("Giswater")
        tools_gw.set_config_parser("menu", "load", "true", "project", "giswater")

        config_icon = QIcon(
            f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}toolbars{os.sep}utilities{os.sep}99.png")

        # region Toolbar
        toolbars_menu = QMenu(f"Toolbars", self.iface.mainWindow().menuBar())
        icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}dialogs{os.sep}20x20{os.sep}36.png"
        toolbars_icon = QIcon(icon_path)
        toolbars_menu.setIcon(toolbars_icon)
        self.main_menu.addMenu(toolbars_menu)
        for toolbar in global_vars.giswater_settings.value(f"toolbars/list_toolbars"):
            toolbar_submenu = QMenu(f"{toolbar}", self.iface.mainWindow().menuBar())
            toolbars_menu.addMenu(toolbar_submenu)
            buttons_toolbar = global_vars.giswater_settings.value(f"toolbars/{toolbar}")

            project_exclusive = tools_gw.get_config_parser('project_exclusive', str(global_vars.project_type),
                                                           "project", "giswater")
            if project_exclusive not in (None, 'None'):
                project_exclusive = project_exclusive.replace(' ', '').split(',')

            for index_action in buttons_toolbar:

                if index_action in project_exclusive:
                    continue

                icon_path = f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}toolbars{os.sep}{toolbar}{os.sep}{index_action}.png"
                icon = QIcon(icon_path)
                button_def = global_vars.giswater_settings.value(f"buttons_def/{index_action}")
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
                shortcut_key = tools_gw.get_config_parser("action_shortcuts", f"{index_action}", "user", "init",
                                                          prefix=False, log_warning=False)
                if shortcut_key:
                    action.setShortcuts(QKeySequence(f"{shortcut_key}"))
                    global_vars.shortcut_keys.append(shortcut_key)

                action.triggered.connect(partial(self._clicked_event, action_function))
        # endregion

        # region Actions
        actions_menu = QMenu(f"Actions", self.iface.mainWindow().menuBar())
        actions_menu.setIcon(config_icon)
        self.main_menu.addMenu(actions_menu)

        action_set_log_sql = actions_menu.addAction(f"Toggle log sql")
        log_sql_shortcut = tools_gw.get_config_parser("system", f"log_sql_shortcut", "user", "init", prefix=False)
        if not log_sql_shortcut:
            tools_gw.set_config_parser("system", f"log_sql_shortcut", f"{log_sql_shortcut}", "user", "init",
                                       prefix=False)
        action_set_log_sql.setShortcuts(QKeySequence(f"{log_sql_shortcut}"))
        action_set_log_sql.triggered.connect(self._set_log_sql)

        action_reset_dialogs = actions_menu.addAction(f"Reset dialogs")

        action_reset_dialogs.triggered.connect(self._reset_position_dialog)
        # endregion

        # region Adavanced
        action_manage_file = self.main_menu.addAction(f"Advanced")
        action_manage_file.triggered.connect(self._open_manage_file)
        folder_icon = QIcon(
            f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}dialogs{os.sep}20x20{os.sep}105.png")
        action_manage_file.setIcon(folder_icon)
        # endregion

        # region Open user folder

        log_folder = os.path.join(global_vars.user_folder_dir, 'log')
        size = tools_os.get_folder_size(log_folder)
        log_folder_volume = f"{round(size / (1024 * 1024), 2)} MB"

        folder_icon = QIcon(
            f"{os.path.dirname(__file__)}{os.sep}..{os.sep}icons{os.sep}dialogs{os.sep}20x20{os.sep}102.png")
        action_open_path = self.main_menu.addAction(f"Open folder  ({log_folder_volume})")

        action_open_path.setIcon(folder_icon)
        action_open_path.triggered.connect(self._open_config_path)
        # endregion

        self.iface.mainWindow().menuBar().insertMenu(last_action, self.main_menu)


    def _clicked_event(self, action_function):

        action_function.clicked_event()


    def _translate(self, message):
        """ Calls on tools_qt to translate parameter message """

        return tools_qt.tr(message)


    # region private functions
    def _open_config_path(self):
        """ Opens the OS-specific Config directory """

        path = os.path.realpath(self.user_folder_dir)
        os.startfile(path)


    def _open_manage_file(self):
        """ Manage files dialog:: """

        tools_qgis.set_cursor_wait()
        self.dlg_manage_menu = GwLoadMenuUi()

        # Manage widgets
        self.tree_config_files = self.dlg_manage_menu.findChild(QTreeWidget, 'tree_config_files')
        self.btn_close = self.dlg_manage_menu.findChild(QPushButton, 'btn_close')

        # Fill table_config_files
        self._fill_tbl_config_files()

        # Listeners
        self.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_manage_menu))

        tools_qgis.restore_cursor()

        message = "Changes on this page are dangerous and can break Giswater plugin in various ways. \n" \
                  "You will need to restart QGIS to apply changes. Do you want continue?"
        title = "Advanced Menu"
        answer = tools_qt.show_question(message, title)
        if not answer:
            return

        # Open dialog
        self.dlg_manage_menu.open()


    def _reset_position_dialog(self):
        """ Reset position dialog x/y """

        try:
            parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
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


    def _fill_tbl_config_files(self):
        """ Fills a UI table with the local list of values variable. """

        self.tree_config_files.resize(500, 200)
        self.tree_config_files.setColumnCount(4)
        self.tree_config_files.setHeaderLabels(["Section", "Parameter", "Value", "Description"])
        self.tree_config_files.itemDoubleClicked.connect(partial(self._double_click_event))
        self.tree_config_files.itemChanged.connect(partial(self._set_config_value))

        files = [f for f in os.listdir(f"{self.user_folder_dir}{os.sep}config")]
        for file in files:
            item = QTreeWidgetItem([f"{file}"])

            project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater")
            parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
            parser.read(f"{self.user_folder_dir}{os.sep}config{os.sep}{file}")

            # For each section we create a sub-item and add all the parameters to that sub-item
            for section in parser.sections():
                subitem = QTreeWidgetItem([f"{section}"])
                item.addChild(subitem)
                for parameter in parser[section]:
                    if parameter[0:2] in project_types and tools_gw.get_project_type() != parameter[0:2]:
                        continue
                    value = parser[section][parameter]
                    values = {}
                    values["Section"] = ""
                    values["Parameter"] = parameter
                    values["Value"] = value.split("#")[0].strip() if value is not None and "#" in value else value
                    values["Description"] = value.split("#")[1].strip() if value is not None and "#" in value else ""
                    if value is None:
                        values["Value"] = ""

                    item_child = QTreeWidgetItem([f"{values['Section']}",
                                                  f"{values['Parameter']}",
                                                  f"{values['Value']}",
                                                  f"{values['Description']}"])
                    subitem.addChild(item_child)

            self.tree_config_files.addTopLevelItem(item)


    def _set_config_value(self, item, column):

        if column == 2:
            file_name = item.parent().parent().text(0).replace(".config", "")
            section = item.parent().text(0)
            parameter = item.text(1)
            value = item.text(2)
            tools_gw.set_config_parser(section, parameter, value, file_name=file_name, prefix=False, chk_user_params=False)


    def _double_click_event(self, item, column):

        tmp = item.flags()
        if column == 2 and item.text(2):
            item.setFlags(tmp | Qt.ItemIsEditable)


    def _set_log_sql(self):

        log_sql = tools_gw.get_config_parser("system", f"log_sql", "user", "init", False, get_none=True)
        if log_sql in ("False", "None"):
            message = "Variable log_sql from user config file has been enabled."
            tools_gw.set_config_parser("system", "log_sql", "True", file_name="init", prefix=False)
        else:
            message = "Variable log_sql from user config file has been disabled."
            tools_gw.set_config_parser("system", "log_sql", "None", file_name="init", prefix=False)

        tools_qgis.show_info(message)

    # endregion
