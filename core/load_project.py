"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.core import QgsProject
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtWidgets import QToolBar, QActionGroup, QDockWidget

from .models.plugin_toolbar import GwPluginToolbar
from .shared.search import GwSearch
from .toolbars import buttons
from .ui.ui_manager import GwDialogTextUi, GwSearchUi
from .utils import tools_gw
from .load_project_menu import GwMenuLoad
from .threads.notify import GwNotify
from .. import global_vars
from ..lib import tools_qgis, tools_log, tools_db, tools_qt, tools_os


class GwLoadProject(QObject):

    def __init__(self):
        """ Class to manage layers. Refactor code from main.py """

        super().__init__()
        self.iface = global_vars.iface
        self.plugin_toolbars = {}
        self.buttons_to_hide = []
        self.buttons = {}


    def project_read(self, show_warning=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        tools_gw.remove_deprecated_config_vars()

        self._get_user_variables()

        # Check if loaded project is valid for Giswater
        if not self._check_project(show_warning):
            return

        # Force commit before opening project and set new database connection
        if not self._check_database_connection(show_warning):
            return

        # Get variables from qgis project
        tools_qgis.get_project_variables()

        # Get water software from table 'sys_version'
        global_vars.project_type = tools_gw.get_project_type()
        if global_vars.project_type is None:
            return

        # Check if user has all config params
        tools_gw.user_params_to_userconfig()

        # Manage schema name
        tools_db.get_current_user()
        layer_source = tools_qgis.get_layer_source(self.layer_node)
        schema_name = layer_source['schema']
        if schema_name:
            global_vars.schema_name = schema_name.replace('"', '')

        # Check for developers options
        value = tools_gw.get_config_parser('system', 'log_sql', "user", "init", False)
        tools_qgis.user_parameters['log_sql'] = value
        value = tools_gw.get_config_parser('system', 'show_message_durations', "user", "init", False)
        tools_qgis.user_parameters['show_message_durations'] = value

        # Manage locale and corresponding 'i18n' file
        global_vars.plugin_name = tools_qgis.get_plugin_metadata('name', 'giswater', global_vars.plugin_dir)
        tools_qt.manage_translation(global_vars.plugin_name)

        # Set PostgreSQL parameter 'search_path'
        tools_db.set_search_path(layer_source['schema'])

        # Check if schema exists
        schema_exists = tools_db.check_schema(global_vars.schema_name)
        if not schema_exists:
            tools_qgis.show_warning("Selected schema not found", parameter=global_vars.schema_name)

        # Get SRID from table node
        global_vars.data_epsg = tools_db.get_srid('v_edit_node', global_vars.schema_name)

        # Check that there are no layers (v_edit_node) with the same view name, coming from different schemes
        status = self._check_layers_from_distinct_schema()
        if status is False:
            return

        # Open automatically 'search docker' depending its value in user settings
        open_search = tools_gw.get_config_parser('btn_search', 'open_search', "user", "session")
        if tools_os.set_boolean(open_search):
            dlg_search = GwSearchUi()
            GwSearch().open_search(dlg_search, load_project=True)

        # Get feature cat
        global_vars.feature_cat = tools_gw.manage_feature_cat()

        # Create menu
        load_project_menu = GwMenuLoad()
        load_project_menu.read_menu()

        # Manage snapping layers
        self._manage_snapping_layers()

        # Manage actions of the different plugin_toolbars
        self._manage_toolbars()

        # Check roles of this user to show or hide toolbars
        self._check_user_roles()

        # call dynamic mapzones repaint
        tools_gw.set_style_mapzones()

        # Create a thread to listen selected database channels
        global_vars.notify = GwNotify()
        list_channels = ['desktop', global_vars.current_user]
        global_vars.notify.start_listening(list_channels)

        # Reset some session/init user variables as vdefault
        if tools_gw.get_config_parser('system', 'reset_user_variables', 'user', 'init', prefix=False):
            self._manage_reset_user_variables()

        # Set global_vars.project_epsg
        global_vars.project_epsg = tools_qgis.get_epsg()
        QgsProject.instance().crsChanged.connect(tools_gw.set_epsg)

        # Log it
        message = "Project read successfully"
        tools_log.log_info(message)


    # region private functions


    def _get_user_variables(self):
        """ Get config related with user variables """

        global_vars.user_level['level'] = tools_gw.get_config_parser('system', 'user_level', "user", "init", False)
        global_vars.user_level['showquestion'] = tools_gw.get_config_parser('user_level', 'showquestion', "user", "init", False)
        global_vars.user_level['showsnapmessage'] = tools_gw.get_config_parser('user_level', 'showsnapmessage', "user", "init", False)
        global_vars.user_level['showselectmessage'] = tools_gw.get_config_parser('user_level', 'showselectmessage', "user", "init", False)
        global_vars.user_level['showadminadvanced'] = tools_gw.get_config_parser('user_level', 'showadminadvanced', "user", "init", False)
        global_vars.date_format = tools_gw.get_config_parser('system', 'date_format', "user", "init", False)


    def _check_project(self, show_warning):
        """ Check if loaded project is valid for Giswater """

        # Check if table 'v_edit_node' is loaded
        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        if not self.layer_node and show_warning:
            layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")
            layer_connec = tools_qgis.get_layer_by_tablename("v_edit_connec")
            if layer_arc or layer_connec:
                title = "Giswater plugin cannot be loaded"
                msg = "QGIS project seems to be a Giswater project, but layer 'v_edit_node' is missing"
                tools_qgis.show_warning(msg, 20, title=title)
                return False

        return True


    def _check_database_connection(self, show_warning, force_commit=False):
        """ Set new database connection. If force_commit=True then force commit before opening project """

        try:
            if global_vars.dao and force_commit:
                tools_log.log_info("Force commit")
                global_vars.dao.commit()
        except Exception as e:
            tools_log.log_info(str(e))
        finally:
            self.connection_status, not_version, layer_source = tools_db.set_database_connection()
            if not self.connection_status or not_version:
                message = global_vars.session_vars['last_error']
                if show_warning:
                    if message:
                        tools_qgis.show_warning(message, 15)
                    tools_log.log_warning(str(layer_source))
                return False

            return True


    def _check_layers_from_distinct_schema(self):
        """
            Checks if there are duplicate layers in any of the defined schemas from project_vars.

            :returns: False if there are duplicate layers and project_vars main_schema or add_schema
            haven't been set.
        """

        layers = tools_qgis.get_project_layers()
        repeated_layers = {}
        for layer in layers:
            layer_toc_name = tools_qgis.get_layer_source_table_name(layer)
            if layer_toc_name == 'v_edit_node':
                layer_source = tools_qgis.get_layer_source(layer)
                repeated_layers[layer_source['schema'].replace('"', '')] = 'v_edit_node'

        if len(repeated_layers) > 1:
            if global_vars.project_vars['main_schema'] is None or global_vars.project_vars['add_schema'] is None:
                self.dlg_dtext = GwDialogTextUi()
                self.dlg_dtext.btn_accept.hide()
                self.dlg_dtext.btn_close.clicked.connect(lambda: self.dlg_dtext.close())
                msg = "QGIS project has more than one v_edit_node layer coming from different schemas. " \
                      "If you are looking to manage two schemas, it is mandatory to define which is the master and " \
                      "which isn't. To do this, you need to configure the QGIS project setting this project's " \
                      "variables: gwMainSchema and gwAddSchema."

                self.dlg_dtext.txt_infolog.setText(msg)
                self.dlg_dtext.open()
                return False

            # If there are layers with a different schema, the one that the user has in the project variable
            # 'gwMainSchema' is taken as the schema_name.
            if global_vars.project_vars['main_schema'] not in (None, 'NULL', ''):
                global_vars.schema_name = global_vars.project_vars['main_schema']

        return True


    def _get_buttons_to_hide(self):
        """ Get all buttons to hide """

        buttons_to_hide = None
        try:
            row = tools_gw.get_config_parser('qgis_toolbar_hidebuttons', 'buttons_to_hide', "user", "init")
            if not row or row in (None, 'None'):
                return None

            buttons_to_hide = [int(x) for x in row.split(',')]

        except Exception as e:
            tools_log.log_warning(f"{type(e).__name__}: {e}")
        finally:
            return buttons_to_hide


    def _manage_toolbars(self):
        """ Manage actions of the custom plugin toolbars """

        # Dynamically get list of toolbars from config file
        toolbar_names = tools_gw.get_config_parser('toolbars', 'list_toolbars', "project", "giswater")
        if toolbar_names in (None, 'None'):
            return

        toolbars_order = tools_gw.get_config_parser('toolbars_position', 'toolbars_order', 'user', 'init')
        toolbars_order = toolbars_order.replace(' ', '').split(',')

        # Call each of the functions that configure the toolbars 'def toolbar_xxxxx(self, toolbar_id, x=0, y=0):'
        for tb in toolbars_order:
            self._create_toolbar(tb)

        # Manage action group of every toolbar
        icon_folder = global_vars.plugin_dir + os.sep + 'icons' + os.sep + 'toolbars' + os.sep
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            ag.setProperty('gw_name', 'gw_QActionGroup')
            for index_action in plugin_toolbar.list_actions:
                successful = False
                count_trys = 0
                while not successful and count_trys < 10:
                    button_def = tools_gw.get_config_parser('buttons_def', str(index_action), "project", "giswater")
                    if button_def not in (None, 'None'):
                        text = tools_qt.tr(f'{index_action}_text')
                        icon_path = icon_folder + plugin_toolbar.toolbar_id + os.sep + index_action + ".png"
                        button = getattr(buttons, button_def)(icon_path, button_def, text, plugin_toolbar.toolbar, ag)
                        self.buttons[index_action] = button
                        successful = True
                    count_trys = count_trys + 1

        # Disable buttons which are project type exclusive
        project_exclusive = None
        successful = False
        count_trys = 0
        while not successful and count_trys < 10:
            project_exclusive = tools_gw.get_config_parser('project_exclusive', global_vars.project_type, "project", "giswater")
            if project_exclusive not in (None, "None"):
                successful = True
            count_trys = count_trys + 1

        if project_exclusive not in (None, 'None'):
            project_exclusive = project_exclusive.replace(' ', '').split(',')
            for index in project_exclusive:
                self._hide_button(index)

        # Hide buttons from buttons_to_hide
        buttons_to_hide = self._get_buttons_to_hide()
        if buttons_to_hide:
            for button_id in buttons_to_hide:
                self._hide_button(button_id)

        # Disable and hide all plugin_toolbars and actions
        self._enable_toolbars(False)

        # Enable toolbars: 'basic', 'utilities', 'toc'
        self._enable_toolbar("basic")
        self._enable_toolbar("utilities")
        self._enable_toolbar("toc")


    def _create_toolbar(self, toolbar_id):

        list_actions = tools_gw.get_config_parser('toolbars', str(toolbar_id), "project", "giswater")
        if list_actions in (None, 'None'):
            return

        list_actions = list_actions.replace(' ', '').split(',')
        if type(list_actions) != list:
            list_actions = [list_actions]

        toolbar_name = tools_qt.tr(f'toolbar_{toolbar_id}_name')
        plugin_toolbar = GwPluginToolbar(toolbar_id, toolbar_name, True)

        # If the toolbar is ToC, add it to the Layers docker toolbar, if not, create a new toolbar
        if toolbar_id == "toc":
            plugin_toolbar.toolbar = self.iface.mainWindow().findChild(QDockWidget, 'Layers').findChildren(QToolBar)[0]
        else:
            plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)

        plugin_toolbar.toolbar.setObjectName(toolbar_name)
        plugin_toolbar.toolbar.setProperty('gw_name', toolbar_id)
        plugin_toolbar.list_actions = list_actions
        self.plugin_toolbars[toolbar_id] = plugin_toolbar


    def _manage_snapping_layers(self):
        """ Manage snapping of layers """

        tools_qgis.manage_snapping_layer('v_edit_arc', snapping_type=2)
        tools_qgis.manage_snapping_layer('v_edit_connec', snapping_type=0)
        tools_qgis.manage_snapping_layer('v_edit_node', snapping_type=0)
        tools_qgis.manage_snapping_layer('v_edit_gully', snapping_type=0)


    def _check_user_roles(self):
        """ Check roles of this user to show or hide toolbars """

        if 'project_role' in global_vars.project_vars:
            restriction = tools_gw.get_role_permissions(global_vars.project_vars['project_role'])
        else:
            restriction = tools_gw.get_role_permissions(None)

        if restriction == 'role_basic':
            return

        elif restriction == 'role_om':
            self._enable_toolbar("om")
            return

        elif restriction == 'role_edit':
            self._enable_toolbar("om")
            self._enable_toolbar("edit")
            self._enable_toolbar("cad")

        elif restriction == 'role_epa':
            self._enable_toolbar("om")
            self._enable_toolbar("edit")
            self._enable_toolbar("cad")
            self._enable_toolbar("epa")

        elif restriction == 'role_master' or restriction == 'role_admin':
            self._enable_toolbar("om")
            self._enable_toolbar("edit")
            self._enable_toolbar("cad")
            self._enable_toolbar("epa")
            self._enable_toolbar("plan")

        # Check if exist some feature_cat with active True on cat_feature table
        self.feature_cat = global_vars.feature_cat
        if self.feature_cat is None:
            self._enable_button("01", False)
            self._enable_button("02", False)


    def _enable_toolbars(self, visible=True):
        """ Enable/disable all plugin toolbars from QGIS GUI """

        # Enable/Disable actions
        self._enable_all_buttons(visible)
        try:
            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(visible)
        except Exception as e:
            tools_log.log_warning(str(e))


    def _enable_all_buttons(self, enable=True):
        """ Utility to enable/disable all buttons """

        for index in self.buttons.keys():
            self._enable_button(index, enable)


    def _enable_button(self, button_id, enable=True):
        """ Enable/disable selected button """

        key = str(button_id).zfill(2)
        if key in self.buttons:
            self.buttons[key].action.setEnabled(enable)


    def _hide_button(self, button_id, hide=True):
        """ Enable/disable selected action """

        key = str(button_id).zfill(2)
        if key in self.buttons:
            self.buttons[key].action.setVisible(not hide)


    def _enable_toolbar(self, toolbar_id, enable=True):
        """ Enable/Disable toolbar. Normally because user has no permission """

        if toolbar_id in self.plugin_toolbars:
            plugin_toolbar = self.plugin_toolbars[toolbar_id]
            plugin_toolbar.toolbar.setVisible(enable)
            for index_action in plugin_toolbar.list_actions:
                self._enable_button(index_action, enable)


    def _manage_reset_user_variables(self):

        # Set dlg_selector_basic as tab_exploitation
        tools_gw.set_config_parser("dialogs_tab", f"dlg_selector_basic", f"tab_exploitation", "user", "session")

    # endregion
