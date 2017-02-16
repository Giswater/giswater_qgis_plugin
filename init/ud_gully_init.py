'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget

from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a gully is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = GullyDialog(dialog, layer, feature)
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)      
    

class GullyDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(GullyDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
        
        # Define local variables
        context_name = "ud_gully"    
        table_element = "v_ui_element_x_gully" 
        table_document = "v_ui_doc_x_gully"           
    
        # Define class variables
        self.field_id = "gully_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")      
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")    
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")             
  
        # Manage tab visibility
        self.set_tabs_visibility()

        # Manage i18n
        self.translate_form(context_name)        
               
        # Fill the info table
        self.fill_table(self.tbl_element, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of info table
        self.set_configuration(self.tbl_element, table_element)
       
        # Fill the tab Document
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        
        # Configuration of document table
        self.set_configuration(self.tbl_document, table_document)
        
        # Set signals                  
        self.dialog.findChild(QPushButton, "btn_element_delete").clicked.connect(partial(self.delete_records, self.tbl_element, table_element))                 
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))                   
            
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: Event, Log
        self.tab_main.removeTab(4) 
        self.tab_main.removeTab(3)      
          
