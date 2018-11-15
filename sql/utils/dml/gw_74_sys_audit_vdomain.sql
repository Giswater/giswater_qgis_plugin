/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- Parametrize functions and function triggers
INSERT INTO audit_cat_function VALUES (2102, 'gw_fct_anl_arc_no_startend_node', 'Review analisys', 'cur_user, expl_id, context', 'arc, node', 'Check topology assistant. To review how many arcs donâ€™t have start or end nodes', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2104, 'gw_fct_anl_arc_same_startend', 'Review analisys', 'cur_user, expl_id, context', 'arc, node', 'Check topology assistant. To review how many arcs have the same node as node1 and node2', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2106, 'gw_fct_anl_connec_duplicated', 'Review analisys', 'cur_user, expl_id, context', 'connec', 'Check topology assistant. To review how many connecs are duplicated (using the parameter connec duplicated tolerance)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2108, 'gw_fct_anl_node_duplicated', 'Review analisys', 'cur_user, expl_id, context', 'node', 'Check topology assistant. To review how many nodes are duplicated (using the parameter node duplicated tolerance)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2110, 'gw_fct_anl_node_orphan', 'Review analisys', 'cur_user, expl_id, context', 'node', 'Check topology assistant. To review how many nodes are disconnected of the network', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2112, 'gw_fct_arc_fusion', 'Network editor', NULL, 'node, arc', 'Used to fusion two arcs in a unique new one, downgrading the node in case of itâ€™s possible to o it', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2114, 'gw_fct_arc_divide', 'Network editor', NULL, 'node, arc', 'Used to divide one arc into two news', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2116, 'gw_fct_audit_function', 'System', NULL, NULL, 'To audit all what itâ€™s happening wiht functions', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2118, 'gw_fct_built_nodefromarc', 'Network builder ', NULL, 'v_edit_node, v_edit_arc', 'Massive builder assistant. Built as many nodes as network need to achieve the topologic rules. To do this, all nodes are inserted using the default values of user (catalog, state...)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2120, 'gw_fct_check_delete', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2122, 'gw_fct_clone_schema', 'System', NULL, NULL, 'To clone schema', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2124, 'gw_fct_connec_to_network', 'Network editor', NULL, 'connec,  gully,  v_edit_arc', 'Massive builder assistant. This function built as many link/vnodes as user connec/gully selects', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2126, 'gw_fct_node_replace', 'Network editor', NULL, NULL, 'Replace one node on service for another one, copying all attributes, setting old one on obsolete and reconnecting arcs to the new node', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2128, 'gw_fct_plan_estimate_result', 'Masterplan', NULL, 'v_edit_node, v_edit_arc', 'Used to insert economic results from calculations on the plan_result_table', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2130, 'gw_state_control', 'System', NULL, 'arc,node, connec, gully', 'To control permisions of users to manage with state=2 and check inconsistency of state updates for arc / nodes, dissabling the update to state=0 if there are arcs (for node) and connecs (for arcs) with state 1 or 2', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2132, 'gw_state_searchnodes', 'System', NULL, 'v_edit_arc, v_edit_node', 'To check extreme nodes from arcs acording the tolerance parameter defined by user (arc_searchnodes) and the state topologic rules', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2302, 'gw_fct_anl_node_topological_consistency', 'Review analisys', NULL, 'node, node_type', 'Check topology assistant. Helps user  to identify nodes with more /less arcs that must be connected in function of the num_arcs field (node_type table)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2304, 'gw_fct_mincut', 'Mincut analysis', NULL, 'v_edit_node, v_edit_arc', 'This function proposes what valves must be closed in a mincut operation', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2306, 'gw_fct_mincut_engine', 'Mincut analysis', NULL, NULL, 'Recursive function of mincut', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2308, 'gw_fct_mincut_flowtrace', 'Mincut analysis', NULL, NULL, 'This function calculates what is the area afected for the mincut valve status', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2310, 'gw_fct_mincut_flowtrace_engine', 'Mincut analysis', NULL, NULL, 'Recursive function of mincut', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2312, 'gw_fct_mincut_valve_unaccess', 'Mincut analysis', NULL, NULL, 'Insert into anl_mincut_result_valve_unaccess valve non accessibles on a specific mincut.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2314, 'gw_fct_pg2epa', 'Hyd. analysis', NULL, 'v_inp_node, v_inp_arc', 'This function starts the exportation process to inp file', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2316, 'gw_fct_pg2epa_nod2arc', 'Hyd. analysis', NULL, 'rpt_inpt_node, rpt_inp_arc', 'This functions transform node to arcs (in case of valve nodes and pump nodes). ', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2236, 'ud_gw_fct_pg2epa_join_virtual', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2238, 'ud_gw_fct_pg2epa_nod2arc_data', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2318, 'gw_fct_pg2epa_pump_additional', 'Hyd. analysis', NULL, NULL, 'This function creates new flow lines for the same pump station as pump as user have been defined on the table inp_pump_additional.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2320, 'gw_fct_repair_arc_searchnodes', 'Network repair', 'cur_user, expl_id', 'arc, node', 'Massive repair function. All the arcs that are not connected with extremal node will be reconected using the parameter arc_searchnodes (from config table)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2322, 'gw_fct_rpt2pg', 'Hyd. analysis', NULL, NULL, 'This function is called when the importation from rpt file is finished.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2202, 'gw_fct_anl_arc_intersection', 'Review analisys', NULL, 'arc, node', 'Check topology assistant.  Identifies intersections againts on the arc table', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2204, 'gw_fct_anl_arc_inverted', 'Review analisys', NULL, 'v_edit_arc', 'Check topology assistant. Identifies arcs that have the slope in a oposite sense that the direction', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2206, 'gw_fct_anl_node_exit_upper_intro', 'Review analisys', NULL, 'v_edit_node, v_edit_arc', 'Check topology assistant.  Identifies nodes that all the exit arcs are upper that all the entry arcs. ', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2208, 'gw_fct_anl_node_flowregulator', 'Review analisys', NULL, 'arc, node', 'Check topology assistant.  Identifies nodes with more than one exit arc', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2210, 'gw_fct_anl_node_sink', 'Review analisys', NULL, 'arc, node', 'Check topology assistant. Identifies nodes not disconnecteds without exit arcs.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2212, 'gw_fct_anl_node_topological_consistency', 'Review analisys', NULL, 'arc, node', 'Check topology assistant. Helps user  to identify nodes with more /less arcs that must be connected in function of the num_arcs field (node_type table)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2214, 'gw_fct_flow_exit', 'Flow analysis', 'cur_user, expl_id', 'v_edit_node, v_edit_arc', 'Analisys of the network identifying all arc and nodes downstream of the selected node.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2216, 'gw_fct_flow_exit_recursive', 'Flow analysis', NULL, 'v_edit_node, v_edit_arc', 'Recursive function of flow exit', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2218, 'gw_fct_flow_trace', 'Flow analysis', 'cur_user, expl_id', 'v_edit_node, v_edit_arc', 'Analisys of the network identifying all arc and nodes upstream of the selected node.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2220, 'gw_fct_flow_trace_recursive', 'Flow analysis', NULL, 'v_edit_node, v_edit_arc', 'Recursive function of flow trace', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2222, 'gw_fct_pg2epa', 'Hyd. analysis', NULL, 'v_node & v_arc_x_node', 'Starts the exportation process to inp file', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2224, 'gw_fct_pg2epa_nodarc', 'Hyd. analysis', NULL, 'rpt_inpt_node, rpt_inp_arc', 'Transform node to arcs (in case that flow regulator must be designed as a node)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2226, 'gw_fct_pg2epa_flowreg_additional', 'Hyd. analysis', NULL, NULL, 'Creates new flow regulator for the same node flow regulator (nodarc) as user have been defined on the tables enabled to do this (inp_flwreg-*)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2228, 'gw_fct_pg2epa_dump_subcath', 'Hyd. analysis', NULL, NULL, 'Exports the subcatchments in case user have been ckecked the checkbox on form of xportation', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2230, 'gw_fct_repair_arc_searchnodes', 'Network repair', 'cur_user, expl_id', 'arc, node', 'Massive repair function. All the arcs that are not connected with extremal node will be reconected using the parameter arc_searchnodes (from config table)', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2232, 'gw_fct_rpt2pg', 'Hyd. analysis', NULL, NULL, 'Called when the importation from rpt file is finished.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1102, 'gw_trg_arc_noderotation_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1104, 'gw_trg_arc_orphannode_delete', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1106, 'gw_trg_connec_proximity', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1108, 'gw_trg_connec_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1110, 'gw_trg_edit_dimensions', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1112, 'gw_trg_edit_dma', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1114, 'gw_trg_edit_element', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1116, 'gw_trg_edit_link', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1118, 'gw_trg_edit_om_visits', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1120, 'gw_trg_edit_plan_psector', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1122, 'gw_trg_edit_samplepoint', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1124, 'gw_trg_edit_sector', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1126, 'gw_trg_edit_vnode', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1128, 'gw_trg_man_addfields_control', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1130, 'gw_trg_plan_psector_x_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1132, 'gw_trg_review_audit_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1134, 'gw_trg_review_audit_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1136, 'gw_trg_topocontrol_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1138, 'gw_trg_ui_doc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1140, 'gw_trg_ui_element', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1142, 'gw_trg_vnode_proximity', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1144, 'gw_trg_vnode_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1302, 'ws_gw_trg_edit_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1304, 'ws_gw_trg_edit_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1306, 'ws_gw_trg_edit_inp_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1308, 'ws_gw_trg_edit_inp_demand', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1310, 'ws_gw_trg_edit_inp_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1312, 'ws_gw_trg_edit_macrodma', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1314, 'ws_gw_trg_edit_man_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1316, 'ws_gw_trg_edit_man_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1318, 'ws_gw_trg_edit_man_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1320, 'ws_gw_trg_edit_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1322, 'ws_gw_trg_edit_review_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1324, 'ws_gw_trg_edit_review_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1326, 'ws_gw_trg_edit_review_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1328, 'ws_gw_trg_edit_rtc_hydro_data', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1330, 'ws_gw_trg_edit_unconnected', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1332, 'ws_gw_trg_man_addfields_control', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1334, 'ws_gw_trg_node_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1336, 'ws_gw_trg_review_audit_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1338, 'ws_gw_trg_review_audit_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1340, 'ws_gw_trg_review_audit_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1342, 'ws_gw_trg_rtc_hydrometer', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1344, 'ws_gw_trg_topocontrol_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1202, 'ud_gw_trg_edit_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1204, 'ud_gw_trg_edit_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1206, 'ud_gw_trg_edit_gully', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1208, 'ud_gw_trg_edit_inp_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1210, 'ud_gw_trg_edit_inp_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1212, 'ud_gw_trg_edit_man_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1214, 'ud_gw_trg_edit_man_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1216, 'ud_gw_trg_edit_man_gully', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1218, 'ud_gw_trg_edit_man_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1220, 'ud_gw_trg_edit_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1222, 'ud_gw_trg_edit_raingage', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1224, 'ud_gw_trg_edit_review_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1226, 'ud_gw_trg_edit_review_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1228, 'ud_gw_trg_edit_review_gully', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1230, 'ud_gw_trg_edit_review_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1232, 'ud_gw_trg_edit_subcatchment', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1234, 'ud_gw_trg_node_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1236, 'ud_gw_trg_review_audit_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1238, 'ud_gw_trg_review_audit_connec', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1240, 'ud_gw_trg_review_audit_gully', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1242, 'ud_gw_trg_review_audit_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1244, 'ud_gw_trg_topocontrol_arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1246, 'ud_trg_edit_macrosector', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1248, 'ud_trg_gully_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1250, 'ud_trg_man_addfields_control', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1146, 'gw_trg_node_arc_divide', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2324, 'ws_gw_fct_pg2epa_check', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2326, 'ws_gw_fct_pg2epa_dscenario', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2328, 'ws_gw_fct_pg2epa_fill_data', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2330, 'ws_gw_fct_pg2epa_rtc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2332, 'ws_gw_fct_pg2epa_valvestatus', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (1346, 'ws_gw_trg_arc_noderotation_update', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2234, 'ud_gw_fct_pg2epa_fill_data', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2240, 'ud_gw_fct_pg2epa_nod2arc_geom', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2242, 'gw_fct_cad_add_relative_point', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2244, 'gw_fct_mincut_result_overlap', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2400, 'gw_fct_mincut_inv_flowtrace', 'Mincut analysis', NULL, NULL, 'This function calculates the area afected by the mincut valve status', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2402, 'gw_fct_mincut_inv_flowtrace_engine', 'Mincut analysis', NULL, NULL, 'Recursive function of mincut', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2414, 'gw_fct_role_permissions', 'Role permissions', NULL, 'db_name_aux, schema_name_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2416, 'gw_trg_edit_man_gully_pol', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2418, 'gw_trg_edit_man_node_pol', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2420, 'gw_trg_flw_regulator', 'Flow analysis', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2422, 'gw_fct_audit_log_feature', 'Audit functions', NULL, 'enabled_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2424, 'gw_fct_audit_schema_check', 'Audit functions', NULL, 'foreign_schema', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2426, 'gw_fct_audit_schema_repair', 'Audit functions', NULL, 'schema_name_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2428, 'gw_fct_edit_element_multiplier', NULL, NULL, 'element_id_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2430, 'gw_fct_epa_audit_check_data', 'Audit functions', NULL, 'result_id', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2432, 'gw_fct_module_activate', NULL, NULL, 'module_id_var', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2434, 'gw_fct_om_visit_multiplier', NULL, NULL, 'visit_id_aux, feature_type_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2436, 'gw_fct_plan_audit_check_data', 'Audit functions', NULL, 'result_type_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2438, 'gw_fct_plan_psector_update_geom', NULL, NULL, 'psector_id_aux, point_aux, dim_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2440, 'gw_fct_utils_csv2pg', NULL, NULL, 'csv2pgcat_id_aux, label_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2442, 'gw_trg_node_arc_divide', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2444, 'gw_trg_audit_log_feature', 'Audit functions', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2446, 'gw_trg_edit_psector', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2448, 'gw_trg_edit_psector_x_other', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2450, 'gw_trg_psector_selector', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2452, 'gw_trg_selector_expl', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2454, 'gw_fct_edit_node_switch_arc_id', NULL, NULL, 'node_id_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2456, 'gw_fct_pg2epa_dscenario', NULL, NULL, 'result_id_var', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2458, 'gw_trg_edit_cat_node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2460, 'gw_trg_edit_man_connec_pol', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2462, 'gw_trg_edit_man_node_pol', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2464, 'gw_fct_node_replace', NULL, NULL, 'old_node_id_aux, function_aux, table_aux', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2466, 'gw_trg_edit_review_node', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2468, 'gw_trg_edit_review_audit_node', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2470, 'gw_trg_edit_review_arc', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2472, 'gw_trg_edit_review_audit_arc', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2474, 'gw_trg_edit_review_connec', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2476, 'gw_trg_edit_review_audit_connec', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2478, 'gw_trg_edit_review_gully', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2480, 'gw_trg_edit_review_audit_gully', 'Review UD', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2482, 'gw_trg_edit_review_node', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2484, 'gw_trg_edit_review_audit_node', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2486, 'gw_trg_edit_review_arc', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2488, 'gw_trg_edit_review_audit_arc', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2490, 'gw_trg_edit_review_connec', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2492, 'gw_trg_edit_review_audit_connec', 'Review WS', NULL, NULL, NULL, NULL, NULL, NULL);




-- -----------------------------
-- Records of sys_role
-- -----------------------------
INSERT INTO sys_role VALUES ('role_basic', 'basic', NULL);
INSERT INTO sys_role VALUES ('role_edit', 'edit', NULL);
INSERT INTO sys_role VALUES ('role_om', 'om', NULL);
INSERT INTO sys_role VALUES ('role_epa', 'epa', NULL);
INSERT INTO sys_role VALUES ('role_master', 'master', NULL);
INSERT INTO sys_role VALUES ('role_admin', 'admin', NULL);

-- -----------------------------
-- Records of sys_fprocess_cat
-- -----------------------------
INSERT INTO sys_fprocess_cat VALUES (1, 'Qgis project check', 'Audit project', 'Qgis project check', 'utils');
INSERT INTO sys_fprocess_cat VALUES (2, 'Schema data consistency', 'Audit project', 'Schema data consistency', 'utils');
INSERT INTO sys_fprocess_cat VALUES (3, 'Arc without start-end nodes', 'Topo analysis', 'Arc without start-end nodes', 'utils');
INSERT INTO sys_fprocess_cat VALUES (4, 'Arc with same start-end nodes', 'Topo analysis', 'Arc with same start-end nodes', 'utils');
INSERT INTO sys_fprocess_cat VALUES (5, 'Connec duplicated', 'Topo analysis', 'Connec duplicated', 'utils');
INSERT INTO sys_fprocess_cat VALUES (6, 'Node duplicated', 'Topo analysis', 'Node duplicated', 'utils');
INSERT INTO sys_fprocess_cat VALUES (7, 'Node orphan', 'Topo analysis', 'Node orphan', 'utils');
INSERT INTO sys_fprocess_cat VALUES (8, 'Node topological consistency', 'Topo analysis', 'Node topological consistency', 'utils');
INSERT INTO sys_fprocess_cat VALUES (9, 'Arc intersection', 'Topo analysis', 'Arc intersection', 'ud');
INSERT INTO sys_fprocess_cat VALUES (10, 'Arc inverted', 'Topo analysis', 'Arc inverted', 'ud');
INSERT INTO sys_fprocess_cat VALUES (11, 'Node exit upper intro', 'Topo analysis', 'Node exit upper intro', 'ud');
INSERT INTO sys_fprocess_cat VALUES (12, 'Node flow regulator', 'Topo analysis', 'Node flow regulator', 'ud');
INSERT INTO sys_fprocess_cat VALUES (13, 'Node sink', 'Topo analysis', 'Node sink', 'ud');
INSERT INTO sys_fprocess_cat VALUES (14, 'EPA audit data', 'Audit epa', 'EPA audit data', 'utils');
INSERT INTO sys_fprocess_cat VALUES (15, 'Null values affecting plan_result_rec calculation', 'Audit plan', 'Null values affecting plan_result calculation', 'utils');
INSERT INTO sys_fprocess_cat VALUES (16, 'Null values affecting plan_result_reh calculation', 'Audit plan', 'Null values affecting plan_result_reh calculation', 'ud');
INSERT INTO sys_fprocess_cat VALUES (17, 'Log updated or deleted features', 'Audit project', 'Log updated or deleted features', 'utils');
INSERT INTO sys_fprocess_cat VALUES (18, 'Repair arcs', 'Repair arcs', 'Log of arcs repaireds', 'ud');
INSERT INTO sys_fprocess_cat VALUES (19, 'Check user value defaults', 'Check', 'Log of inconsistent user value defaults', 'utils');
INSERT INTO sys_fprocess_cat VALUES (20, 'Check plan multi-sector arcs', 'Check', 'Log of more than one psector for individual arc', 'utils');
INSERT INTO sys_fprocess_cat VALUES (21, 'Check plan multi-sector node', 'Check', 'Log of more than one psector for individual node', 'utils');
INSERT INTO sys_fprocess_cat VALUES (22, 'Check v_edit_node duplicated nodes', 'Check', 'Node duplicated analysis on v_edit_node', 'utils');
INSERT INTO sys_fprocess_cat VALUES (23, 'Check v_edit_node orphan nodes', 'Check', 'Node orphan analysis on v_edit_node', 'utils');
INSERT INTO sys_fprocess_cat VALUES (24, 'Check v_edit_arc no start-end nodes', 'Check', 'Arc without start-end nodes on v_edit_arc table', 'utils');
INSERT INTO sys_fprocess_cat VALUES (25, 'Check mincut data', 'Check', 'Check mincut data', 'ws');
INSERT INTO sys_fprocess_cat VALUES (26, 'Check profile tool data ', 'Check', 'Check profile tool data ', 'ud');
INSERT INTO sys_fprocess_cat VALUES (27, 'Auxiliar cad points', 'Cad', 'Auxiliar cad points', 'utils');




