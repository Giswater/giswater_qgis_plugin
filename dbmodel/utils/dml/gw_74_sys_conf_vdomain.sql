/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO cat_users VALUES ('postgres');


INSERT INTO config (id, node_proximity, arc_searchnodes, node2arc, connec_proximity, nodeinsert_arcendpoint, 
		orphannode_delete, vnode_update_tolerance, nodetype_change_enabled, 		
		samenode_init_end_control, node_proximity_control, connec_proximity_control, 
		node_duplicated_tolerance, connec_duplicated_tolerance, audit_function_control, arc_searchnodes_control, insert_double_geometry, buffer_value)
		VALUES ('1', 0.10000000000000001, 0.5, 0.5, 0.10000000000000001, false, false, 0.5, false, true, true, true, 0.001, 0.001, true, true, true, 1);


		

INSERT INTO config_param_system VALUES (31, 'street_layer', 'ext_streetaxis', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (32, 'street_field_code', 'id', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (33, 'street_field_name', 'name', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (34, 'portal_layer', 'ext_address', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (35, 'portal_field_code', 'streetaxis', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (36, 'portal_field_number', 'number', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (9, 'expl_field_name', 'name', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (7, 'expl_layer', 'exploitation', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (16, 'network_field_arc_code', 'code', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (5, 'custom_giswater_folder', 'c:/', '1', '1', NULL);
INSERT INTO config_param_system VALUES (13, 'network_layer_element', 'element', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (18, 'network_field_element_code', 'code', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (19, 'network_field_gully_code', 'code', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (22, 'hydrometer_urban_propierties_field_code', 'connec_id', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (11, 'network_layer_arc', 'v_edit_arc', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (12, 'network_layer_connec', 'v_edit_connec', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (2, 'doc_absolute_path', 'c:' , '1', '1', NULL);
INSERT INTO config_param_system VALUES (25, 'hydrometer_field_urban_propierties_code', 'connec_id', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (15, 'network_layer_node', 'v_edit_node', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (24, 'hydrometer_field_code', 'hydrometer_id', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (17, 'network_field_connec_code', 'code', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (23, 'hydrometer_layer', 'v_rtc_hydrometer', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (20, 'network_field_node_code', 'code', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (14, 'network_layer_gully', 'v_edit_gully', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (21, 'hydrometer_urban_propierties_layer', 'v_edit_connec', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (4, 'om_visit_absolute_path', 'https://www.', '2', '2', NULL);
INSERT INTO config_param_system VALUES (10, 'scale_zoom', '2500', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (37, 'portal_field_postal', 'postcode', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (38, 'street_field_expl', 'muni_id', NULL, 'searchplus', NULL);
INSERT INTO config_param_system VALUES (8, 'expl_field_code', 'muni_id', NULL, 'searchplus', NULL);		
INSERT INTO config_param_system VALUES (39, 'module_om_rehabit', TRUE, NULL, NULL, NULL);		
INSERT INTO config_param_system VALUES (40, 'state_topocontrol', TRUE, boolean, 'topology', NULL);						
INSERT INTO config_param_system VALUES (41, 'mincut_conflict_map', FALSE, NULL, 'mincut', 'Only for WS');				
INSERT INTO config_param_system VALUES (42, 'inventory_update_date', '2017-01-01', date, 'om', NULL);
INSERT INTO config_param_system VALUES (43, 'geom_slp_direction', TRUE, boolean, 'topology', 'Only for UD');							
	
--INSERT INTO config_client_forms VALUES (3867, 'v_ui_element_x_gully', true, 100, 5, NULL);
