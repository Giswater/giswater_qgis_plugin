# -*- coding: utf-8 -*-
"""
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from PyQt4.QtCore import QCoreApplication, QObject, QSettings, QTranslator
from PyQt4.QtGui import QAction, QActionGroup, QIcon   

import os.path
import sys  
from functools import partial

from actions.ed import Ed
from actions.mg import Mg
from controller import DaoController
from map_tools.line_map_tool import LineMapTool
from map_tools.point_map_tool import PointMapTool
from map_tools.move_node_map_tool import MoveNodeMapTool
from map_tools.mincut_map_tool import MincutMapTool
from map_tools.delete_node_map_tool import DeleteNodeMapTool
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
        self.dao = None
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        connection_status = self.controller.set_database_connection()
        if not connection_status:
            msg = self.controller.last_error  
            self.controller.show_message(msg, 1, 100) 
            return 
        else:
            self.dao = self.controller.getDao()           
        
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
                if int(index_action) in (19, 20, 21, 24, 25, 27, 28, 99):
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
                print index_action+". Callback function not found: "+function_name
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
            if int(index_action) == 13:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = LineMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 16:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = MoveNodeMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)
            elif int(index_action) in (10, 11, 12, 14, 15, 8, 29):
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = PointMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)   
            elif int(index_action) == 17:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = DeleteNodeMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 26:
                action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
                map_tool = MincutMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 27:
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
        self.table_version = self.settings.value('db/table_version', 'version')     
        
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
            self.add_action('03', self.toolbar_ud, self.ag_ud)   
                
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
        except AttributeError, e:
            print "unload_AttributeError: "+str(e)
        except KeyError, e:
            print "unload_KeyError: "+str(e)
    
    
    ''' Slots '''             

    def enable_actions(self, enable=True, start=1, stop=37):
        ''' Utility to enable all actions '''
        for i in range(start, stop):
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
        except AttributeError, e:
            print "unload_AttributeError: "+str(e)
        except KeyError, e:
            print "unload_KeyError: "+str(e)                      
                               
    
    def get_layer_source(self, layer):
        ''' Get table or view name of selected layer '''
         
        uri_schema = None
        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()   
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')  
        pos_fi = uri.find('" ')  
        if pos_ini <> -1 and pos_fi <> -1:
            uri_schema = uri[pos_ini+6:pos_end_schema]                             
            uri_table = uri[pos_ini+6:pos_fi+1]                             
             
        return uri_schema, uri_table
    
        
    def search_project_type(self):
        ''' Search in table 'version' project type of current QGIS project '''
        
        try:
            self.mg.project_type = None
            features = self.layer_version.getFeatures()
            for feature in features:
                wsoftware = feature['wsoftware']
                if wsoftware.lower() == 'epanet':
                    self.mg.project_type = 'ws'     
                    if self.toolbar_ws_enabled:                
                        self.toolbar_ws.setVisible(True)                            
                elif wsoftware.lower() == 'epaswmm':
                    self.mg.project_type = 'ud'
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
        self.layer_node = None
        self.layer_connec = None
        self.layer_version = None
        
        # Iterate over all layers to get the ones specified in 'db' config section 
        for cur_layer in layers:     
            (uri_schema, uri_table) = self.get_layer_source(cur_layer)   #@UnusedVariable
            if uri_table is not None:
                if self.table_arc in uri_table:  
                    self.layer_arc = cur_layer
                if self.table_node in uri_table:  
                    self.layer_node = cur_layer
                if self.table_connec in uri_table:  
                    self.layer_connec = cur_layer
                if self.table_version in uri_table:  
                    self.layer_version = cur_layer     
        
        # Check if table 'version' exists
        if self.layer_version is None:
            return
                 
        # Get schema name from table 'version'
        # Check if really exists
        (self.schema_name, uri_table) = self.get_layer_source(self.layer_version)  
        schema_name = self.schema_name.replace('"', '')
        if self.schema_name is None or not self.dao.check_schema(schema_name):
            print "Schema not found: "+self.schema_name
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
            file_ui = os.path.join(self.plugin_dir, 'ui', 'ws_arc.ui')
            file_init = os.path.join(self.plugin_dir, 'ws_arc_init.py')       
            self.layer_arc.editFormConfig().setUiForm(file_ui) 
            self.layer_arc.editFormConfig().setInitCodeSource(1)
            self.layer_arc.editFormConfig().setInitFilePath(file_init)           
            self.layer_arc.editFormConfig().setInitFunction('formOpen') 
                                    
        if self.layer_node is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', 'ws_node.ui')
            file_init = os.path.join(self.plugin_dir, 'ws_node_init.py')       
            self.layer_node.editFormConfig().setUiForm(file_ui) 
            self.layer_node.editFormConfig().setInitCodeSource(1)
            self.layer_node.editFormConfig().setInitFilePath(file_init)           
            self.layer_node.editFormConfig().setInitFunction('formOpen')                         
                                    
        if self.layer_connec is not None and self.load_custom_forms:       
            file_ui = os.path.join(self.plugin_dir, 'ui', 'ws_connec.ui')
            file_init = os.path.join(self.plugin_dir, 'ws_connec_init.py')       
            self.layer_connec.editFormConfig().setUiForm(file_ui) 
            self.layer_connec.editFormConfig().setInitCodeSource(1)
            self.layer_connec.editFormConfig().setInitFilePath(file_init)           
            self.layer_connec.editFormConfig().setInitFunction('formOpen')                         
                    
        # Manage current layer selected     
        self.current_layer_changed(self.iface.activeLayer())   
        
        # Set layer 'Arc' for map tool 'Move node'
        map_tool = self.map_tools['mg_move_node']
        map_tool.set_layer_arc(self.layer_arc)
        map_tool.set_layer_node(self.layer_node)
        map_tool = self.map_tools['mg_flow_trace']
        map_tool.set_layer_arc(self.layer_arc)
        map_tool.set_layer_node(self.layer_node)
        map_tool.set_schema_name(self.schema_name)
        map_tool.set_dao(self.dao)
        map_tool = self.map_tools['mg_delete_node']
        map_tool.set_schema_name(self.schema_name)
        map_tool.set_controller(self.controller)

        # Create SearchPlus object
        try:
            if self.search_plus is None:
                self.search_plus = SearchPlus(self.iface, self.srid)
                self.search_plus.removeMemoryLayers()   
            status = self.search_plus.populateGui()
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False) 
            if not status:
                self.search_plus.dlg.setVisible(False)  
            self.ed.search_plus = self.search_plus                   
        except:
            pass   
        
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
        (uri_schema, uri_table) = self.get_layer_source(layer)  #@UnusedVariable  
        if uri_table is not None:
            if self.table_arc in uri_table:  
                setting_name = 'buttons_arc'
            elif self.table_node in uri_table:  
                setting_name = 'buttons_node'
            elif self.table_connec in uri_table:  
                setting_name = 'buttons_connec'                
        
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
        
        # MG toolbar
        self.enable_action(True, 16)
        self.enable_action(True, 17)
        self.enable_action(True, 19)   
        self.enable_action(True, 21)   
        self.enable_action(True, 24)   
        self.enable_action(True, 25)
        self.enable_action(True, 26)
        self.enable_action(True, 27)
        
        # Enable ED toolbar
        self.enable_actions(True, 30, 37)
                
                    
    def ws_generic(self, function_name):   
        ''' Water supply generic callback function '''
        try:
            # Get sender (selected action) and map tool associated 
            sender = self.sender()                            
            map_tool = self.map_tools[function_name]
            if sender.isChecked():
                self.iface.mapCanvas().setMapTool(map_tool)
                print function_name+" has been checked (ws_generic)"       
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
                print function_name+" has been checked"       
            else:
                self.iface.mapCanvas().unsetMapTool(map_tool)
        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))             
            
            
    def mg_generic(self, function_name):   
        ''' Management generic callback function '''
        try:        
            # Get sender (selected action) and map tool associated 
            sender = self.sender()  
            if function_name in self.map_tools:          
                map_tool = self.map_tools[function_name]

                if not (map_tool == self.iface.mapCanvas().mapTool()):
                    self.iface.mapCanvas().setMapTool(map_tool)
                    print function_name + " has been checked (mg_generic)"
                else:
                    self.iface.mapCanvas().unsetMapTool(map_tool)
                    print function_name + " has been unchecked (mg_generic)"

        except AttributeError as e:
            self.controller.show_warning("AttributeError: "+str(e))            
        except KeyError as e:
            self.controller.show_warning("KeyError: "+str(e))              

