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
import subprocess
from functools import partial

import utils_giswater
from actions.mg import Mg
from controller import DaoController
from map_tools.line_map_tool import LineMapTool
from map_tools.point_map_tool import PointMapTool
from map_tools.move_node import MoveNode
from search.search_plus import SearchPlus
from ui.add_element import Add_element
from ui.add_file import Add_file


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
        self.mg = Mg(self.iface, self.settings, self.controller, self.plugin_dir)
        
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
                # Management toolbar actions
                if int(index_action) in (17, 20, 21, 24, 26, 27, 28, 99):    
                    callback_function = getattr(self.mg, function_name)  
                    action.triggered.connect(callback_function)
                # Edit toolbar actions
                elif int(index_action) == 32:    
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
        ''' Button 32. Open dialog to select street and portal number ''' 
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
                                  
        
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        if dlg is None:
            dlg = self.dlg   
        dlg.close()    
            
            

        
        
        
    ''' Edit bar functions '''
  
    def ed_add_element(self):
        ''' Button 33. Add element '''
          
        # Create the dialog and signals
        self.dlg = Add_element()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()   
        
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!")) 
        
        # Fill  comboBox elementcat_id
        sql = "SELECT DISTINCT(elementcat_id) FROM "+self.schema_name+".element ORDER BY elementcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("elementcat_id", rows) 
        
        # Fill  comboBox state
        sql = "SELECT DISTINCT(state) FROM "+self.schema_name+".element ORDER BY state"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("state", rows)
        
        # Fill comboBox location_type 
        sql = "SELECT DISTINCT(location_type) FROM "+self.schema_name+".element ORDER BY location_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("location_type", rows)
        
        # Fill comboBox workcat_id 
        sql = "SELECT DISTINCT(workcat_id) FROM "+self.schema_name+".element ORDER BY workcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("workcat_id", rows)
        
        # Fill comboBox buildercat_id
        sql = "SELECT DISTINCT(buildercat_id) FROM "+self.schema_name+".element ORDER BY buildercat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("buildercat_id", rows)
        
        # Fill comboBox ownercat_id 
        sql = "SELECT DISTINCT(ownercat_id) FROM "+self.schema_name+".element ORDER BY ownercat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ownercat_id", rows)
        
        # Fill comboBox verified
        sql = "SELECT DISTINCT(verified) FROM "+self.schema_name+".element ORDER BY verified"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("verified", rows)
        
        # Open the dialog
        self.dlg.exec_()    
        
        
    def ed_add_element_accept(self):
           
        # Get values from comboboxes-elementcat_id
        self.elementcat_id = utils_giswater.getWidgetText("elementcat_id")  
        
        # Get state from combobox
        self.state = utils_giswater.getWidgetText("state")   
               
        # Get element_id entered by user
        self.element_id = utils_giswater.getWidgetText("element_id")
        self.annotation = utils_giswater.getWidgetText("annotation")
        self.observ = utils_giswater.getWidgetText("observ")
        self.comment = utils_giswater.getWidgetText("comment")
        self.location_type = utils_giswater.getWidgetText("location_type")
        self.workcat_id = utils_giswater.getWidgetText("workcat_id")
        self.buildercat_id = utils_giswater.getWidgetText("buildercat_id")
        #self.builtdate = utils_giswater.getWidgetText("builtdate")
        self.ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        #self.enddate = utils_giswater.getWidgetText("enddate")
        self.rotation = utils_giswater.getWidgetText("rotation")
        self.link = utils_giswater.getWidgetText("link")
        self.verified = utils_giswater.getWidgetText("verified")
     
        # Execute data to database Elements 
        sql = "INSERT INTO "+self.schema_name+".element (element_id, elementcat_id, state, location_type"
        sql+= ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified) "
        sql+= " VALUES ('"+self.element_id+"', '"+self.elementcat_id+"', '"+self.state+"', '"+self.location_type+"', '"
        sql+= self.workcat_id+"', '"+self.buildercat_id+"', '"+self.ownercat_id+"', '"+self.rotation+"', '"+self.comment+"', '"
        sql+= self.annotation+"','"+self.observ+"','"+self.link+"','"+self.verified+"')"
        self.dao.execute_sql(sql) 
        
        # Get layers
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return
         
        # Initialize variables                    
        self.layer_arc = None
        table_arc = '"'+self.schema_name+'"."'+self.table_arc+'"'
        table_node = '"'+self.schema_name+'"."'+self.table_node+'"'
        table_connec = '"'+self.schema_name+'"."'+self.table_connec+'"'
   
        # Iterate over all layers to get the ones set in config file        
        for cur_layer in layers:     
            uri = cur_layer.dataProvider().dataSourceUri().lower()   
            pos_ini = uri.find('table=')
            pos_fi = uri.find('" ')  
            uri_table = uri 

            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]    
                
                # Table 'arc'                       
                if table_arc == uri_table:  
                    self.layer_arc = cur_layer
                    self.count_arc = self.layer_arc.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_arcs = self.layer_arc.selectedFeatures()
                    i = 0
                    while (i < self.count_arc):
                     
                        feature = features_arcs[i]
                        # Get arc_id from current arc
                        self.arc_id = feature.attribute('arc_id')
                        print(self.arc_id)
                        # Convert i to str ,for exporting index to database
                        #j=str(i)
                        # Execute data of all arcs to database Elements 
                        #sql = "INSERT INTO "+self.schema_name+".element (element_id,elementcat_id,state,location_type,workcat_id,buildercat_id,ownercat_id,rotation,comment,annotation,observ,link) "
                        #sql+= " VALUES ('"+self.element_id+"''"+j+"','"+self.elementcat_id+"','"+self.state+"','"+self.location_type+"','"+self.workcat_id+"','"+self.buildercat_id+"','"+self.ownercat_id+"','"+self.rotation+"','"+self.comment+"','"+self.annotation+"','"+self.observ+"','"+self.link+"')"
                        #print("for data base element")
                        #print (sql)
                        #self.dao.execute_sql(sql)                        
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        ''' data base for arc element_x_arc doesn't exist 
                        sql = "INSERT INTO "+self.schema_name+".element_x_arc (arc_id,element_id) "
                        sql+= " VALUES ('"+self.arc_id+"','"+self.element_id+"')"
                        '''
                        i=i+1
                      
                # Table 'node'   
                if table_node == uri_table:  
                    self.layer_node = cur_layer
                    self.count_node = self.layer_node.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_nodes = self.layer_node.selectedFeatures()
                    i = 0
                    while (i < self.count_node):
                          
                        # Get node_id from current node
                        feature_node = features_nodes[i]
                        self.node_id = feature_node.attribute('node_id')

                        # Execute id(automaticaly),element_id and node_id to element_x_node
                        sql = "INSERT INTO "+self.schema_name+".element_x_node (node_id, element_id) "
                        sql+= " VALUES ('"+self.node_id+"', '"+self.element_id+"')"
                        self.dao.execute_sql(sql)   
                        i+=1
                 
                # Table 'connec'       
                if table_connec == uri_table:  
                    self.layer_connec = cur_layer
                    self.count_connec = self.layer_connec.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_connecs = self.layer_connec.selectedFeatures()
                    i = 0
                    while (i < self.count_connec):

                        # Get connec_id from current connec
                        feature_connec = features_connecs[i]
                        self.connec_id = feature_connec.attribute('connec_id')

                        # Execute id(automaticaly),element_id and node_id to element_x_node
                        sql = "INSERT INTO "+self.schema_name+".element_x_connec (connec_id, element_id) "
                        sql+= " VALUES ('"+self.connec_id+"', '"+self.element_id+"')"
                        self.dao.execute_sql(sql)   
                        i+=1
                
        # Show message to user
        self.showInfo(self.controller.tr("Values has been updated"))
        self.close_dialog()
    
    
    def ed_add_file(self):
        ''' Button 34. Add file '''
                        
        # Create the dialog and signals
        self.dlg = Add_file()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()           
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!")) 
        
        # Fill comboBox elementcat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".doc ORDER BY doc_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type", rows) 
        
        # Fill comboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".doc ORDER BY tagcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("tagcat_id", rows) 
        
        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit,"doc_id")
        self.completer = QCompleter()
        self.edit.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".doc "
        row = self.dao.get_rows(sql)
        for i in range(0,len(row)):
            aux = row[i]
            row[i] = str(aux[0])
        
        model.setStringList(row)
        self.completer.setModel(model)
        
        # Set signal to reach sellected value from QCompleter
        self.completer.activated.connect(self.ed_add_file_autocomplete)
        
        # Open the dialog
        self.dlg.exec_()
        
        
    def ed_add_file_autocomplete(self):    

        # Qcompleter event- get selected value
        self.dlg.doc_id.setCompleter(self.completer)
        self.doc_id = utils_giswater.getWidgetText("doc_id") 
        
        
    def ed_add_file_accept(self):   
        
        # Get values from comboboxes
        self.doc_id = utils_giswater.getWidgetText("doc_id") 
        self.doc_type = utils_giswater.getWidgetText("doc_type")   
        self.tagcat_id = utils_giswater.getWidgetText("tagcat_id")  
        self.observ = utils_giswater.getWidgetText("observ")
        self.link = utils_giswater.getWidgetText("link")
        
        # Execute data to database DOC 
        sql = "INSERT INTO "+self.schema_name+".doc (id, doc_type, path, observ, tagcat_id) "
        sql+= " VALUES ('"+self.doc_id+"', '"+self.doc_type+"', '"+self.link+"', '"+self.observ+"', '"+self.tagcat_id+"')"
        self.dao.execute_sql(sql)
        
        # Get layers
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return
         
        # Initialize variables                    
        self.layer_arc = None
        table_arc = '"'+self.schema_name+'"."'+self.table_arc+'"'
        table_node = '"'+self.schema_name+'"."'+self.table_node+'"'
        table_connec = '"'+self.schema_name+'"."'+self.table_connec+'"'
   
        # Iterate over all layers to get the ones set in config file        
        for cur_layer in layers:     
            uri = cur_layer.dataProvider().dataSourceUri().lower()   
            pos_ini = uri.find('table=')
            pos_fi = uri.find('" ')  
            uri_table = uri 

            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]   
                
                # Table 'arc                        
                if table_arc == uri_table:  
                    self.layer_arc = cur_layer
                    self.count_arc = self.layer_arc.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_arcs = self.layer_arc.selectedFeatures()
                    i=0
                    while (i<self.count_arc):
                     
                        # Get arc_id from current arc
                        feature = features_arcs[i]
                        self.arc_id = feature.attribute('arc_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")
                                              
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_arc (arc_id, doc_id) "
                        sql+= " VALUES ('"+self.arc_id+"', '"+self.doc_id+"')"
                        i+=1
                        self.dao.execute_sql(sql) 
             
            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1] 
                
                # Table 'node'                          
                if table_node == uri_table:  
                    self.layer_node = cur_layer
                    self.count_node = self.layer_node.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_nodes = self.layer_node.selectedFeatures()
                    i = 0
                    while (i<self.count_node):

                        # Get arc_id from current arc
                        feature = features_nodes[i]
                        self.node_id = feature.attribute('node_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")
                                              
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_node (node_id,doc_id) "
                        sql+= " VALUES ('"+self.node_id+"','"+self.doc_id+"')"
                        i+=1
                        self.dao.execute_sql(sql) 
                        
            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]
                
                # Table 'connec'                              
                if table_connec == uri_table:  
                    self.layer_connec = cur_layer
                    self.count_connec = self.layer_connec.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_connecs = self.layer_connec.selectedFeatures()
                    i = 0
                    while (i<self.count_connec):
                     
                        # Get arc_id from current arc
                        feature = features_connecs[i]
                        self.connec_id = feature.attribute('connec_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")

                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_connec (connec_id, doc_id) "
                        sql+= " VALUES ('"+self.connec_id+"', '"+self.doc_id+"')"
                        self.dao.execute_sql(sql)  
                        i+=1
        
        # Show message to user
        self.showInfo(self.controller.tr("Values has been updated"))
        self.close_dialog()            
        
                    
