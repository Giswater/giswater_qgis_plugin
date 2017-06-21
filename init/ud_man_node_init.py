'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QLabel, QPixmap, QLineEdit,QPixmap,QIcon
from PyQt4.QtCore import QSize
from PyQt4.QtGui import *
from PyQt4.QtCore import *

from functools import partial

import utils_giswater
from parent_init import ParentDialog

from ui.gallery import Gallery          #@UnresolvedImport
from ui.gallery_zoom import GalleryZoom          #@UnresolvedImport
from ui.ud_catalog import UDcatalog                  # @UnresolvedImport

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
    
def test():
    print "test"
          
     
class ManNodeDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(ManNodeDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
        table_element = "v_ui_element_x_node" 
        table_document = "v_ui_doc_x_node"   
        table_event_node = "v_ui_om_visit_x_node"
        table_scada = "v_rtc_scada"    
        table_scada_value = "v_rtc_scada_value"    
        table_price_node = "v_price_x_node"
        
        self.table_chamber = self.schema_name+'."v_edit_man_chamber"'
        self.table_chamber_pol = self.schema_name+'."v_edit_man_chamber_pol"'
        self.table_netgully = self.schema_name+'."v_edit_man_netgully"'
        self.table_netgully_pol = self.schema_name+'."v_edit_man_netgully_pol"'
        self.table_netinit = self.schema_name+'."v_edit_man_netinit"'
        self.table_wjump = self.schema_name+'."v_edit_man_wjump"'
        self.table_wwtp = self.schema_name+'."v_edit_man_wwtp"'
        self.table_junction = self.schema_name+'."v_edit_man_junction"'
        self.table_wwtp_pol = self.schema_name+'."v_edit_man_wwtp_pol"'
        self.table_storage = self.schema_name+'."v_edit_man_storage"'
        self.table_storage_pol = self.schema_name+'."v_edit_man_storage_pol"'
        self.table_outfall = self.schema_name+'."v_edit_man_outfall"'
        self.table_manhole = self.schema_name+'."v_edit_man_manhole"'
        self.table_valve = self.schema_name+'."v_edit_man_valvel"'
              
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
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node") 
        self.tbl_scada = self.dialog.findChild(QTableView, "tbl_scada") 
        self.tbl_scada_value = self.dialog.findChild(QTableView, "tbl_scada_value") 
        self.tbl_price_node = self.dialog.findChild(QTableView, "tbl_masterplan")
              
        # Load data from related tables
        self.load_data()
        
        # Manage tab visibility
        self.set_tabs_visibility(9)  
        
        # Fill the info table
        self.fill_table(self.tbl_info, self.schema_name+"."+table_element, self.filter)
       
        # Configuration of info table
        self.set_configuration(self.tbl_info, table_element)    
        
        # Fill the tab Document
        self.fill_tbl_document_man(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # Configuration of Document table
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
        
        # Fill tab costs
        self.fill_table(self.tbl_price_node, self.schema_name+"."+table_price_node, self.filter)

        # Configuration of table cost
        self.set_configuration(self.tbl_price_node, table_price_node)
        
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
        
        # Event
        
        self.btn_open_event = self.dialog.findChild(QPushButton,"btn_open_event")
        self.btn_open_event.clicked.connect(self.open_selected_event_from_table)

    def catalog(self):
        self.dlg_cat = UDcatalog()
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()

        self.dlg_cat.findChild(QPushButton, "pushButton").clicked.connect(self.fillTxtnodecat_id)
        self.dlg_cat.findChild(QPushButton, "pushButton_2").clicked.connect(self.dlg_cat.close)
        self.matcat_id=self.dlg_cat.findChild(QComboBox, "matcat_id")
        self.shape = self.dlg_cat.findChild(QComboBox, "shape")
        self.geom1 = self.dlg_cat.findChild(QComboBox, "geom1")
        self.id = self.dlg_cat.findChild(QComboBox, "id")

        self.matcat_id.currentIndexChanged.connect(self.fillCbxCatalod_id)
        self.matcat_id.currentIndexChanged.connect(self.fillCbxshape)
        self.matcat_id.currentIndexChanged.connect(self.fillCbxgeom1)

        self.shape.currentIndexChanged.connect(self.fillCbxCatalod_id)
        self.shape.currentIndexChanged.connect(self.fillCbxgeom1)

        self.geom1.currentIndexChanged.connect(self.fillCbxCatalod_id)

        self.matcat_id.clear()
        self.shape.clear()
        self.geom1.clear()

        sql= "SELECT DISTINCT(matcat_id) FROM ud_sample_dev.cat_node"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql= "SELECT DISTINCT(shape) FROM ud_sample_dev.cat_node"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.shape, rows)

        sql= "SELECT DISTINCT(geom1) FROM ud_sample_dev.cat_node"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.geom1, rows)


    def fillCbxshape(self,index):
        if index == -1:
            return
        mats=self.matcat_id.currentText()

        sql="SELECT DISTINCT(shape) FROM ud_sample_dev.cat_node"
        if (str(mats)!=""):
            sql += " WHERE matcat_id='"+str(mats)+"'"
        rows = self.controller.get_rows(sql)
        self.shape.clear()
        utils_giswater.fillComboBox(self.shape, rows)
        self.fillCbxgeom1()


    def fillCbxgeom1(self,index):
        if index == -1:
            return
        mats=self.matcat_id.currentText()
        shape=self.shape.currentText()
        sql="SELECT DISTINCT(geom1) FROM ud_sample_dev.cat_node"

        if (str(mats)!=""):
            sql += " WHERE matcat_id='"+str(mats)+"'"
        if(str(shape)!= ""):
            sql +=" and shape='"+str(shape)+"'"
        rows = self.controller.get_rows(sql)
        self.geom1.clear()
        utils_giswater.fillComboBox(self.geom1, rows)


    def fillCbxCatalod_id(self,index):    #@UnusedVariable
        self.id = self.dlg_cat.findChild(QComboBox, "id")
        if self.id!='null':
            mats = self.matcat_id.currentText()
            shape = self.shape.currentText()
            geom1 = self.geom1.currentText()
            sql = "SELECT DISTINCT(id) FROM ud_sample_dev.cat_node"
            if (str(mats)!=""):
                sql += " WHERE matcat_id='"+str(mats)+"'"
            if (str(shape) != ""):
                sql += " and shape='"+str(shape)+"'"
            if (str(geom1) != ""):
                sql += " and geom1='" + str(geom1) + "'"
            rows = self.controller.get_rows(sql)
            self.id.clear()
            utils_giswater.fillComboBox(self.id, rows)


    def fillTxtnodecat_id(self):
        self.dlg_cat.close()
        self.nodecat_id.clear()
        self.nodecat_id.setText(str(self.id.currentText()))


    def open_selected_event_from_table(self):
        ''' Button - Open EVENT | gallery from table event '''
        
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node")
        # Get selected rows
        selected_list = self.tbl_event.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return
        '''
        inf_text = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_event.model().record(row).value("value")
            inf_text+= str(id_)+", "
        inf_text = inf_text[:-2]
        self.path = inf_text 

        
        sql = "SELECT value FROM "+self.schema_name+".config_param_text"
        sql +=" WHERE id = 'doc_absolute_path'"
        row = self.dao.get_row(sql)
        if row is None:
            message = "Check doc_absolute_path in table config_param_text, value does not exist or is not defined!"
            self.controller.show_warning(message, context_name='ui_message')
            return
        else:
            # Full path= path + value from row
            self.full_path =row[0]+self.path
           
            # Parse a URL into components
            url=urlparse.urlsplit(self.full_path)
    
            # Check if path is URL
            if url.scheme=="http":
                # If path is URL open URL in browser
                webbrowser.open(self.full_path) 
            else: 
                # If its not URL ,check if file exist
                if not os.path.exists(self.full_path):
                    message = "File not found:"+self.full_path 
                    self.controller.show_warning(message, context_name='ui_message')
                       
                else:
                    # Open the document
                    os.startfile(self.full_path) 
        '''
        #message = str(selected_list[0])
        #self.controller.show_warning(message, context_name='ui_message' ) 
        inf_text = ""
        #for i in range(0, len(selected_list)):
        row = selected_list[0].row()
        #id_ = self.tbl_event.model().record(row).value("visit_id")
        visit_id = self.tbl_event.model().record(row).value("visit_id")
        event_id = self.tbl_event.model().record(row).value("event_id")
        picture = self.tbl_event.model().record(row).value("value")
        #inf_text+= str(id_)+", "
        #inf_text = inf_text[:-2]
        #self.visit_id = inf_text 



        # Get all events | pictures for visit_id
        sql = "SELECT value FROM "+self.schema_name+".v_ui_om_visit_x_node"
        sql +=" WHERE visit_id = '"+str(visit_id)+"'"
        rows = self.controller.get_rows(sql)

        # Get absolute path
        sql = "SELECT value FROM "+self.schema_name+".config_param_text"
        sql +=" WHERE id = 'doc_absolute_path'"
        row = self.dao.get_row(sql)

        if row is None:
            message = "Check doc_absolute_path in table config_param_text, value does not exist or is not defined!"
            self.dao.show_warning(message, context_name='ui_message')
            return
        else:
            print "full path"
            # Full path= path + value from row
            #self.full_path =row[0]+self.path
            
            # rows - list of relativ paths
            # for each relative path make apsolute path
            '''
            for i in rows:
                # Full path= path + value from row
                self.full_path =row[0]+self.path
                # list of paths of pictures
                list.append(self.full_path)
            
            # set picture
            '''
        
        # Create the dialog and signals
        self.dlg_gallery = Gallery()
        utils_giswater.setDialog(self.dlg_gallery)
        
        '''
        img_0 = self.dlg_gallery.findChild(QLabel, 'img_0')
        img_1 = self.dlg_gallery.findChild(QLabel, 'img_1')
        img_2 = self.dlg_gallery.findChild(QLabel, 'img_2')
        img_3 = self.dlg_gallery.findChild(QLabel, 'img_3')
        img_4 = self.dlg_gallery.findChild(QLabel, 'img_4')
        img_5 = self.dlg_gallery.findChild(QLabel, 'img_5')
        img_6 = self.dlg_gallery.findChild(QLabel, 'img_6')
        img_7 = self.dlg_gallery.findChild(QLabel, 'img_7')
        img_8 = self.dlg_gallery.findChild(QLabel, 'img_8')
        '''
        
        txt_visit_id = self.dlg_gallery.findChild(QLineEdit, 'visit_id')
        txt_visit_id.setText(str(visit_id))
        
        txt_event_id = self.dlg_gallery.findChild(QLineEdit, 'event_id')
        txt_event_id.setText(str(event_id))
        # Add picture to gallery
        '''
        pic_file = "C:/Users/tasladmin/Desktop/img_pipe.png"
        pixmap = QPixmap(pic_file)
        self.img_1.setPixmap(pixmap)
        self.img_1.show()  
        '''
        self.img_path_list = [["C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg"] ,["C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg","C:/Users/tasladmin/Desktop/events/img_pipe.jpg"],["C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg","C:/Users/tasladmin/Desktop/events/img_pipe2.jpg"],["C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg","C:/Users/tasladmin/Desktop/events/img_pipe3.jpg"]]
        
        
        #for i in range(0, len(self.img_path_list)):
        for i in range(0, 9):
            # Set image to QLabel
            pixmap = QPixmap(self.img_path_list[0][i])
            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            #widget.mousePressEvent.connect(self.test)
            widget.setPixmap(pixmap)
            widget.show()

            # Add functionality to button of zooming picture
            btn_widget_name = "btn_zoom_img_"+str(i)
            btn_widget = self.dlg_gallery.findChild(QPushButton, btn_widget_name)
            btn_widget.clicked.connect(partial(self.zoom_img,self.img_path_list[0][i]))
      
        self.start_indx = 0
        self.end_indx = len(self.img_path_list)-1
        self.btn_next = self.dlg_gallery.findChild(QPushButton,"btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        
        self.btn_previous = self.dlg_gallery.findChild(QPushButton,"btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
 
        #label = self.dlg_gallery.findChild(QLabel, 'test')
        #label_click = ClickableLabel(label)
        #label_click.signalClicked.connec(self.test)
        #pixmap = QPixmap("C:/Users/tasladmin/Desktop/events/img_pipe3.jpg")
        #label.setPixmap(pixmap)
        
        self.dlg_gallery.exec_()

        
    def next_gallery(self):
        self.start_indx = self.start_indx+1
        
        
        # First clear previous
        for i in range(0, 9):
            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            widget.clear()
            # WIP : Add action to Label :on click zoom images
                 

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            #Define clicable label
            #self.label=ClickableLabel(widget)
            #self.label.signalClicked.connec(self.test) 
            widget.setPixmap(pixmap)
            widget.show()

            # Add functionality to button of zooming picture
            btn_widget_name = "btn_zoom_img_"+str(i)
            btn_widget = self.dlg_gallery.findChild(QPushButton, btn_widget_name)
            
            message = "btn_clicked"
            self.controller.show_warning(message, context_name='ui_message')
            
            btn_widget.clicked.connect(partial(self.zoom_img,self.img_path_list[self.start_indx][i]))

        if self.start_indx > 0 :
            self.btn_previous.setEnabled(True) 
            
        # On last tab disable btn_next
        #if self.start_indx == (len(self.img_path_list)-1) :
        #    self.btn_next.setEnabled(False) 

    def zoom_img(self,img):
        message = "zoom"
        self.controller.show_warning(message, context_name='ui_message')

        self.dlg_gallery_zoom = GalleryZoom()
        pixmap = QPixmap(img)

        lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom") 
        lbl_img.setPixmap(pixmap)
        lbl_img.show()
            
        self.dlg_gallery_zoom.exec_() 
    
            
    def previous_gallery(self):
        #self.end_indx = self.end_indx-1
        self.start_indx = self.start_indx-1

        # First clear previous
        for i in range(0, 9):
            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            widget.clear()
        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            widget.setPixmap(pixmap)
            widget.show()  
            
            # Add functionality to button of zooming picture
            btn_widget_name = "btn_zoom_img_"+str(i)
            btn_widget = self.dlg_gallery.findChild(QPushButton, btn_widget_name)
          
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)
        if self.start_indx < len(self.img_path_list) :
            self.btn_next.setEnabled(True)  
              
        
        
    ''' ACTIONS TOOLBAR '''    
    def actionZoomOut(self):
        feature = self.feature

        canvas = self.iface.mapCanvas()
        # Get the active layer (must be a vector layer)
        layer = self.iface.activeLayer()

        layer.setSelectedFeatures([feature.id()])

        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        
        
        
    def actionZoom(self):
       
        print "zoom"
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
        self.plugin_name = 'giswater'
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

        
''' Add click event for QLabel '''        
        
class ClickableLabel(QLabel):
    '''Normal label, but emits an event if the label is left-clicked'''
   
    signalClicked = Signal()    # emitted whenever this label is left-clicked
   
    def __init__(self, text, parent=None):
        super(ClickableLabel, self).__init__(text, parent)
        self.setStyleSheet('''
       QLabel {text-decoration:none}
       QLabel:hover {color:white; background:grey;}
       ''')
        self.setFixedSize(self.sizeHint())
   
    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            self.signalClicked.emit()
    