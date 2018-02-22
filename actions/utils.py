"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QDateEdit, QFileDialog, QStandardItem, QStandardItemModel

import os
import sys
import csv
import operator
from functools import partial
from encodings.aliases import aliases

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
from parent import ParentAction
from actions.manage_visit import ManageVisit
from ui.config import ConfigUtils
from ui.toolbox import Toolbox
from ui.topology_tools import TopologyTools
from ui.csv2pg import Csv2Pg


class Utils(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)        


    def set_project_type(self, project_type):     
        self.project_type = project_type


    def utils_arc_topo_repair(self):            
        """ Button 19: Topology repair """
        
        # Create dialog to check wich topology functions we want to execute
        self.dlg_toolbox = Toolbox()
        # if self.project_type == 'ws':
        #     self.dlg_toolbox.tab_review.removeTab(1)
            
        # Set signals
        self.dlg_toolbox.btn_accept.clicked.connect(self.utils_arc_topo_repair_accept)
        self.dlg_toolbox.btn_cancel.clicked.connect(self.dlg_toolbox.close)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_toolbox, 'toolbox')
        self.dlg_toolbox.exec_()


    def utils_arc_topo_repair_accept(self):
        """ Button 19: Executes functions that are selected """

        # Edit/Utils

        # Check project / data

        if self.dlg_toolbox.check_qgis_project.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(1);")
            results = self.controller.get_row(sql)
            self.upsert_selector_audit(results)
        if self.dlg_toolbox.check_user_vdefault_parameters.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(19);")
            results = self.controller.execute_sql(sql)

        #Topology Builder

        if self.dlg_toolbox.check_create_nodes_from_arcs.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_built_nodefromarc();")
            results = self.controller.execute_sql(sql)

        # Topology review

        if self.dlg_toolbox.check_node_orphan.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_orphan();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_duplicated.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_topology_coherence.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_topological_consistency();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arc_same_start_end.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arcs_without_nodes_start_end.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_no_startend_node();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_connec_duplicated.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_mincut_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_edit_audit_check_data(25);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_profile_tool_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_edit_audit_check_data(26);")
            results = self.controller.execute_sql(sql)

        # Topology Repair

        if self.dlg_toolbox.check_arc_searchnodes.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_repair_arc_searchnodes();")
            results = self.controller.execute_sql(sql)

        # Master

        #Master/Price

        if self.dlg_toolbox.check_reconstruction_price.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_audit_check_data(15);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_rehabilitation_price.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_audit_check_data(16);")
            results = self.controller.execute_sql(sql)

        # Master/Advanced_topology_review

        if self.dlg_toolbox.check_arc_multi_psector.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(20);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_multi_psector.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(21);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_orphan_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(22);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_duplicated_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(23);")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arcs_without_nodes_start_end_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(24);")
            results = self.controller.execute_sql(sql)


        # Admin

        if self.dlg_toolbox.check_schema_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(2);")
            results = self.controller.execute_sql(sql)

        # Edit/UD
        if self.dlg_toolbox.check_node_sink.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_sink();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_flow_regulator.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_flowregulator();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_exit_upper_node_entry.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_exit_upper_intro();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arc_intersection_without_node.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_intersection();")
            results = self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_inverted_arcs.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_inverted();")
            results = self.controller.execute_sql(sql)

        # for result in results:
        #     self.upsert_selector_audit(result)

        # Close the dialog
        self.close_dialog()

        # Refresh map canvas
        self.refresh_map_canvas()
        
        
    def utils_giswater_jar(self):
        """ Button 36: Open giswater.jar with selected .gsw file """ 

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("ed_giswater_jar")
        else:
            self.controller.show_info("Function not supported in this Operating System")               


    def utils_config(self):
        """ Button 99: Config utils """
            
        # Create the dialog and signals
        self.dlg = ConfigUtils()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)

        self.dlg.btn_accept.pressed.connect(self.utils_config_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))

        # Set values from widgets of type QComboBox and dates
        # Edit
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows, False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state_type ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("statetype_vdefault", rows, False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows, False)
        sql = "SELECT id FROM " + self.schema_name + ".value_verified ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows, False)

        sql = "SELECT id FROM " + self.schema_name + ".cat_arc ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arccat_vdefault", rows, False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_node ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows, False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_connec ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows, False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_element ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("elementcat_vdefault", rows, False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".exploitation ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("exploitation_vdefault", rows, False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".ext_municipality ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("municipality_vdefault", rows, False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".sector ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("sector_vdefault", rows, False)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_pavement ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("pavementcat_vdefault", rows, False)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_soil ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("soilcat_vdefault", rows, False)
        sql = ("SELECT name FROM " + self.schema_name + ".dma ORDER BY name")
        rows = self.controller.get_row(sql)
        utils_giswater.fillComboBox("dma_vdefault", rows, False)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_polygon'")
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_polygon, rows)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_point, rows)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_line'")
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_line, rows)

        # WS
        sql = "SELECT id FROM " + self.schema_name + ".cat_presszone ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("presszone_vdefault", rows, False)
        self.populate_combo_ws(self.dlg.wtpcat_vdefault, "ETAP")
        self.populate_combo_ws("hydrantcat_vdefault", "HYDRANT")
        self.populate_combo_ws("filtercat_vdefault", "FILTER")
        self.populate_combo_ws("pumpcat_vdefault", "PUMP")
        self.populate_combo_ws("waterwellcat_vdefault", "WATERWELL")
        self.populate_combo_ws("metercat_vdefault", "METER")
        self.populate_combo_ws("tankcat_vdefault", "TANK")
        self.populate_combo_ws("manholecat_vdefault", "MANHOLE")
        self.populate_combo_ws("valvecat_vdefault", "VALVE")
        self.populate_combo_ws("registercat_vdefault", "REGISTER")
        self.populate_combo_ws("sourcecat_vdefault", "SOURCE")
        self.populate_combo_ws("junctioncat_vdefault", "JUNCTION")
        self.populate_combo_ws("expansiontankcat_vdefault", "EXPANSIONTANK")
        self.populate_combo_ws("netwjoincat_vdefault", "NETWJOIN")
        self.populate_combo_ws("reductioncat_vdefault", "REDUCTION")
        self.populate_combo_ws("netelementcat_vdefault", "NETELEMENT")
        self.populate_combo_ws("netsamplepointcat_vdefault", "NETSAMPLEPOINT")
        self.populate_combo_ws("flexunioncat_vdefault", "FLEXUNION")

        # UD
        sql = "SELECT id FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".arc_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".connec_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        # Set current values
        sql = ("SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_" + str(row[0]), True)

        # TODO: Parametrize it
        self.utils_sql("name", "value_state", "id", "state_vdefault")
        self.utils_sql("name", "exploitation", "expl_id", "exploitation_vdefault")
        self.utils_sql("name", "ext_municipality", "muni_id", "municipality_vdefault")
        self.utils_sql("id", "cat_soil", "id", "soilcat_vdefault")

        if self.project_type == 'ws':
            self.dlg.config_tab_vdefault.removeTab(2)
            self.dlg.tab_config_2.removeTab(2)
        elif self.project_type == 'ud':
            self.dlg.config_tab_vdefault.removeTab(1)
            self.dlg.tab_config_2.removeTab(1)
            # Epa
            sql = "SELECT id FROM" + self.schema_name + ".inp_typevalue_outfall"
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox("epa_outfall_type_vdefault", rows)

        #TODO: Parametrize it.
        cur_user = self.controller.get_current_user()
        if cur_user == 'user_basic':
            for i in range(5):
                self.dlg.tabWidget.removeTab(1)
        elif cur_user == 'user_om':
            for i in range(4):
                self.dlg.tabWidget.removeTab(2)
        elif cur_user == 'user_epa':
            for i in range(3):
                self.dlg.tabWidget.removeTab(3)
        elif cur_user == 'user_edit':
            for i in range(2):
                self.dlg.tabWidget.removeTab(4)
        elif cur_user == 'user_master':
                self.dlg.tabWidget.removeTab(5)

        # MasterPlan
        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)
        sql = "SELECT scale FROM" + self.schema_name + ".plan_psector ORDER BY scale"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_scale_vdefault", rows)
        sql = "SELECT rotation FROM" + self.schema_name + ".plan_psector ORDER BY rotation"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_rotation_vdefault", rows)
        sql = "SELECT gexpenses FROM" + self.schema_name + ".plan_psector ORDER BY gexpenses"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_gexpenses_vdefault", rows)
        sql = "SELECT vat FROM" + self.schema_name + ".plan_psector ORDER BY vat"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_vat_vdefault", rows)
        sql = "SELECT other FROM" + self.schema_name + ".plan_psector ORDER BY other"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("psector_other_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_scale_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_scale_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_rotation_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_rotation_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_gexpenses_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_gexpenses_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_vat_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_vat_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE cur_user = current_user AND parameter = 'psector_other_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_other_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))

        # Om
        sql = ("SELECT name"
               " FROM " + self.schema_name + ".om_visit_cat"
               " ORDER BY name")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("visitcat_vdefault", rows)
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit_parameter_type"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("om_param_type_vdefault", rows)

        self.dlg.exec_()
        
    
    def utils_config_accept(self):

        # TODO: Parametrize it. Loop through all widgets
        if utils_giswater.isChecked("chk_state_vdefault"):
            self.upsert_config_param_user(self.dlg.state_vdefault, "state_vdefault")
        else:
            self.delete_config_param_user("state_vdefault")
        if utils_giswater.isChecked("chk_statetype_vdefault"):
            self.upsert_config_param_user(self.dlg.statetype_vdefault, "statetype_vdefault")
        else:
            self.delete_config_param_user("statetype_vdefault")
        if utils_giswater.isChecked("chk_workcat_vdefault"):
            self.upsert_config_param_user(self.dlg.workcat_vdefault, "workcat_vdefault")
        else:
            self.delete_config_param_user("workcat_vdefault")
        if utils_giswater.isChecked("chk_verified_vdefault"):
            self.upsert_config_param_user(self.dlg.verified_vdefault, "verified_vdefault")
        else:
            self.delete_config_param_user("verified_vdefault")
        if utils_giswater.isChecked("chk_builtdate_vdefault"):
            self.upsert_config_param_user(self.dlg.builtdate_vdefault, "builtdate_vdefault")
        else:
            self.delete_config_param_user("builtdate_vdefault")
        if utils_giswater.isChecked("chk_enddate_vdefault"):
            self.upsert_config_param_user(self.dlg.enddate_vdefault, "enddate_vdefault")
        else:
            self.delete_config_param_user("enddate_vdefault")
        if utils_giswater.isChecked("chk_arccat_vdefault"):
            self.upsert_config_param_user(self.dlg.arccat_vdefault, "arccat_vdefault")
        else:
            self.delete_config_param_user("arccat_vdefault")
        if utils_giswater.isChecked("chk_nodecat_vdefault"):
            self.upsert_config_param_user(self.dlg.nodecat_vdefault, "nodecat_vdefault")
        else:
            self.delete_config_param_user("nodecat_vdefault")
        if utils_giswater.isChecked("chk_connecat_vdefault"):
            self.upsert_config_param_user(self.dlg.connecat_vdefault, "connecat_vdefault")
        else:
            self.delete_config_param_user("connecat_vdefault")
        if utils_giswater.isChecked("chk_elementcat_vdefault"):
            self.upsert_config_param_user(self.dlg.elementcat_vdefault, "elementcat_vdefault")
        else:
            self.delete_config_param_user("elementcat_vdefault")
        if utils_giswater.isChecked("chk_exploitation_vdefault"):
            self.upsert_config_param_user(self.dlg.exploitation_vdefault, "exploitation_vdefault")
        else:
            self.delete_config_param_user("exploitation_vdefault")
        if utils_giswater.isChecked("chk_municipality_vdefault"):
            self.upsert_config_param_user(self.dlg.municipality_vdefault, "municipality_vdefault")
        else:
            self.delete_config_param_user("municipality_vdefault")
        if utils_giswater.isChecked("chk_sector_vdefault"):
            self.upsert_config_param_user(self.dlg.sector_vdefault, "sector_vdefault")
        else:
            self.delete_config_param_user("sector_vdefault")
        if utils_giswater.isChecked("chk_pavementcat_vdefault"):
            self.upsert_config_param_user(self.dlg.pavementcat_vdefault, "pavementcat_vdefault")
        else:
            self.delete_config_param_user("pavementcat_vdefault")
        if utils_giswater.isChecked("chk_soilcat_vdefault"):
            self.upsert_config_param_user(self.dlg.soilcat_vdefault, "soilcat_vdefault")
        else:
            self.delete_config_param_user("soilcat_vdefault")
        if utils_giswater.isChecked("chk_dma_vdefault"):
            self.upsert_config_param_user(self.dlg.dma_vdefault, "dma_vdefault")
        else:
            self.delete_config_param_user("dma_vdefault")
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.upsert_config_param_user(self.dlg.visitcat_vdefault, "visitcat_vdefault")
        else:
            self.delete_config_param_user("visitcat_vdefault")
        if utils_giswater.isChecked("chk_virtual_layer_polygon"):
            self.upsert_config_param_user(self.dlg.virtual_layer_polygon, "virtual_layer_polygon")
        else:
            self.delete_config_param_user("virtual_layer_polygon")
        if utils_giswater.isChecked("chk_virtual_layer_point"):
            self.upsert_config_param_user(self.dlg.virtual_layer_point, "virtual_layer_point")
        else:
            self.delete_config_param_user("virtual_layer_point")
        if utils_giswater.isChecked("chk_virtual_layer_line"):
            self.upsert_config_param_user(self.dlg.virtual_layer_line, "virtual_layer_line")
        else:
            self.delete_config_param_user("virtual_layer_line")

        if utils_giswater.isChecked("chk_dim_tooltip"):
            self.upsert_config_param_user("chk_dim_tooltip", "dim_tooltip")
        else:
            self.delete_config_param_user("dim_tooltip")

        # WS
        if utils_giswater.isChecked("chk_presszone_vdefault"):
            self.upsert_config_param_user(self.dlg.presszone_vdefault, "presszone_vdefault")
        else:
            self.delete_config_param_user("presszone_vdefault")
        if utils_giswater.isChecked("chk_wtpcat_vdefault"):
            self.upsert_config_param_user(self.dlg.wtpcat_vdefault, "wtpcat_vdefault")
        else:
            self.delete_config_param_user("wtpcat_vdefault")
        if utils_giswater.isChecked("chk_netsamplepointcat_vdefault"):
            self.upsert_config_param_user(self.dlg.netsamplepointcat_vdefault, "netsamplepointcat_vdefault")
        else:
            self.delete_config_param_user("netsamplepointcat_vdefault")
        if utils_giswater.isChecked("chk_netelementcat_vdefault"):
            self.upsert_config_param_user(self.dlg.netelementcat_vdefault, "netelementcat_vdefault")
        else:
            self.delete_config_param_user("netelementcat_vdefault")
        if utils_giswater.isChecked("chk_flexunioncat_vdefault"):
            self.upsert_config_param_user(self.dlg.flexunioncat_vdefault, "flexunioncat_vdefault")
        else:
            self.delete_config_param_user("flexunioncat_vdefault")
        if utils_giswater.isChecked("chk_tankcat_vdefault"):
            self.upsert_config_param_user(self.dlg.tankcat_vdefault, "tankcat_vdefault")
        else:
            self.delete_config_param_user("tankcat_vdefault")
        if utils_giswater.isChecked("chk_hydrantcat_vdefault"):
            self.upsert_config_param_user(self.dlg.hydrantcat_vdefault, "hydrantcat_vdefault")
        else:
            self.delete_config_param_user("hydrantcat_vdefault")
        if utils_giswater.isChecked("chk_junctioncat_vdefault"):
            self.upsert_config_param_user(self.dlg.junctioncat_vdefault, "junctioncat_vdefault")
        else:
            self.delete_config_param_user("junctioncat_vdefault")
        if utils_giswater.isChecked("chk_pumpcat_vdefault"):
            self.upsert_config_param_user(self.dlg.pumpcat_vdefault, "pumpcat_vdefault")
        else:
            self.delete_config_param_user("pumpcat_vdefault")
        if utils_giswater.isChecked("chk_reductioncat_vdefault"):
            self.upsert_config_param_user(self.dlg.reductioncat_vdefault, "reductioncat_vdefault")
        else:
            self.delete_config_param_user("reductioncat_vdefault")
        if utils_giswater.isChecked("chk_valvecat_vdefault"):
            self.upsert_config_param_user(self.dlg.valvecat_vdefault, "valvecat_vdefault")
        else:
            self.delete_config_param_user("valvecat_vdefault")
        if utils_giswater.isChecked("chk_manholecat_vdefault"):
            self.upsert_config_param_user(self.dlg.manholecat_vdefault, "manholecat_vdefault")
        else:
            self.delete_config_param_user("manholecat_vdefault")
        if utils_giswater.isChecked("chk_metercat_vdefault"):
            self.upsert_config_param_user(self.dlg.metercat_vdefault, "metercat_vdefault")
        else:
            self.delete_config_param_user("metercat_vdefault")
        if utils_giswater.isChecked("chk_sourcecat_vdefault"):
            self.upsert_config_param_user(self.dlg.sourcecat_vdefault, "sourcecat_vdefault")
        else:
            self.delete_config_param_user("sourcecat_vdefault")
        if utils_giswater.isChecked("chk_waterwellcat_vdefault"):
            self.upsert_config_param_user(self.dlg.waterwellcat_vdefault, "waterwellcat_vdefault")
        else:
            self.delete_config_param_user("waterwellcat_vdefault")
        if utils_giswater.isChecked("chk_filtercat_vdefault"):
            self.upsert_config_param_user(self.dlg.filtercat_vdefault, "filtercat_vdefault")
        else:
            self.delete_config_param_user("filtercat_vdefault")
        if utils_giswater.isChecked("chk_registercat_vdefault"):
            self.upsert_config_param_user(self.dlg.registercat_vdefault, "registercat_vdefault")
        else:
            self.delete_config_param_user("registercat_vdefault")
        if utils_giswater.isChecked("chk_netwjoincat_vdefault"):
            self.upsert_config_param_user(self.dlg.netwjoincat_vdefault, "netwjoincat_vdefault")
        else:
            self.delete_config_param_user("netwjoincat_vdefault")
        if utils_giswater.isChecked("chk_expansiontankcat_vdefault"):
            self.upsert_config_param_user(self.dlg.expansiontankcat_vdefault, "expansiontankcat_vdefault")
        else:
            self.delete_config_param_user("expansiontankcat_vdefault")
            
        # UD
        if utils_giswater.isChecked("chk_nodetype_vdefault"):
            sql = ("SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
                   "(SELECT value FROM " + self.schema_name + ".config_param_user"
                   " WHERE parameter = 'exploitation_vdefault')::text")
            row = self.controller.get_row(sql)
            if row:
                utils_giswater.setWidgetText("exploitation_vdefault", str(row[0]))
            self.upsert_config_param_user(self.dlg.nodetype_vdefault, "nodetype_vdefault")
        else:
            self.delete_config_param_user("nodetype_vdefault")
        if utils_giswater.isChecked("chk_arctype_vdefault"):
            self.upsert_config_param_user(self.dlg.arctype_vdefault, "arctype_vdefault")
        else:
            self.delete_config_param_user("arctype_vdefault")
        if utils_giswater.isChecked("chk_connectype_vdefault"):
            self.upsert_config_param_user(self.dlg.connectype_vdefault, "connectype_vdefault")
        else:
            self.delete_config_param_user("connectype_vdefault")

        # MasterPlan
        if utils_giswater.isChecked("chk_psector_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_vdefault, "psector_vdefault")
        else:
            self.delete_config_param_user("psector_vdefault")
        if utils_giswater.isChecked("chk_psector_scale_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_scale_vdefault, "psector_scale_vdefault")
        else:
            self.delete_config_param_user("psector_scale_vdefault")
        if utils_giswater.isChecked("chk_psector_rotation_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_rotation_vdefault, "psector_rotation_vdefault")
        else:
            self.delete_config_param_user("psector_rotation_vdefault")
        if utils_giswater.isChecked("chk_psector_gexpenses_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_gexpenses_vdefault, "psector_gexpenses_vdefault")
        else:
            self.delete_config_param_user("psector_gexpenses_vdefault")
        if utils_giswater.isChecked("chk_psector_vat_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_vat_vdefault, "psector_vat_vdefault")
        else:
            self.delete_config_param_user("psector_vat_vdefault")
        if utils_giswater.isChecked("chk_psector_other_vdefault"):
            self.upsert_config_param_user_master(self.dlg.psector_other_vdefault, "psector_other_vdefault")
        else:
            self.delete_config_param_user("psector_other_vdefault")
        
        # OM
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.upsert_config_param_user(self.dlg.visitcat_vdefault, "visitcat_vdefault")
        else:
            self.delete_config_param_user("visitcat_vdefault")
        if utils_giswater.isChecked("chk_om_param_type_vdefault"):
            self.upsert_config_param_user(self.dlg.om_param_type_vdefault, "om_param_type_vdefault")
        else:
            self.delete_config_param_user("om_param_type_vdefault")
        # Epa
        if utils_giswater.isChecked("chk_epa_outfall_type_vdefault"):
            self.upsert_config_param_user(self.dlg.epa_outfall_type_vdefault, "epa_outfall_type_vdefault")
        else:
            self.delete_config_param_user("epa_outfall_type_vdefault")

        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg)


    def utils_info(self):
        """ Button 100: Utils info """
                
        self.controller.log_info("utils_info")          


    def utils_import_csv(self):
        """ Button 83: Import CSV """
        
        self.dlg_csv = Csv2Pg()
        utils_giswater.setDialog(self.dlg_csv)
        roles = self.controller.get_rolenames()

        temp_tablename = 'temp_csv2pg'
        self.populate_cmb_unicodes(self.dlg_csv.cmb_unicode_list)
        self.populate_combos(self.dlg_csv.cmb_import_type, 'id', 'name_i18n, csv_structure', 'sys_csv2pg_cat', roles, False)

        self.dlg_csv.lbl_info.setWordWrap(True)
        utils_giswater.setWidgetText(self.dlg_csv.cmb_unicode_list, 'utf8')
        self.dlg_csv.rb_comma.setChecked(False)
        self.dlg_csv.rb_semicolon.setChecked(True)

        # Signals
        self.dlg_csv.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_csv))
        self.dlg_csv.btn_accept.clicked.connect(partial(self.write_csv, self.dlg_csv, temp_tablename))

        self.dlg_csv.cmb_import_type.currentIndexChanged.connect(partial(self.update_info, self.dlg_csv))

        self.dlg_csv.btn_file_csv.clicked.connect(partial(self.select_file_csv))
        self.dlg_csv.cmb_unicode_list.currentIndexChanged.connect(partial(self.validate_params, self.dlg_csv))
        self.dlg_csv.rb_comma.clicked.connect(partial(self.preview_csv, self.dlg_csv))
        self.dlg_csv.rb_semicolon.clicked.connect(partial(self.preview_csv, self.dlg_csv))

        self.load_settings_values()

        self.preview_csv(self.dlg_csv)
        self.dlg_csv.progressBar.setVisible(False)

        self.dlg_csv.exec_()
        
        
    def populate_cmb_unicodes(self, combo):
        """ Populate combo with full list of codes """
        
        unicode_list = []
        for item in aliases.items():
            unicode_list.append(str(item[0]))
            sorted_list = sorted(unicode_list, key=str.lower)
        utils_giswater.set_autocompleter(combo, sorted_list)


    def update_info(self, dialog):
        """ Update the tag according to item selected from cmb_import_type """
        dialog.lbl_info.setText(utils_giswater.get_item_data(self.dlg_csv.cmb_import_type, 2))


    def load_settings_values(self):
        """ Load QGIS settings related with csv options """
        
        cur_user = self.controller.get_current_user()
        utils_giswater.setWidgetText(self.dlg_csv.txt_file_csv, self.controller.plugin_settings_value('Csv2Pg_txt_file_csv_'+cur_user))
        utils_giswater.setWidgetText(self.dlg_csv.cmb_unicode_list, self.controller.plugin_settings_value('Csv2Pg_cmb_unicode_list_'+cur_user))
        if self.controller.plugin_settings_value('Csv2Pg_rb_comma_'+cur_user).title() == 'True':
            self.dlg_csv.rb_comma.setChecked(True)
        else:
            self.dlg_csv.rb_semicolon.setChecked(True)


    def save_settings_values(self):
        """ Save QGIS settings related with csv options """
        
        cur_user = self.controller.get_current_user()
        self.controller.plugin_settings_set_value("Csv2Pg_txt_file_csv_"+cur_user, utils_giswater.getWidgetText('txt_file_csv'))
        self.controller.plugin_settings_set_value("Csv2Pg_cmb_unicode_list_"+cur_user, utils_giswater.getWidgetText('cmb_unicode_list'))
        self.controller.plugin_settings_set_value("Csv2Pg_rb_comma_"+cur_user, bool(self.dlg_csv.rb_comma.isChecked()))
        self.controller.plugin_settings_set_value("Csv2Pg_rb_semicolon_"+cur_user, bool(self.dlg_csv.rb_semicolon.isChecked()))


    def validate_params(self, dialog):
        """ Validate if params are valids """
        
        label_aux = utils_giswater.getWidgetText(dialog.txt_import)
        path = self.get_path(dialog)
        self.preview_csv(dialog)
        if path is None or path == 'null':
            return False
        if label_aux is None or label_aux == 'null':
            message = "Please put a import label"
            self.controller.show_warning(message)
            return False
        
        return True


    def get_path(self, dialog):
        """ Take the file path if exist. AND if not exit ask it """
        
        path = utils_giswater.getWidgetText(dialog.txt_file_csv)
        if path is None or path == 'null' or not os.path.exists(path):
            message = "Please choose a valid path"
            self.controller.show_warning(message)
            return None            
        if path.find('.csv') == -1:
            message = "Please choose a csv file"
            self.controller.show_warning(message)
            return None            
        if path is None or path == 'null':
            message = "Please choose a file"
            self.controller.show_warning(message)
            return None
        
        return path


    def get_delimiter(self, dialog):
        
        delimiter = ';'
        if dialog.rb_semicolon.isChecked():
            delimiter = ';'
        elif dialog.rb_comma.isChecked():
            delimiter = ','
        return delimiter


    def preview_csv(self, dialog):
        """ Show current file in QTableView acorrding to selected delimiter and unicode """
        
        path = self.get_path(dialog)
        if path is None:
            return
              
        delimiter = self.get_delimiter(dialog)   
        model = QStandardItemModel()
        _unicode = utils_giswater.getWidgetText(dialog.cmb_unicode_list)
        dialog.tbl_csv.setModel(model)
        dialog.tbl_csv.horizontalHeader().setStretchLastSection(True) 
                
        try:
            with open(path, "rb") as file_input: 
                rows = csv.reader(file_input, delimiter=delimiter)
                for row in rows:
                    unicode_row = [x.decode(str(_unicode)) for x in row]
                    items = [QStandardItem(field)for field in unicode_row]
                    model.appendRow(items)
        except Exception as e:
            self.controller.show_warning(str(e))     
        
        
    def delete_table_csv(self, temp_tablename, csv2pgcat_id_aux):
        """ Delete records from temp_csv2pg for current user and selected cat """
        sql = ("DELETE FROM " + self.schema_name + "." + temp_tablename + " "
               " WHERE csv2pgcat_id = '" +str(csv2pgcat_id_aux) + "' AND user_name = current_user")
        self.controller.execute_sql(sql)


    def write_csv(self, dialog, temp_tablename):
        """ Write csv in postgre and call gw_fct_utils_csv2pg function """
        
        if not self.validate_params(dialog):
            return
        
        csv2pgcat_id_aux = utils_giswater.get_item_data(dialog.cmb_import_type, 0)
        self.delete_table_csv(temp_tablename, csv2pgcat_id_aux)
        path = utils_giswater.getWidgetText(dialog.txt_file_csv)
        label_aux = utils_giswater.getWidgetText(dialog.txt_import)
        delimiter = self.get_delimiter(dialog)
        _unicode = utils_giswater.getWidgetText(dialog.cmb_unicode_list)
        cabecera = True
        fields = "csv2pgcat_id, "
        progress = 0
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setValue(progress)
        
        try:
            with open(path, 'rb') as csvfile:
                # counts rows in csvfile, using var "row_count" to do progresbar
                row_count = sum(1 for rows in csvfile)  #@UnusedVariable  
                dialog.progressBar.setMaximum(row_count - 20)  # -20 for see 100% complete progress
                csvfile.seek(0)  # Position the cursor at position 0 of the file
                reader = csv.reader(csvfile, delimiter=delimiter)
                for row in reader:
                    values = "'" + str(csv2pgcat_id_aux)+"', '"
                    progress += 1
    
                    for x in range(0, len(row)):
                        row[x] = row[x].replace("'", "''")
                    if cabecera:
                        for x in range(1, len(row)+1):
                            fields += 'csv' + str(x)+", "
                        cabecera = False
                        fields = fields[:-2]
                    else:
                        for value in row:
                            if len(value) != 0:
                                values += str(value.decode(str(_unicode))) + "', '"
                            else:
                                values = values[:-1]
                                values += "null, '"
                        values = values[:-3]
                        sql = ("INSERT INTO " + self.controller.schema_name + "." + temp_tablename + " ("
                               + str(fields) + ") VALUES (" + str(values) + ")")

                        status = self.controller.execute_sql(sql)
                        if not status:
                            return
                        dialog.progressBar.setValue(progress)
                    
        except Exception as e:
            self.controller.show_warning(str(e))
            return                               
                                
        message = "Import has been satisfactory"
        self.controller.show_info(message)

        sql = ("SELECT " + self.schema_name + ".gw_fct_utils_csv2pg("
               + str(csv2pgcat_id_aux) + ", '" + str(label_aux) + "')")
        self.controller.execute_sql(sql)

        self.save_settings_values()


    def get_data_from_combo(self, combo, position):
        
        elem = combo.itemData(combo.currentIndex())
        data = str(elem[position])
        return data


    def populate_combos(self, combo, field_id, fields, table_name, roles, allow_nulls=True):

        if roles is None:
            return
        
        sql = ("SELECT DISTINCT(" + field_id + "), " + fields + ""
               " FROM " + self.schema_name + "." + table_name + ""
               " WHERE sys_role IN " + roles + "")
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        if len(rows) == 0:
            message = "You do not have permission to execute this application"
            self.dlg_csv.lbl_info.setText(message)
            self.dlg_csv.lbl_info.setStyleSheet("QLabel{color: red;}")
            self.dlg_csv.setEnabled(False)
            return

        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)

        self.update_info(self.dlg_csv)


    def select_file_csv(self):
        """ Select CSV file """

        file_csv = utils_giswater.getWidgetText('txt_file_csv')
        # Set default value if necessary
        if file_csv is None or file_csv == '':
            file_csv = self.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(file_csv)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select CSV file")
        file_csv = QFileDialog.getOpenFileName(None, message, "", '*.csv')
        self.dlg_csv.txt_file_csv.setText(file_csv)
        self.save_settings_values()


    def populate_combo_ws(self, widget, node_type):
        
        sql = ("SELECT cat_node.id FROM " + self.schema_name + ".cat_node"
               " INNER JOIN " + self.schema_name + ".node_type ON cat_node.nodetype_id = node_type.id"
               " WHERE node_type.type = '" + node_type + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows,False)


    def utils_sql(self, sel, table, atribute, value):

        sql = ("SELECT " + sel + " FROM " + self.schema_name + "." + table + ""
               " WHERE " + atribute + "::text = "
               " (SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = '" + value + "')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(value, str(row[0]))


    def upsert_config_param_user_master(self, widget, parameter):
        """ Insert or update values in tables with current_user control """

        tablename = "config_param_user"
        sql = ("SELECT * FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'" + utils_giswater.getWidgetText(widget) + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', '" + utils_giswater.getWidgetText(widget) + "', current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', "
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "'), current_user)"
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


    def upsert_config_param_user(self, widget, parameter):
        """ Insert or update value of @parameter in table 'config_param_user' with current_user control """

        tablename = "config_param_user"
        sql = ("SELECT parameter FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user AND parameter = '" + str(parameter) + "'")
        exist_param = self.controller.get_row(sql)

        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value = "
                    if widget.objectName() == 'state_vdefault':
                        sql += ("(SELECT id FROM " + self.schema_name + ".value_state"
                                " WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                                " WHERE parameter = 'state_vdefault'")
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += ("(SELECT expl_id FROM " + self.schema_name + ".exploitation"
                                " WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                                " WHERE parameter = 'exploitation_vdefault' ")
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += ("(SELECT muni_id FROM " + self.schema_name + ".ext_municipality"
                                " WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                                " WHERE parameter = 'municipality_vdefault'")
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += ("(SELECT id FROM " + self.schema_name + ".om_visit_cat"
                                " WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                                " WHERE parameter = 'visitcat_vdefault'")
                    else:
                        sql += ("'" + str(utils_giswater.getWidgetText(widget)) + "'"
                                " WHERE cur_user = current_user AND parameter = '" + parameter + "'")
                else:
                    sql = "INSERT INTO " + self.schema_name + "." + tablename + "(parameter, value, cur_user)"
                    if widget.objectName() == 'state_vdefault':
                        sql += (" VALUES ('" + parameter + "',"
                                " (SELECT id FROM " + self.schema_name + ".value_state"
                                " WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)")
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += (" VALUES ('" + parameter + "',"
                                " (SELECT expl_id FROM " + self.schema_name + ".exploitation"
                                " WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)")
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += (" VALUES ('" + parameter + "',"
                                " (SELECT muni_id FROM " + self.schema_name + ".ext_municipality"
                                " WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)")
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += (" VALUES ('" + parameter + "',"
                                " (SELECT id FROM " + self.schema_name + ".om_visit_cat"
                                " WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)")
                    else:
                        sql += (" VALUES ('" + parameter + "', '"
                                + str(utils_giswater.getWidgetText(widget)) + "', current_user)")
        else:
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value = "
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter = '" + parameter + "'"
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"

        self.controller.execute_sql(sql)


    def delete_config_param_user(self, parameter):
        """ Delete value of @parameter in table 'config_param_user' with current_user control """     
           
        tablename = "config_param_user"
        sql = ("DELETE FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user AND parameter = '" + parameter + "'")
        self.controller.execute_sql(sql)

    def upsert_selector_audit(self,result):
        """ Insert or update values in tables with current_user control """

        tablename = "selector_audit"
        sql = ("SELECT * FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user")
        self.controller.log_info(str(sql))
        exist_param = self.controller.get_row(sql)
        if exist_param:
            self.controller.log_info(str("TEST DELETE"))
            sql = ("DELETE FROM " + self.schema_name + "." + tablename + ""
                   " WHERE cur_user = current_user")
            self.controller.log_info(str(sql))
            self.controller.execute_sql(sql)

        sql = ("INSERT INTO " + self.schema_name + "." + tablename + " (fprocesscat_id, cur_user)"
              " VALUES ('" + str(result[0]) + "', current_user)")
        self.controller.log_info(str("TEST INSERT"))
        self.controller.log_info(str(sql))

        self.controller.execute_sql(sql)

