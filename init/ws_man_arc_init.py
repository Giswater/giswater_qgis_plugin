"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QLineEdit, QAction, QComboBox
from PyQt4.QtCore import Qt
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
        self.id = utils_giswater.getWidgetText(self.field_id, False)        
        super(ManArcDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        self.controller.manage_translation('ws_man_arc', dialog)
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            

    def init_config_form(self):
        """ Custom form initial configuration """

        # Define class variables
        self.filter = self.field_id+" = '"+str(self.id)+"'"
        self.connec_type = utils_giswater.getWidgetText("cat_arctype_id", False)
        self.connecat_id = utils_giswater.getWidgetText("arccat_id", False)
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
        action.setChecked(layer.isEditable())
        self.dialog.findChild(QAction, "actionCopyPaste").setEnabled(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(partial(self.action_copy_paste, self.geom_type))
        
        # Manage tab 'Relations'
        self.manage_tab_relations("v_ui_arc_x_relations", "arc_id")   

        # Manage 'image'
        self.set_image("label_image_ws_shape")		
        
        # Manage custom fields                      
        cat_arctype_id = self.dialog.findChild(QLineEdit, 'cat_arctype_id')        
        cat_feature_id = utils_giswater.getWidgetText(cat_arctype_id)        
        tab_custom_fields = 1
        self.manage_custom_fields(cat_feature_id, tab_custom_fields)        
        
        # Check if exist URL from field 'link' in main tab
        self.check_link()

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
        self.tab_main.currentChanged.connect(self.tab_activation)

        # Load default settings
        widget_id = self.dialog.findChild(QLineEdit, 'arc_id')
        if utils_giswater.getWidgetText(widget_id).lower() == 'null':
            self.load_default()
            cat_id = self.controller.get_layer_source_table_name(layer)
            cat_id = cat_id.replace('v_edit_man_', '')
            cat_id += 'cat_vdefault'
            self.load_type_default("arccat_id", cat_id)

        self.load_state_type(state_type, self.geom_type)
        self.load_dma(dma_id, self.geom_type)
        self.load_pressure_zone(presszonecat_id, self.geom_type)


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
        utils_giswater.setText("node_1", node_1)
        utils_giswater.setText("node_2", node_2)
                    

    def open_node_form(self, idx):
        """ Open form corresponding to start or end node of the current arc """

        field_node = "node_" + str(idx)
        widget = self.dialog.findChild(QLineEdit, field_node)        
        node_id = utils_giswater.getWidgetText(widget)           
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
        self.fill_tbl_element_man(self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)
                        

    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_arc"          
        self.fill_tbl_document_man(self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_arc = "v_ui_om_visit_x_arc"        
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_arc, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_visit_event)
        self.set_configuration(self.tbl_event, table_event_arc)
		

    def set_image(self, widget):
        utils_giswater.setImage(widget, "ws_shape_png")
    
	
    def fill_tab_cost(self):
        """ Fill tab 'Cost' """
		
        arc_cost = self.dialog.findChild(QLineEdit, "arc_cost")
        cost_unit = self.dialog.findChild(QLineEdit, "cost_unit")
        arc_cost_2 = self.dialog.findChild(QLineEdit, "arc_cost_2")
        m2mlbottom = self.dialog.findChild(QLineEdit, "m2mlbottom")
        m2bottom_cost = self.dialog.findChild(QLineEdit, "m2bottom_cost")
        m3protec_cost = self.dialog.findChild(QLineEdit, "m3protec_cost")
        m3exc_cost = self.dialog.findChild(QLineEdit, "m3exc_cost")
        m3fill_cost = self.dialog.findChild(QLineEdit, "m3fill_cost")
        m3excess_cost = self.dialog.findChild(QLineEdit, "m3excess_cost")
        m2trenchl_cost = self.dialog.findChild(QLineEdit, "m2trenchl_cost")
        m2pavement_cost = self.dialog.findChild(QLineEdit, "m2pavement_cost")
        m3mlprotec = self.dialog.findChild(QLineEdit, "m3mlprotec")
        m3mlexc = self.dialog.findChild(QLineEdit, "m3mlexc")
        m3mlfill = self.dialog.findChild(QLineEdit, "m3mlfill")
        m3mlexcess = self.dialog.findChild(QLineEdit, "m3mlexcess")
        m2mlpavement = self.dialog.findChild(QLineEdit, "m2mlpavement")
        base_cost = self.dialog.findChild(QLineEdit, "base_cost")
        protec_cost = self.dialog.findChild(QLineEdit, "protec_cost")
        exc_cost = self.dialog.findChild(QLineEdit, "exc_cost")
        fill_cost = self.dialog.findChild(QLineEdit, "fill_cost")
        excess_cost = self.dialog.findChild(QLineEdit, "excess_cost")
        trenchl_cost = self.dialog.findChild(QLineEdit, "trenchl_cost")
        pav_cost = self.dialog.findChild(QLineEdit, "pav_cost")   
        cost = self.dialog.findChild(QLineEdit, "cost")     
        
        rec_y = self.dialog.findChild(QLineEdit, "rec_y")
        total_y = self.dialog.findChild(QLineEdit, "total_y") 
        
        m2mlpav = self.dialog.findChild(QLineEdit, "m2mlpav") 
        m2mlbottom_2 = self.dialog.findChild(QLineEdit, "m2mlbottom_2")    
        
        z1 = self.dialog.findChild(QLineEdit, "z11")
        z2 = self.dialog.findChild(QLineEdit, "z22")
        bulk = self.dialog.findChild(QLineEdit, "bulk")
        
        b = self.dialog.findChild(QLineEdit, "b")
        b_2 = self.dialog.findChild(QLineEdit, "b_2")
        y_param = self.dialog.findChild(QLineEdit, "y_param")
        m3mlfill_2 = self.dialog.findChild(QLineEdit, "m3mlfill_2")
        m3mlexc_2 = self.dialog.findChild(QLineEdit, "m3mlexc_2")
        m3mlexcess_2 = self.dialog.findChild(QLineEdit, "m3mlexcess_2")
        m2mltrenchl_2 = self.dialog.findChild(QLineEdit, "m2mltrenchl_2")
        thickness = self.dialog.findChild(QLineEdit, "thickness")
        m2mltrenchl = self.dialog.findChild(QLineEdit, "m2mltrenchl")
        width = self.dialog.findChild(QLineEdit, "width")
        length = self.dialog.findChild(QLineEdit, "length")
        budget = self.dialog.findChild(QLineEdit, "budget")
        other_budget = self.dialog.findChild(QLineEdit, "other_budget")
        total_budget = self.dialog.findChild(QLineEdit, "total_budget")

        dext = self.dialog.findChild(QLineEdit, "dext")
        area = self.dialog.findChild(QLineEdit, "area")
        dext.setText('None')
        area.setText('None')
        
        cost_unit.setText('None')
        arc_cost.setText('None')
        m2mlbottom.setText('None')    
        arc_cost_2.setText('None') 
        m2bottom_cost.setText('None')  
        m3protec_cost.setText('None') 
        m3exc_cost.setText('None') 
        m3excess_cost.setText('None')  
        m3fill_cost.setText('None') 
        m3mlexcess.setText('None') 
        m2trenchl_cost.setText('None')  
        m2mltrenchl_2.setText('None') 
        m3mlprotec.setText('None')  
        m3mlexc.setText('None') 
        m3mlfill.setText('None') 
        base_cost.setText('None') 
        protec_cost.setText('None') 
        exc_cost.setText('None')  
        fill_cost.setText('None') 
        excess_cost.setText('None') 
        trenchl_cost.setText('None') 
        pav_cost.setText('None')  
        cost.setText('None')  
        m2pavement_cost.setText('None') 
        m2mlpavement.setText('None') 
        
        rec_y.setText('None') 
        total_y.setText('None') 
        m2mlpav.setText('None') 
        m2mlbottom_2.setText('None') 

        z1.setText('None') 
        z2.setText('None') 
        bulk.setText('None') 
        b.setText('None') 
        b_2.setText('None') 
        y_param.setText('None') 
        m3mlfill_2.setText('None') 
        m3mlexc_2.setText('None') 
        m3mlexcess_2.setText('None') 
        m2mltrenchl_2.setText('None') 
        thickness.setText('None') 
        m2mltrenchl.setText('None') 
        width.setText('None') 
        
        # Get values from database        
        sql = "SELECT *"
        sql+= " FROM " + self.schema_name + ".v_plan_arc"
        sql+= " WHERE arc_id = '" + self.id + "'"    
        row = self.controller.get_row(sql)
        if row is None:
            return
        
        cost_unit.setText(str(row['cost_unit']))
        arc_cost.setText(str(row['arc_cost']))
        m2mlbottom.setText(str(row['m2mlbottom']))    
        arc_cost_2.setText(str(row['arc_cost'])) 
        m2bottom_cost.setText(str(row['m2bottom_cost'])) 
        m3protec_cost.setText(str(row['m3protec_cost'])) 
        m3exc_cost.setText(str(row['m3exc_cost'])) 
        m3excess_cost.setText(str(row['m3excess_cost'])) 
        m3fill_cost.setText(str(row['m3fill_cost'])) 
        m3mlexcess.setText(str(row['m3mlexcess'])) 
        m2trenchl_cost.setText(str(row['m2trenchl_cost'])) 
        m2mltrenchl_2.setText(str(row['m2mltrenchl'])) 
        m3mlprotec.setText(str(row['m3mlprotec'])) 
        m3mlexc.setText(str(row['m3mlexc'])) 
        m3mlfill.setText(str(row['m3mlfill'])) 
        base_cost.setText(str(row['base_cost'])) 
        protec_cost.setText(str(row['protec_cost'])) 
        exc_cost.setText(str(row['exc_cost'])) 
        fill_cost.setText(str(row['fill_cost'])) 
        excess_cost.setText(str(row['excess_cost'])) 
        trenchl_cost.setText(str(row['trenchl_cost'])) 
        pav_cost.setText(str(row['pav_cost']))   
        cost.setText(str(row['cost']))  
        m2pavement_cost.setText(str(row['m2pav_cost']))  
        m2mlpavement.setText(str(row['m2mlpav']))  
        
        rec_y.setText(str(row['rec_y']))
        total_y.setText(str(row['total_y']))
        m2mlpav.setText(str(row['m2mlpav']))
        m2mlbottom_2.setText(str(row['m2mlbottom']))
        
        dext.setText(str(row['geom1_ext']))
        area.setText(str(row['area']))

        z1.setText(str(row['z1']))
        z2.setText(str(row['z2']))
        bulk.setText(str(row['bulk']))
        b.setText(str(row['b']))
        b_2.setText(str(row['b']))
        y_param.setText(str(row['y_param']))
        m3mlfill_2.setText(str(row['m3mlfill']))
        m3mlexc_2.setText(str(row['m3mlexc']))
        m3mlexcess_2.setText(str(row['m3mlexcess']))
        m2mltrenchl_2.setText(str(row['m2mltrenchl']))
        thickness.setText(str(row['thickness']))
        m2mltrenchl.setText(str(row['m2mltrenchl']))
        width.setText(str(row['width']))
        length.setText(str(row['length']))
        budget.setText(str(row['budget']))
        other_budget.setText(str(row['other_budget']))
        total_budget.setText(str(row['total_budget']))

        # Set SQL
        sql_common = "SELECT descript FROM " + self.schema_name + ".v_price_x_arc"
        sql_common+= " WHERE arc_id = '" + self.id + "'" 
            
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
        
        arc_element = self.dialog.findChild(QLineEdit, "arc_element")
        arc_bottom = self.dialog.findChild(QLineEdit, "arc_bottom")
        arc_protection = self.dialog.findChild(QLineEdit, "arc_protection")
        
        arc_element.setText('None')
        arc_bottom.setText('None')
        arc_protection.setText('None')
        
        arc_element.setText(element)
        arc_element.setAlignment(Qt.AlignJustify)
        arc_bottom.setText(m2bottom)
        arc_bottom.setAlignment(Qt.AlignJustify)
        arc_protection.setText(m3protec)
        arc_protection.setAlignment(Qt.AlignJustify)
        
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
        
        soil_excavation = self.dialog.findChild(QLineEdit, "soil_excavation")
        soil_filling = self.dialog.findChild(QLineEdit, "soil_filling")
        soil_excess = self.dialog.findChild(QLineEdit, "soil_excess")
        soil_trenchlining = self.dialog.findChild(QLineEdit, "soil_trenchlining")
        
        soil_excavation.setText('None')
        soil_filling.setText('None')
        soil_excess.setText('None')
        soil_trenchlining.setText('None')
        
        soil_excavation.setText(m3exc)
        soil_excavation.setAlignment(Qt.AlignJustify)
        soil_filling.setText(m3fill)
        soil_filling.setAlignment(Qt.AlignJustify)
        soil_excess.setText(m3excess)
        soil_excess.setAlignment(Qt.AlignJustify)
        soil_trenchlining.setText(m2trenchl)
        soil_trenchlining.setAlignment(Qt.AlignJustify)
        
        
    def fill_tab_relations(self):
        """ Fill tab 'Relations' """
                             
        table_relations = "v_ui_arc_x_relations"        
        self.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)     
        self.set_configuration(self.tbl_relations, table_relations)
                
