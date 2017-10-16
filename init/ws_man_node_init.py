'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QTableView, QTabWidget, QAction, QComboBox, QLineEdit
from PyQt4.QtCore import Qt, QPoint, QObject, QEvent, pyqtSignal
from qgis.core import QgsExpression, QgsFeatureRequest, QgsPoint
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.gallery import Gallery              #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom     #@UnresolvedImport
from init.thread import Thread


def formOpen(dialog, layer, feature):
    ''' Function called when a feature is identified in the map '''
    
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
        ''' Constructor class '''
        super(ManNodeDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        #self.controller.manage_translation('ws_man_node', dialog)   


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
      
        table_element = "v_ui_element_x_node" 
        table_document = "v_ui_doc_x_node"   
        table_costs = "v_price_x_node"
        
        table_event_node = "v_ui_om_visit_x_node"
        table_scada = "v_rtc_scada"    
        table_scada_value = "v_rtc_scada_value"
        
        # Initialize variables               
        self.table_tank = self.schema_name+'."v_edit_man_tank"'
        self.table_pump = self.schema_name+'."v_edit_man_pump"'
        self.table_source = self.schema_name+'."v_edit_man_source"'
        self.table_meter = self.schema_name+'."v_edit_man_meter"'
        self.table_junction = self.schema_name+'."v_edit_man_junction"'
        self.table_manhole = self.schema_name+'."v_edit_man_manhole"'
        self.table_reduction = self.schema_name+'."v_edit_man_reduction"'
        self.table_hydrant = self.schema_name+'."v_edit_man_hydrant"'
        self.table_valve = self.schema_name+'."v_edit_man_valve"'
        self.table_waterwell = self.schema_name+'."v_edit_man_waterwell"'
        self.table_filter = self.schema_name+'."v_edit_man_filter"'
              
        # Define class variables
        self.field_id = "node_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"    
        self.nodecat_id = self.dialog.findChild(QLineEdit, 'nodecat_id')
        self.node_type = self.dialog.findChild(QComboBox, 'node_type')                             
        
        # Get widget controls   
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value")
        self.tbl_costs = self.dialog.findChild(QTableView, "tbl_masterplan")
              
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
        
        # Fill the table Costs
        self.fill_table(self.tbl_costs, self.schema_name+"."+table_costs, self.filter)
        
        # Configuration of table Costs
        self.set_configuration(self.tbl_costs, table_element)

        # Set signals
#         self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))
#         self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))
        nodetype_id = self.dialog.findChild(QLineEdit, "nodetype_id")
        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, 'ws', 'node', nodetype_id.text()))
        self.feature_cat_id = nodetype_id.text()

        feature = self.feature
        canvas = self.iface.mapCanvas()
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        if layer.isEditable():
            action.setChecked(True)
        else:
            action.setChecked(False)
            self.dialog.findChild(QAction, "actionCopyPaste").setEnabled(False)
            self.dialog.findChild(QAction, "actionRotation").setEnabled(False)
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionRotation").triggered.connect(self.action_rotation)
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(self.action_copy_paste)
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))
        # Set snapping
        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Event
