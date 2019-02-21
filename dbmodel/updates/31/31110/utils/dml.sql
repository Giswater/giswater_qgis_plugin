/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- update config param system
UPDATE config_param_system SET label='Gully units tolerance:' ,isenabled=TRUE,layout_id=15,layout_order=18 ,project_type='ud' ,datatype='integer' ,widgettype='linextext' WHERE parameter='rev_gully_units_tol';
UPDATE config_param_system SET label='Node geom 1 tolerance:' ,isenabled=TRUE,layout_id=15 ,layout_order=7 ,project_type='ud' ,datatype='double' ,widgettype='spinbox' WHERE parameter='rev_node_geom1_tol';
UPDATE config_param_system SET label='custom_giswater_folder:' ,isenabled=FALSE ,layout_id=NULL ,layout_order=NULL ,project_type=NULL , datatype='string' ,widgettype='linetext' WHERE parameter='custom_giswater_folder';

INSERT INTO sys_fprocess_cat VALUES (35, 'Recursive go2epa process', 'EPA', 'Recursive go2epa process', 'utils');
INSERT INTO sys_fprocess_cat VALUES (36, 'Drop fk', 'admin', 'Drop fk', 'utils');
INSERT INTO sys_fprocess_cat VALUES (37, 'Create fk', 'admin', 'Create fk', 'utils');


