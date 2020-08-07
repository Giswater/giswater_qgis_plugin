"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtGui import QIcon, QKeySequence
from qgis.PyQt.QtWidgets import QAction, QMenu, QToolBar, QActionGroup

import os
import json
import configparser
from collections import OrderedDict
from functools import partial
import sys

from .manage_layers import ManageLayers
from .models.plugin_toolbar import PluginToolbar
from .utils.pg_man import PgMan
from .. import global_vars
from ..lib.qgis_tools import QgisTools
from ..ui_manager import DialogTextUi
# from ..actions.basic import Basic
from .actions.basic.basic_func import GwBasic
from ..actions.edit import Edit
from ..actions.go2epa import Go2Epa
from ..actions.master import Master
from ..actions.mincut import MincutParent
from ..actions.notify_functions import NotifyFunctions
from ..actions.om import Om
from ..actions.parent import ParentAction
from ..actions.utils import Utils
from ..actions.custom import Custom
from ..actions.tm_basic import TmBasic
from ..map_tools.cad_add_circle import CadAddCircle
from ..map_tools.cad_add_point import CadAddPoint
from ..map_tools.cad_api_info import CadApiInfo
from ..map_tools.change_elem_type import ChangeElemType
from ..map_tools.connec import ConnecMapTool
from ..map_tools.delete_node import DeleteNodeMapTool
from ..map_tools.dimensioning import Dimensioning
from ..map_tools.draw_profiles import DrawProfiles
from ..map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from ..map_tools.move_node import MoveNodeMapTool
from ..map_tools.replace_feature import ReplaceFeatureMapTool

