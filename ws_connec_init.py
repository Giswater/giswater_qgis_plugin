# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.utils import iface
from qgis.core import QgsVectorLayerCache, QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest
from qgis.gui import QgsAttributeTableModel, QgsMessageBar

import os

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
     
    feature_dialog.dialog.findChild(QComboBox, "connecat_id").setVisible(False)         
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
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        self.date_document_from_2 = self.dialog.findChild(QDateEdit, "date_document_from_2")
        self.date_document_from_3 = self.dialog.findChild(QDateEdit, "date_document_from_3")
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_to_2 = self.dialog.findChild(QDateEdit, "date_document_to_2")
        self.date_document_to_3 = self.dialog.findChild(QDateEdit, "date_document_to_3")                                                
            
        # Manage tab visibility
        self.set_tabs_visibility()                
        
        # Manage i18n
        self.translate_form('ws_connec') 
            
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        self.fill_info_connec()
        
        # Fill the document table
        self.fill_document_connec()
        
        # Fill the event->element tab
        self.fill_connec_event_element()
        
        # Fill the event->node tab
        self.fill_connec_event_connec()
        
        # Fill hydrometer tab 
        self.fill_hydrometer()
        
        # Fill log/connec tab
        self.fill_log_connec()
        
        # Fill log/element tab
        self.fill_log_element()

                    
                    
    ''' Slot functions '''  
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''     
        pass
    
        
    def delete_row_doc(self):
        ''' Ask question to the user '''
        
        msgBox = QMessageBox()
        msgBox.setText("Are you sure you want unlink element?")
        msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        ret = msgBox.exec_()
        if ret == QMessageBox.Ok:
            self.upload_db_doc()
        elif ret == QMessageBox.Discard:
            return 
        
        
    def upload_db_doc(self):

        # Get data from address in memory (pointer)
        # Get Id of selected row
        sel_indexes = self.tbl_info.selectedIndexes()
        if not sel_indexes:
            return        
        
        # Data base element_x_node
        # Delete row 
        sql = "DELETE FROM "+self.schema_name+".v_ui_doc_x_connec WHERE id='"+sel_indexes[0].data()+"'"
        self.dao.execute_sql(sql)  
        
        # Show table again without deleted row
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_connec")
        # The result is a list, lets pick the first
        if layerList: 
            
            layer_B = layerList[0]
            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.tbl_connec.setModel(self.modelB)   
    
    
    def fill_document_connec(self):
        ''' Fill tab document of connec '''
        
        self.tbl_connec = self.dialog.findChild(QTableView, "tbl_connec") 
        
        # Set signals
        self.doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        self.doc_user.activated.connect(self.get_doc_user)
        
        self.doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        self.doc_type.activated.connect(self.get_doc_type)
        
        self.doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.doc_tag.activated.connect(self.get_doc_tag)
        
        # Set signal for botton delete_row_doc
        self.dialog.findChild(QPushButton, "delete_row_doc").clicked.connect(self.delete_row_doc)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to.dateChanged.connect(self.get_date)
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
            
            # Get connec_id from selected connec
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id")  
            
            # Automatically fill the table, based on connec_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            
            self.model.setRequest(request)
            self.model.loadLayer()
            self.tbl_connec.setModel(self.model)
    
    
    def geth_path(self):
        ''' Get value from selected cell ("PATH")
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_connec.currentIndex().column()
        if position_column == 4 :      
            sel_indexes = self.tbl_connec.selectedIndexes()
            if not sel_indexes:
                return        
            self.path = sel_indexes[0].data() 
            # Check if file exist
            if not os.path.exists(self.path):
                message = "File not found"
                self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            else :
                # Open the document
                os.startfile(self.path)     

            
    def showWarning(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)   
        
        
    def get_doc_user(self):
        ''' Get selected value from combobox doc_user
        Filter the table related on selected value '''

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
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_user is returned to 'null'
        if (self.doc_user_value == 'null'): 
            if (self.doc_type_value != 'null' ):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox doc_tag are selected
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
            if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
        
        
    def get_doc_type(self):
        ''' Get selected value from combobox cat_doc_type
        Filter the table related on selected value '''
        
        # Get selected value from ComboBox cat_doc_type 
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
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
        ''' Get selected value from combobox doc_tag 
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxes
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if (self.doc_type_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')      
        # If combobox cat_doc_type is returned to 'null'
        if (self.doc_tag_value == 'null'): 
            # If ComboCox doc_user is selected
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox _doc_type is selected
            if (self.doc_type_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type selected
            if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )  
               
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)
        
        
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''

        date_from = self.date_document_from.date() 
        date_to = self.date_document_to.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "connec_id" ='+ self.connec_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_connec.setModel(self.model)

    
    def delete_row_info(self):
        ''' Ask question to the user '''
        
        msgBox = QMessageBox()
        msgBox.setText("Are you sure you want unlink element?")
        msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        ret = msgBox.exec_()
        if ret == QMessageBox.Ok:
            self.upload_db_info()
        elif ret == QMessageBox.Discard:
            return 
        
        
    def upload_db_info(self):
        
        # Get data from address in memory (pointer)
        # Get Id of selected row
        sel_indexes = self.tbl_info.selectedIndexes()
        if not sel_indexes:
            return

        # Data base element_x_node
        # Delete row 
        sql = "DELETE FROM "+self.schema_name+".v_ui_element_x_connec WHERE id='"+sel_indexes[0].data()+"'"
        self.dao.execute_sql(sql)  
        
        # Show table again without deleted row
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_element_x_connec")
        # The result is a list, lets pick the first
        if layerList: 
            
            layer_B = layerList[0]
            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.tbl_info.setModel(self.modelB)
            
     
    def fill_info_connec(self): 
        ''' Fill tab info of connec '''
        
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")  
        
        # Get connec_id from selected arc
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")  
        
        # Set signal for bottom delete_row_info
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(self.delete_row_info)

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
            
            
    def fill_connec_event_connec(self):
        ''' Fill tab event->connec of connec '''
        
        self.tbl_event_node = self.dialog.findChild(QTableView, "tbl_event_node") 
        
        # Set signals
        self.doc_user_3 = self.dialog.findChild(QComboBox, "doc_user_3") 
        self.doc_user_3.activated.connect(self.get_doc_user_3)
       
        self.event_id_3 = self.dialog.findChild(QComboBox, "event_id_3") 
        self.event_id_3.activated.connect(self.get_event_id_3)
        
        self.event_type_3 = self.dialog.findChild(QComboBox, "event_type_3") 
        self.event_type_3.activated.connect(self.get_event_type_3)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to_3.dateChanged.connect(self.get_date_event_element_3)
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
            self.model_connec.setRequest(request)
            self.model_connec.loadLayer()
            self.tbl_event_node.setModel(self.model_connec)


    def get_doc_user_3(self):
        ''' Get selected value from combobox doc_user_2
        Filter the table related on selected value '''
        
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
            if ((self.event_id_3_value =='null')&(self.event_type_3_value == 'null')):  
                # Automatically fill the table, based on connec_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
                
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)
    
    
    def get_event_id_3(self):
        ''' Get selected value from combobox event_id
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'')
        
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
        ''' Get selected value from combobox event_type_3
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get connec_id
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id")
      
        # Filter and set table 
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'')
        
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
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''
   
        date_from=self.date_document_from_3.date() 
        date_to=self.date_document_to_3.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_3.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_3.date().toString('yyyyMMdd')+ ' AND "connec_id" ='+ self.connec_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model_connec.setRequest(request)
        self.model_connec.loadLayer()
        self.tbl_event_node.setModel(self.model_connec)  
        
    
    def fill_hydrometer(self):
        ''' Fill hydrometer tab of connec
        Filter and fill table related with connec_id '''

        self.tbl_dae = self.dialog.findChild(QTableView, "tbl_dae") 
        # Define signal ->on dateChanged fill tbl_document

        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_hydrometer_x_connec")
        if layerList: 
            
            layer_hydro = layerList[0]
            self.cache_hydro = QgsVectorLayerCache(layer_hydro, 10000)
            self.model_hydro = QgsAttributeTableModel(self.cache_hydro)

            # Get connec_id from selected connec
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_hydro.setRequest(request)
            self.model_hydro.loadLayer()
            self.tbl_dae.setModel(self.model_hydro)

            
    def fill_log_connec(self):
        ''' Fill log/connec tab of connec
        Filter and fill table related with connec_id '''
        
        self.tbl_log_connec = self.dialog.findChild(QTableView, "tbl_log_connec") 
        # Define signal ->on dateChanged fill tbl_document

        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_audit_connec")
        if layerList: 
            
            layer_log = layerList[0]
            self.cache_log = QgsVectorLayerCache(layer_log, 10000)
            self.model_log = QgsAttributeTableModel(self.cache_log)
            
            # Fill ComboBoxes
            # Fill ComboBox log_connec_user
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_connec_user",rows)
            
            # Fill ComboBox log_connec_event
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_connec_event",rows)
            
            # Fill ComboBox log_connec_event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_connec_event_type",rows) 
            
            # Get connec_id from selected connec
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_log.setRequest(request)
            self.model_log.loadLayer()
            self.tbl_log_connec.setModel(self.model_log)
            
            
    def fill_log_element(self):
        ''' Fill log/element tab of connec
        Filter and fill table related with connec_id '''
        
        self.tbl_log_element = self.dialog.findChild(QTableView, "tbl_log_element") 
        # Define signal ->on dateChanged fill tbl_document
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_audit_element")
        if layerList: 
            
            layer_elem = layerList[0]
            self.cache_elem = QgsVectorLayerCache(layer_elem, 10000)
            self.model_elem = QgsAttributeTableModel(self.cache_elem)
            
            # Fill ComboBoxes
            # Fill ComboBox log_element_user
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_user",rows)
            
            # Fill ComboBox log_element_event
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_event",rows)
            
            # Fill ComboBox log_element_event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_connec ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_event_type",rows)
            
            # Get connec_id from selected connec
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_elem.setRequest(request)
            self.model_elem.loadLayer()
            self.tbl_log_element.setModel(self.model_elem)
        
        
    def fill_connec_event_element(self):
        ''' Fill tab event -> element of connec '''
  
        self.tbl_event_element = self.dialog.findChild(QTableView, "tbl_event_element") 
        
        # Set signals
        self.doc_user_2 = self.dialog.findChild(QComboBox, "doc_user_2") 
        self.doc_user_2.activated.connect(self.get_doc_user_2)
        self.event_id = self.dialog.findChild(QComboBox, "event_id") 
        self.event_id.activated.connect(self.get_event_id)
        self.event_type = self.dialog.findChild(QComboBox, "event_type") 
        self.event_type.activated.connect(self.get_event_type)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to_2.dateChanged.connect(self.get_date_event_element_2)
        self.date_document_from_2.dateChanged.connect(self.get_date_event_element_2)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_element_x_connec")
        if layerList: 
            
            layer_element = layerList[0]
            self.cache_element = QgsVectorLayerCache(layer_element, 10000)
            self.model_element = QgsAttributeTableModel(self.cache_element)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_2
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_element_x_connec ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_2",rows)
            
            # Fill ComboBox event_id
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_element_x_connec ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id",rows)
            
            # Fill ComboBox event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_element_x_connec ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type",rows)
            
            # Get connec_id from selected node
            self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
            
            # Get element_id of selected node from v_ui_event_x_node
            '''
            sql = "SELECT element_id FROM "+self.schema_name+".v_ui_event_x_node WHERE node_id = '"+self.node_id_selected+"'" 
            print("working")
            print(sql)
            element_id = self.dao.get_row(sql)
            self.element_id_value = (str(event_id[0]))
            print ("value event_id:")
            '''
                 
            # Automatically fill the table ->tbl_event_element, based on connec_id 
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_element.setRequest(request)
            self.model_element.loadLayer()
            self.tbl_event_element.setModel(self.model_element)
            
            
    def get_doc_user_2(self):
        
        # Get selected value from ComboBoxs
        self.log_element_user_value = utils_giswater.getWidgetText("doc_user_2")
        self.log_element_event_value = utils_giswater.getWidgetText("event_id")
        self.log_element_event_type_value = utils_giswater.getWidgetText("event_type")
        
        # Get node_id from selected node
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
        
        # Filter database v_ui_event_x_element_x_connec related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element_x_connec
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.log_element_event_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if (self.log_element_event_type_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "user" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_event_value !='null')&(self.log_element_event_type_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.log_element_user_value == 'null'): 
            if (self.log_element_event_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'') 
            if (self.log_element_event_type_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
            if ((self.log_element_event_value !='null')&(self.log_element_event_type_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
            if((self.log_element_event_value =='null')&(self.log_element_event_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' ) 
         
        # Restore table 
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)        
            
            
    def get_event_id (self):
        
        # Get selected value from ComboBoxs
        self.log_element_user_value = utils_giswater.getWidgetText("doc_user_2")
        self.log_element_event_value = utils_giswater.getWidgetText("event_id")
        self.log_element_event_type_value = utils_giswater.getWidgetText("event_type")
        
        # Get connec_id from selected node
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
        
        # Filter database v_ui_event_x_element_x_connec related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element_connec
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.log_element_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if (self.log_element_event_type_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_user_value !='null')&(self.log_element_event_type_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.log_element_event_value == 'null'): 
            if (self.log_element_user_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'') 
            if (self.log_element_event_type_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
            if ((self.log_element_user_value !='null')&(self.log_element_event_type_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
            if((self.log_element_user_value =='null')&(self.log_element_event_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' ) 

        # Restore table 
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)
        
     
    def get_event_type (self):
        
        # Get selected value from ComboBoxs
        self.log_element_user_value = utils_giswater.getWidgetText("doc_user_2")
        self.log_element_event_value = utils_giswater.getWidgetText("event_id")
        self.log_element_event_type_value = utils_giswater.getWidgetText("event_type")
        
        # Get connec_id from selected node
        self.connec_id_selected = utils_giswater.getWidgetText("connec_id") 
        
        # Filter database v_ui_event_x_element_x_connec related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element_x_connec
        expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # Combobox event_type is selected
        if (self.log_element_user_value !='null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
        if (self.log_element_event_value != 'null'):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_user_value !='null')&(self.log_element_event_value != 'null')):
            expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_type is returned to 'null'
        if (self.log_element_event_type_value == 'null'): 
            if (self.log_element_user_value !='null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'') 
            if (self.log_element_event_value != 'null'):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'') 
            if ((self.log_element_user_value !='null')&(self.log_element_event_value != 'null')):
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'')  
        
            if((self.log_element_user_value =='null')&(self.log_element_event_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"connec_id" ='+ self.connec_id_selected+'' ) 
         
        # Restore table 
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)
     
     
    def get_date_event_element_2(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''

        date_from = self.date_document_from_2.date() 
        date_to = self.date_document_to_2.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_2.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_2.date().toString('yyyyMMdd')+ ' AND "connec_id" ='+ self.connec_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)
        
        