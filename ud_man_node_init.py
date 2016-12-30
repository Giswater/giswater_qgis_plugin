'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from PyQt4.QtGui import QComboBox, QDateEdit, QPushButton, QTableView, QTabWidget, QLineEdit, QDialogButtonBox

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.add_sum import Add_sum          # @UnresolvedImport


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManNodeDialog(dialog, layer, feature)
    init_config()

    
def init_config():

    # Manage 'node_type'
    node_type = utils_giswater.getWidgetText("node_type") 
    utils_giswater.setSelectedItem("node_type", node_type)
     
    # Manage 'nodecat_id'
    nodecat_id = utils_giswater.getWidgetText("nodecat_id") 
    utils_giswater.setSelectedItem("nodecat_id", nodecat_id)      
    
    # Set button signals      
    #feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    #feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)  
    #feature_dialog.dialog.findChild(QDialogButtonBox, "ok").clicked.connect(feature_dialog.save)            
     
class ManNodeDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(ManNodeDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
        table_element = "v_ui_element_x_node" 
        table_document = "v_ui_doc_x_node"   
        table_event_node = "v_ui_om_visit_x_node"
        table_scada = "v_rtc_scada"    
        table_scada_value = "v_rtc_scada_value"    
        
        table_price_node = "v_price_x_node"
        
        self.table_chamber = self.schema_name+'."v_edit_man_chamber"'
        self.table_chamber_pol = self.schema_name+'."v_edit_man_chamber_pol"'
        self.table_netgully = self.schema_name+'."v_edit_man_netgully"'
        self.table_netgully_pol = self.schema_name+'."v_edit_man_netgully_pol"'
        self.table_netinit = self.schema_name+'."v_edit_man_netinit"'
        self.table_wjump = self.schema_name+'."v_edit_man_wjump"'
        self.table_wwtp = self.schema_name+'."v_edit_man_wwtp"'
        self.table_junction = self.schema_name+'."v_edit_man_junction"'
        self.table_wwtp_pol = self.schema_name+'."v_edit_man_wwtp_pol"'
        self.table_storage = self.schema_name+'."v_edit_man_storage"'
        self.table_storage_pol = self.schema_name+'."v_edit_man_storage_pol"'
        self.table_outfall = self.schema_name+'."v_edit_man_outfall"'
        self.table_manhole = self.schema_name+'."v_edit_man_manhole"'
        self.table_valve = self.schema_name+'."v_edit_man_valvel"'
              
        # Define class variables
        self.field_id = "node_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.node_type = utils_giswater.getWidgetText("node_type", False)        
        self.nodecat_id = utils_giswater.getWidgetText("nodecat_id", False) 
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")  
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value") 
        self.tbl_price_node = self.dialog.findChild(QTableView, "tbl_masterplan")
              
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        # self.layer.startEditing()
        
        # Manage tab visibility
        self.set_tabs_visibility()  
        
        # Fill the info table
        self.fill_table(self.tbl_info, self.schema_name+"."+table_element, self.filter)
       
        # Configuration of info table
        self.set_configuration(self.tbl_info, table_element)    
        
        # Fill the tab Document
        self.fill_tbl_document_man(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # Configuration of Document table
        self.set_configuration(self.tbl_document, table_document)    
        
        # Fill tab event | node
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_node, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        
        # Configuration of table event | node
        self.set_configuration(self.tbl_event, table_event_node)
        
        # Fill tab scada | scada
        self.fill_tbl_hydrometer(self.tbl_scada, self.schema_name+"."+table_scada, self.filter)
        
        # Configuration of table scada | scada
        self.set_configuration(self.tbl_scada, table_scada)
        
        # Fill tab scada |scada value
        self.fill_tbl_hydrometer(self.tbl_scada_value, self.schema_name+"."+table_scada_value, self.filter)
        
        # Configuration of table scada | scada value
        self.set_configuration(self.tbl_scada_value, table_scada_value)
        
        # Fill tab costs
        self.fill_table(self.tbl_price_node, self.schema_name+"."+table_price_node, self.filter)

        # Configuration of table cost
        self.set_configuration(self.tbl_price_node, table_price_node)
        
        # Set signals          
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))             
        
    
        
    def set_tabs_visibility(self):
        ''' Hide some tabs ''' 
          
        # Get schema and table name of selected layer       
        (uri_schema, uri_table) = self.controller.get_layer_source(self.layer)   #@UnusedVariable
        if uri_table is None:
            self.controller.show_warning("Error getting table name from selected layer")
            return
        
        if (uri_table == self.table_chamber) | (uri_table == self.table_chamber_pol) :
            for i in xrange(9,-1,-1):
                if (i != 0):
                    self.tab_main.removeTab(i) 
                    
        if uri_table == self.table_junction :
            for i in xrange(9,-1,-1):
                if (i != 1):
                    self.tab_main.removeTab(i) 
                    
        if uri_table == self.table_manhole :
            for i in xrange(9,-1,-1):
                if (i != 2):
                    self.tab_main.removeTab(i) 
                    
        if (uri_table == self.table_netgully) | (uri_table == self.table_netgully_pol) :
            for i in xrange(9,-1,-1):
                if (i != 3):
                    self.tab_main.removeTab(i) 
                    
        if uri_table == self.table_netinit :
            for i in xrange(9,-1,-1):
                if (i != 4):
                    self.tab_main.removeTab(i) 
                    
        if uri_table == self.table_outfall :
            for i in xrange(9,-1,-1):
                if (i != 5):
                    self.tab_main.removeTab(i) 
                    
        if (uri_table == self.table_storage) | (uri_table == self.table_storage_pol) :
            for i in xrange(9,-1,-1):
                if (i != 6):
                    self.tab_main.removeTab(i) 
                                           
        if uri_table == self.table_valve :
            for i in xrange(9,-1,-1):
                if (i != 7):
                    self.tab_main.removeTab(i)                       
                                        
        if uri_table == self.table_wjump :
            for i in xrange(9,-1,-1):
                if (i != 8):
                    self.tab_main.removeTab(i) 
                    
        if (uri_table == self.table_wwtp) | (uri_table == self.table_wwtp_pol) :
            for i in xrange(9,-1,-1):
                if (i != 9):
                    self.tab_main.removeTab(i) 
                    
     