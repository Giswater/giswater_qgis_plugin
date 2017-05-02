'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt, QSettings
from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox, QLineEdit, QTableView, QMenu, QPushButton
from PyQt4.QtSql import QSqlTableModel

import os
import sys
import webbrowser

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater    

from ..ui.change_node_type import ChangeNodeType                # @UnresolvedImport
from ..ui.config import Config                                  # @UnresolvedImport
from ..ui.result_compare_selector import ResultCompareSelector  # @UnresolvedImport
from ..ui.table_wizard import TableWizard                       # @UnresolvedImport
from ..ui.topology_tools import TopologyTools                   # @UnresolvedImport
from ..ui.multi_selector import Multi_selector                  # @UnresolvedImport
from ..ui.file_manager import FileManager                       # @UnresolvedImport

from functools import partial


class Mg():
   
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''  
          
        # Initialize instance attributes
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
            
        if self.dlg.check_topology_repair.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_arc_topology();"  
            self.controller.execute_sql(sql) 
            
        if self.dlg.check_node_sink.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"  
            self.controller.execute_sql(sql) 
         
        # Close the dialog    
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
        self.file_csv = self.controller.plugin_settings_value('file_csv')        
        if self.file_csv is None:             
            self.file_csv = self.plugin_dir+"/test.csv"        
        
        # Create dialog
        self.dlg = TableWizard()
        self.dlg.txt_file_path.setText(self.file_csv)
        
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
        if self.file_csv == '': 
            self.file_csv = self.plugin_dir
            
        # Get directory of that file
        folder_path = os.path.dirname(self.file_csv)
        os.chdir(folder_path)
        msg = "Select CSV file"
        self.file_csv = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "", '*.csv')
        self.dlg.txt_file_path.setText(self.file_csv)     

        # Save CSV file path into settings
        self.controller.plugin_settings_set_value('file_csv', self.file_csv)      
        
        
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
        self.file_csv = self.dlg.txt_file_path.toPlainText()
        if not os.path.exists(self.file_csv):
            message = "Selected file not found: "+self.file_csv
            self.controller.show_warning(message, context_name='ui_message')
            return False      
              
        # Open CSV file for read and copy into database
        rf = open(self.file_csv)
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
        
        
    def get_settings_value(self, settings, parameter):
        ''' Utility function that fix problem with network units in Windows '''
        
        file_aux = ""
        try:
            file_aux = settings.value(parameter)
            unit = file_aux[:1]
            if unit != '\\' and file_aux[1] != ':':
                path = file_aux[1:]
                file_aux = unit+":"+path
        except IndexError:
            pass   
        return file_aux
            
             
             
    def mg_go2epa(self):
        ''' Button 23. Open form to set INP, RPT and project '''

        # Initialize variables
        self.file_inp = None
        self.file_rpt = None  
        self.project_name = None    

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 23) 
        
        # Get giswater properties file
        users_home = os.path.expanduser("~")
        filename = "giswater_2.0.properties"        
        java_properties_path = users_home+os.sep+"giswater"+os.sep+"config"+os.sep+filename
        if not os.path.exists(java_properties_path):
            msg = "Giswater properties file not found: "+str(java_properties_path)
            self.controller.show_warning(msg)
            return False      
          
        # Get last GSW file from giswater properties file
        java_settings = QSettings(java_properties_path, QSettings.IniFormat)
        java_settings.setIniCodec(sys.getfilesystemencoding())          
        file_gsw = self.get_settings_value(java_settings, 'FILE_GSW')
        
        # Check if that file exists
        if not os.path.exists(file_gsw):
            msg = "Last GSW file not found: "+str(file_gsw)
            self.controller.show_warning(msg)
            return False
        
        # Get INP, RPT file path and project name from GSW file
        self.gsw_settings = QSettings(file_gsw, QSettings.IniFormat) 
        self.file_inp = self.get_settings_value(self.gsw_settings, 'FILE_INP')
        self.file_rpt = self.get_settings_value(self.gsw_settings, 'FILE_RPT')                
        self.project_name = self.gsw_settings.value('PROJECT_NAME')                                                         
                
        # Create dialog
        self.dlg = FileManager()
        utils_giswater.setDialog(self.dlg)        

        # Set widgets
        self.dlg.txt_file_inp.setText(self.file_inp)
        self.dlg.txt_file_rpt.setText(self.file_rpt)
        self.dlg.txt_result_name.setText(self.project_name)  
        
        # Set signals
        self.dlg.btn_file_inp.clicked.connect(self.mg_go2epa_select_file_inp)
        self.dlg.btn_file_rpt.clicked.connect(self.mg_go2epa_select_file_rpt)
        self.dlg.btn_accept.clicked.connect(self.mg_go2epa_accept)
              
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'file_manager')  
        self.dlg.exec_()          
        
        
    def mg_go2epa_select_file_inp(self):

        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '': 
            self.file_inp = self.plugin_dir
            
        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        msg = self.controller.tr("Select INP file")
        self.file_inp = QFileDialog.getSaveFileName(None, msg, "", '*.inp')
        self.dlg.txt_file_inp.setText(self.file_inp)     


    def mg_go2epa_select_file_rpt(self):

        # Set default value if necessary
        if self.file_rpt is None or self.file_rpt == '': 
            self.file_rpt = self.plugin_dir
            
        # Get directory of that file
        folder_path = os.path.dirname(self.file_rpt)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)        
        os.chdir(folder_path)
        msg = self.controller.tr("Select RPT file")
        self.file_rpt = QFileDialog.getSaveFileName(None, msg, "", '*.rpt')
        self.dlg.txt_file_rpt.setText(self.file_rpt)     

        
    def mg_go2epa_accept(self):
        ''' Save INP, RPT and result name into GSW file '''
        
        # Get widgets values
        self.file_inp = utils_giswater.getWidgetText('txt_file_inp')
        self.file_rpt = utils_giswater.getWidgetText('txt_file_rpt')
        self.project_name = utils_giswater.getWidgetText('txt_result_name')
        
        # Save INP, RPT and result name into GSW file
        self.gsw_settings.setValue('FILE_INP', self.file_inp)
        self.gsw_settings.setValue('FILE_RPT', self.file_rpt)
        self.gsw_settings.setValue('PROJECT_NAME', self.project_name)
                
        # Close form
        self.close_dialog(self.dlg)    
                
                    
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

        # Set project user
        user = self.controller.get_project_user()

        # Delete previous values
        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "DELETE FROM "+self.schema_name+".rpt_selector_result" 
        self.dao.execute_sql(sql)
        sql = "DELETE FROM "+self.schema_name+".rpt_selector_compare" 
        self.dao.execute_sql(sql)
        #sql = "INSERT INTO "+self.schema_name+".rpt_selector_result VALUES ('"+rpt_selector_result_id+"');"
        sql = "INSERT INTO "+self.schema_name+".rpt_selector_result (result_id, cur_user)"
        sql+= " VALUES ('"+rpt_selector_result_id+"', '"+user+"')"

        self.dao.execute_sql(sql)
        #sql = "INSERT INTO "+self.schema_name+".rpt_selector_compare VALUES ('"+rpt_selector_compare_id+"');"
        sql = "INSERT INTO "+self.schema_name+".rpt_selector_compare (result_id, cur_user)"
        sql+= " VALUES ('"+rpt_selector_compare_id+"', '"+user+"')"

        self.dao.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message') 
        self.close_dialog(self.dlg) 



    def mg_analytics(self):
        ''' Button 27. Valve analytics ''' 
                
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
        
        # Close form
        self.close_dialog()
                
                   
    def mg_config(self):                
        ''' Button 99 - Open a dialog showing data from table "config" 
        User can changge its values '''
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)        
        
        # Create the dialog and signals
        self.dlg = Config()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.mg_config_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        self.table_man_selector = "man_selector_state"
        self.table_anl_selector = "anl_selector_state"
        self.table_plan_selector = "plan_selector_state"
  
        self.dlg.btn_management.pressed.connect(partial(self.multi_selector,self.table_man_selector)) 
        self.dlg.btn_analysis.pressed.connect(partial(self.multi_selector,self.table_anl_selector)) 
        self.dlg.btn_planning.pressed.connect(partial(self.multi_selector,self.table_plan_selector)) 
        
        self.om_visit_absolute_path = self.dlg.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_absolute_path = self.dlg.findChild(QLineEdit, "doc_absolute_path")
        self.om_visit_path = self.dlg.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_path = self.dlg.findChild(QLineEdit, "doc_absolute_path")
        
        self.dlg.findChild(QPushButton, "om_path_url").clicked.connect(partial(self.open_web_browser,self.om_visit_path))
        self.dlg.findChild(QPushButton, "om_path_doc").clicked.connect(partial(self.open_file_dialog,self.om_visit_path))
        self.dlg.findChild(QPushButton, "doc_path_url").clicked.connect(partial(self.open_web_browser,self.doc_path))
        self.dlg.findChild(QPushButton, "doc_path_doc").clicked.connect(partial(self.open_file_dialog,self.doc_path))
        
        # Get om_visit_absolute_path and doc_absolute_path from config_param_text
        sql = "SELECT value FROM "+self.schema_name+".config_param_text"
        sql +=" WHERE id = 'om_visit_absolute_path'"
        row = self.dao.get_row(sql)
        if row :
            path = str(row['value'])
            self.om_visit_absolute_path.setText(path)  
        
        sql = "SELECT value FROM "+self.schema_name+".config_param_text"
        sql +=" WHERE id = 'doc_absolute_path'"
        row = self.dao.get_row(sql)
        if row : 
            path = str(row['value'])
            self.doc_absolute_path.setText(path)

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
    
    
    def open_file_dialog(self, widget):
        ''' Open File Dialog '''
        
        # Set default value from QLine
        self.file_path = utils_giswater.getWidgetText(widget)
    
        # Check if file exists
        if not os.path.exists(self.file_path):
            message = "File path doesn't exist"
            self.controller.show_warning(message, 10, context_name='ui_message')
            self.file_path = self.plugin_dir
        #else:
        # Set default value if necessary
        elif self.file_path == 'null': 
            self.file_path = self.plugin_dir
                
        # Get directory of that file
        folder_path = os.path.dirname(self.file_path)
        os.chdir(folder_path)
        msg = "Select file"
        self.file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "")

        # Separate path to components
        abs_path = os.path.split(self.file_path)

        # Set text to QLineEdit
        widget.setText(abs_path[0]+'/')     

   
    def open_web_browser(self, widget):
        ''' Display url using the default browser '''
        
        url = utils_giswater.getWidgetText(widget) 
        if url == 'null' :
            url = 'www.giswater.org'
            webbrowser.open(url)
        else :
            webbrowser.open(url)
            
                 
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
        
        self.om_visit_absolute_path = utils_giswater.getWidgetText("om_visit_absolute_path")
        self.doc_absolute_path = utils_giswater.getWidgetText("doc_absolute_path")  
        
        sql = "UPDATE "+self.schema_name+".config_param_text "
        sql+= " SET value = '"+self.om_visit_absolute_path+"'"
        sql+= " WHERE id = 'om_visit_absolute_path'" 
        self.controller.execute_sql(sql)
    
        sql = "UPDATE "+self.schema_name+".config_param_text "
        sql+= " SET value = '"+self.doc_absolute_path +"'"
        sql+= " WHERE id = 'doc_absolute_path'" 
        self.controller.execute_sql(sql)

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
                        
       
    def multi_selector(self,table):  
        ''' Execute form multi_selector ''' 
        
        # Create the dialog and signals
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)
        
        self.tbl = self.dlg_multi.findChild(QTableView, "tbl") 
        self.dlg_multi.btn_cancel.pressed.connect(self.close_dialog_multi)
           
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table)) 
        self.menu=QMenu()
        self.dlg_multi.btn_insert.setMenu(self.menu)
        
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records, self.tbl, table))  
        
        self.fill_table(self.tbl, self.schema_name+"."+table)
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_multi, 'config')               
        self.dlg_multi.exec_()
        
             
    def fill_insert_menu(self,table):
        ''' Insert menu on QPushButton->QMenu''' 
        
        self.menu.clear()
        sql = "SELECT id FROM "+self.schema_name+".value_state"
        sql+= " ORDER BY id"
        rows = self.dao.get_rows(sql) 
        # Fill menu
        for row in rows:       
            elem = row[0]
            # If not exist in table _selector_state isert to menu
            # Check if we already have data with selected id
            sql = "SELECT id FROM "+self.schema_name+"."+table+" WHERE id = '"+elem+"'"    
            row = self.dao.get_row(sql)  
            if row == None:
                self.menu.addAction(elem,partial(self.insert, elem,table))
        
                 
    def insert(self, id_action, table):
        ''' On action(select value from menu) execute SQL '''

        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)   
        self.fill_table(self.tbl, self.schema_name+"."+table)
    
        
    def delete_records(self, widget, table_name):
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return
        
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("id")
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name 
            sql+= " WHERE id IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()
        
         
    def close_dialog_multi(self, dlg=None): 
        ''' Close dialog '''
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg_multi
        try:
            dlg.close()
        except AttributeError:
            pass   
        
             
    def fill_table(self, widget, table_name): 
        ''' Set a model with selected filter.
        Attach that model to selected table '''
        
        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)        
        model.select()         

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())      

        # Attach model to table view
        widget.setModel(model)    
        