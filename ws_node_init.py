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
        self.node_type = utils_giswater.getWidgetText("node_type", False)        
        self.nodecat_id = utils_giswater.getWidgetText("nodecat_id", False)        
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)  
        
        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")            
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")  
        self.tab_event_2 = self.dialog.findChild(QTabWidget, "tab_event_2")        
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")            
             
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
        self.fill_info_node()
        
        # Fill the document table
        self.fill_doc_path()
        
        # Fill the Event tab Element
        self.fill_node_event_element()
        
        # Fill the Event tab Node
        self.fill_node_event_node()
        
        # Fill the Scada tab
        self.fill_scada_tab()
        
        # Fill the log/element tab
        self.fill_log_element()
        
        # Fill the log/node tab
        self.fill_log_node()
             
    
    def set_tabs_visibility(self):
        ''' TODO: Hide some tabs '''
        
        self.tab_main.removeTab(7)      
        self.tab_main.removeTab(2) 
        
        # Hide some tabs depending 'epa_type'
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
                    
        # Move 'visible' tab to last position and remove previous ones
        '''
        self.tab_analysis.tabBar().moveTab(index_tab, 5);
        for i in range(0, self.tab_analysis.count() - 1):
            self.tab_analysis.removeTab(0)    
        self.tab_event.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_event.count() - 1):
            self.tab_event.removeTab(0)      
        '''   
            
   
    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''
        
        if self.epa_type == 'TANK':
            sql = "SELECT vmax, area" 
            sql+= " FROM "+self.schema_name+".man_tank WHERE "+self.field_id+" = '"+self.id+"'"
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
            total = self.dao.get_rowcount()
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
                            
           
        
    ''' Slot functions '''  
    
    def fill_node_type_id(self):
        ''' Define and execute query to populate combo 'node_type_dummy' '''
        
        # Get node_type.type from node_type.id
        sql = "SELECT type FROM "+self.schema_name+".node_type"
        if self.node_type:
            sql+= " WHERE id = '"+self.node_type+"'"
        row = self.dao.get_row(sql)
        if row: 
            node_type_type = row[0]
            sql = "SELECT id FROM "+self.schema_name+".node_type"
            sql+= " WHERE type = '"+node_type_type+"' ORDER BY id"
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
        
        # Warning
        msgBox = QMessageBox()
        msgBox.setText("Are you sure you want unlink element?")
        msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        ret = msgBox.exec_()
        if ret == QMessageBox.Ok:
            self.upload_db_doc()
        elif ret == QMessageBox.Discard:
            # Cancel save was clicked
            return 
        
        
    def upload_db_doc(self):
        
        position_row = self.doc_path.currentIndex().row()      
        
        # Get data from address in memory (pointer)
        # Get Id of selected row
        self.id = self.doc_path.selectedIndexes()[0].data()
        print(self.id)  
        
        # Data base element_x_node
        # Delete row 
        sql = "DELETE FROM "+self.schema_name+".v_ui_doc_x_node WHERE id='"+self.id+"'"
        self.dao.execute_sql(sql)  
        
        # Show table again without deleted row
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_node")
        # The result is a list, lets pick the first
        if layerList: 
            layer_B = layerList[0]

            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.doc_path.setModel(self.modelB)
      
        
    def fill_doc_path(self):
        ''' Fill the table control to show documents''' 
         
        self.doc_path = self.dialog.findChild(QTableView, "doc_path")     
        
        # Set signals
        self.doc_user = self.dialog.findChild(QComboBox, "doc_user") 
        self.doc_user.activated.connect(self.get_doc_user)
       
        self.doc_type = self.dialog.findChild(QComboBox, "doc_type") 
        self.doc_type.activated.connect(self.get_doc_type)
        
        self.doc_tag = self.dialog.findChild(QComboBox, "doc_tag") 
        self.doc_tag.activated.connect(self.get_doc_tag)
        
        # Set signal for bottom delete_row_doc
        self.dialog.findChild(QPushButton, "delete_row_doc").clicked.connect(self.delete_row_doc)
        
        # Define signal ->on dateChanged fill tbl_document
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_to.dateChanged.connect(self.get_date)
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        self.date_document_from.dateChanged.connect(self.get_date)

        # Signal(double click on cell),function(geth_path):select individual cell("path") in QTableView and open the folder
        self.doc_path.doubleClicked.connect(self.geth_path)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_doc_x_node")

        
        # The result is a list, lets pick the first
        if layerList: 
            layer_a = layerList[0]

            self.cache = QgsVectorLayerCache(layer_a, 10000)
            self.model = QgsAttributeTableModel(self.cache)
            
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
            
            # Get node_id from selected node
            self.node_id_selected = utils_giswater.getWidgetText("node_id")  
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            
            self.model.setRequest(request)
            self.model.loadLayer()
            self.doc_path.setModel(self.model)
        
   
    def geth_path(self):
        ''' Get value from selected cell ("PATH")
        Open the document''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.doc_path.currentIndex().column()
        if position_column == 4:      
            # Get data from address in memory (pointer)
            self.path = self.doc_path.selectedIndexes()[0].data()
            print(self.path)  
            # Check if file exist
            if not os.path.exists(self.path):
                message="File doesn't exist!"
                self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)                
            else:
                # Open the document
                os.startfile(self.path)     

            
    def showWarning(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)    
    
    
    def get_doc_user(self):
        '''Get selected value from combobox doc_user
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
        
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_type_value != 'null' ):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_user is returned to 'null'
        if (self.doc_user_value == 'null'): 
            if (self.doc_type_value != 'null' ):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            if ((self.doc_type_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.doc_type_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.doc_path.setModel(self.model)
        
        
    def get_doc_type(self):
        '''Get selected value from combobox doc_type
        Filter the table related on selected value'''
        
        # Get selected value from ComboBox cat_doc_type 
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get node_id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'')
        #print(expr.dump())
       
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'') 
        if (self.doc_tag_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_type is returned to 'null'
        if (self.doc_type_value == 'null'): 
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            if (self.doc_tag_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
            if ((self.doc_user_value !='null')&(self.doc_tag_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
            if((self.doc_user_value =='null')&(self.doc_tag_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
        
        request = QgsFeatureRequest(expr)     
        self.model.setRequest(request)
        self.model.loadLayer()
        self.doc_path.setModel(self.model)
        
    
    def get_doc_tag(self):
        '''Get selected value from combobox doc_tag 
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxes
        self.doc_type_value = utils_giswater.getWidgetText("doc_type")
        self.doc_user_value = utils_giswater.getWidgetText("doc_user")
        self.doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        # Get node_id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "tagcat_id" = \'' +self.doc_tag_value + '\'')
        #print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if (self.doc_type_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'') 
        if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\' AND "tagcat_id" = \'' +self.doc_tag_value + '\'')  
        
        # If combobox doc_tag is returned to 'null'
        if (self.doc_tag_value == 'null'): 
            # If ComboCox doc_user is selected
            if (self.doc_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\'') 
            # If ComboBox doc_type is selected
            if (self.doc_type_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "doc_type" = \'' +self.doc_type_value + '\'') 
            # If ComboBox doc_user and ComboBox cat_doc_type selected
            if ((self.doc_user_value !='null')&(self.doc_type_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value + '\' AND "doc_type" = \'' +self.doc_type_value + '\'')  
            if((self.doc_user_value =='null')&(self.doc_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' ) 
         
        request = QgsFeatureRequest(expr)   
        self.model.setRequest(request)
        self.model.loadLayer()
        self.doc_path.setModel(self.model)
        
              
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value
        '''
        
        #self.tbl_document.setModel(self.model)
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from") 
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")     
        
        date_from = self.date_document_from.date() 
        date_to = self.date_document_to.date() 
        
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "node_id" ='+ self.node_id_selected+'' )
            print(expr.dump())
        else :
            message="Valid interval!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model.setRequest(request)
        self.model.loadLayer()
        self.doc_path.setModel(self.model)
        
             
    def fill_info_node(self): 
        ''' Fill info tab of node '''
        
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")  
        
        # Set signal for bottom delete_row_info
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(self.delete_row_info) 

        # Get selected node
        self.node_id_selected = utils_giswater.getWidgetText("node_id")  
        # Get layer with selected ame
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_element_x_node")
        # The result is a list, lets pick the first
        if layerList: 
            
            layer_B = layerList[0]
            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.tbl_info.setModel(self.modelB)
       
        
    def delete_row_info(self):
        ''' Ask question to the user '''
        
        msgBox = QMessageBox()
        msgBox.setText("Are you sure you want unlink element?")
        msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        ret = msgBox.exec_()
        if ret == QMessageBox.Ok:
            self.upload_db_el()
        elif ret == QMessageBox.Discard:
            return 
        
        
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
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_element_x_node")
        # The result is a list, lets pick the first
        if layerList: 
            layer_B = layerList[0]

            self.cacheB = QgsVectorLayerCache(layer_B, 10000)
            self.modelB = QgsAttributeTableModel(self.cacheB)
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.modelB.setRequest(request)
            self.modelB.loadLayer()
            self.tbl_info.setModel(self.modelB)

            
    def fill_node_event_node(self):
        ''' Fill tab event -> node of node '''
  
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
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_node")
        if layerList: 
            layer_node = layerList[0]

            self.cache_node = QgsVectorLayerCache(layer_node, 10000)
            self.model_node = QgsAttributeTableModel(self.cache_node)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_3
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_3",rows)
            
            # Fill ComboBox event_id_3
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id_3",rows)
            
            # Fill ComboBox event_type_3
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type_3",rows)
            
            # Get node_id from selected node
            self.node_id_selected = utils_giswater.getWidgetText("node_id") 
                 
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_node.setRequest(request)
            self.model_node.loadLayer()
            self.tbl_event_node.setModel(self.model_node)
        
        
    def get_doc_user_3(self):
        ''' Get selected value from combobox doc_user_3
        Filter the table related on selected value '''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
        
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.event_id_3_value != 'null' ):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\'') 
        if (self.event_type_3_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.event_id_3_value !='null')&(self.event_id_3_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox doc_user_3 is returned to 'null'
        if (self.doc_user_3_value == 'null'): 
            if (self.event_id_3_value != 'null' ):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'') 
            if (self.event_type_3_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'') 
            if ((self.event_id_3_value !='null')&(self.event_type_3_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
            
            if((self.event_id_3_value =='null')&(self.event_type_3_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            
        request = QgsFeatureRequest(expr)
        self.model_node.setRequest(request)
        self.model_node.loadLayer()
        self.tbl_event_node.setModel(self.model_node)
    
    
    def get_event_id_3(self):
        '''Get selected value from combobox event_id
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_3_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_value_3 + '\' AND "event_id" = \'' +self.event_id_3_value + '\'') 
        if (self.event_type_3_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.doc_user_3_value !='null')&(self.event_type_3_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox event_id_3 is returned to 'null'
        if (self.event_id_3_value == 'null'): 
            if (self.doc_user_3_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'') 
            if (self.event_type_3_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'') 
            if ((self.doc_user_3_value !='null')&(self.event_type_3_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
            
            if((self.doc_user_3_value =='null')&(self.event_type_3_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
           
        request = QgsFeatureRequest(expr)
        self.model_node.setRequest(request)
        self.model_node.loadLayer()
        self.tbl_event_node.setModel(self.model_node)
        
        
    def get_event_type_3(self):  
        '''Get selected value from combobox event_type
        Filter the table related on selected value'''
        
        # Get selected value from ComboBoxs
        self.doc_user_3_value = utils_giswater.getWidgetText("doc_user_3")
        self.event_id_3_value = utils_giswater.getWidgetText("event_id_3")
        self.event_type_3_value = utils_giswater.getWidgetText("event_type_3")
        # Get id
        self.node_id_selected = utils_giswater.getWidgetText("node_id")
      
        # Filter and set table 
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.event_type_3_value + '\'')
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.doc_user_3_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if (self.event_id_3_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'') 
        if ((self.doc_user_3_value !='null')&(self.event_id_3_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\' AND "event_type" = \'' +self.event_type_3_value + '\'')  
        
        # If combobox event_type is returned to 'null'
        if (self.event_type_3_value == 'null'): 
            if (self.doc_user_3_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\'') 
            if (self.event_id_3_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.event_id_3_value + '\'') 
            if ((self.doc_user_3_value !='null')&(self.event_id_3_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.doc_user_3_value + '\' AND "event_id" = \'' +self.event_id_3_value + '\'')  
            
            if((self.doc_user_3_value =='null')&(self.event_id_3_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' ) 
               
        request = QgsFeatureRequest(expr)
        self.model_node.setRequest(request)
        self.model_node.loadLayer()
        self.tbl_event_node.setModel(self.model_node)
        
        
    def get_date_event_element_3(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''

        self.date_document_from_3 = self.dialog.findChild(QDateEdit, "date_document_from_3") 
        self.date_document_to_3 = self.dialog.findChild(QDateEdit, "date_document_to_3")     
        date_from = self.date_document_from_3.date() 
        date_to = self.date_document_to_3.date() 
        
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_3.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_3.date().toString('yyyyMMdd')+ ' AND "node_id" ='+ self.node_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model_node.setRequest(request)
        self.model_node.loadLayer()
        self.tbl_event_node.setModel(self.model_node)
        
        
    def fill_node_event_element(self):
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
        self.date_document_to_2 = self.dialog.findChild(QDateEdit, "date_document_to_2")
        self.date_document_to_2.dateChanged.connect(self.get_date_event_element_2)
        self.date_document_from_2 = self.dialog.findChild(QDateEdit, "date_document_from_2")
        self.date_document_from_2.dateChanged.connect(self.get_date_event_element_2)
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_event_x_element_x_node")
        if layerList: 
            
            layer_element = layerList[0]
            self.cache_element = QgsVectorLayerCache(layer_element, 10000)
            self.model_element = QgsAttributeTableModel(self.cache_element)
            
            # Fill ComboBoxes
            # Fill ComboBox doc_user_2
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_element_x_node ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("doc_user_2",rows)
            
            # Fill ComboBox event_id
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_element_x_node ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_id",rows)
            
            # Fill ComboBox event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_element_x_node ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("event_type",rows)
            
            # Get node_id from selected node
            self.node_id_selected = utils_giswater.getWidgetText("node_id") 
            
            # Get element_id of selected node from v_ui_event_x_node
            '''
            sql = "SELECT element_id FROM "+self.schema_name+".v_ui_event_x_node WHERE node_id = '"+self.node_id_selected+"'" 
            print("working")
            print(sql)
            element_id = self.dao.get_row(sql)
            self.element_id_value = (str(event_id[0]))
            print ("value event_id:")
            '''
                 
            # Automatically fill the table ->tbl_event_element, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
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
        self.node_id_selected = utils_giswater.getWidgetText("node_id") 
        
        # Filter database v_ui_event_x_element related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.log_element_event_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if (self.log_element_event_type_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "user" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_event_value !='null')&(self.log_element_event_type_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.log_element_user_value == 'null'): 
            if (self.log_element_event_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'') 
            if (self.log_element_event_type_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
            if ((self.log_element_event_value !='null')&(self.log_element_event_type_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
            if((self.log_element_event_value =='null')&(self.log_element_event_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' ) 
         

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
        
        # Get node_id from selected node
        self.node_id_selected = utils_giswater.getWidgetText("node_id") 
        
        # Filter database v_ui_event_x_element related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'')
        print ("value filter:")
        print(expr.dump())
        
        # Filter and set table depending on selected values from others comboboxes
        if (self.log_element_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if (self.log_element_event_type_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_user_value !='null')&(self.log_element_event_type_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_id is returned to 'null'
        if (self.log_element_event_value == 'null'): 
            if (self.log_element_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'') 
            if (self.log_element_event_type_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
            if ((self.log_element_user_value !='null')&(self.log_element_event_type_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
            if((self.log_element_user_value =='null')&(self.log_element_event_type_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' ) 
         

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
        
        # Get node_id from selected node
        self.node_id_selected = utils_giswater.getWidgetText("node_id") 
        
        # Filter database v_ui_event_x_element related with event_id
        # Filter and set table 
        # filter by event_id from v_ui_event_x_element
        expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\'')
        
        # Filter and set table depending on selected values from others comboboxes
        # Combobox event_type is selected
        if (self.log_element_user_value !='null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'') 
        if (self.log_element_event_value != 'null'):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_type" = \'' +self.log_element_event_type_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'') 
        if ((self.log_element_user_value !='null')&(self.log_element_event_value != 'null')):
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\' AND "event_type" = \'' +self.log_element_event_type_value + '\'')  
        
        # If combobox event_type is returned to 'null'
        if (self.log_element_event_type_value == 'null'): 
            if (self.log_element_user_value !='null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\'') 
            if (self.log_element_event_value != 'null'):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "event_id" = \'' +self.log_element_event_value + '\'') 
            if ((self.log_element_user_value !='null')&(self.log_element_event_value != 'null')):
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'AND "user" = \'' +self.log_element_user_value + '\' AND "event_id" = \'' +self.log_element_event_value + '\'')  
        
            if((self.log_element_user_value =='null')&(self.log_element_event_value == 'null')):  
                # Automatically fill the table, based on node_id if all value of Comboboxes are 'null'
                expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' ) 
         

        # Restore table 
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)
     
     
    def get_date_event_element_2(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value '''
        
        self.date_document_from_2 = self.dialog.findChild(QDateEdit, "date_document_from_2") 
        self.date_document_to_2 = self.dialog.findChild(QDateEdit, "date_document_to_2")     
        date_from = self.date_document_from_2.date() 
        date_to = self.date_document_to_2.date() 
        
        if (date_from < date_to):
            expr = QgsExpression('format_date("timestamp",\'yyyyMMdd\') > ' + self.date_document_from_2.date().toString('yyyyMMdd')+'AND format_date("timestamp",\'yyyyMMdd\') < ' + self.date_document_to_2.date().toString('yyyyMMdd')+ ' AND "node_id" ='+ self.node_id_selected+'' )
        else:
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return
      
        request = QgsFeatureRequest(expr)
        self.model_element.setRequest(request)
        self.model_element.loadLayer()
        self.tbl_event_element.setModel(self.model_element)
        
        
    def fill_scada_tab(self):
        '''Fill scada tab of node
        Filter and fill table related with node_id '''

        self.tbl_rtc = self.dialog.findChild(QTableView, "tbl_rtc") 
        # Define signal ->on dateChanged fill tbl_document

        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_scada_x_node")
        if layerList: 
            
            layer_scada = layerList[0]
            self.cache_scada = QgsVectorLayerCache(layer_scada, 10000)
            self.model_scada = QgsAttributeTableModel(self.cache_scada)

            # Get node_id from selected node
            self.node_id_selected = utils_giswater.getWidgetText("node_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_scada.setRequest(request)
            self.model_scada.loadLayer()
            self.tbl_rtc.setModel(self.model_scada)
                  
            
    def fill_log_node(self):
        '''Fill log/node tab of node
        Filter and fill table related with node_id '''

        self.tbl_log_connec = self.dialog.findChild(QTableView, "tbl_log_connec") 
        # Define signal ->on dateChanged fill tbl_document
        
        # Get layers
        layerList = QgsMapLayerRegistry.instance().mapLayersByName("v_ui_audit_node")
        if layerList: 
            
            layer_log = layerList[0]
            self.cache_log = QgsVectorLayerCache(layer_log, 10000)
            self.model_log = QgsAttributeTableModel(self.cache_log)
            
            # Fill ComboBoxes
            # Fill ComboBox log_user_user
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_user_user",rows)
            
            # Fill ComboBox log_node_event
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_node_event",rows)
            
            # Fill ComboBox log_node_event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_node_event_type",rows)
            
            # Get connec_id from selected connec
            self.connec_id_selected = utils_giswater.getWidgetText("node_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_log.setRequest(request)
            self.model_log.loadLayer()
            self.tbl_log_connec.setModel(self.model_log)
            
            
    def fill_log_element(self):
        '''Fill log/element tab of node
        Filter and fill table related with node_id '''
        
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
            sql = "SELECT DISTINCT(user) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY user" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_user",rows)
            
            # Fill ComboBox log_element_event
            sql = "SELECT DISTINCT(event_id) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_id" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_event",rows)
            
            # Fill ComboBox log_element_event_type
            sql = "SELECT DISTINCT(event_type) FROM "+self.schema_name+".v_ui_event_x_node ORDER BY event_type" 
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("log_element_event_type",rows)
            
            # Get connec_id from selected connec
            self.node_id_selected = utils_giswater.getWidgetText("node_id") 
            
            # Automatically fill the table, based on node_id 
            expr = QgsExpression ('"node_id" ='+ self.node_id_selected+'' )
            request = QgsFeatureRequest(expr)
            self.model_elem.setRequest(request)
            self.model_elem.loadLayer()
            self.tbl_log_element.setModel(self.model_elem)
            
        