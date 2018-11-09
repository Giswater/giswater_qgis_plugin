/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- init
-------------
INSERT INTO audit_cat_table VALUES ('doc_x_psector', 'doc', 'Doc psector', 'role_basic', 0, NULL, NULL, 0, NULL,'doc_x_psector_id_seq', 'id');
INSERT INTO audit_cat_table VALUES ('ext_rtc_hydrometer_state', 'ext', 'hydrometers state catalog', 'role_basic', 0, NULL, NULL, 0, NULL,'ext_rtc_hydrometer_state_id_seq', 'id');
INSERT INTO ext_rtc_hydrometer_state VALUES (0, 'STATE0');
INSERT INTO ext_rtc_hydrometer_state VALUES (1, 'STATE1');
INSERT INTO ext_rtc_hydrometer_state VALUES (2, 'STATE2');
INSERT INTO ext_rtc_hydrometer_state VALUES (3, 'STATE3');
INSERT INTO ext_rtc_hydrometer_state VALUES (4, 'STATE4');
INSERT INTO audit_cat_table VALUES ('selector_hydrometer', 'System', 'Selector of hydrometers', 'role_basic', 0, NULL, NULL, 0, NULL,'selector_hydrometer_id_seq', 'id');
INSERT INTO config_param_system VALUES (160, 'basic_search_hyd_hydro_layer_name', 'v_rtc_hydrometer', 'varchar', 'searchplus', 'layer name');
INSERT INTO config_param_system VALUES (161, 'basic_search_hyd_hydro_field_expl_name', 'expl_name', 'varchar', 'searchplus', 'field exploitation.name');
INSERT INTO config_param_system VALUES (162, 'basic_search_hyd_hydro_field_cc', 'connec_id', 'text', 'searchplus', 'field connec.code');
INSERT INTO config_param_system VALUES (163, 'basic_search_hyd_hydro_field_erhc', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (164, 'basic_search_hyd_hydro_field_ccc', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (166, 'basic_search_hyd_hydro_field_1', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (167, 'basic_search_hyd_hydro_field_2', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (168, 'basic_search_hyd_hydro_field_3', 'state', 'text', 'searchplus', 'field value_state.name');
INSERT INTO config_param_system VALUES (169, 'basic_search_workcat_filter', 'code', 'text', 'searchplus', NULL);
INSERT INTO config_param_system VALUES (170, 'om_mincut_use_pgrouting', 'TRUE', 'boolean', 'mincut', NULL);
INSERT INTO sys_fprocess_cat VALUES (28, 'Massive downgrade features', 'Edit', 'Massive downgrade features', 'utils');
INSERT INTO sys_fprocess_cat VALUES (29, 'Mincut pipe hazard analysis', 'OM', 'Massive network hazard analysis', 'ws');

--28/05/2018
-----------------------
INSERT INTO config_param_system VALUES (184, 'ymax_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (183, 'top_elev_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (185, 'sys_elev_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (186, 'geom1_vd', '0.4', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (187, 'z1_vd', '0.1', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (188, 'z2_vd', '0.1', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (189, 'cat_geom1_vd', '1', 'decimal', 'draw_profile', 'For Node Catalog. Only for UD');
INSERT INTO config_param_system VALUES (190, 'sys_elev1_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (191, 'sys_elev2_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (192, 'y1_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (193, 'y2_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (194, 'slope_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');

--29/05/2018
-----------------------
INSERT INTO config_param_system VALUES (195, 'om_mincut_disable_check_temporary_overlap', 'FALSE', 'Boolean', 'Mincut', 'Only for WS');
INSERT INTO config_param_system VALUES (196, 'om_mincut_valve2tank_traceability', 'FALSE', 'Boolean', 'Mincut', 'Only for WS');
INSERT INTO sys_fprocess_cat VALUES (30, 'Analysis mincut areas', 'OM', 'Analysis mincut areas', 'ws');

--1/06/2018
-----------------------
INSERT INTO audit_cat_param_user VALUES ('edit_connect_force_downgrade_linkvnode', null, null, 'role_edit');
INSERT INTO audit_cat_param_user VALUES ('edit_connect_force_automatic_connect2network', null, null, 'role_edit');
INSERT INTO config_param_user VALUES (110, 'edit_connect_force_downgrade_linkvnode', 'TRUE', 'postgres');
INSERT INTO config_param_user VALUES (111, 'edit_connect_force_automatic_connect2network', 'TRUE', 'postgres');

--04/06/2018
-----------------------
INSERT INTO audit_cat_param_user VALUES ('cf_keep_opened_edition', null, null, 'role_edit');
INSERT INTO config_param_user VALUES (112, 'cf_keep_opened_edition', 'TRUE', 'postgres');
INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxcircle', 'CAD layer', 'Layer to store circle geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxpoint', 'CAD layer', 'Layer to store point geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL); 

--05/06/2018
-----------------------
INSERT INTO sys_fprocess_cat VALUES (31, 'Mincut conlfict scenario result', 'OM', 'Mincut conlfict scenario result', 'ws');
INSERT INTO audit_cat_param_user VALUES ('edit_noderotation_update_dissbl', null, null, 'role_edit');
INSERT INTO config_param_user VALUES (113, 'edit_noderotation_update_dissbl', 'FALSE', 'postgres');
UPDATE audit_cat_table SET sys_sequence='om_psector_id_seq' WHERE id='om_psector';
UPDATE audit_cat_table SET sys_sequence='plan_psector_id_seq' WHERE id='plan_psector';
INSERT INTO sys_fprocess_cat VALUES (32, 'Node proximity analysis', 'EDIT', 'Node proximity analysis', 'utils');

--23/08/2018
--------------------
INSERT INTO audit_cat_error values('3010','The minimum arc length of this exportation is: ', 'This length is less than nod2arc parameter. You need to update config.node2arc parameter to value less than it.',2,TRUE,'utils');

--29/08/2018
--------------------
INSERT INTO config_param_system VALUES (198, 'edit_topocontrol_dsbl_error', 'FALSE', 'Boolean', 'Edit', 'Utils');
INSERT INTO config_param_system VALUES (202, 'edit_node_reduction_auto_d1d2', 'FALSE', 'Boolean', 'Edit', 'Only for WS');

--30/08/2018
--------------------
INSERT INTO audit_cat_function VALUES (2496, 'gw_fct_arc_repair', 'edit', NULL, 'p_arc_id', 'Massive repair function. All the arcs that are not connected with extremal node will be reconected using the parameter arc_searchnodes', NULL, NULL, NULL);
INSERT INTO config_param_system VALUES (203, 'ext_utils_schema', NULL, 'Text', NULL, NULL);
