# -*- coding: utf-8 -*-
from qgis.utils import iface
from PyQt4.QtGui import QComboBox, QDateEdit, QPushButton, QTableView, QTabWidget

from functools import partial

import utils_giswater
from ws_parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ConnecDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
    
    # Manage visibility     
    feature_dialog.dialog.findChild(QComboBox, "connecat_id").setVisible(False)    
    feature_dialog.dialog.findChild(QComboBox, "cat_connectype_id").setVisible(False)    
    
    # Manage 'connecat_id'
    connecat_id = utils_giswater.getWidgetText("connecat_id")
    feature_dialog.dialog.findChild(QComboBox, "connecat_id_dummy").activated.connect(feature_dialog.change_connec_cat)          
    utils_giswater.setSelectedItem("connecat_id_dummy", connecat_id)   
    utils_giswater.setSelectedItem("connecat_id", connecat_id)   
    
    # Manage 'connec_type'
    cat_connectype_id = utils_giswater.getWidgetText("cat_connectype_id")
    utils_giswater.setSelectedItem("cat_connectype_id_dummy", cat_connectype_id)  
    feature_dialog.dialog.findChild(QComboBox, "cat_connectype_id_dummy").activated.connect(feature_dialog.change_connec_type_id)  
    feature_dialog.change_connec_type_id(-1)      
    
    # Set  button signals      
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)      
    
     
class ConnecDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ConnecDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_connec()
        
        
    def init_config_connec(self):
        ''' Custom form initial configuration for 'Connec' '''
        
        # Define class variables
        self.field_id = "connec_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.connec_type = utils_giswater.getWidgetText("cat_connectype_id", False)        
        self.connecat_id = utils_giswater.getWidgetText("connecat_id", False)    
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")  
        self.tab_event_2 = self.dialog.findChild(QTabWidget, "tab_event_2")        
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")      
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")    
        self.tbl_connec = self.dialog.findChild(QTableView, "tbl_connec")             
        self.tbl_dae = self.dialog.findChild(QTableView, "tbl_dae")             
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form('ws_connec')        
        
        # Define and execute query to populate combo 'cat_connectype_id_dummy' 
        self.fill_connec_type_id()
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        table_element = "v_ui_element_x_connec"
        self.fill_tbl_info(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Fill the tab Document
        table_document = "v_ui_doc_x_connec"
        self.fill_tbl_connec(self.tbl_connec, self.schema_name+"."+table_document, self.filter)
        
        # Fill tab Hydrometer
        table_hydrometer = "v_ui_hydrometer_x_connec"
        self.fill_tbl_hydrometer(self.tbl_dae, self.schema_name+"."+table_hydrometer, self.filter)
        
        # Set signals                  
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))                 
        self.dialog.findChild(QPushButton, "delete_row_doc").clicked.connect(partial(self.delete_records, self.tbl_connec, table_document))                   
        
       
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: Event, Log
        self.tab_main.removeTab(4)      
        self.tab_main.removeTab(3) 
                
    
    def fill_connec_type_id(self):
        ''' Define and execute query to populate combo 'cat_connectype_id_dummy' '''
        
        sql = "SELECT connec_type.id"
        sql+= " FROM "+self.schema_name+".connec_type INNER JOIN "+self.schema_name+".cat_connec ON connec_type.id = cat_connec.type"
        sql+= " GROUP BY connec_type.id ORDER BY connec_type.id"
        rows = self.dao.get_rows(sql)           
        utils_giswater.fillComboBox("cat_connectype_id_dummy", rows, False)
        utils_giswater.setWidgetText("cat_connectype_id_dummy", self.connec_type)


    def change_connec_type_id(self, index):
        ''' Define and execute query to populate combo 'cat_nodetype_id' '''
        
        connec_type_id = utils_giswater.getWidgetText("cat_connectype_id_dummy", False)    
        if connec_type_id:       
            utils_giswater.setWidgetText("cat_connectype_id", connec_type_id)    
            sql = "SELECT id FROM "+self.schema_name+".cat_connec"
            sql+= " WHERE type = '"+connec_type_id+"' ORDER BY id"
            rows = self.dao.get_rows(sql)   
            utils_giswater.fillComboBox("connecat_id_dummy", rows, False)    
            if index == -1:  
                utils_giswater.setWidgetText("connecat_id_dummy", self.connecat_id)    
            self.change_connec_cat()
                       
                       
    def change_connec_cat(self):
        ''' Just select item to 'real' combo 'connecat_id' (that is hidden) '''
        connecat_id_dummy = utils_giswater.getWidgetText("connecat_id_dummy")
        utils_giswater.setWidgetText("connecat_id", connecat_id_dummy)           
        
        
    def fill_tbl_connec(self, widget, table_name, filter_):
        ''' Fill the table control to show documents''' 
         
        # Get widgets
        doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        
        # Set signals
        doc_user.activated.connect(partial(self.set_filter_table, self.tbl_connec))
        doc_type.activated.connect(partial(self.set_filter_table, self.tbl_connec))
        doc_tag.activated.connect(partial(self.set_filter_table, self.tbl_connec))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table, self.tbl_connec))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table, self.tbl_connec))
        self.tbl_connec.doubleClicked.connect(self.open_selected_document)
        
        # TODO: Get data from related tables!
        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY tagcat_id" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag",rows)
        
        # Fill ComboBox doccat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY doc_type" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type",rows)
        
        # Fill ComboBox doc_user
        sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY user" 
        rows = self.dao.get_rows(sql)
        #rows = [['gis'], ['postgres']]
        utils_giswater.fillComboBox("doc_user",rows)        
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)   

        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(3)  
        widget.hideColumn(5)          
        
        
    def set_filter_tbl_hydrometer(self):
        ''' Get values selected by the user and sets a new filter for its table model '''
                    
        # Get selected dates
        date_from = self.date_dae_from.date().toString('yyyyMMdd') 
        date_to = self.date_dae_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message, context_name='ws_parent')                   
            return
        
        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '"+date_from+"' AND date <= '"+date_to+"'"
  
        # Refresh model with selected filter
        self.tbl_connec.model().setFilter(expr)
        self.tbl_connec.model().select()
    
        
    def fill_tbl_info(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        
        self.set_model_to_table(widget, table_name, filter_)  
          
        # Hide columns
        widget.hideColumn(1)  
        widget.hideColumn(5)  
        widget.hideColumn(6)           

       
    def fill_tbl_hydrometer(self, widget, table_name, filter_):
        
        # Get widgets
        self.date_dae_to = self.dialog.findChild(QDateEdit, "date_dae_to")
        self.date_dae_from = self.dialog.findChild(QDateEdit, "date_dae_from")
        
        # Set signals
        self.date_dae_to.dateChanged.connect(self.set_filter_tbl_hydrometer)
        self.date_dae_from.dateChanged.connect(self.set_filter_tbl_hydrometer)
        
        #Fill scada tab of node
        #Filter and fill table related with node_id        
        self.set_model_to_table(widget, table_name, filter_)       

        