"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
from __future__ import absolute_import
from builtins import range

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

from qgis.core import QgsExpressionContextUtils, QgsProject
from qgis.PyQt.QtCore import QObject, QSettings, Qt
from qgis.PyQt.QtWidgets import QAction, QActionGroup, QMenu, QApplication, QAbstractItemView, QToolButton, QDockWidget
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtSql import QSqlQueryModel

import os.path
import sys  
from functools import partial

from .actions.basic import Basic
from .actions.edit import Edit
from .actions.go2epa import Go2Epa
from .actions.master import Master
from .actions.mincut import MincutParent
from .actions.om import Om
from .actions.update_sql import UpdateSQL
from .actions.utils import Utils
from .dao.controller import DaoController
from .map_tools.cad_add_circle import CadAddCircle
from .map_tools.cad_add_point import CadAddPoint
from map_tools.cad_api_info_data import CadApiInfo
from .map_tools.change_elem_type import ChangeElemType
from .map_tools.connec import ConnecMapTool
from .map_tools.delete_node import DeleteNodeMapTool
from .map_tools.dimensioning import Dimensioning
from .map_tools.draw_profiles import DrawProfiles
from .map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from .map_tools.move_node import MoveNodeMapTool
from .map_tools.replace_node import ReplaceNodeMapTool
from .map_tools.open_visit import OpenVisit
from .models.plugin_toolbar import PluginToolbar
from .models.sys_feature_cat import SysFeatureCat
from .search.search_plus import SearchPlus
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
        self.search_plus = None
        self.map_tools = {}
        self.srid = None  
        self.plugin_toolbars = {}
            
        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)    
        self.plugin_name = os.path.basename(self.plugin_dir).lower()  
        self.icon_folder = self.plugin_dir+'/icons/'    

        # Initialize svg giswater directory
        svg_plugin_dir = os.path.join(self.plugin_dir, 'svg')
        if Qgis.QGIS_VERSION_INT < 29900:
            QgsExpressionContextUtils.setProjectVariable('svg_path', svg_plugin_dir)
        else:
            QgsExpressionContextUtils.setProjectVariable(QgsProject.instance(), 'svg_path', svg_plugin_dir)
            
        # Check if config file exists    
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name + '.config')
        if not os.path.exists(setting_file):
            message = "Config file not found at: "+setting_file
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


    def set_info_button(self, connection_status):

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
        action.triggered.connect(partial(self.update_sql.init_sql, connection_status))

    
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
            elif int(index_action) in (64, 65, 74, 75, 81, 82, 84):
                callback_function = getattr(self.om, function_name)
                action.triggered.connect(callback_function)
            # Edit toolbar actions
            elif int(index_action) in (0o1, 0o2, 33, 34, 66, 67, 68):
                callback_function = getattr(self.edit, function_name)
                action.triggered.connect(callback_function)
            # Go2epa toolbar actions
            elif int(index_action) in (23, 25, 29, 196, 199):
                callback_function = getattr(self.go2epa, function_name)
                action.triggered.connect(callback_function)
            # Master toolbar actions
            elif int(index_action) in (45, 46, 47, 38, 49, 50):
                callback_function = getattr(self.master, function_name)
                action.triggered.connect(callback_function)
            # Utils toolbar actions
            elif int(index_action) in (206, 19, 58, 83, 99):
                callback_function = getattr(self.utils, function_name)
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
        icon_path = self.icon_folder+index_action+'.png'
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
        for feature_cat in list(self.feature_cat.values()):
            if (index_action == '01' and feature_cat.type == 'NODE') or (index_action == '02' and feature_cat.type == 'ARC'):
                obj_action = QAction(str(feature_cat.layername), self)
                obj_action.setShortcut(str(feature_cat.shortcut_key))
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat.layername))
        menu.addSeparator()
        for feature_cat in list(self.feature_cat.values()):
            if index_action == '01' and feature_cat.type == 'CONNEC':
                obj_action = QAction(str(feature_cat.layername), self)
                obj_action.setShortcut(str(feature_cat.shortcut_key))
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat.layername))
        menu.addSeparator()
        for feature_cat in list(self.feature_cat.values()):
            if index_action == '01' and feature_cat.type == 'GULLY' and self.wsoftware == 'ud':
                obj_action = QAction(str(feature_cat.layername), self)
                obj_action.setShortcut(str(feature_cat.shortcut_key))
                menu.addSeparator()
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat.layername))

            action.setMenu(menu)
        
        return action        

    
    def add_action(self, index_action, toolbar, action_group):
        """ Add new action into specified @toolbar. 
            It has to be defined in the configuration file.
            Associate it to corresponding @action_group
        """
        
        text_action = self.tr(index_action+'_text')
        function_name = self.settings.value('actions/'+str(index_action)+'_function')
        if not function_name:
            return None
            
        # Buttons NOT checkable (normally because they open a form)
        if int(index_action) in (19, 23, 25, 26, 27, 29, 33, 34, 38, 41, 45, 46, 47, 48, 49,
                                 50, 58, 86, 64, 65, 66, 67, 68, 74, 75, 81, 82, 83, 84, 98, 99, 196, 206):

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
        elif int(index_action) == 37:
            map_tool = CadApiInfo(self.iface, self.settings, action, index_action)
        elif int(index_action) == 39:
            map_tool = Dimensioning(self.iface, self.settings, action, index_action)                     
        elif int(index_action) == 43:
            map_tool = DrawProfiles(self.iface, self.settings, action, index_action)
        elif int(index_action) == 44:
            map_tool = ReplaceNodeMapTool(self.iface, self.settings, action, index_action)
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
                    
     
    def manage_toolbars(self):
        """ Manage actions of the different plugin toolbars """           
                        
        list_actions = None        
        toolbar_id = "basic"
        if self.controller.get_project_type() == 'ws':
            list_actions = ['37', '41', '48', '86', '32']
        elif self.controller.get_project_type() == 'ud':
            list_actions = ['37', '41', '48', '32']
        self.manage_toolbar(toolbar_id, list_actions)

        toolbar_id = "om_ws"
        list_actions = ['26', '27', '74', '75', '61', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions) 
            
        toolbar_id = "om_ud"
        list_actions = ['43', '56', '57', '74', '75', '61', '64', '65', '84']
        self.manage_toolbar(toolbar_id, list_actions)                           
        
        toolbar_id = "edit"
        list_actions = ['01', '02', '44', '16', '17', '28', '20', '39', '34', '66', '33', '67', '68']               
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
            
        toolbar_id = "utils"
        list_actions = ['206', '19', '99', '83', '58']
        self.manage_toolbar(toolbar_id, list_actions)                                      
            
        # Manage action group of every toolbar
        parent = self.iface.mainWindow()           
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)                                                                            

        # Disable and hide all plugin_toolbars and actions
        self.enable_toolbars(False) 
        
        self.basic.set_controller(self.controller)            
        self.edit.set_controller(self.controller)            
        self.go2epa.set_controller(self.controller)            
        self.master.set_controller(self.controller)
        if self.wsoftware == 'ws':
            self.mincut.set_controller(self.controller)
        self.om.set_controller(self.controller)  
        self.utils.set_controller(self.controller)                   
        self.basic.set_project_type(self.wsoftware)
        self.go2epa.set_project_type(self.wsoftware)
        self.edit.set_project_type(self.wsoftware)
        self.master.set_project_type(self.wsoftware)
        self.om.set_project_type(self.wsoftware)
        self.utils.set_project_type(self.wsoftware)

        # Enable toobar 'basic' and 'info'
        self.enable_toolbar("basic")           

           
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
        
        # Get tables or views specified in 'db' config section         
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')   
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')  
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully') 
        self.table_pgully = self.settings.value('db/table_pgully', 'v_edit_gully_pol')
        self.table_man_connec = self.settings.value('db/table_man_connec', 'v_edit_man_connec')  
        self.table_man_gully = self.settings.value('db/table_man_gully', 'v_edit_man_gully')       
        self.table_man_pgully = self.settings.value('db/table_man_pgully', 'v_edit_man_gully_pol') 

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
        sql = "SELECT * FROM " + self.schema_name + ".sys_feature_cat"
        rows = self.controller.get_rows(sql)
        if not rows:
            return False

        for row in rows:
            tablename = row['tablename']
            elem = SysFeatureCat(row['id'], row['type'], row['orderby'], row['tablename'], row['shortcut_key'])
            self.feature_cat[tablename] = elem

        return True
    

    def manage_layer_names(self):
        """ Get current layer name (the one set in the TOC) 
            of the tables recorded in the table 'sys_feature_cat'
        """
        
        # Manage records from table 'sys_feature_type'
        if not self.manage_feature_cat():
            return
        
        # Check if we have any layer loaded
        layers = self.controller.get_layers()
        if len(layers) == 0:
            return

        # Iterate over all layers. Set the layer_name to the ones related with table 'sys_feature_cat'
        for cur_layer in layers:
            uri_table = self.controller.get_layer_source_table_name(cur_layer)  # @UnusedVariable
            if uri_table:
                if uri_table in list(self.feature_cat.keys()):
                    elem = self.feature_cat[uri_table]
                    elem.layername = cur_layer.name()


    def unload(self, remove_modules=True):
        """ Removes the plugin menu item and icon from QGIS GUI """

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

            if self.search_plus:
                self.search_plus.unload()

            if remove_modules:
                # unload all loaded giswater related modules
                for modName, mod in list(sys.modules.items()):
                    if mod and hasattr(mod, '__file__') and self.plugin_dir in mod.__file__:
                        del sys.modules[modName]

        except AttributeError:
            self.controller.log_info("unload - AttributeError")
        except:
            pass

    
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
        
        plugin_toolbar = self.plugin_toolbars[toolbar_id]       
        plugin_toolbar.toolbar.setVisible(enable)            
        for index_action in plugin_toolbar.list_actions:
            self.enable_action(enable, index_action)                 


    def project_new(self, show_warning=True):
        """ Function executed when a user creates a new QGIS project """

        self.unload(False)
        self.set_info_button(self.connection_status)

                          
    def project_read(self, show_warning=True): 
        """ Function executed when a user opens a QGIS project (*.qgs) """
        
        self.controller = DaoController(self.settings, self.plugin_name, self.iface, create_logger=show_warning)
        self.controller.set_plugin_dir(self.plugin_dir)
        self.controller.set_qgis_settings(self.qgis_settings)
        self.controller.set_giswater(self)
        self.connection_status, not_version = self.controller.set_database_connection()
        self.set_info_button(self.connection_status)
        if not self.connection_status or not_version:
            message = self.controller.last_error
            if show_warning:
                if message:
                    self.controller.show_warning(message, 15)
                self.controller.log_warning(str(self.controller.layer_source))
            self.project_new()
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

        # Check if schema exists
        self.schema_exists = self.controller.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)

        # Get water software from table 'version'
        self.wsoftware = self.controller.get_project_type()

        # Set actions classes (define one class per plugin toolbar)
        self.go2epa = Go2Epa(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic = Basic(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic.set_giswater(self)
        self.om = Om(self.iface, self.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, self.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, self.settings, self.controller, self.plugin_dir)
        if self.wsoftware == 'ws':
            self.mincut = MincutParent(self.iface, self.settings, self.controller, self.plugin_dir)
        self.utils = Utils(self.iface, self.settings, self.controller, self.plugin_dir)

        # Manage layers
        if not self.manage_layers():
            return

        # Manage layer names of the tables present in table 'sys_feature_cat'
        self.manage_layer_names()   
        
        # Manage snapping layers
        self.manage_snapping_layers()    
        
        # Get SRID from table node
        self.srid = self.controller.get_srid(self.table_node, self.schema_name)
        self.controller.plugin_settings_set_value("srid", self.srid)           

        # Get list of actions to hide
        self.list_to_hide = self.settings.value('system_variables/action_to_hide')

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()   
        
        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)
            
        # Disable for Linux 'go2epa' actions
        self.manage_actions_linux()           
        
        # Set objects for map tools classes
        self.manage_map_tools()

        # Set SearchPlus object
        self.set_search_plus()
         
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
        """ Iterate over all layers to get the ones specified in 'db' config section """ 
        
        # Check if we have any layer loaded
        layers = self.controller.get_layers()
            
        if len(layers) == 0:
            return False   
                
        # Initialize variables
        self.layer_arc_man_ud = []
        self.layer_arc_man_ws = []

        self.layer_node_man_ud = []
        self.layer_node_man_ws = []

        self.layer_connec = None
        self.layer_connec_man_ud = []
        self.layer_connec_man_ws = []
        self.layer_gully_man_ud = []     

        self.layer_gully = None
        self.layer_pgully = None
        self.layer_man_gully = None
        self.layer_man_pgully = None
        self.layer_version = None
        self.layer_dimensions = None
        self.layer_man_junction = None

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            
            uri_table = self.controller.get_layer_source_table_name(cur_layer)   #@UnusedVariable
            if uri_table:
 
                if 'v_edit_man_chamber' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_netgully' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_netinit' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_wjump' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_wwtp' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                    self.layer_man_junction = cur_layer                  
                elif 'v_edit_man_outfall' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                elif 'v_edit_man_storage' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)

                # Node group from WS project
                if 'v_edit_man_source' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_pump' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_meter' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_tank' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_hydrant' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_waterwell' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_reduction' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_filter' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_register' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_netwjoin' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_expansiontank' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_flexunion' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                elif 'v_edit_man_wtp' == uri_table:                  
                    self.layer_node_man_ws.append(cur_layer)                    
                elif 'v_edit_man_netsamplepoint' == uri_table:                  
                    self.layer_node_man_ws.append(cur_layer)                    
                elif 'v_edit_man_netelement' == uri_table:                  
                    self.layer_node_man_ws.append(cur_layer)                    

                if self.table_connec == uri_table:
                    self.layer_connec = cur_layer
                
                if self.table_man_connec == uri_table or self.table_connec == uri_table:
                    self.layer_connec_man_ud.append(cur_layer)
                if 'v_edit_man_greentap' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                elif 'v_edit_man_wjoin' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                elif 'v_edit_man_fountain' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                elif 'v_edit_man_tap' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                    
                if 'v_edit_man_conduit' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                elif 'v_edit_man_siphon' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                elif 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                elif 'v_edit_man_waccel' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                elif 'v_edit_man_gully' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)                    
                    
                if 'v_edit_man_pipe' == uri_table:
                    self.layer_arc_man_ws.append(cur_layer)
                elif 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_ws.append(cur_layer)
                    
                if 'v_edit_dimensions' == uri_table:
                    self.layer_dimensions = cur_layer

                if self.table_gully == uri_table:
                    self.layer_gully = cur_layer
                    
                if self.table_pgully == uri_table:
                    self.layer_pgully = cur_layer

                if self.table_man_gully == uri_table:
                    self.layer_man_gully = cur_layer
                    self.layer_gully_man_ud.append(cur_layer)                    
                    
                if self.table_man_pgully == uri_table:
                    self.layer_man_pgully = cur_layer

        # Set arrow cursor
        QApplication.setOverrideCursor(Qt.ArrowCursor)       
        layers = self.controller.get_layers()
        status = self.populate_audit_check_project(layers)
        QApplication.restoreOverrideCursor()      
        if not status:
            return False

        return True


    def manage_snapping_layers(self):
        """ Manage snapping of layers """

        # TODO 3.x
        try:
            layer = self.controller.get_layer_by_tablename('v_edit_man_pipe')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 1, 15.0, False)
            layer = self.controller.get_layer_by_tablename('v_edit_arc')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 1, 15.0, False)
            layer = self.controller.get_layer_by_tablename('v_edit_connec')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 0, 1, 15.0, False)
            layer = self.controller.get_layer_by_tablename('v_edit_node')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 0, 1, 15.0, False)
            layer = self.controller.get_layer_by_tablename('v_edit_gully')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 0, 1, 15.0, False)
            layer = self.controller.get_layer_by_tablename('v_edit_man_conduit')
            if layer:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 1, 15.0, False)
        except:
            pass

                    
    def manage_custom_forms(self):
        """ Set layer custom UI form and init function """
        
        # WS        
        if self.layer_arc_man_ws: 
            for i in range(len(self.layer_arc_man_ws)):
                if self.layer_arc_man_ws[i]:      
                    self.set_layer_custom_form(self.layer_arc_man_ws[i], 'man_arc')
            
        if self.layer_node_man_ws:  
            for i in range(len(self.layer_node_man_ws)):
                if self.layer_node_man_ws[i]:   
                    self.set_layer_custom_form(self.layer_node_man_ws[i], 'man_node')
                                                                           
        if self.layer_connec:       
            self.set_layer_custom_form(self.layer_connec, 'connec')
            
        if self.layer_connec_man_ws:   
            for i in range(len(self.layer_connec_man_ws)):
                if self.layer_connec_man_ws[i]:  
                    self.set_layer_custom_form(self.layer_connec_man_ws[i], 'man_connec')  
              
        # UD      
        if self.layer_arc_man_ud:
            for i in range(len(self.layer_arc_man_ud)):
                if self.layer_arc_man_ud[i]:    
                    self.set_layer_custom_form(self.layer_arc_man_ud[i], 'man_arc')
            
        if self.layer_node_man_ud: 
            for i in range(len(self.layer_node_man_ud)):
                if self.layer_node_man_ud[i]:       
                    self.set_layer_custom_form(self.layer_node_man_ud[i], 'man_node')                                               
            
        if self.layer_connec_man_ud:
            for i in range(len(self.layer_connec_man_ud)):
                if self.layer_connec_man_ud[i]:      
                    self.set_layer_custom_form(self.layer_connec_man_ud[i], 'man_connec')
            
        if self.layer_gully:       
            self.set_layer_custom_form(self.layer_gully, 'gully') 
        if self.layer_man_gully:       
            self.set_layer_custom_form(self.layer_man_gully, 'man_gully')   

        # Set custom for layer dimensions 
        self.set_layer_custom_form_dimensions(self.layer_dimensions)                     
                
                                    
    def set_layer_custom_form(self, layer, geom_type):
        """ Set custom UI form and init python code of selected layer """
        
        if self.basic.project_type is None:
            return
        
        layer_tablename = self.controller.get_layer_source_table_name(layer)
        if layer_tablename == 'v_edit_arc' or layer_tablename == 'v_edit_node' \
            or layer_tablename == 'v_edit_connec' or layer_tablename == 'v_edit_gully' or layer_tablename == 'v_edit_gully_pol':
            return
        
        layer_tablename = layer_tablename.replace("v_edit_", "")
        name_ui = self.basic.project_type + '_' + layer_tablename + '.ui'
        name_init = self.basic.project_type + '_' + geom_type + '_init.py'
        name_function = 'formOpen'
        path_ui = os.path.join(self.plugin_dir, 'init_ui', name_ui)
        # If specific UI form not found, it will load the generic one
        if not os.path.exists(path_ui):
            name_ui = self.basic.project_type + '_' + geom_type + '.ui'            
            path_ui = os.path.join(self.plugin_dir, 'ui', name_ui)
            
        path_init = os.path.join(self.plugin_dir, 'init', name_init)
        layer.editFormConfig().setUiForm(path_ui) 
        layer.editFormConfig().setInitCodeSource(1)
        layer.editFormConfig().setInitFilePath(path_init)           
        layer.editFormConfig().setInitFunction(name_function) 
        
        
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

        if Qgis.QGIS_VERSION_INT < 29900:
            layer_node = self.controller.get_layer_by_tablename("v_edit_node")
            if layer_node:
                display_field = 'depth : [% "' + fieldname_node + '" %]'
                layer_node.setDisplayField(display_field)

            layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")
            if layer_connec:
                display_field = 'depth : [% "' + fieldname_connec + '" %]'
                layer_connec.setDisplayField(display_field)
        # TODO 3.x
        else:
            pass

    
    def manage_map_tools(self):
        """ Manage map tools """
        self.set_map_tool('map_tool_api_info_data')
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
            if self.basic.project_type == 'ws':
                map_tool.set_layers(self.layer_arc_man_ws, self.layer_connec_man_ws, self.layer_node_man_ws)
                map_tool.set_controller(self.controller)
            else:
                map_tool.set_layers(self.layer_arc_man_ud, self.layer_connec_man_ud, self.layer_node_man_ud, self.layer_gully_man_ud)
                map_tool.set_controller(self.controller)

       
    def set_search_plus(self):
        """ Set SearchPlus object """

        try:         
            self.search_plus = SearchPlus(self.iface, self.srid, self.controller, self.settings, self.plugin_dir)
            self.basic.search_plus = self.search_plus
            status = self.search_plus.init_config()
            self.actions['32'].setVisible(status) 
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False)
            self.search_plus.feature_cat = self.feature_cat
        except Exception as e:
            self.controller.show_warning("Error setting searchplus button: " + str(e))     
               
        
    def manage_actions_linux(self):
        """ Disable for Linux 'go2epa' actions """
        
        # Linux: Disable actions related with go2epa and giswater.jar
        if 'nt' not in sys.builtin_module_names:
            self.enable_action(False, 23)
            self.enable_action(False, 25)                          
                        
            
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
            # TODO: 3.x
            else:
                expl_id = None
        except:
            pass
        
        if expl_id is None:
            return
                    
        # Update table 'selector_expl' of current user (delete and insert)
        sql = ("DELETE FROM " + self.schema_name + ".selector_expl WHERE current_user = cur_user;"
               "\nINSERT INTO " + self.schema_name + ".selector_expl (expl_id, cur_user)"
               " VALUES(" + expl_id + ", current_user);")
        self.controller.execute_sql(sql)        
        
        
    def populate_audit_check_project(self, layers):
        """ Fill table 'audit_check_project' with layers data """

        self.dlg_audit_project = AuditCheckProjectResult()
        self.dlg_audit_project.tbl_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.dlg_audit_project.btn_close.clicked.connect(self.dlg_audit_project.close)

        sql = ("DELETE FROM " + self.schema_name + ".audit_check_project"
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
                sql += ("\nINSERT INTO " + self.schema_name + ".audit_check_project"
                        " (table_schema, table_id, table_dbname, table_host, fprocesscat_id)"
                        " VALUES ('" + str(schema_name) + "', '" + str(table_name) + "', '" + str(db_name) + "', '" + str(host_name) + "', 1);")
                
        status = self.controller.execute_sql(sql)
        if not status:
            return False
                
        sql = ("SELECT " + self.schema_name + ".gw_fct_audit_check_project(1);")
        row = self.controller.get_row(sql, commit=True)
        if not row:
            return False

        if row[0] == -1:
            message = "This is not a valid Giswater project. Do you want to view problem details?"
            answer = self.controller.ask_question(message, "Warning!")
            if answer:
                sql = ("SELECT * FROM " + self.schema_name + ".audit_check_project"
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
                    sql = ("SELECT * FROM " + self.schema_name + ".audit_check_project"
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


