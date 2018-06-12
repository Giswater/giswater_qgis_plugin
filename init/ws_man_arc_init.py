"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QLineEdit, QAction, QComboBox
from qgis.core import QgsExpression, QgsFeatureRequest

from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    """ Function called when a connec is identified in the map """
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction    
    feature_dialog = ManArcDialog(dialog, layer, feature)
    init_config()
    
    
def init_config():
    pass
     
     
class ManArcDialog(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """
        
        self.geom_type = "arc"        
        self.field_id = "arc_id"
        self.id = utils_giswater.getWidgetText(dialog, self.field_id, False)
        super(ManArcDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        self.controller.manage_translation('ws_man_arc', dialog)
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            

    def init_config_form(self):
        """ Custom form initial configuration """

        # Define class variables
        self.filter = self.field_id+" = '"+str(self.id)+"'"
        self.connec_type = utils_giswater.getWidgetText(self.dialog, "cat_arctype_id", False)
        self.connecat_id = utils_giswater.getWidgetText(self.dialog, "arccat_id", False)
        self.arccat_id = self.dialog.findChild(QLineEdit, 'arccat_id')
        
        # Get widget controls
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_arc")
        self.tbl_price_arc = self.dialog.findChild(QTableView, "tbl_price_arc")
        self.tbl_relations = self.dialog.findChild(QTableView, "tbl_relations")           
        self.btn_node_class1 = self.dialog.findChild(QPushButton, "btn_node_class1")
        self.btn_node_class2 = self.dialog.findChild(QPushButton, "btn_node_class2")
        state_type = self.dialog.findChild(QComboBox, 'state_type')
        dma_id = self.dialog.findChild(QComboBox, 'dma_id')
        presszonecat_id = self.dialog.findChild(QComboBox, 'presszonecat_id')

        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, 'ws', 'arc'))
        
        # Manage buttons node forms
        self.set_button_node_form()
        self.set_button_node_form()

        feature = self.feature
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        self.dialog.findChild(QAction, "actionCopyPaste").setEnabled(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, self.dialog, True))
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(partial(self.action_copy_paste, self.geom_type))
        
        # Manage tab 'Relations'
        self.manage_tab_relations("v_ui_arc_x_relations", "arc_id")   

        # Manage 'image'
        self.set_image(self.dialog, "label_image_ws_shape")
        
        # Check if exist URL from field 'link' in main tab
        self.check_link(self.dialog)

        # Check if feature has geometry object and we are creating a new arc
        geometry = self.feature.geometry()    
        if geometry and self.id == 'NULL':        
            # Fill fields node_1 and node_2
            self.get_nodes()                    
        
        # Manage tab signal
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False        
        self.tab_cost_loaded = False        
        self.tab_relations_loaded = False           
        self.tab_custom_fields_loaded = False
        self.tab_main.currentChanged.connect(self.tab_activation)

        # Load default settings
        widget_id = self.dialog.findChild(QLineEdit, 'arc_id')
        if utils_giswater.getWidgetText(self.dialog, widget_id).lower() == 'null':
            self.load_default(self.dialog)
            cat_id = self.controller.get_layer_source_table_name(layer)
            cat_id = cat_id.replace('v_edit_man_', '')
            cat_id += 'cat_vdefault'
            self.load_type_default(self.dialog, "arccat_id", cat_id)

        self.load_state_type(self.dialog, state_type, self.geom_type)
        self.load_dma(self.dialog, dma_id, self.geom_type)
        self.load_pressure_zone(self.dialog, presszonecat_id, self.geom_type)


    def get_nodes(self):
        """ Fill fields node_1 and node_2 """
                     
        # Get start and end points
        polyline = self.feature.geometry().asPolyline()
        start_point = polyline[0]  
        end_point = polyline[len(polyline)-1]         
        
        # Get parameter 'arc_searchnodes' from config table
        arc_searchnodes = 1
        sql = "SELECT arc_searchnodes FROM " + self.schema_name + ".config"
        row = self.controller.get_row(sql)
        if row:
            arc_searchnodes = row[0] 
                
        # Get closest node from selected points
        node_1 = self.get_node_from_point(start_point, arc_searchnodes)
        node_2 = self.get_node_from_point(end_point, arc_searchnodes)

        # Fill fields node_1 and node_2
        utils_giswater.setText(self.dialog, "node_1", node_1)
        utils_giswater.setText(self.dialog, "node_2", node_2)
                    

    def open_node_form(self, idx):
        """ Open form corresponding to start or end node of the current arc """

        field_node = "node_" + str(idx)
        widget = self.dialog.findChild(QLineEdit, field_node)
        node_id = utils_giswater.getWidgetText(self.dialog, widget)
        if not widget:    
            self.controller.log_info("widget not found", parameter=field_node)                 
            return
        
        # get pointer of node by ID
        aux = "\"node_id\" = "
        aux += "'" + str(node_id) + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            return

        # List of nodes from node_type_cat_type - nodes which we are using
        for feature_cat in self.feature_cat.itervalues():
            if feature_cat.type == 'NODE':
                layer = self.controller.get_layer_by_layername(feature_cat.layername)
                if layer:
                    # Get a featureIterator from this expression:
                    it = layer.getFeatures(QgsFeatureRequest(expr))
                    id_list = [i for i in it]
                    if id_list != []:
                        self.iface.openFeatureForm(layer, id_list[0])

        
    def set_button_node_form(self):
        """ Set signals of buttons that open start and node form """
        
        btn_node_1 = self.dialog.findChild(QPushButton, "btn_node_1")
        btn_node_2 = self.dialog.findChild(QPushButton, "btn_node_2")
        if btn_node_1:
            btn_node_1.clicked.connect(partial(self.open_node_form, 1))
        else:
            self.controller.log_info("widget not found", parameter="btn_node_1")
            
        if btn_node_2:
            btn_node_2.clicked.connect(partial(self.open_node_form, 2))
        else:
            self.controller.log_info("widget not found", parameter="btn_node_2")
        

    def tab_activation(self):
        """ Call functions depend on tab selection """
        
        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()   
            
        # Tab 'Custom fields'
        if index_tab == 1 and not self.tab_custom_fields_loaded:
            self.tab_custom_fields_loaded = self.fill_tab_custom_fields()

        # Tab 'Relations'    
        if index_tab == (2 - self.tabs_removed) and not self.tab_relations_loaded:           
            self.fill_tab_relations()           
            self.tab_relations_loaded = True                
            
        # Tab 'Element'    
        elif index_tab == (3 - self.tabs_removed) and not self.tab_element_loaded:
            self.fill_tab_element()           
            self.tab_element_loaded = True 
            
        # Tab 'Document'    
        elif index_tab == (4 - self.tabs_removed) and not self.tab_document_loaded:
            self.fill_tab_document()           
            self.tab_document_loaded = True 
            
        # Tab 'O&M'    
        elif index_tab == (5 - self.tabs_removed) and not self.tab_om_loaded:
            self.fill_tab_om()           
            self.tab_om_loaded = True  
              
        # Tab 'Cost'    
        elif index_tab == (6 - self.tabs_removed) and not self.tab_cost_loaded:
            self.fill_tab_cost()           
            self.tab_cost_loaded = True               
            

    def fill_tab_element(self):
        """ Fill tab 'Element' """
        
        table_element = "v_ui_element_x_arc" 
        self.fill_tbl_element_man(self.dialog, self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)
                        

    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_arc"          
        self.fill_tbl_document_man(self.dialog, self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_arc = "v_ui_om_visit_x_arc"        
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_arc, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_visit_event)
        self.set_configuration(self.tbl_event, table_event_arc)


    def set_image(self, dialog, widget):
        utils_giswater.setImage(dialog, widget, "ws_shape.png")
    

    def fill_tab_cost(self):
        """ Fill tab 'Cost' """
        
        # Get values from database        
        sql = ("SELECT arc_id, y1, y2, mean_y, z1, z2,thickness,width,b,bulk,geom1,area,y_param,total_y, rec_y, geom1_ext,"
               "calculed_y, m3mlexc,m2mltrenchl,m2mlbottom, m2mlpav,m3mlprotec,m3mlfill,m3mlexcess,m3exc_cost,m2trenchl_cost,"
               "m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost,trenchl_cost,"
               "base_cost,protec_cost,fill_cost,excess_cost,arc_cost,cost,length,budget,other_budget,total_budget"
               " FROM " + self.schema_name + ".v_plan_arc"
               " WHERE arc_id = '" + self.id + "'")    
        row = self.controller.get_row(sql)
        if row is None: 
            return
        
        # Match column names with widget names
        columns = []            
        for i in range(0, len(row)):
            column_name = self.controller.dao.get_column_name(i)
            columns.append(column_name)  
        for column_name in columns:                                      
            utils_giswater.setWidgetText(column_name, str(row[column_name]))

        utils_giswater.setWidgetText("arc_cost_2", str(row["arc_cost"]))
        utils_giswater.setWidgetText("m2pavement_cost", str(row["m2pav_cost"]))
        utils_giswater.setWidgetText("m2mlpavement", str(row["m2mlpav"]))
        utils_giswater.setWidgetText("other_budget", str(row["other_budget"]))
        utils_giswater.setWidgetText("m3mlexc_2", str(row["m3mlexc"]))
        utils_giswater.setWidgetText("m3mlfill_2", str(row["m3mlfill"]))
        utils_giswater.setWidgetText("m3mlexcess_2", str(row["m3mlexcess"]))
        utils_giswater.setWidgetText("m2mltrenchl_2", str(row["m2mltrenchl"]))
        utils_giswater.setWidgetText("m2mlbottom_2", str(row["m2mlbottom"]))
        utils_giswater.setWidgetText("b_2", str(row["b"]))

            # Get additional values
        sql_common = ("SELECT descript FROM " + self.schema_name + ".v_price_x_arc"
                      " WHERE arc_id = '" + self.id + "'")
            
        element = None
        m2bottom = None
        m3protec = None
        
        sql = sql_common + " AND identif = 'element'"         
        row = self.controller.get_row(sql)
        if row:
            element = row[0]

        sql = sql_common + " AND identif = 'm2bottom'"          
        row = self.controller.get_row(sql)
        if row:
            m2bottom = row[0]
        
        sql = sql_common + " AND identif = 'm3protec'"          
        row = self.controller.get_row(sql)
        if row:
            m3protec = row[0]
        
        utils_giswater.setWidgetText("arc_element", element)
        utils_giswater.setWidgetText("arc_bottom", m2bottom)
        utils_giswater.setWidgetText("arc_protection", m3protec)
        
        m3exc = None
        m3fill = None
        m3excess = None
        m2trenchl = None
        
        sql = sql_common + " AND identif = 'm3exc'" 
        row = self.controller.get_row(sql)
        if row:
            m3exc = row[0]
        
        sql = sql_common + " AND identif = 'm3fill'"         
        row = self.controller.get_row(sql)
        if row:
            m3fill = row[0]
        
        sql = sql_common + " AND identif = 'm3excess'"         
        row = self.controller.get_row(sql)
        if row:
            m3excess = row[0]
        
        sql = sql_common + " AND identif = 'm2trenchl'"            
        row = self.controller.get_row(sql)
        if row:
            m2trenchl = row[0]
        
        utils_giswater.setWidgetText("soil_excavation", m3exc)
        utils_giswater.setWidgetText("soil_filling", m3fill)
        utils_giswater.setWidgetText("soil_excess", m3excess)
        utils_giswater.setWidgetText("soil_trenchlining", m2trenchl)

        
    def fill_tab_relations(self):
        """ Fill tab 'Relations' """
                             
        table_relations = "v_ui_arc_x_relations"        
        self.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)     
        self.set_configuration(self.tbl_relations, table_relations)


    def fill_tab_custom_fields(self):
        """ Fill tab 'Custom fields' """

        cat_arctype_id = self.dialog.findChild(QLineEdit, 'cat_arctype_id')
        cat_feature_id = utils_giswater.getWidgetText(cat_arctype_id)
        if cat_feature_id.lower() == "null":
            msg = "In order to manage custom fields, that field has to be set"
            self.controller.show_info(msg, parameter="'arc_type'", duration=10)
            return False
        self.manage_custom_fields(cat_feature_id)
        return True

