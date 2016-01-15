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

import resources_rc


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
        locale = QSettings().value('locale/userLocale')[0:2]
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
        self.actions = {}
        self.icon_folder = self.plugin_dir+'/icons/'        
    
    
    def loadPluginSettings(self):
        ''' Load plugin settings
        '''      
        # Create plugin main menu
        self.menu_name = self.settings.value('status/menu_name', 'Giswater')         
    
        # Create edit, epanet and swmm toolbars or not?
        self.toolbar_edit_enabled = bool(int(self.settings.value('status/toolbar_edit_enabled', 1)))
        self.toolbar_epanet_enabled = bool(int(self.settings.value('status/toolbar_epanet_enabled', 1)))
        self.toolbar_swmm_enabled = bool(int(self.settings.value('status/toolbar_swmm_enabled', 1)))
        if self.toolbar_swmm_enabled:
            self.toolbar_swmm_name = self.settings.value('status/toolbar_swmm_name', '')
            self.toolbar_swmm = self.iface.addToolBar(self.toolbar_swmm_name)
            self.toolbar_swmm.setObjectName(self.toolbar_swmm_name)   
        if self.toolbar_epanet_enabled:
            self.toolbar_epanet_name = self.settings.value('status/toolbar_epanet_name', '')
            self.toolbar_epanet = self.iface.addToolBar(self.toolbar_epanet_name)
            self.toolbar_epanet.setObjectName(self.toolbar_epanet_name)   
        if self.toolbar_edit_enabled:
            self.toolbar_edit_name = self.settings.value('status/toolbar_edit_name', '')
            self.toolbar_edit = self.iface.addToolBar(self.toolbar_edit_name)
            self.toolbar_edit.setObjectName(self.toolbar_edit_name)   
        
                
    def createAction(self, icon_index=None, text='', toolbar=None, menu=None, is_checkable=True, callback=None):
        
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
        #action.toggled.connect(callback)
        action.setCheckable(is_checkable)
        
        if toolbar is not None:
            toolbar.addAction(action)  
             
        if menu is not None:
            self.iface.addPluginToMenu(menu, action)
            
        if icon_index is not None:         
            self.actions[icon_index] = action
        else:
            self.actions[text] = action
        
        return action
          
        
    def addAction(self, index_action, toolbar):
        text_action = self.settings.value('actions/'+index_action+'_text', '')
        self.createAction(index_action, text_action, toolbar, None)
        
        
    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""  
        # Edit&Analysis toolbar 
        for i in range(16,28):
            self.addAction(str(i), self.toolbar_edit)
        # Epanet toolbar
        for i in range(10,16):
            self.addAction(str(i), self.toolbar_epanet)
        # SWMM toolbar
        for i in range(1,10):
            self.addAction(str(i).zfill(2), self.toolbar_swmm)
            
        self.createAction(None, 'New network', None, self.menu_name, False)
        self.createAction(None, 'Copy network as', None, self.menu_name, False)
            
        self.menu_network_configuration = QMenu('Network configuration')
        action1 = self.createAction(None, 'Snapping tolerance', None, None, False)               
        action2 = self.createAction(None, 'Node tolerance', None, None, False)         
        self.menu_network_configuration.addAction(action1)
        self.menu_network_configuration.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_network_configuration.menuAction())  
           
        self.menu_network_management = QMenu('Network management')
        action1 = self.createAction('21', 'Table wizard', None, None, False)               
        action2 = self.createAction('22', 'Undo wizard', None, None, False)         
        self.menu_network_management.addAction(action1)
        self.menu_network_management.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_network_management.menuAction())         
           
        self.menu_analysis = QMenu('Analysis')          
        action2 = self.createAction('25', 'Result selector', None, None, False)               
        action3 = self.createAction('27', 'Flow trace node', None, None, False)         
        action4 = self.createAction('26', 'Flow trace arc', None, None, False)         
        self.menu_analysis.addAction(action2)
        self.menu_analysis.addAction(action3)
        self.menu_analysis.addAction(action4)
        self.iface.addPluginToMenu(self.menu_name, self.menu_analysis.menuAction())    
         
        self.menu_go2epa = QMenu('Go2Epa')
        action1 = self.createAction('23', 'Giswater interface', None, None, False)               
        action2 = self.createAction('24', 'Run simulation', None, None, False)         
        self.menu_go2epa.addAction(action1)
        self.menu_go2epa.addAction(action2)
        self.iface.addPluginToMenu(self.menu_name, self.menu_go2epa.menuAction())     
    
    
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
                        
    
    def runPoint(self, b):
        if b:
            self.iface.mapCanvas().setMapTool(self.toolPoint)
        else:
            self.iface.mapCanvas().unsetMapTool(self.toolPoint)
        if self.actionRectangleEnabled:         
            self.actionRectangle.setChecked(False)
            self.selectionButton.setDefaultAction(self.selectionButton.sender())
            
