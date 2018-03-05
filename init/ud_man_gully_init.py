"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QTableView, QTabWidget, QAction, QLineEdit, QComboBox

from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    """ Function called when a gully is identified in the map """
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManGullyDialog(dialog, layer, feature)
    init_config()

    
def init_config():
     
    # Manage 'gratecat_id'
    gratecat_id = utils_giswater.getWidgetText("gratecat_id") 
    utils_giswater.setSelectedItem("gratecat_id", gratecat_id) 

    # Manage 'arccat_id'
    arccat_id = utils_giswater.getWidgetText("arccat_id") 
    utils_giswater.setSelectedItem("arccat_id", arccat_id)    
    
     
class ManGullyDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """
        super(ManGullyDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        #self.controller.manage_translation('ud_man_gully', dialog) 
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            
        
    def init_config_form(self):
        """ Custom form initial configuration """
              
        # Define class variables
        self.geom_type = "gully"      
        self.field_id = "gully_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.gully_type = utils_giswater.getWidgetText("arccat_id", False)        
        self.gratecat_id = utils_giswater.getWidgetText("gratecat_id", False) 
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")  
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_gully") 
        state_type = self.dialog.findChild(QComboBox, 'state_type')
        dma_id = self.dialog.findChild(QComboBox, 'dma_id')

        feature = self.feature
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        action.setChecked(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, self.canvas, layer))
        # self.dialog.findChild(QAction, "actionHelp").triggered.connect(partial(self.action_help, 'ud', 'gully'))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))
        
        # Manage custom fields    
        cat_feature_id = utils_giswater.getWidgetText(self.gully_type)   
        tab_custom_fields = 1
        self.manage_custom_fields(cat_feature_id, tab_custom_fields)
        
        # Check if exist URL from field 'link' in main tab
        self.check_link()        
                
        # Manage tab signal     
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False            
        self.tab_main.currentChanged.connect(self.tab_activation)

        # Load default settings
        widget_id = self.dialog.findChild(QLineEdit, 'gully_id')
        if utils_giswater.getWidgetText(widget_id).lower() == 'null':
            self.load_default()
            #self.load_type_default("nodecat_id", layer)

        self.load_state_type(state_type, self.geom_type)
        self.load_dma(dma_id, self.geom_type)


    def tab_activation(self):
        """ Call functions depend on tab selection """
        
        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        tab_caption = self.tab_main.tabText(index_tab)    
              
        # Tab 'Element'    
        if tab_caption.lower() == 'element' and not self.tab_element_loaded:
            self.fill_tab_element()           
            self.tab_element_loaded = True 
            
        # Tab 'Document'    
        elif tab_caption.lower() == 'document' and not self.tab_document_loaded:
            self.fill_tab_document()           
            self.tab_document_loaded = True 
            
        # Tab 'O&M'    
        elif tab_caption.lower() == 'o&&m' and not self.tab_om_loaded:
            self.fill_tab_om()           
            self.tab_om_loaded = True 
                      

    def fill_tab_element(self):
        """ Fill tab 'Element' """
        
        table_element = "v_ui_element_x_gully" 
        self.fill_tbl_element_man(self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)
        self.set_table_columns(self.tbl_element, table_element)


    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_gully"  
        self.fill_tbl_document_man(self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        self.set_table_columns(self.tbl_document, table_document)
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_gully = "v_ui_om_visit_x_gully"    
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_gully, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        self.set_configuration(self.tbl_event, table_event_gully)       
        
        