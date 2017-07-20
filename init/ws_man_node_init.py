'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QMessageBox, QComboBox, QLineEdit, QDateEdit

from qgis.gui import *
from functools import partial
import os
import utils_giswater
from parent_init import ParentDialog
from ui.ws_catalog import WScatalog                  # @UnresolvedImport


from ui.gallery import Gallery          #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom          #@UnresolvedImport

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
        self.node_type = utils_giswater.getWidgetText("node_type", False)        
        self.nodecat_id = utils_giswater.getWidgetText("nodecat_id", False) 
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value")  
        self.tbl_costs = self.dialog.findChild(QTableView, "tbl_masterplan")
        #self.x=self.dialog.findChild(QDateEdit,"junction_builtdate")
        
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
        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(self.catalog)


        # Toolbar actions
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(self.actionZoom)
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(self.actionCentered)
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(self.actionEnabled)
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(self.actionZoomOut)


        # QLineEdit
        self.nodecat_id = self.dialog.findChild(QLineEdit, 'nodecat_id')
        # ComboBox
        self.node_type = self.dialog.findChild(QComboBox, 'node_type')
        
        # Event
        #self.btn_open_event = self.dialog.findChild(QPushButton,"btn_open_event")
        #self.btn_open_event.clicked.connect(self.open_selected_event_from_table)

    def actionZoomOut(self):
        feature = self.feature

        canvas = self.iface.mapCanvas()
        # Get the active layer (must be a vector layer)
        layer = self.iface.activeLayer()

        layer.setSelectedFeatures([feature.id()])

        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        
        
    def actionZoom(self):
       
        feature = self.feature

        canvas = self.iface.mapCanvas()
        # Get the active layer (must be a vector layer)
        layer = self.iface.activeLayer()

        layer.setSelectedFeatures([feature.id()])

        canvas.zoomToSelected(layer)
        canvas.zoomIn()
    
    
    def actionEnabled(self):
        #btn_enable_edit = self.dialog.findChild(QPushButton, "btn_enable_edit")
        self.actionEnable = self.dialog.findChild(QAction, "actionEnable")
        status = self.layer.startEditing()
        self.set_icon(self.actionEnable, status)


    def set_icon(self, widget, status):

        # initialize plugin directory
        user_folder = os.path.expanduser("~")
        self.plugin_name = 'iw2pg'
        self.plugin_dir = os.path.join(user_folder, '.qgis2/python/plugins/' + self.plugin_name)

        self.layer = self.iface.activeLayer()
        if status == True:

            self.layer.startEditing()

            widget.setActive(True)

        if status == False:
            self.layer.rollBack()

            
    def actionCentered(self):
        feature = self.feature
        canvas = self.iface.mapCanvas()
        # Get the active layer (must be a vector layer)
        layer = self.iface.activeLayer()

        layer.setSelectedFeatures([feature.id()])

        canvas.zoomToSelected(layer)

    def catalog(self):
        self.dlg_cat=WScatalog()
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()

        self.dlg_cat.findChild(QPushButton, "btn_ok").clicked.connect(self.fillTxtnodecat_id)
        self.dlg_cat.findChild(QPushButton, "btn_cancel").clicked.connect(self.dlg_cat.close)

        self.matcat_id=self.dlg_cat.findChild(QComboBox, "matcat_id")
        self.pnom = self.dlg_cat.findChild(QComboBox, "pnom")
        self.dnom = self.dlg_cat.findChild(QComboBox, "dnom")
        self.id = self.dlg_cat.findChild(QComboBox, "id")

        self.matcat_id.currentIndexChanged.connect(self.fillCbxCatalod_id)
        self.matcat_id.currentIndexChanged.connect(self.fillCbxpnom)
        self.matcat_id.currentIndexChanged.connect(self.fillCbxdnom)

        self.pnom.currentIndexChanged.connect(self.fillCbxCatalod_id)
        self.pnom.currentIndexChanged.connect(self.fillCbxdnom)

        self.dnom.currentIndexChanged.connect(self.fillCbxCatalod_id)


        self.matcat_id.clear()
        self.pnom.clear()
        self.dnom.clear()

        node_type = self.node_type.currentText()
        sql= "SELECT DISTINCT(matcat_id) FROM ws_sample_dev.cat_node WHERE nodetype_id='"+node_type+ "'"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)


        sql= "SELECT DISTINCT(pnom) FROM ws_sample_dev.cat_node WHERE nodetype_id='"+node_type+ "'"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.pnom, rows)

        #SELECT DISTINCT(regexp_replace(trim(' nm'from dnom),'-','', 'g')::int)as x FROM ws_sample_dev.cat_node ORDER BY x
        sql = "SELECT dnom FROM  (SELECT DISTINCT(regexp_replace(trim(' nm'from dnom),'-','', 'g')::int)as x, dnom FROM ws_sample_dev.cat_node ORDER BY x)as dnom"
        #sql= "SELECT dnom FROM ws_sample_dev.cat_node WHERE nodetype_id='"+node_type+ "' ORDER BY split_part(dnom,'-', 1)::int"
        #sql = "SELECT dnom FROM ws_sample_dev.cat_node WHERE nodetype_id='" + node_type + "' ORDER BY dint"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.dnom, rows)


    def fillCbxpnom(self,index):
        if index == -1:
            return

        nodetype = self.node_type.currentText()
        mats=self.matcat_id.currentText()

        sql="SELECT DISTINCT(pnom) FROM ws_sample_dev.cat_node"
        if(str(nodetype)!= ""):
            sql += " WHERE nodetype_id='"+nodetype+"'"
        if (str(mats)!=""):
            sql += " and matcat_id='"+str(mats)+"'"
        rows = self.controller.get_rows(sql)
        self.pnom.clear()
        utils_giswater.fillComboBox(self.pnom, rows)
        self.fillCbxdnom()

    def fillCbxdnom(self,index):
        if index == -1:
            return

        nodetype = self.node_type.currentText()
        mats=self.matcat_id.currentText()
        pnom=self.pnom.currentText()
        sql="SELECT dnom FROM (SELECT DISTINCT(regexp_replace(trim(' nm'from dnom),'-','', 'g')::int)as x, dnom FROM ws_sample_dev.cat_node"
        if(str(nodetype)!= ""):
            sql += " WHERE nodetype_id='"+nodetype+"'"
        if (str(mats)!=""):
            sql += " and matcat_id='"+str(mats)+"'"
        if(str(pnom)!= ""):
            sql +=" and pnom='"+str(pnom)+"'"
        sql +=" ORDER BY x) as dnom"
        rows = self.controller.get_rows(sql)
        self.dnom.clear()
        utils_giswater.fillComboBox(self.dnom, rows)

    def fillCbxCatalod_id(self,index):    #@UnusedVariable

        self.id = self.dlg_cat.findChild(QComboBox, "id")

        if self.id!='null':
            nodetype = self.node_type.currentText()
            mats = self.matcat_id.currentText()
            pnom = self.pnom.currentText()
            dnom = self.dnom.currentText()
            sql = "SELECT DISTINCT(id) as id FROM ws_sample_dev.cat_node"
            if(str(nodetype)!= ""):
                sql += " WHERE nodetype_id='"+nodetype+"'"
            if (str(mats)!=""):
                sql += " and matcat_id='"+str(mats)+"'"
            if (str(pnom) != ""):
                sql += " and pnom='"+str(pnom)+"'"
            if (str(dnom) != ""):
                sql += " and dnom='" + str(dnom) + "'"
            sql += " ORDER BY id"
            rows = self.controller.get_rows(sql)
            self.id.clear()
            utils_giswater.fillComboBox(self.id, rows)




    '''
    # QMessageBox.about(None, 'Ok', str(nodetype))
    def initfillcbxnodecat_id(self):
        sql = "SELECT DISTINCT(id) FROM ws_sample_dev.cat_node"
        sql += " WHERE nodetype_id='" + self.node_type.currentText() + "'"
        rows = self.controller.get_rows(sql)
        self.nodecat_id.clear()
        utils_giswater.fillComboBox(self.nodecat_id,rows)
    '''

    def fillTxtnodecat_id(self):
        self.dlg_cat.close()
        self.nodecat_id.clear()
        self.nodecat_id.setText(str(self.id.currentText()))
        
        
        
    def open_selected_event_from_table(self):
        ''' Button - Open EVENT | gallery from table event '''
        message = "54353"
        self.controller.show_warning(message, context_name='ui_message')
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node")
        # Get selected rows
        selected_list = self.tbl_event.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return


        inf_text = ""
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
        for k in range(0,limit):
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = self.num_events/9+1
        columns = 9 
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)]
        message = str(self.img_path_list)
        self.controller.show_warning(message, context_name='ui_message')
        # Convert one-dimensional array to two-dimensional array
        idx=0
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
            self.widgetExtended=ExtendedQLabel.ExtendedQLabel(widget)
 
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

        #myButton.clicked.disconnect(function_B) #this disconnect function_B
        #self.list_labels[i].disconnect( partial(self.zoom_img,self.img_path_list[self.start_indx][i]))
        
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
        
