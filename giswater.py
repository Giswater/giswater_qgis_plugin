"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsExpressionContextUtils, QgsFieldConstraints, QgsPointLocator, \
    QgsProject, QgsSnappingUtils, QgsTolerance
from qgis.PyQt.QtCore import QObject, QPoint, QSettings, Qt
from qgis.PyQt.QtWidgets import QAction, QActionGroup, QApplication, QDockWidget, QMenu, QToolBar, QToolButton
from qgis.PyQt.QtGui import QCursor, QIcon, QKeySequence, QPixmap

import configparser
import json
import os.path
import sys
import webbrowser
from collections import OrderedDict
from functools import partial
from json import JSONDecodeError

from .actions.add_layer import AddLayer
from .actions.basic import Basic
from .actions.check_project_result import CheckProjectResult
from .actions.edit import Edit
from .actions.go2epa import Go2Epa
from .actions.master import Master
from .actions.mincut import MincutParent
from .actions.notify_functions import NotifyFunctions
from .actions.om import Om
from .actions.parent import ParentAction
from .actions.tm_basic import TmBasic
from .actions.update_sql import UpdateSQL
from .actions.utils import Utils
from .dao.controller import DaoController
from .map_tools.cad_add_circle import CadAddCircle
from .map_tools.cad_add_point import CadAddPoint
from .map_tools.cad_api_info import CadApiInfo
from .map_tools.change_elem_type import ChangeElemType
from .map_tools.connec import ConnecMapTool
from .map_tools.delete_node import DeleteNodeMapTool
from .map_tools.dimensioning import Dimensioning
from .map_tools.draw_profiles import DrawProfiles
from .map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from .map_tools.move_node import MoveNodeMapTool
from .map_tools.replace_feature import ReplaceFeatureMapTool
from .models.plugin_toolbar import PluginToolbar
from .models.sys_feature_cat import SysFeatureCat
from .ui_manager import DialogTextUi


