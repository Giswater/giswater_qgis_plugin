"""
This file is part of TreeManage 1.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    import ConfigParser as configparser
else:
    import configparser
   
from qgis.core import QgsExpressionContextUtils, QgsProject
from qgis.PyQt.QtCore import QObject, QSettings
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QActionGroup

import os
import sys  
from functools import partial

from actions.tm_basic import TmBasic
from .dao.controller import DaoController
from .models.plugin_toolbar import PluginToolbar


class TreeManage(QObject):
    
    def __init__(self, iface):
        """ Constructor 
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        
        super(TreeManage, self).__init__()

        # Initialize instance attributes
        self.iface = iface
        self.actions = {}
        self.srid = None
        self.plugin_toolbars = {}
            
        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        self.plugin_name = self.get_value_from_metadata('name', 'tree_manage')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        # Initialize svg tree_manage directory
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
        
        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix) 
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())

        # Define signals
        self.set_signals()
       
               
    def set_signals(self): 
        """ Define widget and event signals """

        self.iface.projectRead.connect(self.project_read)

  
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
            if int(index_action) in (0, 1, 2, 3, 4, 5):
                callback_function = getattr(self.basic, function_name)  
                action.triggered.connect(callback_function)

            # Generic function
            else:        
                callback_function = getattr(self, 'action_triggered')  
                action.triggered.connect(partial(callback_function, function_name))
                
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

        toolbar.addAction(action)  
        action.setCheckable(is_checkable)    
        self.actions[index_action] = action                                     
        
        # Management of the action                     
        self.manage_action(index_action, function_name)

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
        if int(index_action) in (0, 1, 2, 3, 4, 5):
            action = self.create_action(index_action, text_action, toolbar, False, function_name, action_group)
        # Buttons checkable (normally related with 'map_tools')                
        else:
            action = self.create_action(index_action, text_action, toolbar, True, function_name, action_group)
        
        return action         


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


    def manage_toolbars(self):
        """ Manage actions of the different plugin toolbars """ 
        
        toolbar_id = "basic"
        list_actions = ['03', '01', '02', '04', '05']
        self.manage_toolbar(toolbar_id, list_actions)

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()           
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)

        # Enable only toobar 'basic'
        self.enable_toolbar("basic")
        self.basic.set_controller(self.controller)


    def enable_toolbar(self, toolbar_id, enable=True):
        """ Enable/Disable toolbar. Normally because user has no permission """

        plugin_toolbar = self.plugin_toolbars[toolbar_id]
        plugin_toolbar.toolbar.setVisible(enable)
        for index_action in plugin_toolbar.list_actions:
            self.enable_action(enable, index_action)


    def manage_toolbar(self, toolbar_id, list_actions): 
        """ Manage action of selected plugin toolbar """
                
        toolbar_name = self.tr('toolbar_' + toolbar_id + '_name')        
        plugin_toolbar = PluginToolbar(toolbar_id, toolbar_name, True)
        plugin_toolbar.toolbar = self.iface.addToolBar(toolbar_name)
        plugin_toolbar.toolbar.setObjectName(toolbar_name)  
        plugin_toolbar.list_actions = list_actions           
        self.plugin_toolbars[toolbar_id] = plugin_toolbar 
                        
           
    def initGui(self):
        """ Create the menu entries and toolbar icons inside the QGIS GUI """ 

        # Force project read (to work with PluginReloader)
        self.project_read(False)


    def unload(self):
        """ Removes the plugin menu item and icon from QGIS GUI """

        try:
            for action in list(self.actions.values()):
                self.iface.removePluginMenu(self.plugin_name, action)
                self.iface.removeToolBarIcon(action)
                
            for plugin_toolbar in list(self.plugin_toolbars.values()):
                if plugin_toolbar.enabled:
                    plugin_toolbar.toolbar.setVisible(False)                
                    del plugin_toolbar.toolbar

            # unload all loaded tree_manage related modules
            for modName, mod in sys.modules.items():
                if mod and hasattr(mod, '__file__') and self.plugin_dir in mod.__file__:
                    del sys.modules[modName]

        except AttributeError:
            self.controller.log_info("unload - AttributeError")
        except:
            pass
    
    
    """ Slots """             

    def project_read(self, show_warning=True): 
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        self.controller.set_plugin_dir(self.plugin_dir)        
        self.controller.set_qgis_settings(self.qgis_settings)
        self.controller.set_tree_manage(self)
        connection_status = self.controller.set_database_connection()
        if not connection_status:
            msg = self.controller.last_error
            if show_warning:
                self.controller.show_warning(msg, 15) 
            return

        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)       
                
        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)
        
        # Get schema name from table 'version_tm' and set it in controller and in config file
        layer_version = self.controller.get_layer_by_tablename("version_tm")
        if not layer_version:
            self.controller.show_warning("Layer not found", parameter="version_tm")
            return

        layer_source = self.controller.get_layer_source(layer_version)
        self.schema_name = layer_source['schema'].replace('"', '')
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)   
        self.controller.set_schema_name(self.schema_name)

        # Set actions classes (define one class per plugin toolbar)
        self.basic = TmBasic(self.iface, self.settings, self.controller, self.plugin_dir)
        self.basic.set_tree_manage(self)

        # Get SRID from table node
        srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", srid)

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()   
        
        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)


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

