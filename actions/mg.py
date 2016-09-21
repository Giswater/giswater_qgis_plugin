# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QFileDialog, QMessageBox

import os
import sys

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater    

from ..ui.change_node_type import ChangeNodeType                # @UnresolvedImport
from ..ui.config import Config                                  # @UnresolvedImport
from ..ui.result_compare_selector import ResultCompareSelector  # @UnresolvedImport
from ..ui.table_wizard import TableWizard                       # @UnresolvedImport
from ..ui.topology_tools import TopologyTools                   # @UnresolvedImport


class Mg():
   
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''  
          
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao         
        self.schema_name = self.controller.schema_name    
        # Get files to execute giswater jar
        self.java_exe = self.settings.value('files/java_exe')          
        self.giswater_jar = self.settings.value('files/giswater_jar')          
        self.gsw_file = self.settings.value('files/gsw_file')                    
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError as e:
            print "AttributeError: "+str(e)   
                

    def mg_arc_topo_repair(self):
        ''' Button 19. Topology repair '''

        # Create dialog to check wich topology functions we want to execute
        self.dlg = TopologyTools()     
        if self.project_type == 'ws':
            self.dlg.check_node_sink.setEnabled(False)     
 
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.mg_arc_topo_repair_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'topology_tools')                
        self.dlg.exec_()   
    
    
    def mg_arc_topo_repair_accept(self):
        ''' Button 19. Executes functions that are selected '''
        
        if self.dlg.check_node_orphan.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_orphan();"  
            self.controller.execute_sql(sql) 
            
        if self.dlg.check_node_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();"  
            self.controller.execute_sql(sql) 
            
        if self.dlg.check_connec_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();"  
            self.controller.execute_sql(sql) 
            
        if self.dlg.check_arc_same_startend.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();"  
            self.controller.execute_sql(sql) 
            
        if self.dlg.check_node_sink.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"  
            self.controller.execute_sql(sql) 
         
        # Show message and close the dialog    
        message = "Selected functions have been executed"
        self.controller.show_info(message, context_name='ui_message' ) 
        self.close_dialog()         
            
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
        
        # Create dialog to select CSV file and table to import contents to
        self.dlg = TableWizard()
        self.dlg.txt_file_path.setText(self.file_path)   
        table_list.sort()  
        for row in table_list:
            self.dlg.cbo_table.addItem(row)                
 
        # Set signals
        self.dlg.btn_select_file.clicked.connect(self.mg_table_wizard_select_file)
        self.dlg.btn_import_csv.clicked.connect(self.mg_table_wizard_import_csv)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'table_wizard')  
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
        table_name = utils_giswater.getWidgetText(self.dlg.cbo_table)  
        delimiter = utils_giswater.getWidgetText(self.dlg.cbo_delimiter)  
        header_status = self.dlg.chk_header.checkState()             
        
        # Get CSV file. Check if file exists
        self.file_path = self.dlg.txt_file_path.toPlainText()
        if not os.path.exists(self.file_path):
            message = "Selected file not found: "+self.file_path
            self.controller.show_warning(message, context_name='ui_message' )
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
            message = "Selected CSV has been imported successfully"
            self.controller.show_info(message, context_name='ui_message' )
            
                    
    def mg_go2epa_express(self):
        ''' Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            message = "Java Runtime executable file not found at: "+self.java_exe
            self.controller.show_warning(message, context_name='ui_message' ),10
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            message = "Giswater executable file not found at: "+self.giswater_jar
            self.controller.show_warning(message, context_name='ui_message' ),10
            return  

        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.gsw_file
            self.controller.show_info(message, context_name='ui_message' ),10
            self.gsw_file = ""    
        
        # Start program     
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            program = [self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "mg_go2epa_express"]
        else:
            program = [self.java_exe, "-jar", self.giswater_jar, "", "mg_go2epa_express"]
            
        self.controller.start_program(program)   
        
        # Show information message    
        message = "Executing... "+aux
        self.controller.show_info(message, context_name='ui_message' )       
                
    def mg_result_selector(self):
        ''' Button 25. Result selector '''
        
        # Create the dialog and signals
        self.dlg = ResultCompareSelector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.mg_result_selector_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)     
        
        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(result_id) FROM "+self.schema_name+".rpt_cat_result ORDER BY result_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("rpt_selector_result_id", rows) 
        utils_giswater.fillComboBox("rpt_selector_compare_id", rows)     
        
        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM "+self.schema_name+".rpt_selector_result"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setWidgetText("rpt_selector_result_id", row["result_id"])             
        sql = "SELECT result_id FROM "+self.schema_name+".rpt_selector_compare"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setWidgetText("rpt_selector_compare_id", row["result_id"])             
        
        # Open the dialog
        self.dlg.exec_()            
                   
        
    def mg_result_selector_accept(self):
        ''' Update current values to the table '''
           
        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = utils_giswater.getWidgetText("rpt_selector_result_id")
        rpt_selector_compare_id = utils_giswater.getWidgetText("rpt_selector_compare_id")

        # Delete previous values
        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql= "DELETE FROM "+self.schema_name+".rpt_selector_result" 
        self.dao.execute_sql(sql)
        sql= "DELETE FROM "+self.schema_name+".rpt_selector_compare" 
        self.dao.execute_sql(sql)
        sql= "INSERT INTO "+self.schema_name+".rpt_selector_result VALUES ('"+rpt_selector_result_id+"');"
        self.dao.execute_sql(sql)
        sql= "INSERT INTO "+self.schema_name+".rpt_selector_compare VALUES ('"+rpt_selector_compare_id+"');"
        self.dao.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message' ) 
        self.close_dialog(self.dlg) 


    def mg_flow_exit(self):
        ''' Button 27. Valve analytics ''' 
                
        # Execute SQL function  
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.controller.execute_sql(sql)      
        if result:
            message = "Valve analytics executed successfully"
            self.controller.show_info(message, 30, context_name='ui_message' )


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
            message = "You have to select at least one feature!"
            self.controller.show_info(message, context_name='ui_message' )   
            return 
        elif count > 1:  
            message = "More than one feature selected. Only the first one will be processed!"
            self.controller.show_info(message, context_name='ui_message' ) 
            
                    
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
        utils_giswater.setDialog(self.dlg)
        utils_giswater.fillComboBox("node_type_type_new", rows) 
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'change_node_type') 
        self.dlg.exec_()    
     
     
    def mg_change_elem_type_get_value(self, index):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 
        
        # Get selected value from 1st combobox
        self.value_combo1 = utils_giswater.getWidgetText("node_type_type_new")   
        
        # When value is selected, enabled 2nd combo box
        if self.value_combo1 != 'null':
            self.dlg.node_node_type_new.setEnabled(True)  
            # Fill 2nd combo_box-custom node type
            sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".node_type WHERE type='"+self.value_combo1+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_node_type_new", rows)
       
       
    def mg_change_elem_type_get_value_2(self, index):    
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) ''' 

        if index == -1:
            return
        
        # Get selected value from 2nd combobox
        self.value_combo2 = utils_giswater.getWidgetText("node_node_type_new")         
        
        # When value is selected, enabled 3rd combo box
        if self.value_combo2 != 'null':
            # Get selected value from 2nd combobox
            self.dlg.node_nodecat_id.setEnabled(True)
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql+= " FROM "+self.schema_name+".cat_node"
            sql+= " WHERE nodetype_id='"+self.value_combo2+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_nodecat_id", rows)     
    
    
    def mg_change_elem_type_get_value_3(self, index):
        self.value_combo3 = utils_giswater.getWidgetText("node_nodecat_id")      
        
        
    def mg_change_elem_type_accept(self):
        ''' Update current type of node and save changes in database '''

        # Update node_type in the database
        sql = "UPDATE "+self.schema_name+".v_edit_node"
        sql+= " SET node_type ='"+self.value_combo2+"'"
        if self.value_combo3 != 'null':
            sql+= ", nodecat_id='"+self.value_combo3+"'"
        sql+= " WHERE node_id ='"+self.node_id+"'"
        self.dao.execute_sql(sql)
        
        # Show message to the user
        message = "Node type has been update!"
        self.controller.show_info(message, context_name='ui_message' ) 
        
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
        self.dlg = Config()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.mg_config_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Set values from widgets of type QSoubleSpinBox
        utils_giswater.setWidgetText("node_proximity", row["node_proximity"])
        utils_giswater.setWidgetText("arc_searchnodes", row["arc_searchnodes"])
        utils_giswater.setWidgetText("node2arc", row["node2arc"])
        utils_giswater.setWidgetText("connec_proximity", row["connec_proximity"])
        #utils_giswater.setWidgetText("arc_toporepair", row["arc_toporepair"])
        utils_giswater.setWidgetText("vnode_update_tolerance", row["vnode_update_tolerance"])
        utils_giswater.setWidgetText("node_duplicated_tolerance", row["node_duplicated_tolerance"])
        #utils_giswater.setWidgetText("connec_duplicated_tolerance", row["connec_duplicated_tolerance"])

        # Set values from widgets of type QCheckbox  
        self.dlg.orphannode.setChecked(bool(row["orphannode_delete"]))
        self.dlg.arcendpoint.setChecked(bool(row["nodeinsert_arcendpoint"]))
        self.dlg.nodetypechanged.setChecked(bool(row["nodetype_change_enabled"]))
        self.dlg.samenode_init_end_control.setChecked(bool(row["samenode_init_end_control"]))
        self.dlg.node_proximity_control.setChecked(bool(row["node_proximity_control"]))
        self.dlg.connec_proximity_control.setChecked(bool(row["connec_proximity_control"]))
        self.dlg.audit_function_control.setChecked(bool(row["audit_function_control"]))
  
        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodeinsert_catalog_vdefault", rows) 
        utils_giswater.setWidgetText("nodeinsert_catalog_vdefault", row["nodeinsert_catalog_vdefault"])        
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'config')               
        self.dlg.exec_()    
    
  
    def mg_config_get_new_values(self):
        ''' Get new values from all the widgets '''
        
        # Get new values from widgets of type QSoubleSpinBox
        self.new_value_prox = utils_giswater.getWidgetText("node_proximity").replace(",", ".")
        self.new_value_arc = utils_giswater.getWidgetText("arc_searchnodes").replace(",", ".")
        self.new_value_node = utils_giswater.getWidgetText("node2arc").replace(",", ".")
        self.new_value_con = utils_giswater.getWidgetText("connec_proximity").replace(",", ".")
        #self.new_value_arc_top = utils_giswater.getWidgetText("arc_toporepair").replace(",", ".")
        self.new_value_arc_tolerance = utils_giswater.getWidgetText("vnode_update_tolerance").replace(",", ".")
        self.new_value_node_duplicated_tolerance = utils_giswater.getWidgetText("node_duplicated_tolerance").replace(",", ".")
        #self.new_value_connec_duplicated_tolerance = utils_giswater.getWidgetText("connec_duplicated_tolerance").replace(",", ".")
        
        # Get new values from widgets of type QComboBox
        self.new_value_combobox = utils_giswater.getWidgetText("nodeinsert_catalog_vdefault")
        
        # Get new values from widgets of type  QCheckBox
        self.new_value_orpha = self.dlg.orphannode.isChecked()
        self.new_value_nodetypechanged = self.dlg.nodetypechanged.isChecked()
        self.new_value_arcendpoint = self.dlg.arcendpoint.isChecked()
        self.new_value_samenode_init_end_control = self.dlg.samenode_init_end_control.isChecked()
        self.new_value_node_proximity_control = self.dlg.node_proximity_control.isChecked()
        self.new_value_connec_proximity_control = self.dlg.connec_proximity_control.isChecked()
        self.new_value_audit_function_control = self.dlg.audit_function_control.isChecked()

    
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
        #sql+= ", arc_toporepair = "+self.new_value_arc_top
        sql+= ", vnode_update_tolerance = "+self.new_value_arc_tolerance      
        sql+= ", node_duplicated_tolerance = "+self.new_value_node_duplicated_tolerance      
        #sql+= ", connec_duplicated_tolerance = "+self.new_value_connec_duplicated_tolerance      
        sql+= ", nodeinsert_catalog_vdefault = '"+self.new_value_combobox+"'"
        sql+= ", orphannode_delete = '"+str(self.new_value_orpha)+"'"
        sql+= ", nodetype_change_enabled = '"+str(self.new_value_nodetypechanged)+"'"
        sql+= ", nodeinsert_arcendpoint = '"+str(self.new_value_arcendpoint)+"'"
        sql+= ", samenode_init_end_control = '"+str(self.new_value_samenode_init_end_control)+"'"
        sql+= ", node_proximity_control = '"+str(self.new_value_node_proximity_control)+"'"
        sql+= ", connec_proximity_control = '"+str(self.new_value_connec_proximity_control)+"'"        
        sql+= ", audit_function_control = '"+str(self.new_value_audit_function_control)+"'"        
        self.dao.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message' ) 

        self.close_dialog(self.dlg)       
                        
                