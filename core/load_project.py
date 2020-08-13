"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtWidgets import QToolBar, QActionGroup, QDockWidget

import os
import json
import configparser
from collections import OrderedDict
import sys

from .models.plugin_toolbar import PluginToolbar
from .utils.pg_man import PgMan
from .. import global_vars
from ..lib.qgis_tools import QgisTools
from ..ui_manager import DialogTextUi
from ..core.notify_tools import GwNotifyTools
from ..actions.parent import ParentAction

from .actions.basic.search import GwSearch

from .toolbars.basic.basic import *
from .toolbars.edit.edit import *
from .toolbars.cad.cad import *
from .toolbars.epa.epa import *
from .toolbars.toc.toc import *
from .toolbars.plan.plan import *
from .toolbars.utilities.utilities import *
from .toolbars.om.om import *


class LoadProject(QObject):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage layers. Refactor code from giswater.py """

        super(LoadProject, self).__init__()

        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.qgis_tools = QgisTools(iface, self.plugin_dir)
        self.pg_man = PgMan(controller)
        self.plugin_toolbars = {}
        self.buttons_to_hide = []
        self.plugin_name = self.qgis_tools.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        self.buttons = {}


    def project_read(self, show_warning=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Check if loaded project is valid for Giswater
        if not self.check_project(show_warning):
            return

        # Force commit before opening project and set new database connection
        if not self.manage_controller(show_warning):
            return

        # Manage schema name
        self.controller.get_current_user()
        layer_source = self.qgis_tools.qgis_get_layer_source(self.layer_node)
        self.schema_name = layer_source['schema']
        self.schema_name = self.schema_name.replace('"', '')
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)
        self.controller.set_schema_name(self.schema_name)

        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)

        # Set PostgreSQL parameter 'search_path'
        self.controller.set_search_path(layer_source['schema'])

        # Check if schema exists
        self.schema_exists = self.controller.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)

        # Get SRID from table node
        srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", srid)

        # Get variables from qgis project
        self.project_vars = self.qgis_tools.get_qgis_project_variables()
        global_vars.project_vars = self.project_vars

        # Check that there are no layers (v_edit_node) with the same view name, coming from different schemes
        status = self.check_layers_from_distinct_schema()
        if status is False:
            return

        # TODO: Refactor this
        self.controller.parent = ParentAction(self.iface, self.settings, self.controller, self.plugin_dir)

        # Get water software from table 'version'
        self.project_type = self.controller.get_project_type()
        if self.project_type is None:
            return

        # Initialize toolbars
        self.get_buttons_to_hide()

        # Manage records from table 'cat_feature'
        self.feature_cat = self.pg_man.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()

        # Check roles of this user to show or hide toolbars
        self.check_user_roles()

        # Create a thread to listen selected database channels
        if global_vars.settings.value('system_variables/use_notify').upper() == 'TRUE':
            self.notify = GwNotifyTools(self.iface, global_vars.settings, self.controller, self.plugin_dir)
            self.notify.set_controller(self.controller)
            list_channels = ['desktop', self.controller.current_user]
            self.notify.start_listening(list_channels)

        # Open automatically 'search docker' depending its value in user settings
        open_search = self.controller.get_user_setting_value('open_search', 'true')
        if open_search == 'true':
            GwSearch(self.iface, self.settings, self.controller, self.plugin_dir).api_search()

        # call dynamic mapzones repaint
        self.pg_man.set_style_mapzones()

        # Log it
        message = "Project read successfully"
        self.controller.log_info(message)


    def check_project(self, show_warning):
        """ # Check if loaded project is valid for Giswater """

        # Check if table 'v_edit_node' is loaded
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        if not self.layer_node and show_warning:
            layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")
            layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")
            if layer_arc or layer_connec:
                title = "Giswater plugin cannot be loaded"
                msg = "QGIS project seems to be a Giswater project, but layer 'v_edit_node' is missing"
                self.controller.show_warning(msg, 20, title=title)
                return False

        return True


    def manage_controller(self, show_warning, force_commit=False):
        """ Set new database connection. If force_commit=True then force commit before opening project """

        try:
            if self.controller.dao and force_commit:
                self.controller.log_info("Force commit")
                self.controller.dao.commit()
        except Exception as e:
            self.controller.log_info(str(e))
        finally:
            self.connection_status, not_version = self.controller.set_database_connection()
            if not self.connection_status or not_version:
                message = self.controller.last_error
                if show_warning:
                    if message:
                        self.controller.show_warning(message, 15)
                    self.controller.log_warning(str(self.controller.layer_source))
                return False

            return True


    def translate(self, message):
        if self.controller:
            return self.controller.tr(message)


    def check_layers_from_distinct_schema(self):

        layers = self.controller.get_layers()
        repeated_layers = {}
        for layer in layers:
            layer_toc_name = self.controller.get_layer_source_table_name(layer)
            if layer_toc_name == 'v_edit_node':
                layer_source = self.controller.get_layer_source(layer)
                repeated_layers[layer_source['schema'].replace('"', '')] = 'v_edit_node'

        if len(repeated_layers) > 1:
            if self.project_vars['main_schema'] is None or self.project_vars['add_schema'] is None:
                self.dlg_dtext = DialogTextUi()
                self.dlg_dtext.btn_accept.hide()
                self.dlg_dtext.btn_close.clicked.connect(lambda: self.dlg_dtext.close())
                msg = "QGIS project has more than one layer v_edit_node comming from differents schemas. " \
                      "If you are looking for manage two schemas, it is mandatory to define wich is the master and " \
                      "wich is the other one. To do this yo need to configure the  QGIS project setting this project " \
                      "variables: gwMainSchema and gwAddSchema."

                self.dlg_dtext.txt_infolog.setText(msg)
                self.dlg_dtext.open()
                return False

            # If there are layers with a different schema, the one that the user has in the project variable
            # 'gwMainSchema' is taken as the schema_name.
            self.schema_name = self.project_vars['main_schema']
            self.controller.set_schema_name(self.project_vars['main_schema'])

        return True


    def get_buttons_to_hide(self):

        try:
            # db format of value for parameter qgis_toolbar_hidebuttons -> {"index_action":[199, 74,75]}
            row = self.controller.get_config('qgis_toolbar_hidebuttons')
            if not row: return
            json_list = json.loads(row[0], object_pairs_hook=OrderedDict)
            self.buttons_to_hide = [str(x) for x in json_list['action_index']]
        except KeyError:
            pass
        except json.JSONDecodeError:
            # Control if json have a correct format
            pass
        finally:
            # TODO remove this line when do you want enabled api info for epa
            self.buttons_to_hide.append('199')


    def manage_toolbars(self):
        """ Manage actions of the custom plugin toolbars.
        project_type in ('ws', 'ud')
        """

        # Dynamically get list of toolbars from config file
        toolbar_names = global_vars.settings.value(f"toolbars/list_toolbars")

        # Get user UI config file
        parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), self.plugin_name)
        path = main_folder + os.sep + "config" + os.sep + 'user.config'

        # If file not found or file found and section not exists
        if not os.path.exists(path):
            parser = self.init_user_config_file(path, toolbar_names)
        else:
            parser.read(path)
            if not parser.has_section("toolbars_position"):
                parser = self.init_user_config_file(path, toolbar_names)

        parser.read(path)
        # Call each of the functions that configure the toolbars 'def toolbar_xxxxx(self, toolbar_id, x=0, y=0):'
        for pos, tb in enumerate(toolbar_names):
            # If not exists, add it and set it in last position
            if not parser.has_option('toolbars_position', f'pos_{pos}'):
                parser['toolbars_position'][f'pos_{pos}'] = f"{tb},{4000},{98}"

            toolbar_id = parser.get("toolbars_position", f'pos_{pos}').split(',')
            if toolbar_id:
                self.create_toolbar(toolbar_id[0], toolbar_id[1], toolbar_id[2])

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            ag.setProperty('gw_name', 'gw_QActionGroup')
            for index_action in plugin_toolbar.list_actions:

                button_def = global_vars.settings.value(f"buttons_def/{index_action}")

                if button_def:
                    text = self.translate(f'{index_action}_text')

                    icon_path = self.icon_folder + plugin_toolbar.toolbar_id + os.sep + index_action + ".png"
                    button = getattr(sys.modules[__name__], button_def)(icon_path, text, plugin_toolbar.toolbar, ag, self.iface, self.settings, self.controller, self.plugin_dir)

                    self.buttons[index_action] = button

        # Disable buttons which are project type exclusive
        if self.project_type == 'ud':
            for index in self.settings.value("project_exclusive/ws"):
                self.hide_button(index)

        if self.project_type == 'ws':
            for index in self.settings.value("project_exclusive/ud"):
                self.hide_button(index)

        # Hide buttons from buttons_to_hide
        for button_id in self.buttons_to_hide:
            self.hide_button(button_id)

        # Disable and hide all plugin_toolbars and actions
        self.enable_toolbars(False)

        # Enable toolbar 'basic' and 'utils'
        self.enable_toolbar("basic")
        self.enable_toolbar("utilities")
        self.enable_toolbar("toc")


    def create_toolbar(self, toolbar_id, x=None, y=None):

        list_actions = self.settings.value(f"toolbars/{toolbar_id}")

        if list_actions is None:
            return

        toolbar_name = self.translate(f'toolbar_{toolbar_id}_name')
        plugin_toolbar = PluginToolbar(toolbar_id, toolbar_name, True)

        # If the toolbar is ToC, add it to the Layes docker toolbar, else create a new toolbar
        if toolbar_id == "toc":
            plugin_toolbar.toolbar = self.iface.mainWindow().findChild(QDockWidget, 'Layers').findChildren(QToolBar)[0]
        else:
            plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)

        plugin_toolbar.toolbar.setObjectName(toolbar_name)
        plugin_toolbar.toolbar.setProperty('gw_name', toolbar_id)
        plugin_toolbar.list_actions = list_actions
        self.plugin_toolbars[toolbar_id] = plugin_toolbar

        if x and y:
            self.set_toolbar_position(toolbar_id, x, y)


    def manage_snapping_layers(self):
        """ Manage snapping of layers """

        self.qgis_tools.qgis_manage_snapping_layer('v_edit_arc', snapping_type=2)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_connec', snapping_type=0)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_node', snapping_type=0)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_gully', snapping_type=0)


    def check_user_roles(self):
        """ Check roles of this user to show or hide toolbars """

        restriction = self.controller.get_restriction(self.project_vars['role'])

        if restriction == 'role_basic':
            pass

        elif restriction == 'role_om':
            self.enable_toolbar("om")

        elif restriction == 'role_edit':
            self.enable_toolbar("om")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")

        elif restriction == 'role_epa':
            self.enable_toolbar("om")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")
            self.enable_toolbar("epa")
            self.enable_toolbar("plan")
            self.hide_button(38)
            self.hide_button(47)
            self.hide_button(49)
            self.hide_button(50)

        elif restriction == 'role_master':
            self.enable_toolbar("om")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")
            self.enable_toolbar("epa")
            self.enable_toolbar("plan")
            self.enable_toolbar("custom")


    def enable_toolbars(self, visible=True):
        """ Enable/disable all plugin toolbars from QGIS GUI """

        # Enable/Disable actions
        self.enable_all_buttons(visible)
        try:
            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(visible)
        except Exception as e:
            self.controller.log_warning(str(e))


    def enable_toolbar(self, toolbar_id, enable=True):
        """ Enable/Disable toolbar. Normally because user has no permission """

        if toolbar_id in self.plugin_toolbars:
            plugin_toolbar = self.plugin_toolbars[toolbar_id]
            plugin_toolbar.toolbar.setVisible(enable)
            for index_action in plugin_toolbar.list_actions:
                self.enable_button(index_action, enable)


    def enable_all_buttons(self, enable=True):
        """ Utility to enable/disable all buttons """

        for index in self.buttons.keys():
            self.enable_button(index, enable)


    def enable_button(self, button_id, enable=True):
        """ Enable/disable selected button """

        key = str(button_id).zfill(2)
        if key in self.buttons:
            self.buttons[key].action.setEnabled(enable)


    def hide_button(self, button_id, hide=True):
        """ Enable/disable selected action """

        key = str(button_id).zfill(2)
        if key in self.buttons:
            self.buttons[key].action.setVisible(not hide)


    def set_toolbar_position(self, toolbar_id, x, y):

        toolbar = self.plugin_toolbars[toolbar_id].toolbar
        if toolbar:
            toolbar.move(int(x), int(y))


    def init_user_config_file(self, path, toolbar_names):
        """ Initialize UI config file with default values """

        self.controller.log_info(f"init_user_config_file: {path}")

        # Create file and configure section 'toolbars_position'
        parser = configparser.RawConfigParser()
        parser.add_section('toolbars_position')
        for pos, tb in enumerate(toolbar_names):
            parser.set('toolbars_position', f'pos_{pos}', f'{tb}, {pos * 10}, 98')

        # Writing our configuration file to 'user.config'
        with open(path, 'w') as configfile:
            parser.write(configfile)
            configfile.close()
            del configfile

        return parser

