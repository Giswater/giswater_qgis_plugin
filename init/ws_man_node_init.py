'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QTableView, QTabWidget, QAction, QComboBox, QLineEdit
from PyQt4.QtCore import Qt, QObject, QPoint
from qgis.core import QgsExpression, QgsFeatureRequest, QgsPoint
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.gallery import Gallery              #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom     #@UnresolvedImport
import ExtendedQLabel


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
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
        dialog.parent().setFixedSize(625, 720)
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
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
        
        # Get widget controls   
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value")  
        self.tbl_costs = self.dialog.findChild(QTableView, "tbl_masterplan")
        
        # Manage tab visibility
        self.set_tabs_visibility(16)
              
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
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))
        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(partial(self.catalog, 'ws', 'node'))

        feature = self.feature
        canvas = self.iface.mapCanvas()
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnable")
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionRotation").triggered.connect(self.action_rotation)
        self.dialog.findChild(QAction, "actionCopyPaste").triggered.connect(self.action_copy_paste)

        self.nodecat_id = self.dialog.findChild(QLineEdit, 'nodecat_id')
        self.node_type = self.dialog.findChild(QComboBox, 'node_type')
        
        # Event
        #self.btn_open_event = self.dialog.findChild(QPushButton,"btn_open_event")
        #self.btn_open_event.clicked.connect(self.open_selected_event_from_table)

        
    def open_selected_event_from_table(self):
        ''' Button - Open EVENT | gallery from table event '''

        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node")
        # Get selected rows
        selected_list = self.tbl_event.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return

        #for i in range(0, len(selected_list)):
        row = selected_list[0].row()
        #id_ = self.tbl_event.model().record(row).value("visit_id")
        self.visit_id = self.tbl_event.model().record(row).value("visit_id")
        self.event_id = self.tbl_event.model().record(row).value("event_id")
        picture = self.tbl_event.model().record(row).value("value")
        #inf_text+= str(id_)+", "
        #inf_text = inf_text[:-2]
        #self.visit_id = inf_text 
        
        # Get all events | pictures for visit_id
        sql = "SELECT value FROM "+self.schema_name+".v_ui_om_visit_x_node"
        sql +=" WHERE visit_id = '"+str(self.visit_id)+"'"
        rows = self.controller.get_rows(sql)

        # Get absolute path
        sql = "SELECT value FROM "+self.schema_name+".config_param_text"
        sql +=" WHERE id = 'doc_absolute_path'"
        row = self.dao.get_row(sql)
        n = int((len(rows)/9)+1)

        self.img_path_list = []
        self.img_path_list1D = []
        # Creates a list containing 5 lists, each of 8 items, all set to 0


        # Fill 1D array with full path
        if row is None:
            message = "Check doc_absolute_path in table config_param_text, value does not exist or is not defined!"
            self.dao.show_warning(message, context_name='ui_message')
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
        for k in range(0, limit):
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = self.num_events/9+1
        columns = 9 
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)]
        message = str(self.img_path_list)
        self.controller.show_warning(message, context_name='ui_message')
        # Convert one-dimensional array to two-dimensional array
        idx = 0
        '''
        for h in range(0,rows):
            for r in range(0,columns):
                self.img_path_list[h][r]=self.img_path_list1D[idx]    
                idx=idx+1
        '''     
        if rows == 1:
            for br in range(0,len(self.img_path_list1D)):
                self.img_path_list[0][br]=self.img_path_list1D[br]
        else :
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
            self.widgetExtended = ExtendedQLabel.ExtendedQLabel(widget)
 
            self.widgetExtended.setPixmap(pixmap)
            self.start_indx = 0
            # Set signal of ClickableLabel   

            self.dlg_gallery.connect( self.widgetExtended, SIGNAL('clicked()'), (partial(self.zoom_img,i)))
  
            self.list_widgetExtended.append(self.widgetExtended)
            self.list_labels.append(widget)
      
        self.start_indx = 0
        #self.end_indx = len(self.img_path_list)-1
        self.btn_next = self.dlg_gallery.findChild(QPushButton,"btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        
        self.btn_previous = self.dlg_gallery.findChild(QPushButton,"btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
        
        self.dlg_gallery.exec_()
        
        
    def next_gallery(self):

        self.start_indx = self.start_indx+1
        
        # Clear previous
        for i in self.list_widgetExtended:
            i.clear()
            #i.clicked.disconnect(self.zoom_img) #this disconnect all!
  
        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171,151,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)
            
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

        handelerIndex=i    
        
        self.dlg_gallery_zoom = GalleryZoom()
        #pixmap = QPixmap(img)
        pixmap = QPixmap(self.img_path_list[self.start_indx][i])
        #pixmap = pixmap.scaled(711,501,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)
  
        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom") 
        self.lbl_img.setPixmap(pixmap)
        #lbl_img.show()
            
        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id") 
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id") 
        
        zoom_visit_id.setText(str(self.visit_id))
        zoom_event_id.setText(str(self.event_id))
    
        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious") 
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext") 
        
        self.i=i
        self.btn_slidePrevious.clicked.connect(self.slide_previous)
        self.btn_slideNext.clicked.connect(self.slide_next)
        
        self.dlg_gallery_zoom.exec_() 
        
        # Controling start index
        if handelerIndex != i:
            self.start_indx = self.start_indx+1
        
        
    def slide_previous(self):
    
        #indx=self.i-1
        indx=(self.start_indx*9)+self.i-1

        pixmap = QPixmap(self.img_path_list1D[indx])

        self.lbl_img.setPixmap(pixmap)
        
        self.i=self.i-1
        
        # Control sliding buttons
        if indx == 0 :
            self.btn_slidePrevious.setEnabled(False) 
            
        if indx < (self.num_events-1):
            self.btn_slideNext.setEnabled(True) 

        
    def slide_next(self):

        #indx=self.i+1 
        indx=(self.start_indx*9)+self.i+1
        
        pixmap = QPixmap(self.img_path_list1D[indx])

        self.lbl_img.setPixmap(pixmap)
        
        self.i=self.i+1
    
        # Control sliding buttons
        if indx > 0 :
            self.btn_slidePrevious.setEnabled(True) 
            
        if indx == (self.num_events-1):
            self.btn_slideNext.setEnabled(False) 

        
    def previous_gallery(self):
    
        #self.end_indx = self.end_indx-1
        self.start_indx = self.start_indx-1
        
        
        # First clear previous
        for i in self.list_widgetExtended:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171,151,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)
            
            self.list_widgetExtended[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)

            
        control = len(self.img_path_list1D)/9
        if self.start_indx < (control-1):
            self.btn_next.setEnabled(True)
            
     
    def action_rotation(self):
    
        mapCanvas = self.iface.mapCanvas()
        self.emitPoint = QgsMapToolEmitPoint(mapCanvas)
        mapCanvas.setMapTool(self.emitPoint)
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.get_coordinates)
        
        
    def get_coordinates(self, point, btn):

        canvas = self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(canvas)
       
        x = point.x()
        y = point.y()
        
        layer = self.iface.activeLayer().name()
        table = "v_edit_man_"+str(layer.lower())
        
        sql = "SELECT ST_X(the_geom),ST_Y(the_geom)"
        sql+= " FROM "+self.schema_name+"."+table
        sql+= " WHERE node_id = '"+self.id+"'"
        rows = self.controller.get_rows(sql)
        
        existing_point_x = rows[0][0]
        existing_point_y = rows[0][1]
        existing_point = str(QPoint(existing_point_x,existing_point_y))
   
        # coordinates of existing node , coordinates of new selection
        #sql = "SELECT degrees(ST_Azimuth(ST_Point(25, 45), ST_Point(75, 100)))" 
        #hemisphere = "SELECT degrees(ST_Azimuth(ST_Point("+str(x)+","+str(y)+"), ST_Point("+str(existing_point_x)+","+str(existing_point_y)+")))" 
             
        #sql = "UPDATE '"+self.schema_name+"'.node SET hemisphere='"+str(hemisphere)+"' WHERE node_id ='"+str(self.id)+"'" 
        sql = "UPDATE "+self.schema_name+".node SET hemisphere =(SELECT degrees(ST_Azimuth(ST_Point("+str(x)+","+str(y)+"), ST_Point("+str(existing_point_x)+","+str(existing_point_y)+")))) WHERE node_id ='"+str(self.id)+"'"
        status = self.controller.execute_sql(sql)
        
        if status : 
            message = "Hemisphere is updated for node "+str(self.id)
            self.controller.show_info(message, context_name='ui_message')
        
             
    def action_copy_paste(self):
        
        # Activate snapping
        mapCanvas = self.iface.mapCanvas()
        self.emitPoint = QgsMapToolEmitPoint(mapCanvas)
        mapCanvas.setMapTool(self.emitPoint)

        self.canvas = self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.manage_snapping)
      
      
    def manage_snapping(self, point, btn):
     
        #currentTool = self.iface.mapCanvas().mapTool()
        # Get node of snapping
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)
                     
        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

            # Check feature
            for snapPoint in result:
                
                if snapPoint.layer.name() == self.iface.activeLayer().name():
                
                    # Get the point
                    point = QgsPoint(snapPoint.snappedVertex)   #@UnusedVariable
                    snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                    feature = snappFeat
                    
                    #element_id = feature.attribute('state')
                    element_id = feature.attribute('node_id')
                    feature_attributes = feature.attributes()
                    
                    
                    #Delete firts element : node_id because we dont want to copy id 
                    
                    #feature_attributes.pop(0)

                    # LEAVE SELECTION
                    snapPoint.layer.select([snapPoint.snappedAtGeometry])

                    break

        # Copy
        layer = self.iface.activeLayer()

        provider = layer.dataProvider()
        # Fields of attribute table
        fields = provider.fields()
        #for field in fields:
        
        # Get feature for the form 
        # Get pointer of node by ID

        aux = "\"node_id\" = "
        aux += "'" + str(self.id) + "', "
        aux = aux[:-2] 
         
        expr = QgsExpression(aux)
        layer = self.iface.activeLayer()
        layer.startEditing()
        
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i for i in it]
        
        n = len(fields)
        message = ""
        if id_list != []:
            
            
            # id_list[0]: pointer on current feature
            id_current=id_list[0].attribute('node_id')
            # Replace id 
            feature_attributes[0]=id_current
            
            '''
            message = "Do you want to update these values for node" + str(self.id) + str(feature_attributes)
            self.controller.show_info(message, context_name='ui_message' )
            '''
            
            # Show message before executing
            for i in range(0,n):
                message += str(fields[i].name())+":" +str(feature_attributes[i]) + "\n" 
            #self.controller.ask_question(message, context_name='ui_message' )
            answer = self.controller.ask_question(message, "Update records", None)

            # If ok execute and refresh form 
            # If cancel return
            if answer:
                id_list[0].setAttributes(feature_attributes)
                layer.updateFeature(id_list[0])
                layer.commitChanges()
                # Restart forms 
                self.close()
                self.iface.openFeatureForm(layer,id_list[0])
                #self.layer.reload()
                #self.canvas.refresh()
                #self.iface.refresh()

