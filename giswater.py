'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.core import QgsMapLayerRegistry, QgsProject, QCoreApplication, QgsExpressionContextUtils
from PyQt4.QtCore import QObject, QSettings, QTranslator
from PyQt4.QtGui import QAction, QActionGroup, QIcon, QMenu

import os.path
import sys  
from functools import partial

from actions.ed import Ed
from actions.mg import Mg
from dao.controller import DaoController
from map_tools.line import LineMapTool
from map_tools.point import PointMapTool
from map_tools.move_node import MoveNodeMapTool
from map_tools.mincut import MincutMapTool
from map_tools.flow_trace_flow_exit import FlowTraceFlowExitMapTool
from map_tools.delete_node import DeleteNodeMapTool
from map_tools.connec import ConnecMapTool
#from map_tools.valve_analytics import ValveAnalytics
from map_tools.extract_raster_value import ExtractRasterValue
from map_tools.draw_profiles import DrawProfiles
from map_tools.flow_regulator import FlowRegulator
#from map_tools.dimensions import Dimensions

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

        # Initialize instance attributes
        self.iface = iface
        self.legend = iface.legendInterface()    
        self.dao = None
        self.actions = {}
        self.search_plus = None
        self.map_tools = {}
        self.srid = None  
        self.menu_values = None
            
        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)    
        self.plugin_name = os.path.basename(self.plugin_dir)   
        self.icon_folder = self.plugin_dir+'/icons/'    

        # Initialize svg giswater directory
        self.svg_plugin_dir = os.path.join(self.plugin_dir, 'svg')
        QgsExpressionContextUtils.setProjectVariable('svg_path',self.svg_plugin_dir)   

        # Initialize locale
        locale = QSettings().value('locale/userLocale')
        locale_path = os.path.join(self.plugin_dir, 'i18n', self.plugin_name+'_{}.qm'.format(locale))
        # If user locale not exists, load English
        if not os.path.exists(locale_path):
            locale_path = os.path.join(self.plugin_dir, 'i18n', self.plugin_name+'_en_US.qm')

        self.translator = QTranslator()
        self.translator.load(locale_path)
        QCoreApplication.installTranslator(self.translator)
            
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
        self.controller.set_qgis_settings(self.qgis_settings)
        connection_status = self.controller.set_database_connection()
        if not connection_status:
            msg = self.controller.last_error  
            self.controller.show_message(msg, 1, 100) 
            return 
        
        self.dao = self.controller.dao 
        
        # Set actions classes
        self.ed = Ed(self.iface, self.settings, self.controller, self.plugin_dir)
        self.mg = Mg(self.iface, self.settings, self.controller, self.plugin_dir)
        
        # Define signals
        self.set_signals()
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable
       
               
    def set_signals(self): 
        ''' Define widget and event signals '''
        self.iface.projectRead.connect(self.project_read)                
        self.legend.currentLayerChanged.connect(self.current_layer_changed) 

  
    def tr(self, message):
        if self.controller:
            return self.controller.tr(message)      
        
    
    def manage_action(self, index_action, function_name):  
        
        if function_name is not None:
            try:
                action = self.actions[index_action]                
                # Management toolbar actions
                if int(index_action) in (01,02,19, 21, 23, 24, 25,27,39,41,45,46,47,28,99):
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
                action.setEnabled(False)                
        else:
            action.setEnabled(False)
            
     
    def create_action(self, index_action=None, text='', toolbar=None, menu=None, is_checkable=True, function_name=None, parent=None):
        
        schema_name=self.controller.get_schema_name()

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
            if index_action == '01':
                # Button add_node   
                # Add drop down menu to button in toolbar
                self.menu=QMenu()
                self.menu.clear()
             
   
                # Get translated type
                sql = "SELECT DISTINCT(i18n) FROM "+schema_name+".node_type_cat_type "    
                row_id = self.dao.get_rows(sql) 
                
                # Get shortcut
                #sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".node_type WHERE id='"+str(row_id[j][0])+"'"    
                #sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".node_type_cat_type "    
                #row_shortcut = self.dao.get_rows(sql) 
                
                for i in range(0, len(row_id)):
                    # Get shortcut 
                    sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".node_type_cat_type WHERE i18n='"+str(row_id[i][0])+"'" 
                    row_shortcut = self.dao.get_rows(sql)
                    obj_action = QAction(str(row_id[i][0]),self)
                    obj_action.setShortcut(str(row_shortcut[0][0]))
                    self.menu.addAction(obj_action)
                    obj_action.triggered.connect( partial(self.menu_activate,str(row_id[i][0])))
                
                action.setMenu(self.menu)
                
            if index_action == '02':
            
                # Button add_arc 
                # Add drop down menu to button in toolbar
                self.menu_arc=QMenu()
                self.menu_arc.clear()

                # Get translated type
                sql = "SELECT DISTINCT(i18n) FROM "+schema_name+".arc_type_cat_type "    
                row_id = self.dao.get_rows(sql) 
               

                for i in range(0, len(row_id)):
                    # Get shortcut 
                    sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".arc_type_cat_type WHERE i18n='"+str(row_id[i][0])+"'" 
                    row_shortcut = self.dao.get_rows(sql)
                    obj_action = QAction(str(row_id[i][0]),self)
                    obj_action.setShortcut(str(row_shortcut[0][0]))
                    self.menu_arc.addAction(obj_action)
                    obj_action.triggered.connect( partial(self.menu_activate,str(row_id[i][0])))
                
                action.setMenu(self.menu_arc)
                '''
                self.sub_menu=QMenu()
                
                list = [] 
                
                for i in range(0, len(row)):
                    sql = "SELECT DISTINCT(id) FROM "+schema_name+".node_type WHERE i18n='"+str(row[i][0])+"'"    
                    row_id = self.dao.get_rows(sql) 
   
                    list.append(QMenu(self.sub_menu))
                    #self.sub_menu=QMenu()
                    list[i].setTitle(row[i][0])
                    self.menu.addMenu(list[i])

                    for j in range(0, len(row_id)):                 
                        # Get shortcut
                        sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".node_type WHERE id='"+str(row_id[j][0])+"'"    
                        row_shortcut = self.dao.get_rows(sql) 

                        obj_action = QAction(str(row_id[j][0]),self)
                        obj_action.setShortcut(str(row_shortcut[0][0]))
                        list[i].addAction( obj_action )
                        # Provide node_type and node_type_id
                        obj_action.triggered.connect( partial(self.menu_activate,str(row[i][0])))

                action.setMenu(self.menu)
                '''
            
            '''    
            if index_action == '02':
            # Button add_arc
                # Add drop down menu to button in toolbar
                self.menu_arc=QMenu()
                #self.sub_menu=QMenu()
                self.menu_arc.clear()
                # Get translated type
                sql = "SELECT DISTINCT(i18n) FROM "+schema_name+".arc_type "    
                row = self.dao.get_rows(sql) 
                
                self.sub_menu_arc=QMenu()
                
                list = [] 
                
                for i in range(0, len(row)):
                    sql = "SELECT DISTINCT(id) FROM "+schema_name+".arc_type WHERE i18n='"+str(row[i][0])+"'"    
                    row_id = self.dao.get_rows(sql) 
   
                    list.append(QMenu(self.sub_menu_arc))
                    #self.sub_menu=QMenu()
                    list[i].setTitle(row[i][0])
                    self.menu_arc.addMenu(list[i])

                    for j in range(0, len(row_id)):                 
                        # Get shortcut
                        sql = "SELECT DISTINCT(shortcut_key) FROM "+schema_name+".arc_type WHERE id='"+str(row_id[j][0])+"'"    
                        row_shortcut = self.dao.get_rows(sql) 

                        obj_action = QAction(str(row_id[j][0]),self)
                        obj_action.setShortcut(str(row_shortcut[0][0]))
                        list[i].addAction( obj_action )
                        obj_action.triggered.connect( partial(self.menu_activate,str(row[i][0]) ))
                           
                action.setMenu(self.menu_arc)
            '''          
                  
        if toolbar is not None:
            toolbar.addAction(action)  
             
        if menu is not None:
            self.iface.addPluginToMenu(menu, action)
            
        if index_action is not None:         
            self.actions[index_action] = action
        else:
            self.actions[text] = action
                                     
        action.setCheckable(is_checkable)                         
        self.manage_action(index_action, function_name)
            
        return action
          
        
    def menu_activate(self,node_type):
        
        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName(node_type)[0]
        self.iface.setActiveLayer(layer)
        
        # Find the layer to edit
        #layer = self.iface.activeLayer()
        layer.startEditing()
        # Implement the Add Feature button
        self.iface.actionAddFeature().trigger()

    
    def add_action(self, index_action, toolbar, parent):
        ''' Add new action into specified toolbar 
        This action has to be defined in the configuration file ''' 
        
        action = None
        text_action = self.tr(index_action+'_text')
        function_name = self.settings.value('actions/'+str(index_action)+'_function')
        
        if function_name:
            
            map_tool = None
            if int(index_action) != 99:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
            else:
                # 99 should be not checkable
                action = self.create_action(index_action, text_action, toolbar, None, False, function_name, parent)
                            
            if int(index_action) in (3, 5, 13):
                map_tool = LineMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) in (1, 4, 10, 11, 12, 14, 15, 8, 29):
                map_tool = PointMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)   
            elif int(index_action) == 16:
                map_tool = MoveNodeMapTool(self.iface, self.settings, action, index_action, self.srid)
            elif int(index_action) == 17:
                map_tool = DeleteNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 18:
                map_tool = ExtractRasterValue(self.iface, self.settings, action, index_action)
            elif int(index_action) == 26:
                map_tool = MincutMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 20:
                map_tool = ConnecMapTool(self.iface, self.settings, action, index_action)
            #elif int(index_action) == 39:
            #    map_tool = Dimensions(self.iface, self.settings, action, index_action)
            #elif int(index_action) == 27:
            #    map_tool = ValveAnalytics(self.iface, self.settings, action, index_action)
            elif int(index_action) == 43:
                map_tool = DrawProfiles(self.iface, self.settings, action, index_action)
            elif int(index_action) == 52:
                map_tool = FlowRegulator(self.iface, self.settings, action, index_action)
            elif int(index_action) == 56:
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 57:
                map_tool = FlowTraceFlowExitMapTool(self.iface, self.settings, action, index_action)

            # If this action has an associated map tool, add this to dictionary of available map_tools
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
                
        # Set an action list for every toolbar    
        self.list_actions_ud = ['02','04','05']
        self.list_actions_ws = ['10','11','12','14','15','08','29','13']
        self.list_actions_mg = ['01','02','16','17','18','19','20','21','22','23','24','25','26','27','28','39','41','43','45','46','47','99','56','57']
        self.list_actions_ed = ['30','31','32','33','34','35','36','52']
                
        # UD toolbar   
        if self.toolbar_ud_enabled:        
            self.ag_ud = QActionGroup(parent)
            for elem in self.list_actions_ud:
                self.add_action(elem, self.toolbar_ud, self.ag_ud)            
                
        # WS toolbar 
        if self.toolbar_ws_enabled:  
            self.ag_ws = QActionGroup(parent)
            for elem in self.list_actions_ws:
                self.add_action(elem, self.toolbar_ws, self.ag_ws)
                
        # MANAGEMENT toolbar 
        if self.toolbar_mg_enabled:      
            self.ag_mg = QActionGroup(parent)
            for elem in self.list_actions_mg:
                self.add_action(elem, self.toolbar_mg, self.ag_mg)
                    
        # EDIT toolbar 
        if self.toolbar_ed_enabled:      
            self.ag_ed = QActionGroup(parent);
            for elem in self.list_actions_ed:
                self.add_action(elem, self.toolbar_ed, self.ag_ed)                                      
         
        # Disable and hide all toolbars
        self.enable_actions(False)
        self.hide_toolbars() 
                         
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
                self.mg.project_type = wsoftware.lower()
                if wsoftware.lower() == 'ws':
                    self.actions['26'].setVisible(True)
                    self.actions['27'].setVisible(True)
                    self.actions['56'].setVisible(False)
                    self.actions['57'].setVisible(False)
                    self.actions['43'].setVisible(False)
                    self.actions['52'].setVisible(False)
                    if self.toolbar_ws_enabled:
                        self.toolbar_ws.setVisible(True)                            
                elif wsoftware.lower() == 'ud':
                    self.actions['26'].setVisible(False)
                    self.actions['27'].setVisible(False)
                    self.actions['56'].setVisible(True)
                    self.actions['57'].setVisible(True)
                    self.actions['43'].setVisible(True)
                    self.actions['52'].setVisible(True)
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
        self.layer_arc_man_UD = []
        self.layer_arc_man_WS = []

        self.layer_node = None
        self.layer_node_man_UD = []
        self.layer_node_man_WS = []
        self.layer_valve = None

        self.layer_connec = None
        self.layer_connec_man_UD = []
        self.layer_connec_man_WS = []

        self.layer_gully = None
        self.layer_pgully = None

        self.layer_man_gully = None
        self.layer_man_pgully = None
        
        self.layer_version = None
        self.layer_dimensions = None

        #exists_version = False
        #exists_man_junction = False

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            uri_table = self.controller.get_layer_source_table_name(cur_layer)   #@UnusedVariable
            if uri_table is not None:
                
                if self.table_arc in uri_table:
                    self.layer_arc = cur_layer

                if self.table_node == uri_table:
                    self.layer_node = cur_layer
  
                if 'v_edit_man_chamber' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_netgully' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_netinit' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_wjump' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_wwtp' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_outfall' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)
                if 'v_edit_man_storage' == uri_table:
                    self.layer_node_man_UD.append(cur_layer)

                # Node group from WS project
                if 'v_edit_man_source' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_pump' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_meter' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_tank' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_hydrant' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_waterwell' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_manhole' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_reduction' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_junction' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_valve' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_filter' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                    
                if 'v_edit_man_register' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_netwjoin' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_expansiontank' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)
                if 'v_edit_man_flexunion' == uri_table:
                    self.layer_node_man_WS.append(cur_layer)

                if self.table_connec == uri_table:
                    self.layer_connec = cur_layer
                
                if self.table_man_connec == uri_table or self.table_connec == uri_table:
                    self.layer_connec_man_UD.append(cur_layer)
                if 'v_edit_man_greentap' == uri_table :
                    self.layer_connec_man_WS.append(cur_layer)
                if 'v_edit_man_wjoin' == uri_table :
                    self.layer_connec_man_WS.append(cur_layer)
                if 'v_edit_man_fountain' == uri_table :
                    self.layer_connec_man_WS.append(cur_layer)
                if 'v_edit_man_tap' == uri_table :
                    self.layer_connec_man_WS.append(cur_layer)
                    
                if self.table_arc == uri_table:
                    self.layer_arc = cur_layer
                    
                if 'v_edit_man_conduit' == uri_table:
                    self.layer_arc_man_UD.append(cur_layer)
                if 'v_edit_man_siphon' == uri_table:
                    self.layer_arc_man_UD.append(cur_layer)
                if 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_UD.append(cur_layer)
                if 'v_edit_man_waccel' == uri_table:
                    self.layer_arc_man_UD.append(cur_layer)
                    
                if 'v_edit_man_pipe' == uri_table:
                    self.layer_arc_man_WS.append(cur_layer)
                if 'v_edit_man_varc' == uri_table:
                    self.layer_arc_man_WS.append(cur_layer)
                    
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
            
        proj = QgsProject.instance()
        proj.writeEntry("myplugin","myint",10)
        
        # Check if table 'version' and man_junction exists
        exists = False
        for layer in layers:
            layer_DB = self.controller.get_layer_source_table_name(layer) 
            if layer_DB == 'v_edit_man_junction':
                exists = True

        if self.layer_version is None and exists == False:
            pass
        elif self.layer_version is not None and exists == True:
            pass
        else:
            message = "To use this project with Giswater layers man_junction and version must exist. Please check your project !"
            self.controller.show_warning(message)
            return

        # Get schema name from table 'version'
        # Check if really exists
        layer_source = self.controller.get_layer_source(self.layer_version)  
        self.schema_name = layer_source['schema']
        schema_name = self.schema_name.replace('"', '')
        if self.schema_name is None or not self.dao.check_schema(schema_name):
            self.controller.show_warning("Schema not found: "+self.schema_name)            
            return

        # Set schema_name in controller and in config file
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)   
        self.controller.set_schema_name(self.schema_name)   
        
        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)        
        
        # Set SRID from table node
        sql = "SELECT Find_SRID('"+schema_name+"', '"+self.table_node+"', 'the_geom');"
        row = self.dao.get_row(sql)
        if row:
            self.srid = row[0]   
            self.controller.plugin_settings_set_value("srid", self.srid)  

        # Search project type in table 'version'
        self.search_project_type()
        
        self.controller.set_actions(self.actions)

        # Set layer custom UI form and init function   
        if self.load_custom_forms:
            
            #if self.layer_arc is not None:    
            #    self.set_layer_custom_form(self.layer_arc, 'arc') 
                
            if self.layer_arc_man_UD is not None:
                for i in range(len(self.layer_arc_man_UD)):
                    if self.layer_arc_man_UD[i] is not None:    
                        self.set_layer_custom_form(self.layer_arc_man_UD[i], 'man_arc')
                        
            if self.layer_arc_man_WS is not None: 
                for i in range(len(self.layer_arc_man_WS)):
                    if self.layer_arc_man_WS[i] is not None:      
                        self.set_layer_custom_form(self.layer_arc_man_WS[i], 'man_arc')
                  
            #if self.layer_node is not None:       
            #    self.set_layer_custom_form(self.layer_node, 'node') 
                
            if self.layer_node_man_UD is not None: 
                for i in range(len(self.layer_node_man_UD)):
                    if self.layer_node_man_UD[i] is not None:       
                        self.set_layer_custom_form(self.layer_node_man_UD[i], 'man_node')
            
            if self.layer_node_man_WS is not None:  
                for i in range(len(self.layer_node_man_WS)):
                    if self.layer_node_man_WS[i] is not None:   
                        self.set_layer_custom_form(self.layer_node_man_WS[i], 'man_node')
                                                                               
            if self.layer_connec is not None:       
                self.set_layer_custom_form(self.layer_connec, 'connec')
                
            if self.layer_connec_man_UD is not None:
                for i in range(len(self.layer_connec_man_UD)):
                    if self.layer_connec_man_UD[i] is not None:      
                        self.set_layer_custom_form(self.layer_connec_man_UD[i], 'man_connec')
                
            if self.layer_connec_man_WS is not None:   
                for i in range(len(self.layer_connec_man_WS)):
                    if self.layer_connec_man_WS[i] is not None:  
                        self.set_layer_custom_form(self.layer_connec_man_WS[i], 'man_connec')     
                 
            if self.layer_gully is not None:       
                self.set_layer_custom_form(self.layer_gully, 'gully') 
            if self.layer_man_gully is not None:       
                self.set_layer_custom_form(self.layer_man_gully, 'man_gully')   
             
            if self.layer_pgully is not None:       
                self.set_layer_custom_form(self.layer_gully, 'gully')
            if self.layer_man_pgully is not None:       
                self.set_layer_custom_form(self.layer_man_gully, 'man_gully')   
            
            # Set cstom for layer dimensions 
            self.set_layer_custom_form_dimensions(self.layer_dimensions)     

        # Manage current layer selected     
        self.current_layer_changed(self.iface.activeLayer())   
        
        # Set objects for map tools classes
        self.set_map_tool('mg_move_node')
        self.set_map_tool('mg_delete_node')
        self.set_map_tool('mg_mincut')
        self.set_map_tool('mg_flow_trace')
        self.set_map_tool('mg_flow_exit')
        self.set_map_tool('mg_connec_tool')
        self.set_map_tool('mg_extract_raster_value')
        self.set_map_tool('mg_draw_profiles')
        self.set_map_tool('ed_flow_regulator')
        self.set_map_tool('mg_mincut')
        #self.set_map_tool('mg_dimensions')

        # Set SearchPlus object
        self.set_search_plus()
        
        # Delete python compiled files
        self.delete_pyc_files()
                  
                            
    def set_layer_custom_form(self, layer, name):
        ''' Set custom UI form and init python code of selected layer '''
        
        name_ui = self.mg.project_type+'_'+name+'.ui'
        name_init = self.mg.project_type+'_'+name+'_init.py'
        name_function = 'formOpen'
        file_ui = os.path.join(self.plugin_dir, 'ui', name_ui)
        file_init = os.path.join(self.plugin_dir,'init', name_init)                     
        layer.editFormConfig().setUiForm(file_ui) 
        layer.editFormConfig().setInitCodeSource(1)
        layer.editFormConfig().setInitFilePath(file_init)           
        layer.editFormConfig().setInitFunction(name_function) 
        
        
    def set_layer_custom_form_dimensions(self, layer):
 
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
            layer_node.setDisplayField('[% "depth" %]')
        
        layer_connec = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_connec")
        if layer_connec:
            layer_connec = layer_connec[0]
            layer_connec.setDisplayField('[% "depth" %]')

    
    def set_map_tool(self, map_tool_name):
        ''' Set objects for map tools classes '''  

        if map_tool_name in self.map_tools:
            map_tool = self.map_tools[map_tool_name]
            if self.mg.project_type == 'ws':
                map_tool.set_layers(self.layer_arc_man_WS, self.layer_connec_man_WS, self.layer_node_man_WS)
                map_tool.set_controller(self.controller)
            else:
                map_tool.set_layers(self.layer_arc_man_UD, self.layer_connec_man_UD, self.layer_node_man_UD)
                map_tool.set_controller(self.controller)
            if map_tool_name == 'mg_extract_raster_value':
                map_tool.set_config_action(self.actions['99'])                

       
    def set_search_plus(self):
        ''' Set SearchPlus object '''
        
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
        except RuntimeError as e:
            self.controller.show_warning("Error setting searchplus button: "+str(e))
            self.actions['32'].setVisible(False)         
            
                   
    def current_layer_changed(self, layer):
        ''' Manage new layer selected '''

        # Disable all actions (buttons)
        self.enable_actions(False)
        self.custom_enable_actions()     
        
        if layer is None:
            layer = self.iface.activeLayer() 
            if layer is None:
                return            

        # Check is selected layer is 'arc', 'node' or 'connec'
        setting_name = None
        layer_source = self.controller.get_layer_source(layer)  
        uri_table = layer_source['table']
        if uri_table is not None:
            if self.table_arc in uri_table:  
                setting_name = 'buttons_arc'
            elif self.table_node in uri_table:  
                setting_name = 'buttons_node'
            elif self.table_connec in uri_table:  
                setting_name = 'buttons_connec' 
            elif self.table_gully in uri_table:  
                setting_name = 'buttons_gully' 
            elif self.table_pgully in uri_table:  
                setting_name = 'buttons_gully' 
                
            elif self.table_wjoin in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_page in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_greentap in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_fountain in uri_table:  
                setting_name = 'buttons_connec'
            elif self.table_tap in uri_table:  
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
            elif self.table_filter in uri_table:  
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
                
                
            elif self.table_register in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_netwjoin in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_expansiontank in uri_table:  
                setting_name = 'buttons_node' 
            elif self.table_flexunion in uri_table:  
                setting_name = 'buttons_node'
            elif self.table_varc in uri_table:  
                setting_name = 'buttons_arc'  
            elif self.table_siphon in uri_table:  
                setting_name = 'buttons_arc' 
            elif self.table_conduit in uri_table:  
                setting_name = 'buttons_arc'   
            elif self.table_waccel in uri_table:  
                setting_name = 'buttons_arc'     
            elif self.table_pipe in uri_table:  
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
            except AttributeError:
                pass
            except KeyError:
                pass
    
        
    def custom_enable_actions(self):
        ''' Enable selected actions '''
        
        # Enable MG toolbar
        self.enable_actions(True, 1, 27)
        self.enable_action(True, 29)
        self.enable_action(False, 22)            
        
        # Enable ED toolbar
        self.enable_actions(True, 30, 100)
                
                    
    def ws_generic(self, function_name):   
        ''' Water supply generic callback function '''
        
        try:
            self.controller.check_actions(False)
            map_tool = self.map_tools[function_name]
            self.iface.mapCanvas().setMapTool(map_tool)             
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))    
            
            
    def ud_generic(self, function_name):   
        ''' Urban drainage generic callback function '''
        
        try:        
            self.controller.check_actions(False)
            map_tool = self.map_tools[function_name]
            self.iface.mapCanvas().setMapTool(map_tool)     
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))             
            
            
    def mg_generic(self, function_name):   
        ''' Management generic callback function '''
        
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
            
