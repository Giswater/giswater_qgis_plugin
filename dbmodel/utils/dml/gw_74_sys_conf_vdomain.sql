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
		
		
				
	
INSERT INTO config_client_forms VALUES (3867, 'v_ui_element_x_gully', true, 100, 5, NULL);
INSERT INTO config_client_forms VALUES (3870, 'v_ui_element_x_gully', NULL, NULL, 6, NULL);
INSERT INTO config_client_forms VALUES (3872, 'v_ui_element_x_gully', NULL, NULL, 7, NULL);
INSERT INTO config_client_forms VALUES (3874, 'v_ui_element_x_gully', true, 100, 8, NULL);
INSERT INTO config_client_forms VALUES (3876, 'v_ui_element_x_gully', NULL, NULL, 9, NULL);
INSERT INTO config_client_forms VALUES (3894, 'v_ui_element_x_connec', true, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (3896, 'v_ui_element_x_connec', true, 196, 4, NULL);
INSERT INTO config_client_forms VALUES (3898, 'v_ui_element_x_connec', true, 100, 5, NULL);
INSERT INTO config_client_forms VALUES (3900, 'v_ui_element_x_connec', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3902, 'v_ui_element_x_connec', NULL, 150, 7, NULL);
INSERT INTO config_client_forms VALUES (3904, 'v_ui_element_x_connec', true, 100, 8, NULL);
INSERT INTO config_client_forms VALUES (72110, 'v_price_x_node', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (72130, 'v_price_x_node', true, 30, 3, NULL);
INSERT INTO config_client_forms VALUES (72120, 'v_price_x_node', false, 120, 2, NULL);
INSERT INTO config_client_forms VALUES (72140, 'v_price_x_node', true, 300, 4, NULL);
INSERT INTO config_client_forms VALUES (72160, 'v_price_x_node', true, 50, 6, 'depth');
INSERT INTO config_client_forms VALUES (72150, 'v_price_x_node', true, 60, 5, NULL);
INSERT INTO config_client_forms VALUES (72170, 'v_price_x_node', true, 61, 7, NULL);
INSERT INTO config_client_forms VALUES (13200, 'v_ui_om_visit_x_arc', NULL, NULL, 12, NULL);
INSERT INTO config_client_forms VALUES (14200, 'v_ui_om_visit_x_arc', NULL, NULL, 13, NULL);
INSERT INTO config_client_forms VALUES (16000, 'v_ui_om_visit_x_arc', NULL, NULL, 15, NULL);
INSERT INTO config_client_forms VALUES (27000, 'v_ui_om_visit_x_node', NULL, NULL, 11, NULL);
INSERT INTO config_client_forms VALUES (31000, 'v_ui_om_visit_x_node', NULL, NULL, 15, NULL);
INSERT INTO config_client_forms VALUES (32000, 'v_ui_om_visit_x_connec', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (33000, 'v_ui_om_visit_x_connec', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (34000, 'v_ui_om_visit_x_connec', NULL, NULL, 3, NULL);
INSERT INTO config_client_forms VALUES (35000, 'v_ui_om_visit_x_connec', NULL, NULL, 4, NULL);
INSERT INTO config_client_forms VALUES (36000, 'v_ui_om_visit_x_connec', NULL, NULL, 5, NULL);
INSERT INTO config_client_forms VALUES (8200, 'v_ui_om_visit_x_arc', NULL, NULL, 7, NULL);
INSERT INTO config_client_forms VALUES (38000, 'v_ui_om_visit_x_connec', NULL, NULL, 7, NULL);
INSERT INTO config_client_forms VALUES (41000, 'v_ui_om_visit_x_connec', NULL, NULL, 10, NULL);
INSERT INTO config_client_forms VALUES (42000, 'v_ui_om_visit_x_connec', NULL, NULL, 11, NULL);
INSERT INTO config_client_forms VALUES (43000, 'v_ui_om_visit_x_connec', NULL, NULL, 12, NULL);
INSERT INTO config_client_forms VALUES (44000, 'v_ui_om_visit_x_connec', NULL, NULL, 13, NULL);
INSERT INTO config_client_forms VALUES (4120, 'v_ui_om_visit_x_arc', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (3670, 'v_ui_element_x_arc', true, 100, 8, NULL);
INSERT INTO config_client_forms VALUES (3640, 'v_ui_element_x_arc', true, 100, 5, NULL);
INSERT INTO config_client_forms VALUES (3630, 'v_ui_element_x_arc', true, 196, 4, NULL);
INSERT INTO config_client_forms VALUES (3620, 'v_ui_element_x_arc', true, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (3810, 'v_ui_element_x_node', true, 196, 4, NULL);
INSERT INTO config_client_forms VALUES (3800, 'v_ui_element_x_node', true, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (3820, 'v_ui_element_x_node', true, 100, 5, NULL);
INSERT INTO config_client_forms VALUES (3830, 'v_ui_element_x_node', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3850, 'v_ui_element_x_node', true, 100, 8, NULL);
INSERT INTO config_client_forms VALUES (4040, 'v_rtc_scada_value', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (4080, 'v_rtc_scada_value', NULL, NULL, 6, NULL);
INSERT INTO config_client_forms VALUES (4030, 'v_rtc_scada_value', true, 120, 1, NULL);
INSERT INTO config_client_forms VALUES (4110, 'v_ui_om_visit_x_arc', NULL, NULL, 3, NULL);
INSERT INTO config_client_forms VALUES (3960, 'v_rtc_scada', true, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (3970, 'v_rtc_scada', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (3980, 'v_rtc_scada', true, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (4130, 'v_ui_om_visit_x_arc', NULL, NULL, 4, NULL);
INSERT INTO config_client_forms VALUES (4060, 'v_rtc_scada_value', true, 100, 4, NULL);
INSERT INTO config_client_forms VALUES (4050, 'v_rtc_scada_value', true, 130, 3, NULL);
INSERT INTO config_client_forms VALUES (3990, 'v_rtc_scada', true, 224, 4, NULL);
INSERT INTO config_client_forms VALUES (4200, 'v_ui_om_visit_x_arc', NULL, NULL, 5, NULL);
INSERT INTO config_client_forms VALUES (4070, 'v_rtc_scada_value', true, 174, 5, NULL);
INSERT INTO config_client_forms VALUES (5200, 'v_ui_om_visit_x_arc', NULL, NULL, 10, NULL);
INSERT INTO config_client_forms VALUES (7200, 'v_ui_om_visit_x_arc', true, 120, 6, NULL);
INSERT INTO config_client_forms VALUES (9200, 'v_ui_om_visit_x_arc', true, 165, 8, NULL);
INSERT INTO config_client_forms VALUES (10200, 'v_ui_om_visit_x_arc', true, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (11200, 'v_ui_om_visit_x_arc', NULL, NULL, 11, NULL);
INSERT INTO config_client_forms VALUES (22000, 'v_ui_om_visit_x_node', true, 120, 6, NULL);
INSERT INTO config_client_forms VALUES (24000, 'v_ui_om_visit_x_node', true, 160, 8, NULL);
INSERT INTO config_client_forms VALUES (25000, 'v_ui_om_visit_x_node', true, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (28000, 'v_ui_om_visit_x_node', NULL, NULL, 12, NULL);
INSERT INTO config_client_forms VALUES (29000, 'v_ui_om_visit_x_node', NULL, NULL, 13, NULL);
INSERT INTO config_client_forms VALUES (30000, 'v_ui_om_visit_x_node', true, 80, 14, NULL);
INSERT INTO config_client_forms VALUES (37000, 'v_ui_om_visit_x_connec', true, 120, 6, NULL);
INSERT INTO config_client_forms VALUES (3000, 'v_ui_doc_x_node', NULL, 150, 5, NULL);
INSERT INTO config_client_forms VALUES (2950, 'v_ui_doc_x_arc', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3100, 'v_ui_doc_x_connec', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3130, 'v_ui_doc_x_connec', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3070, 'v_ui_doc_x_connec', true, 300, 3, NULL);
INSERT INTO config_client_forms VALUES (39000, 'v_ui_om_visit_x_connec', true, 171, 8, NULL);
INSERT INTO config_client_forms VALUES (40000, 'v_ui_om_visit_x_connec', true, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (45000, 'v_ui_om_visit_x_connec', true, 90, 14, NULL);
INSERT INTO config_client_forms VALUES (46000, 'v_ui_om_visit_x_connec', NULL, NULL, 15, NULL);
INSERT INTO config_client_forms VALUES (52000, 'v_ui_om_visit_x_gully', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (54000, 'v_ui_om_visit_x_gully', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (55000, 'v_ui_om_visit_x_gully', NULL, NULL, 3, NULL);
INSERT INTO config_client_forms VALUES (62000, 'v_ui_om_visit_x_gully', NULL, NULL, 5, NULL);
INSERT INTO config_client_forms VALUES (63000, 'v_ui_om_visit_x_gully', true, 120, 6, NULL);
INSERT INTO config_client_forms VALUES (64000, 'v_ui_om_visit_x_gully', NULL, NULL, 7, NULL);
INSERT INTO config_client_forms VALUES (65000, 'v_ui_om_visit_x_gully', true, 171, 8, NULL);
INSERT INTO config_client_forms VALUES (66000, 'v_ui_om_visit_x_gully', true, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (67000, 'v_ui_om_visit_x_gully', NULL, NULL, 10, NULL);
INSERT INTO config_client_forms VALUES (68000, 'v_ui_om_visit_x_gully', NULL, NULL, 11, NULL);
INSERT INTO config_client_forms VALUES (69000, 'v_ui_om_visit_x_gully', NULL, NULL, 12, NULL);
INSERT INTO config_client_forms VALUES (70000, 'v_ui_om_visit_x_gully', NULL, NULL, 13, NULL);
INSERT INTO config_client_forms VALUES (71000, 'v_ui_om_visit_x_gully', true, 90, 14, NULL);
INSERT INTO config_client_forms VALUES (72000, 'v_ui_om_visit_x_gully', NULL, NULL, 15, NULL);
INSERT INTO config_client_forms VALUES (730, 'v_ui_doc_x_gully', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (740, 'v_ui_doc_x_gully', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (750, 'v_ui_doc_x_gully', true, 300, 3, NULL);
INSERT INTO config_client_forms VALUES (760, 'v_ui_doc_x_gully', true, 150, 4, NULL);
INSERT INTO config_client_forms VALUES (770, 'v_ui_doc_x_gully', NULL, NULL, 5, NULL);
INSERT INTO config_client_forms VALUES (780, 'v_ui_doc_x_gully', NULL, NULL, 6, NULL);
INSERT INTO config_client_forms VALUES (790, 'v_ui_doc_x_gully', true, 81, 7, NULL);
INSERT INTO config_client_forms VALUES (800, 'v_ui_doc_x_gully', NULL, NULL, 8, NULL);
INSERT INTO config_client_forms VALUES (810, 'v_ui_doc_x_gully', NULL, NULL, 9, NULL);
INSERT INTO config_client_forms VALUES (3862, 'v_ui_element_x_gully', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (3863, 'v_ui_element_x_gully', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (3864, 'v_ui_element_x_gully', true, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (3866, 'v_ui_element_x_gully', true, 196, 4, NULL);
INSERT INTO config_client_forms VALUES (3650, 'v_ui_element_x_arc', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3840, 'v_ui_element_x_node', NULL, 150, 7, NULL);
INSERT INTO config_client_forms VALUES (3610, 'v_ui_element_x_arc', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (3790, 'v_ui_element_x_node', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (3660, 'v_ui_element_x_arc', NULL, 150, 7, NULL);
INSERT INTO config_client_forms VALUES (2890, 'v_ui_doc_x_arc', true, 300, 3, NULL);
INSERT INTO config_client_forms VALUES (3600, 'v_ui_element_x_arc', NULL, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (3780, 'v_ui_element_x_node', NULL, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (3680, 'v_ui_element_x_arc', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3860, 'v_ui_element_x_node', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3110, 'v_ui_doc_x_connec', true, 81, 7, NULL);
INSERT INTO config_client_forms VALUES (3080, 'v_ui_doc_x_connec', true, 150, 4, NULL);
INSERT INTO config_client_forms VALUES (3060, 'v_ui_doc_x_connec', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (3050, 'v_ui_doc_x_connec', NULL, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (2940, 'v_ui_doc_x_arc', NULL, 150, 8, NULL);
INSERT INTO config_client_forms VALUES (3090, 'v_ui_doc_x_connec', NULL, 150, 5, NULL);
INSERT INTO config_client_forms VALUES (3120, 'v_ui_doc_x_connec', NULL, 150, 8, NULL);
INSERT INTO config_client_forms VALUES (3270, 'v_edit_rtc_hydro_data_x_connec', NULL, 140, 5, NULL);
INSERT INTO config_client_forms VALUES (3280, 'v_edit_rtc_hydro_data_x_connec', NULL, 140, 6, NULL);
INSERT INTO config_client_forms VALUES (3230, 'v_edit_rtc_hydro_data_x_connec', NULL, 100, 1, NULL);
INSERT INTO config_client_forms VALUES (3240, 'v_edit_rtc_hydro_data_x_connec', NULL, 130, 2, NULL);
INSERT INTO config_client_forms VALUES (3260, 'v_edit_rtc_hydro_data_x_connec', NULL, 125, 4, NULL);
INSERT INTO config_client_forms VALUES (2900, 'v_ui_doc_x_arc', true, 150, 4, NULL);
INSERT INTO config_client_forms VALUES (2880, 'v_ui_doc_x_arc', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (2870, 'v_ui_doc_x_arc', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (2910, 'v_ui_doc_x_arc', NULL, 150, 5, NULL);
INSERT INTO config_client_forms VALUES (2920, 'v_ui_doc_x_arc', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (2930, 'v_ui_doc_x_arc', true, 81, 7, NULL);
INSERT INTO config_client_forms VALUES (2970, 'v_ui_doc_x_node', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (2960, 'v_ui_doc_x_node', NULL, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (3250, 'v_edit_rtc_hydro_data_x_connec', true, 125, 3, NULL);
INSERT INTO config_client_forms VALUES (3292, 'v_edit_rtc_hydro_data_x_connec', true, 120, 8, NULL);
INSERT INTO config_client_forms VALUES (3294, 'v_edit_rtc_hydro_data_x_connec', true, 120, 9, NULL);
INSERT INTO config_client_forms VALUES (3290, 'v_edit_rtc_hydro_data_x_connec', true, 160, 7, NULL);
INSERT INTO config_client_forms VALUES (3300, 'v_rtc_hydrometer', true, 100, 1, NULL);
INSERT INTO config_client_forms VALUES (3310, 'v_rtc_hydrometer', NULL, 150, 2, NULL);
INSERT INTO config_client_forms VALUES (3330, 'v_rtc_hydrometer', NULL, 130, 4, NULL);
INSERT INTO config_client_forms VALUES (3350, 'v_rtc_hydrometer', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3370, 'v_rtc_hydrometer', NULL, 150, 8, NULL);
INSERT INTO config_client_forms VALUES (3380, 'v_rtc_hydrometer', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3390, 'v_rtc_hydrometer', NULL, 150, 10, NULL);
INSERT INTO config_client_forms VALUES (3400, 'v_rtc_hydrometer', NULL, 150, 11, NULL);
INSERT INTO config_client_forms VALUES (3410, 'v_rtc_hydrometer', NULL, 150, 12, NULL);
INSERT INTO config_client_forms VALUES (2990, 'v_ui_doc_x_node', true, 150, 4, NULL);
INSERT INTO config_client_forms VALUES (3420, 'v_rtc_hydrometer', NULL, 150, 13, NULL);
INSERT INTO config_client_forms VALUES (3320, 'v_rtc_hydrometer', NULL, 150, 3, NULL);
INSERT INTO config_client_forms VALUES (3430, 'v_rtc_hydrometer', NULL, 100, 14, NULL);
INSERT INTO config_client_forms VALUES (3360, 'v_rtc_hydrometer', true, 150, 7, NULL);
INSERT INTO config_client_forms VALUES (3340, 'v_rtc_hydrometer', true, 175, 5, NULL);
INSERT INTO config_client_forms VALUES (3010, 'v_ui_doc_x_node', NULL, 150, 6, NULL);
INSERT INTO config_client_forms VALUES (3030, 'v_ui_doc_x_node', NULL, 150, 8, NULL);
INSERT INTO config_client_forms VALUES (3040, 'v_ui_doc_x_node', NULL, 150, 9, NULL);
INSERT INTO config_client_forms VALUES (3020, 'v_ui_doc_x_node', true, 81, 7, NULL);
INSERT INTO config_client_forms VALUES (2980, 'v_ui_doc_x_node', true, 300, 3, NULL);
INSERT INTO config_client_forms VALUES (15000, 'v_ui_om_visit_x_arc', true, 85, 14, NULL);
INSERT INTO config_client_forms VALUES (17000, 'v_ui_om_visit_x_node', NULL, NULL, 1, NULL);
INSERT INTO config_client_forms VALUES (18000, 'v_ui_om_visit_x_node', NULL, NULL, 2, NULL);
INSERT INTO config_client_forms VALUES (19000, 'v_ui_om_visit_x_node', NULL, NULL, 3, NULL);
INSERT INTO config_client_forms VALUES (20000, 'v_ui_om_visit_x_node', NULL, NULL, 4, NULL);
INSERT INTO config_client_forms VALUES (21000, 'v_ui_om_visit_x_node', NULL, NULL, 5, NULL);
INSERT INTO config_client_forms VALUES (23000, 'v_ui_om_visit_x_node', NULL, NULL, 7, NULL);
INSERT INTO config_client_forms VALUES (26000, 'v_ui_om_visit_x_node', NULL, NULL, 10, NULL);
INSERT INTO config_client_forms VALUES (60000, 'v_ui_om_visit_x_gully', NULL, NULL, 4, NULL);
INSERT INTO config_client_forms VALUES (3890, 'v_ui_element_x_connec', NULL, 150, 1, NULL);
INSERT INTO config_client_forms VALUES (3892, 'v_ui_element_x_connec', NULL, 100, 2, NULL);
INSERT INTO config_client_forms VALUES (3906, 'v_ui_element_x_connec', NULL, 100, 9, NULL);
INSERT INTO config_client_forms VALUES (4100, 'v_ui_om_visit_x_arc', NULL, NULL, 1, NULL);