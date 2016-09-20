# -*- coding: utf-8 -*-
from qgis.utils import iface
from PyQt4.QtGui import QComboBox, QDateEdit, QPushButton, QTableView, QTabWidget

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
    feature_dialog.dialog.findChild(QComboBox, "cat_arctype_id").setVisible(False)    
    feature_dialog.dialog.findChild(QComboBox, "arccat_id").setVisible(False)    
    
    # Manage 'arccat_id'
    nodecat_id = utils_giswater.getWidgetText("arccat_id")
    feature_dialog.dialog.findChild(QComboBox, "arccat_id_dummy").activated.connect(feature_dialog.change_arc_cat)          
    utils_giswater.setSelectedItem("arcccat_id_dummy", nodecat_id)   
    utils_giswater.setSelectedItem("nodecat_id", nodecat_id)   
    
    # Manage 'cat_arctype_id'
    arc_type_id = utils_giswater.getWidgetText("cat_arctype_id")
    utils_giswater.setSelectedItem("cat_arctype_id_dummy", arc_type_id)    
    feature_dialog.dialog.findChild(QComboBox, "cat_arctype_id_dummy").activated.connect(feature_dialog.change_arc_type_id)  
    feature_dialog.change_arc_type_id(-1)      
      
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
        self.arc_type = utils_giswater.getWidgetText("cat_arctype_id", False)        
        self.arccat_id = utils_giswater.getWidgetText("arccat_id", False)        
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
        
        # Define and execute query to populate combo 'cat_arctype_id_dummy'
        self.fill_arc_type_id()        
      
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        table_element= "v_ui_element_x_arc"
        self.fill_tbl_info(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of  info table
        self.set_configuration(self.tbl_info, table_element)
        
        # Fill the tab Document
        table_document = "v_ui_doc_x_arc"
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        
        # Configuration of table document
        self.set_configuration(self.tbl_document, table_document)
    
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: EPANET, Event, Log
        self.tab_main.removeTab(5)      
        self.tab_main.removeTab(4) 
        self.tab_main.removeTab(2) 
                
    
    def fill_arc_type_id(self):
        ''' Define and execute query to populate combo 'node_type_dummy' '''
        
        # Get node_type.type from node_type.id
        sql = "SELECT type FROM "+self.schema_name+".arc_type"
        if self.arc_type:
            sql+= " WHERE id = '"+self.arc_type+"'"
        row = self.dao.get_row(sql)
        if row: 
            arc_type_type = row[0]
            sql = "SELECT arc_type.id"
            sql+= " FROM "+self.schema_name+".arc_type INNER JOIN "+self.schema_name+".cat_arc ON arc_type.id = cat_arc.arctype_id"
            sql+= " WHERE type = '"+arc_type_type+"' GROUP BY arc_type.id ORDER BY arc_type.id"
            rows = self.dao.get_rows(sql)             
            utils_giswater.fillComboBox("cat_arctype_id_dummy", rows, False)
            utils_giswater.setWidgetText("cat_arctype_id_dummy", self.arc_type)
        
        
    def change_arc_type_id(self, index):
        ''' Define and execute query to populate combo 'cat_arctype_id' '''

        arc_type_id = utils_giswater.getWidgetText("cat_arctype_id", False)    
        if arc_type_id:        
            utils_giswater.setWidgetText("cat_arctype_id", arc_type_id)    
            sql = "SELECT id FROM "+self.schema_name+".cat_arc"
            sql+= " WHERE arctype_id = '"+arc_type_id+"' ORDER BY id"
            rows = self.dao.get_rows(sql)    
            utils_giswater.fillComboBox("arccat_id_dummy", rows, False)    
            if index == -1:  
                utils_giswater.setWidgetText("arccat_id_dummy", self.arccat_id)    
            self.change_arc_cat()     
                  
                       
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
        doc_user.activated.connect(partial(self.set_filter_table, self.tbl_document))
        doc_type.activated.connect(partial(self.set_filter_table, self.tbl_document))
        doc_tag.activated.connect(partial(self.set_filter_table, self.tbl_document))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table, self.tbl_document))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table, self.tbl_document))
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
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
    
            
    def fill_tbl_info(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        
        self.set_model_to_table(widget, table_name, filter_)  
           
        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(5)  
        widget.hideColumn(6)

    