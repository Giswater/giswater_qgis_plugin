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
from qgis.gui import QgsMessageBar
from qgis.core import QgsExpression, QgsFeatureRequest
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport

import os.path
import sys  
from functools import partial
import subprocess

import utils_giswater
from controller import DaoController
from map_tools.line_map_tool import LineMapTool
from map_tools.point_map_tool import PointMapTool
from map_tools.move_node import MoveNode
from search.search_plus import SearchPlus
from ui.change_node_type import ChangeNodeType
from ui.table_wizard import TableWizard
from ui.config import Config


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
            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)
         
        # Load local settings of the plugin
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())    
        
        # Set controller to handle settings and database
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        self.controller.set_database_connection()     
        self.dao = self.controller.getDao()           
        
        # Declare instance attributes
        self.icon_folder = self.plugin_dir+'/icons/'        
        self.actions = {}
        self.search_plus = None
        self.srid = None
        
        # {function_name, map_tool}
        self.map_tools = {}
        
        # Define signals
        self.set_signals()
               

    def set_signals(self): 
        ''' Define widget and event signals '''
        self.iface.projectRead.connect(self.project_read)                
        self.legend.currentLayerChanged.connect(self.current_layer_changed)       
        
                   
    def tr(self, message):
        if self.controller:
            return self.controller.tr(message)
        
        
    def showInfo(self, text, duration=5):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, duration)            
        
        
    def showWarning(self, text, duration=5):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)            
        
        
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
                # Define buttons to execute custom or generic function
                # Custom function
                if int(index_action) in (17, 20, 21, 24, 26, 27, 28) or int(index_action) >= 30:    
                    callback_function = getattr(self, function_name)  
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
            action = self.create_action(index_action, text_action, toolbar, None, True, function_name, parent)
            if int(index_action) == 13:
                map_tool = LineMapTool(self.iface, self.settings, action, index_action)
            elif int(index_action) == 16:
                map_tool = MoveNode(self.iface, self.settings, action, index_action, self.controller, self.srid)         
            elif int(index_action) in (10, 11, 12, 14, 15, 8, 29):
                map_tool = PointMapTool(self.iface, self.settings, action, index_action, self.controller, self.srid)   
            else:
                pass
            if map_tool:      
                self.map_tools[function_name] = map_tool       
        
        return action         
        
        
    def initGui(self):
        ''' Create the menu entries and toolbar icons inside the QGIS GUI ''' 
        
        if self.controller is None:
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
                         
        # Project initialization
        self.project_read()               


    def unload(self):
        ''' Removes the plugin menu item and icon from QGIS GUI '''
        
        try:
            for action_index, action in self.actions.iteritems():
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
        pos_end_schema = uri.find('.')  
        pos_fi = uri.find('" ')  
        if pos_ini <> -1 and pos_fi <> -1:
            uri_schema = uri[pos_ini+6:pos_end_schema]                             
            uri_table = uri[pos_ini+6:pos_fi+1]                             
             
        return uri_schema, uri_table
    
        
    def search_project_type(self):
        ''' Search in table 'version' project type of current QGIS project '''
        
        self.project_type = None
        features = self.layer_version.getFeatures()
        for feature in features:
            wsoftware = feature['wsoftware']
            if wsoftware.lower() == 'epanet':
                self.project_type = 'ws'     
                if self.toolbar_ws_enabled:                
                    self.toolbar_ws.setVisible(True)                            
            elif wsoftware.lower() == 'epaswmm':
                self.project_type = 'ud'
                if self.toolbar_ud_enabled:                
                    self.toolbar_ud.setVisible(True)                
        
        # Set visible MANAGEMENT and EDIT toolbar  
        if self.toolbar_mg_enabled:         
            self.toolbar_mg.setVisible(True)
        if self.toolbar_ed_enabled: 
            self.toolbar_ed.setVisible(True)

                                
    def project_read(self): 
        ''' Function executed when a user opens a QGIS project (*.qgs) '''
        
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
            (uri_schema, uri_table) = self.get_layer_source(cur_layer)   
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
        if self.layer_arc is not None:       
            file_ui = os.path.join(self.plugin_dir, 'ui', 'ws_arc.ui')
            file_init = os.path.join(self.plugin_dir, 'ws_arc_init.py')       
            self.layer_arc.editFormConfig().setUiForm(file_ui) 
            self.layer_arc.editFormConfig().setInitCodeSource(1)
            self.layer_arc.editFormConfig().setInitFilePath(file_init)           
            self.layer_arc.editFormConfig().setInitFunction('formOpen') 
                                    
        if self.layer_node is not None:       
            file_ui = os.path.join(self.plugin_dir, 'ui', 'ws_node.ui')
            file_init = os.path.join(self.plugin_dir, 'ws_node_init.py')       
            self.layer_node.editFormConfig().setUiForm(file_ui) 
            self.layer_node.editFormConfig().setInitCodeSource(1)
            self.layer_node.editFormConfig().setInitFilePath(file_init)           
            self.layer_node.editFormConfig().setInitFunction('formOpen')                         
                                    
        if self.layer_connec is not None:       
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
        (uri_schema, uri_table) = self.get_layer_source(layer)  
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
        self.enable_action(True, 21)   
        
        # Enable ED toolbar
        self.enable_actions(True, 30, 37)
        self.enable_action(True, 24)   
                
                    
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
            self.showWarning("AttributeError: "+str(e))            
        except KeyError as e:
            self.showWarning("KeyError: "+str(e))    
            
            
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
            self.showWarning("AttributeError: "+str(e))            
        except KeyError as e:
            self.showWarning("KeyError: "+str(e))             
            
            
    def mg_generic(self, function_name):   
        ''' Management generic callback function '''
        try:        
            # Get sender (selected action) and map tool associated 
            sender = self.sender()  
            if function_name in self.map_tools:          
                map_tool = self.map_tools[function_name]
                if sender.isChecked():
                    self.iface.mapCanvas().setMapTool(map_tool)
                    print function_name+" has been checked (mg_generic)"       
                else:
                    self.iface.mapCanvas().unsetMapTool(map_tool)
                    print function_name+" has been unchecked (mg_generic)"  
        except AttributeError as e:
            self.showWarning("AttributeError: "+str(e))            
        except KeyError as e:
            self.showWarning("KeyError: "+str(e))   
            
                                            
                                                   
    ''' Edit bar functions '''  
            
    def ed_search_plus(self):   
        if self.search_plus is not None:
            self.search_plus.dlg.setVisible(True)    
            
                    
    def ed_giswater_jar(self):   
        ''' Button 36. Open giswater.jar with selected .gsw file '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            self.showWarning(self.controller.tr("Java Runtime executable file not found at: "+self.java_exe), 10)
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            self.showWarning(self.controller.tr("Giswater executable file not found at: "+self.giswater_jar), 10)
            return  
                  
        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            self.showInfo(self.controller.tr("GSW file not found at: "+self.gsw_file), 10)
            self.gsw_file = ""    
        
        # Execute process
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "ed_giswater_jar"])
        else:
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, "", "ed_giswater_jar"])
        
        # Show information message    
        self.showInfo(self.controller.tr("Executing... "+aux))
                              
                              
                                  
    ''' Management bar functions '''   
        
    def mg_go2epa_express(self):
        ''' Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            self.showWarning(self.controller.tr("Java Runtime executable file not found at: "+self.java_exe), 10)
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            self.showWarning(self.controller.tr("Giswater executable file not found at: "+self.giswater_jar), 10)
            return  

        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            self.showInfo(self.controller.tr("GSW file not found at: "+self.gsw_file), 10)
            self.gsw_file = ""    
        
        # Execute process
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "mg_go2epa_express"])
        else:
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, "", "mg_go2epa_express"])
        
        # Show information message    
        self.showInfo(self.controller.tr("Executing... "+aux))        
                               
        
    def mg_delete_node(self):
        ''' Button 17. User select one node. 
        Execute SQL function 'gw_fct_delete_node' 
        Show warning (if any) '''

        # Get selected features (from layer 'node')          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!"))      
        
        features = layer.selectedFeatures()
        feature = features[0]
        node_id = feature.attribute('node_id')   
        
        # Execute SQL function and show result to the user
        function_name = "gw_fct_delete_node"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(node_id)+"');"  
        self.controller.get_row(sql)
                    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()             
        
        
    def mg_connec_tool(self):
        ''' Button 20. User select connections from layer 'connec' 
        and executes function: 'gw_fct_connect_to_network' '''      

        # Get selected features (from layer 'connec')
        aux = "{"         
        layer = self.iface.activeLayer()  
        if layer.selectedFeatureCount() == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        features = layer.selectedFeatures()
        for feature in features:
            connec_id = feature.attribute('connec_id') 
            aux+= str(connec_id)+", "
        connec_array = aux[:-2]+"}"
        
        # Execute function
        sql = "SELECT "+self.schema_name+".gw_fct_connect_to_network('"+connec_array+"');"  
        self.dao.execute_sql(sql) 
        
        # Refresh map canvas
        self.iface.mapCanvas().refresh() 
    
        
    def mg_table_wizard(self):
        ''' Button 21. WS/UD table wizard ''' 
        
        if self.project_type == 'ws':
            table_list = ['inp_controls', 'inp_curve', 'inp_demand', 'inp_pattern', 'inp_rules', 'cat_node', 'cat_arc']
        elif self.project_type == 'ud':   
            table_list = {'inp_controls', 'inp_curve', 'inp_transects', 'inp_timeseries', 'inp_dwf', 'inp_hydrograph', 'inp_inflows', 'inp_lid_control', 'cat_node', 'cat_arc'}
        else:
            return
        
        # Get CSV file path from settings file          
        self.file_path = self.settings.value('files/csv_file')
        if self.file_path is None:             
            self.file_path = self.plugin_dir+"/csv/test.csv"        
        
        # Open dialog to select CSV file and table to import contents to
        self.dlg = TableWizard()
        self.dlg.txt_file_path.setText(self.file_path)   
        #utils_giswater.fillComboBox(self.dlg.cbo_table, table_list) 
        table_list.sort()  
        for row in table_list:
            self.dlg.cbo_table.addItem(row)                
 
        # Set signals
        self.dlg.btn_select_file.clicked.connect(self.select_file)
        self.dlg.btn_import_csv.clicked.connect(self.import_csv)

        self.dlg.exec_()            

        
    def select_file(self):

        # Set default value if necessary
        if self.file_path == '': 
            self.file_path = self.plugin_dir
            
        # Get directory of that file
        folder_path = os.path.dirname(self.file_path)
        os.chdir(folder_path)
        msg = "Select CSV file"
        self.file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "", '*.csv')
        self.dlg.txt_file_path.setText(self.file_path)     

        # Save CSV file path into settings
        self.settings.setValue('files/csv_file', self.file_path)       
        
        
    def import_csv(self):

        # Get selected table, delimiter, and header
        table_name = utils_giswater.getWidgetText(self.dlg.cbo_table)  
        delimiter = utils_giswater.getWidgetText(self.dlg.cbo_delimiter)  
        header_status = self.dlg.chk_header.checkState()             
        
        # Get CSV file. Check if file exists
        self.file_path = self.dlg.txt_file_path.toPlainText()
        if not os.path.exists(self.file_path):
            msg = "Selected file not found: "+self.file_path
            self.showWarning(msg)
            return False      
              
        # Open CSV file for read and copy into database
        rf = open(self.file_path)
        sql = "COPY "+self.schema_name+"."+table_name+" FROM STDIN WITH CSV"
        if (header_status == Qt.Checked):
            sql+= " HEADER"
        sql+= " DELIMITER AS '"+delimiter+"'"
        status = self.dao.copy_expert(sql, rf)
        if status:
            self.dao.rollback()
            msg = "Cannot import CSV into table "+table_name+". Reason:\n"+str(status).decode('utf-8')
            QMessageBox.warning(None, "Import CSV", self.controller.tr(msg))
            return False
        else:
            self.dao.commit()
            msg = "Selected CSV has been imported successfully"
            self.showInfo(self.controller.tr(msg))
        
            
    def mg_flow_exit(self):
        ''' Button 27. Valve analytics ''' 
                
        # Execute SQL function
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.dao.get_row(sql) 
        self.dao.commit()   

        # Manage SQL execution result
        if result is None:
            self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
            return   
        elif result[0] == 0:
            self.showInfo(self.controller.tr("Process completed"), 50)    
        else:
            self.showWarning(self.controller.tr("Undefined error"))    
            return              
        
            
    def mg_flow_trace(self):
        ''' Button 26. User select one node or arc.
        SQL function fills 3 temporary tables with id's: node_id, arc_id and valve_id
        Returns and integer: error code
        Get these id's and select them in its corresponding layers '''
        
        # Get selected features and layer type: 'arc' or 'node'   
        elem_type = self.current_layer.name().lower()
        count = self.current_layer.selectedFeatureCount()     
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!"))      
         
        features = self.current_layer.selectedFeatures()
        feature = features[0]
        elem_id = feature.attribute(elem_type+'_id')   
        
        # Execute SQL function
        function_name = "gw_fct_mincut"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+elem_type+"');"  
        result = self.dao.get_row(sql) 
        self.dao.commit()        
        
        # Manage SQL execution result
        if result is None:
            self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
            return   
        elif result[0] == 0:
            # Get 'arc' and 'node' list and select them 
            self.mg_flow_trace_select_features(self.layer_arc, 'arc')                         
            self.mg_flow_trace_select_features(self.layer_node, 'node')   
        elif result[0] == 1:
            self.showWarning(self.controller.tr("Parametrize error type 1"))   
            return
        else:
            self.showWarning(self.controller.tr("Undefined error"))    
            return        
    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()   
   
   
    def mg_flow_trace_select_features(self, layer, elem_type):
        
        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_"+elem_type+" ORDER BY "+elem_type+"_id"  
        rows = self.dao.get_rows(sql)
        self.dao.commit()
        
        # Build an expression to select them
        aux = "\""+elem_type+"_id\" IN ("
        for elem in rows:
            aux+= elem[0]+", "
        aux = aux[:-2]+")"
        
        # Get a featureIterator from this expression:
        expr = QgsExpression(aux)
        if expr.hasParserError():
            self.showWarning("Expression Error: "+str(expr.parserErrorString()))
            return        
        it = layer.getFeatures(QgsFeatureRequest(expr))
        
        # Build a list of feature id's from the previous result
        id_list = [i.id() for i in it]
        
        # Select features with these id's 
        layer.setSelectedFeatures(id_list)       
        
        
    def mg_change_elem_type(self):                
        ''' Button 28: User select one node. A form is opened showing current node_type.type 
        Combo to select new node_type.type
        Combo to select new node_type.id
        Combo to select new cat_node.id
        TODO: Trigger 'gw_trg_edit_node' has to be disabled temporarily 
        '''
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!"))   
                    
        # Get selected features (nodes)           
        features = layer.selectedFeatures()
        feature = features[0]
        # Get node_id form current node
        self.node_id = feature.attribute('node_id')

        # Get node_type from current node
        node_type = feature.attribute('node_type')
        
        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()
        self.dlg.node_node_type.setText(node_type)
        self.dlg.node_type_type_new.currentIndexChanged.connect(self.get_value)         
        self.dlg.node_node_type_new.currentIndexChanged.connect(self.get_value_2)
        self.dlg.node_nodecat_id.currentIndexChanged.connect(self.get_value_3)           
        self.dlg.btn_accept.pressed.connect(self.accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        utils_giswater.setDialog(self.dlg)
        utils_giswater.fillComboBox("node_type_type_new", rows) 
    
        # Open the dialog
        self.dlg.exec_()    
     
     
    def get_value(self, index):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 
        
        # Get selected value from 1st combobox
        self.value_combo1 = utils_giswater.getWidgetText("node_type_type_new")   
        
        # When value is selected, enabled 2nd combo box
        if self.value_combo1 != 'null':
            self.dlg.node_node_type_new.setEnabled(True)  
            # Fill 2nd combo_box-custom node type
            sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".node_type WHERE type='"+self.value_combo1+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_node_type_new", rows)
       
       
    def get_value_2(self, index):    
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 

        if index == -1:
            return
        
        # Get selected value from 2nd combobox
        self.value_combo2 = utils_giswater.getWidgetText("node_node_type_new")         
        
        # When value is selected, enabled 3rd combo box
        if self.value_combo2 != 'null':
            # Get selected value from 2nd combobox
            self.dlg.node_nodecat_id.setEnabled(True)
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql+= " FROM "+self.schema_name+".cat_node"
            sql+= " WHERE nodetype_id='"+self.value_combo2+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_nodecat_id", rows)     
    
    
    def get_value_3(self, index):
        self.value_combo3 = utils_giswater.getWidgetText("node_nodecat_id")      
        
        
    def accept(self):
        ''' Update current type of node and save changes in database '''

        # Update node_type in the database
        sql = "UPDATE "+self.schema_name+".node"
        sql+= " SET node_type ='"+self.value_combo2+"'"
        if self.value_combo3 != 'null':
            sql+= ", nodecat_id='"+self.value_combo3+"'"
        sql+= " WHERE node_id ='"+self.node_id+"'"
        self.dao.execute_sql(sql)
        
        # Show message to the user
        self.showInfo(self.controller.tr("Node type has been update!")) 
        
        # Close dialog
        self.close_dialog()
       
                  
    def close_dialog(self): 
        ''' Close dialog '''
        self.dlg.close()       
            
            
    def mg_config(self):                
        ''' Button 99 - Open a dialog showing data from table "config" 
        User can changge its values '''
        
        # Get data from database "config"
        # Get entire row from database 
        sql = "SELECT * FROM "+self.schema_name+".config"
        self.row = self.dao.get_row(sql)
        
        # Create the dialog and signals
        self.dlg = Config()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ok_button)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        self.dlg.id.textChanged.connect(self.get_new_value)
        self.dlg.node_proximity.valueChanged.connect(self.get_new_value)
        self.dlg.arc_searchnodes.valueChanged.connect(self.get_new_value) 
        self.dlg.node2arc.valueChanged.connect(self.get_new_value)
        self.dlg.connec_proximity.valueChanged.connect(self.get_new_value)
        self.dlg.arc_toporepair.valueChanged.connect(self.get_new_value)
        self.dlg.vnode_update_tolerance.valueChanged.connect(self.get_new_value) 
        self.dlg.nodeinsert_catalog_vdefault.currentIndexChanged.connect(self.get_new_value) 
        self.dlg.orphannode.stateChanged.connect(self.get_new_value)
        
        # Set values of current data 
        utils_giswater.setWidgetText("id", self.row["id"])
        self.dlg.node_proximity.setValue(self.row["node_proximity"])
        self.dlg.arc_searchnodes.setValue(self.row["arc_searchnodes"])
        self.dlg.node2arc.setValue(self.row["node2arc"])
        self.dlg.connec_proximity.setValue(self.row["connec_proximity"])
        self.dlg.arc_toporepair.setValue(self.row["arc_toporepair"])
        self.dlg.vnode_update_tolerance.setValue(self.row["vnode_update_tolerance"])

        # Set current value to Checkbox  
        self.dlg.orphannode.setChecked(bool(self.row["orphannode_delete"]))
        self.dlg.arcendpoint.setChecked(bool(self.row["nodeinsert_arcendpoint"]))
        self.dlg.nodetypechanged.setChecked(bool(self.row["nodetype_change_enabled"]))
       
        # Fill ComboBox
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodeinsert_catalog_vdefault", rows) 

        # Open the dialog
        self.dlg.exec_()    
    
  
    def get_new_value(self, index):
        ''' Get new value '''
        
        self.new_value_id = utils_giswater.getWidgetText("id")
        self.new_value_prox = utils_giswater.getWidgetText("node_proximity")
        self.new_value_arc = utils_giswater.getWidgetText("arc_searchnodes")
        self.new_value_node = utils_giswater.getWidgetText("node2arc")
        self.new_value_con = utils_giswater.getWidgetText("connec_proximity")
        self.new_value_arc_top = utils_giswater.getWidgetText("arc_toporepair")
        self.new_value_arc_tolerance = utils_giswater.getWidgetText("vnode_update_tolerance")
        
        # Get new value form combobox
        self.new_value_combobox = utils_giswater.getWidgetText("nodeinsert_catalog_vdefault")
        
        # Get new value from CheckBox
        self.new_value_orpha = self.dlg.orphannode.isChecked()
        self.new_value_nodetypechanged = self.dlg.nodetypechanged.isChecked()
        self.new_value_arcendpoint = self.dlg.arcendpoint.isChecked()

    
    def ok_button(self):
        ''' Update curren value to the database
        On pressed button OK execute new value to database "config" '''
        
        # restore int value from row to new variable like str
        # Set new value to database "config"
        sql = "UPDATE "+self.schema_name+".config" 
        sql+= " SET id = '"+self.new_value_id+"',"
        sql+= " node_proximity = '"+self.new_value_prox+"',"
        sql+= " arc_searchnodes = '"+self.new_value_arc+"',"
        sql+= " node2arc = '"+self.new_value_node+"',"
        sql+= " connec_proximity = '"+self.new_value_con+"',"
        sql+= " arc_toporepair = '"+self.new_value_arc_top+"',"
        sql+= " nodeinsert_catalog_vdefault = '"+self.new_value_combobox+"',"
        sql+= " orphannode_delete = '"+str(self.new_value_orpha)+"',"
        sql+= " nodetype_change_enabled = '"+str(self.new_value_nodetypechanged)+"',"
        sql+= " nodeinsert_arcendpoint = '"+str(self.new_value_arcendpoint)+"'"
        self.dao.execute_sql(sql)
    
        # Show message to user
        self.showInfo(self.controller.tr("Values has been updated"))
        self.close_dialog() 
        
                    