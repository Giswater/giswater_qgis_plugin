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
    ''' Function called when an arc is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ArcDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
     
    feature_dialog.dialog.findChild(QComboBox, "arccat_id").setVisible(False)         
    arccat_id = utils_giswater.getWidgetText("arccat_id", False)
    feature_dialog.change_arc_type()  
    feature_dialog.dialog.findChild(QComboBox, "cat_arctype_id").activated.connect(feature_dialog.change_arc_type)    
    feature_dialog.dialog.findChild(QComboBox, "arccat_id_dummy").activated.connect(feature_dialog.change_arc_cat)          
    utils_giswater.setSelectedItem("arccat_id_dummy", arccat_id)            
    utils_giswater.setSelectedItem("arccat_id", arccat_id)            
    
    feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)    
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)        


     
class ArcDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ArcDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_arc()
        
        
    def init_config_arc(self):
        ''' Custom form initial configuration for 'Arc' '''
        
        # Define class variables
        self.field_id = "arc_id"
        self.id = utils_giswater.getWidgetText(self.field_id, False)
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)    
        if self.epa_type == 'PIPE':
            self.epa_table = 'inp_pipe'
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")   
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")                   
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form('ws_arc')        
        
        # Fill combo 'arc type' from 'epa_type'
        self.fill_arc_type()
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the document table
        self.fill_document()
        
        # Fill the Event tab
        self.fill_arc_event_pipe()


    def set_tabs_visibility(self):
        ''' Hide some tabs '''
            
        self.tab_main.removeTab(7)      
        self.tab_main.removeTab(2)           
        self.tab_main.removeTab(3) 
        self.tab_main.removeTab(3)
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        
        if self.epa_type == 'PIPE':                                       
            self.fields_pipe = ['minorloss', 'status']               
            sql = "SELECT "
            for i in range(len(self.fields_pipe)):
                sql+= self.fields_pipe[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE "+self.field_id+" = '"+self.id+"'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_pipe)):
                    widget_name = self.epa_table+"_"+self.fields_pipe[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))  
             

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''   
                     
        #super(ArcDialog, self).save_tab_analysis()
        if self.epa_type == 'PIPE':
            values = []            
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_pipe)):
                widget_name = self.epa_table+"_"+self.fields_pipe[i]     
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_pipe[i]+" = "+str(values[i])+", "
            sql = sql[:-2]      
            sql+= " WHERE "+self.field_id+" = '"+self.id+"'"        
            self.dao.execute_sql(sql)        
                        
                        
        
    ''' Slot functions '''  
    
    def fill_arc_type(self):
        ''' Define and execute query to populate combo 'cat_arctype_id' '''
        
        cat_arctype_id = utils_giswater.getWidgetText("cat_arctype_id", False)     
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type"
        sql+= " WHERE epa_default = '"+self.epa_type+"' ORDER BY id"
        rows = self.dao.get_rows(sql)       
        utils_giswater.fillComboBox("cat_arctype_id", rows)
        utils_giswater.setWidgetText("cat_arctype_id", cat_arctype_id)
            
            
    def change_arc_type(self):
        ''' Define and execute query to populate combo 'arccat_id_dummy' '''
        
        cat_arctype_id = utils_giswater.getWidgetText("cat_arctype_id", True)    
        sql = "SELECT id FROM "+self.schema_name+".cat_arc"
        sql+= " WHERE arctype_id = "+cat_arctype_id+" ORDER BY id"   
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arccat_id_dummy", rows, False) 
        # Select first item by default         
        self.change_arc_cat()       
        
                       
    def change_arc_cat(self):
        ''' Just select item to 'real' combo 'arccat_id' (that is hidden) '''
        dummy = utils_giswater.getWidgetText("arccat_id_dummy", False)
        utils_giswater.setWidgetText("arccat_id", dummy)   
        
                
    def change_epa_type(self, index):
        ''' Just select item to 'real' combo 'arccat_id' (that is hidden) '''
        epa_type = utils_giswater.getWidgetText("epa_type", False)
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)        


    def fill_document(self):
        ''' Fill the table control to show documents'''
        
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")     
        
        # Set signals
        self.doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        self.doc_user.activated.connect(self.get_doc_user)
       
        self.cat_doc_type = self.dialog.findChild(QComboBox, "cat_doc_type") 
        self.cat_doc_type.activated.connect(self.get_cat_doc_type)
        
        self.doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.doc_tag.activated.connect(self.get_doc_tag)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_to.dateChanged.connect(self.get_date)
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        self.date_document_from.dateChanged.connect(self.get_date)
        # Signal(double click on cell),function(get_path):select individual cell("path") in QTableView and open the folder
        self.tbl_document.doubleClicked.connect(self.get_path)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_arc")
        
        # The result is a list, lets pick the first
        if layerList: 
            
            layer_a = layerList[0]
            self.cache = QgsVectorLayerCache(layer_a, 10000)
            self.model = QgsAttributeTableModel(self.cache)

            # Fill ComboBox doc_tag
            sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY tagcat_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_tag",rows)
            
            # Fill ComboBox cat_doc_type
            sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY doc_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("cat_doc_type",rows)
            
            # Fill ComboBox doc_user
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_arc ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user",rows)
            
            # Get arc_id from selected arc
            self.arc_id_selected = utils_giswater.getWidgetText("arc_id")  
            
            # Automatically fill the table, based on arc_id 
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
            
            request = QgsFeatureRequest(expr)
            self.model.setRequest(request)
            self.model.loadLayer()
            self.tbl_document.setModel(self.model)
        
   
    def get_path(self):
        ''' Get value from selected cell "PATH"
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_document.currentIndex().column()
        if position_column == 4 :      
            # Get data from address in memory (pointer)
            self.path = self.tbl_document.selectedIndexes()[0].data()
            #print(self.path)  
            # Check if file exist
            if not os.path.exists(self.path):
                message = "File not found!"
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
        self.cat_doc_type_value = utils_giswater.getWidgetText("cat_doc_type")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
    
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox doc_user and ComboBox cat_doc_type are selected
        if (self.cat_doc_type_value != 'null' ):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.cat_doc_type_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_user is returned to 'null'
        if (self.doc_user_value == 'null'): 
            # If ComboBox doc_user and ComboBox cat_doc_type are selected
            if (self.cat_doc_type_value != 'null' ):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox doc_tag are selected
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
            if ((self.cat_doc_type_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.cat_doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
            
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_document.setModel(self.model)
        
        
    def get_cat_doc_type(self):
        ''' Get selected value from combobox cat_doc_type
        Filter the table related on selected value '''
        
        # Get selected value from ComboBox cat_doc_type 
        self.cat_doc_type_value = utils_giswater.getWidgetText("cat_doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
      
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox doc_user and ComboBox cat_doc_type are selected
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\'') 
        # If ComboBox cat_doc_type and ComboBox doc_tag are selected
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox cat_doc_type is returned to 'null'
        if (self.cat_doc_type_value == 'null'): 
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox cat_doc_type and ComboBox doc_tag are selected
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
            if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.cat_doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
           
        request = QgsFeatureRequest(expr)     
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_document.setModel(self.model)
        
    
    def get_doc_tag(self):
        ''' Get selected value from combobox doc_tag 
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxes
        self.cat_doc_type_value = utils_giswater.getWidgetText("cat_doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
      
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox doc_user and ComboBox cat_doc_type are selected
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox cat_doc_type and ComboBox doc_tag are selected
        if (self.cat_doc_type_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.doc_user_value !='null')&(self.cat_doc_type_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox cat_doc_type is returned to 'null'
        if (self.doc_tag_value == 'null'): 
            # If ComboCox doc_user is selected
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox cat_doc_type is selected
            if (self.cat_doc_type_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "doc_type" = \'' +self.cat_doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type selected
            if ((self.doc_user_value !='null')&(self.cat_doc_type_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.cat_doc_type_value + '\'')  
            if((self.cat_doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
             
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_document.setModel(self.model)
        
              
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''
        
        date_from = self.date_document_from.date() 
        date_to = self.date_document_to.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "arc_id" ='+ self.arc_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model.setRequest(request)
        self.model.loadLayer()
        self.tbl_document.setModel(self.model)
        
        
    def fill_arc_event_pipe(self):
        ''' Fill arc event tab
        Define filters '''
        
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
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_arc")
        if layerList: 
            
            layer_C = layerList[0]
            self.cacheC = QgsVectorLayerCache(layer_C, 10000)
            self.modelC = QgsAttributeTableModel(self.cacheC)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_2
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_arc ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_2",rows)
            
            # Fill ComboBox event_id
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_arc ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id",rows)
            
            # Fill ComboBox event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_arc ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type",rows)
            
            # Get node_id from selected node
            self.arc_id_selected = utils_giswater.getWidgetText("arc_id") 
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.modelC.setRequest(request)
            self.modelC.loadLayer()
            self.tbl_event_element.setModel(self.modelC)
        
   
    def get_doc_user_2(self):
        ''' Get selected value from combobox doc_user_2
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_2_value = utils_giswater.getWidgetText("doc_user_2")
        self.event_id_value = utils_giswater.getWidgetText("event_id")
        self.event_type_value = utils_giswater.getWidgetText("event_type")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
        
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox event_id and ComboBox event_type are selected
        if (self.event_id_value != 'null' ):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_id" = \'' +self.event_id_value + '\'') 
        if (self.event_type_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_type" = \'' +self.event_type_value + '\'') 
        # If ComboBox doc_user_2 and ComboBox event_id and ComboBox event_type are selected
        if ((self.event_id_value !='null')&(self.event_id_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'')  
        
        # If combobox doc_user_2 is returned to 'null'
        if (self.doc_user_2_value == 'null'): 
            if (self.event_id_value != 'null' ):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\'') 
            if (self.event_type_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_type" = \'' +self.event_type_value + '\'') 
            if ((self.event_id_value !='null')&(self.event_type_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'')  
            
            if((self.event_id_value =='null')&(self.event_type_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
            
        request = QgsFeatureRequest(expr)
        self.modelC.setRequest(request)
        self.modelC.loadLayer()
        self.tbl_event_element.setModel(self.modelC)
            
        
    def get_event_id(self):
        ''' Get selected value from combobox event_id
        Filter the table related on selected value '''
        
        # Get selected value from ComboBox cat_doc_type 
        self.doc_user_2_value = utils_giswater.getWidgetText("doc_user_2")
        self.event_id_value = utils_giswater.getWidgetText("event_id")
        self.event_type_value = utils_giswater.getWidgetText("event_type")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
      
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # If ComboBox user and ComboBox event_type are selected
        if (self.doc_user_2_value !='null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value_2 + '\' AND "event_id" = \'' +self.event_id_value + '\'') 
        # If ComboBox cat_doc_type and ComboBox doc_tag are selected
        if (self.event_type_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'') 
        # If ComboBox doc_user and ComboBox cat_doc_type and ComboBox doc_tag are selected
        if ((self.doc_user_2_value !='null')&(self.event_type_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.event_id_value == 'null'): 
            if (self.doc_user_2_value !='null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_value_2 + '\'') 
            if (self.event_type_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_type" = \'' +self.event_type_value + '\'') 
            if ((self.doc_user_2_value !='null')&(self.event_type_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_type" = \'' +self.event_type_value + '\'')  
            
            if((self.doc_user_2_value =='null')&(self.event_type_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' )
           
        request = QgsFeatureRequest(expr)
        self.modelC.setRequest(request)
        self.modelC.loadLayer()
        self.tbl_event_element.setModel(self.modelC)
        
        
    def get_event_type(self):
        ''' Get selected value from combobox event_type
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_2_value = utils_giswater.getWidgetText("doc_user_2")
        self.event_id_value = utils_giswater.getWidgetText("event_id")
        self.event_type_value = utils_giswater.getWidgetText("event_type")
        # Get arc_id
        self.arc_id_selected = utils_giswater.getWidgetText("arc_id")
      
        # Filter and set table 
        expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_type" = \'' +self.event_type_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_2_value !='null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_type" = \'' +self.event_type_value + '\'') 
        if (self.event_id_value != 'null'):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'') 
        if ((self.doc_user_2_value !='null')&(self.event_id_value != 'null')):
            expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_id" = \'' +self.event_id_value + '\' AND "event_type" = \'' +self.event_type_value + '\'')  
        
        # If combobox event_type is returned to 'null'
        if (self.event_type_value == 'null'): 
            if (self.doc_user_2_value !='null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\'') 
            if (self.event_id_value != 'null'):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "event_id" = \'' +self.event_id_value + '\'') 
            if ((self.doc_user_2_value !='null')&(self.event_id_value != 'null')):
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'AND "user" = \'' +self.doc_user_2_value + '\' AND "event_id" = \'' +self.event_id_value + '\'')  
            
            if((self.doc_user_2_value =='null')&(self.event_id_value == 'null')):  
                # Automatically fill the table, based on arc_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"arc_id" ='+ self.arc_id_selected+'' ) 
               
        request = QgsFeatureRequest(expr)
        self.modelC.setRequest(request)
        self.modelC.loadLayer()
        self.tbl_event_element.setModel(self.modelC)
           
           
    def get_date_event_element(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''

        date_from = self.date_document_from_2.date() 
        date_to = self.date_document_to_2.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_2.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_2.date().toString('yyyyMMdd')+ ' AND "arc_id" ='+ self.arc_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.modelC.setRequest(request)
        self.modelC.loadLayer()
        self.tbl_event_element.setModel(self.modelC)        
        
    