from .toolbars.basic.basic import *
from .toolbars.edit.edit import *

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
        self.dict_toolbars = {}
        self.dict_actions = {}
        self.actions_not_checkable = []
        self.list_to_hide = []
        self.actions = {}
        self.map_tools = {}
        self.action = None
        self.plugin_name = self.qgis_tools.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep
        
        self.buttons = {}


    def set_params_config(self, dict_toolbars, dict_actions, actions_not_checkable):

        self.dict_toolbars = dict_toolbars
        self.dict_actions = dict_actions
        self.actions_not_checkable = actions_not_checkable


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
        global_vars.set_project_vars(self.project_vars)

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
        self.initialize_toolbars()
        self.get_buttons_to_hide()

        # Manage project read of type 'tm'
        if self.project_type == 'tm':
            self.project_read_tm()
            return

        # Manage project read of type 'pl'
        elif self.project_type == 'pl':
            self.project_read_pl()
            return

        # Set custom plugin toolbars (one action class per toolbar)
        if self.project_type == 'ws':
            self.mincut = MincutParent(self.iface, global_vars.settings, self.controller, self.plugin_dir)

        # Manage records from table 'cat_feature'
        self.feature_cat = self.pg_man.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Set objects for map tools classes
        self.manage_map_tools()

        # Check roles of this user to show or hide toolbars
        self.check_user_roles()

        # Create a thread to listen selected database channels
        if global_vars.settings.value('system_variables/use_notify').upper() == 'TRUE':
            self.notify = NotifyFunctions(self.iface, global_vars.settings, self.controller, self.plugin_dir)
            self.notify.set_controller(self.controller)
            list_channels = ['desktop', self.controller.current_user]
            self.notify.start_listening(list_channels)

        # Hide info button if giswater project is loaded
        if show_warning:
            self.set_info_button_visible(False)

        # Open automatically 'search docker' depending its value in user settings
        open_search = self.controller.get_user_setting_value('open_search', 'true')
        if open_search == 'true':
            self.basic.basic_api_search()

        # call dynamic mapzones repaint
        self.pg_man.set_style_mapzones()

        # Manage layers and check project
        self.manage_layers = ManageLayers(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.manage_layers.set_params(self.project_type, self.schema_name, self.project_vars['infotype'],
            self.project_vars['add_schema'])
        if not self.manage_layers.config_layers():
            self.controller.log_info("manage_layers return False")
            return

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


    def initialize_toolbars(self):
        """ Initialize toolbars """

        self.basic = GwBasic(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.utils = Utils(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.go2epa = Go2Epa(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.om = Om(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.custom = Custom(self.iface, global_vars.settings, self.controller, self.plugin_dir)


    def get_buttons_to_hide(self):

        try:
            # db format of value for parameter qgis_toolbar_hidebuttons -> {"index_action":[199, 74,75]}
            row = self.controller.get_config('qgis_toolbar_hidebuttons')
            if not row: return
            json_list = json.loads(row[0], object_pairs_hook=OrderedDict)
            self.list_to_hide = [str(x) for x in json_list['action_index']]
        except KeyError:
            pass
        except json.JSONDecodeError:
            # Control if json have a correct format
            pass
        finally:
            # TODO remove this line when do you want enabled api info for epa
            self.list_to_hide.append('199')


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
                if toolbar_id[0] in ('basic', 'utils'):
                    getattr(self, f'toolbar_{toolbar_id[0]}')(toolbar_id[0], toolbar_id[1], toolbar_id[2])
                else:
                    self.toolbar_common(toolbar_id[0], toolbar_id[1], toolbar_id[2])

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            ag.setProperty('gw_name', 'gw_QActionGroup')
            for index_action in plugin_toolbar.list_actions:
    
                button_def = global_vars.settings.value(f"buttons_def/{index_action}")
    
                if not button_def:
                    self.add_action(index_action, plugin_toolbar.toolbar, ag)
    
                else:
                    text = self.translate(f'{index_action}_text')
                    
                    icon_path = self.icon_folder + plugin_toolbar.toolbar_id + os.sep + index_action + ".png"
                    button = getattr(sys.modules[__name__], button_def)(icon_path, text, plugin_toolbar.toolbar, ag, self.iface, self.settings, self.controller, self.plugin_dir)
                    
                    self.buttons[index_action] = button
    

        # Disable and hide all plugin_toolbars and actions
        self.enable_toolbars(False)

        self.edit.set_controller(self.controller)
        self.go2epa.set_controller(self.controller)
        self.master.set_controller(self.controller)
        if self.project_type == 'ws':
            self.mincut.set_controller(self.controller)
        self.om.set_controller(self.controller)
        self.custom.set_controller(self.controller)

        self.edit.set_project_type(self.project_type)
        self.go2epa.set_project_type(self.project_type)
        self.master.set_project_type(self.project_type)
        self.om.set_project_type(self.project_type)
        self.custom.set_project_type(self.project_type)

        # Enable toolbar 'basic' and 'utils'
        self.enable_toolbar("basic")
        self.enable_toolbar("utils")


    def manage_toolbar(self, toolbar_id, list_actions):
        """ Manage action of selected plugin toolbar """

        if list_actions is None:
            return

        toolbar_name = self.translate(f'toolbar_{toolbar_id}_name')
        plugin_toolbar = PluginToolbar(toolbar_id, toolbar_name, True)
        plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)
        plugin_toolbar.toolbar.setObjectName(toolbar_name)
        plugin_toolbar.toolbar.setProperty('gw_name', toolbar_id)
        plugin_toolbar.list_actions = list_actions
        self.plugin_toolbars[toolbar_id] = plugin_toolbar


    def manage_toolbars_common(self):
        """ Manage actions of the common plugin toolbars """

        self.toolbar_basic("basic")
        self.toolbar_utils("utils")


    def toolbar_common(self, toolbar_id, x=0, y=0):
        """ Manage toolbars: 'om_ud', 'om_ws', 'edit', 'cad', 'epa', 'master' """

        if toolbar_id not in self.dict_toolbars:
            return

        list_actions = self.dict_toolbars[toolbar_id]
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.translate(f'toolbar_{toolbar_id}_name'), x, y)


    def toolbar_basic(self, toolbar_id, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        if toolbar_id not in self.dict_toolbars:
            return

        list_actions = self.dict_toolbars[toolbar_id]
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.translate(f'toolbar_{toolbar_id}_name'), x, y)


    def toolbar_utils(self, toolbar_id, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        if toolbar_id not in self.dict_toolbars:
            return

        list_actions = self.dict_toolbars[toolbar_id]
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.translate(f'toolbar_{toolbar_id}_name'), x, y)

        self.basic.set_controller(self.controller)
        self.utils.set_controller(self.controller)
        self.basic.set_project_type(self.project_type)
        self.utils.set_project_type(self.project_type)


    def manage_snapping_layers(self):
        """ Manage snapping of layers """

        self.qgis_tools.qgis_manage_snapping_layer('v_edit_arc', snapping_type=2)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_connec', snapping_type=0)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_node', snapping_type=0)
        self.qgis_tools.qgis_manage_snapping_layer('v_edit_gully', snapping_type=0)


    def manage_map_tools(self):
        """ Manage map tools """

        self.set_map_tool('map_tool_api_info_data')
        if self.controller.get_project_type() in ('ws', 'ud'):
            self.set_map_tool('map_tool_api_info_inp')
            self.set_map_tool('map_tool_move_node')
            self.set_map_tool('map_tool_delete_node')
            self.set_map_tool('map_tool_flow_trace')
            self.set_map_tool('map_tool_flow_exit')
            self.set_map_tool('map_tool_connec_tool')
            self.set_map_tool('map_tool_draw_profiles')
            self.set_map_tool('map_tool_replace_node')
            self.set_map_tool('map_tool_change_node_type')
            self.set_map_tool('map_tool_dimensioning')
            self.set_map_tool('cad_add_circle')
            self.set_map_tool('cad_add_point')


    def set_map_tool(self, map_tool_name):
        """ Set objects for map tools classes """

        if map_tool_name in self.map_tools:
            map_tool = self.map_tools[map_tool_name]
            map_tool.set_controller(self.controller)


    def check_user_roles(self):
        """ Check roles of this user to show or hide toolbars """

        restriction = self.controller.get_restriction(self.project_vars['role'])

        if restriction == 'role_basic':
            pass

        elif restriction == 'role_om':
            if self.project_type in ('ws', 'ud'):
                self.enable_toolbar(f"om_{self.project_type}")

        elif restriction == 'role_edit':
            if self.project_type in ('ws', 'ud'):
                self.enable_toolbar(f"om_{self.project_type}")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")

        elif restriction == 'role_epa':
            if self.project_type in ('ws', 'ud'):
                self.enable_toolbar(f"om_{self.project_type}")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")
            self.enable_toolbar("epa")
            self.enable_toolbar("master")
            self.hide_action(False, 38)
            self.hide_action(False, 47)
            self.hide_action(False, 49)
            self.hide_action(False, 50)

        elif restriction == 'role_master':
            if self.project_type in ('ws', 'ud'):
                self.enable_toolbar(f"om_{self.project_type}")
            self.enable_toolbar("edit")
            self.enable_toolbar("cad")
            self.enable_toolbar("epa")
            self.enable_toolbar("master")
            self.enable_toolbar("custom")


    def enable_toolbars(self, visible=True):
        """ Enable/disable all plugin toolbars from QGIS GUI """

        # Enable/Disable actions
        self.enable_actions(visible)
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
                self.enable_action(enable, index_action)


    def enable_actions(self, enable=True, start=1, stop=1000):
        """ Utility to enable/disable all actions """

        for i in range(start, stop + 1):
            self.enable_action(enable, i)


    def enable_action(self, enable=True, index=1):
        """ Enable/disable selected action """

        key = str(index).zfill(2)
        if key in self.actions:
            action = self.actions[key]
            action.setEnabled(enable)


    def hide_action(self, visible=True, index=1):
        """ Enable/disable selected action """

        key = str(index).zfill(2)
        if key in self.actions:
            action = self.actions[key]
            action.setVisible(visible)


    def set_toolbar_position(self, tb_name, x, y):

        toolbar = self.iface.mainWindow().findChild(QToolBar, tb_name)
        if toolbar:
            toolbar.move(int(x), int(y))


    def set_info_button_visible(self, visible=True):

        if self.action:
            self.action.setVisible(visible)


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


    def add_action(self, index_action, toolbar, action_group):
        """ Add new action into specified @toolbar.
            It has to be defined in the configuration file.
            Associate it to corresponding @action_group
        """

        text_action = self.translate(f'{index_action}_text')
        function_name = global_vars.settings.value(f'actions/{index_action}_function')
        if not function_name:
            return None

        # Actions NOT checkable (normally because they open a form)
        if index_action in self.actions_not_checkable:
            action = self.create_action(index_action, text_action, toolbar, False, function_name, action_group)

        # Actions checkable (normally related with 'map_tools')
        else:
            action = self.create_action(index_action, text_action, toolbar, True, function_name, action_group)

        return action


    def create_action(self, index_action, text, toolbar, is_checkable, function_name, action_group):
        """ Creates a new action with selected parameters """

        icon = None
        icon_path = self.icon_folder + index_action + '.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)

        if icon is None:
            action = QAction(text, action_group)
        else:
            action = QAction(icon, text, action_group)
        action.setObjectName(function_name)
        action.setProperty('index_action', index_action)

        # Button add_node or add_arc: add drop down menu to button in toolbar
        if self.schema_exists and (index_action == '01' or index_action == '02'):
            action = self.manage_dropdown_menu(action, index_action)
        
        toolbar.addAction(action)
        action.setCheckable(is_checkable)
        self.actions[index_action] = action

        # Management of the action
        self.manage_action(index_action, function_name)

        # Management of the map_tool associated to this action (if it has one)
        self.manage_map_tool(index_action, function_name)

        return action


    def manage_action(self, index_action, function_name):
        """ Associate the action with @index_action the execution
            of the callback function @function_name when the action is triggered
        """

        if function_name is None:
            return

        action = None
        try:

            action = self.actions[index_action]
            callback_function = None

            # Basic toolbar actions
            if 'basic' in self.dict_actions and index_action in self.dict_actions['basic']:
                callback_function = getattr(self.basic, function_name)
            # Mincut toolbar actions
            elif 'mincut' in self.dict_actions and index_action in self.dict_actions['mincut']:
                if self.project_type == 'ws':
                    callback_function = getattr(self.mincut, function_name)
            # OM toolbar actions
            elif 'om' in self.dict_actions and index_action in self.dict_actions['om']:
                callback_function = getattr(self.om, function_name)
            # Edit toolbar actions
            elif 'edit' in self.dict_actions and index_action in self.dict_actions['edit']:
                callback_function = getattr(self.edit, function_name)
            # Go2epa toolbar actions
            elif 'go2epa' in self.dict_actions and index_action in self.dict_actions['go2epa']:
                callback_function = getattr(self.go2epa, function_name)
            # Master toolbar actions
            elif 'master' in self.dict_actions and index_action in self.dict_actions['master']:
                callback_function = getattr(self.master, function_name)
            # Utils toolbar actions
            elif 'utils' in self.dict_actions and index_action in self.dict_actions['utils']:
                callback_function = getattr(self.utils, function_name)
            # Tm Basic toolbar actions
            elif 'tm_basic' in self.dict_actions and index_action in self.dict_actions['tm_basic']:
                callback_function = getattr(self.tm_basic, function_name)
            # Custom toolbar actions
            elif 'custom' in self.dict_actions and index_action in self.dict_actions['custom']:
                callback_function = getattr(self.custom, function_name)

            # Action found
            if callback_function:
                action.triggered.connect(callback_function)
            # Action not found: execute generic function
            else:
                callback_function = getattr(self, 'action_triggered')
                action.triggered.connect(partial(callback_function, function_name))

            # Hide actions according parameter action_to_hide from config file
            if self.list_to_hide is not None:
                if len(self.list_to_hide) > 0:
                    if str(action.property('index_action')) in self.list_to_hide:
                        action.setVisible(False)

        except AttributeError:
            action.setEnabled(False)


    def manage_map_tool(self, index_action, function_name):
        """ Get the action with @index_action and check if has an associated map_tool.
            If so, add it to dictionary of available map_tools
        """

        map_tool = None
        action = self.actions[index_action]

        # Check if the @action has an associated map_tool
        if int(index_action) == 16:
            map_tool = MoveNodeMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 17:
            map_tool = DeleteNodeMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 20:
            map_tool = ConnecMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 28:
            map_tool = ChangeElemType(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) in (37, 199):
            map_tool = CadApiInfo(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 39:
            map_tool = Dimensioning(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 43:
            map_tool = DrawProfiles(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 44:
            map_tool = ReplaceFeatureMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 56:
            map_tool = FlowTraceFlowExitMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 57:
            map_tool = FlowTraceFlowExitMapTool(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 71:
            map_tool = CadAddCircle(self.iface, global_vars.settings, action, index_action)
        elif int(index_action) == 72:
            map_tool = CadAddPoint(self.iface, global_vars.settings, action, index_action)

        # If this action has an associated map tool, add this to dictionary of available map_tools
        if map_tool:
            self.map_tools[function_name] = map_tool


    def manage_dropdown_menu(self, action, index_action):
        """ Create dropdown menu for insert management of nodes and arcs """

        # Get list of different node and arc types
        menu = QMenu()
        # List of nodes from node_type_cat_type - nodes which we are using
        list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if (index_action == '01' and feature_cat.feature_type.upper() == 'NODE') or (
                    index_action == '02' and feature_cat.feature_type.upper() == 'ARC'):
                obj_action = QAction(str(feature_cat.id), self)
                obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
        menu.addSeparator()

        list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if index_action == '01' and feature_cat.feature_type.upper() == 'CONNEC':
                obj_action = QAction(str(feature_cat.id), self)
                obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
        menu.addSeparator()

        list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if index_action == '01' and feature_cat.feature_type.upper() == 'GULLY' and self.project_type == 'ud':
                obj_action = QAction(str(feature_cat.id), self)
                obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
        menu.addSeparator()
        action.setMenu(menu)

        return action


    def action_triggered(self, function_name):
        """ Action with corresponding funcion name has been triggered """
        
        print("Action Triggered")
        
        try:
            if function_name in self.map_tools:
                self.controller.check_actions(False)
                self.controller.prev_maptool = self.iface.mapCanvas().mapTool()
                map_tool = self.map_tools[function_name]
                if not (map_tool == self.iface.mapCanvas().mapTool()):
                    self.iface.mapCanvas().setMapTool(map_tool)
                else:
                    self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: " + str(e))
        except KeyError as e:
            self.controller.show_warning("KeyError: " + str(e))


    def project_read_tm(self):
        """ Function executed when a user opens a QGIS project of type 'tm' """

        # Set actions classes (define one class per plugin toolbar)
        self.tm_basic = TmBasic(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.tm_basic.set_tree_manage(self)

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()
        self.manage_toolbars_tm()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Set objects for map tools classes
        self.manage_map_tools()

        # Log it
        message = "Project read successfully ('tm')"
        self.controller.log_info(message)


    def manage_toolbars_tm(self):
        """ Manage actions of the different plugin toolbars """

        toolbar_id = "tm_basic"
        list_actions = ['303', '301', '302', '304', '305', '309']
        self.manage_toolbar(toolbar_id, list_actions)

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)

        # Enable toolbars
        self.enable_toolbar("basic")
        self.enable_toolbar("utils")
        self.enable_toolbar("tm_basic")
        self.tm_basic.set_controller(self.controller)


    def project_read_pl(self):
        """ Function executed when a user opens a QGIS project of type 'pl' """

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Log it
        message = "Project read successfully ('pl')"
        self.controller.log_info(message)

