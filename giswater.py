'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from PyQt4.QtCore import QCoreApplication, QObject, QSettings, QTranslator
from PyQt4.QtGui import QAction, QActionGroup, QIcon   

import os.path
import sys  
from functools import partial

from actions.ed import Ed
from actions.mg import Mg
from controller import DaoController
from map_tools.line import LineMapTool
from map_tools.point import PointMapTool
from map_tools.move_node import MoveNodeMapTool
from map_tools.mincut import MincutMapTool
from map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from map_tools.delete_node import DeleteNodeMapTool
from map_tools.connec import ConnecMapTool
from map_tools.extract_raster_value import ExtractRasterValue
from search.search_plus import SearchPlus


class Giswater(QObject):
   
    def __init__(self, iface):
        ''' Constructor 
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        '''
        super(Giswater, self).__init__()
        
        # Save reference to the QGIS interface
        self.iface = iface
        self.legend = iface.legendInterface()    
            
        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)    
        self.plugin_name = os.path.basename(self.plugin_dir)   

        # initialize locale
        locale = QSettings().value('locale/userLocale')
        locale_path = os.path.join(self.plugin_dir, 'i18n', self.plugin_name+'_{}.qm'.format(locale))
        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)
         
        # Load local settings of the plugin
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())    
        
        # Declare instance attributes
        self.icon_folder = self.plugin_dir+'/icons/'        
        self.actions = {}
        self.map_tools = {}
        self.search_plus = None
        self.srid = None
        
        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        
        # Check if config file exists    
        if not os.path.exists(setting_file):
            msg = "Config file not found at: "+setting_file
            self.controller.show_message(msg, 1, 100) 
            return    
        
        # Check connection status   
        connection_status = self.controller.set_database_connection()
        self.dao = self.controller.dao        
        if not connection_status:
            msg = self.controller.last_error  
            self.controller.show_message(msg, 1, 100) 
            return 
        
        # Set actions classes
        self.ed = Ed(self.iface, self.settings, self.controller, self.plugin_dir)
        self.mg = Mg(self.iface, self.settings, self.controller, self.plugin_dir)
        
        # Define signals
        self.set_signals()
  
        
               
    def set_signals(self): 
        ''' Define widget and event signals '''
        self.iface.projectRead.connect(self.project_read)                
        self.legend.currentLayerChanged.connect(self.current_layer_changed)       
        
                   
    def tr(self, message):
        if self.controller:
            return self.controller.tr(message)      
        
        
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
                                    
        if toolbar is not None:
            toolbar.addAction(action)  
             
        if menu is not None:
            self.iface.addPluginToMenu(menu, action)
            
        if index_action is not None:         
            self.actions[index_action] = action
        else:
            self.actions[text] = action
                                     
        if function_name is not None:
            try:
                action.setCheckable(is_checkable) 
                # Management toolbar actions
                if int(index_action) in (19, 21, 24, 25, 27, 28, 99):
                    callback_function = getattr(self.mg, function_name)  
                    action.triggered.connect(callback_function)
                # Edit toolbar actions
                elif int(index_action) in (32, 33, 34, 36):    
                    callback_function = getattr(self.ed, function_name)  
                    action.triggered.connect(callback_function)                    
                # Generic function
                else:        
                    water_soft = function_name[:2] 
                    callback_function = getattr(self, water_soft+'_generic')  
                    action.triggered.connect(partial(callback_function, function_name))
            except AttributeError:
                #print index_action+". Callback function not found: "+function_name
                action.setEnabled(False)                
        else:
            action.setEnabled(False)
            
        return action
          
        
    def add_action(self, index_action, toolbar, parent):
        ''' Add new action into specified toolbar 
        This action has to be defined in the configuration file ''' 
        
        action = None
        text_action = self.tr(index_action+'_text')
        function_name = self.settings.value('actions/'+str(index_action)+'_function')
        if function_name:
            map_tool = None
            if int(index_action) in (3, 5, 13):
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = LineMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) in (1, 2, 4, 10, 11, 12, 14, 15, 8, 29):
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = PointMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)   
            elif int(index_action) == 16:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = MoveNodeMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)
            elif int(index_action) == 17:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = DeleteNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 18:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = ExtractRasterValue(self.iface, self.settings, action, index_action)
            elif int(index_action) == 26:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = MincutMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 20:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = ConnecMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 56:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 57:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) in (27, 99):
                # 27 should be not checkeable
                action = self.create_action(index_action, text_action, toolbar, None, False, function_name, parent)
            else:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)

            if map_tool:
                self.map_tools[function_name] = map_tool
        
        return action         
        
        
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
        self.table_version = self.settings.value('db/table_version', 'version') 
        
        self.table_man_arc = self.settings.value('db/table_arc', 'v_edit_man_arc')        
        self.table_man_node = self.settings.value('db/table_node', 'v_edit_man_node')   
        self.table_man_connec = self.settings.value('db/table_connec', 'v_edit_man_connec')  
        self.table_man_gully = self.settings.value('db/table_gully', 'v_edit_man_gully')   
        
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

      
        # Tables arc
        self.table_varc = self.settings.value('db/table_varc', 'v_edit_man_varc')
        self.table_siphon = self.settings.value('db/table_siphon', 'v_edit_man_siphon')
        self.table_conduit = self.settings.value('db/table_conduit', 'v_edit_man_conduit')
        self.table_waccel = self.settings.value('db/table_waccel', 'v_edit_man_waccel')
        
  
        # Create UD, WS, MANAGEMENT and EDIT toolbars or not?
        parent = self.iface.mainWindow()
        self.toolbar_ud_enabled = bool(int(self.settings.value('status/toolbar_ud_enabled', 1)))
        self.toolbar_ws_enabled = bool(int(self.settings.value('status/toolbar_ws_enabled', 1)))
        self.toolbar_mg_enabled = bool(int(self.settings.value('status/toolbar_mg_enabled', 1)))
        self.toolbar_ed_enabled = bool(int(self.settings.value('status/toolbar_ed_enabled', 1)))
        if self.toolbar_ud_enabled:
            self.toolbar_ud_name = self.tr('toolbar_ud_name')
            self.toolbar_ud = self.iface.addToolBar(self.toolbar_ud_name)
            self.toolbar_ud.setObjectName(self.toolbar_ud_name)   
        if self.toolbar_ws_enabled:
            self.toolbar_ws_name = self.tr('toolbar_ws_name')
            self.toolbar_ws = self.iface.addToolBar(self.toolbar_ws_name)
            self.toolbar_ws.setObjectName(self.toolbar_ws_name)   
        if self.toolbar_mg_enabled:
            self.toolbar_mg_name = self.tr('toolbar_mg_name')
            self.toolbar_mg = self.iface.addToolBar(self.toolbar_mg_name)
            self.toolbar_mg.setObjectName(self.toolbar_mg_name)      
        if self.toolbar_ed_enabled:
            self.toolbar_ed_name = self.tr('toolbar_ed_name')
            self.toolbar_ed = self.iface.addToolBar(self.toolbar_ed_name)
            self.toolbar_ed.setObjectName(self.toolbar_ed_name)      
                
        # UD toolbar   
        if self.toolbar_ud_enabled:        
            self.ag_ud = QActionGroup(parent);
            self.add_action('01', self.toolbar_ud, self.ag_ud)   
            self.add_action('02', self.toolbar_ud, self.ag_ud)   
            self.add_action('04', self.toolbar_ud, self.ag_ud)   
            self.add_action('05', self.toolbar_ud, self.ag_ud)   
            #self.add_action('03', self.toolbar_ud, self.ag_ud)   
                
        # WS toolbar 
        if self.toolbar_ws_enabled:  
            self.ag_ws = QActionGroup(parent);
            self.add_action('10', self.toolbar_ws, self.ag_ws)
            self.add_action('11', self.toolbar_ws, self.ag_ws)
            self.add_action('12', self.toolbar_ws, self.ag_ws)
            self.add_action('14', self.toolbar_ws, self.ag_ws)
            self.add_action('15', self.toolbar_ws, self.ag_ws)
            self.add_action('08', self.toolbar_ws, self.ag_ws)
            self.add_action('29', self.toolbar_ws, self.ag_ws)
            self.add_action('13', self.toolbar_ws, self.ag_ws)
                
        # MANAGEMENT toolbar 
        if self.toolbar_mg_enabled:      
            self.ag_mg = QActionGroup(parent);
            self.add_action('16', self.toolbar_mg, self.ag_mg)
            self.add_action('28', self.toolbar_mg, self.ag_mg)            
            for i in range(17,28):
                self.add_action(str(i), self.toolbar_mg, self.ag_mg)
            self.add_action('99', self.toolbar_mg, self.ag_mg)
            self.add_action('56', self.toolbar_mg, self.ag_mg)
            self.add_action('57', self.toolbar_mg, self.ag_mg)
                    
        # EDIT toolbar 
        if self.toolbar_ed_enabled:      
            self.ag_ed = QActionGroup(parent);
            for i in range(30,37):
                self.add_action(str(i), self.toolbar_ed, self.ag_ed)                   
         
        # Disable and hide all toolbars
        self.enable_actions(False)
        self.hide_toolbars() 
        
        # Get files to execute giswater jar
        self.java_exe = self.settings.value('files/java_exe')          
        self.giswater_jar = self.settings.value('files/giswater_jar')          
        self.gsw_file = self.settings.value('files/gsw_file')   
                         
        # Load automatically custom forms for layers 'arc', 'node', and 'connec'   
        self.load_custom_forms = bool(int(self.settings.value('status/load_custom_forms', 1)))   
                                 
        # Project initialization
        self.project_read()               


    def unload(self):
        ''' Removes the plugin menu item and icon from QGIS GUI '''
        
        try:
            for action_index, action in self.actions.iteritems():   #@UnusedVariable
                self.iface.removePluginMenu(self.menu_name, action)
                self.iface.removeToolBarIcon(action)
            if self.toolbar_ud_enabled:    
                del self.toolbar_ud
            if self.toolbar_ws_enabled:    
                del self.toolbar_ws
            if self.toolbar_mg_enabled:    
                del self.toolbar_mg
            if self.toolbar_ed_enabled:    
                del self.toolbar_ed
                if self.search_plus is not None:
                    self.search_plus.unload()
        except AttributeError:
            pass
        except KeyError:
            pass
    
    
    ''' Slots '''             

    def enable_actions(self, enable=True, start=1, stop=36):
        ''' Utility to enable all actions '''
        for i in range(start, stop+1):
            self.enable_action(enable, i)              


    def enable_action(self, enable=True, index=1):
        ''' Enable selected action '''
        key = str(index).zfill(2)
        if key in self.actions:
            action = self.actions[key]
            action.setEnabled(enable)                   


    def hide_toolbars(self):
        ''' Hide all toolbars from QGIS GUI '''
        
        try:
            if self.toolbar_ud_enabled:            
                self.toolbar_ud.setVisible(False)
            if self.toolbar_ws_enabled:                
                self.toolbar_ws.setVisible(False)
            if self.toolbar_mg_enabled:                
                self.toolbar_mg.setVisible(False)
            if self.toolbar_ed_enabled:                
                self.toolbar_ed.setVisible(False)
        except AttributeError:
            pass
        except KeyError:
            pass                      
                                  
        
    def search_project_type(self):
        ''' Search in table 'version' project type of current QGIS project '''
        
        try:
            self.mg.project_type = None
            features = self.layer_version.getFeatures()
            for feature in features:
                wsoftware = feature['wsoftware']
                if wsoftware.lower() == 'epanet':
                    self.mg.project_type = 'ws'
                    self.actions['26'].setVisible(True)
                    self.actions['27'].setVisible(True)
                    self.actions['56'].setVisible(False)
                    self.actions['57'].setVisible(False)
                    if self.toolbar_ws_enabled:
                        self.toolbar_ws.setVisible(True)                            
                elif wsoftware.lower() == 'epaswmm':
                    self.mg.project_type = 'ud'
                    self.actions['26'].setVisible(False)
                    self.actions['27'].setVisible(False)
                    self.actions['56'].setVisible(True)
                    self.actions['57'].setVisible(True)
                    if self.toolbar_ud_enabled:
                        self.toolbar_ud.setVisible(True)                
            
            # Set visible MANAGEMENT and EDIT toolbar  
            if self.toolbar_mg_enabled:         
                self.toolbar_mg.setVisible(True)
            if self.toolbar_ed_enabled: 
                self.toolbar_ed.setVisible(True)
            self.ed.search_plus = self.search_plus                   
        except:
            pass                  

                                
    #def project_read(self): 
        ''' Function executed when a user opens a QGIS project (*.qgs) '''
        '''
        if self.dao is None:
            return
 
        # Hide all toolbars
        self.hide_toolbars()
                    
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return    
        
        # Initialize variables
        self.layer_arc = None
        self.layer_node = None
        self.layer_connec = None
        self.layer_gully = None
        self.layer_version = None
        
        self.layer_man_arc = None
        self.layer_man_node = None
        self.layer_man_connec = None
        self.layer_man_gully = None
        
        self.layer_wjoin = None
        self.layer_page = None
        self.layer_greentap = None
        self.layer_fountain = None
        
        self.layer_tank = None
        self.layer_pump = None
        self.layer_source = None
        self.layer_meter = None
        self.layer_junction = None
        self.layer_waterwell = None
        self.layer_reduction = None
        self.layer_hydrant = None
        self.layer_valve = None
        self.layer_manhole = None
        
        self.layer_chamber = None
        self.layer_chamber_pol = None
        self.layer_netgully = None
        self.layer_netgully_pol = None
        self.layer_netinit = None
        self.layer_wjump = None
        self.layer_wwtp = None
        self.layer_wwtp_pol = None
        self.layer_storage = None
        self.layer_storage_pol = None
        self.layer_outfall = None
        
        self.layer_varc = None
        self.layer_siphon = None
        self.layer_conduit = None
        self.layer_waccel = None
        
        
        # Iterate over all layers to get the ones specified in 'db' config section 
        for cur_layer in layers:     
            (uri_schema, uri_table) = self.controller.get_layer_source(cur_layer)   #@UnusedVariable
            if uri_table is not None:
                
                
                if self.table_arc in uri_table:  
                    self.layer_arc = cur_layer
                if self.table_node in uri_table:  
                    self.layer_node = cur_layer
                if self.table_connec in uri_table:  
                    self.layer_connec = cur_layer
                if self.table_gully in uri_table:  
                    self.layer_gully = cur_layer
                if self.table_version in uri_table:  
                    self.layer_version = cur_layer 
                    
                if self.table_man_arc in uri_table:  
                    self.layer_man_arc = cur_layer
                if self.table_man_node in uri_table:  
                    self.layer_man_node = cur_layer
                if self.table_man_connec in uri_table:  
                    self.layer_man_connec = cur_layer
                if self.table_man_gully in uri_table:  
                    self.layer_man_gully = cur_layer
                    
                    
                # Connec
                if self.table_wjoin in uri_table:  
                    self.layer_wjoin = cur_layer 
                if self.table_page in uri_table:  
                    self.layer_page = cur_layer 
                if self.table_greentap in uri_table:  
                    self.layer_greentap = cur_layer 
                if self.table_fountain in uri_table:  
                    self.layer_fountain = cur_layer  
                    
                # Node
                if self.table_tank in uri_table:  
                    self.layer_tank = cur_layer 
                if self.table_pump in uri_table:  
                    self.layer_pump = cur_layer 
                if self.table_source in uri_table:  
                    self.layer_source = cur_layer 
                if self.table_meter in uri_table:  
                    self.layer_meter = cur_layer 
                if self.table_junction in uri_table:  
                    self.layer_junction = cur_layer 
                if self.table_waterwell in uri_table:  
                    self.layer_waterwell = cur_layer 
                if self.table_reduction in uri_table:  
                    self.layer_reduction = cur_layer 
                if self.table_hydrant in uri_table:  
                    self.layer_hydrant = cur_layer
                if self.table_valve in uri_table:  
                    self.layer_valve = cur_layer 
                if self.table_manhole in uri_table:  
                    self.layer_manhole = cur_layer 
                    
                if self.table_chamber in uri_table:  
                    self.layer_chamber = cur_layer  
                if self.table_chamber_pol in uri_table:  
                    self.layer_chamber_pol = cur_layer
                if self.table_netgully in uri_table:  
                    self.layer_netgully = cur_layer
                if self.table_netgully_pol in uri_table:  
                    self.layer_netgully_pol = cur_layer 
                if self.table_netinit in uri_table:  
                    self.layer_netinit = cur_layer 
                if self.table_wjump in uri_table:  
                    self.layer_wjump = cur_layer 
                if self.table_wwtp in uri_table:  
                    self.layer_wwtp = cur_layer   
                if self.table_wwtp_pol in uri_table:  
                    self.layer_wwtp_pol = cur_layer 
                if self.table_storage in uri_table:  
                    self.layer_storage = cur_layer
                if self.table_storage_pol in uri_table:  
                    self.layer_storage_pol = cur_layer 
                if self.table_outfall in uri_table:  
                    self.layer_outfall = cur_layer          
              
                    
                # Arc
                if self.table_varc in uri_table:  
                    self.layer_varc = cur_layer  
                if self.table_siphon in uri_table:  
                    self.layer_siphon = cur_layer 
                if self.table_conduit in uri_table:  
                    self.layer_conduit = cur_layer 
                if self.table_waccel in uri_table:  
                    self.layer_waccel = cur_layer    
                 
        
        # Check if table 'version' exists
        if self.layer_version is None:
            self.controller.show_warning("Layer version not found")
            return
                 
        # Get schema name from table 'version'
        # Check if really exists
        (self.schema_name, uri_table) = self.controller.get_layer_source(self.layer_version)  
        schema_name = self.schema_name.replace('"', '')
        if self.schema_name is None or not self.dao.check_schema(schema_name):
            self.controller.show_warning("Schema not found: "+self.schema_name)            
            return
        
        # Set schema_name in controller and in config file
        self.settings.setValue("db/schema_name", self.schema_name)    
        self.controller.set_schema_name(self.schema_name)    
        
        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)        
        
        # Set SRID from table node
        sql = "SELECT Find_SRID('"+schema_name+"', '"+self.table_node+"', 'the_geom');"
        row = self.dao.get_row(sql)
        if row:
            self.srid = row[0]   
            self.settings.setValue("db/srid", self.srid)                           
        
        # Search project type in table 'version'
        self.search_project_type()
                                         
        # Set layer custom UI form and init function   
        if self.layer_arc is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_arc_init.py')                     
            self.layer_arc.editFormConfig().setUiForm(file_ui) 
            self.layer_arc.editFormConfig().setInitCodeSource(1)
            self.layer_arc.editFormConfig().setInitFilePath(file_init)           
            self.layer_arc.editFormConfig().setInitFunction('formOpen') 
         
        if self.layer_node is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_node_init.py')       
            self.layer_node.editFormConfig().setUiForm(file_ui) 
            self.layer_node.editFormConfig().setInitCodeSource(1)
            self.layer_node.editFormConfig().setInitFilePath(file_init)           
            self.layer_node.editFormConfig().setInitFunction('formOpen')                         
                                    
        if self.layer_connec is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_connec_init.py')       
            self.layer_connec.editFormConfig().setUiForm(file_ui) 
            self.layer_connec.editFormConfig().setInitCodeSource(1)
            self.layer_connec.editFormConfig().setInitFilePath(file_init)           
            self.layer_connec.editFormConfig().setInitFunction('formOpen')   

        if self.layer_gully is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_gully.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_gully_init.py')       
            self.layer_gully.editFormConfig().setUiForm(file_ui) 
            self.layer_gully.editFormConfig().setInitCodeSource(1)
            self.layer_gully.editFormConfig().setInitFilePath(file_init)           
            self.layer_gully.editFormConfig().setInitFunction('formOpen') 
            
            
        if self.layer_man_arc is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_arc_init.py')                     
            self.layer_man_arc.editFormConfig().setUiForm(file_ui) 
            self.layer_man_arc.editFormConfig().setInitCodeSource(1)
            self.layer_man_arc.editFormConfig().setInitFilePath(file_init)           
            self.layer_man_arc.editFormConfig().setInitFunction('formOpen') 
         
        if self.layer_man_node is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')       
            self.layer_man_node.editFormConfig().setUiForm(file_ui) 
            self.layer_man_node.editFormConfig().setInitCodeSource(1)
            self.layer_man_node.editFormConfig().setInitFilePath(file_init)           
            self.layer_man_node.editFormConfig().setInitFunction('formOpen')                         
                                    
        if self.layer_man_connec is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_connec_init.py')       
            self.layer_man_connec.editFormConfig().setUiForm(file_ui) 
            self.layer_man_connec.editFormConfig().setInitCodeSource(1)
            self.layer_man_connec.editFormConfig().setInitFilePath(file_init)           
            self.layer_man_connec.editFormConfig().setInitFunction('formOpen')   
        
        if self.layer_man_gully is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_gully.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_gully_init.py')       
            self.layer_man_gully.editFormConfig().setUiForm(file_ui) 
            self.layer_man_gully.editFormConfig().setInitCodeSource(1)
            self.layer_man_gully.editFormConfig().setInitFilePath(file_init)           
            self.layer_man_gully.editFormConfig().setInitFunction('formOpen') 
            
        
        if self.layer_wjoin is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_connec_init.py')       
            self.layer_wjoin.editFormConfig().setUiForm(file_ui) 
            self.layer_wjoin.editFormConfig().setInitCodeSource(1)
            self.layer_wjoin.editFormConfig().setInitFilePath(file_init)           
            self.layer_wjoin.editFormConfig().setInitFunction('formOpen')   
            
        
        if self.layer_page is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_connec_init.py')  
            self.layer_page.editFormConfig().setUiForm(file_ui) 
            self.layer_page.editFormConfig().setInitCodeSource(1)
            self.layer_page.editFormConfig().setInitFilePath(file_init)           
            self.layer_page.editFormConfig().setInitFunction('formOpen')   
            
        
        if self.layer_greentap is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_connec_init.py')      
            self.layer_greentap.editFormConfig().setUiForm(file_ui) 
            self.layer_greentap.editFormConfig().setInitCodeSource(1)
            self.layer_greentap.editFormConfig().setInitFilePath(file_init)           
            self.layer_greentap.editFormConfig().setInitFunction('formOpen')   
            
            
        if self.layer_fountain is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_connec_init.py')      
            self.layer_fountain.editFormConfig().setUiForm(file_ui) 
            self.layer_fountain.editFormConfig().setInitCodeSource(1)
            self.layer_fountain.editFormConfig().setInitFilePath(file_init)           
            self.layer_fountain.editFormConfig().setInitFunction('formOpen')  
            
        
        if self.layer_tank is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')       
            self.layer_tank.editFormConfig().setUiForm(file_ui) 
            self.layer_tank.editFormConfig().setInitCodeSource(1)
            self.layer_tank.editFormConfig().setInitFilePath(file_init)           
            self.layer_tank.editFormConfig().setInitFunction('formOpen') 
            
        
        if self.layer_pump is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')         
            self.layer_pump.editFormConfig().setUiForm(file_ui) 
            self.layer_pump.editFormConfig().setInitCodeSource(1)
            self.layer_pump.editFormConfig().setInitFilePath(file_init)           
            self.layer_pump.editFormConfig().setInitFunction('formOpen') 
            
        
        if self.layer_source is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')        
            self.layer_source.editFormConfig().setUiForm(file_ui) 
            self.layer_source.editFormConfig().setInitCodeSource(1)
            self.layer_source.editFormConfig().setInitFilePath(file_init)           
            self.layer_source.editFormConfig().setInitFunction('formOpen')
            
            
        if self.layer_meter is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')        
            self.layer_meter.editFormConfig().setUiForm(file_ui) 
            self.layer_meter.editFormConfig().setInitCodeSource(1)
            self.layer_meter.editFormConfig().setInitFilePath(file_init)           
            self.layer_meter.editFormConfig().setInitFunction('formOpen') 
            
        
        if self.layer_junction is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')         
            self.layer_junction.editFormConfig().setUiForm(file_ui) 
            self.layer_junction.editFormConfig().setInitCodeSource(1)
            self.layer_junction.editFormConfig().setInitFilePath(file_init)           
            self.layer_junction.editFormConfig().setInitFunction('formOpen') 
            
            
        if self.layer_waterwell is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')         
            self.layer_waterwell.editFormConfig().setUiForm(file_ui) 
            self.layer_waterwell.editFormConfig().setInitCodeSource(1)
            self.layer_waterwell.editFormConfig().setInitFilePath(file_init)           
            self.layer_waterwell.editFormConfig().setInitFunction('formOpen')
            
            
        if self.layer_reduction is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')        
            self.layer_reduction.editFormConfig().setUiForm(file_ui) 
            self.layer_reduction.editFormConfig().setInitCodeSource(1)
            self.layer_reduction.editFormConfig().setInitFilePath(file_init)           
            self.layer_reduction.editFormConfig().setInitFunction('formOpen') 
            
            
        if self.layer_hydrant is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')         
            self.layer_hydrant.editFormConfig().setUiForm(file_ui) 
            self.layer_hydrant.editFormConfig().setInitCodeSource(1)
            self.layer_hydrant.editFormConfig().setInitFilePath(file_init)           
            self.layer_hydrant.editFormConfig().setInitFunction('formOpen') 
            
            
        if self.layer_valve is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')    
            self.layer_valve.editFormConfig().setUiForm(file_ui) 
            self.layer_valve.editFormConfig().setInitCodeSource(1)
            self.layer_valve.editFormConfig().setInitFilePath(file_init)           
            self.layer_valve.editFormConfig().setInitFunction('formOpen')
            
            
        if self.layer_manhole is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_manhole.editFormConfig().setUiForm(file_ui) 
            self.layer_manhole.editFormConfig().setInitCodeSource(1)
            self.layer_manhole.editFormConfig().setInitFilePath(file_init)           
            self.layer_manhole.editFormConfig().setInitFunction('formOpen')    
            
            
        if self.layer_chamber is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_chamber.editFormConfig().setUiForm(file_ui) 
            self.layer_chamber.editFormConfig().setInitCodeSource(1)
            self.layer_chamber.editFormConfig().setInitFilePath(file_init)           
            self.layer_chamber.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_chamber_pol is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_chamber_pol.editFormConfig().setUiForm(file_ui) 
            self.layer_chamber_pol.editFormConfig().setInitCodeSource(1)
            self.layer_chamber_pol.editFormConfig().setInitFilePath(file_init)           
            self.layer_chamber_pol.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_netgully is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_netgully.editFormConfig().setUiForm(file_ui) 
            self.layer_netgully.editFormConfig().setInitCodeSource(1)
            self.layer_netgully.editFormConfig().setInitFilePath(file_init)           
            self.layer_netgully.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_netgully_pol is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_netgully_pol.editFormConfig().setUiForm(file_ui) 
            self.layer_netgully_pol.editFormConfig().setInitCodeSource(1)
            self.layer_netgully_pol.editFormConfig().setInitFilePath(file_init)           
            self.layer_netgully_pol.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_netinit is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_netinit.editFormConfig().setUiForm(file_ui) 
            self.layer_netinit.editFormConfig().setInitCodeSource(1)
            self.layer_netinit.editFormConfig().setInitFilePath(file_init)           
            self.layer_netinit.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_wjump is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_wjump.editFormConfig().setUiForm(file_ui) 
            self.layer_wjump.editFormConfig().setInitCodeSource(1)
            self.layer_wjump.editFormConfig().setInitFilePath(file_init)           
            self.layer_wjump.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_wwtp is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_wwtp.editFormConfig().setUiForm(file_ui) 
            self.layer_wwtp.editFormConfig().setInitCodeSource(1)
            self.layer_wwtp.editFormConfig().setInitFilePath(file_init)           
            self.layer_wwtp.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_wwtp_pol is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_wwtp_pol.editFormConfig().setUiForm(file_ui) 
            self.layer_wwtp_pol.editFormConfig().setInitCodeSource(1)
            self.layer_wwtp_pol.editFormConfig().setInitFilePath(file_init)           
            self.layer_wwtp_pol.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_storage is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_storage.editFormConfig().setUiForm(file_ui) 
            self.layer_storage.editFormConfig().setInitCodeSource(1)
            self.layer_storage.editFormConfig().setInitFilePath(file_init)           
            self.layer_storage.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_storage_pol is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_storage_pol.editFormConfig().setUiForm(file_ui) 
            self.layer_storage_pol.editFormConfig().setInitCodeSource(1)
            self.layer_storage_pol.editFormConfig().setInitFilePath(file_init)           
            self.layer_storage_pol.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_outfall is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_node_init.py')      
            self.layer_outfall.editFormConfig().setUiForm(file_ui) 
            self.layer_outfall.editFormConfig().setInitCodeSource(1)
            self.layer_outfall.editFormConfig().setInitFilePath(file_init)           
            self.layer_outfall.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_varc is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_arc_init.py')      
            self.layer_varc.editFormConfig().setUiForm(file_ui) 
            self.layer_varc.editFormConfig().setInitCodeSource(1)
            self.layer_varc.editFormConfig().setInitFilePath(file_init)           
            self.layer_varc.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_siphon is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_arc_init.py')      
            self.layer_siphon.editFormConfig().setUiForm(file_ui) 
            self.layer_siphon.editFormConfig().setInitCodeSource(1)
            self.layer_siphon.editFormConfig().setInitFilePath(file_init)           
            self.layer_siphon.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_conduit is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_arc_init.py')      
            self.layer_conduit.editFormConfig().setUiForm(file_ui) 
            self.layer_conduit.editFormConfig().setInitCodeSource(1)
            self.layer_conduit.editFormConfig().setInitFilePath(file_init)           
            self.layer_conduit.editFormConfig().setInitFunction('formOpen') 
            
        if self.layer_waccel is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_man_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_man_arc_init.py')      
            self.layer_waccel.editFormConfig().setUiForm(file_ui) 
            self.layer_waccel.editFormConfig().setInitCodeSource(1)
            self.layer_waccel.editFormConfig().setInitFilePath(file_init)           
            self.layer_waccel.editFormConfig().setInitFunction('formOpen') 
            
        


        # Manage current layer selected     
        self.current_layer_changed(self.iface.activeLayer())   
        
        # Set objects for map tools classes
        map_tool = self.map_tools['mg_move_node']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        
        map_tool = self.map_tools['mg_delete_node']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        
        map_tool = self.map_tools['mg_mincut']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_flow_trace']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_flow_exit']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_connec_tool']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_extract_raster_value']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        map_tool.set_config_action(self.actions['99'])
        
        # Create SearchPlus object
        try:
            if self.search_plus is None:
                self.search_plus = SearchPlus(self.iface, self.srid, self.controller)
                self.search_plus.remove_memory_layers() 
            self.ed.search_plus = self.search_plus             
            status = self.search_plus.populate_dialog()
            self.actions['32'].setVisible(status) 
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False) 
        except KeyError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)                     
            pass   
        except RuntimeError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)                     
        
        self.custom_enable_actions()
        '''
        
    def project_read(self): 
        ''' Function executed when a user opens a QGIS project (*.qgs) '''
        
        if self.dao is None:
            return
                
        # Hide all toolbars
        self.hide_toolbars()
                    
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return    
        
        # Initialize variables
        self.layer_arc = None

        self.layer_node = None
        self.layer_node_man = [None for i in range(11)]

        self.layer_connec = None
        self.layer_connec_man = [None for i in range(5)]

        self.layer_gully = None
        self.layer_version = None

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            (uri_schema, uri_table) = self.controller.get_layer_source(cur_layer)   #@UnusedVariable
            if uri_table is not None:
                if self.table_arc in uri_table:
                    self.layer_arc = cur_layer

                if self.table_node in uri_table:
                    self.layer_node = cur_layer
                if 'v_edit_man_hydrant' in uri_table:
                    self.layer_node_man[0] = cur_layer
                if 'v_edit_man_junction' in uri_table:
                    self.layer_node_man[1] = cur_layer
                if 'v_edit_man_manhole' in uri_table:
                    self.layer_node_man[2] = cur_layer
                if 'v_edit_man_meter' in uri_table:
                    self.layer_node_man[3] = cur_layer
                if 'v_edit_man_node' in uri_table:
                    self.layer_node_man[4] = cur_layer
                if 'v_edit_man_pump' in uri_table:
                    self.layer_node_man[5] = cur_layer
                if 'v_edit_man_reduction' in uri_table:
                    self.layer_node_man[6] = cur_layer
                if 'v_edit_man_source' in uri_table:
                    self.layer_node_man[7] = cur_layer
                if 'v_edit_man_tank' in uri_table:
                    self.layer_node_man[8] = cur_layer
                if 'v_edit_man_valve' in uri_table:
                    self.layer_node_man[9] = cur_layer
                if 'v_edit_man_waterwell' in uri_table:
                    self.layer_node_man[10] = cur_layer


                if self.table_connec in uri_table:
                    self.layer_connec = cur_layer
                if 'v_edit_man_connec' in uri_table:
                    self.layer_connec_man[0] = cur_layer
                if 'v_edit_man_fountain' in uri_table:
                    self.layer_connec_man[1] = cur_layer
                if 'v_edit_man_greentap' in uri_table:
                    self.layer_connec_man[2] = cur_layer
                if 'v_edit_man_tap' in uri_table:
                    self.layer_connec_man[3] = cur_layer
                if 'v_edit_man_wjoin' in uri_table:
                    self.layer_connec_man[4] = cur_layer

                if self.table_gully in uri_table:
                    self.layer_gully = cur_layer
                if self.table_version in uri_table:
                    self.layer_version = cur_layer

        # Check if table 'version' exists
        if self.layer_version is None:
            self.controller.show_warning("Layer version not found")
            return
                 
        # Get schema name from table 'version'
        # Check if really exists
        (self.schema_name, uri_table) = self.controller.get_layer_source(self.layer_version)  
        schema_name = self.schema_name.replace('"', '')
        if self.schema_name is None or not self.dao.check_schema(schema_name):
            self.controller.show_warning("Schema not found: "+self.schema_name)            
            return
        
        # Set schema_name in controller and in config file
        self.settings.setValue("db/schema_name", self.schema_name)    
        self.controller.set_schema_name(self.schema_name)    
        
        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)        
        
        # Set SRID from table node
        sql = "SELECT Find_SRID('"+schema_name+"', '"+self.table_node+"', 'the_geom');"
        row = self.dao.get_row(sql)
        if row:
            self.srid = row[0]   
            self.settings.setValue("db/srid", self.srid)                           
        
        # Search project type in table 'version'
        self.search_project_type()
                                         
        # Set layer custom UI form and init function   
        if self.layer_arc is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_arc.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_arc_init.py')                     
            self.layer_arc.editFormConfig().setUiForm(file_ui) 
            self.layer_arc.editFormConfig().setInitCodeSource(1)
            self.layer_arc.editFormConfig().setInitFilePath(file_init)           
            self.layer_arc.editFormConfig().setInitFunction('formOpen') 
         
        if self.layer_node is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_node.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_node_init.py')       
            self.layer_node.editFormConfig().setUiForm(file_ui) 
            self.layer_node.editFormConfig().setInitCodeSource(1)
            self.layer_node.editFormConfig().setInitFilePath(file_init)           
            self.layer_node.editFormConfig().setInitFunction('formOpen')

            for i in range(11):
                if self.layer_node_man[i] is not None:
                    self.layer_node_man[i].editFormConfig().setUiForm(file_ui)
                    self.layer_node_man[i].editFormConfig().setInitCodeSource(1)
                    self.layer_node_man[i].editFormConfig().setInitFilePath(file_init)
                    self.layer_node_man[i].editFormConfig().setInitFunction('formOpen')

        if self.layer_connec is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_connec.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_connec_init.py')       
            self.layer_connec.editFormConfig().setUiForm(file_ui) 
            self.layer_connec.editFormConfig().setInitCodeSource(1)
            self.layer_connec.editFormConfig().setInitFilePath(file_init)           
            self.layer_connec.editFormConfig().setInitFunction('formOpen')

            for i in range(5):
                if self.layer_connec_man[i] is not None:
                    self.layer_connec_man[i].editFormConfig().setUiForm(file_ui)
                    self.layer_connec_man[i].editFormConfig().setInitCodeSource(1)
                    self.layer_connec_man[i].editFormConfig().setInitFilePath(file_init)
                    self.layer_connec_man[i].editFormConfig().setInitFunction('formOpen')

        if self.layer_gully is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', self.mg.project_type+'_gully.ui')
            file_init = os.path.join(self.plugin_dir, self.mg.project_type+'_gully_init.py')       
            self.layer_connec.editFormConfig().setUiForm(file_ui) 
            self.layer_connec.editFormConfig().setInitCodeSource(1)
            self.layer_connec.editFormConfig().setInitFilePath(file_init)           
            self.layer_connec.editFormConfig().setInitFunction('formOpen')                       

                      
        # Manage current layer selected     
        self.current_layer_changed(self.iface.activeLayer())   
        
        # Set objects for map tools classes
        map_tool = self.map_tools['mg_move_node']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        
        map_tool = self.map_tools['mg_delete_node']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        
        map_tool = self.map_tools['mg_mincut']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_flow_trace']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_flow_exit']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_connec_tool']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)

        map_tool = self.map_tools['mg_extract_raster_value']
        map_tool.set_layers(self.layer_arc, self.layer_connec, self.layer_node)
        map_tool.set_controller(self.controller)
        map_tool.set_config_action(self.actions['99'])

        # Create SearchPlus object
        try:
            if self.search_plus is None:
                self.search_plus = SearchPlus(self.iface, self.srid, self.controller)
                self.search_plus.remove_memory_layers() 
            self.ed.search_plus = self.search_plus             
            status = self.search_plus.populate_dialog()
            self.actions['32'].setVisible(status) 
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False) 
        except KeyError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)                     
            pass   
        except RuntimeError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)                     
        
        self.custom_enable_actions()
                                
    def current_layer_changed(self, layer):
        ''' Manage new layer selected '''

        # Disable all actions (buttons)
        self.enable_actions(False)
        
        self.custom_enable_actions()     
        
        if layer is None:
            layer = self.iface.activeLayer() 
            if layer is None:
                return            
        self.current_layer = layer
        
        # Check is selected layer is 'arc', 'node' or 'connec'
        setting_name = None
        (uri_schema, uri_table) = self.controller.get_layer_source(layer)  #@UnusedVariable  
        if uri_table is not None:
            if self.table_arc in uri_table:  
                setting_name = 'buttons_arc'     
            elif self.table_node in uri_table:  
                setting_name = 'buttons_node'
            elif self.table_connec in uri_table:  
                setting_name = 'buttons_connec' 
            elif self.table_gully in uri_table:  
                setting_name = 'buttons_gully' 
                
            elif self.table_wjoin in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_page in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_greentap in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_fountain in uri_table:  
                setting_name = 'buttons_connec'
            
            
            elif self.table_tank in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_pump in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_source in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_meter in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_junction in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_waterwell in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_reduction in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_hydrant in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_valve in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_manhole in uri_table:  
                setting_name = 'buttons_node'   
            
            elif self.table_chamber in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_chamber_pol in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_netgully in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_netgully_pol in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_netinit in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_wjump in uri_table:  
                setting_name = 'buttons_node'   
            elif self.table_wwtp in uri_table:  
                setting_name = 'buttons_node'     
            elif self.table_wwtp_pol in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_storage in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_storage_pol in uri_table:  
                setting_name = 'buttons_node'  
            elif self.table_outfall in uri_table:  
                setting_name = 'buttons_node'        
              
            
            elif self.table_varc in uri_table:  
                setting_name = 'buttons_arc'  
            elif self.table_siphon in uri_table:  
                setting_name = 'buttons_arc' 
            elif self.table_conduit in uri_table:  
                setting_name = 'buttons_arc'   
            elif self.table_waccel in uri_table:  
                setting_name = 'buttons_arc'      
            
            
            
        if setting_name is not None:
            try:
                list_index_action = self.settings.value('layers/'+setting_name, None)
                if list_index_action:
                    if type(list_index_action) is list:
                        for index_action in list_index_action:
                            if index_action != '-1' and str(index_action) in self.actions:
                                self.actions[index_action].setEnabled(True)
                    elif type(list_index_action) is unicode:
                        index_action = str(list_index_action)
                        if index_action != '-1' and str(index_action) in self.actions:
                            self.actions[index_action].setEnabled(True)                
            except AttributeError, e:
                print "current_layer_changed: "+str(e)
            except KeyError, e:
                print "current_layer_changed: "+str(e)
                        
    
    def custom_enable_actions(self):
        ''' Enable selected actions '''
        
        # Enable MG toolbar
        self.enable_actions(True, 16, 27)
        self.enable_action(False, 22)        
        self.enable_action(False, 23)        
        
        # Enable ED toolbar
        self.enable_actions(True, 30, 36)
                
                    
    def ws_generic(self, function_name):   
        ''' Water supply generic callback function '''
        
        try:
            # Get sender (selected action) and map tool associated 
            sender = self.sender()                            
            map_tool = self.map_tools[function_name]
            if sender.isChecked():
                self.iface.mapCanvas().setMapTool(map_tool)     
            else:
                self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))    
            
            
    def ud_generic(self, function_name):   
        ''' Urban drainage generic callback function '''
        
        try:        
            # Get sender (selected action) and map tool associated 
            sender = self.sender()            
            map_tool = self.map_tools[function_name]
            if sender.isChecked():
                self.iface.mapCanvas().setMapTool(map_tool)  
            else:
                self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))             
            
            
    def mg_generic(self, function_name):   
        ''' Management generic callback function '''
        
        try:        
            if function_name in self.map_tools:          
                map_tool = self.map_tools[function_name]
                if not (map_tool == self.iface.mapCanvas().mapTool()):
                    self.iface.mapCanvas().setMapTool(map_tool)
                else:
                    self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))              




    
        