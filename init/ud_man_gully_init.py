"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QTableView, QTabWidget, QAction, QLineEdit, QComboBox

from functools import partial

import utils_giswater
from giswater.parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    """ Function called when a gully is identified in the map """
    
    global feature_dialog
    # Create class to manage Feature Form interaction
    feature_dialog = ManGullyDialog(dialog, layer, feature)
    init_config(dialog)

    
def init_config(dialog):
     
    # Manage 'gratecat_id'
    gratecat_id = utils_giswater.getWidgetText(dialog, "gratecat_id")
    utils_giswater.setSelectedItem(dialog, "gratecat_id", gratecat_id)

    # Manage 'arccat_id'
    arccat_id = utils_giswater.getWidgetText(dialog, "arccat_id")
    utils_giswater.setSelectedItem(dialog, "arccat_id", arccat_id)
    
     
class ManGullyDialog(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """

        self.geom_type = "gully"      
        self.field_id = "gully_id"        
        self.id = utils_giswater.getWidgetText(dialog, self.field_id, False)
        super(ManGullyDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        self.dlg_is_destroyed = False
        #self.controller.manage_translation('ud_man_gully', dialog) 
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            
        
    def init_config_form(self):
        """ Custom form initial configuration """
              
        # Define class variables
        self.filter = self.field_id + " = '" + str(self.id) + "'"
        self.gratecat_id = utils_giswater.getWidgetText(self.dialog, "gratecat_id", False)

        # Get user permisions
        role_basic = self.controller.check_role_user("role_basic")

        # Get widget controls
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")  
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_gully") 
        state_type = self.dialog.findChild(QComboBox, 'state_type')
        dma_id = self.dialog.findChild(QComboBox, 'dma_id')

        feature = self.feature
        layer = self.iface.activeLayer()

        self.dialog.destroyed.connect(partial(self.dlg_destroyed, layer=layer))

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, self.canvas, layer))
        if not role_basic:
            action.setChecked(layer.isEditable())
            layer.editingStarted.connect(partial(self.check_actions, action, True))
            layer.editingStopped.connect(partial(self.check_actions, action, False))
            self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, self.layer))
        else:
            action.setEnabled(False)
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, self.dialog, True))
        
        # Check if exist URL from field 'link' in main tab
        self.check_link(self.dialog)
                
        # Manage tab signal     
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False            
        self.tab_custom_fields_loaded = False
        self.tab_main.currentChanged.connect(self.tab_activation)

        # Load default settings
        widget_id = self.dialog.findChild(QLineEdit, 'gully_id')
        if utils_giswater.getWidgetText(self.dialog, widget_id).lower() == 'null':
            self.load_default(self.dialog, "gully")

        self.load_state_type(self.dialog, state_type, self.geom_type)
        self.load_dma(self.dialog, dma_id, self.geom_type)


    def tab_activation(self):
        """ Call functions depend on tab selection """
        
        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()

        # Tab 'Custom fields'
        if index_tab == 1 and not self.tab_custom_fields_loaded:
            self.tab_custom_fields_loaded = self.fill_tab_custom_fields()
        
        # Tab 'Element'    
        if index_tab == (2 - self.tabs_removed) and not self.tab_element_loaded:
            self.fill_tab_element()           
            self.tab_element_loaded = True             
            
        # Tab 'Document'    
        elif index_tab == (3 - self.tabs_removed) and not self.tab_document_loaded:
            self.fill_tab_document()           
            self.tab_document_loaded = True 
            
        # Tab 'O&M'    
        elif index_tab == (4 - self.tabs_removed) and not self.tab_om_loaded:
            self.fill_tab_om()           
            self.tab_om_loaded = True  
                      

    def fill_tab_element(self):
        """ Fill tab 'Element' """
        
        table_element = "v_ui_element_x_gully" 
        self.fill_tbl_element_man(self.dialog, self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)


    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_gully"  
        self.fill_tbl_document_man(self.dialog, self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_gully = "v_ui_om_visit_x_gully"    
        self.fill_tbl_event(self.tbl_event, table_event_gully, self.filter)
        self.tbl_event.model().rowsInserted.connect(self.set_filter_table_event, self.tbl_event)
        self.tbl_event.model().rowsRemoved.connect(self.set_filter_table_event, self.tbl_event)
        self.tbl_event.doubleClicked.connect(self.open_visit_event)
        self.set_configuration(self.tbl_event, table_event_gully)


    def fill_tab_custom_fields(self):
        """ Fill tab 'Custom fields' """

        gully_type = self.dialog.findChild(QComboBox, "gully_type")
        cat_feature_id = utils_giswater.getWidgetText(self.dialog, gully_type)
        if cat_feature_id.lower() == "null":
            msg = "In order to manage custom fields, that field has to be set"
            self.controller.show_info(msg, parameter='gully_type', duration=10)
            return False
        self.manage_custom_fields(cat_feature_id)
        return True

