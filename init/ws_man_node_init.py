'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QMessageBox, QComboBox, QLineEdit

from qgis.gui import *
from functools import partial
import os
import utils_giswater
from parent_init import ParentDialog
from ui.ws_catalog import WScatalog                  # @UnresolvedImport

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
        
        # Manage tab visibility
        self.set_tabs_visibility(14)
              
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

        self.dlg_cat.findChild(QPushButton, "pushButton").clicked.connect(self.fillTxtnodecat_id)
        self.dlg_cat.findChild(QPushButton, "pushButton_2").clicked.connect(self.dlg_cat.close)

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


        sql= "SELECT DISTINCT(dnom) FROM ws_sample_dev.cat_node WHERE nodetype_id='"+node_type+ "'"
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
        sql="SELECT DISTINCT(dnom) FROM ws_sample_dev.cat_node"
        if(str(nodetype)!= ""):
            sql += " WHERE nodetype_id='"+nodetype+"'"
        if (str(mats)!=""):
            sql += " and matcat_id='"+str(mats)+"'"
        if(str(pnom)!= ""):
            sql +=" and pnom='"+str(pnom)+"'"
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
            sql = "SELECT DISTINCT(id) FROM ws_sample_dev.cat_node"
            if(str(nodetype)!= ""):
                sql += " WHERE nodetype_id='"+nodetype+"'"
            if (str(mats)!=""):
                sql += " and matcat_id='"+str(mats)+"'"
            if (str(pnom) != ""):
                sql += " and pnom='"+str(pnom)+"'"
            if (str(dnom) != ""):
                sql += " and dnom='" + str(dnom) + "'"
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
