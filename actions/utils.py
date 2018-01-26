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
from PyQt4.QtGui import QDateEdit

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
        self.dlg = ConfigUtils()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)

        self.dlg.btn_accept.pressed.connect(self.utils_config_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))

        # Set values from widgets of type QComboBox and dates
        #Edit
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
        #
        # # WS
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
        sql = ("SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
                                                                    " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_" + str(row[0]), True)
        #
        # # TODO: Parametrize it
        self.utils_sql("name", "value_state", "id", "state_vdefault")
        self.utils_sql("name", "exploitation", "expl_id", "exploitation_vdefault")
        self.utils_sql("name", "ext_municipality", "muni_id", "municipality_vdefault")
        self.utils_sql("id", "cat_soil", "id", "soilcat_vdefault")

        if self.project_type == 'ws':
            self.dlg.config_tab_vdefault.removeTab(2)
            # self.dlg.tab_config.removeTab(1)
        elif self.project_type == 'ud':
            self.dlg.config_tab_vdefault.removeTab(1)

        #MasterPlan

        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)
        sql = "SELECT scale FROM" + self.schema_name + ".plan_psector ORDER BY scale"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_scale_vdefault", rows)
        sql = "SELECT rotation FROM" + self.schema_name + ".plan_psector ORDER BY rotation"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_rotation_vdefault", rows)
        sql = "SELECT gexpenses FROM" + self.schema_name + ".plan_psector ORDER BY gexpenses"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_gexpenses_vdefault", rows)
        sql = "SELECT vat FROM" + self.schema_name + ".plan_psector ORDER BY vat"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vat_vdefault", rows)
        sql = "SELECT other FROM" + self.schema_name + ".plan_psector ORDER BY other"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_other_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_scale_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_scale_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_rotation_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_rotation_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_gexpenses_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_gexpenses_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_vat_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_vat_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_other_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_other_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))

        #Om
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
            self.insert_or_update_config_param_curuser(self.dlg.state_vdefault, "state_vdefault", "config_param_user")
        else:
            self.delete_row("state_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_statetype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.statetype_vdefault, "statetype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("statetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_workcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.workcat_vdefault, "workcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("workcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_verified_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.verified_vdefault, "verified_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("verified_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_builtdate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.builtdate_vdefault, "builtdate_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("builtdate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_enddate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.enddate_vdefault, "enddate_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("enddate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arccat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.arccat_vdefault, "arccat_vdefault", "config_param_user")
        else:
            self.delete_row("arccat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_nodecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.nodecat_vdefault, "nodecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("nodecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.connecat_vdefault, "connecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("connecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_elementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.elementcat_vdefault, "elementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("elementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_exploitation_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.exploitation_vdefault, "exploitation_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("exploitation_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_municipality_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.municipality_vdefault, "municipality_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("municipality_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sector_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.sector_vdefault, "sector_vdefault", "config_param_user")
        else:
            self.delete_row("sector_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pavementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.pavementcat_vdefault, "pavementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("pavementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_soilcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.soilcat_vdefault, "soilcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("soilcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_dma_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.dma_vdefault, "dma_vdefault", "config_param_user")
        else:
            self.delete_row("dma_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.visitcat_vdefault, "visitcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("visitcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_polygon"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_polygon, "virtual_layer_polygon",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_polygon", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_point"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_point, "virtual_layer_point",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_point", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_line"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_line, "virtual_layer_line",
                                                       "config_param_user")
        else:
            self.delete_row("virtual_layer_line", "config_param_user")

        if utils_giswater.isChecked("chk_dim_tooltip"):
            self.insert_or_update_config_param_curuser("chk_dim_tooltip", "dim_tooltip", "config_param_user")
        else:
            self.delete_row("dim_tooltip", "config_param_user")

        # WS

        if utils_giswater.isChecked("chk_presszone_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.presszone_vdefault, "presszone_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("presszone_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_wtpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.wtpcat_vdefault, "wtpcat_vdefault", "config_param_user")
        else:
            self.delete_row("wtpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netsamplepointcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.netsamplepointcat_vdefault,
                                                       "netsamplepointcat_vdefault", "config_param_user")
        else:
            self.delete_row("netsamplepointcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netelementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.netelementcat_vdefault, "netelementcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("netelementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_flexunioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.flexunioncat_vdefault, "flexunioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("flexunioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_tankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.tankcat_vdefault, "tankcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("tankcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_hydrantcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.hydrantcat_vdefault, "hydrantcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("hydrantcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_junctioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.junctioncat_vdefault, "junctioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("junctioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pumpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.pumpcat_vdefault, "pumpcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("pumpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_reductioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.reductioncat_vdefault, "reductioncat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("reductioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_valvecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.valvecat_vdefault, "valvecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("valvecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_manholecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.manholecat_vdefault, "manholecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("manholecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_metercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.metercat_vdefault, "metercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("metercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sourcecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.sourcecat_vdefault, "sourcecat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("sourcecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_waterwellcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.waterwellcat_vdefault, "waterwellcat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("waterwellcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_filtercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.filtercat_vdefault, "filtercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("filtercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_registercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.registercat_vdefault, "registercat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("registercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netwjoincat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.netwjoincat_vdefault, "netwjoincat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("netwjoincat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_expansiontankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.expansiontankcat_vdefault, "expansiontankcat_vdefault",
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
            self.insert_or_update_config_param_curuser(self.dlg.nodetype_vdefault, "nodetype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("nodetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arctype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.arctype_vdefault, "arctype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("arctype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connectype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.connectype_vdefault, "connectype_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("connectype_vdefault", "config_param_user")

        #MasterPlan
        if utils_giswater.isChecked("chk_psector_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_vdefault, "psector_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("psector_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_scale_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_scale_vdefault, "psector_scale_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("psector_scale_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_rotation_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_rotation_vdefault, "psector_rotation_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("psector_rotation_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_gexpenses_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_gexpenses_vdefault,
                                                       "psector_gexpenses_vdefault", "config_param_user")
        else:
            self.delete_row("psector_gexpenses_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_vat_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_vat_vdefault, "psector_vat_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("psector_vat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_other_vdefault"):
            self.insert_or_update_config_param_curuser_master(self.dlg.psector_other_vdefault, "psector_other_vdefault",
                                                       "config_param_user")
        else:
            self.delete_row("psector_other_vdefault", "config_param_user")
        #


        #OM
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.visitcat_vdefault, "visitcat_vdefault", "config_param_user")
        else:
            self.delete_row("visitcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_om_param_type_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.om_param_type_vdefault, "om_param_type_vdefault", "config_param_user")
        else:
            self.delete_row("om_param_type_vdefault", "config_param_user")

        # Update tables 'confog' and 'config_param_system'
        # self.update_config("config", self.dlg)
        # self.update_config_param_system("config_param_system")
        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg)


    def utils_info(self):
        """ Button 100: Utils info """
                
        self.controller.log_info("utils_info")          


    def utils_import_csv(self):
        """ Button 83: Import CSV """
                
        self.controller.log_info("utils_import_csv")


    def populate_combo_ws(self, widget, type):
        sql = ("SELECT cat_node.id FROM " + self.schema_name + ".cat_node"
               " INNER JOIN " + self.schema_name + ".node_type ON cat_node.nodetype_id = node_type.id"
               " WHERE node_type.type = '" + type + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows,False)

    def utils_sql(self, sel, table, atribute, value):

        sql = ("SELECT " + sel + " FROM " + self.schema_name + "." + table + " WHERE " + atribute + "::text = "
                                                                                                    "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = '" + value + "')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(value, str(row[0]))
    def insert_or_update_config_param_curuser_master(self, widget, parameter, tablename):
        """ Insert or update values in tables with current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user'
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
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "'), current_user)"
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

    def insert_or_update_config_param_curuser(self, widget, parameter, tablename):
        """ Insert or update value of @parameter in @tablename with current_user control """

        sql = ("SELECT parameter FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user AND parameter = '" + str(parameter) + "'")
        exist_param = self.controller.get_row(sql)

        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value = "
                    if widget.objectName() == 'state_vdefault':
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += "(SELECT expl_id FROM " + self.schema_name + ".exploitation WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'exploitation_vdefault' "
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += "(SELECT muni_id FROM " + self.schema_name + ".ext_municipality WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'municipality_vdefault' "
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += "(SELECT id FROM " + self.schema_name + ".om_visit_cat WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'visitcat_vdefault' "
                    else:
                        sql += "'" + str(utils_giswater.getWidgetText(widget)) + "' WHERE parameter = '" + parameter + "'"
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() == 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT expl_id FROM " + self.schema_name + ".exploitation WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT muni_id FROM " + self.schema_name + ".ext_municipality WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".om_visit_cat WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', '" + str(utils_giswater.getWidgetText(widget)) + "', current_user)"
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

    def delete_row(self,  parameter, tablename):
        sql = 'DELETE FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user and parameter = ' + "'" + parameter + "'"
        self.controller.execute_sql(sql)

    def update_config(self, tablename, dialog):
        """ Update table @tablename from values get from @dialog """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            if column_name != 'id':
                columns.append(column_name)

        if columns is None:
            return

        sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
        for column_name in columns:
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

            if value is not None:
                if value == 'null':
                    sql += column_name + " = null, "
                else:
                    if type(value) is not bool and widget_type is not QSpinBox:
                        value = value.replace(",", ".")
                    sql += column_name + " = '" + str(value) + "', "

        sql = sql[:- 2]
        self.controller.execute_sql(sql)

    def update_config_param_system(self, tablename):
        """ Update table @tablename """

        # Get all parameters from dictionary object
        for config in self.config_dict.itervalues():
            value = utils_giswater.getWidgetText(str(config.parameter))
            if value is not None:
                value = value.replace('null', '')
                sql = "UPDATE " + self.schema_name + "." + tablename
                sql += " SET value = '" + str(value) + "'"
                sql += " WHERE parameter = '" + str(config.parameter) + "';"
                self.controller.execute_sql(sql)