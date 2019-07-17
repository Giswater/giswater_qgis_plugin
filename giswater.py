"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    import ConfigParser as configparser
else:
    import configparser
    from qgis.core import QgsSnappingUtils, QgsPointLocator, QgsTolerance

from qgis.core import QgsExpressionContextUtils, QgsProject
from qgis.PyQt.QtCore import QObject, QSettings, Qt
from qgis.PyQt.QtWidgets import QAction, QActionGroup, QMenu, QApplication, QAbstractItemView, QToolButton, QDockWidget
from qgis.PyQt.QtGui import QIcon, QKeySequence
from qgis.PyQt.QtSql import QSqlQueryModel

import os.path
import sys
from collections import OrderedDict
from functools import partial

from .actions.basic import Basic
from .actions.edit import Edit
from .actions.go2epa import Go2Epa
from .actions.master import Master
from .actions.mincut import MincutParent
from .actions.om import Om
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
            
        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        self.plugin_name = self.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        # Initialize svg giswater directory
        svg_plugin_dir = os.path.join(self.plugin_dir, 'svg')
        if Qgis.QGIS_VERSION_INT < 29900:
            QgsExpressionContextUtils.setProjectVariable('svg_path', svg_plugin_dir)
        else:
            QgsExpressionContextUtils.setProjectVariable(QgsProject.instance(), 'svg_path', svg_plugin_dir)
            
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

        self.iface.projectRead.connect(self.project_read)
        self.iface.newProjectCreated.connect(self.project_new)


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
            elif int(index_action) in (64, 65, 74, 75, 76, 81, 82, 84):
                callback_function = getattr(self.om, function_name)
                action.triggered.connect(callback_function)
            # Edit toolbar actions
            elif int(index_action) in (1, 2, 33, 34, 66, 67, 68):
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
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
        menu.addSeparator()

        list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if index_action == '01' and feature_cat.feature_type.upper() == 'CONNEC':
                obj_action = QAction(str(feature_cat.id), self)
                obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
        menu.addSeparator()

        list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if index_action == '01' and feature_cat.feature_type.upper() == 'GULLY' and self.wsoftware == 'ud':
                obj_action = QAction(str(feature_cat.id), self)
                obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                menu.addSeparator()
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))

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
        list_actions = (23, 25, 26, 27, 29, 33, 34, 38, 41, 45, 46, 47, 48, 49, 50, 58, 86, 64, 65, 66, 67, 68,
                        74, 75, 76, 81, 82, 83, 84, 98, 99, 196, 206, 301, 302, 303, 304, 305)

        if int(index_action) in list_actions:
            action = self.create_action(index_action, text_action, toolbar, False, function_name, action_group)

        # Buttons checkable (normally related with 'map_tools')                
        else:
            action = self.create_action(index_action, text_action, toolbar, True, function_name, action_group)
        
        return action         


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

        list_actions = None
        toolbar_id = "basic"
        if self.controller.get_project_type() == 'ws':
            list_actions = ['37', '41', '48', '86', '32']
        elif self.controller.get_project_type() == 'ud':
            list_actions = ['37', '41', '48', '32']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['37', '41', '48', '32']
        self.manage_toolbar(toolbar_id, list_actions)

        toolbar_id = "utils"
        if self.controller.get_project_type() in ('ws', 'ud'):
            list_actions = ['206', '99', '83', '58']
        elif self.controller.get_project_type() in ('tm', 'pl'):
            list_actions = ['206', '99', '83', '58']
        self.manage_toolbar(toolbar_id, list_actions)

        self.basic.set_controller(self.controller)
        self.utils.set_controller(self.controller)
        self.basic.set_project_type(self.wsoftware)
        self.utils.set_project_type(self.wsoftware)


    def manage_toolbars(self):
        """ Manage actions of the custom plugin toolbars.
        project_type in ('ws', 'ud')
        """

        toolbar_id = "om_ws"
        list_actions = ['26', '27', '74', '75', '76', '61', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions)

        toolbar_id = "om_ud"
        list_actions = ['43', '56', '57', '74', '75', '76', '61', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions)                           
        
        toolbar_id = "edit"
        list_actions = ['01', '02', '44', '16', '17', '28', '20', '68', '39', '34', '66', '33', '67']
        self.manage_toolbar(toolbar_id, list_actions)   
        
        toolbar_id = "cad"
        list_actions = ['71', '72']               
        self.manage_toolbar(toolbar_id, list_actions)   
        
        toolbar_id = "epa"
        list_actions = ['199', '196', '23', '25', '29']
        self.manage_toolbar(toolbar_id, list_actions)    
        
        toolbar_id = "master"
        list_actions = ['45', '46', '47', '38', '49', '50']               
        self.manage_toolbar(toolbar_id, list_actions)
            
        # Manage action group of every toolbar
        parent = self.iface.mainWindow()           
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
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
        plugin_toolbar.list_actions = list_actions           
        self.plugin_toolbars[toolbar_id] = plugin_toolbar 
                        
           
    def initGui(self):
        """ Create the menu entries and toolbar icons inside the QGIS GUI """

        # Delete python compiled files
        self.delete_pyc_files()  
        
        # Force project read (to work with PluginReloader)
        self.project_read(False)


    def manage_feature_cat(self):
        """ Manage records from table 'sys_feature_type' """

        # Dictionary to keep every record of table 'sys_feature_cat'
        # Key: field tablename
        # Value: Object of the class SysFeatureCat

        self.feature_cat = {}
        sql = ("SELECT * FROM cat_feature "
               "WHERE active is True")
        rows = self.controller.get_rows(sql)

        if not rows:
            return False

        for row in rows:
            tablename = row['child_layer']
            elem = SysFeatureCat(row['id'], row['system_id'], row['feature_type'], row['type'], row['shortcut_key'],
                                 row['parent_layer'], row['child_layer'], row['active'])
            self.feature_cat[tablename] = elem

        self.feature_cat = OrderedDict(sorted(self.feature_cat.items(), key=lambda t: t[0]))

        return True


    def unload(self, remove_modules=True):
        """ Removes plugin menu items and icons from QGIS GUI """

        try:

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
            print(str(e))
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

                          
    def project_read(self, show_warning=True): 
        """ Function executed when a user opens a QGIS project (*.qgs) """


        # Unload plugin before reading opened project
        self.unload(False)

        self.controller = DaoController(self.settings, self.plugin_name, self.iface, create_logger=show_warning)
        self.controller.set_plugin_dir(self.plugin_dir)
        self.controller.set_qgis_settings(self.qgis_settings)
        self.controller.set_giswater(self)
        self.connection_status, not_version = self.controller.set_database_connection()
        self.set_info_button()
        if not self.connection_status or not_version:
            message = self.controller.last_error
            if show_warning:
                if message:
                    self.controller.show_warning(message, 15)
                self.controller.log_warning(str(self.controller.layer_source))
            return

        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)

        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)

        # Get schema name from table 'v_edit_node' and set it in controller and in config file
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if not layer:
            self.controller.show_warning("Layer not found", parameter="v_edit_node")
            return

        layer_source = self.controller.get_layer_source(layer)
        self.schema_name = layer_source['schema']
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)
        self.controller.set_schema_name(self.schema_name)

        # Set PostgreSQL parameter 'search_path'
        self.controller.set_search_path(layer_source['db'], layer_source['schema'])
        self.controller.log_info("Set search_path")
        connection_status, not_version = self.controller.set_database_connection()
        self.set_info_button()
        if not connection_status or not_version:
            message = self.controller.last_error
            if show_warning:
                if message:
                    self.controller.show_warning(message, 15)
                self.controller.log_warning(str(self.controller.layer_source))
            return

        # Check if schema exists
        self.schema_exists = self.controller.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)

        # Get SRID from table node
        self.srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", self.srid)

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

        # Manage records from table 'sys_feature_type'
        self.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        # Get list of actions to hide
        self.list_to_hide = self.settings.value('system_variables/action_to_hide')

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()
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

        # Log it
        message = "Project read successfully"
        self.controller.log_info(message)


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

        if Qgis.QGIS_VERSION_INT < 29900:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, snapping_type, 1, tolerance, False)
        else:
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
            if Qgis.QGIS_VERSION_INT < 29900:
                self.layer_node.setDisplayField(display_field)
            else:
                self.layer_node.setMapTipTemplate(display_field)
                self.layer_node.setDisplayExpression(display_field)

        if self.layer_connec:
            display_field = 'depth : [% "' + fieldname_connec + '" %]'
            if Qgis.QGIS_VERSION_INT < 29900:
                self.layer_connec.setDisplayField(display_field)
            else:
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
       
        
    def delete_pyc_files(self):
        """ Delete python compiled files """
        
        filelist = [ f for f in os.listdir(".") if f.endswith(".pyc") ]
        for f in filelist:
            os.remove(f)


    def manage_expl_id(self):
        """ Manage project variable 'expl_id' """
        
        # Get project variable 'expl_id'
        try:
            if Qgis.QGIS_VERSION_INT < 29900:
                expl_id = QgsExpressionContextUtils.projectScope().variable('expl_id')
            else:
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

        self.dlg_audit_project = AuditCheckProjectResult()
        self.dlg_audit_project.tbl_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.dlg_audit_project.btn_close.clicked.connect(self.dlg_audit_project.close)

        sql = ("DELETE FROM audit_check_project"
               " WHERE user_name = current_user AND fprocesscat_id = 1")
        self.controller.execute_sql(sql)
        sql = ""
        for layer in layers:
            layer_source = self.controller.get_layer_source(layer)
            schema_name = layer_source['schema']
            if schema_name is not None:
                schema_name = schema_name.replace('"', '')
                table_name = layer_source['table']
                db_name = layer_source['db']
                host_name = layer_source['host']
                sql += ("\nINSERT INTO audit_check_project"
                        " (table_schema, table_id, table_dbname, table_host, fprocesscat_id)"
                        " VALUES ('" + str(schema_name) + "', '" + str(table_name) + "', '" + str(db_name) + "', '" + str(host_name) + "', 1);")
                
        status = self.controller.execute_sql(sql)
        if not status:
            return False
                
        sql = ("SELECT gw_fct_audit_check_project(1);")
        row = self.controller.get_row(sql, commit=True)
        if not row:
            return False

        if row[0] == -1:
            message = "This is not a valid Giswater project. Do you want to view problem details?"
            answer = self.controller.ask_question(message, "Warning!")
            if answer:
                sql = ("SELECT * FROM audit_check_project"
                       " WHERE fprocesscat_id = 1 AND enabled = false AND user_name = current_user AND criticity = 3")
                rows = self.controller.get_rows(sql)
                if rows:
                    self.populate_table_by_query(self.dlg_audit_project.tbl_result, sql)
                    self.dlg_audit_project.tbl_result.horizontalHeader().setResizeMode(0)
                    self.dlg_audit_project.exec_()
                    # Fill log file with the names of the layers
                    message = "This is not a valid Giswater project"
                    self.controller.log_info(message)
                    message = ""
                    for row in rows:
                        message += str(row["table_id"]) + "\n"
                    self.controller.log_info(message)                    
            return False

        elif row[0] > 0:
            show_msg = self.settings.value('system_variables/show_msg_layer')
            if show_msg == 'TRUE':
                message = "Some layers of your role not found. Do you want to view them?"
                answer = self.controller.ask_question(message, "Warning")
                if answer:
                    sql = ("SELECT * FROM audit_check_project"
                           " WHERE fprocesscat_id = 1 AND enabled = false AND user_name = current_user")
                    rows = self.controller.get_rows(sql, log_sql=True)
                    if rows:
                        self.populate_table_by_query(self.dlg_audit_project.tbl_result, sql)
                        self.dlg_audit_project.tbl_result.horizontalHeader().setResizeMode(0)
                        self.dlg_audit_project.exec_()
                        # Fill log file with the names of the layers
                        message = "Layers of your role not found"
                        self.controller.log_info(message)
                        message = ""
                        for row in rows:
                            message += str(row["table_id"]) + "\n"
                        self.controller.log_info(message)
            
        return True


    def populate_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """
        
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())


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

