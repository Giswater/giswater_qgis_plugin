'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.core import QgsMapLayerRegistry, QgsProject, QgsExpressionContextUtils
from PyQt4 import uic
from PyQt4.QtCore import QObject, QSettings, Qt
from PyQt4.QtGui import QAction, QActionGroup, QIcon, QMenu

import os.path
import sys  
from functools import partial

from actions.go2epa import Go2Epa
from actions.basic import Basic
from actions.edit import Edit
from actions.master import Master
from actions.mincut import MincutParent
from dao.controller import DaoController
from map_tools.move_node import MoveNodeMapTool
from map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from map_tools.delete_node import DeleteNodeMapTool
from map_tools.connec import ConnecMapTool
from map_tools.draw_profiles import DrawProfiles
from map_tools.replace_node import ReplaceNodeMapTool
from models.plugin_toolbar import PluginToolbar
from search.search_plus import SearchPlus

from models.sys_feature_cat import SysFeatureCat


class Giswater(QObject):  
    
    def __init__(self, iface):
        ''' Constructor 
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        '''
        super(Giswater, self).__init__()

        # Initialize instance attributes
        self.iface = iface
        self.dao = None
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
        QgsExpressionContextUtils.setProjectVariable('svg_path', svg_plugin_dir)   
            
        # Check if config file exists    
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        if not os.path.exists(setting_file):
            message = "Config file not found at: "+setting_file
            self.iface.messageBar().pushMessage("", message, 1, 20) 
            return  
          
        # Set plugin settings
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())  
        
        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix) 
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding()) 
        
        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        self.controller.plugin_dir = self.plugin_dir        
        self.controller.set_qgis_settings(self.qgis_settings)
        connection_status = self.controller.set_database_connection()
        if not connection_status:
            msg = self.controller.last_error  
            self.controller.show_warning(msg, 30) 
            return 
        
        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)       
                
        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)
                
        # Get schema and check if exists
        self.dao = self.controller.dao 
        self.schema_name = self.controller.get_schema_name()
        self.schema_exists = self.dao.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)
        
        # Set actions classes (define one class per plugin toolbar)
        self.go2epa = Go2Epa(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic = Basic(self.iface, self.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, self.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, self.settings, self.controller, self.plugin_dir)
        self.mincut = MincutParent(self.iface, self.settings, self.controller, self.plugin_dir)    

        # Define signals
        self.set_signals()
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable
       
               
    def set_signals(self): 
        ''' Define widget and event signals '''
        self.iface.projectRead.connect(self.project_read)                

  
    def tr(self, message):
        if self.controller:
            return self.controller.tr(message)      
        
    
    def manage_action(self, index_action, function_name):  
        
        if function_name is None:
            return 
        
        try:
            action = self.actions[index_action]                

            # Basic toolbar actions
            if int(index_action) in (41, 48, 32):
                callback_function = getattr(self.basic, function_name)  
                action.triggered.connect(callback_function)
            # Mincut toolbar actions
            elif int(index_action) in (26, 27):
                callback_function = getattr(self.mincut, function_name)
                action.triggered.connect(callback_function)            
            # Edit toolbar actions
            elif int(index_action) in (01, 02, 19, 28, 33, 34, 39, 98):
                callback_function = getattr(self.edit, function_name)
                action.triggered.connect(callback_function)
            # Go2epa toolbar actions
            elif int(index_action) in (23, 24, 25, 36):
                callback_function = getattr(self.go2epa, function_name)
                action.triggered.connect(callback_function)
            # Master toolbar actions
            elif int(index_action) in (45, 46, 47, 38, 49, 99):
                callback_function = getattr(self.master, function_name)
                action.triggered.connect(callback_function)
            # Generic function
            else:        
                callback_function = getattr(self, 'action_triggered')  
                action.triggered.connect(partial(callback_function, function_name))
                
        except AttributeError:
            action.setEnabled(False)                

     
    def create_action(self, index_action=None, text='', toolbar=None, menu=None, is_checkable=True, function_name=None, parent=None):
        
        if parent is None:
            parent = self.iface.mainWindow()

        icon = None
        if index_action is not None:
            icon_path = self.icon_folder+index_action+'.png'
            if os.path.exists(icon_path):        
                icon = QIcon(icon_path)
                
        if icon is None:
            action = QAction(text, parent) 
            
        else:
            action = QAction(icon, text, parent)  
            
        # Button add_node or add_arc: add drop down menu to button in toolbar
        if self.schema_exists and (index_action == '01' or index_action == '02'):
            action = self.manage_dropdown_menu(action, index_action)

        if toolbar is not None:
            toolbar.addAction(action)  
            
        if index_action is not None:         
            self.actions[index_action] = action
        else:
            self.actions[text] = action
                                     
        action.setCheckable(is_checkable)                         
        self.manage_action(index_action, function_name)
            
        return action
      
      
    def manage_dropdown_menu(self, action, index_action):
        """ Create dropdown menu for insert management of nodes and arcs """        
               
        # Get list of different node and arc types
        menu = QMenu()

        # List of nodes from node_type_cat_type - nodes which we are using
        for feature_cat in self.feature_cat.itervalues():
            if (index_action == '01' and feature_cat.type == 'NODE') or (index_action == '02' and feature_cat.type == 'ARC'):
                obj_action = QAction(str(feature_cat.layername), self)
                obj_action.setShortcut(str(feature_cat.shortcut_key))
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.edit.menu_activate, str(feature_cat.layername)))

            action.setMenu(menu)
        
        return action
                         

    def menu_activate(self, node_type):
        
        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName(node_type)
        if layer:
            layer = layer[0]
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
        else:
            self.controller.show_warning("Selected layer name not found: "+str(node_type))

    
    def add_action(self, index_action, toolbar, parent):
        ''' Add new action into specified toolbar 
        This action has to be defined in the configuration file ''' 
        
        action = None
        text_action = self.tr(index_action+'_text')
        function_name = self.settings.value('actions/'+str(index_action)+'_function')
        
        if function_name:
            
            map_tool = None
            if int(index_action) in (19, 23, 24, 25, 26, 27, 28, 36, 41, 45, 46, 47, 48, 49, 98, 99):
                action = self.create_action(index_action, text_action, toolbar, None, False, function_name, parent)
            else:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                   
            # Manage Map Tools         
            if int(index_action) == 16:
                map_tool = MoveNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 17:
                map_tool = DeleteNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 20:
                map_tool = ConnecMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 43:
                map_tool = DrawProfiles(self.iface, self.settings, action, index_action)
            elif int(index_action) == 44:
                map_tool = ReplaceNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 56:
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 57:
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)

            # If this action has an associated map tool, add this to dictionary of available map_tools
            if map_tool:
                self.map_tools[function_name] = map_tool
        
        return action         

     
    def manage_toolbars(self):
        ''' Manage actions of the different plugin toolbars '''
        
        parent = self.iface.mainWindow()    
        
        # TODO: It should be managed trough database roles
        toolbar_basic_enabled = bool(int(self.settings.value('status/toolbar_basic_enabled', 1)))
        toolbar_om_ws_enabled = bool(int(self.settings.value('status/toolbar_om_ws_enabled', 1)))
        toolbar_om_ud_enabled = bool(int(self.settings.value('status/toolbar_om_ud_enabled', 1)))
        toolbar_edit_enabled = bool(int(self.settings.value('status/toolbar_edit_enabled', 1)))
        toolbar_epa_enabled = bool(int(self.settings.value('status/toolbar_epa_enabled', 1)))
        toolbar_master_enabled = bool(int(self.settings.value('status/toolbar_master_enabled', 1)))  
        
        if toolbar_basic_enabled:
            toolbar_id = "basic"
            list_actions = ['41', '48', '32']
            self.manage_toolbar(toolbar_id, list_actions)

        if toolbar_om_ws_enabled:
            toolbar_id = "om_ws"
            list_actions = ['26', '27']                
            self.manage_toolbar(toolbar_id, list_actions) 
            
        if toolbar_om_ud_enabled:
            toolbar_id = "om_ud"
            list_actions = ['43', '56', '57']                
            self.manage_toolbar(toolbar_id, list_actions)                           
            
        if toolbar_edit_enabled:
            toolbar_id = "edit"
            list_actions = ['01', '02', '44', '16', '17', '28', '19', '20', '33', '34', '39', '98']               
            self.manage_toolbar(toolbar_id, list_actions)   
            
        if toolbar_epa_enabled:
            toolbar_id = "epa"
            list_actions = ['23', '24', '25', '36']               
            self.manage_toolbar(toolbar_id, list_actions)    
            
        if toolbar_master_enabled:
            toolbar_id = "master"
            list_actions = ['45', '46', '47', '38', '49', '99']               
            self.manage_toolbar(toolbar_id, list_actions)                             

        # Manage action group of every toolbar
        for plugin_toolbar in self.plugin_toolbars.itervalues():
            ag = QActionGroup(parent)
            for elem in plugin_toolbar.list_actions:
                self.add_action(elem, plugin_toolbar.toolbar, ag)                                       

        # Disable and hide all plugin_toolbars
        self.enable_actions(False)
        self.show_toolbars(False) 
           
           
    def manage_toolbar(self, toolbar_id, list_actions): 
        ''' Manage action of selected plugin toolbar '''
                
        toolbar_name = self.tr('toolbar_' + toolbar_id + '_name')        
        plugin_toolbar = PluginToolbar(toolbar_id, toolbar_name, True)
        plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)
        plugin_toolbar.toolbar.setObjectName(toolbar_name)  
        plugin_toolbar.list_actions = list_actions           
        self.plugin_toolbars[toolbar_id] = plugin_toolbar 
                        
           
    def initGui(self):
        ''' Create the menu entries and toolbar icons inside the QGIS GUI ''' 
        
        if self.dao is None:
            return
        
        # Create plugin main menu
        self.menu_name = self.tr('menu_name')    
        
        # Get tables or views specified in 'db' config section         
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')   
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')  
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully') 
        self.table_pgully = self.settings.value('db/table_pgully', 'v_edit_pgully')   
        self.table_version = self.settings.value('db/table_version', 'version') 

        self.table_man_connec = self.settings.value('db/table_man_connec', 'v_edit_man_connec')  
        self.table_man_gully = self.settings.value('db/table_man_gully', 'v_edit_man_gully')       
        self.table_man_pgully = self.settings.value('db/table_man_pgully', 'v_edit_man_pgully') 
 
        # Tables connec
        self.table_wjoin = self.settings.value('db/table_wjoin', 'v_edit_man_wjoin')
        self.table_page = self.settings.value('db/table_page', 'v_edit_man_page')
        self.table_greentap = self.settings.value('db/table_greentap', 'v_edit_man_greentap')
        self.table_fountain = self.settings.value('db/table_fountain', 'v_edit_man_fountain')
        
        # Tables node
        self.table_tank = self.settings.value('db/table_tank', 'v_edit_man_tank')
        self.table_pump = self.settings.value('db/table_pump', 'v_edit_man_pump')
        self.table_source = self.settings.value('db/table_source', 'v_edit_man_source')
        self.table_meter = self.settings.value('db/table_meter', 'v_edit_man_meter')
        self.table_junction = self.settings.value('db/table_junction', 'v_edit_man_junction')
        self.table_waterwell = self.settings.value('db/table_waterwell', 'v_edit_man_waterwell')
        self.table_reduction = self.settings.value('db/table_reduction', 'v_edit_man_reduction')
        self.table_hydrant = self.settings.value('db/table_hydrant', 'v_edit_man_hydrant')
        self.table_valve = self.settings.value('db/table_valve', 'v_edit_man_valve')
        self.table_manhole = self.settings.value('db/table_manhole', 'v_edit_man_manhole')
        
        self.table_chamber = self.settings.value('db/table_chamber', 'v_edit_man_chamber')
        self.table_chamber_pol = self.settings.value('db/table_chamber_pol', 'v_edit_man_chamber_pol')
        self.table_netgully = self.settings.value('db/table_netgully', 'v_edit_man_netgully')
        self.table_netgully_pol = self.settings.value('db/table_netgully_pol', 'v_edit_man_netgully_pol')
        self.table_netinit = self.settings.value('db/table_netinit', 'v_edit_man_netinit')
        self.table_wjump = self.settings.value('db/table_wjump', 'v_edit_man_wjump')
        self.table_wwtp = self.settings.value('db/table_wwtp', 'v_edit_man_wwtp')
        self.table_wwtp_pol = self.settings.value('db/table_wwtp_pol', 'v_edit_man_wwtp_pol')
        self.table_storage = self.settings.value('db/table_storage', 'v_edit_man_storage')
        self.table_storage_pol = self.settings.value('db/table_storage_pol', 'v_edit_man_storage_pol')
        self.table_outfall = self.settings.value('db/table_outfall', 'v_edit_man_outfall')
        
        self.table_register = self.settings.value('db/table_register', 'v_edit_man_register')
        self.table_netwjoin = self.settings.value('db/table_netwjoin', 'v_edit_man_netwjoin')
        self.table_expansiontank = self.settings.value('db/table_expansiontank', 'v_edit_man_expansiontank')
        self.table_flexunion = self.settings.value('db/table_flexunion', 'v_edit_man_flexunion')
        self.table_filter =  self.settings.value('db/table_filter', 'v_edit_man_filter')
      
        # Tables arc
        self.table_varc = self.settings.value('db/table_varc', 'v_edit_man_varc')
        self.table_siphon = self.settings.value('db/table_siphon', 'v_edit_man_siphon')
        self.table_conduit = self.settings.value('db/table_conduit', 'v_edit_man_conduit')
        self.table_waccel = self.settings.value('db/table_waccel', 'v_edit_man_waccel')
        self.table_tap = self.settings.value('db/table_tap', 'v_edit_man_tap')
        self.table_pipe = self.settings.value('db/table_pipe', 'v_edit_man_pipe')

        self.feature_cat = {}

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()
                         
        # Load automatically custom forms for layers 'arc', 'node', and 'connec'? 
        self.load_custom_forms = bool(int(self.settings.value('status/load_custom_forms', 1)))   
                                 
        # Delete python compiled files
        self.delete_pyc_files()  
                                         
        # Project initialization
        self.project_read()


    def manage_feature_cat(self):
        """ Manage records from table 'sys_feature_type' """
        
        # Dictionary to keep every record of table 'sys_feature_cat'
        # Key: field tablename
        # Value: Object of the class SysFeatureCat
        self.feature_cat = {}             
        sql = "SELECT * FROM " + self.schema_name + ".sys_feature_cat"
        rows = self.dao.get_rows(sql)
        if not rows:
            return False

        for row in rows:
            tablename = row['tablename']
            elem = SysFeatureCat(row['id'], row['type'], row['orderby'], row['tablename'], row['shortcut_key'])
            self.feature_cat[tablename] = elem

        return True
    

    def project_read_features(self):
        
        # Manage records from table 'sys_feature_type'
        if not self.manage_feature_cat():
            return
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return

        # Iterate over all layers. Set the layer_name to the ones related with table 'sys_feature_cat'
        for cur_layer in layers:
            uri_table = self.controller.get_layer_source_table_name(cur_layer)  # @UnusedVariable
            if uri_table is not None:
                if uri_table in self.feature_cat.keys():
                    elem = self.feature_cat[uri_table]
                    elem.layername = cur_layer.name()


    def unload(self):
        ''' Removes the plugin menu item and icon from QGIS GUI '''
        
        try:
            for action in self.actions.itervalues():
                self.iface.removePluginMenu(self.menu_name, action)
                self.iface.removeToolBarIcon(action)
                
            for plugin_toolbar in self.plugin_toolbars.itervalues():
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(False)                
                    del plugin_toolbar.toolbar

            if self.search_plus is not None:
                self.search_plus.unload()
        except AttributeError:
            self.controller.log_info("unload - AttributeError")
            pass
        except KeyError:
            pass
    
    
    ''' Slots '''             

    def enable_actions(self, enable=True, start=1, stop=100):
        ''' Utility to enable/disable all actions '''
        for i in range(start, stop+1):
            self.enable_action(enable, i)              


    def enable_action(self, enable=True, index=1):
        ''' Enable/disable selected action '''
        key = str(index).zfill(2)
        if key in self.actions:
            action = self.actions[key]
            action.setEnabled(enable)                   


    def show_toolbars(self, visible=True):
        ''' Show/Hide all plugin toolbars from QGIS GUI '''
        
        try:
            for plugin_toolbar in self.plugin_toolbars.itervalues():
                if plugin_toolbar.enabled:                
                    plugin_toolbar.toolbar.setVisible(visible)
        except AttributeError:
            pass
        except KeyError:
            pass                      
                                  
        
    def search_project_type(self):
        ''' Search in table 'version' project type of current QGIS project '''
        
        try:
            self.show_toolbars(True)
            self.go2epa.set_project_type(None)
            self.basic.set_project_type(None)
            self.edit.set_project_type(None)
            self.master.set_project_type(None)
            features = self.layer_version.getFeatures()
            for feature in features:
                wsoftware = feature['wsoftware']
                self.basic.set_project_type(wsoftware.lower())
                self.go2epa.set_project_type(wsoftware.lower())
                self.edit.set_project_type(wsoftware.lower())
                self.master.set_project_type(wsoftware.lower())
                if wsoftware.lower() == 'ws':
                    self.plugin_toolbars['om_ws'].toolbar.setVisible(True)          
                    self.plugin_toolbars['om_ud'].toolbar.setVisible(False)                   
                elif wsoftware.lower() == 'ud':
                    self.plugin_toolbars['om_ud'].toolbar.setVisible(True)                   
                    self.plugin_toolbars['om_ws'].toolbar.setVisible(False)          
            
        except Exception as e:
            self.controller.log_info("search_project_type - Exception: "+str(e))
            pass                  

                          
    def project_read(self): 
        ''' Function executed when a user opens a QGIS project (*.qgs) '''
        
        if self.dao is None:
            return

        # Manage layers
        if not self.manage_layers():
            return
              
        self.project_read_features()
               
        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()
                      
        # Hide all plugin_toolbars
        self.show_toolbars(False)        

        # Get schema name from table 'version'
        # Check if really exists
        layer_source = self.controller.get_layer_source(self.layer_version)  
        self.schema_name = layer_source['schema']
        if self.schema_name is None or not self.dao.check_schema(self.schema_name):
            self.controller.show_warning("Schema not found", parameter=self.schema_name)            
            return

        # Set schema_name in controller and in config file
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)   
        self.controller.set_schema_name(self.schema_name)   
        
        # Get PostgreSQL version
        self.controller.get_postgresql_version()        
        
        # Get SRID from table node
        self.srid = self.dao.get_srid(self.schema_name, self.table_node)
        self.controller.plugin_settings_set_value("srid", self.srid)           

        # Search project type in table 'version'
        self.search_project_type()              
        
        self.controller.set_actions(self.actions)

        # Set layer custom UI form and init function   
        if self.load_custom_forms:
            self.manage_custom_forms()
            
        self.custom_enable_actions()           
        
        # Set objects for map tools classes
        self.manage_map_tools()

        # Set SearchPlus object
        self.set_search_plus()
         
         
    def manage_layers(self):
        """ Iterate over all layers to get the ones specified in 'db' config section """ 
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
            
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
            if uri_table is not None:
 
                if 'v_edit_man_chamber' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_netgully' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_netinit' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_wjump' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_wwtp' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                    self.layer_man_junction = cur_layer                  
                if 'v_edit_man_outfall' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)
                if 'v_edit_man_storage' == uri_table:
                    self.layer_node_man_ud.append(cur_layer)

                # Node group from WS project
                if 'v_edit_man_source' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_pump' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_meter' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_tank' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_hydrant' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_waterwell' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_reduction' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_filter' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_register' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_netwjoin' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_expansiontank' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)
                if 'v_edit_man_flexunion' == uri_table:
                    self.layer_node_man_ws.append(cur_layer)

                if self.table_connec == uri_table:
                    self.layer_connec = cur_layer
                
                if self.table_man_connec == uri_table or self.table_connec == uri_table:
                    self.layer_connec_man_ud.append(cur_layer)
                if 'v_edit_man_greentap' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                if 'v_edit_man_wjoin' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                if 'v_edit_man_fountain' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                if 'v_edit_man_tap' == uri_table:
                    self.layer_connec_man_ws.append(cur_layer)
                    
                if 'v_edit_man_conduit' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                if 'v_edit_man_siphon' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                if 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                if 'v_edit_man_waccel' == uri_table:
                    self.layer_arc_man_ud.append(cur_layer)
                    
                if 'v_edit_man_pipe' == uri_table:
                    self.layer_arc_man_ws.append(cur_layer)
                if 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_ws.append(cur_layer)
                    
                if 'v_edit_dimensions' == uri_table:
                    self.layer_dimensions = cur_layer

                if self.table_gully == uri_table:
                    self.layer_gully = cur_layer
                    
                if self.table_pgully == uri_table:
                    self.layer_pgully = cur_layer

                if self.table_man_gully == uri_table:
                    self.layer_man_gully = cur_layer
                    
                if self.table_man_pgully == uri_table:
                    self.layer_man_pgully = cur_layer
                
                if self.table_version == uri_table:
                    self.layer_version = cur_layer
                 
        # Check if table 'version' and man_junction exists
        if self.layer_version is None or self.layer_man_junction is None:
            message = "To use this project with Giswater, layers man_junction and version must exist. Please check your project!"
            self.controller.show_warning(message)
            return False
        
        return True
                                           
                      
    def manage_custom_forms(self):
        ''' Set layer custom UI form and init function '''
        
        if self.layer_arc_man_ud is not None:
            for i in range(len(self.layer_arc_man_ud)):
                if self.layer_arc_man_ud[i] is not None:    
                    self.set_layer_custom_form(self.layer_arc_man_ud[i], 'man_arc')
                    
        if self.layer_arc_man_ws is not None: 
            for i in range(len(self.layer_arc_man_ws)):
                if self.layer_arc_man_ws[i] is not None:      
                    self.set_layer_custom_form(self.layer_arc_man_ws[i], 'man_arc')
            
        if self.layer_node_man_ud is not None: 
            for i in range(len(self.layer_node_man_ud)):
                if self.layer_node_man_ud[i] is not None:       
                    self.set_layer_custom_form(self.layer_node_man_ud[i], 'man_node')
        
        if self.layer_node_man_ws is not None:  
            for i in range(len(self.layer_node_man_ws)):
                if self.layer_node_man_ws[i] is not None:   
                    self.set_layer_custom_form(self.layer_node_man_ws[i], 'man_node')
                                                                           
        if self.layer_connec is not None:       
            self.set_layer_custom_form(self.layer_connec, 'connec')
            
        if self.layer_connec_man_ud is not None:
            for i in range(len(self.layer_connec_man_ud)):
                if self.layer_connec_man_ud[i] is not None:      
                    self.set_layer_custom_form(self.layer_connec_man_ud[i], 'man_connec')
            
        if self.layer_connec_man_ws is not None:   
            for i in range(len(self.layer_connec_man_ws)):
                if self.layer_connec_man_ws[i] is not None:  
                    self.set_layer_custom_form(self.layer_connec_man_ws[i], 'man_connec')     
             
        if self.layer_gully is not None:       
            self.set_layer_custom_form(self.layer_gully, 'gully') 
        if self.layer_man_gully is not None:       
            self.set_layer_custom_form(self.layer_man_gully, 'man_gully')   
         
        if self.layer_pgully is not None:       
            self.set_layer_custom_form(self.layer_pgully, 'gully')
        if self.layer_man_pgully is not None:       
            self.set_layer_custom_form(self.layer_man_pgully, 'man_gully')   
        
        # Set cstom for layer dimensions 
        self.set_layer_custom_form_dimensions(self.layer_dimensions)                     
                
                                    
    def set_layer_custom_form(self, layer, name):
        ''' Set custom UI form and init python code of selected layer '''
        
        name_ui = self.basic.project_type+'_'+name+'.ui'
        name_init = self.basic.project_type+'_'+name+'_init.py'
        name_function = 'formOpen'
        file_ui = os.path.join(self.plugin_dir, 'ui', name_ui)
        file_init = os.path.join(self.plugin_dir, 'init', name_init)
        layer.editFormConfig().setUiForm(file_ui) 
        layer.editFormConfig().setInitCodeSource(1)
        layer.editFormConfig().setInitFilePath(file_init)           
        layer.editFormConfig().setInitFunction(name_function) 
        
        
    def set_layer_custom_form_dimensions(self, layer):
 
        if layer is None:
            return
        
        name_ui = 'dimensions.ui'
        name_init = 'dimensions.py'
        name_function = 'formOpen'
        file_ui = os.path.join(self.plugin_dir, 'ui', name_ui)
        file_init = os.path.join(self.plugin_dir,'init', name_init)                     
        layer.editFormConfig().setUiForm(file_ui) 
        layer.editFormConfig().setInitCodeSource(1)
        layer.editFormConfig().setInitFilePath(file_init)           
        layer.editFormConfig().setInitFunction(name_function)
        
        layer_node = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_node")
        if layer_node:
            layer_node = layer_node[0]
            layer_node.setDisplayField('depth : [% "depth" %]')
        
        layer_connec = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_connec")
        if layer_connec:
            layer_connec = layer_connec[0]
            layer_connec.setDisplayField('depth : [% "depth" %]')

    
    def manage_map_tools(self):
        ''' Manage map tools '''
        
        self.set_map_tool('map_tool_move_node')
        self.set_map_tool('map_tool_delete_node')
        self.set_map_tool('map_tool_flow_trace')
        self.set_map_tool('map_tool_flow_exit')
        self.set_map_tool('map_tool_connec_tool')
        self.set_map_tool('map_tool_draw_profiles')
        self.set_map_tool('map_tool_replace_node')
                
        
    def set_map_tool(self, map_tool_name):
        ''' Set objects for map tools classes '''  

        if map_tool_name in self.map_tools:
            map_tool = self.map_tools[map_tool_name]
            if self.basic.project_type == 'ws':
                map_tool.set_layers(self.layer_arc_man_ws, self.layer_connec_man_ws, self.layer_node_man_ws)
                map_tool.set_controller(self.controller)
            else:
                map_tool.set_layers(self.layer_arc_man_ud, self.layer_connec_man_ud, self.layer_node_man_ud)
                map_tool.set_controller(self.controller)

       
    def set_search_plus(self):
        """ Set SearchPlus object """

        try:         
            if self.search_plus is None:        
                self.search_plus = SearchPlus(self.iface, self.srid, self.controller)
            self.basic.search_plus = self.search_plus
            status = self.search_plus.populate_dialog()
            self.actions['32'].setVisible(status) 
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False) 
        except KeyError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)                      
        except RuntimeError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)         
               
        
    def custom_enable_actions(self):
        ''' Enable selected actions '''
        
        # Enable all actions
        self.enable_actions(True, 1, 100)
        
        # Linux: Disable actions related with go2epa and giswater.jar
        if 'nt' not in sys.builtin_module_names:
            self.enable_action(False, 23)
            self.enable_action(False, 24) 
            self.enable_action(False, 36)                          
                        
            
    def action_triggered(self, function_name):   
        ''' Action with corresponding funcion name has been triggered '''
        
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
        ''' Delete python compiled files '''
        
        filelist = [ f for f in os.listdir(".") if f.endswith(".pyc") ]
        for f in filelist:
            os.remove(f)

