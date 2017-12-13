"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QTableView, QTabWidget, QAction, QComboBox, QLineEdit
from PyQt4.QtCore import Qt, QObject, QEvent, pyqtSignal
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.gallery import Gallery              #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom     #@UnresolvedImport
from init.thread import Thread


def formOpen(dialog, layer, feature):
    """ Function called when a feature is identified in the map """
    
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
        # self.controller.manage_translation('ws_man_node', dialog)
        if dialog.parent():
            dialog.parent().setFixedSize(625, 660)
            

    def clickable(self, widget):

        class Filter(QObject):

            clicked = pyqtSignal()

            def eventFilter(self, obj, event):
                if obj == widget:
                    if event.type() == QEvent.MouseButtonRelease:
                        if obj.rect().contains(event.pos()):
                            self.clicked.emit()
                            return True

                return False

        filter_ = Filter(widget)
        widget.installEventFilter(filter_)
        return filter_.clicked   
        
                
    def init_config_form(self):
        """ Custom form initial configuration """
                 
        # Define class variables
        self.geom_type = "node"
        self.field_id = "node_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id + " = '" + str(self.id) + "'"    
        self.nodecat_id = self.dialog.findChild(QLineEdit, 'nodecat_id')
        self.pump_hemisphere = self.dialog.findChild(QLineEdit, 'pump_hemisphere')
        self.node_type = self.dialog.findChild(QComboBox, 'node_type')                             
        
        # Get widget controls   
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value")
        self.tbl_costs = self.dialog.findChild(QTableView, "tbl_masterplan")
              
        # Set signals
        nodetype_id = self.dialog.findChild(QLineEdit, "nodetype_id")
        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, 'ws', 'node', nodetype_id.text()))
        self.feature_cat_id = nodetype_id.text()

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
        self.dialog.findChild(QAction, "actionRotation").triggered.connect(self.action_rotation)
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(partial(self.action_copy_paste, self.geom_type))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))

        # Manage custom fields   
        tab_custom_fields = 1
        self.manage_custom_fields(self.feature_cat_id, tab_custom_fields)
        
        # Check if exist URL from field 'link' in main tab
        self.check_link() 

        # Check topology for new features
        continue_insert = True        
        node_over_node = True     
        check_topology_node = self.controller.plugin_settings_value("check_topology_node", "0")
        check_topology_arc = self.controller.plugin_settings_value("check_topology_arc", "0")
         
        # Check if feature has geometry object
        geometry = self.feature.geometry()   
        if geometry:
            if self.id.upper() == 'NULL' and check_topology_node == "0":
                self.get_topology_parameters()
                (continue_insert, node_over_node) = self.check_topology_node()    
            
            if continue_insert and not node_over_node:           
                if self.id.upper() == 'NULL' and check_topology_arc == "0":
                    self.check_topology_arc()           
            
            # Create thread    
            thread1 = Thread(self, self.controller, 3)
            thread1.start()  
            
        # Manage tab signal
        self.tab_element_loaded = False        
        self.tab_document_loaded = False        
        self.tab_om_loaded = False        
        self.tab_scada_loaded = False        
        self.tab_cost_loaded = False        
        self.tab_main.currentChanged.connect(self.tab_activation)             

        # Load default settings
        node_id = self.dialog.findChild(QLineEdit, 'node_id')
        if utils_giswater.getWidgetText(node_id).lower() == 'null':
            self.load_default()
            cat_id = self.controller.get_layer_source_table_name(layer)
            cat_id = cat_id.replace('v_edit_man_', '')
            cat_id += 'cat_vdefault'
            self.load_type_default("nodecat_id", cat_id)

        self.init_filters(self.dialog)


    def get_topology_parameters(self):
        """ Get parameters 'node_proximity' and 'node2arc' from config table """
        
        self.node_proximity = 0.5
        self.node2arc = 0.5
        sql = "SELECT node_proximity, node2arc FROM " + self.schema_name + ".config"
        row = self.controller.get_row(sql)
        if row:
            self.node_proximity = row['node_proximity'] 
            self.node2arc = row['node2arc']   
            
        
    def check_topology_arc(self):
        """ Check topology: Inserted node is over an existing arc? """
       
        # Initialize plugin parameters
        self.controller.plugin_settings_set_value("check_topology_arc", "0")       
        self.controller.plugin_settings_set_value("close_dlg", "0")
                        
        # Get selected srid and coordinates. Set SQL to check topology  
        srid = self.controller.plugin_settings_value('srid')
        point = self.feature.geometry().asPoint()
        node_geom = "ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + ")"
    
        sql = ("SELECT arc_id, state FROM " + self.schema_name + ".v_edit_arc"
               " WHERE ST_DWithin(" + node_geom + ", v_edit_arc.the_geom, " + str(self.node2arc) + ")"
               " ORDER BY ST_Distance(v_edit_arc.the_geom, " + node_geom + ")"
               " LIMIT 1")
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            msg = ("We have detected you are trying to divide an arc with state " + str(row['state']) + ""
                   "\nRemember that:"
                   "\n\nIn case of arc has state 0, you are allowed to insert a new node, because state 0 has not topology rules, and as a result arc will not be broken."
                   "\nIn case of arc has state 1, only nodes with state=1 can be part of node1 or node2 from arc. If the new node has state 0 or state 2 arc will be broken."
                   "\nIn case of arc has state 2, nodes with state 1 or state 2 are enabled. If the new node has state 0 arc will not be broken"
                   "\n\nWould you like to continue?")         
            answer = self.controller.ask_question(msg, "Divide intersected arc?")
            if answer:      
                self.controller.plugin_settings_set_value("check_topology_arc", "1")
            else:
                self.controller.plugin_settings_set_value("close_dlg", "1")


    def check_topology_node(self):
        """ Check topology: Inserted node is over an existing node? """
       
        node_over_node = False
        continue_insert = True
        
        # Initialize plugin parameters
        self.controller.plugin_settings_set_value("check_topology_node", "0")       
        self.controller.plugin_settings_set_value("close_dlg", "0")
                
        # Get selected srid and coordinates. Set SQL to check topology  
        srid = self.controller.plugin_settings_value('srid')
        point = self.feature.geometry().asPoint()  
        node_geom = "ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + ")"
                     
        sql = ("SELECT node_id, state FROM " + self.schema_name + ".v_edit_node" 
               " WHERE ST_Intersects(ST_Buffer(" + node_geom + ", " + str(self.node_proximity) + "), the_geom)"
               " ORDER BY ST_Distance(" + node_geom + ", the_geom)"
               " LIMIT 1")           
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            node_over_node = True
            msg = ("We have detected you are trying to insert one node over another node with state " + str(row['state']) + ""
                   "\nRemember that:"
                   "\n\nIn case of old or new node has state 0, you are allowed to insert new one, because state 0 has not topology rules."
                   "\nIn the rest of cases, remember that the state topology rules of Giswater only enables one node with the same state at the same position."
                   "\n\nWould you like to continue?")    
            answer = self.controller.ask_question(msg, "Insert node over node?")
            if answer:      
                self.controller.plugin_settings_set_value("check_topology_node", "1")
            else:
                self.controller.plugin_settings_set_value("close_dlg", "1")
                continue_insert = False
        
        return (continue_insert, node_over_node)              
        
                    
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
                full_path = str(row[0]) + str(value[0])
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

        limit = self.num_events % 9
        for k in range(0, limit):   # @UnusedVariable
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = self.num_events / 9+1
        columns = 9 
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)] # @UnusedVariable
        message = str(self.img_path_list)

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
        self.list_widget=[]
        self.list_labels=[]

        for i in range(0, 9):

            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            if widget:
                # Set image to QLabel
                pixmap = QPixmap(str(self.img_path_list[0][i]))
                pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
                widget.setPixmap(pixmap)
                self.start_indx = 0
                self.clickable(widget).connect(partial(self.zoom_img, i))
                self.list_widget.append(widget)
                self.list_labels.append(widget)
      
        self.start_indx = 0
        self.btn_next = self.dlg_gallery.findChild(QPushButton,"btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        self.btn_previous = self.dlg_gallery.findChild(QPushButton,"btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
        self.set_icon(self.btn_previous, "109")
        self.set_icon(self.btn_next, "108")
        self.btn_close = self.dlg_gallery.findChild(QPushButton, "btn_close")
        self.btn_close.clicked.connect(self.dlg_gallery.close)

        self.dlg_gallery.exec_()


    def next_gallery(self):

        self.start_indx = self.start_indx + 1
        # Clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171,151,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx > 0 :
            self.btn_previous.setEnabled(True) 
            
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)
     
        control = len(self.img_path_list1D) / 9
        if self.start_indx == (control-1):
            self.btn_next.setEnabled(False)


    def previous_gallery(self):

        self.start_indx = self.start_indx - 1

        # First clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx == 0:
            self.btn_previous.setEnabled(False)

        control = len(self.img_path_list1D) / 9
        if self.start_indx < (control - 1):
            self.btn_next.setEnabled(True)


    def zoom_img(self, i):

        handelerIndex = i

        self.dlg_gallery_zoom = GalleryZoom()
        pixmap = QPixmap(self.img_path_list[self.start_indx][i])

        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom")
        self.lbl_img.setPixmap(pixmap)
        #lbl_img.show()

        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id")
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id")

        zoom_visit_id.setText(str(self.visit_id))
        zoom_event_id.setText(str(self.event_id))

        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious")
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext")
        self.set_icon(self.btn_slidePrevious, "109")
        self.set_icon(self.btn_slideNext, "108")

        self.i = i
        self.btn_slidePrevious.clicked.connect(self.slide_previous)
        self.btn_slideNext.clicked.connect(self.slide_next)
        self.dlg_gallery_zoom.exec_() 
        
        # Controling start index
        if handelerIndex != i:
            self.start_indx = self.start_indx+1
        
        
    def slide_previous(self):
    
        indx = (self.start_indx*9) + self.i -1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i=self.i-1
        
        # Control sliding buttons
        if indx == 0 :
            self.btn_slidePrevious.setEnabled(False) 
            
        if indx < (self.num_events - 1):
            self.btn_slideNext.setEnabled(True) 

        
    def slide_next(self):

        indx = (self.start_indx*9) + self.i + 1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i = self.i + 1

        # Control sliding buttons
        if indx > 0 :
            self.btn_slidePrevious.setEnabled(True)

        if indx == (self.num_events - 1):
            self.btn_slideNext.setEnabled(False)
            
     
    def action_rotation(self):
    
        self.set_snapping()
        self.emit_point.canvasClicked.connect(self.get_coordinates)      
        
        
    def get_coordinates(self, point, btn):   #@UnusedVariable
        
        viewname = self.controller.get_layer_source_table_name(self.layer) 
        sql = ("SELECT ST_X(the_geom), ST_Y(the_geom)"
               " FROM " + self.schema_name + "." + viewname + ""
               " WHERE node_id = '" + self.id + "'")
        row = self.controller.get_row(sql)
        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]
             
        sql = ("UPDATE " + self.schema_name + ".node"
               " SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point(" + str(existing_point_x) + ", " + str(existing_point_y) + "), "
               " ST_Point(" + str(point.x()) + ", " + str(point.y()) + "))))"
               " WHERE node_id = '" + str(self.id) + "'")
        status = self.controller.execute_sql(sql)
        if not status:
            return

        sql = ("SELECT degrees(ST_Azimuth(ST_Point(" + str(existing_point_x) + ", " + str(existing_point_y) + "),"
               " ST_Point( " + str(point.x()) + ", " + str(point.y()) + ")))")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("hemisphere" , str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            self.controller.show_info(message, parameter=str(row[0]))


    def set_snapping(self):
        
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        

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
        if tab_caption.lower() == 'document' and not self.tab_document_loaded:
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
        self.fill_tbl_element_man(self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)  
                        

    def fill_tab_document(self):
        """ Fill tab 'Document' """
        
        table_document = "v_ui_doc_x_node"       
        self.fill_tbl_document_man(self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)   
        
            
    def fill_tab_om(self):
        """ Fill tab 'O&M' (event) """
        
        table_event_node = "v_ui_om_visit_x_node"     
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_node, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        self.set_configuration(self.tbl_event, table_event_node)
        
            
    def fill_tab_scada(self):
        """ Fill tab 'Scada' """
        
        table_scada = "v_rtc_scada"    
        table_scada_value = "v_rtc_scada_value"    
        self.fill_tbl_hydrometer(self.tbl_scada, self.schema_name+"."+table_scada, self.filter)
        self.set_configuration(self.tbl_scada, table_scada)
        self.fill_tbl_hydrometer(self.tbl_scada_value, self.schema_name+"."+table_scada_value, self.filter)
        self.set_configuration(self.tbl_scada_value, table_scada_value)
        
        
    def fill_tab_cost(self):
        """ Fill tab 'Cost' """
               
        table_costs = "v_price_x_node"        
        self.fill_table(self.tbl_costs, self.schema_name + "." + table_costs, self.filter)
        self.set_configuration(self.tbl_costs, table_costs)        
                    
            