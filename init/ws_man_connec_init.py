"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QAbstractItemView
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QLineEdit, QComboBox

import webbrowser
from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    """ Function called when a connec is identified in the map """

    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManConnecDialog(dialog, layer, feature)
    init_config(dialog)

    
def init_config(dialog):

    # Manage 'connec_type'
    connec_type = utils_giswater.getWidgetText(dialog, "connec_type")
    utils_giswater.setSelectedItem(dialog, "connec_type", connec_type)
     
    # Manage 'connecat_id'
    connecat_id = utils_giswater.getWidgetText(dialog, "connecat_id")
    utils_giswater.setSelectedItem(dialog, "connecat_id", connecat_id)
        
     
class ManConnecDialog(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """

        self.layer = layer
        self.feature = feature
        self.geom_type = "connec"
        self.field_id = "connec_id"        
        self.id = utils_giswater.getWidgetText(dialog, self.field_id, False)
        super(ManConnecDialog, self).__init__(dialog, layer, feature)
        self.init_config_form()
        self.controller.manage_translation('ws_man_connec', dialog)
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            
        
    def init_config_form(self):
        """ Custom form initial configuration """
              
        # Define class variables
        self.filter = self.field_id + " = '" + str(self.id) + "'"                       
        self.connecat_id = self.dialog.findChild(QLineEdit, 'connecat_id')

        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_connec") 
        self.tbl_hydrometer = self.dialog.findChild(QTableView, "tbl_hydrometer") 
        self.tbl_hydrometer_value = self.dialog.findChild(QTableView, "tbl_hydrometer_value")
        state_type = self.dialog.findChild(QComboBox, 'state_type')
        dma_id = self.dialog.findChild(QComboBox, 'dma_id')
        presszonecat_id = self.dialog.findChild(QComboBox, 'presszonecat_id')

        self.tbl_hydrometer.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.tbl_hydrometer.clicked.connect(self.check_url)
        
        # Check if exist URL from field 'link' in main tab
        self.check_link(self.dialog)

        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, self.dialog, 'ws', 'connec'))
        self.dialog.findChild(QPushButton, "btn_new_workcat").clicked.connect(partial(self.cf_new_workcat, self.dialog))

        open_link = self.dialog.findChild(QPushButton, "open_link")
        utils_giswater.setWidgetEnabled(self.dialog, "open_link", False)
        open_link.clicked.connect(self.open_url)
        
        feature = self.feature
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        action.setChecked(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, self.feature, self.canvas, self.layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered, self.feature, self.canvas, self.layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, self.layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, self.feature, self.canvas, self.layer))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, self.dialog, self.dialog, True))
        
        # Manage tab signal
        self.tab_hydrometer_loaded = False        
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False            
        self.tab_custom_fields_loaded = False
        self.tab_main.currentChanged.connect(self.tab_activation)            

        # Load default settings
        widget_id = self.dialog.findChild(QLineEdit, 'connec_id')
        if utils_giswater.getWidgetText(self.dialog, widget_id).lower() == 'null':
            self.load_default(self.dialog)
            cat_id = self.controller.get_layer_source_table_name(layer)
            cat_id = cat_id.replace('v_edit_man_', '')
            cat_id += 'cat_vdefault'
            self.load_type_default(self.dialog, "connecat_id", cat_id)

        self.load_state_type(self.dialog, state_type, self.geom_type)
        self.load_dma(self.dialog, dma_id, self.geom_type)
        self.load_pressure_zone(self.dialog ,presszonecat_id, self.geom_type)


    def check_url(self):
        """ Check URL. Enable/Disable button that opens it """
        
        selected_list = self.tbl_hydrometer.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()
        url = self.tbl_hydrometer.model().record(row).value("hydrometer_link")
        if url != '':
            self.url = url
            utils_giswater.setWidgetEnabled(self.dialog, "open_link")
        else:
            utils_giswater.setWidgetEnabled(self.dialog, "open_link", False)


    def open_url(self):
        """ Open URL """
        webbrowser.open(self.url)
        

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
            
        # Tab 'Hydrometer'    
        elif index_tab == (3 - self.tabs_removed) and not self.tab_hydrometer_loaded:           
            self.fill_tab_hydrometer()           
            self.tab_hydrometer_loaded = True               
            
        # Tab 'Document'    
        elif index_tab == (4 - self.tabs_removed) and not self.tab_document_loaded:
            self.fill_tab_document()           
            self.tab_document_loaded = True 
            
        # Tab 'O&M'    
        elif index_tab == (5 - self.tabs_removed) and not self.tab_om_loaded:
            self.fill_tab_om()           
            self.tab_om_loaded = True  
                      
        
    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydrometer = "v_rtc_hydrometer"    
        table_hydrometer_value = "v_edit_rtc_hydro_data_x_connec"    
        self.fill_tbl_hydrometer(self.tbl_hydrometer, self.schema_name + "." + table_hydrometer, self.filter)
        self.set_configuration(self.tbl_hydrometer, table_hydrometer)
        self.fill_tbl_hydrometer(self.tbl_hydrometer_value, self.schema_name + "." + table_hydrometer_value, self.filter)
        self.set_configuration(self.tbl_hydrometer_value, table_hydrometer_value)
        self.dialog.findChild(QPushButton, "btn_delete_hydrometer").clicked.connect(partial(self.delete_records_hydro, self.tbl_hydrometer))               
        self.dialog.findChild(QPushButton, "btn_add_hydrometer").clicked.connect(self.insert_records)        
       
            
    def fill_tab_element(self):
        """ Fill tab 'Element' """
        
        table_element = "v_ui_element_x_connec" 
        self.fill_tbl_element_man(self.dialog, self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)


    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_connec"  
        self.fill_tbl_document_man(self.dialog, self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_connec = "v_ui_om_visit_x_connec"    
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_connec, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_visit_event)
        self.set_configuration(self.tbl_event, table_event_connec)


    def fill_tab_custom_fields(self):
        """ Fill tab 'Custom fields' """

        connectype_id = self.dialog.findChild(QLineEdit, "connectype_id")
        cat_feature_id = utils_giswater.getWidgetText(self.dialog, connectype_id)
        if cat_feature_id.lower() == "null":
            msg = "In order to manage custom fields, that field has to be set"
            self.controller.show_info(msg, parameter="'connec_type'", duration=10)
            return False
        self.manage_custom_fields(cat_feature_id)
        return True

