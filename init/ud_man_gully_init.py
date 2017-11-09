'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction

from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
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
        ''' Constructor class '''
        super(ManGullyDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        #self.controller.manage_translation('ud_man_gully', dialog) 
        if dialog.parent():
            dialog.parent().setFixedSize(615, 755)
            
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
        table_element = "v_ui_element_x_gully" 
        table_document = "v_ui_doc_x_gully"   
        table_event_gully = "v_ui_om_visit_x_gully"
              
        # Define class variables
        self.field_id = "gully_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.gully_type = utils_giswater.getWidgetText("arccat_id", False)        
        self.gratecat_id = utils_giswater.getWidgetText("gratecat_id", False) 
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")  
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_gully") 

        # Load data from related tables
        self.load_data()
        
        # Fill the info table
        self.fill_table(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of info table
        self.set_configuration(self.tbl_info, table_element)    
        
        # Fill the tab Document
        self.fill_tbl_document_man(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # Configuration of table Document
        self.set_configuration(self.tbl_document, table_document)
        
        # Fill tab event 
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_gully, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        
        # Configuration of table event
        self.set_configuration(self.tbl_event, table_event_gully)
        
        # Set signals          
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        #self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))       
        
        feature = self.feature
        canvas = self.iface.mapCanvas()
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        action.setChecked(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, canvas, layer))
        # self.dialog.findChild(QAction, "actionHelp").triggered.connect(partial(self.action_help, 'ud', 'gully'))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))
        
        # TODO: Manage custom fields    
        tab_custom_fields = 1
        self.manage_custom_fields(tab_to_remove=tab_custom_fields)

        # Set autocompleter
        tab_main = self.dialog.findChild(QTabWidget, "tab_main")
        cmb_workcat_id = tab_main.findChild(QComboBox, str(tab_main.tabText(0).lower()) + "_workcat_id")
        cmb_workcat_id_end = tab_main.findChild(QComboBox, str(tab_main.tabText(0).lower()) + "_workcat_id_end")
        self.set_autocompleter(cmb_workcat_id)
        self.set_autocompleter(cmb_workcat_id_end)
                
