"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from json import JSONDecodeError

from qgis.core import Qgis, QgsDataSourceUri, QgsEditorWidgetSetup, QgsExpressionContextUtils, QgsFieldConstraints
from qgis.core import QgsPointLocator, QgsProject, QgsSnappingUtils, QgsTolerance, QgsVectorLayer
from qgis.PyQt.QtCore import QObject, QPoint, QSettings, Qt
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QActionGroup, QApplication, QCheckBox, QDockWidget
from qgis.PyQt.QtWidgets import QGridLayout, QGroupBox, QMenu, QLabel, QSizePolicy, QToolBar, QToolButton
from qgis.PyQt.QtGui import QIcon, QKeySequence, QCursor

import configparser
import os.path
import sys
import webbrowser
from collections import OrderedDict
from functools import partial

from . import utils_giswater
from .actions.add_layer import AddLayer
from .actions.basic import Basic
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
from .map_tools.open_visit import OpenVisit
from .models.plugin_toolbar import PluginToolbar
from .models.sys_feature_cat import SysFeatureCat
from .ui_manager import AuditCheckProjectResult



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
            
        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        self.plugin_name = self.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        # Check if config file exists
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name + '.config')
        if not os.path.exists(setting_file):
            message = "Config file not found at: " + setting_file
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

        if sys.version[0] == '2':
            reload(sys)
            sys.setdefaultencoding("utf-8")


    def set_signals(self): 
        """ Define widget and event signals """

        try:
            self.iface.projectRead.connect(self.project_read)
            self.iface.newProjectCreated.connect(self.project_new)
        except AttributeError as e:
            pass


    def set_info_button(self):

        self.toolButton = QToolButton()
        self.action_info = self.iface.addToolBarWidget(self.toolButton)

        icon_path = self.icon_folder + '36.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            action = QAction(icon, "Show info", self.iface.mainWindow())
        else:
            action = QAction("Show info", self.iface.mainWindow())

        self.toolButton.setDefaultAction(action)

        self.update_sql = UpdateSQL(self.iface, self.settings, self.controller, self.plugin_dir)
        action.triggered.connect(self.update_sql.init_sql)

    
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
        
        try:
            action = self.actions[index_action]                

            # Basic toolbar actions
            if int(index_action) in (32, 41, 48, 86):
                callback_function = getattr(self.basic, function_name)  
                action.triggered.connect(callback_function)
            # Mincut toolbar actions
            elif int(index_action) in (26, 27) and self.wsoftware == 'ws':
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
            elif int(index_action) in (23, 25, 29, 196):
                callback_function = getattr(self.go2epa, function_name)
                action.triggered.connect(callback_function)
            # Master toolbar actions
            elif int(index_action) in (45, 46, 47, 38, 49, 50):
                callback_function = getattr(self.master, function_name)
                action.triggered.connect(callback_function)
            # Utils toolbar actions
            elif int(index_action) in (206, 58, 83, 99):
                callback_function = getattr(self.utils, function_name)
                action.triggered.connect(callback_function)
            # Tm Basic toolbar actions
            elif int(index_action) in (301, 302, 303, 304, 305):
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
            if index_action == '01' and feature_cat.feature_type.upper() == 'GULLY' and self.wsoftware == 'ud':
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
        list_actions = (18, 23, 25, 26, 27, 29, 33, 34, 38, 41, 45, 46, 47, 48, 49, 50, 58, 86, 64, 65, 66, 67, 68, 69,
                        74, 75, 76, 81, 82, 83, 84, 98, 99, 196, 206, 301, 302, 303, 304, 305)

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
        elif int(index_action) == 61:
            map_tool = OpenVisit(self.iface, self.settings, action, index_action)
        elif int(index_action) == 71:
            map_tool = CadAddCircle(self.iface, self.settings, action, index_action)
        elif int(index_action) == 72:
            map_tool = CadAddPoint(self.iface, self.settings, action, index_action)

        # If this action has an associated map tool, add this to dictionary of available map_tools
        if map_tool:
            self.map_tools[function_name] = map_tool


    def manage_toolbars_common(self):
        """ Manage actions of the common plugin toolbars """
        self.toolbar_basic()
        self.toolbar_utils()

    def toolbar_basic(self, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "basic"
        if self.controller.get_project_type() == 'ws':
            list_actions = ['37', '41', '48', '86', '32']
        elif self.controller.get_project_type() == 'ud':
            list_actions = ['37', '41', '48', '32']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['37', '41', '48', '32']
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_utils(self, x=None, y=None):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "utils"
        if self.controller.get_project_type() in ('ws', 'ud'):
            list_actions = ['206', '99', '83', '58']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['206', '99', '83', '58']
        self.manage_toolbar(toolbar_id, list_actions)
        if x and y:
            self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)

        self.basic.set_controller(self.controller)
        self.utils.set_controller(self.controller)
        self.basic.set_project_type(self.wsoftware)
        self.utils.set_project_type(self.wsoftware)


    def toolbar_om_ws(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "om_ws"
        list_actions = ['26', '27', '74', '75', '76', '61', '64', '65', '84', '18']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_om_ud(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "om_ud"
        list_actions = ['43', '56', '57', '74', '75', '76', '61', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_edit(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "edit"
        list_actions = ['01', '02', '44', '16', '17', '28', '20', '68', '69', '39', '34', '66', '33', '67']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_cad(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "cad"
        list_actions = ['71', '72']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_epa(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "epa"
        list_actions = ['199', '196', '23', '25', '29']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def toolbar_master(self, x=0, y=0):
        """ Function called in def manage_toolbars(...)
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])
        """
        toolbar_id = "master"
        list_actions = ['45', '46', '47', '38', '49', '50']
        self.manage_toolbar(toolbar_id, list_actions)
        self.set_toolbar_position(self.tr('toolbar_' + toolbar_id + '_name'), x, y)


    def save_toolbars_position(self):

        parser = configparser.ConfigParser(comment_prefixes='/', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), self.plugin_name)
        config_folder = main_folder + os.sep + "config" + os.sep
        if not os.path.exists(config_folder):
            os.makedirs(config_folder)
        path = config_folder + 'ui_config.config'
        parser.read(path)

        # Get all QToolBar
        widget_list = self.iface.mainWindow().findChildren(QToolBar)

        x=0
        own_toolbars=[]
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

        if len(own_toolbars)==8:
            for w in own_toolbars:
                parser['toolbars_position']['pos_' + str(x)] = (w.property('gw_name') + "," + str(w.x()) + "," + str(w.y()))
                x+=1
            with open(path, 'w') as configfile:
                parser.write(configfile)
                configfile.close()


    def set_toolbar_position(self, tb_name, x, y):

        toolbar = self.iface.mainWindow().findChild(QToolBar, tb_name)
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

        # Call each of the functions that configure the toolbars 'def toolbar_xxxxx(self, x=0, y=0):'
        for x in range(0,8):
            toolbar_id = parser.get("toolbars_position", 'pos_'+str(x)).split(',')
            if toolbar_id:
                getattr(self, 'toolbar_'+str(toolbar_id[0]))(toolbar_id[1], toolbar_id[2])

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            ag.setProperty('gw_name','gw_QActionGroup')
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)

        # Disable and hide all plugin_toolbars and actions
        self.enable_toolbars(False)

        self.edit.set_controller(self.controller)
        self.go2epa.set_controller(self.controller)
        self.master.set_controller(self.controller)
        if self.wsoftware == 'ws':
            self.mincut.set_controller(self.controller)
        self.om.set_controller(self.controller)

        self.edit.set_project_type(self.wsoftware)
        self.go2epa.set_project_type(self.wsoftware)
        self.master.set_project_type(self.wsoftware)
        self.om.set_project_type(self.wsoftware)

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

        # Force project read (to work with PluginReloader)
        self.project_read(False)


    def manage_feature_cat(self):
        """ Manage records from table 'cat_feature' """

        # Dictionary to keep every record of table 'cat_feature'
        # Key: field tablename
        # Value: Object of the class SysFeatureCat

        self.feature_cat = {}

        if self.wsoftware.upper() == 'WS':
            sql = ("SELECT cat_feature.* FROM cat_feature JOIN " 
                  "(SELECT id,active FROM node_type UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE ORDER BY id")
        elif self.wsoftware.upper() == 'UD':
            sql = ("SELECT cat_feature.* FROM cat_feature JOIN "
                   "(SELECT id,active FROM node_type UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE ORDER BY id")

        rows = self.controller.get_rows(sql, commit=True)

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


    def unload(self, remove_modules=True):
        """ Removes plugin menu items and icons from QGIS GUI """

        if self.btn_add_layers:
            dockwidget = self.iface.mainWindow().findChild(QDockWidget, 'Layers')
            toolbar = dockwidget.findChildren(QToolBar)[0]
            # TODO improve this, now remove last action
            toolbar.removeAction(toolbar.actions()[len(toolbar.actions())-1])
            self.btn_add_layers = None

        # Save toolbar position after unload plugin
        try:
            self.save_toolbars_position()
        except Exception as e:
            pass

        try:
            # Unlisten notify channel and stop thread
            if self.settings.value('system_variables/use_notify').upper() == 'TRUE' and hasattr(self, 'notify'):
                list_channels = ['desktop', self.controller.current_user]
                self.notify.stop_listening(list_channels)

            # Remove icon of action 'Info'
            self.iface.removeToolBarIcon(self.action_info)

            for action in list(self.actions.values()):
                self.iface.removePluginMenu(self.plugin_name, action)
                self.iface.removeToolBarIcon(action)

            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(False)                
                    del plugin_toolbar.toolbar

            if remove_modules:
                # unload all loaded giswater related modules
                for mod_name, mod in list(sys.modules.items()):
                    if mod and hasattr(mod, '__file__') and self.plugin_dir in mod.__file__:
                        del sys.modules[mod_name]

            # Reset instance attributes
            self.actions = {}
            self.map_tools = {}
            self.srid = None
            self.plugin_toolbars = {}

        except Exception as e:
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

        for i in range(start, stop+1):
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


    def project_new(self):
        """ Function executed when a user creates a new QGIS project """

        self.unload(False)
        self.set_info_button()
        self.enable_info_button(True)

                          
    def project_read(self, show_warning=True): 
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Unload plugin before reading opened project
        self.unload(False)

        self.controller = DaoController(self.settings, self.plugin_name, self.iface, create_logger=show_warning)
        self.controller.set_plugin_dir(self.plugin_dir)
        self.controller.set_qgis_settings(self.qgis_settings)
        self.controller.set_giswater(self)
        self.connection_status, not_version = self.controller.set_database_connection()
        if not self.connection_status or not_version:
            message = self.controller.last_error
            if show_warning:
                if message:
                    self.controller.show_warning(message, 15)
                self.controller.log_warning(str(self.controller.layer_source))
            return

        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)

        # Get schema name from table 'v_edit_node' and set it in controller and in config file
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if not layer:
            self.controller.show_warning("Layer not found", parameter="v_edit_node")
            return

        self.controller.get_current_user()
        layer_source = self.controller.get_layer_source(layer)
        self.schema_name = layer_source['schema']
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)
        self.controller.set_schema_name(self.schema_name)

        # Set PostgreSQL parameter 'search_path'
        self.controller.set_search_path(layer_source['db'], layer_source['schema'])
        self.controller.log_info("Set search_path")

        self.set_info_button()

        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)

        # Check if schema exists
        self.schema_exists = self.controller.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)

        # Get SRID from table node
        self.srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", self.srid)

        self.parent = ParentAction(self.iface, self.settings, self.controller, self.plugin_dir)
        self.add_layer = AddLayer(self.iface, self.settings, self.controller, self.plugin_dir)

        # Set common plugin toolbars (one action class per toolbar)
        self.basic = Basic(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic.set_giswater(self)
        self.utils = Utils(self.iface, self.settings, self.controller, self.plugin_dir)

        # Get water software from table 'version'
        self.wsoftware = self.controller.get_project_type()

        # Manage project read of type 'tm'
        if self.wsoftware == 'tm':
            self.project_read_tm(show_warning)
            return

        # Manage project read of type 'pl'
        elif self.wsoftware == 'pl':
            self.project_read_pl(show_warning)
            return

        # Set custom plugin toolbars (one action class per toolbar)
        self.go2epa = Go2Epa(self.iface, self.settings, self.controller, self.plugin_dir)
        self.om = Om(self.iface, self.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, self.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, self.settings, self.controller, self.plugin_dir)
        if self.wsoftware == 'ws':
            self.mincut = MincutParent(self.iface, self.settings, self.controller, self.plugin_dir)

        # Manage layers
        if not self.manage_layers():
            return

        # Manage records from table 'cat_feature'
        self.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        self.list_to_hide = []
        try:
            #db format of value for parameter qgis_toolbar_hidebuttons -> {"index_action":[199, 74,75]}
            row = self.controller.get_config('qgis_toolbar_hidebuttons')
            json_list = json.loads(row[0], object_pairs_hook=OrderedDict)
            self.list_to_hide = [str(x) for x in json_list['action_index']]
        except  KeyError as e:
            pass
        except JSONDecodeError as e:
            # Control if json have a correct format
            pass
        finally:
             # TODO remove this line when do you want enabled api info for epa
             self.list_to_hide.append('199')

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)
            
        # Set objects for map tools classes
        self.manage_map_tools()

        # Set layer custom UI forms and init function for layers 'arc', 'node', and 'connec' and 'gully'  
        self.manage_custom_forms()
        
        # Initialize parameter 'node2arc'
        self.controller.plugin_settings_set_value("node2arc", "0")        
        
        # Check roles of this user to show or hide toolbars 
        self.controller.check_user_roles()
        
        # Manage project variable 'expl_id'
        self.manage_expl_id()

        # Manage layer fields
        self.get_layers_to_config()
        self.set_layer_config(self.available_layers)

        # Disable info button
        self.enable_info_button(False)

        # Create a thread to listen selected database channels
        if self.settings.value('system_variables/use_notify').upper() == 'TRUE':
            self.notify = NotifyFunctions(self.iface, self.settings, self.controller, self.plugin_dir)
            list_channels = ['desktop', self.controller.current_user]
            self.notify.start_listening(list_channels)

        # Save toolbar position after save project
        self.iface.actionSaveProject().triggered.connect(self.save_toolbars_position)

        # Set config layer fields when user add new layer into the TOC
        QgsProject.instance().legendLayersAdded.connect(self.get_new_layers_name)
        # QgsProject.instance().legendLayersAdded.connect(self.add_layers_button)

        # Put add layers button into toc
        self.add_layers_button()

        # Log it
        message = "Project read successfully"
        self.controller.log_info(message)


    def enable_info_button(self, enable=True):
        """ Enable/Disable info button """

        if self.action_info:
            self.action_info.setEnabled(enable)


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
        parent_layers = self.controller.get_rows(sql, log_sql=True, commit=True)

        for parent_layer in parent_layers:
            # Create sub menu
            sub_menu = main_menu.addMenu(str(parent_layer[0]))

            # Get child layers
            sql = (f"SELECT DISTINCT(child_layer), lower(feature_type), id as alias FROM cat_feature "
                   f"WHERE parent_layer = '{parent_layer[1]}' "
                   f"AND child_layer IN ("
                   f"   SELECT table_name FROM information_schema.tables"
                   f"   WHERE table_schema = '{schema_name}')"
                   f" ORDER BY child_layer")


            child_layers = self.controller.get_rows(sql, log_sql=True, commit=True)
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
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc, child_layers=child_layers, group=None))
                else:
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc, child_layer[0], "the_geom", child_layer[1]+"_id", None, None))

        main_menu.exec_(click_point)


    def get_new_layers_name(self, layers_list):
        layers_name = []
        for layer in layers_list:
            layer_source = self.controller.get_layer_source(layer)
            # Collect only the layers of the work scheme
            if 'schema' in layer_source and layer_source['schema'] == self.schema_name:
                layers_name.append(layer.name())

        self.set_layer_config(layers_name)


    def manage_layers(self):
        """ Get references to project main layers """

        # Initialize variables
        self.layer_arc = None
        self.layer_connec = None
        self.layer_dimensions = None
        self.layer_gully = None
        self.layer_node = None

        # Check if we have any layer loaded
        layers = self.controller.get_layers()

        if len(layers) == 0:
            return False

        # Iterate over all layers
        for cur_layer in layers:

            uri_table = self.controller.get_layer_source_table_name(cur_layer)   #@UnusedVariable
            if uri_table:

                if 'v_edit_arc' == uri_table:
                    self.layer_arc = cur_layer

                elif 'v_edit_connec' == uri_table:
                    self.layer_connec = cur_layer

                elif 'v_edit_dimensions' == uri_table:
                    self.layer_dimensions = cur_layer

                elif 'v_edit_gully' == uri_table:
                    self.layer_gully = cur_layer

                elif 'v_edit_node' == uri_table:
                    self.layer_node = cur_layer

        if self.wsoftware in ('ws', 'ud'):
            QApplication.setOverrideCursor(Qt.ArrowCursor)
            layers = self.controller.get_layers()
            status = self.populate_audit_check_project(layers)
            QApplication.restoreOverrideCursor()
            if not status:
                return False

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


    def manage_custom_forms(self):
        """ Set layer custom UI form and init function """

        # Set custom for layer dimensions
        self.set_layer_custom_form_dimensions(self.layer_dimensions)                     

        
    def set_layer_custom_form_dimensions(self, layer):
 
        if layer is None:
            return
        
        name_ui = 'dimensions.ui'
        name_init = 'dimensions.py'
        name_function = 'formOpen'
        file_ui = os.path.join(self.plugin_dir, 'ui', name_ui)
        file_init = os.path.join(self.plugin_dir, 'init', name_init)                     
        layer.editFormConfig().setUiForm(file_ui) 
        layer.editFormConfig().setInitCodeSource(1)
        layer.editFormConfig().setInitFilePath(file_init)           
        layer.editFormConfig().setInitFunction(name_function)
        
        if self.wsoftware == 'ws':
            fieldname_node = "depth"
            fieldname_connec = "depth"
        elif self.wsoftware == 'ud':
            fieldname_node = "ymax"
            fieldname_connec = "connec_depth"

        if self.layer_node:
            display_field = 'depth : [% "' + fieldname_node + '" %]'
            self.layer_node.setMapTipTemplate(display_field)
            self.layer_node.setDisplayExpression(display_field)

        if self.layer_connec:
            display_field = 'depth : [% "' + fieldname_connec + '" %]'
            self.layer_connec.setMapTipTemplate(display_field)
            self.layer_connec.setDisplayExpression(display_field)

    
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
            self.set_map_tool('map_tool_open_visit')


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
                map_tool = self.map_tools[function_name]
                if not (map_tool == self.iface.mapCanvas().mapTool()):
                    self.iface.mapCanvas().setMapTool(map_tool)
                else:
                    self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))

    def manage_expl_id(self):
        """ Manage project variable 'expl_id' """
        
        # Get project variable 'expl_id'
        try:
            expl_id = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable('expl_id')
        except:
            pass
        
        if expl_id is None:
            return
                    
        # Update table 'selector_expl' of current user (delete and insert)
        sql = ("DELETE FROM selector_expl WHERE current_user = cur_user;"
               "\nINSERT INTO selector_expl (expl_id, cur_user)"
               " VALUES(" + expl_id + ", current_user);")
        self.controller.execute_sql(sql)        


    def populate_audit_check_project(self, layers):
        """ Fill table 'audit_check_project' with layers data """
        sql = ("DELETE FROM audit_check_project"
               " WHERE user_name = current_user AND fprocesscat_id = 1")
        self.controller.execute_sql(sql)
        sql = ""
        for layer in layers:
            if layer is None: continue
            if layer.providerType() in ('memory', 'ogr'): continue
            layer_source = self.controller.get_layer_source(layer)
            if 'schema' not in layer_source or layer_source['schema'] != self.schema_name: continue
            # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
            uri = layer.dataProvider().dataSourceUri()
            if 'SELECT row_number() over ()' in str(uri): continue
            schema_name = layer_source['schema']
            if schema_name is not None:
                schema_name = schema_name.replace('"', '')
                table_name = layer_source['table']
                db_name = layer_source['db']
                host_name = layer_source['host']
                table_user = layer_source['user']
                sql += ("\nINSERT INTO audit_check_project"
                        " (table_schema, table_id, table_dbname, table_host, fprocesscat_id, table_user)"
                        " VALUES ('" + str(schema_name) + "', '" + str(table_name) + "', '" + str(db_name) + "', '" + str(host_name) + "', 1, '"+str(table_user)+"');")
                
        status = self.controller.execute_sql(sql)
        if not status:
            return False

        version = self.parent.get_plugin_version()
        extras = f'"version":"{version}"'
        extras += f', "fprocesscat_id":1'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_fct_audit_check_project($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, commit=True, log_sql=True)
        
        if not row:
            return False

        result = json.loads(row[0], object_pairs_hook=OrderedDict)
        if 'status' in result and result['status'] == 'Failed':
            try:
                title = "Execute failed."
                msg = f"<b>Error: </b>{result['SQLERR']}<br>"
                msg += f"<b>Context: </b>{result['SQLCONTEXT']} <br><br>"
            except KeyError as e:
                title = "Key on returned json from ddbb is missed."
                msg = f"<b>Key: </b>{e}<br>"
                msg += f"<b>Python file: </b>{__name__} <br>"
                msg += f"<b>Python function: </b>{self.populate_audit_check_project.__name__} <br><br>"
            self.controller.show_exceptions_msg(title, msg)
            return True

        self.dlg_audit_project = AuditCheckProjectResult()
        self.parent.load_settings(self.dlg_audit_project)
        self.dlg_audit_project.rejected.connect(partial(self.parent.save_settings, self.dlg_audit_project))

        # Populate info_log and missing layers
        critical_level = 0
        text_result = self.add_layer.add_temp_layer(self.dlg_audit_project, result['body']['data'], 'gw_fct_audit_check_project_result', True, False, 0, True)

        if 'missingLayers' in result['body']['data']:
            critical_level= self.get_missing_layers(self.dlg_audit_project, result['body']['data']['missingLayers'], critical_level)

        self.parent.hide_void_groupbox(self.dlg_audit_project)

        if int(critical_level) > 0 or text_result:
            row = self.controller.get_config('qgis_form_initproject_hidden')
            if row and row[0].lower() == 'false':
                self.dlg_audit_project.btn_accept.clicked.connect(partial(self.add_selected_layers))
                self.dlg_audit_project.chk_hide_form.stateChanged.connect(partial(self.update_config))
                self.parent.open_dialog(self.dlg_audit_project)

        return True


    def update_config(self, state):
        """ Set qgis_form_initproject_hidden True or False into config_param_user """
        value = {0:"False", 2:"True"}
        sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
               f" VALUES('qgis_form_initproject_hidden', '{value[state]}', current_user) "
               f" ON CONFLICT  (parameter, cur_user) "
               f" DO UPDATE SET value='{value[state]}'")
        self.controller.execute_sql(sql, log_sql=True)
        

    def get_missing_layers(self, dialog, m_layers, critical_level):

        grl_critical = dialog.findChild(QGridLayout, "grl_critical")
        grl_others = dialog.findChild(QGridLayout, "grl_others")
        msg = ""
        exceptions = []
        for pos, item in enumerate(m_layers):
            try:
                if not item: continue
                widget = dialog.findChild(QCheckBox, f"{item['layer']}")
                # If it is the case that a layer is necessary for two functions,
                # and the widget has already been put in another iteration
                if widget: continue
                label = QLabel()
                label.setObjectName(f"lbl_{item['layer']}")
                label.setText(f'<b>{item["layer"]}</b><font size="2";> {item["qgis_message"]}</font>')

                critical_level = int(item['criticity']) if int(item['criticity']) > critical_level else critical_level
                widget = QCheckBox()
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                widget.setObjectName(f"{item['layer']}")
                widget.setProperty('field_id', item['id'])
                if int(item['criticity']) == 3:
                    grl_critical.addWidget(label, pos, 0)
                    grl_critical.addWidget(widget, pos, 1)
                else:
                    grl_others.addWidget(label, pos, 0)
                    grl_others.addWidget(widget, pos, 1)
            except KeyError as e:
                if type(e).__name__ not in exceptions:
                    exceptions.append(type(e).__name__)
                    msg += f"<b>Key: </b>{e}<br>"
                    msg += f"<b>Python file: </b>{__name__} <br>"
                    msg += f"<b>Python function: </b>{self.get_missing_layers.__name__} <br>"
        if "KeyError" in exceptions:
            self.controller.show_exceptions_msg("Key on returned json from ddbb is missed.", msg)
        return critical_level


    def add_selected_layers(self):
        checks = self.dlg_audit_project.scrollArea.findChildren(QCheckBox)
        schemaname = self.schema_name.replace('"','')
        for check in checks:
            if check.isChecked():
                sql = (f"SELECT attname FROM pg_attribute a "
                       f" JOIN pg_class t on a.attrelid = t.oid "
                       f" JOIN pg_namespace s on t.relnamespace = s.oid "
                       f" WHERE a.attnum > 0  AND NOT a.attisdropped  AND t.relname = '{check.objectName()}' "
                       f" AND s.nspname = '{schemaname}' "
                       f" AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)='geometry' "
                       f" ORDER BY a.attnum limit 1")
                the_geom = self.controller.get_row(sql, commit=True)
                if not the_geom: the_geom = [None]
                self.add_layer.from_postgres_to_toc(check.objectName(), the_geom[0], check.property('field_id'), None)
        self.parent.close_dialog(self.dlg_audit_project)


    def project_read_pl(self, show_warning=True):
        """ Function executed when a user opens a QGIS project of type 'pl' """

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Log it
        message = "Project read successfully ('pl')"
        self.controller.log_info(message)


    def project_read_tm(self, show_warning=True):
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
        list_actions = ['303', '301', '302', '304', '305']
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
            message = "Metadata file not found: " + metadata_file
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return default_value

        value = None
        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = "Parameter not found: " + parameter
            self.iface.messageBar().pushMessage("", message, 1, 20)
            value = default_value
        finally:
            return value


    def get_layers_to_config(self):

        """ Get available layers to be configured """
        schema_name = self.schema_name.replace('"','')
        sql =(f"SELECT DISTINCT(parent_layer) FROM cat_feature " 
              f"UNION " 
              f"SELECT DISTINCT(child_layer) FROM cat_feature "
              f"WHERE child_layer IN ("
              f"     SELECT table_name FROM information_schema.tables"
              f"     WHERE table_schema = '{schema_name}')")
        rows = self.controller.get_rows(sql, commit=True)
        self.available_layers = [layer[0] for layer in rows]

        self.set_form_suppress(self.available_layers)
        all_layers_toc = self.controller.get_layers()
        for layer in all_layers_toc:
            layer_source = self.controller.get_layer_source(layer)
            # Filter to take only the layers of the current schema
            if 'schema' not in layer_source or layer_source['schema'] != self.schema_name: continue
            table_name = f"{self.controller.get_layer_source_table_name(layer)}"
            self.available_layers.append(table_name)


    def set_form_suppress(self, layers_list):
        """ Set form suppress on "Hide form on add feature (global settings) """
        for layer_name in layers_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if layer is None: continue
            config = layer.editFormConfig()
            config.setSuppress(0)
            layer.setEditFormConfig(config)


    def set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable')"""
        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError as e:
            # Control if key 'iseditable' not exist
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def set_layer_config(self, layers):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos and typeahead as ValueMap"""
        msg_failed = ""
        msg_key = ""
        for layer_name in layers:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                # msg = f"Layer {layer_name} does not found, therefore, not configured."
                # self.controller.show_warning(msg)
                continue
                
            feature = '"tableName":"' + str(layer_name) + '", "id":""'
            body = self.create_body(feature=feature)
            sql = (f"SELECT gw_api_getinfofromid($${{{body}}}$$)")
            row = self.controller.get_row(sql, commit=True, log_sql=True)
            if not row:
                self.controller.show_message("NOT ROW FOR: " + sql, 2)
                continue
            complet_result = row[0]
            # When info is nothing
            if 'results' in complet_result:
                if complet_result['results'] == 0:
                    self.controller.show_message(complet_result['message']['text'], 1)
                    continue

            if 'status' in complet_result and complet_result['status'] == 'Failed':
                print(sql)
                try:
                    msg_failed += f"<b>Error: </b>{complet_result['SQLERR']}<br>"
                    msg_failed += f"<b>Context: </b>{complet_result['SQLCONTEXT']} <br><br>"
                except KeyError as e:
                    msg_key += f"<b>Key: </b>{e}<br>"
                    msg_key += f"<b>Python file: </b>{__name__} <br>"
                    msg_key += f"<b>Python function: </b>{self.set_layer_config.__name__} <br><br>"
                continue

            for field in complet_result['body']['data']['fields']:
                _values = {}

                # Get column index
                fieldIndex = layer.fields().indexFromName(field['column_id'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['column_id'], field['hidden'])

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

                # Manage editability
                self.set_read_only(layer, field, fieldIndex)

                # Manage fields
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        # Set values
                        for i in range(0, len(field['comboIds'])):
                            _values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
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

        client = '"client":{"device":9, "infoType":100, "lang":"ES"}, '
        form = '"form":{' + form + '}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras is not None:
            data += ', ' + extras
        data += '}'
        body = "" + client + form + feature + data

        return body