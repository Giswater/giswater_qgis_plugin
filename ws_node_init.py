# -*- coding: utf-8 -*-
from qgis.core import QgsVectorLayerCache, QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest
from qgis.gui import QgsAttributeTableModel
from qgis.utils import iface
from PyQt4.QtGui import *    # @UnusedWildImport
from PyQt4.QtSql import QSqlTableModel

import os

import utils_giswater
from ws_parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a node is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = NodeDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
    
    # Manage visibility 
    feature_dialog.dialog.findChild(QComboBox, "node_type").setVisible(False)    
    feature_dialog.dialog.findChild(QComboBox, "nodecat_id").setVisible(False)    
    
    # Manage 'nodecat_id'
    nodecat_id = utils_giswater.getWidgetText("nodecat_id")
    feature_dialog.dialog.findChild(QComboBox, "nodecat_id_dummy").activated.connect(feature_dialog.change_node_cat)          
    utils_giswater.setSelectedItem("nodecat_id_dummy", nodecat_id)   
    utils_giswater.setSelectedItem("nodecat_id", nodecat_id)   
    
    # Manage 'node_type'
    node_type_id = utils_giswater.getWidgetText("node_type")
    utils_giswater.setSelectedItem("node_type_dummy", node_type_id)   
    feature_dialog.dialog.findChild(QComboBox, "node_type_dummy").activated.connect(feature_dialog.change_node_type_id)  
    feature_dialog.change_node_type_id(-1)  
      
    # Set 'epa_type' and button signals      
    feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)  
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)      
    
    
     
class NodeDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(NodeDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_node()
        
        
    def init_config_node(self):
        ''' Custom form initial configuration for 'Node' '''
        
        # Define class variables
        self.field_id = "node_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.node_type = utils_giswater.getWidgetText("node_type", False)        
        self.nodecat_id = utils_giswater.getWidgetText("nodecat_id", False)        
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)        
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")  
        self.tab_event_2 = self.dialog.findChild(QTabWidget, "tab_event_2")        
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")      
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")    
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")             
        self.tbl_rtc = self.dialog.findChild(QTableView, "tbl_rtc")             
        
        # Set signals 
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(self.delete_row_info)                    
             
        # Manage tab visibility
        self.set_tabs_visibility()
        
        # Manage i18n
        self.translate_form('ws_node')        
        
        # Define and execute query to populate combo 'node_type_dummy'
        self.fill_node_type_id()
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
        
        # Fill the info table
        table_name = "v_ui_element_x_node"
        self.fill_tbl_info(self.tbl_info, self.schema_name+"."+table_name, self.filter)
        
        # Fill the tab Document
        table_name = "v_ui_doc_x_node"
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_name, self.filter)
        
        # Fill the tab Scada
        table_name = "v_ui_scada_x_node"
        self.fill_tbl_scada(self.tbl_rtc, self.schema_name+"."+table_name, self.filter)

        # TODO: Fill the tab Event - Element
        #self.fill_node_event_element()
        
        # Fill the tab Event - Node
        #self.fill_node_event_node()
        
        # Fill the tab Log - Element
        #self.fill_log_element()
        
        # Fill the tab Log - Node
        #self.fill_log_node()
             
    
    def set_tabs_visibility(self):
        ''' Hide some tabs '''
        
        # Remove tabs: EPANET, Event, Log
        self.tab_main.removeTab(5)      
        self.tab_main.removeTab(4) 
        self.tab_main.removeTab(2) 
        
        # Get 'epa_type'
        man_visible = False
        index_tab = 0      
        if self.epa_type == 'JUNCTION':
            index_tab = 0
            self.epa_table = 'inp_junction'
        elif self.epa_type == 'RESERVOIR' or self.epa_type == 'HYDRANT':
            index_tab = 1
            self.epa_table = 'inp_reservoir'
        elif self.epa_type == 'TANK':
            index_tab = 2
            self.epa_table = 'inp_tank'
            man_visible = True           
        elif self.epa_type == 'PUMP':
            index_tab = 3
            self.epa_table = 'inp_pump'
        elif self.epa_type == 'VALVE':
            index_tab = 4
            self.epa_table = 'inp_valve'
        elif self.epa_type == 'SHORTPIPE' or self.epa_type == 'FILTER':
            index_tab = 5
            self.epa_table = 'inp_shortpipe'
        elif self.epa_type == 'MEASURE INSTRUMENT':
            index_tab = 6
        
        # Tab 'Add. info': Manage visibility of these widgets 
        utils_giswater.setWidgetVisible("label_man_tank_vmax", man_visible) 
        utils_giswater.setWidgetVisible("label_man_tank_area", man_visible) 
        utils_giswater.setWidgetVisible("man_tank_vmax", man_visible) 
        utils_giswater.setWidgetVisible("man_tank_area", man_visible) 
           
        # Tab 'EPANET': Hide some tabs depending 'epa_type'                    
        # Move 'visible' tab to last position and remove previous ones
        self.tab_analysis.tabBar().moveTab(index_tab, 5);
        for i in range(0, self.tab_analysis.count() - 1):    #@UnusedVariable
            self.tab_analysis.removeTab(0)    
        self.tab_event.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_event.count() - 1):   #@UnusedVariable
            self.tab_event.removeTab(0)      
            
   
    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''
        
        if self.epa_type == 'TANK':
            sql = "SELECT vmax, area" 
            sql+= " FROM "+self.schema_name+".man_tank"
            sql+= " WHERE "+self.field_id+" = '"+self.id+"'"
            row = self.dao.get_row(sql)           
            if row:             
                utils_giswater.setWidgetText("man_tank_vmax", str(row[0]))
                utils_giswater.setWidgetText("man_tank_area", str(row[1]))
   
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        
        if self.epa_type == 'JUNCTION':                           
            # Load combo 'pattern_id'
            combo = self.epa_table+"_pattern_id"
            table_name = "inp_pattern"
            sql = "SELECT pattern_id FROM "+self.schema_name+"."+table_name+" ORDER BY pattern_id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)
            
            self.fields_junction = ['demand', 'pattern_id']               
            sql = "SELECT "
            for i in range(len(self.fields_junction)):
                sql+= self.fields_junction[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE node_id = '"+self.id+"'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_junction)):
                    widget_name = self.epa_table+"_"+self.fields_junction[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))                
                    
        elif self.epa_type == 'TANK':
            # Load combo 'curve_id'
            combo = self.epa_table+"_curve_id"
            table_name = "inp_curve_id"            
            sql = "SELECT id FROM "+self.schema_name+".inp_curve_id ORDER BY id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)
                        
            self.fields_tank = ['initlevel', 'minlevel', 'maxlevel', 'diameter', 'minvol', 'curve_id']            
            sql = "SELECT "
            for i in range(len(self.fields_tank)):
                sql+= self.fields_tank[i]+", "
            sql = sql[:-2]
            sql+= " FROM "+self.schema_name+"."+self.epa_table+" WHERE "+self.field_id+" = '"+self.id+"'"
            row = self.dao.get_row(sql)      
            if row:
                for i in range(len(self.fields_tank)):
                    widget_name = self.epa_table+"_"+self.fields_tank[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))
             

    def save_tab_add_info(self):
        ''' Save tab from tab 'Add. info' '''   
                  
        if self.epa_type == 'TANK':
            vmax = utils_giswater.getWidgetText("man_tank_vmax", False)
            area = utils_giswater.getWidgetText("man_tank_area", False)
            sql= " UPDATE "+self.schema_name+".man_tank SET" 
            sql+= " vmax = "+str(vmax)+ ", area = "+str(area)
            sql+= " WHERE node_id = '"+self.id+"';"
            self.dao.execute_sql(sql)
            total = self.dao.rowcount
            # Perform an INSERT if any record has been updated
            # TODO: If trigger was working correctly this wouldn't be necessary!
            if total == 0:
                sql = "INSERT INTO "+self.schema_name+".man_tank (node_id, vmax, area) VALUES"
                sql+= " ('"+self.id+"', "+str(vmax)+ ", "+str(area)+");"     
                self.dao.execute_sql(sql)


    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''        
                
        #super(NodeDialog, self).save_tab_analysis()
        if self.epa_type == 'JUNCTION':
            values = []            
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_junction)):
                widget_name = self.epa_table+"_"+self.fields_junction[i]     
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_junction[i]+" = "+str(values[i])+", "
            sql = sql[:-2]      
            sql+= " WHERE node_id = '"+self.id+"'"        
            self.dao.execute_sql(sql)
            
        if self.epa_type == 'TANK':
            values = []
            sql = "UPDATE "+self.schema_name+"."+self.epa_table+" SET "
            for i in range(len(self.fields_tank)):
                widget_name = self.epa_table+"_"+self.fields_tank[i]              
                value = utils_giswater.getWidgetText(widget_name, True)     
                values.append(value)
                sql+= self.fields_tank[i]+" = "+str(values[i])+", "
            sql = sql[:-2]                
            sql+= " WHERE node_id = '"+self.id+"'"        
            self.dao.execute_sql(sql)
                            
    
    def fill_node_type_id(self):
        ''' Define and execute query to populate combo 'node_type_dummy' '''
        
        # Get node_type.type from node_type.id
        sql = "SELECT type FROM "+self.schema_name+".node_type"
        if self.node_type:
            sql+= " WHERE id = '"+self.node_type+"'"
        row = self.dao.get_row(sql)
        if row: 
            node_type_type = row[0]
            sql = "SELECT node_type.id"
            sql+= " FROM "+self.schema_name+".node_type INNER JOIN "+self.schema_name+".cat_node ON node_type.id = cat_node.nodetype_id"
            sql+= " WHERE type = '"+node_type_type+"' GROUP BY node_type.id ORDER BY node_type.id"
            rows = self.dao.get_rows(sql)              
            utils_giswater.fillComboBox("node_type_dummy", rows, False)
            utils_giswater.setWidgetText("node_type_dummy", self.node_type)
        
        
    def change_node_type_id(self, index):
        ''' Define and execute query to populate combo 'cat_nodetype_id' '''
        
        node_type_id = utils_giswater.getWidgetText("node_type_dummy", False)    
        if node_type_id:        
            utils_giswater.setWidgetText("node_type", node_type_id)    
            sql = "SELECT id FROM "+self.schema_name+".cat_node"
            sql+= " WHERE nodetype_id = '"+node_type_id+"' ORDER BY id"
            rows = self.dao.get_rows(sql)    
            utils_giswater.fillComboBox("nodecat_id_dummy", rows, False)    
            if index == -1:  
                utils_giswater.setWidgetText("nodecat_id_dummy", self.nodecat_id)    
            self.change_node_cat()
                           
                       
    def change_node_cat(self):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) '''
        nodecat_id_dummy = utils_giswater.getWidgetText("nodecat_id_dummy")
        utils_giswater.setWidgetText("nodecat_id", nodecat_id_dummy)           
        
                
    def change_epa_type(self, index):
        ''' Refresh form '''
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)     
        
        
    def delete_row_doc(self):
        ''' Delete selected document '''
        answer = self.controller.ask_question("Are you sure you want to unlink selected document?")
        if answer:
            self.upload_db_doc()
        
        
    def upload_db_doc(self):
        
        # Get data from address in memory (pointer)
        # Get Id of selected row
        row_id = self.doc_path.selectedIndexes()[0].data()
        
        # Data base element_x_node
        # Delete row 
        sql = "DELETE FROM "+self.schema_name+".v_ui_doc_x_node WHERE id='"+row_id+"'"
        self.dao.execute_sql(sql)  
        
        # Show table again without deleted row
        # Get layers
        layer_list = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_node")
        # The result is a list, lets pick the first
        if layer_list: 
            
            cache = QgsVectorLayerCache(layer_list[0], 10000)
            self.model_doc = QgsAttributeTableModel(cache)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.id+'' )
            request = QgsFeatureRequest(expr)
            self.model_doc.setRequest(request)
            self.model_doc.loadLayer()
            self.tbl_document.setModel(self.model_doc)
      
        
    def fill_tbl_document(self, widget, table_name, filter_):
        ''' Fill the table control to show documents''' 
         
        # Get widgets
        doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        btn_doc_delete = self.dialog.findChild(QPushButton, "delete_row_doc")
        
        # Set signals
        doc_user.activated.connect(self.get_doc_user)
        doc_type.activated.connect(self.get_doc_type)
        doc_tag.activated.connect(self.get_doc_tag)
        self.date_document_to.dateChanged.connect(self.get_date)
        self.date_document_from.dateChanged.connect(self.get_date)
        btn_doc_delete.clicked.connect(self.delete_row_doc)
        self.tbl_document.doubleClicked.connect(self.get_path)
        
        # TODO: Get data from related tables!
        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".v_ui_doc_x_node ORDER BY tagcat_id" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag",rows)
        
        # Fill ComboBox doccat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".v_ui_doc_x_node ORDER BY doc_type" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type",rows)
        
        # Fill ComboBox doc_user
        sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_doc_x_node ORDER BY user" 
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_user",rows)        
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)   
        
   
    def get_path(self):
        ''' Get value from selected cell ("PATH")
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_document.currentIndex().column()
        if position_column == 4:      
            # Get data from address in memory (pointer)
            self.path = self.tbl_document.selectedIndexes()[0].data()
            # Check if file exist
            if not os.path.exists(self.path):
                message = "File not found!"
                self.controller.show_warning(message)                
            else:
                # Open the document
                os.startfile(self.path)     
    
    
    def get_doc_user(self):
        ''' Get selected value from combobox doc_user
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_type_value != 'null' ):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_user is returned to 'null'
        if (self.doc_user_value == 'null'): 
            if (self.doc_type_value != 'null' ):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if ((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.id+'' )
            
        request = QgsFeatureRequest(expr)   
        self.model_doc.setRequest(request)
        self.model_doc.loadLayer()
        self.tbl_document.setModel(self.model_doc)
        
        
    def get_doc_type(self):
        ''' Get selected value from combobox doc_type
        Filter the table related on selected value '''
        
        # Get selected value from ComboBox cat_doc_type 
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\'')
        #print(expr.dump())
       
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_type is returned to 'null'
        if (self.doc_type_value == 'null'): 
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\'') 
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if ((self.doc_user_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.id+'' )
        
        request = QgsFeatureRequest(expr)     
        self.model_doc.setRequest(request)
        self.model_doc.loadLayer()
        self.tbl_document.setModel(self.model_doc)
        
    
    def get_doc_tag(self):
        ''' Get selected value from combobox doc_tag 
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxes
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.id+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'')
        #print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if (self.doc_type_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_tag is returned to 'null'
        if (self.doc_tag_value == 'null'): 
            # If ComboCox doc_user is selected
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox doc_type is selected
            if (self.doc_type_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type selected
            if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.id+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'')  
            if ((self.doc_user_value =='null')&(self.doc_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.id+'' ) 
         
        request = QgsFeatureRequest(expr)   
        self.model_doc.setRequest(request)
        self.model_doc.loadLayer()
        self.tbl_document.setModel(self.model_doc)
        
              
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''
        
        date_from = self.date_document_from.date() 
        date_to = self.date_document_to.date() 
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "node_id" ='+ self.id+'' )
        else:
            message = "Date interval not valid"
            self.controller.show_warning(message)                   
            return
       
        request = QgsFeatureRequest(expr)
        self.model_doc.setRequest(request)
        self.model_doc.loadLayer()
        self.tbl_document.setModel(self.model_doc)
    
    
    def set_model_to_table(self, widget, table_name, filter_): 
        ''' Set a model with selected filter.
        Attach that model to selected table '''
        
        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setFilter(filter_)
        model.select()    

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())      

        # Attach model to table view
        widget.setModel(model)  
        
             
    def fill_tbl_info(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        self.set_model_to_table(widget, table_name, filter_)    
        
        
    def fill_tbl_scada(self, widget, table_name, filter_):
        ''' Fill scada tab of node
        Filter and fill table related with node_id '''        
        self.set_model_to_table(widget, table_name, filter_)    
       
        
    def delete_row_info(self):
        ''' Delete selected element '''
        answer = self.controller.ask_question("Are you sure you want unlink selected element?")
        if answer:
            self.upload_db_el()
        
        
    def upload_db_el(self):
       
        # Get data from address in memory (pointer)
        # Get Id of selected row
        self.id = self.tbl_info.selectedIndexes()[0].data()
        
        # Data base element_x_node
        # Delete row 
        sql = "DELETE FROM "+self.schema_name+".v_ui_element_x_node WHERE id='"+self.id+"'"
        self.dao.execute_sql(sql)  
        
        # Show table again without deleted row
        # Get layers
        layer_list = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_element_x_node")
        # The result is a list, lets pick the first
        if layer_list: 
            layer = layer_list[0]

            cache = QgsVectorLayerCache(layer, 10000)
            self.model_info = QgsAttributeTableModel(cache)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.id+'' )
            request = QgsFeatureRequest(expr)
            self.model_info.setRequest(request)
            self.model_info.loadLayer()
            self.tbl_info.setModel(self.model_info)

    