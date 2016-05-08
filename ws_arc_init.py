# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.utils import iface

import utils_giswater
from ws_parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when an arc is inserted of clicked in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ArcDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
     
    feature_dialog.dialog.findChild(QComboBox, "arccat_id").setVisible(False)         
    arccat_id = utils_giswater.getWidgetText("arccat_id", False)
    feature_dialog.change_arc_type()  
    feature_dialog.dialog.findChild(QComboBox, "cat_arctype_id").activated.connect(feature_dialog.change_arc_type)    
    feature_dialog.dialog.findChild(QComboBox, "arccat_id_dummy").activated.connect(feature_dialog.change_arc_cat)          
    utils_giswater.setSelectedItem("arccat_id_dummy", arccat_id)            
    utils_giswater.setSelectedItem("arccat_id", arccat_id)            
    
    feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)    
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)        


     
class ArcDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ArcDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_arc()
        
        
    def init_config_arc(self):
        ''' Custom form initial configuration for 'Arc' '''
        
        # Define class variables
        self.field_id = "arc_id"
        self.id = utils_giswater.getWidgetText(self.field_id, False)
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)        
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")         
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form('ws_arc')        
        
        # Fill combo 'arc type' from 'epa_type'
        self.fill_arc_type()
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
               
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        
        if self.epa_type == 'PIPE':                                       
            self.fields_pipe = ['minorloss', 'status']               
            sql = "SELECT "
            for i in range(len(self.fields_pipe)):
                sql+= self.fields_pipe[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE arc_id = '"+self.id+"'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_pipe)):
                    widget_name = self.epa_table+"_"+self.fields_pipe[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))  
             

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''   
                     
        #super(ArcDialog, self).save_tab_analysis()
        if self.epa_type == 'PIPE':
            values = []            
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_pipe)):
                widget_name = self.epa_table+"_"+self.fields_pipe[i]     
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_pipe[i]+" = "+str(values[i])+", "
            sql = sql[:-2]      
            sql+= " WHERE arc_id = '"+self.id+"'"        
            self.dao.execute_sql(sql)        
                        
                        
        
    ''' Slot functions '''  
    
    def fill_arc_type(self):
        ''' Define and execute query to populate combo 'cat_arctype_id' '''
        cat_arctype_id = utils_giswater.getWidgetText("cat_arctype_id", False)     
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type"
        sql+= " WHERE epa_default = '"+self.epa_type+"' ORDER BY id"
        rows = self.dao.get_rows(sql)       
        utils_giswater.fillComboBox("cat_arctype_id", rows)
        utils_giswater.setWidgetText("cat_arctype_id", cat_arctype_id)
            
            
    def change_arc_type(self):
        ''' Define and execute query to populate combo 'arccat_id_dummy' '''
        cat_arctype_id = utils_giswater.getWidgetText("cat_arctype_id", True)    
        sql = "SELECT id FROM "+self.schema_name+".cat_arc"
        sql+= " WHERE arctype_id = "+cat_arctype_id+" ORDER BY id"   
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arccat_id_dummy", rows, False) 
        # Select first item by default         
        self.change_arc_cat()       
        
                       
    def change_arc_cat(self):
        ''' Just select item to 'real' combo 'arccat_id' (that is hidden) '''
        dummy = utils_giswater.getWidgetText("arccat_id_dummy", False)
        utils_giswater.setWidgetText("arccat_id", dummy)   
        
                
    def change_epa_type(self, index):
        ''' Just select item to 'real' combo 'arccat_id' (that is hidden) '''
        epa_type = utils_giswater.getWidgetText("epa_type", False)
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)        
    
    
    def set_tabs_visibility(self):
        ''' Hide some 'tabs' depending 'epa_type' '''
          
        if self.epa_type == 'PIPE':
            self.epa_table = 'inp_pipe'



