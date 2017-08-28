'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt, QSettings, QPoint
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest

from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox, QLineEdit, QTableView, QMenu, QPushButton, QComboBox
from PyQt4.QtGui import QSpinBox, QTextEdit, QDateEdit, QTimeEdit, QAbstractItemView, QTabWidget, QDoubleValidator
from PyQt4.Qt import QDate, QTime

from datetime import datetime
import os
import sys
import webbrowser
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.change_node_type import ChangeNodeType                # @UnresolvedImport
from ..ui.config_master import ConfigMaster                     # @UnresolvedImport
from ..ui.config_edit import ConfigEdit                         # @UnresolvedImport
from ..ui.result_compare_selector import ResultCompareSelector  # @UnresolvedImport
from ..ui.table_wizard import TableWizard                       # @UnresolvedImport
from ..ui.topology_tools import TopologyTools                   # @UnresolvedImport
from ..ui.multi_selector import Multi_selector                  # @UnresolvedImport
from ..ui.file_manager import FileManager                       # @UnresolvedImport
from ..ui.multiexpl_selector import Multiexpl_selector          # @UnresolvedImport
from ..ui.mincut_edit import Mincut_edit                        # @UnresolvedImport
from ..ui.mincut_fin import Mincut_fin                          # @UnresolvedImport
from ..ui.mincut import Mincut                                  # @UnresolvedImport
from ..ui.plan_psector import Plan_psector                      # @UnresolvedImport
from ..ui.psector_management import Psector_management          # @UnresolvedImport
from ..ui.state_selector import State_selector                  # @UnresolvedImport
from ..ui.multirow_selector import Multirow_selector            # @UnresolvedImport

from parent import ParentAction                                 # @UnresolvedImport