#         self.btn_open_event = self.dialog.findChild(QPushButton, "btn_open_event")
#         self.btn_open_event.clicked.connect(self.open_selected_event_from_table)

        # Manage custom fields                                     
        self.manage_custom_fields(self.feature_cat_id, 18)
        
        # Manage tab visibility
        self.set_tabs_visibility(17)        
        
        # Check topology for new features
        continue_insert = True        
        node_over_node = True     
        check_topology_node = self.controller.plugin_settings_value("check_topology_node", "0")
        check_topology_arc = self.controller.plugin_settings_value("check_topology_arc", "0")
         
        # Check if feature has geometry object
        geometry = self.feature.geometry()   
        if geometry:
            if self.id.upper() == 'NULL' and check_topology_node == "0":
                (continue_insert, node_over_node) = self.check_topology_node()    
            
            if continue_insert and not node_over_node:           
                if self.id.upper() == 'NULL' and check_topology_arc == "0":
                    self.check_topology_arc()           
            
            # Create thread    
            thread1 = Thread(self, self.controller, 3)
            thread1.start()  


    def check_topology_arc(self):
        """ Check topology: Inserted node is over an existing arc? """
       
        # Initialize plugin parameters
        self.controller.plugin_settings_set_value("check_topology_arc", "0")       
        self.controller.plugin_settings_set_value("close_dlg", "0")
        
        # Get parameter 'node2arc' from config table
        node2arc = 1
        sql = "SELECT node2arc FROM " + self.schema_name + ".config"
        row = self.controller.get_row(sql)
        if row:
            node2arc = row[0] 
                
        # Get selected coordinates. Set SQL to check topology  
        srid = self.controller.plugin_settings_value('srid')
        point = self.feature.geometry().asPoint()
        sql = "SELECT arc_id, state FROM " + self.schema_name + ".v_edit_arc" 
        sql += " WHERE ST_Intersects(ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + "), "
        sql += " ST_Buffer(the_geom, " + str(node2arc) + "))" 
        sql += " ORDER BY ST_Distance(ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + "), the_geom) LIMIT 1"     
        #self.controller.log_info(sql)
        row = self.controller.get_row(sql)
        if row:
            msg = "We have detected you are trying to divide an arc with state " + str(row['state'])
            msg += "\nRemember that:"
            msg += "\n\nIn case of arc has state 0, you are allowed to insert a new node, because state 0 has not topology rules, and as a result arc will not be broken."
            msg += "\nIn case of arc has state 1, only nodes with state=1 can be part of node1 or node2 from arc. If the new node has state 0 or state 2 arc will be broken."
            msg += "\nIn case of arc has state 2, nodes with state 1 or state 2 are enabled. If the new node has state 0 arc will not be broken"
            msg += "\n\nWould you like to continue?"          
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
        
        # Get parameter 'node_proximity' from config table
        node_proximity = 1
        sql = "SELECT node_proximity FROM " + self.schema_name + ".config"
        row = self.controller.get_row(sql)
        if row:
            node_proximity = row[0] 
                
        # Get selected coordinates. Set SQL to check topology  
        srid = self.controller.plugin_settings_value('srid')
        point = self.feature.geometry().asPoint()       
        sql = "SELECT node_id, state FROM " + self.schema_name + ".v_edit_node" 
        sql += " WHERE ST_Intersects(ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + "), "
        sql += " ST_Buffer(the_geom, " + str(node_proximity) + "))" 
        sql += " ORDER BY ST_Distance(ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + "), the_geom) LIMIT 1"           
        #self.controller.log_info(sql)
        row = self.controller.get_row(sql)
        if row:
            node_over_node = True
            msg = "We have detected you are trying to insert one node over another node with state " + str(row['state'])
            msg += "\nRemember that:"
            msg += "\n\nIn case of old or new node has state 0, you are allowed to insert new one, because state 0 has not topology rules."
            msg += "\nIn the rest of cases, remember that the state topology rules of Giswater only enables one node with the same state at the same position."
            msg += "\n\nWould you like to continue?"          
            answer = self.controller.ask_question(msg, "Insert node over node?")
            if answer:      
                self.controller.plugin_settings_set_value("check_topology_node", "1")
            else:
                self.controller.plugin_settings_set_value("close_dlg", "1")
                continue_insert = False
        
        return (continue_insert, node_over_node)              
        
                    
    def open_selected_event_from_table(self):
        ''' Button - Open EVENT | gallery from table event '''

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
        row = self.dao.get_row(sql)

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
    
        self.emit_point.canvasClicked.connect(self.get_coordinates)      
        
        
    def get_coordinates(self, point, btn):   #@UnusedVariable
        
        layer_name = self.iface.activeLayer().name()
        table = "v_edit_man_"+str(layer_name.lower())
        
        sql = "SELECT ST_X(the_geom),ST_Y(the_geom)"
        sql+= " FROM "+self.schema_name+"."+table
        sql+= " WHERE node_id = '"+self.id+"'"
        rows = self.controller.get_rows(sql)
        existing_point_x = rows[0][0]
        existing_point_y = rows[0][1]
             
        sql = "UPDATE "+self.schema_name+".node "
        sql+= " SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point("+str(point.x())+","+str(point.y())+"), "
        sql+= " ST_Point("+str(existing_point_x)+","+str(existing_point_y)+"))))"
        sql+= " WHERE node_id ='"+str(self.id)+"'"      
        status = self.controller.execute_sql(sql)
        
        if status: 
            message = "Hemisphere is updated for node "+str(self.id)
            self.controller.show_info(message, context_name='ui_message')

    def action_copy_paste(self):
                          
        self.emit_point.canvasClicked.connect(self.manage_snapping)      
        
        
    def manage_snapping(self, point):    
                         
        # Get node of snapping
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)
                     
        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:
            for snapped_point in result:
                if snapped_point.layer.name() == self.iface.activeLayer().name():
                    # Get only one feature
                    point = QgsPoint(snapped_point.snappedVertex)   #@UnusedVariable
                    snapped_feature = next(snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                    snapped_feature_attr = snapped_feature.attributes()
                    # Leave selection
                    snapped_point.layer.select([snapped_point.snappedAtGeometry])
                    break
        
        aux = "\"node_id\" = "
        aux += "'" + str(self.id) + "'"         
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)            
            return    
            
        layer = self.iface.activeLayer()
        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i for i in it]
        
        if id_list != []:
            
            # id_list[0]: pointer on current feature
            id_current = id_list[0].attribute('node_id')
            
            message = "Selected snapped node to copy values from: " + str(snapped_feature_attr[0]) + "\n"
            message+= "Do you want to copy its values to the current node?\n\n"
            # Replace id because we don't have to copy it!
            snapped_feature_attr[0] = id_current
            for i in range(1, len(fields)):
                message += str(fields[i].name())+": " +str(snapped_feature_attr[i]) + "\n" 

            # Show message before executing
            answer = self.controller.ask_question(message, "Update records", None)

            # If ok execute and refresh form 
            if answer:
                id_list[0].setAttributes(snapped_feature_attr)
                layer.updateFeature(id_list[0])
                layer.commitChanges()
                self.dialog.refreshFeature()
