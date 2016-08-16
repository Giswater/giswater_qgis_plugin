# -*- coding: utf-8 -*-
from qgis.core import QgsExpression, QgsFeatureRequest
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QFileDialog, QMessageBox

import os
import subprocess

#from utils_giswater import *      
from ..utils_giswater import *
from ..ui.change_node_type import ChangeNodeType    # @UnresolvedImport
from ..ui.config import Config                      # @UnresolvedImport
from ..ui.table_wizard import TableWizard           # @UnresolvedImport


class Mg():
   
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''    
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir= plugin_dir       
        self.dao = self.controller.getDao()             
        self.schema_name = self.controller.schema_name    
        # Get files to execute giswater jar
        self.java_exe = self.settings.value('files/java_exe')          
        self.giswater_jar = self.settings.value('files/giswater_jar')          
        self.gsw_file = self.settings.value('files/gsw_file')                    
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        if dlg is None:
            dlg = self.dlg   
        dlg.close()    
                

    def mg_delete_node(self):
        ''' Button 17. User select one node. 
        Execute SQL function 'gw_fct_delete_node' 
        Show warning (if any) '''

        # Get selected features (from layer 'node')          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.controller.show_warning("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_warning("More than one feature selected. Only the first one will be processed!")     
        
        features = layer.selectedFeatures()
        feature = features[0]
        node_id = feature.attribute('node_id')   
        
        # Execute SQL function and show result to the user
        function_name = "gw_fct_delete_node"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(node_id)+"');"  
        self.controller.get_row(sql)
                    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()   
                
           
    def mg_connec_tool(self):
        ''' Button 20. User select connections from layer 'connec' 
        and executes function: 'gw_fct_connect_to_network' '''      

        # Get selected features (from layer 'connec')
        aux = "{"         
        layer = self.iface.activeLayer()  
        if layer.selectedFeatureCount() == 0:
            self.controller.show_warning("You have to select at least one feature!")
            return 
        features = layer.selectedFeatures()
        for feature in features:
            connec_id = feature.attribute('connec_id') 
            aux+= str(connec_id)+", "
        connec_array = aux[:-2]+"}"
        
        # Execute function
        function_name = "gw_fct_connect_to_network"        
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+connec_array+"');"  
        self.controller.execute_sql(sql) 
        
        # Refresh map canvas
        self.iface.mapCanvas().refresh() 
        
        
    def mg_table_wizard(self):
        ''' Button 21. WS/UD table wizard ''' 
        
        if self.project_type == 'ws':
            table_list = ['inp_controls', 'inp_curve', 'inp_demand', 'inp_pattern', 'inp_rules', 'cat_node', 'cat_arc']
        elif self.project_type == 'ud':   
            table_list = {'inp_controls', 'inp_curve', 'inp_transects', 'inp_timeseries', 'inp_dwf', 'inp_hydrograph', 'inp_inflows', 'inp_lid_control', 'cat_node', 'cat_arc'}
        else:
            return
        
        # Get CSV file path from settings file          
        self.file_path = self.settings.value('files/csv_file')
        if self.file_path is None:             
            self.file_path = self.plugin_dir+"/test.csv"        
        
        # Open dialog to select CSV file and table to import contents to
        self.dlg = TableWizard()
        self.dlg.txt_file_path.setText(self.file_path)   
        #utils_giswater.fillComboBox(self.dlg.cbo_table, table_list) 
        table_list.sort()  
        for row in table_list:
            self.dlg.cbo_table.addItem(row)                
 
        # Set signals
        self.dlg.btn_select_file.clicked.connect(self.mg_table_wizard_select_file)
        self.dlg.btn_import_csv.clicked.connect(self.mg_table_wizard_import_csv)

        self.dlg.exec_()            

        
    def mg_table_wizard_select_file(self):

        # Set default value if necessary
        if self.file_path == '': 
            self.file_path = self.plugin_dir
            
        # Get directory of that file
        folder_path = os.path.dirname(self.file_path)
        os.chdir(folder_path)
        msg = "Select CSV file"
        self.file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "", '*.csv')
        self.dlg.txt_file_path.setText(self.file_path)     

        # Save CSV file path into settings
        self.settings.setValue('files/csv_file', self.file_path)       
        
        
    def mg_table_wizard_import_csv(self):

        # Get selected table, delimiter, and header
        table_name = getWidgetText(self.dlg.cbo_table)  
        delimiter = getWidgetText(self.dlg.cbo_delimiter)  
        header_status = self.dlg.chk_header.checkState()             
        
        # Get CSV file. Check if file exists
        self.file_path = self.dlg.txt_file_path.toPlainText()
        if not os.path.exists(self.file_path):
            msg = "Selected file not found: "+self.file_path
            self.controller.show_warning(msg)
            return False      
              
        # Open CSV file for read and copy into database
        rf = open(self.file_path)
        sql = "COPY "+self.schema_name+"."+table_name+" FROM STDIN WITH CSV"
        if (header_status == Qt.Checked):
            sql+= " HEADER"
        sql+= " DELIMITER AS '"+delimiter+"'"
        status = self.dao.copy_expert(sql, rf)
        if status:
            self.dao.rollback()
            msg = "Cannot import CSV into table "+table_name+". Reason:\n"+str(status).decode('utf-8')
            QMessageBox.warning(None, "Import CSV", self.controller.tr(msg))
            return False
        else:
            self.dao.commit()
            msg = "Selected CSV has been imported successfully"
            self.controller.show_info(msg)
            
                    
    def mg_go2epa_express(self):
        ''' Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            self.showWarning(self.controller.tr("Java Runtime executable file not found at: "+self.java_exe), 10)
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            self.showWarning(self.controller.tr("Giswater executable file not found at: "+self.giswater_jar), 10)
            return  

        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            self.controller.show_info("GSW file not found at: "+self.gsw_file, 10)
            self.gsw_file = ""    
        
        # Execute process
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "mg_go2epa_express"])
        else:
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, "", "mg_go2epa_express"])
        
        # Show information message    
        self.controller.show_info("Executing... "+aux)    
                
        
    def mg_flow_trace(self):
        ''' Button 26. User select one node or arc.
        SQL function fills 3 temporary tables with id's: node_id, arc_id and valve_id
        Returns and integer: error code
        Get these id's and select them in its corresponding layers '''
        
        # Get selected features and layer type: 'arc' or 'node'   
        layer = self.iface.activeLayer()          
        elem_type = layer.name().lower()
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.controller.show_warning("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_warning("More than one feature selected. Only the first one will be processed!")   
         
        features = layer.selectedFeatures()
        feature = features[0]
        elem_id = feature.attribute(elem_type+'_id')   
        
        # Execute SQL function
        function_name = "gw_fct_mincut"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+elem_type+"');"  
        result = self.controller.execute_sql(sql) 
        if result:
            # Get 'arc' and 'node' list and select them 
            self.mg_flow_trace_select_features(self.layer_arc, 'arc')                         
            self.mg_flow_trace_select_features(self.layer_node, 'node')     
            
        # Refresh map canvas
        self.iface.mapCanvas().refresh()                         
                
        
    def mg_flow_trace_select_features(self, layer, elem_type):
        
        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_"+elem_type+" ORDER BY "+elem_type+"_id"  
        rows = self.dao.get_rows(sql)
        self.dao.commit()
        
        # Build an expression to select them
        aux = "\""+elem_type+"_id\" IN ("
        for elem in rows:
            aux+= elem[0]+", "
        aux = aux[:-2]+")"
        
        # Get a featureIterator from this expression:
        expr = QgsExpression(aux)
        if expr.hasParserError():
            self.controller.show_message("Expression Error: "+str(expr.parserErrorString()))
            return        
        it = layer.getFeatures(QgsFeatureRequest(expr))
        
        # Build a list of feature id's from the previous result
        id_list = [i.id() for i in it]
        
        # Select features with these id's 
        layer.setSelectedFeatures(id_list)   
        
        
    def mg_flow_exit(self):
        ''' Button 27. Valve analytics ''' 
                
        # Execute SQL function
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.dao.get_row(sql) 
        self.dao.commit()   

        # Manage SQL execution result
        if result is None:
            self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
            return   
        elif result[0] == 0:
            self.controller.show_info("Process completed", 50)    
        else:
            self.controller.show_warning("Undefined error")    
            return       
        

    def mg_change_elem_type(self):                
        ''' Button 28: User select one node. A form is opened showing current node_type.type 
        Combo to select new node_type.type
        Combo to select new node_type.id
        Combo to select new cat_node.id
        TODO: Trigger 'gw_trg_edit_node' has to be disabled temporarily 
        '''
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.controller.show_info("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_info("More than one feature selected. Only the first one will be processed!")
                    
        # Get selected features (nodes)           
        features = layer.selectedFeatures()
        feature = features[0]
        # Get node_id form current node
        self.node_id = feature.attribute('node_id')

        # Get node_type from current node
        node_type = feature.attribute('node_type')
        
        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()
        self.dlg.node_node_type.setText(node_type)
        self.dlg.node_type_type_new.currentIndexChanged.connect(self.mg_change_elem_type_get_value)         
        self.dlg.node_node_type_new.currentIndexChanged.connect(self.mg_change_elem_type_get_value_2)
        self.dlg.node_nodecat_id.currentIndexChanged.connect(self.mg_change_elem_type_get_value_3)           
        self.dlg.btn_accept.pressed.connect(self.mg_change_elem_type_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        setDialog(self.dlg)
        fillComboBox("node_type_type_new", rows) 
    
        # Open the dialog
        self.dlg.exec_()    
     
     
    def mg_change_elem_type_get_value(self, index):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 
        
        # Get selected value from 1st combobox
        self.value_combo1 = getWidgetText("node_type_type_new")   
        
        # When value is selected, enabled 2nd combo box
        if self.value_combo1 != 'null':
            self.dlg.node_node_type_new.setEnabled(True)  
            # Fill 2nd combo_box-custom node type
            sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".node_type WHERE type='"+self.value_combo1+"'"
            rows = self.dao.get_rows(sql)
            fillComboBox("node_node_type_new", rows)
       
       
    def mg_change_elem_type_get_value_2(self, index):    
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 

        if index == -1:
            return
        
        # Get selected value from 2nd combobox
        self.value_combo2 = getWidgetText("node_node_type_new")         
        
        # When value is selected, enabled 3rd combo box
        if self.value_combo2 != 'null':
            # Get selected value from 2nd combobox
            self.dlg.node_nodecat_id.setEnabled(True)
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql+= " FROM "+self.schema_name+".cat_node"
            sql+= " WHERE nodetype_id='"+self.value_combo2+"'"
            rows = self.dao.get_rows(sql)
            fillComboBox("node_nodecat_id", rows)     
    
    
    def mg_change_elem_type_get_value_3(self, index):
        self.value_combo3 = getWidgetText("node_nodecat_id")      
        
        
    def mg_change_elem_type_accept(self):
        ''' Update current type of node and save changes in database '''

        # Update node_type in the database
        sql = "UPDATE "+self.schema_name+".node"
        sql+= " SET node_type ='"+self.value_combo2+"'"
        if self.value_combo3 != 'null':
            sql+= ", nodecat_id='"+self.value_combo3+"'"
        sql+= " WHERE node_id ='"+self.node_id+"'"
        self.dao.execute_sql(sql)
        
        # Show message to the user
        self.controller.show_info("Node type has been update!")
        
        # Close dialog
        self.close_dialog()
                
                   
    def mg_config(self):                
        ''' Button 99 - Open a dialog showing data from table "config" 
        User can changge its values '''
        
        # Get data from database "config"
        # Get entire row from database 
        sql = "SELECT * FROM "+self.schema_name+".config"
        row = self.dao.get_row(sql)
        if not row:
            return
        
        # Create the dialog and signals
        self.dlg_config = Config()
        setDialog(self.dlg_config)
        self.dlg_config.btn_accept.pressed.connect(self.mg_config_accept)
        self.dlg_config.btn_cancel.pressed.connect(self.close_dialog)
        
        # Set values from widgets of type QSoubleSpinBox
        setWidgetText("node_proximity", row["node_proximity"])
        setWidgetText("arc_searchnodes", row["arc_searchnodes"])
        setWidgetText("node2arc", row["node2arc"])
        setWidgetText("connec_proximity", row["connec_proximity"])
        setWidgetText("arc_toporepair", row["arc_toporepair"])
        setWidgetText("vnode_update_tolerance", row["vnode_update_tolerance"])
        setWidgetText("node_duplicated_tolerance", row["node_duplicated_tolerance"])

        # Set values from widgets of type QCheckbox  
        self.dlg_config.orphannode.setChecked(bool(row["orphannode_delete"]))
        self.dlg_config.arcendpoint.setChecked(bool(row["nodeinsert_arcendpoint"]))
        self.dlg_config.nodetypechanged.setChecked(bool(row["nodetype_change_enabled"]))
        self.dlg_config.samenode_init_end_control.setChecked(bool(row["samenode_init_end_control"]))
        self.dlg_config.node_proximity_control.setChecked(bool(row["node_proximity_control"]))
        self.dlg_config.connec_proximity_control.setChecked(bool(row["connec_proximity_control"]))
       
        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        fillComboBox("nodeinsert_catalog_vdefault", rows) 
        setWidgetText("nodeinsert_catalog_vdefault", row["nodeinsert_catalog_vdefault"])        

        # Open the dialog
        self.dlg_config.exec_()    
    
  
    def mg_config_get_new_values(self):
        ''' Get new values from all the widgets '''
        
        # Get new values from widgets of type QSoubleSpinBox
        self.new_value_prox = getWidgetText("node_proximity").replace(",", ".")
        self.new_value_arc = getWidgetText("arc_searchnodes").replace(",", ".")
        self.new_value_node = getWidgetText("node2arc").replace(",", ".")
        self.new_value_con = getWidgetText("connec_proximity").replace(",", ".")
        self.new_value_arc_top = getWidgetText("arc_toporepair").replace(",", ".")
        self.new_value_arc_tolerance = getWidgetText("vnode_update_tolerance").replace(",", ".")
        self.new_value_node_duplicated_tolerance = getWidgetText("node_duplicated_tolerance").replace(",", ".")
        
        # Get new values from widgets of type QComboBox
        self.new_value_combobox = getWidgetText("nodeinsert_catalog_vdefault")
        
        # Get new values from widgets of type  QCheckBox
        self.new_value_orpha = self.dlg_config.orphannode.isChecked()
        self.new_value_nodetypechanged = self.dlg_config.nodetypechanged.isChecked()
        self.new_value_arcendpoint = self.dlg_config.arcendpoint.isChecked()
        self.new_value_samenode_init_end_control = self.dlg_config.samenode_init_end_control.isChecked()
        self.new_value_node_proximity_control = self.dlg_config.node_proximity_control.isChecked()
        self.new_value_connec_proximity_control = self.dlg_config.connec_proximity_control.isChecked()

    
    def mg_config_accept(self):
        ''' Update current values to the table '''
        
        # Get new values from all the widgets
        self.mg_config_get_new_values()

        # Set these values to table "config"
        sql = "UPDATE "+self.schema_name+".config" 
        sql+= " SET node_proximity = "+self.new_value_prox
        sql+= ", arc_searchnodes = "+self.new_value_arc
        sql+= ", node2arc = "+self.new_value_node
        sql+= ", connec_proximity = "+self.new_value_con
        sql+= ", arc_toporepair = "+self.new_value_arc_top
        sql+= ", vnode_update_tolerance = "+self.new_value_arc_tolerance      
        sql+= ", node_duplicated_tolerance = "+self.new_value_node_duplicated_tolerance      
        sql+= ", nodeinsert_catalog_vdefault = '"+self.new_value_combobox+"'"
        sql+= ", orphannode_delete = '"+str(self.new_value_orpha)+"'"
        sql+= ", nodetype_change_enabled = '"+str(self.new_value_nodetypechanged)+"'"
        sql+= ", nodeinsert_arcendpoint = '"+str(self.new_value_arcendpoint)+"'"
        sql+= ", samenode_init_end_control = '"+str(self.new_value_samenode_init_end_control)+"'"
        sql+= ", node_proximity_control = '"+str(self.new_value_node_proximity_control)+"'"
        sql+= ", connec_proximity_control = '"+str(self.new_value_connec_proximity_control)+"'"        
        self.dao.execute_sql(sql)

        # Show message to user
        self.controller.show_info("Values has been updated")
        self.close_dialog(self.dlg_config)       
                        
                