class Mg(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
                  
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
    
                  
    def close_dialog(self, dlg=None): 
        """ Close dialog """

        dlg.close()
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError:
            pass


    def mg_arc_topo_repair(self):
        """ Button 19. Topology repair """

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
        """ Button 19. Executes functions that are selected """

        # Review/Utils
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

        # Builder
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
        """ Button 21. WS/UD table wizard
        Create dialog to select CSV file and table to import contents to """

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
        """ Get available tables from configuration table 'config_csv_import' """

        self.table_dict = {}
        self.dlg.cbo_table.addItem('', '')
        sql = "SELECT gis_client_layer_name, table_name"
        sql += " FROM "+self.schema_name+".config_csv_import"
        sql += " ORDER BY gis_client_layer_name"
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
        if header_status == Qt.Checked:
            sql += " HEADER"
        sql += " DELIMITER AS '"+delimiter+"'"
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
        """ Button 23. Open form to set INP, RPT and project """

        # Initialize variables
        self.file_inp = None
        self.file_rpt = None
        self.project_name = None

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 23)

        # Get giswater properties file
        users_home = os.path.expanduser("~")
        filename = "giswater_"+self.giswater_version+".properties"
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
        """ Save INP, RPT and result name into GSW file """

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
        """ Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        """
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
            self.controller.show_info(message, context_name='ui_message')
            return
        elif count > 1:
            message = "More than one feature selected. Only the first one will be processed!"
            self.controller.show_info(message, context_name='ui_message')


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
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """

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
        """ Update current type of node and save changes in database """

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


    def mg_config_master(self):
        """ Button 99 - Open a dialog showing data from table 'config_param_system' """     
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)
        self.controller.check_action(True, 99)
        
        # Create the dialog and signals
        self.dlg_config_master = ConfigMaster()
        utils_giswater.setDialog(self.dlg_config_master)
        self.dlg_config_master.btn_accept.pressed.connect(self.mg_config_master_accept)
        self.dlg_config_master.btn_cancel.pressed.connect(self.dlg_config_master.close)

        self.om_visit_absolute_path = self.dlg_config_master.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_absolute_path = self.dlg_config_master.findChild(QLineEdit, "doc_absolute_path")
        self.om_visit_path = self.dlg_config_master.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_path = self.dlg_config_master.findChild(QLineEdit, "doc_absolute_path")

        self.dlg_config_master.findChild(QPushButton, "om_path_url").clicked.connect(partial(self.open_web_browser, self.om_visit_path))
        self.dlg_config_master.findChild(QPushButton, "om_path_doc").clicked.connect(partial(self.open_file_dialog, self.om_visit_path))
        self.dlg_config_master.findChild(QPushButton, "doc_path_url").clicked.connect(partial(self.open_web_browser, self.doc_path))
        self.dlg_config_master.findChild(QPushButton, "doc_path_doc").clicked.connect(partial(self.open_file_dialog, self.doc_path))

        # Get om_visit_absolute_path and doc_absolute_path from config_param_text
        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'om_visit_absolute_path'"
        row = self.dao.get_row(sql)
        if row:
            path = str(row['value'])
            self.om_visit_absolute_path.setText(path)

        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'doc_absolute_path'"
        row = self.dao.get_row(sql)
        if row:
            path = str(row['value'])
            self.doc_absolute_path.setText(path)

        # QCheckBox
        self.chk_psector_enabled = self.dlg_config_master.findChild(QCheckBox, 'chk_psector_enabled')
        self.slope_arc_direction = self.dlg_config_master.findChild(QCheckBox, 'slope_arc_direction')

        if self.project_type == 'ws':
            self.slope_arc_direction.setEnabled(False)

        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'psector_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            self.controller.show_info(str(row))
            utils_giswater.setChecked(self.chk_psector_enabled, True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        self.mg_options_get_data("config")
        self.mg_options_get_data("config_param_system")

        self.dlg_config_master.exec_()


    def mg_options_get_data(self, tablename):
        """ Get data from selected table and fill widgets according to the name of the columns """
        
        sql = 'SELECT * FROM ' + self.schema_name + "." + tablename
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
            elif widget_type is QDateEdit:
                utils_giswater.setCalendarDate(column_name, datetime.strptime(row[column_name], '%Y-%m-%d'))
            elif widget_type is QTimeEdit:
                timeparts = str(row[column_name]).split(':')
                if len(timeparts) < 3:
                    timeparts.append("0")
                days = int(timeparts[0]) / 24
                hours = int(timeparts[0]) % 24
                minuts = int(timeparts[1])
                seconds = int(timeparts[2])
                time = QTime(hours, minuts, seconds)
                utils_giswater.setTimeEdit(column_name, time)
                utils_giswater.setText(column_name + "_day", days)
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
            columns.append(column_name)
            
        return columns


    def mg_config_master_accept(self):

        if utils_giswater.isChecked(self.chk_psector_enabled):
            self.insert_or_update_config_param_curuser(self.dlg_config_master.psector_vdefault, "psector_vdefault", "config_param_user")
        else:
            self.delete_row("psector_vdefault", "config_param_user")
        self.update_conf_param_master(True, "config", self.dlg_config_master)

        self.insert_or_update_config_param(self.dlg_config_master.om_visit_absolute_path, "om_visit_absolute_path", "config_param_system")
        self.insert_or_update_config_param(self.dlg_config_master.doc_absolute_path, "doc_absolute_path", "config_param_system")
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.dlg_config_master.close()


    def update_conf_param_master(self, update, tablename, dialog):
        """ INSERT or UPDATE tables according :param update """
        
        sql = "SELECT *"
        sql += " FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)
            
        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = dialog.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd')
                        elif widget_type is QTimeEdit:
                            aux = 0
                            widget_day = str(column_name) + "_day"
                            day = utils_giswater.getText(widget_day)
                            if day != "null":
                                aux = int(day) * 24
                            time = dialog.findChild(QTimeEdit, str(column_name))
                            timeparts = time.dateTime().toString('HH:mm:ss').split(':')
                            h = int(timeparts[0]) + int(aux)
                            aux = str(h) + ":" + str(timeparts[1]) + ":00"
                            value = aux
                        elif widget_type is QSpinBox:
                            x = dialog.findChild(QSpinBox, str(column_name))
                            value = x.value()
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value == 'null':
                            sql += column_name + " = null, "
                        elif value is None:
                            pass
                        else:
                            if type(value) is not bool and widget_type is not QSpinBox:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "
                sql = sql[:len(sql) - 2]
                
        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                for column_name in columns:
                    if column_name != 'id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name) + ", "
                            elif widget_type is QDateEdit:
                                date = dialog.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd') + ", "
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values
                
        self.controller.execute_sql(sql)


    def insert_or_update_config_param_curuser(self, widget, parameter, tablename):
        """ Insert or update values in tables with current_user control """
        
        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename + ' WHERE "cur_user" = current_user'
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if widget.currentText() != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    # self.controller.show_info(str(widget.objectName()))
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'"+widget.currentText() + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + widget.currentText() + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('"+parameter+"', '" + widget.currentText() + "', current_user)"
                    else:
                        sql += " VALUES ('"+parameter+"', (SELECT id FROM "+self.schema_name + ".value_state WHERE name ='" + widget.currentText()+"'), current_user)"
        else:
            for row in rows:
                if row[1] == parameter:
                    exist_param = True
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter='" + parameter + "'"
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"
                
        self.controller.execute_sql(sql)


    def insert_or_update_config_param(self, widget, parameter, tablename):
        """ Insert or update values in tables with out current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename
        rows = self.controller.get_rows(sql)
        exist_param = False
        for row in rows:
            if row[1] == parameter:
                exist_param = True
        if exist_param:
            sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
            sql += "'" + widget.text() + "' WHERE parameter='" + parameter + "'"
        else:
            sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value)'
            sql += " VALUES ('" + parameter + "', "+ widget.text() + "'))"
        self.controller.execute_sql(sql)


    def mg_config_edit(self):
        """ Button 98 - Open a dialog showing data from table 'config_param_user' """     

        # Create the dialog and signals
        self.dlg_config_edit = ConfigEdit()
        utils_giswater.setDialog(self.dlg_config_edit)
        self.dlg_config_edit.btn_accept.pressed.connect(self.mg_config_edit_accept)
        self.dlg_config_edit.btn_cancel.pressed.connect(self.dlg_config_edit.close)
        
        # Set values from widgets of type QComboBox and dates
        # QComboBox Utils
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name+".value_state ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".cat_work ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".value_verified ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows)
        
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql+= ' WHERE "cur_user" = current_user AND parameter = ' + "'builtdate_vdefault'"
        row = self.dao.get_row(sql)
        if row is not None:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
        else:
            date_value = QDate.currentDate()
        utils_giswater.setCalendarDate("builtdate_vdefault", date_value)

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".cat_arc ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arccat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".cat_node ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".cat_connec ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows)

        # QComboBox Ud
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".node_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".arc_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name+".connec_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        rows = self.dao.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_"+str(row[0]), True)

        sql = "SELECT name FROM "+self.schema_name + ".value_state WHERE id::text = "
        sql += "(SELECT value FROM "+self.schema_name + ".config_param_user WHERE parameter = 'state_vdefault')::text"
        rows = self.dao.get_rows(sql)
        if rows:
            utils_giswater.setWidgetText("state_vdefault", str(rows[0][0]))

        if self.project_type == 'ws':
            self.dlg_config_edit.chk_nodetype_vdefault.setEnabled(False)
            self.dlg_config_edit.chk_arctype_vdefault.setEnabled(False)
            self.dlg_config_edit.chk_connectype_vdefault.setEnabled(False)
            self.dlg_config_edit.nodetype_vdefault.setEnabled(False)
            self.dlg_config_edit.arctype_vdefault.setEnabled(False)
            self.dlg_config_edit.connectype_vdefault.setEnabled(False)

        self.dlg_config_edit.exec_()


    def mg_config_edit_accept(self):
        
        if utils_giswater.isChecked("chk_state_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.state_vdefault, "state_vdefault", "config_param_user")
        else:
            self.delete_row("state_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_workcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.workcat_vdefault, "workcat_vdefault", "config_param_user")
        else:
            self.delete_row("workcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_verified_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.verified_vdefault, "verified_vdefault", "config_param_user")
        else:
            self.delete_row("verified_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_builtdate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.builtdate_vdefault, "builtdate_vdefault", "config_param_user")
        else:
            self.delete_row("builtdate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arccat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.arccat_vdefault, "arccat_vdefault", "config_param_user")
        else:
            self.delete_row("arccat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_nodecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.nodecat_vdefault, "nodecat_vdefault", "config_param_user")
        else:
            self.delete_row("nodecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.connecat_vdefault, "connecat_vdefault", "config_param_user")
        else:
            self.delete_row("connecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_nodetype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.nodetype_vdefault, "nodetype_vdefault", "config_param_user")
        else:
            self.delete_row("nodetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arctype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.arctype_vdefault, "arctype_vdefault", "config_param_user")
        else:
            self.delete_row("arctype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connectype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_edit.connectype_vdefault, "connectype_vdefault", "config_param_user")
        else:
            self.delete_row("connectype_vdefault", "config_param_user")
            
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.dlg_config_edit.close()


    def open_file_dialog(self, widget):
        """ Open File Dialog """

        # Set default value from QLine
        self.file_path = utils_giswater.getWidgetText(widget)

        # Check if file exists
        if not os.path.exists(self.file_path):
            message = "File path doesn't exist"
            self.controller.show_warning(message, 10, context_name='ui_message')
            self.file_path = self.plugin_dir
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
        """ Display url using the default browser """

        url = utils_giswater.getWidgetText(widget)
        if url == 'null':
            url = 'www.giswater.org'
            webbrowser.open(url)
        else :
            webbrowser.open(url)

                 
    def delete_row(self,  parameter, tablename):
        sql = 'DELETE FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user and parameter = '+ "'" + parameter + "'"
        self.controller.execute_sql(sql)

 
    def multi_selector(self, table):  
        """ Execute form multi_selector """
        
        # Create the dialog and signals
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)

        self.tbl = self.dlg_multi.findChild(QTableView, "tbl")
        self.dlg_multi.btn_cancel.pressed.connect(self.close_dialog_multi)
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table))
        self.menu = QMenu()
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

        selected_list = self.tbl_all_explot.selectionModel().selectedRows()
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

        #sql = "DELETE FROM "+self.schema_name+".exploitation"
        #sql+= " WHERE expl_id IN ("+expl_id+")"
        #self.controller.execute_sql(sql)
        #self.tbl_all_explot.model().select()
        cur_user = self.controller.get_project_user()

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
        """ Insert menu on QPushButton->QMenu"""

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
            if row is None:
                self.menu.addAction(elem, partial(self.insert, elem,table))


    def insert(self, id_action, table):
        """ On action(select value from menu) execute SQL """

        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)
        self.fill_table(self.tbl, self.schema_name+"."+table)


    def delete_records(self, widget, table_name):
        """ Delete selected elements of the table """

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


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

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
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg_multi
        try:
            dlg.close()
        except AttributeError:
            pass


    def fill_table(self, widget, table_name):
        """ Set a model with selected filter.
        Attach that model to selected table """

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
        id_ = self.tbl_mincut_edit.model().record(row).value("id")
        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_result_cat"
        sql+= " WHERE id = '"+id_+"'"
        rows = self.dao.get_row(sql)

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
        mincut_result_type = rows['mincut_result_type']
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
            if elem != mincut_result_type:
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

        self.old_id = self.id.text()
        
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

        self.cbx_date_end_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_end_fin")
        self.cbx_hours_end_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_end_fin")

        self.btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")

        self.btn_accept.clicked.connect(self.accept)
        self.btn_cancel.clicked.connect(self.dlg_fin.close)

        # Set values mincut and address
        self.mincut_fin = self.dlg_fin.findChild(QLineEdit, "mincut")
        self.address_fin = self.dlg_fin.findChild(QLineEdit, "address")
        id_fin = self.id.text()
        street_fin = self.street.text()
        number_fin = str(self.number.text())
        address_fin = street_fin + " " + number_fin
        self.mincut_fin.setText(id_fin)
        self.address_fin.setText(address_fin)

        # Open the dialog
        self.dlg_fin.show()


    def accept(self):

        # reach end_date and end_hour from mincut_fin dialog
        datestart = self.cbx_date_start_fin.date()
        timestart = self.cbx_hours_start_fin.time()
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
        id_ = self.id.text()
        street = str(self.street.text())
        number = str(self.number.text())
        mincut_result_type = str(utils_giswater.getWidgetText("type"))
        anl_cause = str(utils_giswater.getWidgetText("cause"))
        anl_descript = str(utils_giswater.getWidgetText("pred_description"))

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
        sql+= " SET id = '"+id_+"', mincut_result_state = '"+mincut_result_state+"', anl_descript = '"+anl_descript+\
              "', exec_descript= '"+exec_descript+"', exec_depth = '"+ exec_depth+"', exec_limit_distance = '"+\
              exec_limit_distance+"', forecast_start= '"+forecast_start_predict+"', forecast_end = '"+ forecast_end_predict+"', exec_start ='"+ forecast_start_real+"', exec_end ='"+ forecast_end_real+"' , address ='"+ street +"', address_num ='"+ number +"', mincut_result_type ='"+ mincut_result_type +"', anl_cause ='"+ anl_cause +"' "
        sql+= " WHERE id = '"+id_+"'"
        self.controller.execute_sql(sql)

        '''
        self.fill_table(self.tbl_mincut_edit, self.schema_name + ".anl_mincut_result_cat")
        for i in range(1, 18):
            self.tbl_mincut_edit.hideColumn(i)
        '''
        self.dlg_mincut.close()


    def close(self, dlg = None):
        """ Close dialog """
        dlg.close()


    def mg_dimensions(self):
        """ Button_39: Dimensioning """

        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        layer.startEditing()
        # Implement the Add Feature button
        self.iface.actionAddFeature().trigger()


    def mg_new_psector(self, psector_id=None, enable_tabs=False):
        """ Button_45 : New psector """
        
        # Create the dialog and signals
        self.dlg_new_psector = Plan_psector()
        utils_giswater.setDialog(self.dlg_new_psector)
        self.list_elemets = {}
        update = False  # if false: insert; if true: update
        self.tab_arc_node_other = self.dlg_new_psector.findChild(QTabWidget,"tabWidget_2")
        self.tab_arc_node_other.setTabEnabled(0, enable_tabs)
        self.tab_arc_node_other.setTabEnabled(1, enable_tabs)
        self.tab_arc_node_other.setTabEnabled(2, enable_tabs)

        # tab General elements
        self.psector_id = self.dlg_new_psector.findChild(QLineEdit, "psector_id")
        self.priority = self.dlg_new_psector.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)

        scale = self.dlg_new_psector.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg_new_psector.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())

        # tab Bugdet
        sum_expenses = self.dlg_new_psector.findChild(QLineEdit, "sum_expenses")
        other = self.dlg_new_psector.findChild(QLineEdit, "other")
        other.setValidator(QDoubleValidator())
        other_cost = self.dlg_new_psector.findChild(QLineEdit, "other_cost")

        sum_oexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_oexpenses")
        gexpenses = self.dlg_new_psector.findChild(QLineEdit, "gexpenses")
        gexpenses.setValidator(QDoubleValidator())
        gexpenses_cost = self.dlg_new_psector.findChild(QLineEdit, "gexpenses_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))

        sum_gexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_gexpenses")
        vat = self.dlg_new_psector.findChild(QLineEdit, "vat")
        vat.setValidator(QDoubleValidator())
        vat_cost = self.dlg_new_psector.findChild(QLineEdit, "vat_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))

        sum_vexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_vexpenses")

        self.dlg_new_psector.other.textChanged.connect(partial(self.cal_percent, sum_expenses, other, other_cost))
        self.dlg_new_psector.other_cost.textChanged.connect(partial(self.sum_total, sum_expenses, other_cost, sum_oexpenses))
        self.dlg_new_psector.gexpenses.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.sum_total, sum_oexpenses, gexpenses_cost, sum_gexpenses))
        self.dlg_new_psector.vat.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
        self.dlg_new_psector.vat_cost.textChanged.connect(partial(self.sum_total, sum_gexpenses, vat_cost, sum_vexpenses))

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

        # tab Elements
        self.dlg_new_psector.btn_add_arc_plan.pressed.connect(partial(self.snapping, "v_edit_arc", "plan_arc_x_psector", self.tbl_arc_plan, "arc"))
        self.dlg_new_psector.btn_del_arc_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_arc_plan, "plan_arc_x_psector", "id"))

        self.dlg_new_psector.btn_add_node_plan.pressed.connect(partial(self.snapping, "v_edit_node", "plan_node_x_psector", self.tbl_node_plan, "node" ))
        self.dlg_new_psector.btn_del_node_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_node_plan, "plan_node_x_psector", "id"))

        self.dlg_new_psector.btn_del_other_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_other_plan, "plan_other_x_psector", "id"))

        ##
        # if a row is selected from mg_psector_mangement(button 46)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        ##
        if isinstance(psector_id, bool):
            psector_id = 0
            
        if psector_id != 0:

            sql = "SELECT psector_id, name, priority, descript, text1, text2, observ, atlas_id, scale, rotation "
            sql += " FROM " + self.schema_name + ".plan_psector"
            sql += " WHERE psector_id = " + str(psector_id)
            row = self.dao.get_row(sql)
            if row is None:
                return
            
            self.psector_id.setText(str(row["psector_id"]))
            utils_giswater.setRow(row)
            utils_giswater.fillWidget("name")            
            utils_giswater.fillWidget("descript")
            index = self.priority.findText(row["priority"], Qt.MatchFixedString)
            if index >= 0:
                self.priority.setCurrentIndex(index)
            utils_giswater.fillWidget("text1")
            utils_giswater.fillWidget("text2") 
            utils_giswater.fillWidget("observ") 
            utils_giswater.fillWidget("atlas_id") 
            utils_giswater.fillWidget("scale") 
            utils_giswater.fillWidget("rotation")                         

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan_other_x_psector with selected filter
            expr = " psector_id = "+ str(psector_id)
            self.tbl_arc_plan.model().setFilter(expr)
            self.tbl_arc_plan.model().select()

            expr = " psector_id = " + str(psector_id)
            self.tbl_node_plan.model().setFilter(expr)
            self.tbl_node_plan.model().select()

            # Total other Prices
            total_other_price = 0            
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_other_x_psector"
            sql+= " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:       
                if row[0]:
                    total_other_price = row[0]
            utils_giswater.setText("sum_v_plan_other_x_psector", total_other_price)
            
            # Total arcs
            total_arcs = 0
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_arc_x_psector"
            sql+= " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:              
                if row[0]:
                    total_arcs = row[0]
            utils_giswater.setText("sum_v_plan_x_arc_psector", total_arcs)            

            # Total nodes
            total_nodes = 0
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_node_x_psector"
            sql+= " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:              
                if row[0]:
                    total_nodes = row[0]
            utils_giswater.setText("sum_v_plan_x_node_psector", total_nodes)            
            
            sum_expenses = total_other_price + total_arcs + total_nodes
            utils_giswater.setText("sum_expenses", sum_expenses)
            update = True

        # Buttons
        self.dlg_new_psector.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector'))
        self.dlg_new_psector.btn_cancel.pressed.connect(self.dlg_new_psector.close)
        self.dlg_new_psector.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_new_psector.open()


    def insert_or_update_new_psector(self, update, tablename):
        
        sql = "SELECT *"
        sql += " FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                sql += " WHERE psector_id = '" + self.psector_id.text() + "'"
                
        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename+" ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name)+", "
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss')+", "
                            else:
                                value =utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2]+") "
                values = values[:len(values)-2] + ")"
                sql += values
        self.controller.execute_sql(sql)
        self.dlg_new_psector.close()


    def snapping(self, layer_view, tablename, table_view, elem_type):
        
        map_canvas = self.iface.mapCanvas()
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(map_canvas)
        map_canvas.setMapTool(self.emitPoint)
        self.dlg_new_psector.btn_add_arc_plan.setText('Editing')
        self.emitPoint.canvasClicked.connect(partial(self.click_button_add, layer_view, tablename, table_view, elem_type))


    def click_button_add(self,  layer_view, tablename, table_view, elem_type, point, button):
        """
        :param layer_view: it is the view we are using
        :param tablename:  Is the name of the table that we will use to make the SELECT and INSERT
        :param table_view: it's QTableView we are using, need ir for upgrade his own view
        :param elem_type: Used to buy the object that we "click" with the type of object we want to add or delete
        :param point: param inherited from signal canvasClicked
        :param button: param inherited from signal canvasClicked
        """
        
        if button == Qt.LeftButton:

            node_group = ["Junction", "Valve", "Reduction", "Tank", "Meter", "Manhole", "Source", "Hydrant"]
            arc_group = ["Pipe"]
            canvas = self.iface.mapCanvas()
            snapper = QgsMapCanvasSnapper(canvas)
            map_point = canvas.getCoordinateTransform().transform(point)
            x = map_point.x()
            y = map_point.y()
            event_point = QPoint(x, y)

            # Snapping
            (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped point
            if result:
                # Check feature
                for snapPoint in result:
                    element_type = snapPoint.layer.name()
                    feat_type = None
                    if element_type in node_group:
                        feat_type = 'node'
                    elif element_type in arc_group:
                        feat_type = 'arc'

                    if feat_type is not None:
                        # Get the point
                        feature = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                        element_id = feature.attribute(feat_type + '_id')

                        # LEAVE SELECTION
                        snapPoint.layer.select([snapPoint.snappedAtGeometry])
                        # Get depth of feature
                        if feat_type == elem_type:
                            sql = "SELECT * FROM " + self.schema_name + "." + tablename
                            sql+= " WHERE " + feat_type+"_id = '" + element_id+"' AND psector_id = '" + self.psector_id.text() + "'"
                            row = self.dao.get_row(sql)
                            if not row:
                                self.list_elemets[element_id] = feat_type
                            else:
                                message = "This id already exists"
                                self.controller.show_info(message, context_name='ui_message')
                        else:
                            message = self.tr("You are trying to introduce")+" "+feat_type+" "+self.tr("in a")+" "+elem_type
                            self.controller.show_info(message, context_name='ui_message')

        elif button == Qt.RightButton:
            for element_id, feat_type in self.list_elemets.items():
                sql = "INSERT INTO " + self.schema_name + "." + tablename + "(" + feat_type + "_id, psector_id)"
                sql += "VALUES (" + element_id + ", " + self.psector_id.text() + ")"
                self.controller.execute_sql(sql)
            table_view.model().select()
            self.emitPoint.canvasClicked.disconnect()
            self.list_elemets.clear()
            self.dlg_new_psector.btn_add_arc_plan.setText('Add')


    def cal_percent(self, widged_total, widged_percent, wided_result):
        wided_result.setText(str((float(widged_total.text())*float(widged_percent.text())/100)))


    def sum_total(self, widget_total, widged_percent, wided_result):
        wided_result.setText(str((float(widget_total.text()) + float(widged_percent.text()))))


    def mg_psector_mangement(self):
        """ Button_46 : Psector management """

        # psm es abreviacion de psector_management
        # Create the dialog and signals
        self.dlg_psector_mangement = Psector_management()
        utils_giswater.setDialog(self.dlg_psector_mangement)
        table_name = "plan_psector"
        column_id = "psector_id"
        
        # Tables
        self.tbl_psm = self.dlg_psector_mangement.findChild(QTableView, "tbl_psm")
        self.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        # Set signals
        self.dlg_psector_mangement.btn_accept.pressed.connect(self.charge_psector)
        self.dlg_psector_mangement.btn_cancel.pressed.connect(self.dlg_psector_mangement.close)
        self.dlg_psector_mangement.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.tbl_psm, table_name, column_id))
        self.dlg_psector_mangement.txt_name.textChanged.connect(partial(self.filter_by_text, self.tbl_psm, self.dlg_psector_mangement.txt_name, "plan_psector"))

        self.fill_table(self.tbl_psm, self.schema_name + ".plan_psector")
        self.dlg_psector_mangement.exec_()


    def charge_psector(self):
        
        selected_list = self.tbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        row = selected_list[0].row()
        psector_id = self.tbl_psm.model().record(row).value("psector_id")
        self.dlg_psector_mangement.close()
        self.mg_new_psector(psector_id, True)


    def filter_by_text(self, table, widget_txt, tablename):
        
        result_select = utils_giswater.getWidgetText(widget_txt)
        if result_select != 'null':
            expr = " name LIKE '%"+result_select+"%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(self.tbl_psm, self.schema_name + "."+tablename)


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])
            
            
    def show_colums(self, widget, comuns_to_show):
        for i in range(0, len(comuns_to_show)):
            widget.showColumn(comuns_to_show[i])


    def mg_psector_selector(self):
        """ Button_47 : Psector selector """

        # Create the dialog and signals
        self.dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(self.dlg_psector_sel)

        # Tables
        self.tbl_all_row = self.dlg_psector_sel.findChild(QTableView, "all_row")
        self.tbl_all_row.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT * FROM "+self.controller.schema_name+".plan_psector WHERE name not in ("
        sql += "SELECT name FROM "+self.controller.schema_name+".plan_psector RIGTH JOIN "
        sql += self.controller.schema_name+".selector_psector ON plan_psector.psector_id = selector_psector.psector_id "
        sql += "WHERE cur_user = current_user)"
        self.fill_table_by_query(self.tbl_all_row, sql)
        columstohide = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        self.hide_colums(self.tbl_all_row, columstohide)

        self.tbl_selected_psector = self.dlg_psector_sel.findChild(QTableView, "selected_row")
        self.tbl_selected_psector.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT name, cur_user, plan_psector.psector_id FROM "+self.controller.schema_name+".plan_psector "
        sql += "JOIN "+self.controller.schema_name+".selector_psector ON plan_psector.psector_id = selector_psector.psector_id "
        sql += "WHERE cur_user=current_user"
        self.fill_table_by_query(self.tbl_selected_psector, sql)

        self.dlg_psector_sel.btn_cancel.pressed.connect(self.dlg_psector_sel.close)

        query_left = "SELECT * FROM "+self.controller.schema_name+".plan_psector where name not in "
        query_left += "(SELECT name from "+self.controller.schema_name+".plan_psector "
        query_left += "RIGHT JOIN "+self.controller.schema_name+".selector_psector on plan_psector.psector_id = selector_psector.psector_id "
        query_left += "WHERE cur_user = current_user)"

        query_right = "SELECT name, cur_user, plan_psector.psector_id from "+self.controller.schema_name+".plan_psector "
        query_right += "JOIN "+self.controller.schema_name+".selector_psector on plan_psector.psector_id=selector_psector.psector_id "
        query_right += "WHERE cur_user = current_user"
        field = "psector_id"
        self.dlg_psector_sel.btn_select.pressed.connect(partial(self.multi_rows_selector, self.tbl_all_row, self.tbl_selected_psector, "psector_id", "selector_psector", "id", query_left,query_right, field))

        query_left = "SELECT * FROM " + self.controller.schema_name+".plan_psector WHERE name NOT IN "
        query_left += "(SELECT name FROM "+ self.controller.schema_name+".plan_psector RIGHT JOIN " + self.controller.schema_name+".selector_psector "
        query_left += "ON plan_psector.psector_id = selector_psector.psector_id where cur_user=current_user)"
        query_right = "SELECT name, cur_user, plan_psector.psector_id from "+self.controller.schema_name+".plan_psector "
        query_right += "JOIN "+self.controller.schema_name+".selector_psector ON plan_psector.psector_id = selector_psector.psector_id "
        query_right += "WHERE cur_user = current_user"

        query_delete = "DELETE FROM "+self.controller.schema_name+".selector_psector "
        query_delete += "WHERE current_user = cur_user and selector_psector.psector_id ="
        self.dlg_psector_sel.btn_unselect.pressed.connect(partial(self.unselector, self.tbl_all_row, self.tbl_selected_psector,
                                                                  query_delete, query_left, query_right, field))

        self.dlg_psector_sel.txt_name.textChanged.connect(partial(self.query_like_widget_text, self.dlg_psector_sel.txt_name))
        self.dlg_psector_sel.exec_()


    def query_like_widget_text(self, widget):
        
        query = widget.text()
        sql = "SELECT * FROM "+self.controller.schema_name+".plan_psector WHERE name NOT IN ("
        sql += "SELECT name FROM "+self.controller.schema_name+".plan_psector RIGHT JOIN "
        sql += self.controller.schema_name+".selector_psector on plan_psector.psector_id = selector_psector.psector_id "
        sql += "WHERE cur_user = current_user) AND name LIKE '%" + query + "%'"
        self.fill_table_by_query(self.tbl_all_row, sql)


    def mg_state_selector(self):
        """ Button_48 : state selector """
        
        # Create the dialog and signals
        self.dlg_state_sel = State_selector()
        utils_giswater.setDialog(self.dlg_state_sel)
        # Tables
        self.tbl_all_state = self.dlg_state_sel.findChild(QTableView, "all_state")
        self.tbl_all_state.setSelectionBehavior(QAbstractItemView.SelectRows)
        #self.set_configuration(self.tbl_all_state, "all_state")
        sql = "SELECT * FROM "+self.controller.schema_name+".value_state WHERE name NOT IN ("
        sql += "SELECT name FROM "+self.controller.schema_name+".value_state RIGHT JOIN "
        sql += self.controller.schema_name+".selector_state ON value_state.id = state_id WHERE cur_user=current_user)"
        self.fill_table_by_query(self.tbl_all_state, sql)
        columstohide = [0, 2, 3, 4]
        self.hide_colums(self.tbl_all_state, columstohide)

        self.tbl_selected_state = self.dlg_state_sel.findChild(QTableView, "selected_state")
        self.tbl_selected_state.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT name, cur_user, state_id from "+self.controller.schema_name+".value_state"
        sql += " JOIN "+self.controller.schema_name+".selector_state on value_state.id = state_id"
        sql += " WHERE cur_user=current_user"
        self.fill_table_by_query(self.tbl_selected_state, sql)
        columstohide = [2]
        self.hide_colums(self.tbl_selected_state, columstohide)

        query_left = "SELECT * from "+self.controller.schema_name+".value_state WHERE name not in (SELECT name FROM "+self.controller.schema_name+".value_state "
        query_left += " RIGHT JOIN "+self.controller.schema_name+".selector_state ON value_state.id = state_id WHERE cur_user=current_user)"
        query_right = "SELECT name, cur_user,state_id FROM "+self.controller.schema_name+".value_state JOIN "+self.controller.schema_name+".selector_state"
        query_right += " ON value_state.id=state_id WHERE cur_user=current_user"
        field = "state_id"
        self.dlg_state_sel.btn_select_state.pressed.connect(
            partial(self.multi_rows_selector, self.tbl_all_state, self.tbl_selected_state, "id", "selector_state",
                    "state_id", query_left, query_right, field))

        query_left = "SELECT * FROM "+self.controller.schema_name+".value_state WHERE name NOT IN "
        query_left += "(SELECT name FROM "+self.controller.schema_name+".value_state "
        query_left += "RIGHT JOIN "+self.controller.schema_name+".selector_state ON value_state.id = state_id WHERE cur_user = current_user)"

        query_right = "SELECT name, cur_user, state_id from "+self.controller.schema_name+".value_state JOIN "
        query_right += self.controller.schema_name+".selector_state ON value_state.id = state_id WHERE cur_user=current_user"
        query_delete = "DELETE FROM "+self.controller.schema_name+".selector_state WHERE current_user = cur_user and state_id ="
        field = "state_id"
        self.dlg_state_sel.btn_unselect_state.pressed.connect(
            partial(self.unselector, self.tbl_all_state, self.tbl_selected_state, query_delete, query_left, query_right, field))

        self.dlg_state_sel.btn_cancel.pressed.connect(self.dlg_state_sel.close)
        self.dlg_state_sel.exec_()


    def unselector(self, qtable_left, qtable_right, sql, query_left, query_right, field):
        
        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(sql+str(expl_id[i]))

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)
        self.iface.mapCanvas().refresh()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right, field):
        """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param tablename_ori: table origin
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(" + id_des + ", cur_user)"
            sql+= " FROM " + self.schema_name+"." + tablename_des
            sql+= " WHERE " + id_des + " = '" + str(expl_id[i])
            row = self.dao.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id "+str(expl_id[i])+" is already selected!", "Info")
            else:
                sql = 'INSERT INTO '+self.schema_name+'.'+tablename_des+' ('+field+', cur_user) '
                sql += " VALUES ("+str(expl_id[i])+", current_user)"
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.iface.mapCanvas().refresh()
        

    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()