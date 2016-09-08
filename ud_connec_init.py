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
    feature_dialog = ConnecDialog(iface, dialog, layer, feature)
    init_config()
    

def init_config():

    # Set 'epa_type' and button signals      
    #feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)  
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)      
    

class ConnecDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ConnecDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_connec()
        
        
    def init_config_connec(self):
        ''' Custom form initial configuration for 'Node' '''
    
        # Define class variables
        self.field_id = "connec_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
    
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    

        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")      
        
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")    
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")             
  
        # Manage tab visibility
        self.set_tabs_visibility()
        '''
        # Manage i18n
        #self.translate_form('ws_node')        
        
        
        # Load data from related tables
        self.load_data()
        '''
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        table_element= "v_ui_element_x_connec"
        self.fill_tbl_element(self.tbl_element, self.schema_name+"."+table_element, self.filter)
       
        # Fill the tab Document
        table_document = "v_ui_doc_x_connec"
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        
        # Set signals                  
        self.dialog.findChild(QPushButton, "btn_element_delete").clicked.connect(partial(self.delete_records, self.tbl_element, table_element))                 
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))                   
           
        
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: IPTU, Event, Log
        self.tab_main.removeTab(5)      
        self.tab_main.removeTab(4) 
        self.tab_main.removeTab(3) 
        
        
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
        
        # TODO: Get data from related tables!
        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY tagcat_id" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag",rows)
        
        # Fill ComboBox doccat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY doc_type" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type",rows)
        
        # Fill ComboBox doc_user
        sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY user" 
        rows = self.dao.get_rows(sql)
        #rows = [['gis'], ['postgres']]
        utils_giswater.fillComboBox("doc_user",rows)        
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)   

        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(3)  
        widget.hideColumn(5)            
    
            
    def fill_tbl_element(self, widget, table_name, filter_): 
        ''' Fill info tab of connec '''
        
        self.set_model_to_table(widget, table_name, filter_)  
          
        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(5)  
        widget.hideColumn(6)  