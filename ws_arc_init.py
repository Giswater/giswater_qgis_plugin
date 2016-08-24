# -*- coding: utf-8 -*-
from qgis.core import QgsVectorLayerCache, QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest
from qgis.gui import QgsAttributeTableModel
from qgis.utils import iface
from PyQt4.QtGui import *    # @UnusedWildImport
from PyQt4.QtSql import QSqlTableModel

import os
from functools import partial

import utils_giswater
from ws_parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a node is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ArcDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
    
    # Manage visibility 
    #feature_dialog.dialog.findChild(QComboBox, "cat_arctype_id").setVisible(False)    
    feature_dialog.dialog.findChild(QComboBox, "arccat_id").setVisible(False)    
    
    # Manage 'arccat_id'
    nodecat_id = utils_giswater.getWidgetText("arccat_id")
    feature_dialog.dialog.findChild(QComboBox, "arccat_id_dummy").activated.connect(feature_dialog.change_arc_cat)          
    utils_giswater.setSelectedItem("arcccat_id_dummy", nodecat_id)   
    utils_giswater.setSelectedItem("nodecat_id", nodecat_id)   
    
    # Manage 'cat_arctype_id'
    node_type_id = utils_giswater.getWidgetText("cat_arctype_id")
    utils_giswater.setSelectedItem("cat_arctype_id", node_type_id)    
      
    # Set 'epa_type' and button signals      
    feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)  
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)      
    
    
     
class ArcDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ArcDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_arc()
        
        
    def init_config_arc(self):
        ''' Custom form initial configuration for 'Node' '''
        
        # Define class variables
        self.field_id = "arc_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.node_type = utils_giswater.getWidgetText("cat_arctype_id", False)        
        self.nodecat_id = utils_giswater.getWidgetText("arccat_id", False)        
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)        
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")  
        self.tab_event_2 = self.dialog.findChild(QTabWidget, "tab_event_2")        
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")      
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")    
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")             
        self.tbl_rtc = self.dialog.findChild(QTableView, "tbl_rtc")             
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form('ws_arc')        
      
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        table_element= "v_ui_element_x_arc"
        self.fill_tbl_info(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Fill the tab Document
        table_document = "v_ui_doc_x_arc"
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_document, self.filter)
       
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: EPANET, Event, Log
        self.tab_main.removeTab(5)      
        self.tab_main.removeTab(4) 
        self.tab_main.removeTab(2) 
        
        '''
        # Get 'epa_type'
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
        ''' 
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        
        print("load_tab_analysis")
        '''
        if self.epa_type == 'JUNCTION':                           
            # Load combo 'pattern_id'
            combo = self.epa_table+"_pattern_id"
            table_name = "inp_pattern"
            sql = "SELECT pattern_id FROM "+self.schema_name+"."+table_name+" ORDER BY pattern_id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)
            
            self.fields_junction = ['demand', 'pattern_id']               
            sql = "SELECT "
            for i in range(len(self.fields_junction)):
                sql+= self.fields_junction[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE arc_id = '"+self.id+"'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_junction)):
                    widget_name = self.epa_table+"_"+self.fields_junction[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))                
                    
        elif self.epa_type == 'TANK':
            # Load combo 'curve_id'
            combo = self.epa_table+"_curve_id"
            table_name = "inp_curve_id"            
            sql = "SELECT id FROM "+self.schema_name+".inp_curve_id ORDER BY id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)
                        
            self.fields_tank = ['initlevel', 'minlevel', 'maxlevel', 'diameter', 'minvol', 'curve_id']            
            sql = "SELECT "
            for i in range(len(self.fields_tank)):
                sql+= self.fields_tank[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE "+self.field_id+" = '"+self.id+"'"
            row = self.dao.get_row(sql)      
            if row:
                for i in range(len(self.fields_tank)):
                    widget_name = self.epa_table+"_"+self.fields_tank[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))
        '''    

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''        
        print("save_tab_analysis")
        '''
        #super(NodeDialog, self).save_tab_analysis()
        if self.epa_type == 'JUNCTION':
            values = []            
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_junction)):
                widget_name = self.epa_table+"_"+self.fields_junction[i]     
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_junction[i]+" = "+str(values[i])+", "
            sql = sql[:-2]      
            sql+= " WHERE node_id = '"+self.id+"'"        
            self.dao.execute_sql(sql)
            
        if self.epa_type == 'TANK':
            values = []
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_tank)):
                widget_name = self.epa_table+"_"+self.fields_tank[i]              
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_tank[i]+" = "+str(values[i])+", "
            sql = sql[:-2]                
            sql+= " WHERE node_id = '"+self.id+"'"        
            self.dao.execute_sql(sql)
        '''              
    
    def fill_arc_type_id(self):
        ''' Define and execute query to populate combo 'node_type_dummy' '''
        
        print("fill_arc_type_id")
        '''
        # Get node_type.type from node_type.id
        sql = "SELECT type FROM "+self.schema_name+".node_type"
        if self.node_type:
            sql+= " WHERE id = '"+self.node_type+"'"
        row = self.dao.get_row(sql)
        if row: 
            node_type_type = row[0]
            sql = "SELECT node_type.id"
            sql+= " FROM "+self.schema_name+".node_type INNER JOIN "+self.schema_name+".cat_node ON node_type.id = cat_node.nodetype_id"
            sql+= " WHERE type = '"+node_type_type+"' GROUP BY node_type.id ORDER BY node_type.id"
            rows = self.dao.get_rows(sql)              
            utils_giswater.fillComboBox("node_type_dummy", rows, False)
            utils_giswater.setWidgetText("node_type_dummy", self.node_type)
        '''
        
    def change_arc_type_id(self, index):
        ''' Define and execute query to populate combo 'cat_arctype_id' '''
        
        print("change arc type id")
        '''  
        arc_type_id = utils_giswater.getWidgetText("cat_arctype_id", False)    
        if arc_type_id:        
            utils_giswater.setWidgetText("cat_arctype_id", arc_type_id)    
            sql = "SELECT id FROM "+self.schema_name+".cat_arc"
            sql+= " WHERE arctype_id = '"+arc_type_id+"' ORDER BY id"
            rows = self.dao.get_rows(sql)    
            utils_giswater.fillComboBox("arccat_id_dummy", rows, False)    
            if index == -1:  
                utils_giswater.setWidgetText("arccat_id_dummy", self.nodecat_id)    
            self.change_arc_cat()
        '''                 
                       
    def change_arc_cat(self):
        ''' Just select item to 'real' combo 'arccat_id' (that is hidden) '''
        arccat_id_dummy = utils_giswater.getWidgetText("arccat_id_dummy")
        utils_giswater.setWidgetText("arccat_id", arccat_id_dummy)           
        
                
    def change_epa_type(self, index):
        ''' Refresh form '''
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)     
              
        
    def fill_tbl_document(self, widget, table_name, filter_):
        ''' Fill the table control to show documents''' 
         
        # Get widgets
        doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        
        # Set signals
        doc_user.activated.connect(self.set_filter_tbl_document)
        doc_type.activated.connect(self.set_filter_tbl_document)
        doc_tag.activated.connect(self.set_filter_tbl_document)
        self.date_document_to.dateChanged.connect(self.set_filter_tbl_document)
        self.date_document_from.dateChanged.connect(self.set_filter_tbl_document)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # TODO: Get data from related tables!
        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY tagcat_id" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag",rows)
        
        # Fill ComboBox doccat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY doc_type" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type",rows)
        
        # Fill ComboBox doc_user
        sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY user" 
        rows = self.dao.get_rows(sql)
        #rows = [['gis'], ['postgres']]
        utils_giswater.fillComboBox("doc_user",rows)        
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)   

        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(3)  
        widget.hideColumn(5)          
        
         
    def set_filter_tbl_document(self):
        ''' Get values selected by the user and sets a new filter for its table model '''
        
        # Get selected dates
        date_from = self.date_document_from.date().toString('yyyyMMdd') 
        date_to = self.date_document_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)                   
            return
        
        # Get selected value from ComboBoxs
        doc_user_value = utils_giswater.getWidgetText("doc_user")
        doc_type_value = utils_giswater.getWidgetText("doc_type")
        doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        
        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '"+date_from+"' AND date <= '"+date_to+"'"
        
        if doc_type_value != 'null': 
            expr+= " AND doc_type = '"+doc_type_value+"'"
        if doc_tag_value != 'null': 
            expr+= " AND tagcat_id = '"+doc_tag_value+"'"
        
        # TODO: Bug because 'user' is a reserverd word
#         if doc_user_value != 'null': 
#             expr+= " AND user = '"+doc_user_value+"'"
        #print expr
  
        # Refresh model with selected filter
        self.tbl_document.model().setFilter(expr)
        self.tbl_document.model().select()
    
    
            
    def fill_tbl_info(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        
        self.set_model_to_table(widget, table_name, filter_)  
           
        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(5)  
        widget.hideColumn(6)           

 

    