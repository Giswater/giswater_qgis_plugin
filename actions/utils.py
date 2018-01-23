"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
from parent import ParentAction
from actions.manage_visit import ManageVisit
from ui.config import ConfigUtils
from ui.topology_tools import TopologyTools   


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
        self.dlg = TopologyTools()
        if self.project_type == 'ws':
            self.dlg.tab_review.removeTab(1)
            
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.utils_arc_topo_repair_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'topology_tools')
        self.dlg.exec_()


    def utils_arc_topo_repair_accept(self):
        """ Button 19: Executes functions that are selected """

        # Review/Utils
        if self.dlg.check_node_orphan.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_orphan();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();"
            self.controller.execute_sql(sql)
        if self.dlg.check_topology_coherence.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_topological_consistency();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arc_same_start_end.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arcs_without_nodes_start_end.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_no_startend_node();"
            self.controller.execute_sql(sql)
        if self.dlg.check_connec_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();"
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
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_intersection();"
            self.controller.execute_sql(sql)
        if self.dlg.check_inverted_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_inverted();"
            self.controller.execute_sql(sql)

        # Builder
        if self.dlg.check_create_nodes_from_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_built_nodefromarc();"
            self.controller.execute_sql(sql)

        # Repair
        if self.dlg.check_arc_searchnodes.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_repair_arc_searchnodes();"
            self.controller.execute_sql(sql)

        # Close the dialog
        self.close_dialog()

        # Refresh map canvas
        self.refresh_map_canvas()
        
        
    def utils_giswater_jar(self):
        """ Button 36: Open giswater.jar with selected .gsw file """ 
        
        self.controller.log_info("utils_giswater_jar")   

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("go2epa_giswater_jar", 36)
        else:
            self.controller.show_info("Function not supported in this Operating System")               


    def utils_config(self):
        """ Button 99: Config utils """
            
        # Create the dialog and signals
        self.dlg_config_utils = ConfigUtils()
        utils_giswater.setDialog(self.dlg_config_utils)
        self.load_settings(self.dlg_config_utils)

        self.dlg_config_utils.btn_accept.pressed.connect(self.utils_config_accept)
        self.dlg_config_utils.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_config_utils))
        self.dlg_config_utils.rejected.connect(partial(self.save_settings, self.dlg_config_utils))

        # Set values from widgets of type QComboBox and dates
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

        # sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        # sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'builtdate_vdefault'"
        # row = self.controller.get_row(sql)
        # if row is not None:
        #     date_value = datetime.strptime(row[0], '%Y-%m-%d')
        # else:
        #     date_value = QDate.currentDate()
        # utils_giswater.setCalendarDate("builtdate_vdefault", date_value)

        # sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        # sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'enddate_vdefault'"
        # row = self.controller.get_row(sql)
        # if row is not None:
        #     date_value = datetime.strptime(row[0], '%Y-%m-%d')
        # else:
        #     date_value = QDate.currentDate()
        # utils_giswater.setCalendarDate("enddate_vdefault", date_value)
        #
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
        # sql = ("SELECT name FROM " + self.schema_name + ".dma ORDER BY name")
        # rows = self.controller.get_row(sql)
        # utils_giswater.fillComboBox("dma_vdefault", rows, False)
        # sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
        #                                                  " WHERE cur_user = current_user AND parameter = 'virtual_layer_polygon'")
        # rows = self.controller.get_row(sql)
        # utils_giswater.setText(self.dlg_config_utils.virtual_layer_polygon, rows, False)
        # sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
        #                                                  " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")
        # rows = self.controller.get_row(sql)
        # utils_giswater.setText(self.dlg_config_utils.virtual_layer_point, rows, False)
        # sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
        #                                                  " WHERE cur_user = current_user AND parameter = 'virtual_layer_line'")
        # rows = self.controller.get_row(sql)
        # utils_giswater.setText(self.dlg_config_utils.virtual_layer_line, rows, False)
        #
        # # WS
        # sql = "SELECT id FROM " + self.schema_name + ".cat_presszone ORDER BY id"
        # rows = self.controller.get_rows(sql)
        # utils_giswater.fillComboBox("presszone_vdefault", rows, False)
        # self.populate_combo_ws(self.dlg_config_utils.wtpcat_vdefault, "ETAP")
        # self.populate_combo_ws("hydrantcat_vdefault", "HYDRANT")
        # self.populate_combo_ws("filtercat_vdefault", "FILTER")
        # self.populate_combo_ws("pumpcat_vdefault", "PUMP")
        # self.populate_combo_ws("waterwellcat_vdefault", "WATERWELL")
        # self.populate_combo_ws("metercat_vdefault", "METER")
        # self.populate_combo_ws("tankcat_vdefault", "TANK")
        # self.populate_combo_ws("manholecat_vdefault", "MANHOLE")
        # self.populate_combo_ws("valvecat_vdefault", "VALVE")
        # self.populate_combo_ws("registercat_vdefault", "REGISTER")
        # self.populate_combo_ws("sourcecat_vdefault", "SOURCE")
        # self.populate_combo_ws("junctioncat_vdefault", "JUNCTION")
        # self.populate_combo_ws("expansiontankcat_vdefault", "EXPANSIONTANK")
        # self.populate_combo_ws("netwjoincat_vdefault", "NETWJOIN")
        # self.populate_combo_ws("reductioncat_vdefault", "REDUCTION")
        # self.populate_combo_ws("netelementcat_vdefault", "NETELEMENT")
        # self.populate_combo_ws("netsamplepointcat_vdefault", "NETSAMPLEPOINT")
        # self.populate_combo_ws("flexunioncat_vdefault", "FLEXUNION")

        # # UD
        sql = "SELECT id FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".arc_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".connec_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        # # Set current values
        # sql = ("SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        #                                                             " WHERE cur_user = current_user")
        # rows = self.controller.get_rows(sql)
        # for row in rows:
        #     utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        #     utils_giswater.setChecked("chk_" + str(row[0]), True)
        #
        # # TODO: Parametrize it
        # self.utils_sql("name", "value_state", "id", "state_vdefault")
        # self.utils_sql("name", "exploitation", "expl_id", "exploitation_vdefault")
        # self.utils_sql("name", "ext_municipality", "muni_id", "municipality_vdefault")
        # self.utils_sql("id", "cat_soil", "id", "soilcat_vdefault")
        #
        # if self.project_type == 'ws':
        #     self.dlg_config_utils.config_tab_vdefault.removeTab(2)
        #     # self.dlg_config_utils.tab_config.removeTab(1)
        # elif self.project_type == 'ud':
        #     self.dlg_config_utils.config_tab_vdefault.removeTab(1)

        self.dlg_config_utils.exec_()
        
    
    def utils_config_accept(self):

        # TODO: Parametrize it. Loop through all widgets
        if utils_giswater.isChecked("chk_state_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.state_vdefault, "state_vdefault", "config_param_user")
        else:
            self.delete_row("state_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_statetype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.statetype_vdefault, "statetype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("statetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_workcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.workcat_vdefault, "workcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("workcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_verified_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.verified_vdefault, "verified_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("verified_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_builtdate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.builtdate_vdefault, "builtdate_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("builtdate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_enddate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.enddate_vdefault, "enddate_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("enddate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arccat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.arccat_vdefault, "arccat_vdefault", "config_param_user")
        else:
            self.delete_row("arccat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_nodecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.nodecat_vdefault, "nodecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("nodecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.connecat_vdefault, "connecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("connecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_elementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.elementcat_vdefault, "elementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("elementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_exploitation_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.exploitation_vdefault, "exploitation_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("exploitation_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_municipality_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.municipality_vdefault, "municipality_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("municipality_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sector_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.sector_vdefault, "sector_vdefault", "config_param_user")
        else:
            self.delete_row("sector_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pavementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.pavementcat_vdefault, "pavementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("pavementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_soilcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.soilcat_vdefault, "soilcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("soilcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_dma_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.dma_vdefault, "dma_vdefault", "config_param_user")
        else:
            self.delete_row("dma_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.visitcat_vdefault, "visitcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("visitcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_polygon"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.virtual_layer_polygon, "virtual_layer_polygon",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_polygon", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_point"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.virtual_layer_point, "virtual_layer_point",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_point", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_line"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.virtual_layer_line, "virtual_layer_line",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_line", "config_param_user")

        if utils_giswater.isChecked("chk_dim_tooltip"):
            self.insert_or_update_config_param_curuser("chk_dim_tooltip", "dim_tooltip", "config_param_user")
        else:
            self.delete_row("dim_tooltip", "config_param_user")

        # WS

        if utils_giswater.isChecked("chk_presszone_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.presszone_vdefault, "presszone_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("presszone_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_wtpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.wtpcat_vdefault, "wtpcat_vdefault", "config_param_user")
        else:
            self.delete_row("wtpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netsamplepointcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.netsamplepointcat_vdefault,
                                                       "netsamplepointcat_vdefault", "config_param_user")
        else:
            self.delete_row("netsamplepointcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netelementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.netelementcat_vdefault, "netelementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("netelementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_flexunioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.flexunioncat_vdefault, "flexunioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("flexunioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_tankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.tankcat_vdefault, "tankcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("tankcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_hydrantcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.hydrantcat_vdefault, "hydrantcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("hydrantcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_junctioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.junctioncat_vdefault, "junctioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("junctioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pumpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.pumpcat_vdefault, "pumpcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("pumpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_reductioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.reductioncat_vdefault, "reductioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("reductioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_valvecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.valvecat_vdefault, "valvecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("valvecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_manholecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.manholecat_vdefault, "manholecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("manholecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_metercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.metercat_vdefault, "metercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("metercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sourcecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.sourcecat_vdefault, "sourcecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("sourcecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_waterwellcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.waterwellcat_vdefault, "waterwellcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("waterwellcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_filtercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.filtercat_vdefault, "filtercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("filtercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_registercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.registercat_vdefault, "registercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("registercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netwjoincat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.netwjoincat_vdefault, "netwjoincat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("netwjoincat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_expansiontankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.expansiontankcat_vdefault, "expansiontankcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("expansiontankcat_vdefault", "config_param_user")
        # UD
        if utils_giswater.isChecked("chk_nodetype_vdefault"):
            sql = "SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
            sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'exploitation_vdefault')::text"
            row = self.controller.get_row(sql)
            if row:
                utils_giswater.setWidgetText("exploitation_vdefault", str(row[0]))
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.nodetype_vdefault, "nodetype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("nodetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arctype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.arctype_vdefault, "arctype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("arctype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connectype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg_config_utils.connectype_vdefault, "connectype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("connectype_vdefault", "config_param_user")

        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_config_utils)


    def utils_info(self):
        """ Button 100: Utils info """
                
        self.controller.log_info("utils_info")          


    def utils_import_csv(self):
        """ Button 83: Import CSV """
                
        self.controller.log_info("utils_import_csv")

    def populate_combo(self, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = ("SELECT " + field_name + ""
                                        " FROM " + self.schema_name + "." + table_name + " ORDER BY " + field_name)
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows, False)
        if len(rows) > 0:
            utils_giswater.setCurrentIndex(widget, 1)

    def populate_combo_ws(self, widget, node_type):

        sql = ("SELECT cat_node.id FROM " + self.schema_name + ".cat_node"
                                                               " INNER JOIN " + self.schema_name + ".node_type ON cat_node.nodetype_id = node_type.id"
                                                                                                   " WHERE node_type.type = '" + type + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows, False)

    def utils_sql(self, sel, table, atribute, value):

        sql = ("SELECT " + sel + " FROM " + self.schema_name + "." + table + " WHERE " + atribute + "::text = "
                                                                                                    "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = '" + value + "')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(value, str(row[0]))
