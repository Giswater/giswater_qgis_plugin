/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "ud", public, pg_catalog;



INSERT INTO config_param_system VALUES (180, 'api_search_element', '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system VALUES (177, 'api_search_node', '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system VALUES (184, 'api_search_postnumber', '{"sys_table_id":"v_ext_address", "sys_id_field":"id", "sys_search_field":"postnumber", "sys_parent_field":"streetaxis_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);
INSERT INTO config_param_system VALUES (167, 'ApiVersion', '0.9.101', 'varchar', 'api', NULL);
INSERT INTO config_param_system VALUES (176, 'api_search_arc', '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby":"1"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system VALUES (183, 'api_search_street', '{"sys_table_id":"v_ext_streetaxis", "sys_id_field":"id", "sys_search_field":"name", "sys_parent_field":"muni_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);
INSERT INTO config_param_system VALUES (174, 'api_sensibility_factor_mobile', '2', NULL, NULL, NULL);
INSERT INTO config_param_system VALUES (171, 'api_sensibility_factor_web', '1', NULL, NULL, NULL);
INSERT INTO config_param_system VALUES (178, 'api_search_connec', '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system VALUES (179, 'api_search_gully', '{"sys_table_id":"v_edit_gully", "sys_id_field":"gully_id", "sys_search_field":"gully_id", "alias":"Embornal", "cat_field":"gratecat_id", "orderby":"4"}', NULL, 'api_search_network', NULL);

INSERT INTO config_param_system VALUES (187, 'api_search_psector', '{"sys_table_id":"v_edit_plan_psector", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL);
INSERT INTO config_param_system VALUES (188, 'api_search_exploitation', '{"sys_table_id":"exploitation", "sys_id_field":"expl_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL);
INSERT INTO config_param_system VALUES (182, 'api_search_muni', '{"sys_table_id":"ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);
INSERT INTO config_param_system VALUES (186, 'api_search_workcat', '{"sys_table_id":"v_ui_workcat_polygon", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_workcat', NULL);
INSERT INTO config_param_system VALUES (190, 'api_search_network_null', '{"sys_table_id":"", "sys_id_field":"", "sys_search_field":"", "alias":"", "cat_field":"", "orderby":"0"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system VALUES (191, 'api_search_service', 'amb', NULL, 'api_search_search', NULL);
INSERT INTO config_param_system VALUES (192, 'api_search_minimsearch', '1', NULL, 'api_search', NULL);
INSERT INTO config_param_system VALUES (189, 'api_search_hydrometer', '{"sys_table_id":"v_ui_hydrometer", "sys_id_field":"sys_hydrometer_id", "sys_connec_id":"sys_connec_id", "sys_search_field_1":"Hydro ccode:",  "sys_search_field_2":"Connec ccode:",  "sys_search_field_3":"State:", "sys_parent_field":"Exploitation:"}', NULL, 'apì_search_hydrometer', NULL);
INSERT INTO config_param_system VALUES (195, 'api_search_character_number', '3', NULL, NULL, NULL);