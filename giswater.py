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
from qgis.utils import active_plugins
from qgis.gui import (QgsMessageBar)
from qgis.core import (QgsGeometry, QgsPoint, QgsLogger)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport

import os.path
import sys  

from generic_map_tool import GenericMapTool


class Giswater(QObject):
    """QGIS Plugin Implementation."""

    def __init__(self, iface):
        """Constructor.

        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        super(Giswater, self).__init__()
        
        # Save reference to the QGIS interface
        self.iface = iface
        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        self.pluginName = os.path.basename(self.plugin_dir)
        # initialize locale
        locale = QSettings().value('locale/userLocale')
        locale_path = os.path.join(self.plugin_dir, 'i18n', 'Giswater_{}.qm'.format(locale))
        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)
        
        # load local settings of the plugin
        settingFile = os.path.join(self.plugin_dir, 'config', 'giswater.config')
        self.settings = QSettings(settingFile, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # load plugin settings
        self.loadPluginSettings()            
        
        # Declare instance attributes
        self.icon_folder = self.plugin_dir+'/icons/'        
        self.actions = {}
        
        # {function_name, map_tool}
        self.map_tools = {}
    
    
    def loadPluginSettings(self):
        ''' Load plugin settings
        '''      
        # Create plugin main menu
        self.menu_name = self.tr('menu_name')        
    
        # Create edit, epanet and swmm toolbars or not?
        self.toolbar_edit_enabled = bool(int(self.settings.value('status/toolbar_edit_enabled', 1)))
        self.toolbar_epanet_enabled = bool(int(self.settings.value('status/toolbar_epanet_enabled', 1)))
        self.toolbar_swmm_enabled = bool(int(self.settings.value('status/toolbar_swmm_enabled', 1)))
        if self.toolbar_swmm_enabled:
            self.toolbar_swmm_name = self.tr('toolbar_swmm_name')
            self.toolbar_swmm = self.iface.addToolBar(self.toolbar_swmm_name)
            self.toolbar_swmm.setObjectName(self.toolbar_swmm_name)   
        if self.toolbar_epanet_enabled:
            self.toolbar_epanet_name = self.tr('toolbar_epanet_name')
            self.toolbar_epanet = self.iface.addToolBar(self.toolbar_epanet_name)
            self.toolbar_epanet.setObjectName(self.toolbar_epanet_name)   
        if self.toolbar_edit_enabled:
            self.toolbar_edit_name = self.tr('toolbar_edit_name')
            self.toolbar_edit = self.iface.addToolBar(self.toolbar_edit_name)
            self.toolbar_edit.setObjectName(self.toolbar_edit_name)   
        

    def tr(self, message):
        return QCoreApplication.translate('Giswater', message)
        
        
    def createAction(self, icon_index=None, text='', toolbar=None, menu=None, is_checkable=True, function_name=None, parent=None):
        
        if parent is None:
            parent = self.iface.mainWindow()

        icon = None
        if icon_index is not None:
            icon_path = self.icon_folder+icon_index+'.png'
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
            
        if icon_index is not None:         
            self.actions[icon_index] = action
        else:
            self.actions[text] = action
            
        if function_name is not None:
            try:
                callback_function = getattr(self, function_name)
                action.toggled.connect(callback_function)               
                action.setCheckable(is_checkable)          
            except AttributeError:
                print "Callback function not found: "+function_name
                action.setEnabled(False)                
        else:
            action.setEnabled(False)
            
        return action
          
        
    def addAction(self, index_action, toolbar, parent):
        #text_action = self.settings.value('actions/'+index_action+'_text', '')
        text_action = self.tr(index_action+'_text')
        function_name = self.settings.value('actions/'+str(index_action)+'_function')
        action = self.createAction(index_action, text_action, toolbar, None, True, function_name, parent)
        self.map_tool = GenericMapTool(self.iface, action, self.settings, index_action) 
        self.map_tools[function_name] = self.map_tool             
        
        return action         
        
        
    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""  
        
        parent = self.iface.mainWindow()
        # Edit&Analysis toolbar 
        if self.toolbar_edit_enabled:      
            self.ag_edit = QActionGroup(parent);
            for i in range(16,28):
                self.addAction(str(i), self.toolbar_edit, self.ag_edit)
                
        # Epanet toolbar
        if self.toolbar_epanet_enabled:  
            self.ag_epanet = QActionGroup(parent);
            for i in range(10,16):
                self.addAction(str(i), self.toolbar_epanet, self.ag_epanet)
                
        # SWMM toolbar
        if self.toolbar_swmm_enabled:        
            for i in range(1,10):
                self.ag_swmm = QActionGroup(parent);                
                self.addAction(str(i).zfill(2), self.toolbar_swmm, self.ag_swmm)                    
            
        # Menu entries
        self.createAction(None, self.tr('New network'), None, self.menu_name, False)
        self.createAction(None, self.tr('Copy network as'), None, self.menu_name, False)
            
        self.menu_network_configuration = QMenu(self.tr('Network configuration'))
        action1 = self.createAction(None, self.tr('Snapping tolerance'), None, None, False)               
        action2 = self.createAction(None, self.tr('Node tolerance'), None, None, False)         
        self.menu_network_configuration.addAction(action1)
        self.menu_network_configuration.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_network_configuration.menuAction())  
           
        self.menu_network_management = QMenu(self.tr('Network management'))
        action1 = self.createAction('21', self.tr('Table wizard'), None, None, False)               
        action2 = self.createAction('22', self.tr('Undo wizard'), None, None, False)         
        self.menu_network_management.addAction(action1)
        self.menu_network_management.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_network_management.menuAction())         
           
        self.menu_analysis = QMenu(self.tr('Analysis'))          
        action2 = self.createAction('25', self.tr('Result selector'), None, None, False)               
        action3 = self.createAction('27', self.tr('Flow trace node'), None, None, False)         
        action4 = self.createAction('26', self.tr('Flow trace arc'), None, None, False)         
        self.menu_analysis.addAction(action2)
        self.menu_analysis.addAction(action3)
        self.menu_analysis.addAction(action4)
        self.iface.addPluginToMenu(self.menu_name, self.menu_analysis.menuAction())    
         
        self.menu_go2epa = QMenu(self.tr('Go2Epa'))
        action1 = self.createAction('23', self.tr('Giswater interface'), None, None, False)               
        action2 = self.createAction('24', self.tr('Run simulation'), None, None, False)         
        self.menu_go2epa.addAction(action1)
        self.menu_go2epa.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_go2epa.menuAction())     
    
                     
    
    # Water supply callback functions
    def ws_generic(self, is_checked, function_name):
        
        map_tool = self.map_tools[function_name]
        if is_checked:
            self.iface.mapCanvas().setMapTool(map_tool)
            print function_name+" has been checked"
#             sender = self.sender()
#             print sender.text()
        else:
            self.iface.mapCanvas().unsetMapTool(map_tool)
            #print function_name+" has been unchecked" 
                    
        
    def ws_junction(self, is_checked):
        function_name = sys._getframe().f_code.co_name
        self.ws_generic(is_checked, function_name)
                        
    def ws_reservoir(self, is_checked):
        function_name = sys._getframe().f_code.co_name
        self.ws_generic(is_checked, function_name)
        
        
        
    # Urban drainage callback functions        
    def ud_junction(self, b):
        
        print sys._getframe().f_code.co_name
        #self.iface.mapCanvas().setMapTool(self.toolPoint)
            
    
    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        for action_index, action in self.actions.iteritems():
            self.iface.removePluginMenu(self.menu_name, self.menu_network_management.menuAction())
            self.iface.removePluginMenu(self.menu_name, action)
            self.iface.removeToolBarIcon(action)
        if self.toolbar_edit_enabled:    
            del self.toolbar_edit
        if self.toolbar_epanet_enabled:    
            del self.toolbar_epanet
        if self.toolbar_swmm_enabled:    
            del self.toolbar_swmm
            
            