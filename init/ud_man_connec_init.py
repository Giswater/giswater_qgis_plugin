'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QLineEdit, QComboBox, QMessageBox

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.ud_catalog import UDcatalog

def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManConnecDialog(dialog, layer, feature)
    init_config()

    
def init_config():

    # Manage 'connec_type'
    connec_type = utils_giswater.getWidgetText("connec_type") 
    utils_giswater.setSelectedItem("connec_type", connec_type)
     
    # Manage 'connecat_id'
    connecat_id = utils_giswater.getWidgetText("connecat_id") 
    utils_giswater.setSelectedItem("connecat_id", connecat_id)   
      
    # Set button signals      
    #feature_dialog.dialog.findChild(QDialogButtonBox, "ok").accepted.connect(feature_dialog.save)   
    #feature_dialog.dialog.findChild(QDialogButtonBox, "buttonBox").accepted.connect(feature_dialog.save)        
    #feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)  

     
class ManConnecDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(ManConnecDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        dialog.parent().setFixedSize(625, 670)
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
        table_element = "v_ui_element_x_connec" 
        table_document = "v_ui_doc_x_connec"
        table_event_connec = "v_ui_om_visit_x_connec"
        table_hydrometer = "v_rtc_hydrometer"    
        table_hydrometer_value = "v_edit_rtc_hydro_data_x_connec"    
              
        # Define class variables
        self.field_id = "connec_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.connec_type = utils_giswater.getWidgetText("cat_connectype_id", False)        
        self.connec_type = utils_giswater.getWidgetText("connec_type", False) 
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_connec")  
        self.tbl_hydrometer = self.dialog.findChild(QTableView, "tbl_hydro") 
        self.tbl_hydrometer_value = self.dialog.findChild(QTableView, "tbl_hydro_value") 
              
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
        
        # Fill tab event | connec
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_connec, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        # Configuration of table event | connec
        self.set_configuration(self.tbl_event, table_event_connec)
              
        # Fill tab hydrometer | hydrometer
        self.fill_tbl_hydrometer(self.tbl_hydrometer, self.schema_name+"."+table_hydrometer, self.filter)
        
        # Configuration of table hydrometer | hydrometer
        self.set_configuration(self.tbl_hydrometer, table_hydrometer)
        
        # Fill tab hydrometer | hydrometer value
        self.fill_tbl_hydrometer(self.tbl_hydrometer_value, self.schema_name+"."+table_hydrometer_value, self.filter)
        
        # Configuration of table hydrometer | hydrometer value
        self.set_configuration(self.tbl_hydrometer_value, table_hydrometer_value)
        
        # Set signals          
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))       
        self.dialog.findChild(QPushButton, "btn_delete_hydrometer").clicked.connect(partial(self.delete_records_hydro, self.tbl_hydrometer))               
        self.dialog.findChild(QPushButton, "btn_add_hydrometer").clicked.connect(self.insert_records)
        self.dialog.findChild(QPushButton, "btn_catalog").clicked.connect(self.catalog)
        
        # Toolbar actions
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(self.actionZoom)
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(self.actionCentered)
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(self.actionEnabled)
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(self.actionZoomOut)

        # QLineEdit
        self.connecat_id = self.dialog.findChild(QLineEdit, 'connecat_id')



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
        self.dlg_cat = UDcatalog()
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()
        self.dlg_cat.findChild(QPushButton, "btn_ok").clicked.connect(self.fillTxtconnecat_id)
        self.dlg_cat.findChild(QPushButton, "btn_cancel").clicked.connect(self.dlg_cat.close)
        self.matcat_id = self.dlg_cat.findChild(QComboBox, "matcat_id")
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

        sql = "SELECT DISTINCT(matcat_id) as matcat_id FROM ud_sample_dev.cat_connec ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT(shape) as shape FROM ud_sample_dev.cat_connec ORDER BY shape"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.shape, rows)

        sql = "SELECT DISTINCT(geom1) as geom1 FROM ud_sample_dev.cat_connec ORDER BY geom1"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.geom1, rows)


    def fillCbxshape(self, index):
        if index == -1:
            return
        mats = self.matcat_id.currentText()

        sql = "SELECT DISTINCT(shape) FROM ud_sample_dev.cat_connec"
        if (str(mats) != ""):
            sql += " WHERE matcat_id='" + str(mats) + "'"
        rows = self.controller.get_rows(sql)
        self.shape.clear()
        utils_giswater.fillComboBox(self.shape, rows)
        self.fillCbxgeom1()


    def fillCbxgeom1(self, index):
        if index == -1:
            return
        mats = self.matcat_id.currentText()
        shape = self.shape.currentText()
        sql = "SELECT DISTINCT(geom1) as geom1 FROM ud_sample_dev.cat_connec"

        if (str(mats) != ""):
            sql += " WHERE matcat_id='" + str(mats) + "'"
        if (str(shape) != ""):
            sql += " and shape='" + str(shape) + "'"
        sql += " ORDER BY geom1"
        rows = self.controller.get_rows(sql)
        self.geom1.clear()
        utils_giswater.fillComboBox(self.geom1, rows)


    def fillCbxCatalod_id(self, index):  # @UnusedVariable
        self.id = self.dlg_cat.findChild(QComboBox, "id")
        if self.id != 'null':
            mats = self.matcat_id.currentText()
            shape = self.shape.currentText()
            geom1 = self.geom1.currentText()
            sql = "SELECT DISTINCT(id) as id FROM ud_sample_dev.cat_connec"
            if (str(mats) != ""):
                sql += " WHERE matcat_id='" + str(mats) + "'"
            if (str(shape) != ""):
                sql += " and shape='" + str(shape) + "'"
            if (str(geom1) != ""):
                sql += " and geom1='" + str(geom1) + "'"
            sql += " ORDER BY id"
            rows = self.controller.get_rows(sql)
            self.id.clear()
            utils_giswater.fillComboBox(self.id, rows)


    def fillTxtconnecat_id(self):
        self.dlg_cat.close()
        self.connecat_id.clear()
        self.connecat_id.setText(str(self.id.currentText()))