class Giswater(QObject):

    def __init__(self, iface):
        """ Constructor
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """

        super(Giswater, self).__init__()

        # Initialize instance attributes
        self.iface = iface
        self.actions = {}
        self.map_tools = {}
        self.srid = None
        self.plugin_toolbars = {}
        self.available_layers = []
        self.btn_add_layers = None
        self.update_sql = None
        self.action = None
        self.action_info = None
        self.toolButton = None

        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        self.plugin_name = self.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        # Check if config file exists
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name + '.config')
        if not os.path.exists(setting_file):
            message = f"Config file not found at: {setting_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return

        # Set plugin settings
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())

        # Enable Python console and Log Messages panel if parameter 'enable_python_console' = True
        enable_python_console = self.settings.value('system_variables/enable_python_console', 'FALSE').upper()
        if enable_python_console == 'TRUE':
            self.enable_python_console()

        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix)
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())

        # Define signals
        self.set_signals()


    def set_signals(self):
        """ Define widget and event signals """

        try:
            self.iface.projectRead.connect(self.project_read)
            self.iface.newProjectCreated.connect(self.project_new)
        except AttributeError:
            pass


    def set_info_button(self):
        """ Set main information button (always visible) """

        self.toolButton = QToolButton()
        self.action_info = self.iface.addToolBarWidget(self.toolButton)

        icon_path = self.icon_folder + '36.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "Show info", self.iface.mainWindow())
        else:
            self.action = QAction("Show info", self.iface.mainWindow())

        self.toolButton.setDefaultAction(self.action)
        self.update_sql = UpdateSQL(self.iface, self.settings, self.controller, self.plugin_dir)
        self.action.triggered.connect(self.update_sql.init_sql)


    def unset_info_button(self):
        """ Unset main information button (when plugin is disabled or reloaded) """

        if self.action:
            self.action.triggered.disconnect()
        if self.action_info:
            self.iface.removeToolBarIcon(self.action_info)
        self.action = None
        self.action_info = None


    def set_info_button_visible(self, visible=True):

        if self.action:
            self.action.setVisible(visible)


    def enable_python_console(self):
        """ Enable Python console and Log Messages panel if parameter 'enable_python_console' = True """

        # Manage Python console
        python_console = self.iface.mainWindow().findChild(QDockWidget, 'PythonConsole')
        if python_console:
            python_console.setVisible(True)
        else:
            import console
            console.show_console()

        # Manage Log Messages panel
        message_log = self.iface.mainWindow().findChild(QDockWidget, 'MessageLog')
        if message_log:
            message_log.setVisible(True)


    def tr(self, message):
        if self.controller:
            return self.controller.tr(message)


    def manage_action(self, index_action, function_name):
        """ Associate the action with @index_action the execution
            of the callback function @function_name when the action is triggered
        """

        if function_name is None:
            return

        action = None
        try:
            action = self.actions[index_action]

            # Basic toolbar actions
            if int(index_action) in (143, 142):
                callback_function = getattr(self.basic, function_name)
                action.triggered.connect(callback_function)
            # Mincut toolbar actions
            elif int(index_action) in (26, 27) and self.project_type == 'ws':
                callback_function = getattr(self.mincut, function_name)
                action.triggered.connect(callback_function)
            # OM toolbar actions
            elif int(index_action) in (18, 64, 65, 74, 75, 76, 81, 82, 84):
                callback_function = getattr(self.om, function_name)
                action.triggered.connect(callback_function)
            # Edit toolbar actions
            elif int(index_action) in (1, 2, 33, 34, 66, 67, 68, 69):
                callback_function = getattr(self.edit, function_name)
                action.triggered.connect(callback_function)
            # Go2epa toolbar actions
            elif int(index_action) in (23, 25, 29):
                callback_function = getattr(self.go2epa, function_name)
                action.triggered.connect(callback_function)
            # Master toolbar actions
            elif int(index_action) in (45, 46, 50):
                callback_function = getattr(self.master, function_name)
                action.triggered.connect(callback_function)
            # Utils toolbar actions
            elif int(index_action) in (206, 58, 83, 99, 59):
                callback_function = getattr(self.utils, function_name)
                action.triggered.connect(callback_function)
            # Tm Basic toolbar actions
            elif int(index_action) in (301, 302, 303, 304, 305, 309):
                callback_function = getattr(self.tm_basic, function_name)
                action.triggered.connect(callback_function)
            # Generic function
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


    def add_action(self, index_action, toolbar, action_group):
        """ Add new action into specified @toolbar.
            It has to be defined in the configuration file.
            Associate it to corresponding @action_group
        """

        text_action = self.tr(index_action + '_text')
        function_name = self.settings.value('actions/' + str(index_action) + '_function')

        if not function_name:
            return None

        # Buttons NOT checkable (normally because they open a form)
        list_actions = (18, 23, 25, 26, 27, 29, 33, 34, 45, 46, 50, 58, 59, 86, 64, 65, 66,
                        67, 68, 69, 74, 75, 76, 81, 82, 83, 84, 98, 99, 142, 143, 206, 301, 302, 303, 304, 305, 309)

        if int(index_action) in list_actions:
            action = self.create_action(index_action, text_action, toolbar, False, function_name, action_group)

        # Buttons checkable (normally related with 'map_tools')
        else:
            action = self.create_action(index_action, text_action, toolbar, True, function_name, action_group)

        return action


    def open_browser(self, web_tag):
        """ Open the web browser according to the drop down menu of the feature to insert """
        webbrowser.open_new_tab('https://giswater.org/giswater-manual/#' + web_tag)


    def manage_map_tool(self, index_action, function_name):
        """ Get the action with @index_action and check if has an associated map_tool.
            If so, add it to dictionary of available map_tools
        """

        map_tool = None
        action = self.actions[index_action]

        # Check if the @action has an associated map_tool
        if int(index_action) == 16:
            map_tool = MoveNodeMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 17:
            map_tool = DeleteNodeMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 20:
            map_tool = ConnecMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 28:
            map_tool = ChangeElemType(self.iface, self.settings, action, index_action)
        elif int(index_action) in (37, 199):
            map_tool = CadApiInfo(self.iface, self.settings, action, index_action)
        elif int(index_action) == 39:
            map_tool = Dimensioning(self.iface, self.settings, action, index_action)
        elif int(index_action) == 43:
            map_tool = DrawProfiles(self.iface, self.settings, action, index_action)
        elif int(index_action) == 44:
            map_tool = ReplaceFeatureMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 56:
            map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 57:
            map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
        elif int(index_action) == 71:
            map_tool = CadAddCircle(self.iface, self.settings, action, index_action)
        elif int(index_action) == 72:
            map_tool = CadAddPoint(self.iface, self.settings, action, index_action)

        # If this action has an associated map tool, add this to dictionary of available map_tools
        if map_tool:
            self.map_tools[function_name] = map_tool


    def manage_toolbars_common(self):
        """ Manage actions of the common plugin toolbars """

        self.toolbar_basic("basic")
        self.toolbar_utils("utils")


    def toolbar_basic(self, toolbar_id, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = None
        if self.controller.get_project_type() == 'ws':
            list_actions = ['37', '142', '143']
        elif self.controller.get_project_type() == 'ud':
            list_actions = ['37', '142', '143']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['37', '142', '143']
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_utils(self, toolbar_id, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = None
        if self.controller.get_project_type() in ('ws', 'ud'):
            list_actions = ['206', '99', '83', '58', '59']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['206', '99', '83', '58']
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)

        self.basic.set_controller(self.controller)
        self.utils.set_controller(self.controller)
        self.basic.set_project_type(self.project_type)
        self.utils.set_project_type(self.project_type)


    def toolbar_om_ws(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['26', '27', '74', '75', '76', '64', '65', '84', '18']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_om_ud(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['43', '56', '57', '74', '75', '76', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_edit(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['01', '02', '44', '16', '17', '28', '20', '68', '69', '39', '34', '66', '33', '67']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_cad(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['71', '72']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_epa(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['199', '23', '25', '29']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_master(self, toolbar_id, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """

        list_actions = ['45', '46', '50']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def save_toolbars_position(self):

        parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), self.plugin_name)
        config_folder = main_folder + os.sep + "config" + os.sep
        if not os.path.exists(config_folder):
            os.makedirs(config_folder)
        path = config_folder + 'ui_config.config'
        parser.read(path)

        # Get all QToolBar
        widget_list = self.iface.mainWindow().findChildren(QToolBar)
        x = 0
        own_toolbars = []
        # Get a list with own QToolBars
        for w in widget_list:
            if w.property('gw_name'):
                own_toolbars.append(w)

        # Order list of toolbar in function of X position
        own_toolbars = sorted(own_toolbars, key=lambda k: k.x())

        # Check if section toolbars_position exists in file
        if 'toolbars_position' not in parser:
            parser = configparser.RawConfigParser()
            parser.add_section('toolbars_position')

        if len(own_toolbars) == 8:
            for w in own_toolbars:
                parser['toolbars_position'][f'pos_{x}'] = f"{w.property('gw_name')},{w.x()},{w.y()}"
                x += 1
            with open(path, 'w') as configfile:
                parser.write(configfile)
                configfile.close()


    def set_toolbar_position(self, tb_name, x, y):

        toolbar = self.iface.mainWindow().findChild(QToolBar, tb_name)
        if toolbar:
            toolbar.move(int(x), int(y))


    def init_ui_config_file(self, path, toolbar_names):
        """ Initialize UI config file with default values """

        # Create file and configure section 'toolbars_position'
        parser = configparser.RawConfigParser()
        parser.add_section('toolbars_position')
        for pos, tb in enumerate(toolbar_names):
            parser.set('toolbars_position', f'pos_{pos}', f'{tb}, {pos * 10}, 98')

        # Writing our configuration file to 'ui_config.config'
        with open(path, 'w') as configfile:
            parser.write(configfile)
            configfile.close()
            del configfile

        return parser


    def manage_toolbars(self):
        """ Manage actions of the custom plugin toolbars.
        project_type in ('ws', 'ud')
        """

        # TODO: Dynamically get from config file
        toolbar_names = ('basic', 'om_ud', 'om_ws', 'edit', 'cad', 'epa', 'master', 'utils')

        # Get user UI config file
        parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), self.plugin_name)
        path = main_folder + os.sep + "config" + os.sep + 'ui_config.config'

        # If file not found or file found and section not exists
        if not os.path.exists(path):
            parser = self.init_ui_config_file(path, toolbar_names)
        else:
            parser.read(path)
            if not parser.has_section("toolbars_position"):
                parser = self.init_ui_config_file(path, toolbar_names)

        parser.read(path)
        # Call each of the functions that configure the toolbars 'def toolbar_xxxxx(self, toolbar_id, x=0, y=0):'
        for pos, tb in enumerate(toolbar_names):
            toolbar_id = parser.get("toolbars_position", f'pos_{pos}').split(',')
            if toolbar_id:
                getattr(self, f'toolbar_{toolbar_id[0]}')(toolbar_id[0], toolbar_id[1], toolbar_id[2])

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            ag.setProperty('gw_name', 'gw_QActionGroup')
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)

        # Disable and hide all plugin_toolbars and actions
        self.enable_toolbars(False)

        self.edit.set_controller(self.controller)
        self.go2epa.set_controller(self.controller)
        self.master.set_controller(self.controller)
        if self.project_type == 'ws':
            self.mincut.set_controller(self.controller)
        self.om.set_controller(self.controller)

        self.edit.set_project_type(self.project_type)
        self.go2epa.set_project_type(self.project_type)
        self.master.set_project_type(self.project_type)
        self.om.set_project_type(self.project_type)

        # Enable toolbar 'basic' and 'utils'
        self.enable_toolbar("basic")
        self.enable_toolbar("utils")


    def manage_toolbar(self, toolbar_id, list_actions):
        """ Manage action of selected plugin toolbar """

        if list_actions is None:
            return

        toolbar_name = self.tr('toolbar_' + toolbar_id + '_name')
        plugin_toolbar = PluginToolbar(toolbar_id, toolbar_name, True)

        plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)
        plugin_toolbar.toolbar.setObjectName(toolbar_name)
        plugin_toolbar.toolbar.setProperty('gw_name', toolbar_id)
        plugin_toolbar.list_actions = list_actions
        self.plugin_toolbars[toolbar_id] = plugin_toolbar


    def initGui(self):
        """ Create the menu entries and toolbar icons inside the QGIS GUI """

        # Initialize plugin
        self.init_plugin()

        # Force project read (to work with PluginReloader)
        self.project_read(False)


    def init_plugin(self):
        """ Plugin main initialization function """

        # Set controller (no database connection yet)
        self.controller = DaoController(self.settings, self.plugin_name, self.iface, create_logger=True)
        self.controller.set_plugin_dir(self.plugin_dir)
        self.controller.set_qgis_settings(self.qgis_settings)
        self.controller.set_giswater(self)

        # Set main information button (always visible)
        self.set_info_button()


    def manage_feature_cat(self):
        """ Manage records from table 'cat_feature' """

        # Dictionary to keep every record of table 'cat_feature'
        # Key: field tablename
        # Value: Object of the class SysFeatureCat

        sql = None
        self.feature_cat = {}
        sql = ("SELECT cat_feature.* FROM cat_feature "
               "WHERE active IS TRUE ORDER BY id")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False

        msg = "Field child_layer of id: "
        for row in rows:
            tablename = row['child_layer']
            if not tablename:
                msg += f"{row['id']}, "
                continue
            elem = SysFeatureCat(row['id'], row['system_id'], row['feature_type'], row['shortcut_key'],
                                 row['parent_layer'], row['child_layer'])
            self.feature_cat[tablename] = elem

        self.feature_cat = OrderedDict(sorted(self.feature_cat.items(), key=lambda t: t[0]))

        if msg != "Field child_layer of id: ":
            self.controller.show_warning(msg + "is not defined in table cat_feature")

        return True


    def remove_dockers(self):
        """ Remove Giswater dockers """

        docker_search = self.iface.mainWindow().findChild(QDockWidget, 'dlg_search')
        if docker_search:
            self.iface.removeDockWidget(docker_search)

        docker_info = self.iface.mainWindow().findChild(QDockWidget, 'docker')
        if docker_info:
            self.iface.removeDockWidget(docker_info)

        if self.btn_add_layers:
            dockwidget = self.iface.mainWindow().findChild(QDockWidget, 'Layers')
            toolbar = dockwidget.findChildren(QToolBar)[0]
            # TODO improve this, now remove last action
            toolbar.removeAction(toolbar.actions()[len(toolbar.actions()) - 1])
            self.btn_add_layers = None


    def unload(self, remove_modules=True):
        """ Removes plugin menu items and icons from QGIS GUI
            :param @remove_modules is True when plugin is disabled or reloaded
        """

        # Remove Giswater dockers
        self.remove_dockers()

        # Save toolbar position after unload plugin
        try:
            self.save_toolbars_position()
        except Exception as e:
            self.controller.log_warning(str(e))

        try:
            # Unlisten notify channel and stop thread
            if self.settings.value('system_variables/use_notify').upper() == 'TRUE' and hasattr(self, 'notify'):
                list_channels = ['desktop', self.controller.current_user]
                self.notify.stop_listening(list_channels)

            for action in list(self.actions.values()):
                self.iface.removePluginMenu(self.plugin_name, action)
                self.iface.removeToolBarIcon(action)

            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(False)
                    del plugin_toolbar.toolbar

            if remove_modules:
                # Unset main information button (when plugin is disabled or reloaded)
                self.unset_info_button()

                # unload all loaded giswater related modules
                for mod_name, mod in list(sys.modules.items()):
                    if mod and hasattr(mod, '__file__') and mod.__file__:
                        if self.plugin_dir in mod.__file__:
                            del sys.modules[mod_name]

            else:
                self.set_info_button_visible()

        except Exception:
            pass
        finally:
            # Reset instance attributes
            self.actions = {}
            self.map_tools = {}
            self.srid = None
            self.plugin_toolbars = {}


    """ Slots """

    def enable_actions(self, enable=True, start=1, stop=100):
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


    def enable_toolbars(self, visible=True):
        """ Enable/disable all plugin toolbars from QGIS GUI """

        # Enable/Disable actions
        self.enable_actions(visible)
        try:
            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(visible)
        except:
            pass


    def enable_toolbar(self, toolbar_id, enable=True):
        """ Enable/Disable toolbar. Normally because user has no permission """

        if toolbar_id in self.plugin_toolbars:
            plugin_toolbar = self.plugin_toolbars[toolbar_id]
            plugin_toolbar.toolbar.setVisible(enable)
            for index_action in plugin_toolbar.list_actions:
                self.enable_action(enable, index_action)


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

    def check_layers_from_distinct_schema(self):
        layers = self.controller.get_layers()
        repeated_layers = {}
        for layer in layers:
            layer_toc_name = self.controller.get_layer_source_table_name(layer)
            if layer_toc_name == 'v_edit_node':
                layer_source = self.controller.get_layer_source(layer)
                repeated_layers[layer_source['schema'].replace('"', '')] = 'v_edit_node'

        if len(repeated_layers) > 1:
            if self.qgis_project_main_schema is None or self.qgis_project_add_schema is None:
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

            # If there are layers with a different scheme, the one that the user has in the project variable
            # self.qgis_project_main_schema is taken as the schema_name.
            self.schema_name = self.qgis_project_main_schema
            self.controller.set_schema_name(self.qgis_project_main_schema)
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


    def initialize_toolbars(self):
        """ Initialize toolbars """

        self.basic = Basic(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic.set_giswater(self)
        self.utils = Utils(self.iface, self.settings, self.controller, self.plugin_dir)
        self.go2epa = Go2Epa(self.iface, self.settings, self.controller, self.plugin_dir)
        self.om = Om(self.iface, self.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, self.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, self.settings, self.controller, self.plugin_dir)


    def project_new(self):
        """ Function executed when a user creates a new QGIS project """

        self.unload(False)


    def project_read(self, show_warning=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Unload plugin before reading opened project
        self.unload(False)

        # Check if loaded project is valid for Giswater
        if not self.check_project(show_warning):
            return

        # Force commit before opening project and set new database connection
        if not self.manage_controller(show_warning):
            return

        # Manage schema name
        self.controller.get_current_user()
        layer_source = self.controller.get_layer_source(self.layer_node)
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
        self.srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", self.srid)

        # Get variables from qgis project
        self.get_qgis_project_variables()

        # Check that there are no layers (v_edit_node) with the same view name, coming from different schemes
        status = self.check_layers_from_distinct_schema()
        if status is False:
            return

        self.parent = ParentAction(self.iface, self.settings, self.controller, self.plugin_dir)
        self.add_layer = AddLayer(self.iface, self.settings, self.controller, self.plugin_dir)

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
            self.mincut = MincutParent(self.iface, self.settings, self.controller, self.plugin_dir)

        # Manage layers and check project
        self.set_qgis_layers = True
        if not self.manage_layers():
            return

        # Manage records from table 'cat_feature'
        self.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Set objects for map tools classes
        self.manage_map_tools()

        # Check roles of this user to show or hide toolbars
        self.controller.check_user_roles()

        # Set project layers with gw_fct_getinfofromid: This process takes time for user
        if self.set_qgis_layers is True:
            self.get_layers_to_config()
            self.set_layer_config(self.available_layers)

        # Create a thread to listen selected database channels
        if self.settings.value('system_variables/use_notify').upper() == 'TRUE':
            self.notify = NotifyFunctions(self.iface, self.settings, self.controller, self.plugin_dir)
            self.notify.set_controller(self.controller)
            list_channels = ['desktop', self.controller.current_user]
            self.notify.start_listening(list_channels)

        # Save toolbar position after save project
        self.iface.actionSaveProject().triggered.connect(self.save_toolbars_position)

        # Set config layer fields when user add new layer into the TOC
        QgsProject.instance().legendLayersAdded.connect(self.get_new_layers_name)

        # Put add layers button into toc
        self.add_layers_button()

        # Hide info button if giswater project is loaded
        if show_warning:
            self.set_info_button_visible(False)

        # Open automatically 'search docker' depending its value in user settings
        open_search = self.controller.get_user_setting_value('open_search', 'true')
        if open_search == 'true':
            self.basic.basic_api_search()

        # call dynamic mapzones repaint
        self.parent.set_style_mapzones()

        # Log it
        message = "Project read successfully"
        self.controller.log_info(message)


    def get_buttons_to_hide(self):

        self.list_to_hide = []
        try:
            # db format of value for parameter qgis_toolbar_hidebuttons -> {"index_action":[199, 74,75]}
            row = self.controller.get_config('qgis_toolbar_hidebuttons')
            if not row:
                return
            json_list = json.loads(row[0], object_pairs_hook=OrderedDict)
            self.list_to_hide = [str(x) for x in json_list['action_index']]
        except KeyError:
            pass
        except JSONDecodeError:
            # Control if json have a correct format
            pass
        finally:
            # TODO remove this line when do you want enabled api info for epa
            self.list_to_hide.append('199')


    def add_layers_button(self):

        icon_path = self.plugin_dir + '/icons/306.png'
        dockwidget = self.iface.mainWindow().findChild(QDockWidget, 'Layers')
        toolbar = dockwidget.findChildren(QToolBar)[0]
        btn_exist = toolbar.findChild(QToolButton, 'gw_add_layers')

        if btn_exist is None:
            self.btn_add_layers = QToolButton()
            self.btn_add_layers.setIcon(QIcon(icon_path))
            self.btn_add_layers.setObjectName('gw_add_layers')
            self.btn_add_layers.setToolTip('Load giswater layer')
            toolbar.addWidget(self.btn_add_layers)
            self.btn_add_layers.clicked.connect(partial(self.create_add_layer_menu))


    def create_add_layer_menu(self):

        # Create main menu and get cursor click position
        main_menu = QMenu()
        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)
        schema_name = self.schema_name.replace('"', '')
        # Get parent layers
        sql = ("SELECT distinct ( CASE parent_layer WHEN 'v_edit_node' THEN 'Node' "
               "WHEN 'v_edit_arc' THEN 'Arc' WHEN 'v_edit_connec' THEN 'Connec' "
               "WHEN 'v_edit_gully' THEN 'Gully' END ), parent_layer FROM cat_feature"
               " ORDER BY parent_layer")
        parent_layers = self.controller.get_rows(sql)

        for parent_layer in parent_layers:


            # Get child layers
            sql = (f"SELECT DISTINCT(child_layer), lower(feature_type), id as alias FROM cat_feature "
                   f"WHERE parent_layer = '{parent_layer[1]}' "
                   f"AND child_layer IN ("
                   f"   SELECT table_name FROM information_schema.tables"
                   f"   WHERE table_schema = '{schema_name}')"
                   f" ORDER BY child_layer")

            child_layers = self.controller.get_rows(sql)
            if not child_layers:
                continue

            # Create sub menu
            sub_menu = main_menu.addMenu(str(parent_layer[0]))
            child_layers.insert(0, ['Load all', 'Load all', 'Load all'])
            for child_layer in child_layers:
                # Create actions
                action = QAction(str(child_layer[2]), sub_menu, checkable=True)

                # Get load layers and create child layers menu (actions)
                layers_list = []
                layers = self.iface.mapCanvas().layers()
                for layer in layers:
                    layers_list.append(str(layer.name()))

                if str(child_layer[0]) in layers_list:
                    action.setChecked(True)

                sub_menu.addAction(action)
                if child_layer[0] == 'Load all':
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc,
                        child_layers=child_layers, group=None))
                else:
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc,
                        child_layer[0], "the_geom", child_layer[1] + "_id", None, None))

        main_menu.exec_(click_point)


    def get_new_layers_name(self, layers_list):

        layers_name = []
        for layer in layers_list:
            layer_source = self.controller.get_layer_source(layer)
            # Collect only the layers of the work scheme
            if 'schema' in layer_source:
                schema = layer_source['schema']
                if schema and schema.replace('"', '') == self.schema_name:
                    layers_name.append(layer.name())

        self.set_layer_config(layers_name)


    def manage_layers(self):
        """ Get references to project main layers """

        # Check if we have any layer loaded
        layers = self.controller.get_layers()
        if len(layers) == 0:
            return False

        if self.project_type in ('ws', 'ud'):
            QApplication.setOverrideCursor(Qt.ArrowCursor)
            self.check_project_result = CheckProjectResult(self.iface, self.settings, self.controller, self.plugin_dir)
            self.check_project_result.set_controller(self.controller)

            # check project
            status, result = self.check_project_result.populate_audit_check_project(layers, "true")
            try:
                if 'actions' in result['body']:
                    if 'setQgisLayers' in result['body']['actions']:
                        self.set_qgis_layers = result['body']['actions']['setQgisLayers']
                    if 'useGuideMap' in result['body']['actions']:
                        guided_map = result['body']['actions']['useGuideMap']
                        if guided_map:
                            self.controller.log_info("manage_guided_map")
                            self.manage_guided_map()
            except Exception as e:
                self.controller.log_info(str(e))
            finally:
                QApplication.restoreOverrideCursor()
                return status

        return True


    def manage_snapping_layers(self):
        """ Manage snapping of layers """

        self.manage_snapping_layer('v_edit_arc', snapping_type=2)
        self.manage_snapping_layer('v_edit_connec', snapping_type=0)
        self.manage_snapping_layer('v_edit_node', snapping_type=0)
        self.manage_snapping_layer('v_edit_gully', snapping_type=0)


    def manage_snapping_layer(self, layername, snapping_type=0, tolerance=15.0):
        """ Manage snapping of @layername """

        layer = self.controller.get_layer_by_tablename(layername)
        if not layer:
            return
        if snapping_type == 0:
            snapping_type = QgsPointLocator.Vertex
        elif snapping_type == 1:
            snapping_type = QgsPointLocator.Edge
        elif snapping_type == 2:
            snapping_type = QgsPointLocator.All
        QgsSnappingUtils.LayerConfig(layer, snapping_type, tolerance, QgsTolerance.Pixels)


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


    def action_triggered(self, function_name):
        """ Action with corresponding funcion name has been triggered """

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



    def project_read_pl(self):
        """ Function executed when a user opens a QGIS project of type 'pl' """

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Log it
        message = "Project read successfully ('pl')"
        self.controller.log_info(message)


    def project_read_tm(self):
        """ Function executed when a user opens a QGIS project of type 'tm' """

        # Set actions classes (define one class per plugin toolbar)
        self.tm_basic = TmBasic(self.iface, self.settings, self.controller, self.plugin_dir)
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


    def get_value_from_metadata(self, parameter, default_value):
        """ Get @parameter from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = f"Metadata file not found: {metadata_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return default_value

        value = None
        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = f"Parameter not found: {parameter}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            value = default_value
        finally:
            return value


    def get_layers_to_config(self):
        """ Get available layers to be configured """

        schema_name = self.schema_name.replace('"', '')
        sql = (f"SELECT DISTINCT(parent_layer) FROM cat_feature "
              f"UNION "
              f"SELECT DISTINCT(child_layer) FROM cat_feature "
              f"WHERE child_layer IN ("
              f"     SELECT table_name FROM information_schema.tables"
              f"     WHERE table_schema = '{schema_name}')")
        rows = self.controller.get_rows(sql)
        self.available_layers = [layer[0] for layer in rows]

        all_layers_toc = self.controller.get_layers()
        for layer in all_layers_toc:
            layer_source = self.controller.get_layer_source(layer)
            # Filter to take only the layers of the current schema
            if 'schema' in layer_source:
                schema = layer_source['schema']
                if schema and schema.replace('"', '') == self.schema_name:
                    table_name = f"{self.controller.get_layer_source_table_name(layer)}"
                    self.available_layers.append(table_name)


    def set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable') """

        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError:
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def set_layer_config(self, layers):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos as ValueMap, typeahead as textedit"""

        msg_failed = ""
        msg_key = ""
        for layer_name in layers:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                continue

            feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
            extras = f'"infoType":"{self.qgis_project_infotype}"'
            body = self.create_body(feature=feature, extras=extras)
            complet_result = self.controller.get_json('gw_fct_getinfofromid', body)
            if not complet_result:
                continue

            for field in complet_result['body']['data']['fields']:
                valuemap_values = {}

                # Get column index
                fieldIndex = layer.fields().indexFromName(field['columnname'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['columnname'], field['hidden'])

                # Set alias column
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                if 'widgetcontrols' in field:
                    # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                    if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                        self.set_column_multiline(layer, field, fieldIndex)

                    # Set field constraints
                    if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                        if field['widgetcontrols']['setQgisConstraints'] is True:
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                                                     QgsFieldConstraints.ConstraintStrengthSoft)
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintUnique,
                                                     QgsFieldConstraints.ConstraintStrengthHard)

                if 'ismandatory' in field and not field['ismandatory']:
                    layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                                             QgsFieldConstraints.ConstraintStrengthSoft)
                # Manage editability
                self.set_read_only(layer, field, fieldIndex)

                # Manage new values in ValueMap
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        # Set values
                        for i in range(0, len(field['comboIds'])):
                            valuemap_values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                elif field['widgettype'] == 'text':
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                elif field['widgettype'] == 'check':
                    config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                    editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
                elif field['widgettype'] == 'datetime':
                    config = {'allow_null': True,
                              'calendar_popup': True,
                              'display_format': 'yyyy-MM-dd',
                              'field_format': 'yyyy-MM-dd',
                              'field_iso_format': False}
                    editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


        if msg_failed != "":
            self.controller.show_exceptions_msg("Execute failed.", msg_failed)

        if msg_key != "":
            self.controller.show_exceptions_msg("Key on returned json from ddbb is missed.", msg_key)


    def set_column_visibility(self, layer, col_name, hidden):
        """ Hide selected fields according table config_api_form_fields.hidden """

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, layer, field, fieldIndex):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
        form = '"form":{' + form + '}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def get_qgis_project_variables(self):
        """ Manage qgis project variables """

        self.qgis_project_infotype = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('gwInfoType')
        self.qgis_project_add_schema = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('gwAddSchema')
        self.qgis_project_main_schema = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('gwMainSchema')
        self.qgis_project_role = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('gwProjectRole')
        self.controller.plugin_settings_set_value("gwInfoType", self.qgis_project_infotype)
        self.controller.plugin_settings_set_value("gwAddSchema", self.qgis_project_add_schema)
        self.controller.plugin_settings_set_value("gwMainSchema", self.qgis_project_main_schema)
        self.controller.plugin_settings_set_value("gwProjectRole", self.qgis_project_role)


    def manage_guided_map(self):
        """ Guide map works using ext_municipality """

        self.layer_muni = self.controller.get_layer_by_tablename('ext_municipality')
        if self.layer_muni is None:
            return

        self.iface.setActiveLayer(self.layer_muni)
        self.controller.set_layer_visible(self.layer_muni)
        self.layer_muni.selectAll()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()
        self.iface.actionSelect().trigger()
        self.iface.mapCanvas().selectionChanged.connect(self.selection_changed)
        cursor = self.get_cursor_multiple_selection()
        if cursor:
            self.iface.mapCanvas().setCursor(cursor)


    def selection_changed(self):
        """ Get selected muni_id and execute function setselectors """

        muni_id = None
        features = self.layer_muni.getSelectedFeatures()
        for feature in features:
            muni_id = feature["muni_id"]
            self.controller.log_info(f"Selected muni_id: {muni_id}")
            break

        self.iface.mapCanvas().selectionChanged.disconnect()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()

        if muni_id is None:
            return

        extras = f'"selectorType":"explfrommuni", "id":{muni_id}, "value":true, "isAlone":true, '
        extras += f'"addSchema":"{self.qgis_project_add_schema}"'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_fct_setselectors({body})::text"
        row = self.controller.get_row(sql, commit=True, log_sql=True)
        if row:
            self.iface.mapCanvas().refreshAllLayers()
            self.layer_muni.triggerRepaint()

            # For trigger Giswater info
            action_info = self.iface.mainWindow().findChild(QAction, 'map_tool_api_info_data')
            action_info.trigger()


    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """

        icon_path = self.plugin_dir + '/icons/211.png'
        if os.path.exists(icon_path):
            cursor = QCursor(QPixmap(icon_path))
        else:
            cursor = None

        return cursor
