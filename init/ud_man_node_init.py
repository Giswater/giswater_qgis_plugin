"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsExpression, QgsFeatureRequest
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QTableView, QTabWidget, QAction, QComboBox, QLineEdit, QAbstractItemView
from PyQt4.QtCore import Qt
from PyQt4.QtSql import QSqlQueryModel

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.gallery import Gallery              #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom     #@UnresolvedImport
import ExtendedQLabel


def formOpen(dialog, layer, feature):
    """ Function called when a connec is identified in the map """
    
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
    
     
class ManNodeDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """
        super(ManNodeDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        #self.controller.manage_translation('ud_man_node', dialog) 
        if dialog.parent():
            dialog.parent().setFixedSize(640, 720)
            
        
    def init_config_form(self):
        """ Custom form initial configuration """
              
        # Define class variables
        self.field_id = "node_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id + " = '" + str(self.id) + "'"                    
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")  
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value") 
        self.tbl_costs = self.dialog.findChild(QTableView, "tbl_masterplan")
        
        # Tables
        self.tbl_upstream = self.dialog.findChild(QTableView, "tbl_upstream")
        self.tbl_upstream.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells
        self.tbl_downstream = self.dialog.findChild(QTableView, "tbl_downstream")
        self.tbl_downstream.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, 'ud', 'node'))

        btn_open_upstream = self.dialog.findChild(QPushButton, "btn_open_upstream")
        btn_open_upstream.clicked.connect(partial(self.open_up_down_stream, self.tbl_upstream))

        btn_open_downstream = self.dialog.findChild(QPushButton, "btn_open_downstream")
        btn_open_downstream.clicked.connect(partial(self.open_up_down_stream, self.tbl_downstream))

        feature = self.feature
        layer = self.iface.activeLayer()
        
        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        action.setChecked(layer.isEditable())
        self.dialog.findChild(QAction, "actionCopyPaste").setEnabled(layer.isEditable())
        self.dialog.findChild(QAction, "actionRotation").setEnabled(layer.isEditable())
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, self.canvas, layer))
        self.dialog.findChild(QAction, "actionHelp").triggered.connect(partial(self.action_help, 'ud', 'node'))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))
        geom_type = 'node'
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(partial(self.action_copy_paste, geom_type))
        self.nodecat_id = self.dialog.findChild(QLineEdit, 'nodecat_id')
        self.node_type = self.dialog.findChild(QComboBox, 'node_type')

        self.feature_cat = {}
        self.project_read()
        
        # Manage custom fields   
        tab_custom_fields = 11
        self.manage_custom_fields(tab_to_remove= tab_custom_fields)
        
        # Manage tab visibility
        self.set_tabs_visibility(tab_custom_fields - 1)

        # Set autocompleter
        tab_main = self.dialog.findChild(QTabWidget, "tab_main")
        cmb_workcat_id = tab_main.findChild(QComboBox, str(tab_main.tabText(0).lower()) + "_workcat_id")
        cmb_workcat_id_end = tab_main.findChild(QComboBox, str(tab_main.tabText(0).lower()) + "_workcat_id_end")
        self.set_autocompleter(cmb_workcat_id)
        self.set_autocompleter(cmb_workcat_id_end)

        self.fill_tables(self.tbl_upstream, "v_ui_node_x_connection_upstream")
        self.fill_tables(self.tbl_downstream, "v_ui_node_x_connection_downstream")
        
        # Manage tab signal
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False        
        self.tab_scada_loaded = False        
        self.tab_cost_loaded = False        
        self.tab_main.currentChanged.connect(self.tab_activation)           


    def fill_tables(self, qtable, table_name):
        """
        :param qtable: QTableView to show
        :param table_name: view or table name wich we want to charge
        """
        sql = "SELECT * FROM " + self.controller.schema_name + "." + table_name
        sql += " WHERE node_id = '" + self.id + "'"
        model = QSqlQueryModel()
        model.setQuery(sql)
        qtable.setModel(model)
        qtable.show()


    def open_up_down_stream(self, qtable):
        """ Open selected node from @qtable """
        
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()
        feature_id = qtable.model().record(row).value("feature_id")
        featurecat_id = qtable.model().record(row).value("featurecat_id")
        
        # Get sys_feature_cat.id from cat_feature.id
        sql = "SELECT sys_feature_cat.id FROM " + self.controller.schema_name + ".cat_feature"
        sql += " INNER JOIN " + self.controller.schema_name + ".sys_feature_cat ON cat_feature.system_id = sys_feature_cat.id"
        sql += " WHERE cat_feature.id = '" + featurecat_id + "'"
        row = self.controller.get_row(sql)
        if not row:
            return
        
        layer = self.get_layer(row[0])            
        if layer:
            field_id = self.controller.get_layer_primary_key(layer)             
            aux = "\"" + field_id+ "\" = "
            aux += "'" + str(feature_id) + "'"
            expr = QgsExpression(aux)                  
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message)
                return    
                                                      
            it = layer.getFeatures(QgsFeatureRequest(expr))
            features = [i for i in it]                                
            if features != []:                
                self.controller.log_info(str(features[0]))                 
                self.iface.openFeatureForm(layer, features[0])
        else:
            self.controller.log_info("Layer not found", parameter=row[0])                 


    def open_selected_event_from_table(self):
        """ Button - Open EVENT | gallery from table event """

        # Get selected rows
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node")
        selected_list = self.tbl_event.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return

        row = selected_list[0].row()
        self.visit_id = self.tbl_event.model().record(row).value("visit_id")
        self.event_id = self.tbl_event.model().record(row).value("event_id")
        
        # Get all events | pictures for visit_id
        sql = "SELECT value FROM "+self.schema_name+".v_ui_om_visit_x_node"
        sql +=" WHERE visit_id = '"+str(self.visit_id)+"'"
        rows = self.controller.get_rows(sql)

        # Get absolute path
        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'doc_absolute_path'"
        row = self.controller.get_row(sql)

        self.img_path_list = []
        self.img_path_list1D = []
        # Creates a list containing 5 lists, each of 8 items, all set to 0

        # Fill 1D array with full path
        if row is None:
            message = "Parameter not set in table 'config_param_system'"
            self.controller.show_warning(message, parameter='doc_absolute_path')
            return
        else:
            for value in rows:
                full_path = str(row[0])+str(value[0])
                #self.img_path_list.append(full_path)
                self.img_path_list1D.append(full_path)
         
        # Create the dialog and signals
        self.dlg_gallery = Gallery()
        utils_giswater.setDialog(self.dlg_gallery)
        
        txt_visit_id = self.dlg_gallery.findChild(QLineEdit, 'visit_id')
        txt_visit_id.setText(str(self.visit_id))
        
        txt_event_id = self.dlg_gallery.findChild(QLineEdit, 'event_id')
        txt_event_id.setText(str(self.event_id))
        
        # Add picture to gallery
       
        # Fill one-dimensional array till the end with "0"
        self.num_events = len(self.img_path_list1D) 
        
        limit = self.num_events%9
        for k in range(0, limit):   # @UnusedVariable
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = self.num_events / 9+1
        columns = 9 
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)] # @UnusedVariable
        message = str(self.img_path_list)
        self.controller.show_warning(message, context_name='ui_message')
        # Convert one-dimensional array to two-dimensional array
        idx = 0 
        if rows == 1:
            for br in range(0,len(self.img_path_list1D)):
                self.img_path_list[0][br]=self.img_path_list1D[br]
        else:
            for h in range(0,rows):
                for r in range(0,columns):
                    self.img_path_list[h][r]=self.img_path_list1D[idx]    
                    idx=idx+1

        # List of pointers(in memory) of clicableLabels
        self.list_widgetExtended=[]
        self.list_labels=[]
        
        for i in range(0, 9):
            # Set image to QLabel
            pixmap = QPixmap(str(self.img_path_list[0][i]))
            pixmap = pixmap.scaled(171,151,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)

            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)

            # Set QLabel like ExtendedQLabel(ClickableLabel)
            self.widget_extended = ExtendedQLabel.ExtendedQLabel(widget)
            self.widget_extended.setPixmap(pixmap)
            self.start_indx = 0
            
            # Set signal of ClickableLabel   
            #self.dlg_gallery.connect(self.widget_extended, SIGNAL('clicked()'), (partial(self.zoom_img,i)))
            self.widget_extended.clicked.connect(partial(self.zoom_img, i))            
            self.list_widgetExtended.append(self.widget_extended)
            self.list_labels.append(widget)
      
        self.start_indx = 0
        self.btn_next = self.dlg_gallery.findChild(QPushButton, "btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        
        self.btn_previous = self.dlg_gallery.findChild(QPushButton, "btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
        
        self.dlg_gallery.exec_()
        
        
    def next_gallery(self):

        self.start_indx = self.start_indx + 1
        
        # Clear previous
        for i in self.list_widgetExtended:
            i.clear()
  
        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            
            self.list_widgetExtended[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx > 0 :
            self.btn_previous.setEnabled(True) 
            
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)
     
        control = len(self.img_path_list1D)/9
        if self.start_indx == (control-1):
            self.btn_next.setEnabled(False)
            
        
    def zoom_img(self,i):
       
        handelerIndex = i    
        
        self.dlg_gallery_zoom = GalleryZoom()
        pixmap = QPixmap(self.img_path_list[self.start_indx][i])
  
        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom") 
        self.lbl_img.setPixmap(pixmap)
            
        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id") 
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id") 
        
        zoom_visit_id.setText(str(self.visit_id))
        zoom_event_id.setText(str(self.event_id))
    
        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious") 
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext") 
        
        self.i = i
        self.btn_slidePrevious.clicked.connect(self.slide_previous)
        self.btn_slideNext.clicked.connect(self.slide_next)
        
        self.dlg_gallery_zoom.exec_() 
        
        # Controling start index
        if handelerIndex != i:
            self.start_indx = self.start_indx+1
        
        
    def slide_previous(self):

        indx = (self.start_indx*9) + self.i - 1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        
        self.i = self.i-1
        
        # Control sliding buttons
        if indx == 0 :
            self.btn_slidePrevious.setEnabled(False) 
            
        if indx < (self.num_events-1):
            self.btn_slideNext.setEnabled(True) 

        
    def slide_next(self):
  
        indx = (self.start_indx*9)+self.i+1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i = self.i+1
    
        # Control sliding buttons
        if indx > 0 :
            self.btn_slidePrevious.setEnabled(True) 
            
        if indx == (self.num_events - 1):
            self.btn_slideNext.setEnabled(False) 

        
    def previous_gallery(self):
        
        self.start_indx = self.start_indx-1
        
        # First clear previous
        for i in self.list_widgetExtended:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            self.list_widgetExtended[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)

        control = len(self.img_path_list1D)/9
        if self.start_indx < (control-1):
            self.btn_next.setEnabled(True)


    def set_snapping(self):
        
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        

    def action_rotation(self):

        self.set_snapping()
        self.emit_point.canvasClicked.connect(self.get_coordinates)


    def get_coordinates(self, point, btn):  # @UnusedVariable

        layer_name = self.iface.activeLayer().name()
        table = "v_edit_man_" + str(layer_name.lower())

        sql = "SELECT ST_X(the_geom), ST_Y(the_geom)"
        sql += " FROM " + self.schema_name + "." + table
        sql += " WHERE node_id = '" + self.id + "'"
        row = self.controller.get_row(sql)
        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]

        sql = "UPDATE " + self.schema_name + ".node "
        sql += " SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point(" + str(existing_point_x) + "," + str(existing_point_y) + "), "
        sql += " ST_Point(" + str(point.x()) + ", " + str(point.y()) + "))))"
        sql += " WHERE node_id = '" + str(self.id) + "'"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Hemisphere is updated for node " + str(self.id)
            self.controller.show_info(message, context_name='ui_message')

        sql = "(SELECT degrees(ST_Azimuth(ST_Point(" + str(existing_point_x) + "," + str(existing_point_y) + "), "
        sql += " ST_Point(" + str(point.x()) + ", " + str(point.y()) + "))))"
        row = self.controller.get_row(sql)
        utils_giswater.setWidgetText(str(layer_name.lower()) + "_hemisphere", str(row[0]))


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
                      
        # Tab 'Scada'    
        elif tab_caption.lower() == 'scada' and not self.tab_scada_loaded:
            self.fill_tab_scada()           
            self.tab_scada_loaded = True   
              
        # Tab 'Cost'    
        elif tab_caption.lower() == 'cost' and not self.tab_cost_loaded:
            self.fill_tab_cost()           
            self.tab_cost_loaded = True     
            
            
    def fill_tab_element(self):
        """ Fill tab 'Element' """
        
        table_element = "v_ui_element_x_node" 
        self.fill_table(self.tbl_element, self.schema_name + "." + table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)       
                        

    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_node"       
        self.fill_tbl_document_man(self.tbl_document, self.schema_name + "." + table_document, self.filter)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        self.set_configuration(self.tbl_document, table_document)         
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
                
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_node = "v_ui_om_visit_x_node"     
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_node, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        self.set_configuration(self.tbl_event, table_event_node)
        
            
    def fill_tab_scada(self):
        """ Fill tab 'Scada' """
        
        pass
        #table_scada = "v_rtc_scada"    
        #table_scada_value = "v_rtc_scada_value"    
        #self.fill_tbl_hydrometer(self.tbl_scada, self.schema_name+"."+table_scada, self.filter)
        #self.set_configuration(self.tbl_scada, table_scada)
        #self.fill_tbl_hydrometer(self.tbl_scada_value, self.schema_name+"."+table_scada_value, self.filter)
        #self.set_configuration(self.tbl_scada_value, table_scada_value)
        
        
    def fill_tab_cost(self):
        """ Fill tab 'Cost' """
              
        table_costs = "v_price_x_node"        
        self.fill_table(self.tbl_costs, self.schema_name + "." + table_costs, self.filter)
        self.set_configuration(self.tbl_costs, table_costs)        
                                
    