# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.utils import iface

import utils_giswater
from ws_parent_init import ParentDialog

from qgis.core import QgsVectorLayerCache, QgsMapLayerRegistry
from qgis.gui import QgsAttributeTableView, QgsAttributeTableModel

from controller import DaoController
from itertools import count

import os
import ctypes

def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ConnecDialog(iface, dialog, layer, feature)
    init_config()
    
def init_config():
     
    feature_dialog.dialog.findChild(QComboBox, "connecat_id").setVisible(False)         
    connecat_id = utils_giswater.getWidgetText("connecat_id", False)
    
    
    # TODO: Define slots
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
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")         
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")     
        
        # Manage tab visibility
        self.set_tabs_visibility()                
        
        # Manage i18n
        self.translate_form('ws_connec') 
            
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        self.fill_info_node()
        
        # Fill the document table
        self.fill_document_connec()
        
        # Fill the event->element tab
        self.fill_connec_event_element()
        
        # Fill the event->node tab
        self.fill_connec_event_node()
        


                    
    ''' TODO: Slot functions '''  
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''     
        self.tab_main.removeTab(3) 
        
        
    
    def fill_document_connec(self):
        '''Fill tab document of arc
        '''
        
        self.tbl_connec = self.dialog.findChild(QTableView, "tbl_connec") 
        
        # Set signals
        self.doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        self.doc_user.activated.connect(self.get_doc_user)
        
        self.doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        self.doc_type.activated.connect(self.get_doc_type)
        
        self.doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.doc_tag.activated.connect(self.get_doc_tag)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_to.dateChanged.connect(self.get_date)
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        self.date_document_from.dateChanged.connect(self.get_date)
    
        # Signal(double click on cell),function(geth_path):select individual cell("path") in QTableView and open the folder
        self.tbl_connec.doubleClicked.connect(self.geth_path)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_connec")
        
        # The result is a list, lets pick the first
        if layerList: 
            layer_a = layerList[0]

            self.cache = QgsVectorLayerCache(layer_a, 10000)
            self.model = QgsAttributeTableModel(self.cache)
            
            # Fill ComboBox doc_tag
            sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY tagcat_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_tag",rows)
            
            # Fill ComboBox cat_doc_type
            sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY doc_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_type",rows)
            
            # Fill ComboBox doc_user
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_connec ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user",rows)
            
            # Get arc_id from selected arc
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id")  
            
            # Automatically fill the table, based on arc_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            
            self.model.setRequest(request)
            self.model.loadLayer()
            self.tbl_connec.setModel(self.model)
    
    
    def geth_path(self):
        ''' Get value from selected cell ("PATH")
        Open the document''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_connec.currentIndex().column()
        if position_column == 4 :      
            # Get data from address in memory (pointer)
            self.path=self.tbl_connec.selectedIndexes()[0].data() 
            # Check if file exist
            if not os.path.exists(self.path):
                message="File doesn't exist!"
                self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
                print ("File doesn't exist!")
                
            else :
                # Open the document
                os.startfile(self.path)     
        else :
            return
            
    def showWarning(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)   
        
    def get_doc_user(self):
        '''Get selected value from combobox doc_user
        Filter the table related on selected value'''
        print ("koji k")
        # Get selected value from ComboBoxs
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
        
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox doc_user and ComboBox cat_doc_type are selected
        if (self.doc_type_value != 'null' ):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_user is returned to 'null'
        if (self.doc_user_value == 'null'): 
            if (self.doc_type_value != 'null' ):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox doc_tag are selected
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
            if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
        
        
    def get_doc_type(self):
        '''Get selected value from combobox cat_doc_type
        Filter the table related on selected value'''
        
        # Get selected value from ComboBox cat_doc_type 
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox cat_doc_type is returned to 'null'
        if (self.doc_type_value == 'null'): 
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
                
        request = QgsFeatureRequest(expr)     
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
    
    def get_doc_tag(self):
        '''Get selected value from combobox doc_tag 
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxes
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if (self.doc_type_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')      
        # If combobox cat_doc_type is returned to 'null'
        if (self.doc_tag_value == 'null'): 
            # If ComboCox doc_user is selected
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox _doc_type is selected
            if (self.doc_type_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doccat_id" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type selected
            if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doccat_id" = \'' +self.doc_type_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )  
               
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
        
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value
        '''
        #self.tbl_document.setModel(self.model)
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from") 
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")     
        
        date_from=self.date_document_from.date() 
        date_to=self.date_document_to.date() 
        
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "connec_id" ='+ self.connec_id_selected+'' )
            print(expr.dump())
        else :
            message="Valid interval!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
        
        
    def fill_info_node(self): 
        ''' Fill tab info of node
        '''
        
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")  
        
        # Get connec_id from selected arc
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")  

        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_element_x_connec")
        # The result is a list, lets pick the first
        if layerList: 
            layer_B = layerList[0]

            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on connec_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.tbl_info.setModel(self.modelB)
            
            
    def fill_connec_event_node(self):
        '''Fill tab event->node of connec
        '''
        
        self.tbl_event_node = self.dialog.findChild(QTableView, "tbl_event_node") 
        
        # Set signals
        self.doc_user_3 = self.dialog.findChild(QComboBox, "doc_user_3") 
        self.doc_user_3.activated.connect(self.get_doc_user_3)
       
        self.event_id_3 = self.dialog.findChild(QComboBox, "event_id_3") 
        self.event_id_3.activated.connect(self.get_event_id_3)
        
        self.event_type_3 = self.dialog.findChild(QComboBox, "event_type_3") 
        self.event_type_3.activated.connect(self.get_event_type_3)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to_3 = self.dialog.findChild(QDateEdit, "date_document_to_3")
        self.date_document_to_3.dateChanged.connect(self.get_date_event_element_3)
        self.date_document_from_3 = self.dialog.findChild(QDateEdit, "date_document_from_3")
        self.date_document_from_3.dateChanged.connect(self.get_date_event_element_3)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_connec")
        if layerList: 
            layer_connec = layerList[0]

            self.cache_connec = QgsVectorLayerCache(layer_connec, 10000)
            self.model_connec = QgsAttributeTableModel(self.cache_connec)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_2
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_3",rows)
            
            # Fill ComboBox event_id
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id_3",rows)
            
            # Fill ComboBox event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type_3",rows)
            
            # Get node_id from selected node
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
    
            print(expr.dump())
            self.model_connec.setRequest(request)
            self.model_connec.loadLayer()
            self.tbl_event_node.setModel(self.model_connec)


    def get_doc_user_3(self):
        print ("get_doc_user_3")
        '''Get selected value from combobox doc_user_2
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
        
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.event_id_3_value != 'null' ):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\'') 
        if (self.event_type_3_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.event_id_3_value !='null')&(self.event_id_3_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox doc_user_3 is returned to 'null'
        if (self.doc_user_3_value == 'null'): 
            if (self.event_id_3_value != 'null' ):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'') 
            if (self.event_type_3_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'') 
            if ((self.event_id_3_value !='null')&(self.event_type_3_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
            
            if((self.event_id_3_value =='null')&(self.event_type_3_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
                
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)
    
    def get_event_id_3(self):
        print("get event id 3")
        '''Get selected value from combobox event_id
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_3_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value_3 + '\' AND "event_id" = \'' +self.event_id_3_value + '\'') 
        if (self.event_type_3_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.doc_user_3_value !='null')&(self.event_type_3_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.event_id_3_value == 'null'): 
            if (self.doc_user_3_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'') 
            if (self.event_type_3_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'') 
            if ((self.doc_user_3_value !='null')&(self.event_type_3_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
            
            if((self.doc_user_3_value =='null')&(self.event_type_3_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
        
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)
        
    def get_event_type_3(self):
        '''Get selected value from combobox event_type_3
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_3_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if (self.event_id_3_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.doc_user_3_value !='null')&(self.event_id_3_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox event_type_3 is returned to 'null'
        if (self.event_type_3_value == 'null'): 
            if (self.doc_user_3_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'') 
            if (self.event_id_3_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'') 
            if ((self.doc_user_3_value !='null')&(self.event_id_3_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\'')  
            
            if((self.doc_user_3_value =='null')&(self.event_id_3_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' ) 
               
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)
        
        
    def get_date_event_element_3(self):
        print ("get_date_event_element")
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value
        '''

        self.date_document_from_3 = self.dialog.findChild(QDateEdit, "date_document_from_3") 
        self.date_document_to_3 = self.dialog.findChild(QDateEdit, "date_document_to_3")     
        
        date_from=self.date_document_from_3.date() 
        date_to=self.date_document_to_3.date() 
        
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_3.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_3.date().toString('yyyyMMdd')+ ' AND "connec_id" ='+ self.connec_id_selected+'' )
            print(expr.dump())
        else :
            message="Valid interval!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)  
        
        
        
        
    def fill_connec_event_element(self):
        print("fill element")
        print("fill element")
        
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        
        # Set signals
        self.doc_user_2 = self.dialog.findChild(QComboBox, "doc_user_2") 
        self.doc_user_2.activated.connect(self.get_doc_user_2)
        
        self.event_id = self.dialog.findChild(QComboBox, "event_id") 
        self.event_id.activated.connect(self.get_event_id)
        
        self.event_type = self.dialog.findChild(QComboBox, "event_type") 
        self.event_type.activated.connect(self.get_event_type)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to_2 = self.dialog.findChild(QDateEdit, "date_document_to_2")
        self.date_document_to_2.dateChanged.connect(self.get_date_event_element)
        self.date_document_from_2 = self.dialog.findChild(QDateEdit, "date_document_from_2")
        self.date_document_from_2.dateChanged.connect(self.get_date_event_element)

        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_element")
        if layerList: 
            layer_C = layerList[0]

            self.cacheC = QgsVectorLayerCache(layer_C, 10000)
            self.modelC = QgsAttributeTableModel(self.cacheC)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_2
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_element ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_2",rows)
            
            # Fill ComboBox event_id
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_element ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id",rows)
            
            # Fill ComboBox event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_element ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type",rows)
          
            # Get event_id related on connec_id
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
            sql = "SELECT event_id FROM "+self.schema_name+".v_ui_event_x_connec WHERE connec_id = '"+self.connec_id_selected+"'" 
            
            # Execute value from sql to self.connec_event_id
            self.connec_event_id = self.dao.get_row(sql)
            print(self.connec_event_id)
            '''
            # Automatically fill the table, based on event_id
            expr = QgsExpression ('"event_id" ='+ self.connec_event_id+'' )
            
            request = QgsFeatureRequest(expr)
            print(expr.dump())
            self.modelC.setRequest(request)
            self.modelC.loadLayer()
            self.tbl_event_element.setModel(self.modelC)
            '''
    def get_doc_user_2(self):
        print("")
    def get_event_id(self):
        print("")
    def get_event_type(self):
        print("")
    def get_date_event_element(self):
        print("")