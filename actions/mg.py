'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt, QSettings
from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox, QLineEdit, QTableView, QMenu, QPushButton, QComboBox, QTextEdit, QDateEdit, QTimeEdit, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
from PyQt4.Qt import  QDate, QTime
from qgis.core import QgsMapLayerRegistry

from datetime import datetime, date
import os
import sys
import webbrowser
from functools import partial

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
from ..ui.multiexpl_selector import Multiexpl_selector          # @UnresolvedImport
from ..ui.mincut_edit import Mincut_edit                        # @UnresolvedImport
from ..ui.mincut_fin import Mincut_fin                          # @UnresolvedImport
from ..ui.mincut import Mincut                                  # @UnresolvedImport
from ..ui.multipsector_selector import Multipsector_selector    # @UnresolvedImport
from ..ui.plan_psector import Plan_psector                      # @UnresolvedImport
from ..ui.psector_management import Psector_management          # @UnresolvedImport

from parent import ParentAction


class Mg(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''  
                  
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''

        dlg.close()
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
            self.dlg.check_node_flow_regulator.setEnabled(False)
            self.dlg.check_node_exit_upper_node_entry.setEnabled(False)
            self.dlg.check_arc_intersection_without_node.setEnabled(False)
            self.dlg.check_inverted_arcs.setEnabled(False)
        if self.project_type == 'ud':
            self.dlg.check_topology_coherence.setEnabled(False)

        # Set signals
        self.dlg.btn_accept.clicked.connect(self.mg_arc_topo_repair_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'topology_tools')
        self.dlg.exec_()


    def mg_arc_topo_repair_accept(self):
        ''' Button 19. Executes functions that are selected '''

        #Review/Utils
        if self.dlg.check_node_orphan.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_orphan();"
            self.controller.execute_sql(sql)

        if self.dlg.check_node_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();"
            self.controller.execute_sql(sql)

        if self.dlg.check_node_state_coherence.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_state_coherence();"
            self.controller.execute_sql(sql)

        if self.dlg.check_arc_same_startend.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();"
            self.controller.execute_sql(sql)

        if self.dlg.check_arcs_without_nodes_start_end.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_no_startend_node();"
            self.controller.execute_sql(sql)

        if self.dlg.check_connec_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();"
            self.controller.execute_sql(sql)

        # Review/WS
        if self.dlg.check_topology_coherence.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_topological_consistency();"
            self.controller.execute_sql(sql)

        # Review/UD
        if self.dlg.check_node_sink.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_flow_regulator.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_flowregulator();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_exit_upper_node_entry.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_exit_upper_intro();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arc_intersection_without_node.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"
            self.controller.execute_sql(sql)
        if self.dlg.check_inverted_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"
            self.controller.execute_sql(sql)

        #Builder
        if self.dlg.create_nodes_from_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_built_nodefromarc();"
            self.controller.execute_sql(sql)
        '''
        if self.dlg.check_topology_repair.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_arc_topology();"
            self.controller.execute_sql(sql)
        '''

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
        file_gsw = utils_giswater.get_settings_value(java_settings, 'FILE_GSW')
        
        # Check if that file exists
        if not os.path.exists(file_gsw):
            msg = "Last GSW file not found: "+str(file_gsw)
            self.controller.show_warning(msg)
            return False

        # Get INP, RPT file path and project name from GSW file
        self.gsw_settings = QSettings(file_gsw, QSettings.IniFormat) 
        self.file_inp = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_INP')
        self.file_rpt = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_RPT')                
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
        self.execute_giswater("mg_go2epa_express", 24)
                        

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
        sql = "DELETE FROM "+self.schema_name+".rpt_selector_result"
        self.dao.execute_sql(sql)
        sql = "DELETE FROM "+self.schema_name+".rpt_selector_compare"
        self.dao.execute_sql(sql)
        
        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "INSERT INTO "+self.schema_name+".rpt_selector_result (result_id, cur_user)"
        sql+= " VALUES ('"+rpt_selector_result_id+"', '"+user+"')"
        self.dao.execute_sql(sql)
        sql = "INSERT INTO "+self.schema_name+".rpt_selector_compare (result_id, cur_user)"
        sql+= " VALUES ('"+rpt_selector_compare_id+"', '"+user+"')"
        self.dao.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.close_dialog(self.dlg)

    '''
=======
>>>>>>> 9cf88f7... Add class 'ParentAction' to manage common functions
    def mg_analytics(self):
        # Button 27. Valve analytics 
                
        # Execute SQL function  
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.controller.execute_sql(sql)      
        if result:
            message = "Valve analytics executed successfully"
            self.controller.show_info(message, 30, context_name='ui_message')
    '''


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
        #self.controller.check_action(True, 28)
        self.controller.check_action(True, 99)

        # Create the dialog and signals
        self.dlg = Config()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.mg_config_accept)
        self.dlg.btn_cancel.pressed.connect(self.dlg.close)

        self.table_man_selector = "man_selector_state"
        self.table_anl_selector = "anl_selector_state"
        self.table_plan_selector = "plan_selector_state"

        self.dlg.btn_management.pressed.connect(partial(self.multi_selector,self.table_man_selector))
        self.dlg.btn_analysis.pressed.connect(partial(self.multi_selector,self.table_anl_selector))
        self.dlg.btn_planning.pressed.connect(partial(self.multi_selector,self.table_plan_selector))

        # QLineEdit
        self.om_visit_absolute_path = self.dlg.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_absolute_path = self.dlg.findChild(QLineEdit, "doc_absolute_path")
        self.om_visit_path = self.dlg.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_path = self.dlg.findChild(QLineEdit, "doc_absolute_path")

        # QPushButton
        self.dlg.findChild(QPushButton, "om_path_url").clicked.connect(partial(self.open_web_browser,self.om_visit_path))
        self.dlg.findChild(QPushButton, "om_path_doc").clicked.connect(partial(self.open_file_dialog,self.om_visit_path))
        self.dlg.findChild(QPushButton, "doc_path_url").clicked.connect(partial(self.open_web_browser,self.doc_path))
        self.dlg.findChild(QPushButton, "doc_path_doc").clicked.connect(partial(self.open_file_dialog,self.doc_path))

        # QComboBox
        self.state_vdefault=self.dlg.findChild(QComboBox,"state_vdefault")
        self.psector_vdefault = self.dlg.findChild(QComboBox, "psector_vdefault")
        self.workcat_vdefault=self.dlg.findChild(QComboBox,"workcat_vdefault")
        self.verified_vdefault = self.dlg.findChild(QComboBox, "verified_vdefault")
        self.arccat_vdefault = self.dlg.findChild(QComboBox, "arccat_vdefault")
        self.nodecat_vdefault = self.dlg.findChild(QComboBox, "nodecat_vdefault")
        self.connecat_vdefault = self.dlg.findChild(QComboBox, "connecat_vdefault")

        # QDateEdit
        self.builtdate_vdefault = self.dlg.findChild(QDateEdit, "builtdate_vdefault")
        sql = 'SELECT value FROM ' + self.schema_name + '.config_vdefault WHERE "user"=current_user and parameter='+"'builtdate_vdefault'"
        row = self.dao.get_row(sql)
        if row!= None:
            utils_giswater.setCalendarDate(self.builtdate_vdefault, datetime.strptime(row[0], '%Y-%m-%d'))
        else:
            self.builtdate_vdefault.setDate(QDate.currentDate())

        # QCheckBox
        self.chk_state_vdefault = self.dlg.findChild(QCheckBox, 'chk_state_vdefault')
        self.chk_psector_vdefault = self.dlg.findChild(QCheckBox, 'chk_psector_vdefault')
        self.chk_workcat_vdefault = self.dlg.findChild(QCheckBox, 'chk_workcat_vdefault')
        self.chk_cverified_vdefault = self.dlg.findChild(QCheckBox, 'chk_cverified_vdefault')
        self.chk_builtdate_vdefault = self.dlg.findChild(QCheckBox, 'chk_builtdate_vdefault')
        self.chk_arccat_vdefault = self.dlg.findChild(QCheckBox, 'chk_arccat_vdefault')
        self.chk_nodecat_vdefault = self.dlg.findChild(QCheckBox, 'chk_nodecat_vdefault')
        self.chk_connecat_vdefault = self.dlg.findChild(QCheckBox, 'chk_connecat_vdefault')

        #self.arc_vdef_enabled.stateChanged.connect(partial(self.chec_checkbox,self.arc_vdef_enabled, self.arccat_vdefault, "arccat_vdefault"))
        #self.node_vdef_enabled.stateChanged.connect(partial(self.chec_checkbox, self.node_vdef_enabled, self.nodecat_vdefault))
        #self.connec_vdef_enabled.stateChanged.connect(partial(self.chec_checkbox, self.connec_vdef_enabled, self.connecat_vdefault))
        #self.dlg.findChild(QCheckBox, 'chk_arccat_vdefault').stateChanged.connect(partial(self.test, "check"))
        #self.dlg.findChild(QCheckBox, 'chk_nodecat_vdefault').stateChanged.connect(partial(self.test, "check"))
        #self.dlg.findChild(QCheckBox, 'chk_connecat_vdefault').stateChanged.connect(partial(self.test, "check"))
       
        self.dlg.findChild(QPushButton, "om_path_url").clicked.connect(partial(self.open_web_browser, self.om_visit_path))
        self.dlg.findChild(QPushButton, "om_path_doc").clicked.connect(partial(self.open_file_dialog, self.om_visit_path))
        self.dlg.findChild(QPushButton, "doc_path_url").clicked.connect(partial(self.open_web_browser, self.doc_path))
        self.dlg.findChild(QPushButton, "doc_path_doc").clicked.connect(partial(self.open_file_dialog, self.doc_path))
        
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

        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".value_state ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows)
        sql="SELECT DISTINCT(psector_id) FROM" +self.schema_name+".plan_psector ORDER BY psector_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)

        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".cat_work ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows)
        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".value_verified ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows)
        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".cat_arc ORDER BY id"
        rows = self.dao.get_rows(sql)

        utils_giswater.fillComboBox("arccat_vdefault", rows)
        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".cat_node ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows)
        sql="SELECT DISTINCT(id) FROM" +self.schema_name+".cat_connec ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows)

        # Set values from widgets of type QDateEdit
        sql = "SELECT DISTINCT(builtdate_vdefault) FROM" + self.schema_name + ".config"
        rows = self.dao.get_rows(sql)
        #utils_giswater.setCalendarDate("builtdate_vdefault", rows[0][0])


        # Get data from tables: 'config', 'config_search_plus' and 'config_extract_raster_value'
        self.generic_columns=self.new_mg_config_get_data('config_vdefault')
        #self.generic_columns = self.mg_config_get_data('config')
        self.search_plus_columns = self.mg_config_get_data('config_search_plus')
        self.raster_columns = self.mg_config_get_data('config_extract_raster_value')

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'config')
        self.dlg.exec_()


    # Like def mf_config_get_date(....): but for multi user
    def new_mg_config_get_data(self,tablename):
        # Like def mf_config_get_date(....): but for multi user
        
        sql = 'SELECT * FROM ' + self.schema_name + "." + tablename +' WHERE "user"=current_user'
        rows = self.dao.get_rows(sql)
        if not rows:
            self.controller.show_warning("Any data found in table "+tablename)
            return None

        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in rows:
            utils_giswater.setWidgetText(str(i[1]), str(i[2]))
            utils_giswater.setChecked("chk_" + str(i[1]), True)
            columns.append(str(i[1]))
        return columns

        
    def test(self, text):
        QMessageBox.about(None, 'Ok', str(text))

        
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
        #self.mg_config_accept_table('config', self.generic_columns)

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

        # Show message, insert in DB and close form
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message' )
        if utils_giswater.isChecked(self.chk_state_vdefault) == True:
            self.insert_or_update_config_vdefault(self.state_vdefault, "state_vdefault")
        else:
            self.delete_row("state_vdefault")
        if utils_giswater.isChecked(self.chk_psector_vdefault) == True:
            self.insert_or_update_config_vdefault(self.psector_vdefault, "psector_vdefault")
        else:
            self.delete_row("psector_vdefault")
        if utils_giswater.isChecked(self.chk_workcat_vdefault) == True:
            self.insert_or_update_config_vdefault(self.workcat_vdefault, "workcat_vdefault")
        else:
            self.delete_row("workcat_vdefault")
        if utils_giswater.isChecked(self.chk_cverified_vdefault) == True:
            self.insert_or_update_config_vdefault(self.verified_vdefault, "verified_vdefault")
        else:
            self.delete_row("verified_vdefault")

        if utils_giswater.isChecked(self.chk_builtdate_vdefault) == True:
            self.insert_or_update_config_vdefault(self.builtdate_vdefault, "builtdate_vdefault")
        else:
            self.delete_row("builtdate_vdefault")

        if utils_giswater.isChecked(self.chk_arccat_vdefault) == True:
            self.insert_or_update_config_vdefault(self.arccat_vdefault, "arccat_vdefault")
        else:
            self.delete_row("arccat_vdefault")
        if utils_giswater.isChecked(self.chk_nodecat_vdefault) == True:
            self.insert_or_update_config_vdefault(self.nodecat_vdefault, "nodecat_vdefault")
        else:
            self.delete_row("nodecat_vdefault")
        if utils_giswater.isChecked(self.chk_connecat_vdefault) == True:
            self.insert_or_update_config_vdefault(self.connecat_vdefault, "connecat_vdefault")
        else:
            self.delete_row("connecat_vdefault")

        self.close_dialog(self.dlg)


    def delete_row(self,  parameter):
        sql='DELETE FROM '+ self.schema_name + '.config_vdefault WHERE "user"=current_user and parameter='+"'"+ parameter+"'"
        self.controller.execute_sql(sql)
       
        
    def insert_or_update_config_vdefault(self, widget, parameter):

        sql='SELECT * FROM '+ self.schema_name + '.config_vdefault WHERE "user"=current_user'
        rows=self.controller.get_rows(sql)
        self.exist = False
        if type(widget) == QDateEdit:
            if widget.date() != "":
                for row in rows:
                    if row[1] == parameter:
                        self.exist = True
                if self.exist:
                    sql = "UPDATE " + self.schema_name + ".config_vdefault SET value='" + widget.date().toString('yyyy-MM-dd') + "'"
                    sql += " WHERE parameter='"+parameter+"'"
                    self.controller.execute_sql(sql)
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.config_vdefault (parameter, value, "user")'
                    sql += " VALUES ('" + parameter + "', '" + widget.date().toString('yyyy-MM-dd') + "', current_user)"
                    self.controller.execute_sql(sql)
        elif widget.currentText() != "":
            for row in rows:
                if row[1] == parameter:
                    self.exist = True
            if self.exist:
                sql = "UPDATE " + self.schema_name + ".config_vdefault SET value='" + widget.currentText() + "'"
                sql += " WHERE parameter='" + parameter + "'"
                self.controller.execute_sql(sql)
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.config_vdefault (parameter, value, "user")'
                sql += " VALUES ('"+parameter+"', '" + widget.currentText() + "', current_user)"
                self.controller.execute_sql(sql)


    def mg_config_accept_table(self, tablename, columns):
        ''' Update values of selected 'tablename' with the content of 'columns' '''

        if columns is not None:
            sql = "UPDATE "+self.schema_name+"."+tablename+" SET "
            for column_name in columns:
                if column_name != 'id':
                    widget_type = utils_giswater.getWidgetType(column_name)
                    if widget_type is QCheckBox:
                        value = utils_giswater.isChecked(column_name)
                    elif widget_type is QDateEdit:
                        date = self.dlg.findChild(QDateEdit, str(column_name))
                        value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
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
        
        if columns is None:
            return
               
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
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table)) 
        
        self.menu = QMenu()
        self.dlg_multi.btn_insert.setMenu(self.menu)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records, self.tbl, table))  
        self.fill_table(self.tbl, self.schema_name+"."+table)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_multi, 'config')
        self.dlg_multi.exec_()


    def mg_exploitation_selector(self):

        self.dlg_multiexp = Multiexpl_selector()
        utils_giswater.setDialog(self.dlg_multiexp)

        self.tbl_all_explot=self.dlg_multiexp.findChild(QTableView, "all_explot")
        self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")

        self.btn_select=self.dlg_multiexp.findChild(QPushButton, "btn_select")
        self.btn_unselect = self.dlg_multiexp.findChild(QPushButton, "btn_unselect")
        self.txt_short_descript = self.dlg_multiexp.findChild(QLineEdit, 'txt_short_descript')

        sql = "SELECT * FROM " + self.schema_name + ".exploitation WHERE short_descript LIKE '"
        self.txt_short_descript.textChanged.connect(partial(self.filter_all_explot, sql, self.txt_short_descript))

        self.btn_select.pressed.connect(self.selection)
        self.btn_unselect.pressed.connect(self.unselection)

        self.dlg_multiexp.btn_cancel.pressed.connect(self.dlg_multiexp.close)
        
        self.fill_table(self.tbl_all_explot, self.schema_name + ".exploitation")
        #self.tbl_all_explot.hideColumn(0)
        self.tbl_all_explot.hideColumn(2)
        self.tbl_all_explot.hideColumn(3)
        self.tbl_all_explot.hideColumn(4)
        self.tbl_all_explot.setColumnWidth(0,98)
        self.tbl_all_explot.setColumnWidth(1,99)

        self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
        self.tbl_selected_explot.hideColumn(1)
        self.tbl_selected_explot.setColumnWidth(0,197)

        self.dlg_multiexp.exec_()


    def filter_all_explot(self,sql, widget):
    
        sql += widget.text()+"%'"
        model = QSqlQueryModel()
        model.setQuery(sql)
        self.tbl_all_explot.setModel(model)
        self.tbl_all_explot.show()


    def selection(self):

        self.tbl_all_explot = self.dlg_multiexp.findChild(QTableView, "all_explot")
        self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")

        selected_list =self.tbl_all_explot.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return

        row_index = ""
        expl_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_all_explot.model().record(row).value("expl_id")

            expl_id += str(id_)+", "
            row_index += str(row+1)+", "

        row_index = row_index[:-2]
        expl_id = expl_id[:-2]


        table_name_select = "exploitation"

        #sql = "DELETE FROM "+self.schema_name+"."+table_name_select
        #sql+= " WHERE expl_id IN ("+expl_id+")"
        #self.controller.execute_sql(sql)
        #self.tbl_all_explot.model().select()

        cur_user = self.controller.get_project_user()
        table_name_unselect = "expl_selector"

        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(expl_id) FROM "+self.schema_name+".expl_selector WHERE expl_id = '"+expl_id[i]+"'"
            row = self.dao.get_row(sql)
            if row:
            # if exist - show warning
                self.controller.show_info_box("Expl_id "+expl_id[i]+" is already selected!", "Info")
                #self.controller.show_warning("Any data found in table "+tablename)
            else:
                sql = "INSERT INTO "+self.schema_name+".expl_selector (expl_id,cur_user) "
                sql+= " VALUES ('"+expl_id[i]+"', '"+cur_user+"')"
                self.controller.execute_sql(sql)

        self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
        #refresh
        self.fill_table(self.tbl_all_explot, self.schema_name + ".exploitation")
        self.iface.mapCanvas().refresh()


    def unselection(self):

        self.tbl_all_explot = self.dlg_multiexp.findChild(QTableView, "all_explot")
        self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")

        selected_list =self.tbl_selected_explot.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return

        row_index = ""
        expl_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_selected_explot.model().record(row).value("expl_id")

            expl_id += str(id_)+", "
            row_index += str(row+1)+", "

        row_index = row_index[:-2]
        expl_id = expl_id[:-2]

        table_name_unselect = "expl_selector"
        sql = "DELETE FROM "+self.schema_name+"."+table_name_unselect
        sql+= " WHERE expl_id IN ("+expl_id+")"
        self.controller.execute_sql(sql)
        self.tbl_all_explot.model().select()

        # Refresh
        self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
        self.iface.mapCanvas().refresh()

        
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

            
    def delete_records_with_params(self, widget, table_name, column_id):
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
            id_ = widget.model().record(row).value(str(column_id))
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)

        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql+= " WHERE "+column_id+" IN ("+list_id+")"
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


    def mg_mincut_edit(self):
        # Button_27 : mincut edit

        # Create the dialog and signals
        self.dlg_min_edit = Mincut_edit()
        utils_giswater.setDialog(self.dlg_min_edit)

        self.combo_state_edit= self.dlg_min_edit.findChild(QComboBox, "state_edit")
        self.tbl_mincut_edit = self.dlg_min_edit.findChild(QTableView, "tbl_mincut_edit")

        self.btn_accept_min= self.dlg_min_edit.findChild(QPushButton, "btn_accept")
        self.btn_accept_min.clicked.connect(self.accept_min)

        self.dlg_min_edit.btn_cancel.pressed.connect(partial(self.close, self.dlg_min_edit))

        # Fill ComboBox state
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_state"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_edit", rows)

        self.fill_table(self.tbl_mincut_edit, self.schema_name + ".anl_mincut_result_cat")
        for i in range(1, 18):
            self.tbl_mincut_edit.hideColumn(i)

        self.combo_state_edit.activated.connect(partial(self.filter_by_state,self.tbl_mincut_edit))

        self.dlg_min_edit.show()


    def filter_by_state(self,widget):

        result_select = utils_giswater.getWidgetText("state_edit")
        expr = " mincut_result_state = '"+result_select+"'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()

        
    def accept_min(self):

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return
        row = selected_list[0].row()
        id = self.tbl_mincut_edit.model().record(row).value("id")

        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_result_cat WHERE id = '"+id+"'"

        rows = self.dao.get_row(sql)

        #self.dlg_min_edit.close()

        # Create the dialog and signals
        self.dlg_mincut = Mincut()
        utils_giswater.setDialog(self.dlg_mincut)

        self.btn_accept_edit = self.dlg_mincut.findChild(QPushButton, "btn_accept")
        self.btn_cancel_edit = self.dlg_mincut.findChild(QPushButton, "btn_cancel")

        self.btn_accept_edit.clicked.connect(self.accept_update)
        self.btn_cancel_edit.clicked.connect(self.dlg_mincut.close)

        self.id = self.dlg_mincut.findChild(QLineEdit, "id")
        self.state = self.dlg_mincut.findChild(QLineEdit, "state")
        self.street = self.dlg_mincut.findChild(QLineEdit, "street")
        self.number = self.dlg_mincut.findChild(QLineEdit, "number")
        self.pred_description = self.dlg_mincut.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg_mincut.findChild(QTextEdit, "real_description")
        self.distance = self.dlg_mincut.findChild(QLineEdit, "distance")
        self.depth = self.dlg_mincut.findChild(QLineEdit, "depth")

        self.exploitation = self.dlg_mincut.findChild(QComboBox, "exploitation")
        self.type = self.dlg_mincut.findChild(QComboBox, "type")
        self.cause = self.dlg_mincut.findChild(QComboBox ,"cause")

        self.cbx_date_end = self.dlg_mincut.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_end = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_end")
        self.cbx_date_start = self.dlg_mincut.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_start = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_end")

        self.id.setText(rows['id'])
        self.state.setText(rows['mincut_result_state'])
        utils_giswater.setWidgetText("pred_description",rows['anl_descript'])
        utils_giswater.setWidgetText("real_description",rows['exec_descript'])
        self.distance.setText(str(rows['exec_limit_distance']))
        self.depth.setText(str(rows['exec_depth']))

        # from address separate street and number
        address_db = rows['address']

        self.street.setText(address_db)
        number_db = rows['address_num']
        self.number.setText(number_db)

        # Set values from mincut to comboBox
        #utils_giswater.fillComboBox("type", rows['mincut_result_type'])
        #utils_giswater.fillComboBox("cause", rows['anl_cause'])
        type = rows['mincut_result_type']
        cause = rows['anl_cause']
        # Clear comboBoxes
        self.type.clear()
        self.cause.clear()

        # Fill comboBoxes
        self.type.addItem(rows['mincut_result_type'])
        self.cause.addItem(rows['anl_cause'])

        # Fill ComboBox type
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_type"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        #utils_giswater.fillComboBox("type", rows)
        for row in rows:
            elem = str(row[0])
            if elem != type:
                self.type.addItem(elem)

        # Fill ComboBox cause
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_cause"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        #utils_giswater.fillComboBox("cause", rows)
        for row in rows:
            elem = str(row[0])
            if elem != cause:
                self.cause.addItem(elem)


        self.old_id= self.id.text()

        self.btn_start = self.dlg_mincut.findChild(QPushButton, "btn_start")
        self.btn_start.clicked.connect(self.real_start)

        self.btn_end = self.dlg_mincut.findChild(QPushButton, "btn_end")
        self.btn_end.clicked.connect(self.real_end)

        self.cbx_date_start = self.dlg_mincut.findChild(QDateEdit, "cbx_date_start")
        self.cbx_hours_start = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_start")

        self.real_description = self.dlg_mincut.findChild(QTextEdit, "real_description")
        self.distance = self.dlg_mincut.findChild(QLineEdit, "distance")
        self.depth = self.dlg_mincut.findChild(QLineEdit, "depth")

        self.btn_end.setEnabled(True)

        self.distance.setEnabled(True)
        self.depth.setEnabled(True)
        self.real_description.setEnabled(True)

        self.cbx_date_end.setEnabled(True)
        self.cbx_hours_end.setEnabled(True)
        self.cbx_date_start.setEnabled(True)
        self.cbx_hours_start.setEnabled(True)

        # Disable to edit ID
        self.id.setEnabled(False)

        # Open the dialog
        self.dlg_mincut.show()
        self.dlg_min_edit.close()


    def real_end(self):

        self.date_end = QDate.currentDate()
        self.cbx_date_end.setDate(self.date_end)

        self.time_end = QTime.currentTime()
        self.cbx_hours_end.setTime(self.time_end)


        # Create the dialog and signals
        self.dlg_fin = Mincut_fin()
        utils_giswater.setDialog(self.dlg_fin)

        self.cbx_date_start_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_start_fin")
        self.cbx_hours_start_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_start_fin")
        #self.cbx_date_start_fin.setDate(self.date_start)
        #self.cbx_hours_start_fin.setTime(self.time_start)

        self.cbx_date_end_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_end_fin")
        self.cbx_hours_end_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_end_fin")
        #self.cbx_date_end_fin.setDate(self.date_end)
        #self.cbx_hours_end_fin.setTime(self.time_end)

        self.btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")

        self.btn_accept.clicked.connect(self.accept)
        self.btn_cancel.clicked.connect(self.dlg_fin.close)

        #self.btn_cancel.clicked.connect()

        # Set values mincut and address
        self.mincut_fin = self.dlg_fin.findChild(QLineEdit, "mincut")
        self.address_fin = self.dlg_fin.findChild(QLineEdit, "address")
        id_fin = self.id.text()
        street_fin = self.street.text()
        number_fin = str(self.number.text())
        address_fin = street_fin +" "+ number_fin
        self.mincut_fin.setText(id_fin)
        self.address_fin.setText(address_fin)

        # set status
        #self.state.setText(str(self.state_values[2][0]) )

        # Open the dialog
        self.dlg_fin.show()

        
    def accept(self):
    
        # reach end_date and end_hour from mincut_fin dialog
        datestart=self.cbx_date_start_fin.date()
        timestart=self.cbx_hours_start_fin.time()
        dateend = self.cbx_date_end_fin.date()
        timeend = self.cbx_hours_end_fin.time()

        # set new values of date in mincut dialog
        self.cbx_date_start.setDate(datestart)
        self.cbx_hours_start.setTime(timestart)
        self.cbx_date_end.setDate(dateend)
        self.cbx_hours_end.setTime(timeend)

        #self.dlg_fin.close()

        
    def real_start(self):

        self.date_start = QDate.currentDate()
        self.cbx_date_start.setDate(self.date_start)

        self.time_start = QTime.currentTime()
        self.cbx_hours_start.setTime(self.time_start)


    def accept_update(self):
    
        mincut_result_state = self.state.text()
        id = self.id.text()
        #exploitation =
        street = str(self.street.text())
        number = str(self.number.text())
        address = str(street + " " + number)
        mincut_result_type = str(utils_giswater.getWidgetText("type"))
        anl_cause = str(utils_giswater.getWidgetText("cause"))
        #forecast_start =
        #forecast_end =
        anl_descript = str(utils_giswater.getWidgetText("pred_description"))

        #exec_start =
        #exec_end =

        exec_limit_distance =  self.distance.text()
        exec_depth = self.depth.text()
        exec_descript = str(utils_giswater.getWidgetText("real_description"))

        # Widgets for predict date
        self.cbx_date_start_predict = self.dlg_mincut.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start_predict = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_start_predict")

        self.cbx_date_end_predict = self.dlg_mincut.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_hours_end_predict = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_end_predict")

        # Widgets for real date
        self.cbx_date_start = self.dlg_mincut.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_start_predict")

        self.cbx_date_end = self.dlg_mincut.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_end = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_end")


        # Get prediction date - start
        dateStart_predict=self.cbx_date_start_predict.date()
        timeStart_predict=self.cbx_hours_start_predict.time()
        forecast_start_predict=dateStart_predict.toString('yyyy-MM-dd') + " " + timeStart_predict.toString('HH:mm:ss')

        # Get prediction date - end
        dateEnd_predict=self.cbx_date_end_predict.date()
        timeEnd_predict=self.cbx_hours_end_predict.time()
        forecast_end_predict=dateEnd_predict.toString('yyyy-MM-dd') + " " + timeEnd_predict.toString('HH:mm:ss')

        # Get real date - start
        dateStart_real = self.cbx_date_start.date()
        timeStart_real = self.cbx_hours_start.time()
        forecast_start_real = dateStart_real.toString('yyyy-MM-dd') + " " + timeStart_real.toString('HH:mm:ss')

        # Get real date - end
        dateEnd_real = self.cbx_date_end.date()
        timeEnd_real=self.cbx_hours_end.time()
        forecast_end_real=dateEnd_real.toString('yyyy-MM-dd') + " " + timeEnd_real.toString('HH:mm:ss')


        sql = "UPDATE "+self.schema_name+".anl_mincut_result_cat "
        sql+= " SET id = '"+id+"',mincut_result_state = '"+mincut_result_state+"',anl_descript = '"+anl_descript+\
              "',exec_descript= '"+exec_descript+"', exec_depth ='"+ exec_depth+"', exec_limit_distance ='"+\
              exec_limit_distance+"', forecast_start='"+forecast_start_predict+"', forecast_end ='"+ forecast_end_predict+"', exec_start ='"+ forecast_start_real+"', exec_end ='"+ forecast_end_real+"' , address ='"+ street +"', address_num ='"+ number +"', mincut_result_type ='"+ mincut_result_type +"', anl_cause ='"+ anl_cause +"' "
        sql+= " WHERE id = '"+id+"'"
        self.controller.execute_sql(sql)

        '''
        self.fill_table(self.tbl_mincut_edit, self.schema_name + ".anl_mincut_result_cat")
        for i in range(1, 18):
            self.tbl_mincut_edit.hideColumn(i)
        '''
        self.dlg_mincut.close()


    def close(self, dlg = None):
        ''' Close dialog '''
        dlg.close()
        
        
    def mg_dimensions(self):
        ''' Button_39: Dimensioning ''' 

        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        
        # Find the layer to edit
        #layer = self.iface.activeLayer()
        layer.startEditing()
        # Implement the Add Feature button
        self.iface.actionAddFeature().trigger()

    
    def mg_new_psector(self,psector_id=None):
        ''' Button_45 : New psector '''
        '''
        layer = self.iface.activeLayer()
        QMessageBox.about(None, 'Ok', str(layer.name()))
        # Get selected features (nodes)
        features = layer.selectedFeatures()
        QMessageBox.about(None, 'Ok', str(features))
        feature = features[0]
        QMessageBox.about(None, 'Ok', str(feature))
        # Get node_id form current node
        self.node_id = feature.attribute('node_id')
        QMessageBox.about(None, 'Ok', str(self.node_id))
        '''
        # Create the dialog and signals
        self.dlg_new_psector = Plan_psector()
        utils_giswater.setDialog(self.dlg_new_psector)
        update=False # if false: insert; if true: update
        # LineEdit
        # tab General elements
        self.psector_id = self.dlg_new_psector.findChild(QLineEdit, "psector_id")
        self.short_descript = self.dlg_new_psector.findChild(QLineEdit, "short_descript")
        self.priority = self.dlg_new_psector.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)

        self.descript = self.dlg_new_psector.findChild(QLineEdit, "descript")
        self.text1 = self.dlg_new_psector.findChild(QLineEdit, "text1")
        self.text2 = self.dlg_new_psector.findChild(QLineEdit, "text2")
        self.observ = self.dlg_new_psector.findChild(QLineEdit, "observ")
        self.scale = self.dlg_new_psector.findChild(QLineEdit, "scale")
        self.atlas_id = self.dlg_new_psector.findChild(QLineEdit, "atlas_id")
        self.rotation = self.dlg_new_psector.findChild(QLineEdit, "rotation")

        # tab Bugdet
        self.sum_v_plan_other_x_psector = self.dlg_new_psector.findChild(QLineEdit, "sum_v_plan_other_x_psector")
        self.sum_v_plan_x_arc_psector = self.dlg_new_psector.findChild(QLineEdit, "sum_v_plan_x_arc_psector")
        self.sum_v_plan_x_node_psector = self.dlg_new_psector.findChild(QLineEdit, "sum_v_plan_x_node_psector")

        self.sum_expenses = self.dlg_new_psector.findChild(QLineEdit, "sum_expenses")
        self.other = self.dlg_new_psector.findChild(QLineEdit, "other")
        self.other_cost = self.dlg_new_psector.findChild(QLineEdit, "other_cost")

        self.sum_oexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_oexpenses")
        self.gexpenses = self.dlg_new_psector.findChild(QLineEdit, "gexpenses")
        self.gexpenses_cost = self.dlg_new_psector.findChild(QLineEdit, "gexpenses_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, self.sum_oexpenses, self.gexpenses, self.gexpenses_cost))

        self.sum_gexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_gexpenses")
        self.vat = self.dlg_new_psector.findChild(QLineEdit, "vat")
        self.vat_cost = self.dlg_new_psector.findChild(QLineEdit, "vat_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, self.sum_gexpenses, self.vat, self.vat_cost))

        self.sum_vexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_vexpenses")


        self.dlg_new_psector.other.textChanged.connect(partial(self.cal_percent, self.sum_expenses, self.other, self.other_cost))
        self.dlg_new_psector.other_cost.textChanged.connect(partial(self.sum_total, self.sum_expenses, self.other_cost,self.sum_oexpenses ))

        self.dlg_new_psector.gexpenses.textChanged.connect(partial(self.cal_percent, self.sum_oexpenses, self.gexpenses, self.gexpenses_cost))
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.sum_total, self.sum_oexpenses, self.gexpenses_cost, self.sum_gexpenses))

        self.dlg_new_psector.vat.textChanged.connect(partial(self.cal_percent, self.sum_gexpenses, self.vat, self.vat_cost))
        self.dlg_new_psector.vat_cost.textChanged.connect(partial(self.sum_total, self.sum_gexpenses, self.vat_cost, self.sum_vexpenses))

        # Tables
        # tab Elements
        self.tbl_arc_plan = self.dlg_new_psector.findChild(QTableView, "tbl_arc_plan")
        self.tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")

        self.tbl_node_plan = self.dlg_new_psector.findChild(QTableView, "tbl_node_plan")
        self.tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_node_plan, self.schema_name + ".plan_node_x_psector")

        self.tbl_other_plan = self.dlg_new_psector.findChild(QTableView, "tbl_other_plan")
        self.tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_other_plan, self.schema_name + ".plan_other_x_psector")

        # tab Bugdet
        self.tbl_v_plan_other_x_psector = self.dlg_new_psector.findChild(QTableView, "tbl_v_plan_other_x_psector")
        self.fill_table(self.tbl_v_plan_other_x_psector, self.schema_name + ".v_plan_other_x_psector")
        self.tbl_v_plan_other_x_psector.hideColumn(0)

        # tab Elements
        self.dlg_new_psector.btn_add_arc_plan.pressed.connect(self.pressbtn)
        self.dlg_new_psector.btn_del_arc_plan.pressed.connect(self.pressbtn)
        self.dlg_new_psector.btn_add_node_plan.pressed.connect(self.pressbtn)
        self.dlg_new_psector.btn_del_node_plan.pressed.connect(self.pressbtn)
        self.dlg_new_psector.btn_add_other_plan.pressed.connect(self.pressbtn)
        self.dlg_new_psector.btn_del_other_plan.pressed.connect(self.pressbtn)
        # if a row is selected from mg_psector_mangement(button 46)
        if not isinstance(psector_id, bool):
            sql = "SELECT * FROM " + self.schema_name + ".plan_psector  WHERE psector_id = "+ str(psector_id)
            row = self.dao.get_row(sql)
            self.psector_id.setText(str(row[0]))
            self.short_descript.setText(row[15])
            index = self.priority.findText(row[2], Qt.MatchFixedString)
            if index >= 0:
                self.priority.setCurrentIndex(index)
            self.descript.setText(row[1])
            self.text1.setText(row[3])
            self.text2.setText(row[4])
            self.observ.setText(row[5])
            self.atlas_id.setText(row[9])
            self.test(row[7])
            if row[7]!=None:
                self.scale.setText(str(row[7]))
            if row[6] != None:
                self.rotation.setText(str(row[6]))

            expr = " psector_id = "+ str(psector_id)
            # Refresh model with selected filter
            self.tbl_arc_plan.model().setFilter(expr)
            self.tbl_arc_plan.model().select()
            expr = " psector_id = " + str(psector_id)
            # Refresh model with selected filter
            self.tbl_node_plan.model().setFilter(expr)
            self.tbl_node_plan.model().select()

            expr = " psector_id = " + str(psector_id)
            self.tbl_v_plan_other_x_psector.model().setFilter(expr)
            self.tbl_v_plan_other_x_psector.model().select()

            # Total other Prices:
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_other_x_psector  WHERE psector_id = "+ str(psector_id)
            row = self.dao.get_row(sql)

            if not row[0]:
                total_other_price=0
            else:
                total_other_price=row[0]
            self.sum_v_plan_other_x_psector.setText(str(total_other_price))
            #Total arcs:
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_arc_x_psector  WHERE psector_id = "+ str(psector_id)
            row = self.dao.get_row(sql)
            if not row[0]:
                total_arcs=0
            else:
                total_arcs=row[0]
            self.sum_v_plan_x_arc_psector.setText(str(total_arcs))
            # Total nnodes:
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_node_x_psector  WHERE psector_id = "+ str(psector_id)
            row = self.dao.get_row(sql)
            if not row[0]:
                total_nodes=0
            else:
                total_nodes = row[0]
            self.sum_v_plan_x_node_psector.setText(str(total_nodes))

            sum_expenses=total_other_price+total_arcs+total_nodes
            self.sum_expenses.setText(str(sum_expenses))
            update=True
        # Buttons
        self.dlg_new_psector.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector,update,'plan_psector') )
        self.dlg_new_psector.btn_cancel.pressed.connect(self.dlg_new_psector.close)
        self.dlg_new_psector.exec_()


    def insert_or_update_new_psector(self, update,table):
        
        self.test(update)
        if update:
            sql = "UPDATE " + self.schema_name + "."+table+" SET descript='" + self.descript.text()+"'"
            sql += ", priority='"+self.priority.currentText()+"'"
            sql += ", text1='" + self.text1.text() + "'"
            sql += ", text2='" + self.text2.text() + "'"
            sql += ", observ='" + self.observ.text() + "'"
            sql += ", scale='" + self.scale.text() + "'"
            sql += ", atlas_id='" + self.atlas_id.text() + "'"
            sql += ", rotation='" + self.rotation.text() + "'"
            sql += ", short_descript='" + self.short_descript.text() + "'"

            sql += " WHERE psector_id = '"+self.psector_id.text() +"'"
        else:
            '''
            fields=""
            values=""
            self.test(self.descript.text())
            if self.short_descript.text()!="":
                fields="short_descript"
                values="'"+self.short_descript.text()+"'" or None
            if self.descript.text()!="":
                fields+=", descript"
                values+=", '"+self.descript.text()+"'" or None
            if self.priority.currentText()!="":
                fields += ", priority"
                values += ", '"+self.priority.currentText()+"'" or None



            sql = "INSERT INTO " + self.schema_name + "."+table+"("+fields+")"
            sql += " VALUES (" +values+")"
            '''
            #, text1, text2, observ, scale, atlas_id, rotation, short_descript
            sql = "INSERT INTO " + self.schema_name + "." + table + "(descript, priority, text1)"
            sql += " VALUES (" + str(self.descript.text()) +","+str(self.priority.currentText())+","+str(self.text1.text())+ ")"
            self.test(sql)
        self.controller.execute_sql(sql)


    def cal_percent(self,widged_total, widged_percent, wided_result):
        wided_result.setText(str((float(widged_total.text())*float(widged_percent.text())/100)))


    def sum_total(self, widget_total, widged_percent, wided_result):
        wided_result.setText(str((float(widget_total.text()) + float(widged_percent.text()))))
    '''
    def insert_mg_newp(self):

        if self.psector_id.text()=='':
            self.test("Field psector_id needed")
        else:
            sql = "INSERT INTO " + self.schema_name + ".plan_psector (psector_id, descript, priority, text1, text2, observ)"
            sql += " VALUES ('" + self.psector_id.text()+ "', '" + self.descript.text()+ "', '" + self.priority.text()+ "', '" + self.text1.text() + "', '" + self.text2.text() +"', '" + self.observ.text()+  "')"
            self.controller.execute_sql(sql)
            self.test("saved")
    '''

    def mg_psector_mangement(self):
        ''' Button_46 : Psector management '''
        
        'psm es abreviacion de psector_management'
        # Create the dialog and signals
        self.dlg_psector_mangement = Psector_management()
        utils_giswater.setDialog(self.dlg_psector_mangement)
        table_document="plan_psector"
        column_id="psector_id"
        # Tables
        self.tbl_psm=self.dlg_psector_mangement.findChild(QTableView, "tbl_psm")
        self.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows) #Select by rows instead of individual cells
        # Buttons
        self.dlg_psector_mangement.btn_accept.pressed.connect(self.charge_psector)
        self.dlg_psector_mangement.btn_cancel.pressed.connect(self.dlg_psector_mangement.close)
        self.dlg_psector_mangement.btn_delete.clicked.connect(partial(self.delete_records_with_params, self.tbl_psm, table_document,column_id))
        # LineEdit
        self.dlg_psector_mangement.txt_short_descript_psm.textChanged.connect(partial(self.filter_by_text, self.tbl_psm, self.dlg_psector_mangement.txt_short_descript_psm))
        #self.txt_short_descript_psm.

        self.fill_table(self.tbl_psm, self.schema_name + ".plan_psector")
        self.dlg_psector_mangement.exec_()


    def charge_psector(self):
        selected_list = self.tbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return
        row = selected_list[0].row()
        psector_id = self.tbl_psm.model().record(row).value("psector_id")
        self.dlg_psector_mangement.close()
        self.mg_new_psector(psector_id)


    def filter_by_text(self,table,txt):
        result_select = utils_giswater.getWidgetText(txt)
        if result_select=='null':
            result_select=""

        expr = " psector_id LIKE '%"+result_select+"%'"
        # Refresh model with selected filter
        table.model().setFilter(expr)
        table.model().select()


    def mg_psector_selector(self):
        ''' Button_47 : Psector selector '''

        # Create the dialog and signals
        self.dlg_psector_sel = Multipsector_selector()
        utils_giswater.setDialog(self.dlg_psector_sel)
        # Buttons
        self.dlg_psector_sel.btn_accept.pressed.connect(self.pressbtn)
        self.dlg_psector_sel.btn_cancel.pressed.connect(self.dlg_psector_sel.close)
        self.dlg_psector_sel.btn_select_state.pressed.connect(self.pressbtn)
        self.dlg_psector_sel.btn_unselect_state.pressed.connect(self.pressbtn)
        self.dlg_psector_sel.btn_select_psector.pressed.connect(self.pressbtn)
        self.dlg_psector_sel.btn_unselect_psector.pressed.connect(self.pressbtn)

        # Tables
        self.tbl_all_state = self.dlg_psector_sel.findChild(QTableView, "all_state")
        self.tbl_selected_state = self.dlg_psector_sel.findChild(QTableView, "selected_state")
        self.tbl_all_psector = self.dlg_psector_sel.findChild(QTableView, "all_psector")
        self.tbl_selected_psector = self.dlg_psector_sel.findChild(QTableView, "selected_psector")

        # LineEdit
        self.pss_txt_short_descript = self.dlg_psector_sel.findChild(QLineEdit, "txt_short_descript")

        self.dlg_psector_sel.exec_()
        
        
    def pressbtn(self):
        QMessageBox.about(None, 'Ok', str('btn pressed'))
  
    
