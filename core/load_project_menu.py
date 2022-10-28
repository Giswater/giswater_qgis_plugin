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
from qgis.core import QgsApplication

from .toolbars import buttons
from .ui.ui_manager import GwLoadMenuUi
from .utils import tools_gw
from .. import global_vars
from ..lib import tools_log, tools_qt, tools_qgis, tools_os, tools_db
from .threads.project_layers_config import GwProjectLayersConfig


class GwMenuLoad(QObject):

    def __init__(self):
        """ Class to manage layers. Refactor code from main.py """

        super().__init__()
        self.iface = global_vars.iface


    def read_menu(self, project_loaded):
        """  """

        actions = self.iface.mainWindow().menuBar().actions()
        last_action = actions[-1]

        self.main_menu = QMenu("&Giswater", self.iface.mainWindow().menuBar())
        self.main_menu.setObjectName("Giswater")
        tools_gw.set_config_parser("menu", "load", "true", "project", "giswater")

        icon_folder = f"{global_vars.plugin_dir}{os.sep}icons"
        icon_path = f"{icon_folder}{os.sep}toolbars{os.sep}utilities{os.sep}99.png"
        config_icon = QIcon(icon_path)

        if project_loaded:
            # region Toolbar
            toolbars_menu = QMenu(f"Toolbars", self.iface.mainWindow().menuBar())
            icon_path = f"{icon_folder}{os.sep}dialogs{os.sep}24x24{os.sep}36.png"
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

                    if project_exclusive and index_action in project_exclusive:
                        continue

                    icon_path = f"{icon_folder}{os.sep}toolbars{os.sep}{toolbar}{os.sep}{index_action}.png"
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

                    # Check if the class associated to the button definition exists
                    if hasattr(buttons, button_def):
                        button_class = getattr(buttons, button_def)
                        action_function = button_class(icon_path, button_def, text, None, ag)
                        action = toolbar_submenu.addAction(icon, f"{text}")
                        shortcut_key = tools_gw.get_config_parser("toolbars_shortcuts", f"{index_action}", "user", "init", prefix=False)
                        if shortcut_key:
                            action.setShortcuts(QKeySequence(f"{shortcut_key}"))
                            global_vars.shortcut_keys.append(shortcut_key)
                        action.triggered.connect(partial(self._clicked_event, action_function))
                    else:
                        tools_log.log_warning(f"Class '{button_def}' not imported in file '{buttons.__file__}'")
            # endregion

            # region Actions
            actions_menu = QMenu(f"Actions", self.iface.mainWindow().menuBar())
            actions_menu.setIcon(config_icon)
            self.main_menu.addMenu(actions_menu)

            # Action 'Get help'
            action_help = actions_menu.addAction(f"Get help")
            action_help_shortcut = tools_gw.get_config_parser("actions_shortcuts", f"shortcut_help", "user", "init", prefix=False)
            if not action_help_shortcut:
                tools_gw.set_config_parser("actions_shortcuts", f"shortcut_help", f"{action_help_shortcut}", "user", "init",
                                           prefix=False)
            action_help.setShortcuts(QKeySequence(f"{action_help_shortcut}"))
            action_help.triggered.connect(tools_gw.open_dlg_help)

            # Action 'Reset dialogs'
            action_reset_dialogs = actions_menu.addAction(f"Reset dialogs")
            action_reset_dialogs.triggered.connect(self._reset_position_dialog)

            # Action 'Reset plugin
            action_reset_plugin = actions_menu.addAction(f"Reset plugin")
            action_reset_plugin_shortcut = tools_gw.get_config_parser("actions_shortcuts", f"shortcut_reset_plugin",
                "user", "init", prefix=False)
            if not action_reset_plugin_shortcut:
                tools_gw.set_config_parser("actions_shortcuts", f"shortcut_reset_plugin",
                    f"{action_reset_plugin_shortcut}", "user", "init", prefix=False)
            action_reset_plugin.setShortcuts(QKeySequence(f"{action_reset_plugin_shortcut}"))
            action_reset_plugin.triggered.connect(self._reset_plugin)

            # Action 'Show current selectors'
            action_open_selections = actions_menu.addAction(f"Show current selectors")
            action_open_selections_shortcut = tools_gw.get_config_parser("actions_shortcuts",
                f"shortcut_open_curselectors", "user", "init", prefix=False)
            if not action_open_selections_shortcut:
                tools_gw.set_config_parser("actions_shortcuts", f"shortcut_open_curselectors",
                    f"{action_open_selections_shortcut}", "user", "init", prefix=False)
            action_open_selections.setShortcuts(QKeySequence(f"{action_open_selections_shortcut}"))
            action_open_selections.triggered.connect(self._open_current_selections)

            # Action 'Toggle Log DB'
            action_set_log_sql = actions_menu.addAction(f"Toggle Log DB")
            log_sql_shortcut = tools_gw.get_config_parser("actions_shortcuts", f"shortcut_toggle_log_db", "user", "init", prefix=False)
            if not log_sql_shortcut:
                tools_gw.set_config_parser("actions_shortcuts", f"shortcut_toggle_log_db", f"{log_sql_shortcut}", "user",
                    "init", prefix=False)
            action_set_log_sql.setShortcuts(QKeySequence(f"{log_sql_shortcut}"))
            action_set_log_sql.triggered.connect(self._set_log_sql)

            # endregion

        # region Open plugin folder
        if global_vars.plugin_dir:
            icon_path = f"{icon_folder}{os.sep}dialogs{os.sep}20x20{os.sep}108.png"
            folder_icon = QIcon(icon_path)
            action_open_plugin_path = self.main_menu.addAction(f"Open plugin folder")
            action_open_plugin_path.setIcon(folder_icon)
            action_open_plugin_path.triggered.connect(self._open_plugin_path)
        # endregion

        # region Advanced
        action_manage_file = self.main_menu.addAction(f"Advanced")
        action_manage_file.triggered.connect(self._open_manage_file)
        icon_path = f"{icon_folder}{os.sep}dialogs{os.sep}20x20{os.sep}105.png"
        folder_icon = QIcon(icon_path)
        action_manage_file.setIcon(folder_icon)
        # endregion

        # region Open user folder
        if global_vars.user_folder_dir:
            log_folder = f"{global_vars.user_folder_dir}{os.sep}core{os.sep}log"
            size = tools_os.get_folder_size(log_folder)
            log_folder_volume = f"{round(size / (1024 * 1024), 2)} MB"
            icon_path = f"{icon_folder}{os.sep}dialogs{os.sep}20x20{os.sep}102.png"
            folder_icon = QIcon(icon_path)
            action_open_path = self.main_menu.addAction(f"Open user folder ({log_folder_volume})")
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

        path = os.path.realpath(global_vars.user_folder_dir)
        status, message = tools_os.open_file(path)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path)


    def _open_plugin_path(self):
        """ Opens the OS-specific Plugin directory """

        path = os.path.realpath(global_vars.plugin_dir)
        status, message = tools_os.open_file(path)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path)


    def _open_manage_file(self):
        """ Manage files dialog:: """

        tools_qgis.set_cursor_wait()
        self.dlg_manage_menu = GwLoadMenuUi()
        tools_gw.load_settings(self.dlg_manage_menu)

        # Manage widgets
        self.tree_config_files = self.dlg_manage_menu.findChild(QTreeWidget, 'tree_config_files')
        self.btn_close = self.dlg_manage_menu.findChild(QPushButton, 'btn_close')

        # Fill table_config_files
        self._fill_tbl_config_files()

        # Listeners
        self.btn_close.clicked.connect(partial(self.dlg_manage_menu.reject))
        self.dlg_manage_menu.rejected.connect(partial(tools_gw.close_dialog, self.dlg_manage_menu))

        tools_qgis.restore_cursor()

        message = "Changes on this page are dangerous and can break Giswater plugin in various ways. \n" \
                  "You will need to restart QGIS to apply changes. Do you want continue?"
        title = "Advanced Menu"
        answer = tools_qt.show_question(message, title)
        if not answer:
            return

        # Open dialog
        self.dlg_manage_menu.setWindowTitle(f'Advanced Menu')
        self.dlg_manage_menu.open()


    def _reset_position_dialog(self):
        """ Reset position dialog x/y """

        try:
            parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
            config_folder = f"{global_vars.user_folder_dir}{os.sep}config{os.sep}"
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

        path = f"{global_vars.user_folder_dir}{os.sep}core{os.sep}config"
        files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
        for file in files:
            item = QTreeWidgetItem([f"{file}"])

            project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater")
            parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
            parser.read(f"{global_vars.user_folder_dir}{os.sep}core{os.sep}config{os.sep}{file}")

            # For each section we create a sub-item and add all the parameters to that sub-item
            for section in parser.sections():
                subitem = QTreeWidgetItem([f"{section}"])
                item.addChild(subitem)
                for parameter in parser[section]:
                    if parameter[0:2] in project_types and global_vars.project_type != parameter[0:2]:
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

        # Sort items on QTreeWidget
        for index in range(self.tree_config_files.topLevelItemCount()):
            # Obtain the actual top-level item
            top_level_item = self.tree_config_files.topLevelItem(index)
            # Sort
            top_level_item.sortChildren(0, Qt.AscendingOrder)


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

        log_sql = tools_gw.get_config_parser("log", f"log_sql", "user", "init", False, get_none=True)
        if log_sql in ("False", "None"):
            message = "Variable log_sql from user config file has been enabled."
            tools_gw.set_config_parser("log", "log_sql", "True", file_name="init", prefix=False)
        else:
            message = "Variable log_sql from user config file has been disabled."
            tools_gw.set_config_parser("log", "log_sql", "None", file_name="init", prefix=False)

        tools_qgis.show_info(message)


    def _open_current_selections(self):

        if global_vars.session_vars['current_selections']:
            global_vars.iface.addDockWidget(Qt.LeftDockWidgetArea, global_vars.session_vars['current_selections'])


    def _reset_plugin(self):
        """ Called in reset plugin action """

        self._reset_notify()
        self._reset_snapping_managers()
        self._reset_all_rubberbands()
        tools_qgis.restore_cursor()  # Restore cursor in case it's stuck with an overridden one
        self.iface.actionPan().trigger()  # Force actionPan action
        self._reload_layers()  # Execute GwProjectLayersConfig thread


    def _reload_layers(self):
        """ Reloads all the layers """

        # Manage if task is already running
        if hasattr(self, 'task_get_layers') and self.task_get_layers is not None:
            try:
                if self.task_get_layers.isActive():
                    message = "ConfigLayerFields task is already active!"
                    tools_qgis.show_warning(message)
                    return
            except RuntimeError:
                pass

        schema_name = global_vars.schema_name.replace('"', '')
        sql = (f"SELECT DISTINCT(parent_layer) FROM cat_feature "
               f"UNION "
               f"SELECT DISTINCT(child_layer) FROM cat_feature "
               f"WHERE child_layer IN ("
               f"     SELECT table_name FROM information_schema.tables"
               f"     WHERE table_schema = '{schema_name}')")
        rows = tools_db.get_rows(sql)
        description = f"ConfigLayerFields"
        params = {"project_type": global_vars.project_type, "schema_name": global_vars.schema_name, "db_layers": rows,
                  "qgis_project_infotype": global_vars.project_vars['info_type']}
        self.task_get_layers = GwProjectLayersConfig(description, params)
        QgsApplication.taskManager().addTask(self.task_get_layers)
        QgsApplication.taskManager().triggerTask(self.task_get_layers)


    def _reset_snapping_managers(self):
        """ Deactivates all snapping managers """

        for i in range(0, len(global_vars.snappers)):
            global_vars.snappers[i].restore_snap_options(global_vars.snappers[i].recover_snapping_options())
            global_vars.snappers[i].set_snapping_status(False)
            global_vars.snappers[i].vertex_marker.hide()


    def _reset_all_rubberbands(self):
        """ Resets all active rubber bands """

        for i in range(0, len(global_vars.active_rubberbands)):
            global_vars.active_rubberbands[0].reset()
            global_vars.active_rubberbands.pop(0)


    def _reset_notify(self):
        """ Reset notify class """

        if global_vars.notify:
            global_vars.notify.stop_listening()
            global_vars.notify.start_listening()


    # endregion