/*

REMIX
1)
UPDATE config_param_system SET         4, 'expl_layer', 'ext_municipality', 'varchar', 'searchplus', NULL, 'expl_layer:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
2)
label='' ,isenabled= ,layout_id= ,layout_order= ,project_type= , datatype= ,widgettype= WHERE parameter='';

1+2= EXAMPLE
UPDATE config_param_system SET label='expl_layer:' ,isenabled=false ,layout_id=false ,layout_order=false ,project_type=false , datatype='string' ,widgettype='linetext' WHERE parameter='expl_layer';


										   PARAMETER (1)												      LABEL(:)              ISENABLED(t/f), (1), LY_ID, LY_OD, PT, f,f, DATAYPE   WIDGETTYPE
UPDATE config_param_system SET         4, 'expl_layer', 'ext_municipality', 'varchar', 'searchplus', NULL, 'expl_layer:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         5, 'expl_field_code', 'muni_id', 'varchar', 'searchplus', NULL, 'expl_field_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         6, 'expl_field_name', 'name', 'varchar', 'searchplus', NULL, 'expl_field_name:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         8, 'network_layer_arc', 'v_edit_arc', 'varchar', 'searchplus', NULL, 'network_layer_arc:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         9, 'network_layer_connec', 'v_edit_connec', 'varchar', 'searchplus', NULL, 'network_layer_connec:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         10, 'network_layer_element', 'element', 'varchar', 'searchplus', NULL, 'network_layer_element:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         11, 'network_layer_gully', 'v_edit_gully', 'varchar', 'searchplus', NULL, 'network_layer_gully:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         12, 'network_layer_node', 'v_edit_node', 'varchar', 'searchplus', NULL, 'network_layer_node:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         13, 'network_field_arc_code', 'code', 'varchar', 'searchplus', NULL, 'network_field_arc_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         14, 'network_field_connec_code', 'code', 'varchar', 'searchplus', NULL, 'network_field_connec_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         15, 'network_field_element_code', 'code', 'varchar', 'searchplus', NULL, 'network_field_element_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         16, 'network_field_gully_code', 'code', 'varchar', 'searchplus', NULL, 'network_field_gully_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         17, 'network_field_node_code', 'code', 'varchar', 'searchplus', NULL, 'network_field_node_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         18, 'street_layer', 'v_ext_streetaxis', 'varchar', 'searchplus', NULL, 'street_layer:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         19, 'street_field_code', 'id', 'varchar', 'searchplus', NULL, 'street_field_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         20, 'street_field_name', 'name', 'varchar', 'searchplus', NULL, 'street_field_name:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         21, 'portal_layer', 'v_ext_address', 'varchar', 'searchplus', NULL, 'portal_layer:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         22, 'portal_field_code', 'streetaxis_id', 'varchar', 'searchplus', NULL, 'portal_field_code:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         23, 'portal_field_number', 'postnumber', 'varchar', 'searchplus', NULL, 'portal_field_number:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         24, 'portal_field_postal', 'postcode', 'varchar', 'searchplus', NULL, 'portal_field_postal:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         25, 'street_field_expl', 'muni_id', 'varchar', 'searchplus', NULL, 'street_field_expl:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         60, 'basic_search_hyd_hydro_layer_name', 'v_rtc_hydrometer', 'varchar', 'searchplus', 'layer name', 'basic_search_hyd_hydro_layer_name:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         61, 'basic_search_hyd_hydro_field_expl_name', 'expl_name', 'varchar', 'searchplus', 'field exploitation.name', 'basic_search_hyd_hydro_field_expl_name:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         68, 'basic_search_hyd_hydro_field_3', 'state', 'text', 'searchplus', 'field value_state.name', 'basic_search_hyd_hydro_field_3:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         69, 'basic_search_workcat_filter', 'code', 'text', 'searchplus', NULL, 'basic_search_workcat_filter:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         11114, 'gully_proximity', '0.5', NULL, NULL, NULL, 'gully_proximity:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         11115, 'gully_proximity_control', 'TRUE', NULL, NULL, NULL, 'gully_proximity_control:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         39, 'rev_node_ymax_tol', '0', 'float', 'review', 'Only for UD', 'Node Y max tolerance:', NULL, NULL, true, 1, 15, 6, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         92, 'arc_searchnodes', '9.0', NULL, NULL, NULL, 'Arc searchnodes buffer:', NULL, NULL, true, NULL, 13, 1, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         36, 'rev_arc_geom1_tol', '0', 'float', 'review', 'Only for UD', 'Arc geom 1 tolerance:', NULL, NULL, true, 1, 15, 3, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         48, 'rev_gully_sandbox_tol', '0', 'float', 'review', 'Only for UD', 'Gully sandbox tolerance:', NULL, NULL, true, 1, 15, 15, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         50, 'rev_gully_connec_geom2_tol', '0', 'float', 'review', 'Only for UD', 'Gully geom 2 tolerance:', NULL, NULL, true, 1, 15, 17, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         71, 'node_proximity', '4.0', 'double precision', NULL, NULL, 'Node proximity control:', NULL, NULL, true, 1, 13, 3, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         34, 'rev_arc_y1_tol', '0', 'float', 'review', 'Only for UD', 'Arc y1 tolerance:', NULL, NULL, true, 1, 15, 1, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         82, 'node_duplicated_tolerance', '0.001', 'double precision', NULL, NULL, 'Node duplicated tolerance:', NULL, NULL, true, 1, 16, 1, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         33, 'rev_node_depth_tol', '0', 'float', 'review', 'Only for WS', 'Node depth tolerance:', NULL, NULL, true, 1, 15, 3, 'ws', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         53, 'proximity_buffer', '50.0', 'double precision', NULL, NULL, 'Neighbourhood proximity buffer:', NULL, NULL, true, 1, 13, 10, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         49, 'rev_gully_connec_geom1_tol', '0', 'float', 'review', 'Only for UD', 'Gully geom 1 tolerance:', NULL, NULL, true, 1, 15, 16, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         83, 'connec_duplicated_tolerance', '0.001', 'double precision', NULL, NULL, 'Connec duplicated tolerance:', NULL, NULL, true, 1, 16, 2, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         47, 'rev_gully_ymax_tol', '0', 'float', 'review', 'Only for UD', 'Gully Y max tolerance:', NULL, NULL, true, 1, 15, 14, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         35, 'rev_arc_y2_tol', '0', 'float', 'review', 'Only for UD', 'Arc y2 tolerance:', NULL, NULL, true, 1, 15, 2, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         87, 'buffer_value', '3.0', 'double precision', NULL, NULL, 'Double geometry enabled:', NULL, NULL, true, 1, 13, 5, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         37, 'rev_arc_geom2_tol', '0', 'float', 'review', 'Only for UD', 'Arc geom 2 tolerance:', NULL, NULL, true, 1, 15, 4, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         38, 'rev_node_top_elev_tol', '0', 'float', 'review', 'Only for UD', 'Node top elev tolerance:', NULL, NULL, true, 1, 15, 5, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         52, 'link_searchbuffer', '3.0', 'boolean', 'topology', NULL, 'Link search buffer:', NULL, NULL, true, 1, 13, 9, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         74, 'connec_proximity', '1.0', 'double precision', NULL, NULL, 'Connec proximity control:', NULL, NULL, true, 1, 13, 4, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         41, 'rev_node_geom2_tol', '0', 'float', 'review', 'Only for UD', 'Node geom 2 tolerance:', NULL, NULL, true, 1, 15, 8, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         43, 'rev_connec_y2_tol', '0', 'float', 'review', 'Only for UD', 'Connec y2 tolerance:', NULL, NULL, true, 1, 15, 10, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         32, 'rev_node_elevation_tol', '2', 'float', 'review', 'Only for WS', 'Node elev tolerance:', NULL, NULL, true, 1, 15, 1, 'ws', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         45, 'rev_connec_geom2_tol', '0', 'float', 'review', 'Only for UD', 'Connec geom 2 tolerance:', NULL, NULL, true, 1, 15, 12, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         42, 'rev_connec_y1_tol', '0', 'float', 'review', 'Only for UD', 'Connec y1 tolerance:', NULL, NULL, true, 1, 15, 9, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         44, 'rev_connec_geom1_tol', '0', 'float', 'review', 'Only for UD', 'Connec geom 1 tolerance:', NULL, NULL, true, 1, 15, 11, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         46, 'rev_gully_top_elev_tol', '0', 'float', 'review', 'Only for UD', 'Gully top elev tolerance:', NULL, NULL, true, 1, 15, 13, 'ud', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         81, 'connec_proximity_control', 'true', 'boolean', NULL, NULL, 'Connec proximity control:', NULL, NULL, true, 1, 13, 4, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         86, 'insert_double_geometry', 'true', 'boolean', NULL, NULL, 'Double geometry enabled:', NULL, NULL, true, 1, 13, 5, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         76, 'orphannode_delete', 'true', 'boolean', NULL, NULL, 'Orphan node delete:', NULL, NULL, true, 1, 13, 6, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         75, 'nodeinsert_arcendpoint', 'true', 'boolean', NULL, NULL, 'Automatic insert arc end point:', NULL, NULL, true, 1, 13, 7, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         7, 'scale_zoom', '500', 'integer', 'searchplus', NULL, 'scale_zoom:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'integer', 'linetext', NULL);
UPDATE config_param_system SET         26, 'module_om_rehabit', 'TRUE', 'boolean', 'om', NULL, 'module_om_rehabit:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         27, 'state_topocontrol', 'true', 'boolean', 'topology', 'Only for WS', 'state_topocontrol:', NULL, NULL, true, 1, 13, 15, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         28, 'mincut_conflict_map', 'false', 'boolean', 'mincut', NULL, 'mincut_conflict_map:', NULL, NULL, true, 1, 17, 4, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         29, 'inventory_update_date', '2017-01-01', 'date', 'om', NULL, 'inventory_update_date:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'date', 'datepickertime', NULL);
UPDATE config_param_system SET         31, 'link_search_button', '0,1', 'float', 'edit', NULL, 'link_search_button:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         55, 'edit_enable_arc_nodes_update', 'true', 'boolean', 'edit', NULL, 'edit_enable_arc_nodes_update:', NULL, NULL, true, 1, 13, 14, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         56, 'hydrometer_link_absolute_path', '', 'text', 'rtc', NULL, 'hydrometer_link_absolute_path:', NULL, NULL, true, 1, 17, 3, 'utils', false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         62, 'basic_search_hyd_hydro_field_cc', 'connec_id', 'text', 'searchplus', 'field connec.code', 'basic_search_hyd_hydro_field_cc:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         63, 'basic_search_hyd_hydro_field_erhc', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code', 'basic_search_hyd_hydro_field_erhc:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         64, 'basic_search_hyd_hydro_field_ccc', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code', 'basic_search_hyd_hydro_field_ccc:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         66, 'basic_search_hyd_hydro_field_1', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code', 'basic_search_hyd_hydro_field_1:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         67, 'basic_search_hyd_hydro_field_2', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code', 'basic_search_hyd_hydro_field_2:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         70, 'om_mincut_use_pgrouting', NULL, 'boolean', 'mincut', NULL, 'om_mincut_use_pgrouting:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         73, 'node2arc', '0.5', 'double precision', NULL, NULL, 'Node Tolerance (arc divide):', NULL, NULL, true, 1, 13, 16, 'ws', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         77, 'vnode_update_tolerance', '0.5', 'double precision', NULL, NULL, 'vnode_update_tolerance:', NULL, NULL, true, 1, 13, 11, 'utils', false, false, 'double', 'spinbox', NULL);
UPDATE config_param_system SET         84, 'audit_function_control', 'TRUE', 'boolean', NULL, NULL, 'audit_function_control:', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         11113, 'api_canvasmargin', '{"mincanvasmargin":{"mts":5, "pixels":""}, "maxcanvasmargin":{"mts":50, "pixels":""}}', NULL, NULL, NULL, 'api_canvasmargin:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         11112, 'sys_currency', '{"id":"EUR", "descript":"EURO", "symbol":"€"}', NULL, NULL, NULL, 'sys_currency:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         30, 'geom_slp_direction', 'FALSE', 'boolean', 'topology', 'Ony for UD', 'Geometry direction as slope arc direction:', NULL, NULL, true, 1, 13, 16, 'ud', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         94, 'chk_state_topo', 'true', NULL, NULL, NULL, 'State topo control:', NULL, NULL, true, NULL, 13, 8, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         80, 'node_proximity_control', 'true', 'boolean', NULL, NULL, 'Node proximity control:', NULL, NULL, true, 1, 13, 3, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         93, 'samenode_init_end_control', 'true', NULL, NULL, NULL, 'Arc same node init end control:', NULL, NULL, true, NULL, 13, 2, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         85, 'arc_searchnodes_control', 'true', 'boolean', NULL, NULL, 'Arc searchnodes buffer:', NULL, NULL, true, 1, 13, 1, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         1, 'doc_absolute_path', '', 'varchar', 'path', NULL, 'doc_absolute_path:', NULL, NULL, true, 1, 17, 1, 'utils', false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         2, 'om_visit_absolute_path', 'c:/', 'varchar', 'path', NULL, 'om_visit_absolute_path:', NULL, NULL, true, 1, 17, 2, 'utils', false, false, 'string', 'linetext', NULL);
UPDATE config_param_system SET         54, 'edit_arc_divide_automatic_control', 'true', 'boolean', 'edit', NULL, 'edit_arc_divide_automatic_control:', NULL, NULL, true, 1, 13, 13, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         78, 'nodetype_change_enabled', 'true', 'boolean', NULL, NULL, 'nodetype_change_enabled:', NULL, NULL, true, 1, 13, 12, 'utils', false, false, 'boolean', 'check', NULL);
UPDATE config_param_system SET         95, 'api_search_arc', '{"sys_table_id":"ve_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}', NULL, 'api_search_network', '
', 'api_search_arc:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         90, 'ApiVersion', '0.9.101', NULL, NULL, NULL, 'ApiVersion:', NULL, NULL, false, NULL, NULL, NULL, NULL, false, false, NULL, NULL, NULL);
UPDATE config_param_system SET         88, 'api_sensibility_factor_mobile', '2', NULL, NULL, NULL, 'api_sensibility_factor_mobile:', NULL, NULL, false, NULL, NULL, NULL, NULL, false, false, NULL, NULL, NULL);
UPDATE config_param_system SET         89, 'api_sensibility_factor_web', '1', NULL, NULL, NULL, 'api_sensibility_factor_web:', NULL, NULL, false, NULL, NULL, NULL, NULL, false, false, NULL, NULL, NULL);
UPDATE config_param_system SET         96, 'api_search_node', '{"sys_table_id":"ve_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}', NULL, 'api_search_network', NULL, 'api_search_node:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         97, 'api_search_connec', '{"sys_table_id":"ve_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}', NULL, 'api_search_network', NULL, 'api_search_connec:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         98, 'api_search_element', '{"sys_table_id":"ve_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}', NULL, 'api_search_network', NULL, 'api_search_element:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         99, 'api_search_muni', '{"sys_table_id":"ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL, 'api_search_muni:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         100, 'api_search_street', '{"sys_table_id":"v_ext_streetaxis", "sys_id_field":"id", "sys_search_field":"name", "sys_parent_field":"muni_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL, 'api_search_street:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         101, 'api_search_postnumber', '{"sys_table_id":"v_ext_address", "sys_id_field":"id", "sys_search_field":"postnumber", "sys_parent_field":"streetaxis_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL, 'api_search_postnumber:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         102, 'api_search_workcat', '{"sys_table_id":"v_ui_workcat_polygon", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom", "filter_text":"code"}', NULL, 'apì_search_workcat', NULL, 'api_search_workcat:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         103, 'api_search_psector', '{"sys_table_id":"ve_plan_psector","WARNING":"sys_table_id only web, python is hardcoded: ve_plan_psector as self.plan_om =''plan''''", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL, 'api_search_psector:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         104, 'api_search_exploitation', '{"sys_table_id":"exploitation", "sys_id_field":"expl_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL, 'api_search_exploitation:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         105, 'api_search_hydrometer', '{"sys_table_id":"v_ui_hydrometer", "sys_id_field":"sys_hydrometer_id", "sys_connec_id":"sys_connec_id", "sys_search_field_1":"Hydro ccode:",  "sys_search_field_2":"Connec ccode:",  "sys_search_field_3":"State:", "sys_parent_field":"Exploitation:"}', NULL, 'apì_search_hydrometer', NULL, 'api_search_hydrometer:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         106, 'api_search_network_null', '{"sys_table_id":"", "sys_id_field":"", "sys_search_field":"", "alias":"", "cat_field":"", "orderby":"0"}', NULL, 'api_search_network', NULL, 'api_search_network_null:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         107, 'api_search_visit', '{"sys_table_id":"om_visit", "sys_id_field":"id", "sys_search_field":"id", "alias":"Visita", "cat_field":"visitcat_id", "orderby":"6", "feature_type":"visit"}', NULL, 'api_search_network', NULL, 'api_search_visit:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         108, 'api_search_visit_modificat', '{"sys_table_id":"om_visit", "sys_id_field":"id", "sys_search_field":"id", "sys_geom_field":"the_geom"}', NULL, 'api_search_visit', NULL, 'api_search_visit_modificat:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE config_param_system SET         11111, 'daily_update_mails', '{"mails": [{"mail":"info@bgeo.es"},{"mail":"info@giswater.org"}]}', 'json', 'daily_update_mails', 'Daily update mails', 'daily_update_mails:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
*/


