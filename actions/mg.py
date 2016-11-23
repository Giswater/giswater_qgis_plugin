# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox

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
        self.gsw_file = self.controller.plugin_settings_value('gsw_file')      
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError:
            pass   
                

    def mg_arc_topo_repair(self):
        ''' Button 19. Topology repair '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 19)
        
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
        ''' Button 21. WS/UD table wizard 
        Create dialog to select CSV file and table to import contents to ''' 
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 21)
                
        # Get CSV file path from settings file 
        self.file_path = self.controller.plugin_settings_value('csv_file')        
        if self.file_path is None:             
            self.file_path = self.plugin_dir+"/test.csv"        
        
        # Create dialog
        self.dlg = TableWizard()
        self.dlg.txt_file_path.setText(self.file_path)  
        
        # Fill combo 'table' 
        self.mg_table_wizard_get_tables()          
 
        # Set signals
        self.dlg.btn_select_file.clicked.connect(self.mg_table_wizard_select_file)
        self.dlg.btn_import_csv.clicked.connect(self.mg_table_wizard_import_csv)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'table_wizard')  
        self.dlg.exec_()            

        
    def mg_table_wizard_get_tables(self):
        ''' Get available tables from configuration table 'config_csv_import' '''
        
        self.table_dict = {} 
        self.dlg.cbo_table.addItem('', '')             
        sql = "SELECT gis_client_layer_name, table_name"
        sql+= " FROM "+self.schema_name+".config_csv_import"
        sql+= " ORDER BY gis_client_layer_name"
        rows = self.dao.get_rows(sql)
        if rows:
            for row in rows:
                elem = [row[0], row[1]]
                self.table_dict[row[0]] = row[1]     
                self.dlg.cbo_table.addItem(row[0], elem)                                 
        else:
            self.controller.show_warning("Table 'config_csv_import' is empty")
            
        
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
        self.controller.plugin_settings_set_value('csv_file', self.file_path)    
        
        
    def mg_table_wizard_import_csv(self):

        # Get selected table, delimiter, and header
        alias = utils_giswater.getWidgetText(self.dlg.cbo_table) 
        if not alias:
            self.controller.show_warning("Any table has been selected", context_name='ui_message')
            return False
        
        table_name = self.table_dict[alias]
        delimiter = utils_giswater.getWidgetText(self.dlg.cbo_delimiter)  
        header_status = self.dlg.chk_header.checkState()             
        
        # Get CSV file. Check if file exists
        self.file_path = self.dlg.txt_file_path.toPlainText()
        if not os.path.exists(self.file_path):
            message = "Selected file not found: "+self.file_path
            self.controller.show_warning(message, context_name='ui_message')
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
            self.controller.show_info(message, context_name='ui_message')
            
                    
    def mg_go2epa_express(self):
        ''' Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 24)
                
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            message = "Java Runtime executable file not found at: "+self.java_exe
            self.controller.show_warning(message, context_name='ui_message')
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            message = "Giswater executable file not found at: "+self.giswater_jar
            self.controller.show_warning(message, context_name='ui_message')
            return  

        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.gsw_file
            self.controller.show_info(message, context_name='ui_message')
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
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 25)
                
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
        self.controller.execute_sql(sql)
        sql= "DELETE FROM "+self.schema_name+".rpt_selector_compare" 
        self.controller.execute_sql(sql)
        sql= "INSERT INTO "+self.schema_name+".rpt_selector_result VALUES ('"+rpt_selector_result_id+"');"
        self.controller.execute_sql(sql)
        sql= "INSERT INTO "+self.schema_name+".rpt_selector_compare VALUES ('"+rpt_selector_compare_id+"');"
        self.controller.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message') 
        self.close_dialog(self.dlg) 


    def mg_flow_exit(self):
        ''' Button 27. Valve analytics ''' 

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 27)        
                
        # Execute SQL function  
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.controller.execute_sql(sql)      
        if result:
            message = "Valve analytics executed successfully"
            self.controller.show_info(message, 30, context_name='ui_message')


    def mg_change_elem_type(self):                
        ''' Button 28: User select one node. A form is opened showing current node_type.type 
        Combo to select new node_type.type
        Combo to select new node_type.id
        Combo to select new cat_node.id
        TODO: Trigger 'gw_trg_edit_node' has to be disabled temporarily 
        '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)        
        
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
     
     
    def mg_change_elem_type_get_value(self, index):   #@UnusedVariable
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
    
    
    def mg_change_elem_type_get_value_3(self, index):   #@UnusedVariable
        self.value_combo3 = utils_giswater.getWidgetText("node_nodecat_id")      
        
        
    def mg_change_elem_type_accept(self):
        ''' Update current type of node and save changes in database '''

        # Update node_type in the database
        sql = "UPDATE "+self.schema_name+".v_edit_node"
        sql+= " SET node_type ='"+self.value_combo2+"'"
        if self.value_combo3 != 'null':
            sql+= ", nodecat_id='"+self.value_combo3+"'"
        sql+= " WHERE node_id ='"+self.node_id+"'"
        self.controller.execute_sql(sql)
        
        # Show message to the user
        message = "Node type has been update!"
        self.controller.show_info(message, context_name='ui_message' ) 
        
        # Close dialog
        self.close_dialog()
                
                   
    def mg_config(self):                
        ''' Button 99 - Open a dialog showing data from table "config" 
        User can changge its values '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 99)        
        
        # Create the dialog and signals
        self.dlg = Config()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.mg_config_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodeinsert_catalog_vdefault", rows) 
        
        # Get data from tables: 'config', 'config_search_plus' and 'config_extract_raster_value' 
        self.generic_columns = self.mg_config_get_data('config')    
        self.search_plus_columns = self.mg_config_get_data('config_search_plus')    
        self.raster_columns = self.mg_config_get_data('config_extract_raster_value')    
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'config')               
        self.dlg.exec_()        
    
    
    def mg_config_get_data(self, tablename):                
        ''' Get data from selected table '''
        
        sql = "SELECT *"
        sql+= " FROM "+self.schema_name+"."+tablename
        row = self.dao.get_row(sql)
        if not row:
            self.controller.show_warning("Any data found in table "+tablename)
            return None
        
        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            widget_type = utils_giswater.getWidgetType(column_name)
            if widget_type is QCheckBox:
                utils_giswater.setChecked(column_name, row[column_name])                        
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
            columns.append(column_name) 
            
        return columns           

    
    def mg_config_accept(self):
        ''' Update current values to the configuration tables '''
        
        self.mg_config_accept_table('config', self.generic_columns)
        self.mg_config_accept_table('config_search_plus', self.search_plus_columns)
        self.mg_config_accept_table('config_extract_raster_value', self.raster_columns)

        # Show message and close form
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message' ) 
        self.close_dialog(self.dlg)       
    
    
    def mg_config_accept_table(self, tablename, columns):
        ''' Update values of selected 'tablename' with the content of 'columns' '''
        
        if columns is not None:       
            sql = "UPDATE "+self.schema_name+"."+tablename+" SET "         
            for column_name in columns:
                if column_name != 'id':
                    widget_type = utils_giswater.getWidgetType(column_name)
                    if widget_type is QCheckBox:
                        value = utils_giswater.isChecked(column_name)                      
                    else:
                        value = utils_giswater.getWidgetText(column_name)
                    if value is None or value == 'null':
                        sql+= column_name+" = null, "     
                    else:
                        if type(value) is not bool:
                            value = value.replace(",", ".")
                        sql+= column_name+" = '"+str(value)+"', "           
            
            sql = sql[:-2]
            self.controller.execute_sql(sql)
                        
                