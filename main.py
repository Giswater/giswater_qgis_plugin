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
from .core.utils.signal_manager import GwSignalManager
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
        self.iface = iface
        self.load_project = None
        self.btn_add_layers = None
        self.action = None
        self.action_info = None


    def initGui(self):
        """ Create the menu entries and toolbar icons inside the QGIS GUI """

        # Initialize plugin
        if self._init_plugin():
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
        except Exception as e:
            print(f"Exception in unload when reset values for global_vars.project_vars: {e}")

        try:
            # Remove Giswater dockers
            self._remove_dockers()
        except Exception as e:
            print(f"Exception in unload when self._remove_dockers(): {e}")

        try:
            # Close all open dialogs
            self._close_open_dialogs()
        except Exception as e:
            print(f"Exception in unload when self._close_open_dialogs(): {e}")
            raise e

        try:
            # Force action pan
            self.iface.actionPan().trigger()
        except Exception as e:
            print(f"Exception in unload when self.iface.actionPan().trigger(): {e}")

        try:
            # Disconnect QgsProject.instance().crsChanged signal
            tools_gw.disconnect_signal('load_project', 'project_read_crsChanged_set_epsg')
        except Exception as e:
            print(f"Exception in unload when disconnecting QgsProject.instance().crsChanged signal: {e}")

        try:
            # Remove 'Main Info button'
            self._unset_info_button()
        except Exception as e:
            print(f"Exception in unload when self._unset_info_button(): {e}")

        try:
            # Remove 'Add child layer button'
            self._unset_child_layer_button()
        except Exception as e:
            print(f"Exception in unload when self._unset_child_layer_button(): {e}")

        try:
            # Remove file handler when reloading
            if hide_gw_button:
                global_vars.logger.close_logger()
        except Exception as e:
            print(f"Exception in unload when global_vars.logger.close_logger(): {e}")

        try:
            # Remove 'Giswater menu'
            self._unset_giswater_menu()
        except Exception as e:
            print(f"Exception in unload when self._unset_giswater_menu(): {e}")

        try:
            # Set 'Main Info button' if project is unload or project don't have layers
            layers = QgsProject.instance().mapLayers().values()
            if hide_gw_button is False and len(layers) == 0:
                self._set_info_button()
        except Exception as e:
            print(f"Exception in unload when self._set_info_button(): {e}")

        try:
            # Unlisten notify channel and stop thread
            if hasattr(global_vars, 'notify'):
                list_channels = ['desktop', global_vars.current_user]
                if global_vars.notify:
                    global_vars.notify.stop_listening(list_channels)
        except Exception as e:
            print(f"Exception in unload when global_vars.notify.stop_listening(list_channels): {e}")

        try:
            # Check if project is current loaded and remove giswater action from PluginMenu and Toolbars
            if self.load_project:
                global_vars.project_type = None
                if self.load_project.buttons != {}:
                    for button in list(self.load_project.buttons.values()):
                        self.iface.removePluginMenu(self.plugin_name, button.action)
                        self.iface.removeToolBarIcon(button.action)
        except Exception as e:
            print(f"Exception in unload when self.iface.removePluginMenu(self.plugin_name, button.action): {e}")

        try:
            # Check if project is current loaded and remove giswater toolbars from qgis
            if self.load_project:
                if self.load_project.plugin_toolbars:
                    for plugin_toolbar in list(self.load_project.plugin_toolbars.values()):
                        if plugin_toolbar.enabled:
                            plugin_toolbar.toolbar.setVisible(False)
                            del plugin_toolbar.toolbar
        except Exception as e:
            print(f"Exception in unload when del plugin_toolbar.toolbar: {e}")

        self.load_project = None


    # region private functions


    def _init_plugin(self):
        """ Plugin main initialization function """

        # Initialize plugin global variables
        plugin_dir = os.path.dirname(__file__)
        global_vars.plugin_dir = plugin_dir
        global_vars.iface = self.iface
        self.plugin_name = tools_qgis.get_plugin_metadata('name', 'giswater', plugin_dir)
        self.icon_folder = f"{plugin_dir}{os.sep}icons{os.sep}dialogs{os.sep}20x20{os.sep}"
        major_version = tools_qgis.get_major_version(plugin_dir=plugin_dir)
        user_folder_dir = f'{tools_os.get_datadir()}{os.sep}{self.plugin_name.capitalize()}{os.sep}{major_version}'
        global_vars.init_global(self.iface, self.iface.mapCanvas(), plugin_dir, self.plugin_name, user_folder_dir)

        # Create log file
        min_log_level = 20
        tools_log.set_logger(self.plugin_name, min_log_level)
        tools_log.log_info("Initialize plugin")

        # Check if config file exists
        setting_file = os.path.join(plugin_dir, 'config', 'giswater.config')
        if not os.path.exists(setting_file):
            message = f"Config file not found at: {setting_file}"
            tools_qgis.show_warning(message)
            return False

        # Set plugin and QGIS settings: stored in the registry (on Windows) or .ini file (on Unix)
        global_vars.init_giswater_settings(setting_file)
        global_vars.init_qgis_settings(self.plugin_name)

        # Check if user config folder exists
        self._manage_user_config_folder(global_vars.user_folder_dir)

        # Initialize parsers of configuration files: init, session, giswater, user_params
        tools_gw.initialize_parsers()

        # Check if user has config files 'init' and 'session' and its parameters (only those without prefix)
        tools_gw.user_params_to_userconfig()

        # Set logger parameters min_log_level and log_limit_characters
        min_log_level = int(tools_gw.get_config_parser('log', 'log_level', 'user', 'init', False))
        log_limit_characters = int(tools_gw.get_config_parser('log', 'log_limit_characters', 'user', 'init', False))
        log_db_limit_characters = int(tools_gw.get_config_parser('log', 'log_db_limit_characters', 'user', 'init', 200))
        global_vars.logger.set_logger_parameters(min_log_level, log_limit_characters, log_db_limit_characters)

        # Enable Python console and Log Messages panel if parameter 'enable_python_console' = True
        python_enable_console = tools_gw.get_config_parser('system', 'enable_python_console', 'project', 'giswater')
        if python_enable_console == 'TRUE':
            tools_qgis.enable_python_console()

        # Set init parameter 'exec_procedure_max_retries'
        global_vars.exec_procedure_max_retries = int(tools_gw.get_config_parser('system', 'exec_procedure_max_retries', 'user', 'init', False))

        # Create the GwSignalManager
        self._create_signal_manager()

        # Define signals
        self._set_signals()

        # Set main information button (always visible)
        self._set_info_button()

        return True


    def _create_signal_manager(self):
        """ Creates an instance of GwSignalManager and connects all the signals """

        global_vars.signal_manager = GwSignalManager()
        global_vars.signal_manager.show_message.connect(tools_qgis.show_message)
        global_vars.signal_manager.refresh_selectors.connect(tools_gw.refresh_selectors)


    def _manage_user_config_folder(self, user_folder_dir):
        """ Check if user config folder exists. If not create empty files init.config and session.config """

        try:
            config_folder = f"{user_folder_dir}{os.sep}config{os.sep}"
            if not os.path.exists(config_folder):
                tools_log.log_info(f"Creating user config folder: {config_folder}")
                os.makedirs(config_folder)

            # Check if config files exists. If not create them empty
            filepath = f"{config_folder}{os.sep}init.config"
            if not os.path.exists(filepath):
                open(filepath, 'a').close()
            filepath = f"{config_folder}{os.sep}session.config"
            if not os.path.exists(filepath):
                open(filepath, 'a').close()

        except Exception as e:
            tools_log.log_warning(f"manage_user_config_folder: {e}")


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
        main_toolbutton = QToolButton()
        self.action_info = self.iface.addToolBarWidget(main_toolbutton)

        # Set icon button if exists
        icon_path = self.icon_folder + '36.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "Show info", self.iface.mainWindow())
        else:
            self.action = QAction("Show info", self.iface.mainWindow())

        main_toolbutton.setDefaultAction(self.action)
        admin_button = GwAdminButton()
        self.action.triggered.connect(partial(admin_button.init_sql, True))


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
            # TODO: manage this better, deleteLater() is not fast enough and deletes the docker after opening the search
            #  again on load_project.py --> if tools_os.set_boolean(open_search)
            docker_search.deleteLater()

        # Get 'Docker' docker form from qgis iface and remove it if exists
        docker_info = self.iface.mainWindow().findChild(QDockWidget, 'docker')
        if docker_info:
            self.iface.removeDockWidget(docker_info)

        # Remove 'current_selections' docker
        if global_vars.session_vars['current_selections']:
            self.iface.removeDockWidget(global_vars.session_vars['current_selections'])
            global_vars.session_vars['current_selections'].deleteLater()
            global_vars.session_vars['current_selections'] = None

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
                   not getattr(x, "isHidden", False) and (issubclass(type(x), GwMainWindow) or issubclass(type(x), GwDialog))]

        # Close them
        for window in windows:
            try:
                tools_gw.close_dialog(window)
            except Exception as e:
                print(f"Exception in _close_open_dialogs: {e}")

    # endregion