/*
-- update config_param_user

1)
UPDATE audit_cat_param_user SET     WHERE parameter='verified_vdefault', 'config', NULL, 'role_edit', NULL, 'Verified:', 'SELECT id AS id, id as idval  FROM value_verified WHERE id IS NOT NULL', NULL, true, 8, 1, 'utils', false, NULL, 'verified', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
									
2)
label='' , dv_querytext=, dv_parent_id=, isenabled= , layout_id= ,layout_order= , project_type='' ,isparent= ,dv_querytext_filterc=NULL, feature_field_id=, feature_dv_parent_value=, isautoupdate=
, datatype='' , widgettype='' ismandatory= , widgetcontrols= , vdefault= , layout_name=, reg_exp=;


1+2= EXAMPLE
UPDATE audit_cat_param_user SET  label='Verified:', dv_querytext='SELECT id AS id, id as idval FROM value_verified WHERE id IS NOT NULL', dv_parent_id=NULL, isenabled=true , layout_id=8 ,layout_order=1 , 
project_type='utils' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='verified', feature_dv_parent_value=NULL, isautoupdate=false, datatype='string' , widgettype='combo' ismandatory=false , widgetcontrols=NULL , vdefault=NULL , layout_name=NULL, reg_exp=NULL WHERE parameter='verified_vdefault';



UPDATE audit_cat_param_user SET     WHERE parameter='visitclass_vdefault_connec', 'config', NULL, 'role_om', NULL, 'Visit class vdefault connec:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 6, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='visitclass_vdefault_arc', 'config', NULL, 'role_om', NULL, 'Visit class vdefault arc:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 4, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='visitclass_vdefault_node', 'config', NULL, 'role_om', NULL, 'Visit class vdefault node:', 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 5, 'utils', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_other_vdefault', 'config', NULL, 'role_master', NULL, 'Psector other:', NULL, NULL, true, 7, 6, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_vat_vdefault', 'config', NULL, 'role_master', NULL, 'Psector vat:', NULL, NULL, true, 7, 5, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_scale_vdefault', 'config', NULL, 'role_master', NULL, 'Psector scale:', NULL, NULL, true, 7, 2, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_rotation_vdefault', 'config', NULL, 'role_master', NULL, 'Psector rotation:', NULL, NULL, true, 7, 3, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='visitcat_vdefault', 'config', NULL, 'role_om', NULL, 'Visit catalog:', 'SELECT id AS id, name as idval  FROM om_visit_cat WHERE id IS NOT NULL', NULL, true, 2, 1, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='state_vdefault', 'config', NULL, 'role_edit', NULL, 'State:', 'SELECT id AS id , name as idval  FROM value_state WHERE id IS NOT NULL', NULL, true, 3, 1, 'utils', false, NULL, 'state', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='exploitation_vdefault', 'config', NULL, 'role_edit', NULL, 'Exploitation:', 'SELECT expl_id AS id , name as idval FROM exploitation WHERE expl_id IS NOT NULL', NULL, true, 4, 2, 'utils', true, NULL, 'expl_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='parameter_vdefault', 'config', NULL, 'role_om', NULL, 'Parameter:', 'SELECT om_visit_parameter.id AS id, om_visit_parameter.id AS idval FROM om_visit_parameter WHERE id IS NOT NULL', NULL, true, 2, 2, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='document_type_vdefault', 'config', NULL, 'role_basic', NULL, 'Document type:', 'SELECT doc_type.id AS id, doc_type.id AS idval FROM doc_type WHERE id IS NOT NULL', NULL, true, 1, 5, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='search_municipality_vdefault', 'config', NULL, 'role_basic', NULL, 'Search municipality:', 'SELECT muni_id AS id, name AS idval FROM ext_municipality WHERE muni_id IS NOT NULL', NULL, true, 1, 2, 'utils', false, NULL, 'muni_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='nodetype_vdefault', 'config', NULL, 'role_edit', NULL, 'Node Type:', 'SELECT id AS id, id AS idval FROM node_type WHERE id IS NOT NULL', NULL, true, 9, 1, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='builtdate_vdefault', 'config', NULL, 'role_edit', NULL, 'Builtdate:', NULL, NULL, true, 3, 5, 'utils', false, NULL, 'builtdate', NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='from_date_vdefault', 'config', NULL, 'role_basic', NULL, 'From date:', NULL, NULL, true, 1, 3, 'utils', false, NULL, NULL, NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='to_date_vdefault', 'config', NULL, 'role_basic', NULL, 'To date:', NULL, NULL, true, 1, 4, 'utils', false, NULL, NULL, NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='cf_keep_opened_edition', 'config', NULL, 'role_edit', NULL, 'Keep opened edition:', NULL, NULL, true, 8, 4, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='edit_arc_downgrade_force', 'config', NULL, 'role_edit', 'edit', 'edit_arc_downgrade_force', NULL, NULL, true, 99, 98, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='dim_tooltip', 'config', NULL, 'role_edit', NULL, 'Dim. tooltip:', NULL, NULL, true, 8, 2, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='edit_arc_division_dsbl', 'config', NULL, 'role_edit', 'edit', 'Dissable arc div on node insert:', NULL, NULL, true, 8, 3, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='plan_arc_vdivision_dsbl', 'config', NULL, 'role_edit', 'edit', 'Dissable arc vdiv on node insert:', NULL, NULL, true, 7, 9, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='statetype_end_vdefault', 'config', NULL, 'role_edit', NULL, 'State type end:', 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 0', NULL, true, 3, 3, 'utils', false, NULL, 'state_type', '0', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='statetype_vdefault', 'config', NULL, 'role_edit', NULL, 'State type:', 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 1', NULL, true, 3, 2, 'utils', false, NULL, 'state_type', '1', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_vdefault', 'config', NULL, 'role_master', NULL, 'Psector (Alternative):', 'SELECT plan_psector.psector_id AS id,  plan_psector.name as idval FROM plan_psector WHERE psector_id IS NOT NULL', NULL, true, 7, 1, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='arccat_vdefault', 'config', NULL, 'role_edit', NULL, 'Arc catalog:', 'SELECT cat_arc.id AS id, cat_arc.id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, true, 10, 1, 'ud', false, NULL, 'arccat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='statetype_plan_vdefault', 'config', NULL, 'role_master', 'plan', 'State type plan:', 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 2', NULL, true, 7, 8, 'utils', false, NULL, 'state_type', '2', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_gexpenses_vdefault', 'config', NULL, 'role_master', NULL, 'Psector gexpenses:', NULL, NULL, true, 7, 4, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='dma_vdefault', 'config', NULL, 'role_edit', NULL, 'Dma:', 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'exploitation_vdefault', true, 4, 3, 'utils', false, ' AND expl_id=', 'dma_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='enddate_vdefault', 'config', NULL, 'role_edit', NULL, 'End date:', NULL, NULL, true, 3, 6, 'utils', false, NULL, 'enddate', NULL, false, 'date', 'datepickertime', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='municipality_vdefault', 'config', NULL, 'role_edit', NULL, 'Municipality:', 'SELECT muni_id AS id, name AS idval FROM ext_municipality WHERE muni_id IS NOT NULL', NULL, true, 4, 1, 'utils', false, NULL, 'muni_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='om_param_type_vdefault', 'config', NULL, 'role_om', NULL, 'Parameter type:', 'SELECT om_visit_parameter_type.id AS id, om_visit_parameter_type.id as idval FROM om_visit_parameter_type WHERE id IS NOT NULL', NULL, true, 2, 3, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='search_exploitation_vdefault', 'config', NULL, 'role_basic', NULL, 'Search exploitation:', 'SELECT expl_id AS id , name as idval FROM exploitation WHERE expl_id IS NOT NULL', NULL, true, 1, 1, 'utils', false, NULL, 'expl_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='workcat_id_end_vdefault', 'config', NULL, 'role_edit', NULL, 'workcat_id_end_vdefault', 'SELECT cat_work.id AS id,cat_work.id as idval FROM cat_work WHERE id IS NOT NULL', NULL, true, 99, 97, 'utils', false, NULL, 'workcat_id_end', '0', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='psector_measurement_vdefault', 'config', NULL, 'role_master', NULL, 'Psector measurement:', NULL, NULL, true, 7, 7, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='workcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Workcat id:', 'SELECT cat_work.id AS id,cat_work.id as idval FROM cat_work WHERE id IS NOT NULL', NULL, true, 3, 4, 'utils', false, NULL, 'workcat_id', '1', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='sector_vdefault', 'config', NULL, 'role_edit', NULL, 'Sector:', 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', NULL, true, 4, 4, 'utils', false, NULL, 'sector_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='elementcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Element catalog:', 'SELECT cat_element.id, cat_element.id as idval FROM cat_element WHERE  id IS NOT NULL', NULL, true, 5, 1, 'utils', false, NULL, 'elementcat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='pavementcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Pavement catalog:', 'SELECT cat_pavement.id AS id, cat_pavement.id as idval FROM cat_pavement WHERE id IS NOT NULL', NULL, true, 5, 2, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='soilcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Soil catalog:', 'SELECT cat_soil.id AS id, cat_soil.id as idval FROM cat_soil WHERE id IS NOT NULL', NULL, true, 5, 3, 'utils', false, NULL, 'soilcat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);




*/



