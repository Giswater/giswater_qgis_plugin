"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from functools import partial
from qgis.core import QgsProject
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QDockWidget, QToolBar, QToolButton, QMenu, QApplication

from . import global_vars
from .core.admin.admin_btn import GwAdminButton
from .core.load_project import GwLoadProject
from .core.utils import tools_gw
from .lib import tools_qgis, tools_os, tools_log
from .core.ui.dialog import GwDialog
from .core.ui.main_window import GwMainWindow


class Giswater(QObject):

    def __init__(self, iface):
        """
        Constructor
            :param iface: An interface instance that will be passed to this class
                which provides the hook by which you can manipulate the QGIS
                application at run time. (QgsInterface)
        """

        super(Giswater, self).__init__()

        # Initialize instance attributes
        self.iface = iface
        self.srid = None
        self.load_project = None
        self.dict_toolbars = {}
        self.dict_actions = {}
        self.actions_not_checkable = None
        self.available_layers = []
        self.btn_add_layers = None
        self.update_sql = None
        self.action = None
        self.action_info = None
        self.toolButton = None


    def initGui(self):
        """ Create the menu entries and toolbar icons inside the QGIS GUI """

        # Initialize plugin
        self._init_plugin()

        # Force project read (to work with PluginReloader)
        self._project_read(False, False)


    def unload(self, hide_gw_button=True):
        """
        Removes plugin menu items and icons from QGIS GUI
            :param hide_gw_button: is True when plugin is disabled or reloaded
        """

        try:

            # Reset values for global_vars.project_vars
            global_vars.project_vars['info_type'] = None
            global_vars.project_vars['add_schema'] = None
            global_vars.project_vars['main_schema'] = None
            global_vars.project_vars['project_role'] = None
            global_vars.project_vars['project_type'] = None

            # Remove Giswater dockers
            self._remove_dockers()

            # Close all open dialogs
            self._close_open_dialogs()

            # Force action pan
            self.iface.actionPan().trigger()

            # Remove 'Main Info button'
            self._unset_info_button()

            # Remove 'Add child layer button'
            self._unset_child_layer_button()

            # Remove file handler when reloading
            if hide_gw_button:
                global_vars.logger.close_logger()

            # Remove 'Giswater menu'
            self._unset_giswater_menu()

            # Set 'Main Info button' if project is unload or project don't have layers
            layers = QgsProject.instance().mapLayers().values()
            if hide_gw_button is False and len(layers) == 0:
                self._set_info_button()

            # Unlisten notify channel and stop thread
            if hasattr(global_vars, 'notify'):
                list_channels = ['desktop', global_vars.current_user]
                if global_vars.notify:
                    global_vars.notify.stop_listening(list_channels)

            # Check if project is current loaded and remove giswater action from PluginMenu and Toolbars
            if self.load_project:
                global_vars.project_type = None
                if self.load_project.buttons != {}:
                    for button in list(self.load_project.buttons.values()):
                        self.iface.removePluginMenu(self.plugin_name, button.action)
                        self.iface.removeToolBarIcon(button.action)

            # Check if project is current loaded and remove giswater toolbars from qgis
            if self.load_project:
                if self.load_project.plugin_toolbars:
                    for plugin_toolbar in list(self.load_project.plugin_toolbars.values()):
                        if plugin_toolbar.enabled:
                            plugin_toolbar.toolbar.setVisible(False)
                            del plugin_toolbar.toolbar

        except Exception as e:
            print(f"Exception in unload: {e}")
        finally:
            self.load_project = None


    # region private functions


    def _init_plugin(self):
        """ Plugin main initialization function """

        # Initialize plugin global variables
        self.plugin_dir = os.path.dirname(__file__)
        global_vars.plugin_dir = self.plugin_dir
        global_vars.iface = self.iface
        self.plugin_name = tools_qgis.get_plugin_metadata('name', 'giswater', self.plugin_dir)
        major_version = tools_qgis.get_major_version(plugin_dir=self.plugin_dir)
        user_folder_dir = f'{tools_os.get_datadir()}{os.sep}{self.plugin_name.capitalize()}{os.sep}{major_version}'
        global_vars.init_global(self.iface, self.iface.mapCanvas(), self.plugin_dir, self.plugin_name, user_folder_dir)
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep

        # Check if config file exists
        setting_file = os.path.join(self.plugin_dir, 'config', 'giswater.config')
        if not os.path.exists(setting_file):
            message = f"Config file not found at: {setting_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return

        # Set plugin and QGIS settings: stored in the registry (on Windows) or .ini file (on Unix)
        global_vars.init_giswater_settings(setting_file)
        global_vars.init_qgis_settings(self.plugin_name)

        # Enable Python console and Log Messages panel if parameter 'enable_python_console' = True
        python_enable_console = tools_gw.get_config_parser('system', 'enable_python_console', 'project', 'giswater')
        if python_enable_console == 'TRUE':
            tools_qgis.enable_python_console()

        # Set logger (no database connection yet)
        min_log_level = int(tools_gw.get_config_parser('system', 'log_level', 'user', 'init', False))
        tools_log.min_log_level = min_log_level
        log_limit_characters = tools_gw.get_config_parser('system', 'log_limit_characters', 'user', 'init', False)
        tools_log.set_logger(self.plugin_name, log_limit_characters)
        tools_log.log_info("Initialize plugin")

        # Check if user has config params (only params without prefix)
        tools_gw.user_params_to_userconfig()

        # Define signals
        self._set_signals()

        # Set main information button (always visible)
        self._set_info_button()

        # Manage section 'actions_list' of config file
        self._manage_section_actions_list()

        # Manage section 'toolbars' of config file
        self._manage_section_toolbars()


    def _set_signals(self):
        """ Define iface event signals on Project Read / New Project / Save Project """

        try:
            self.iface.projectRead.connect(self._project_read)
            self.iface.newProjectCreated.connect(self._project_new)
            self.iface.actionSaveProject().triggered.connect(self._save_toolbars_position)
        except AttributeError:
            pass


    def _set_info_button(self):
        """ Set Giswater information button (always visible)
            If project is loaded show information form relating to Plugin Giswater
            Else open admin form with which can manage database and qgis projects
        """

        # Create instance class and add button into QGIS toolbar
        self.toolButton = QToolButton()
        self.action_info = self.iface.addToolBarWidget(self.toolButton)

        # Set icon button if exists
        icon_path = self.icon_folder + '36.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "Show info", self.iface.mainWindow())
        else:
            self.action = QAction("Show info", self.iface.mainWindow())

        self.toolButton.setDefaultAction(self.action)
        self.update_sql = GwAdminButton()
        self.action.triggered.connect(partial(self.update_sql.init_sql, True))


    def _unset_info_button(self):
        """ Unset Giswater information button (when plugin is disabled or reloaded) """

        # Disconnect signal from action if exists
        if self.action:
            self.action.triggered.disconnect()

        # Remove button from toolbar if exists
        if self.action_info:
            self.iface.removeToolBarIcon(self.action_info)

        # Set action and button as None
        self.action = None
        self.action_info = None


    def _unset_child_layer_button(self):
        """ Unset Add Child Layer button (when plugin is disabled or reloaded) """

        action = self.iface.mainWindow().findChild(QAction, "GwAddChildLayerButton")
        if action not in (None, "None"):
            action.deleteLater()


    def _unset_giswater_menu(self):
        """ Unset Giswater menu (when plugin is disabled or reloaded) """

        menu_giswater = self.iface.mainWindow().menuBar().findChild(QMenu, "Giswater")
        if menu_giswater not in (None, "None"):
            menu_giswater.deleteLater()


    def _manage_section_actions_list(self):
        """ Manage section 'actions_list' of config file """

        # Dynamically get parameters defined in section 'actions_list' from qgis variables into 'list_keys'
        section = 'actions_not_checkable'
        global_vars.giswater_settings.beginGroup(section)
        list_keys = global_vars.giswater_settings.allKeys()
        global_vars.giswater_settings.endGroup()

        # Get value for every key and append into 'self.dict_actions' dictionary
        for key in list_keys:
            list_values = global_vars.giswater_settings.value(f"{section}/{key}")
            if list_values:
                self.dict_actions[key] = list_values
            else:
                tools_qgis.show_warning(f"Parameter not set in section '{section}' of config file: '{key}'")

        # Get list of actions not checkable (normally because they open a form)
        aux = []
        for list_actions in self.dict_actions.values():
            for elem in list_actions:
                aux.append(elem)

        self.actions_not_checkable = sorted(aux)


    def _manage_section_toolbars(self):
        """ Manage section 'toolbars' of config file """

        # Dynamically get parameters defined in section 'toolbars' from qgis variables into 'list_keys'
        section = 'toolbars'
        global_vars.giswater_settings.beginGroup(section)
        list_keys = global_vars.giswater_settings.allKeys()
        global_vars.giswater_settings.endGroup()

        # Get value for every key and append into 'self.dict_toolbars' dictionary
        for key in list_keys:
            list_values = global_vars.giswater_settings.value(f"{section}/{key}")
            if list_values:
                # Check if list_values has only one value
                if type(list_values) is str:
                    list_values = [list_values]
                self.dict_toolbars[key] = list_values
            else:
                tools_qgis.show_warning(f"Parameter not set in section '{section}' of config file: '{key}'")


    def _project_new(self):
        """ Function executed when a user creates a new QGIS project """

        # Unload plugin when create new QGIS project
        self.unload(False)


    def _project_read(self, show_warning=True, hide_gw_button=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Unload plugin before reading opened project
        self.unload(hide_gw_button)

        # Add file handler
        if hide_gw_button:
            global_vars.logger.add_file_handler()

        # Create class to manage code that performs project configuration
        self.load_project = GwLoadProject()
        self.load_project.project_read(show_warning)


    def _save_toolbars_position(self):

        # Get all QToolBar from qgis iface
        widget_list = self.iface.mainWindow().findChildren(QToolBar)
        own_toolbars = []

        # Get list with own QToolBars
        for w in widget_list:
            if w.property('gw_name'):
                own_toolbars.append(w)

        # Order list of toolbar in function of X position
        own_toolbars = sorted(own_toolbars, key=lambda k: k.x())
        if len(own_toolbars) == 0 or (len(own_toolbars) == 1 and own_toolbars[0].property('gw_name') == 'toc') or \
                global_vars.project_type is None:
            return

        # Set 'toolbars_order' parameter on 'toolbars_position' section on init.config user file (found in user path)
        sorted_toolbar_ids = [tb.property('gw_name') for tb in own_toolbars]
        sorted_toolbar_ids = ",".join(sorted_toolbar_ids)
        tools_gw.set_config_parser('toolbars_position', 'toolbars_order', str(sorted_toolbar_ids), "user", "init")


    def _remove_dockers(self):
        """ Remove Giswater dockers """

        # Get 'Search' docker form from qgis iface and remove it if exists
        docker_search = self.iface.mainWindow().findChild(QDockWidget, 'dlg_search')
        if docker_search:
            self.iface.removeDockWidget(docker_search)
            docker_search.deleteLater()

        # Get 'Docker' docker form from qgis iface and remove it if exists
        docker_info = self.iface.mainWindow().findChild(QDockWidget, 'docker')
        if docker_info:
            self.iface.removeDockWidget(docker_info)

        # Manage 'dialog_docker' from global_vars.session_vars and remove it if exists
        tools_gw.close_docker()

        # Get 'Layers' docker form and his actions from qgis iface and remove it if exists
        if self.btn_add_layers:
            dockwidget = self.iface.mainWindow().findChild(QDockWidget, 'Layers')
            toolbar = dockwidget.findChildren(QToolBar)[0]
            # TODO improve this, now remove last action
            toolbar.removeAction(toolbar.actions()[len(toolbar.actions()) - 1])
            self.btn_add_layers = None


    def _close_open_dialogs(self):
        """ Close Giswater open dialogs """

        # Get all widgets
        allwidgets = QApplication.allWidgets()

        # Only keep Giswater widgets that are currently open
        windows = [x for x in allwidgets if
                   not x.isHidden() and (issubclass(type(x), GwMainWindow) or issubclass(type(x), GwDialog))]

        # Close them
        for window in windows:
            tools_gw.close_dialog(window)

    # endregion
