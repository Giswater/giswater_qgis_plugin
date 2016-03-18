# -*- coding: utf-8 -*-
from qgis.gui import (QgsMessageBar)
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.utils import iface
import os.path
import sys  

import utils
from controller import DaoController


def formOpen(dialog, layer, feature):
    
    # Create class to manage Feature Form interaction  
    global node_dialog
    utils.setDialog(dialog)
    node_dialog = NodeDialog(iface, dialog, layer, feature)
    initConfig()

    
def initConfig():
     
    node_dialog.dialog.findChild(QComboBox, "nodecat_id").setVisible(False)         
    node_dialog.dialog.findChild(QComboBox, "cat_nodetype_id").activated.connect(node_dialog.changeNodeType)    
    node_dialog.changeNodeType(-1)  
    nodecat_id = utils.getSelectedItem("nodecat_id")
    utils.setSelectedItem("nodecat_id_dummy", nodecat_id)            
    node_dialog.dialog.findChild(QComboBox, "nodecat_id_dummy").activated.connect(node_dialog.changeNodeCat)          

    node_dialog.dialog.findChild(QPushButton, "btnAccept").clicked.connect(node_dialog.save)            
    node_dialog.dialog.findChild(QPushButton, "btnClose").clicked.connect(node_dialog.close)        
        
        
     
class NodeDialog():   
    
    def __init__(self, iface, dialog, layer, feature):
        self.iface = iface
        self.dialog = dialog
        self.layer = layer
        self.feature = feature
        self.initConfig()
    
        
    def initConfig(self):    
        
        self.epa_type = self.dialog.findChild(QWidget, "epa_type").text()
            
        # initialize plugin directory
        user_folder = os.path.expanduser("~") 
        self.plugin_name = 'giswater'  
        self.plugin_dir = os.path.join(user_folder, '.qgis2/python/plugins/'+self.plugin_name)    
        
        # Get config file
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        if not os.path.isfile(setting_file):
            message = "Config file not found at: "+setting_file
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)  
            self.close()
            return
            
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # Get widget controls
        self.cbo_cat_nodetype_id = self.dialog.findChild(QComboBox, "cat_nodetype_iddd")      
        self.cbo_nodecat_id = self.dialog.findChild(QComboBox, "nodecat_id")   
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")        
        self.tab_man = self.dialog.findChild(QTabWidget, "tab_man")        
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")            
        
        # Set controller to handle settings and database connection
        self.controller = DaoController()
        self.controller.setSettings(self.settings, self.plugin_name)
        status = self.controller.setDatabaseConnection()      
        if not status:
            message = self.controller.getLastError()
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return 
             
        self.schema_name = self.controller.getSchemaName()            
        self.dao = self.controller.getDao()
             
        # Manage tab visibility
        self.setTabsVisibility()
        
        # Manage i18n
        self.translateForm()
        
        # Fill combo 'node type' from 'epa_type'
        self.fillNodeType()
        
        # Set layer in editing mode
        self.layer.startEditing()
            
            
    def translateForm(self):
        
        # Get objects of type: QLabel
        context_name = 'ws_node'
        widget_list = self.dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translateWidget(context_name, widget)
            
            
    def translateWidget(self, context_name, widget):
        
        if widget:
            widget_name = widget.objectName()
            text = utils.tr(context_name, widget_name)
            if text != widget_name:
                widget.setText(text)        
        
   
    
    # Slots  
    
    def fillNodeType(self):
        """ Define and execute query to populate combo 'cat_nodetype_id' """
        current_value = utils.getSelectedItem("cat_nodetype_id")
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type WHERE type = '"+self.epa_type+"' UNION "
        sql+= "SELECT id, man_table, epa_table FROM "+self.schema_name+".node_type WHERE type = '"+self.epa_type+"' ORDER BY id"
        rows = self.dao.get_rows(sql)
        self.cbo_cat_nodetype_id = self.dialog.findChild(QComboBox, "cat_nodetype_id")    
        utils.fillComboBox(self.cbo_cat_nodetype_id, rows)
        utils.setSelectedItem('cat_nodetype_id', current_value)
            
            
    def changeNodeType(self, index):
        """ Define and execute query to populate combo 'nodecat_id_dummy' """
        cat_nodetype_id = utils.getSelectedItem("cat_nodetype_id")
        sql = "SELECT id FROM "+self.schema_name+".cat_arc WHERE arctype_id = '"+cat_nodetype_id+"' UNION "
        sql+= "SELECT id FROM "+self.schema_name+".cat_node WHERE nodetype_id = '"+cat_nodetype_id+"' ORDER BY id"   
        rows = self.dao.get_rows(sql)
        self.cbo_nodecat_id = self.dialog.findChild(QComboBox, "nodecat_id_dummy")
        utils.fillComboBox(self.cbo_nodecat_id, rows)  
        
                       
    def changeNodeCat(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """
        dummy = utils.getSelectedItem("nodecat_id_dummy")
        utils.setSelectedItem("nodecat_id", dummy)           
    
    
    def setTabsVisibility(self):
        
        index_tab = 0      
        if self.epa_type == 'JUNCTION':
            index_tab = 0
        if self.epa_type == 'RESERVOIR' or self.epa_type == 'HYDRANT':
            index_tab = 1
        if self.epa_type == 'TANK':
            index_tab = 2
        if self.epa_type == 'PUMP':
            index_tab = 3
        if self.epa_type == 'VALVE':
            index_tab = 4
        if self.epa_type == 'SHORTPIPE' or self.epa_type == 'FILTER':
            index_tab = 5
        if self.epa_type == 'MEASURE INSTRUMENT':
            index_tab = 6
        
        # Move 'visible' tab to last position and remove previous ones
        self.tab_analysis.tabBar().moveTab(index_tab, 5);
        for i in range(0, self.tab_analysis.count() - 1):
            self.tab_analysis.removeTab(0)    
        self.tab_man.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_man.count() - 1):
            self.tab_man.removeTab(0)    
        self.tab_event.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_event.count() - 1):
            self.tab_event.removeTab(0)    
            
               
    def save(self):
        self.dialog.accept()
        self.layer.commitChanges()    
        self.close()     
        
        
    def close(self):
        self.layer.rollBack()   
        self.dialog.parent().setVisible(False)    