-- 2019/01/26
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2640, 'gw_api_getvisitmanager', 'role_om', FALSE, 'To call visit from user');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2642, 'gw_api_setvisitmanagerstart', 'role_om', FALSE,'To start visit manager');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2644, 'gw_api_setvisitmanagerend', 'role_om', FALSE,'To start visit manager');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2646, 'gw_fct_pg2epa_recursive', 'role_epa', FALSE, 'Function to enable recursive calculations on epa workflow');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2648, 'gw_fct_admin_schema_manage_fk', 'role_admin', FALSE, 'Function to manage fk');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2650, 'gw_fct_admin_schema_lastprocess', 'role_admin', FALSE, 'Function to create fk');


-- 2019/01/31
INSERT INTO sys_csv2pg_cat VALUES (10, 'Export inp', 'Export inp', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (11, 'Import rpt', 'Import rpt', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (12, 'Import inp', 'Import inp', null, 'role_admin');

-- 2019/02/02
UPDATE audit_cat_function SET istoolbox=TRUE,  descript=return_type, context=project_type, project_type='utils', function_type='{"featureType":"node"}', 
return_type=null, input_params='[{"name":"nodeTolerance", "type":"float"}]' , sys_role_id='role_edit', isparametric=true WHERE function_name='gw_fct_anl_node_duplicated';

-- 2019/02/08
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('vdefault_rtc_period_seconds','2592000','integer', 'rtc', 'Default value used if ext_cat_period doesn''t have date values or they are incorrect');

-- 2019/02/14
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('customer_code_autofill', 'FALSE', 'boolean', 'System', 'If TRUE, when insert a new connec customer_code will be the same as connec_id');


INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('nodeisert_arcendpoint', 'FALSE', 'boolean', 'edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('orphannode_delete', 'false', 'boolean', NULL, NULL, 'Orphan node delete:', NULL, NULL, true, 13, 6, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('nodetype_change_enabled', 'FALSE', 'boolean', NULL, NULL, 'nodetype_change_enabled', NULL, NULL, true, 13, 12, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('samenode_init_end_control', 'true', NULL, NULL, NULL, 'Arc same node init end control:', NULL, NULL, true, 13, 2, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('audit_function_control', 'TRUE', 'boolean', NULL, NULL, 'audit_function_control', NULL, NULL, false, NULL, NULL, NULL, false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('insert_double_geometry', 'false', 'boolean', NULL, NULL, 'Double geometry enabled:', NULL, NULL, true, 13, 5, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('buffer_value', '3.0', 'double precision', NULL, NULL, 'Double geometry enabled:', NULL, NULL, true, 13, 5, 'utils', false, false, 'double', 'spinbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('node_proximity_control', 'true', 'boolean', NULL, NULL, 'Node proximity control:', NULL, NULL, true, 13, 3, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('arc_searchnodes_control', 'true', 'boolean', NULL, NULL, 'Arc searchnodes buffer:', NULL, NULL, true, 13, 1, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('connec_proximity_control', 'true', 'boolean', NULL, NULL,'Connec proximity control:', NULL, NULL, true, 13, 4, 'utils', false, false, 'boolean', 'checkbox', NULL);




