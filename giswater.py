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
from qgis.gui import (QgsMessageBar)
from qgis.core import QgsExpression, QgsFeatureRequest
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport

import os.path
import sys  
from functools import partial

from line_map_tool import LineMapTool
from point_map_tool import PointMapTool
from controller import DaoController
from map_tools.move_node import MoveNode
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
            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)
         
        # Load local settings of the plugin
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())    
        
        # Set controller to handle settings and database
        self.controller = DaoController(self.settings, self.plugin_name)
        self.controller.set_database_connection()     
        self.dao = self.controller.getDao()     
        self.schema_name = self.controller.getSchemaName()      
        
        # Declare instance attributes
        self.icon_folder = self.plugin_dir+'/icons/'        
        self.actions = {}
        self.search_plus = None
        
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
        
        
    def showInfo(self, text, duration = 5):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, duration)            
        
        
    def showWarning(self, text, duration = 5):
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
                if int(index_action) in (17, 20, 26, 32):    
                    callback_function = getattr(self, function_name)  
                    action.triggered.connect(callback_function)
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
                map_tool = LineMapTool(self.iface, self.settings, action, index_action, self.controller)
            elif int(index_action) == 16:
                map_tool = MoveNode(self.iface, self.settings, action, index_action, self.controller)         
            elif int(index_action) in (10, 11, 12, 14, 15, 8, 29):
                map_tool = PointMapTool(self.iface, self.settings, action, index_action, self.controller)   
            else:
                pass
            if map_tool:      
                self.map_tools[function_name] = map_tool       
        
        return action         
        
        
    def initGui(self):
        ''' Create the menu entries and toolbar icons inside the QGIS GUI ''' 
        
        parent = self.iface.mainWindow()
        if self.controller is None:
            return
        
        # Create plugin main menu
        self.menu_name = self.tr('menu_name')    
        
        # Get table or view related with 'arc' and 'node'
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')        
                
        # Create UD, WS, MANAGEMENT and EDIT toolbars or not?
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
                    
        # EDIT toolbar 
        if self.toolbar_ed_enabled:      
            self.ag_ed = QActionGroup(parent);
            for i in range(30,36):
                self.add_action(str(i), self.toolbar_ed, self.ag_ed)
                
        # Project initialization
        self.project_read()               


    def unload(self):
        ''' Removes the plugin menu item and icon from QGIS GUI '''
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
            
    
    
    ''' Slots '''
            
    def disable_actions(self):
        ''' Utility to disable all actions '''
        for i in range(1,30):
            key = str(i).zfill(2)
            if key in self.actions:
                action = self.actions[key]
                action.setEnabled(False)         

                                
    def project_read(self): 
        ''' Function executed when a user opens a QGIS project (*.qgs) '''
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return    
        
        # Initialize variables
        self.layer_arc = None
        self.layer_node = None
        table_arc = '"'+self.schema_name+'"."'+self.table_arc+'"'
        table_node = '"'+self.schema_name+'"."'+self.table_node+'"'
        
        # Iterate over all layers to get 'arc' and 'node' layer '''      
        for cur_layer in layers:     
            uri = cur_layer.dataProvider().dataSourceUri().lower()   
            pos_ini = uri.find('table=')
            pos_fi = uri.find('" ')  
            uri_table = uri   
            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]                           
                if uri_table == table_arc:  
                    self.layer_arc = cur_layer
                if uri_table == table_node:  
                    self.layer_node = cur_layer
        
        # Disable toolbar actions and manage current layer selected
        self.disable_actions()       
        self.current_layer_changed(self.iface.activeLayer())   
        
        # Create SearchPlus object
        try:
            if self.search_plus is None:
                self.search_plus = SearchPlus(self.iface)
                self.search_plus.removeMemoryLayers()   
            status = self.search_plus.populateGui()
            self.actions['32'].setEnabled(status) 
            self.actions['32'].setCheckable(False) 
            if not status:
                self.search_plus.dlg.setVisible(False)                     
        except:
            pass       
                               
                               
    def current_layer_changed(self, layer):
        ''' Manage new layer selected '''

        self.disable_actions()
        if layer is None:
            layer = self.iface.activeLayer() 
        self.current_layer = layer
        try:
            list_index_action = self.settings.value('layers/'+self.current_layer.name(), None)
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
        except AttributeError:
            print "ud_generic: AttributeError"                
            
            
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
            #self.iface.mainWindow().addDockWidget(Qt.TopDockWidgetArea, self.search_plus.dlg)
            self.search_plus.dlg.setVisible(True)            
             
                                  
    ''' Management bar functions '''                                
        
    def mg_delete_node(self):
        ''' Button 17. User select one node. 
        Execute SQL function 'gw_fct_delete_node' 
        Show warning (if any) '''

        # Get selected features (from layer 'connec')          
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
        
        # Execute SQL function
        function_name = "gw_fct_delete_node"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(node_id)+"');"  
        result = self.dao.get_row(sql) 
        self.dao.commit()
                    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()    
        
        # Manage SQL execution result
        if result is None:
            self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
        elif result[0] == 0:
            self.showInfo(self.controller.tr("Node deleted successfully"))    
        elif result[0] == 1:
            self.showWarning(self.controller.tr("Nonexistent node id: ")+node_id)   
        elif result[0] == 2:
            self.showWarning(self.controller.tr("Pipes has different types"))   
        elif result[0] == 3:
            self.showWarning(self.controller.tr("Node has not 2 arcs"))   
        else:
            self.showWarning(self.controller.tr("Undefined error"))               
        
        
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
    
        
    def change_elem_type(self):
        ''' TODO: 28. User select one node. A form is opened showing current node_type.type 
        Combo to select new node_type.type
        Combo to select catalog id
        Trigger 'gw_trg_edit_node' has to be disabled temporarily '''
        pass
        
    def table_wizard(self):
        ''' TODO: 21. ''' 
        pass
        
        
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
            # Drop temporary tables 
            sql = "DROP TABLE IF EXISTS temp_mincut_node CASCADE;"
            sql+= "DROP TABLE IF EXISTS temp_mincut_arc CASCADE;"
            sql+= "DROP TABLE IF EXISTS temp_mincut_valve CASCADE;" 
            self.dao.execute_sql(sql)  
        else:
            self.showWarning(self.controller.tr("Undefined error"))    
            return        
    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()   
   
   
    def mg_flow_trace_select_features(self, layer, elem_type):
        
        sql = "SELECT * FROM "+self.schema_name+".temp_mincut_"+elem_type+" ORDER BY "+elem_type+"_id"  
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
            
            