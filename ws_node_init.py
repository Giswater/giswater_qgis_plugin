# -*- coding: utf-8 -*-
from qgis.gui import (QgsMessageBar)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.utils import iface
import os.path
import sys  

import utils_giswater
from controller import DaoController


def formOpen(dialog, layer, feature):
    ''' Function called when a node is inserted of clicked in the map '''
    
    global node_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    node_dialog = NodeDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
     
    node_dialog.dialog.findChild(QComboBox, "nodecat_id").setVisible(False)         
    node_dialog.dialog.findChild(QComboBox, "cat_nodetype_id").activated.connect(node_dialog.change_node_type)    
    node_dialog.change_node_type(-1)  
    nodecat_id = utils_giswater.getSelectedItem("nodecat_id")
    utils_giswater.setSelectedItem("nodecat_id_dummy", nodecat_id)            
    node_dialog.dialog.findChild(QComboBox, "nodecat_id_dummy").activated.connect(node_dialog.change_node_cat)          
    node_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(node_dialog.change_epa_type)    
    
    node_dialog.dialog.findChild(QPushButton, "btnAccept").clicked.connect(node_dialog.save)            
    node_dialog.dialog.findChild(QPushButton, "btnClose").clicked.connect(node_dialog.close)        
        
        
     
class NodeDialog():   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        self.iface = iface
        self.dialog = dialog
        self.layer = layer
        self.feature = feature
        self.init_config()
    
        
    def init_config(self):    
        
        self.node_id = utils_giswater.getStringValue2("node_id")
        self.epa_type = utils_giswater.getSelectedItem("epa_type")
            
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
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")         
        
        # Set controller to handle settings and database connection
        # TODO: Try to make only one connection
        self.controller = DaoController(self.settings, self.plugin_name)
        status = self.controller.set_database_connection()      
        if not status:
            message = self.controller.getLastError()
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return 
             
        self.schema_name = self.controller.getSchemaName()            
        self.dao = self.controller.getDao()
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form()
        
        # Fill combo 'node type' from 'epa_type'
        self.fill_node_type()
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
            
            
    def translate_form(self):
        
        # Get objects of type: QLabel
        context_name = 'ws_node'
        widget_list = self.dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
            
    def translate_widget(self, context_name, widget):
        
        if widget:
            widget_name = widget.objectName()
            text = utils_giswater.tr(context_name, widget_name)
            if text != widget_name:
                widget.setText(text)        
        
   
    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''
        if self.epa_type == 'TANK':
            sql = "SELECT vmax, area FROM "+self.schema_name+".man_tank WHERE node_id = "+self.node_id
            row = self.dao.get_row(sql)
            if row:             
                utils_giswater.setText("man_tank_vmax", str(row[0]))
                utils_giswater.setText("man_tank_area", str(row[1]))
   
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        
        if self.epa_type == 'JUNCTION':                           
            sql = "SELECT demand, pattern_id"
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE node_id = "+self.node_id
            row = self.dao.get_row(sql)
            if row:
                for i in range(self.dao.get_columns_length()):
                    widget_name = self.epa_table+"_"+self.dao.get_column_name(i)
                    utils_giswater.setText(widget_name, str(row[i]))
                    
        elif self.epa_type == 'TANK':
            # Load combo widgets
            combo = self.epa_table+"_curve_id"
            sql = "SELECT id FROM "+self.schema_name+".inp_curve_id ORDER BY id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)
                        
            self.fields_tank = ['initlevel', 'minlevel', 'maxlevel', 'diameter', 'minvol', 'curve_id']            
            sql = "SELECT "
            for i in range(len(self.fields_tank)):
                sql+= self.fields_tank[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE node_id = "+self.node_id
            row = self.dao.get_row(sql)
            #print sql            
            if row:
                for i in range(len(self.fields_tank)):
                    widget_name = self.epa_table+"_"+self.fields_tank[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))
        
        
    def load_data(self):
        ''' Load data from related tables '''
        
        self.load_tab_add_info()
        self.load_tab_analysis()
        
        ''' TODO:
        self.load_tab_document()
        self.load_tab_picture()
        self.load_tab_event()
        self.load_tab_log()
        self.load_tab_rtc()
        '''        
        

    def save_tab_add_info(self):
        ''' Save tab from tab 'Add. info' '''                
        if self.epa_type == 'TANK':
            vmax = utils_giswater.getStringValue2("man_tank_vmax")
            area = utils_giswater.getStringValue2("man_tank_area")
            sql = "UPDATE "+self.schema_name+".man_tank SET vmax = "+str(vmax)+ ", area = "+str(area)
            sql+= " WHERE node_id = "+str(self.node_id)
            self.dao.execute_sql(sql)
                

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''                

        if self.epa_type == 'JUNCTION':
            demand = utils_giswater.getStringValue2(self.epa_table+"_demand")
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET"
            sql+= " demand = "+str(demand)
            sql+= " WHERE node_id = "+str(self.node_id)          
            self.dao.execute_sql(sql)
            
        if self.epa_type == 'TANK':
            values = []
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_tank)):
                widget_name = self.epa_table+"_"+self.fields_tank[i]              
                values.append(utils_giswater.getWidgetText(widget_name))
                sql+= self.fields_tank[i]+" = "+str(values[i])+", "
            sql = sql[:-2]                
            sql+= " WHERE node_id = "+str(self.node_id)        
            self.dao.execute_sql(sql)
                
                
    def save_data(self):
        ''' Save data from related tables '''
        self.save_tab_add_info()
        self.save_tab_analysis()
        
        ''' TODO:
        self.save_tab_document()
        self.save_tab_picture()
        self.save_tab_event()
        self.save_tab_log()
        self.save_tab_rtc()
        '''        
                
           
        
    ''' Slot functions '''  
    
    def fill_node_type(self):
        ''' Define and execute query to populate combo 'cat_nodetype_id' '''
        cat_nodetype_id = utils_giswater.getSelectedItem("cat_nodetype_id")     
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type WHERE epa_default = '"+self.epa_type+"' UNION "
        sql+= "SELECT id, man_table, epa_table FROM "+self.schema_name+".node_type WHERE epa_default = '"+self.epa_type+"' ORDER BY id"
        rows = self.dao.get_rows(sql)     
        self.cbo_cat_nodetype_id = self.dialog.findChild(QComboBox, "cat_nodetype_id")    
        utils_giswater.fillComboBox(self.cbo_cat_nodetype_id, rows)
        utils_giswater.setSelectedItem('cat_nodetype_id', cat_nodetype_id)
            
            
    def change_node_type(self, index):
        ''' Define and execute query to populate combo 'nodecat_id_dummy' '''
        cat_nodetype_id = utils_giswater.getSelectedItem("cat_nodetype_id")     
        sql = "SELECT id FROM "+self.schema_name+".cat_arc WHERE arctype_id = '"+cat_nodetype_id+"' UNION "
        sql+= "SELECT id FROM "+self.schema_name+".cat_node WHERE nodetype_id = '"+cat_nodetype_id+"' ORDER BY id"   
        rows = self.dao.get_rows(sql)
        self.cbo_nodecat_id = self.dialog.findChild(QComboBox, "nodecat_id_dummy")
        utils_giswater.fillComboBox(self.cbo_nodecat_id, rows, False)  
        self.change_node_cat(0)       
        
                       
    def change_node_cat(self, index):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) '''
        dummy = utils_giswater.getSelectedItem("nodecat_id_dummy")
        utils_giswater.setSelectedItem("nodecat_id", dummy)   
        
                
    def change_epa_type(self, index):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) '''
        epa_type = utils_giswater.getSelectedItem("epa_type")
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)        
    
    
    def set_tabs_visibility(self):
        
        man_visible = False
        index_tab = 0      
        if self.epa_type == 'JUNCTION':
            index_tab = 0
            self.epa_table = 'inp_junction'
        elif self.epa_type == 'RESERVOIR' or self.epa_type == 'HYDRANT':
            index_tab = 1
            self.epa_table = 'inp_reservoir'
        elif self.epa_type == 'TANK':
            index_tab = 2
            self.epa_table = 'inp_tank'
            man_visible = True           
        elif self.epa_type == 'PUMP':
            index_tab = 3
            self.epa_table = 'inp_pump'
        elif self.epa_type == 'VALVE':
            index_tab = 4
            self.epa_table = 'inp_valve'
        elif self.epa_type == 'SHORTPIPE' or self.epa_type == 'FILTER':
            index_tab = 5
            self.epa_table = 'inp_shortpipe'
        elif self.epa_type == 'MEASURE INSTRUMENT':
            index_tab = 6
        
        # Tab 'Add. info': Manage visibility of these widgets 
        utils_giswater.setWidgetVisible("label_man_tank_vmax", man_visible) 
        utils_giswater.setWidgetVisible("label_man_tank_area", man_visible) 
        utils_giswater.setWidgetVisible("man_tank_vmax", man_visible) 
        utils_giswater.setWidgetVisible("man_tank_area", man_visible) 
                    
        # Move 'visible' tab to last position and remove previous ones
        self.tab_analysis.tabBar().moveTab(index_tab, 5);
        for i in range(0, self.tab_analysis.count() - 1):
            self.tab_analysis.removeTab(0)    
        self.tab_event.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_event.count() - 1):
            self.tab_event.removeTab(0)    
            
               
    def save(self):
        ''' Save feature '''
        self.save_data()
                                
        self.dialog.accept()
        self.layer.commitChanges()    
        self.close()     
        
        
    def close(self):
        ''' Close form without saving '''
        self.layer.rollBack()   
        self.dialog.parent().setVisible(False)    

