/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


SELECT setval('SCHEMA_NAME.config_param_system (parameter, value, data_type, context, descript) _id_seq', (SELECT max(id) FROM config_param_system (parameter, value, data_type, context, descript) ), true);


-- general 
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('ApiVersion', '0.9.101', 'varchar', 'api', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_sensibility_factor_mobile', '2', NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_sensibility_factor_web', '1', NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_minimsearch', '1', NULL, 'api_search', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_character_number', '3', NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_publish_user', 'qgisserver', 'text', 'api', NULL);


-- network 
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_arc', '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby":"1"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_node', '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_connec', '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_gully', '{"sys_table_id":"v_edit_gully", "sys_id_field":"gully_id", "sys_search_field":"gully_id", "alias":"Embornal", "cat_field":"gratecat_id", "orderby":"4"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_element', '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_network_null', '{"sys_table_id":"", "sys_id_field":"", "sys_search_field":"", "alias":"", "cat_field":"", "orderby":"0"}', NULL, 'api_search_network', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_visit', '{"sys_table_id":"om_visit", "sys_id_field":"id", "sys_search_field":"ext_code", "alias":"Visita", "cat_field":"ext_code", "orderby":"6"}', 'text', 'api_search_network', NULL);


-- streeter 
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_muni', '{"sys_table_id":"ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_street', '{"sys_table_id":"v_ext_streetaxis", "sys_id_field":"id", "sys_search_field":"name", "sys_parent_field":"muni_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_postnumber', '{"sys_table_id":"v_ext_address", "sys_id_field":"id", "sys_search_field":"postnumber", "sys_parent_field":"streetaxis_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_adress', NULL);

-- workcat
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_workcat', '{"sys_table_id":"v_ui_workcat_polygon_all", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_workcat', NULL);

--hydrometer
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_hydrometer', '{"sys_table_id":"v_ui_hydrometer", "sys_id_field":"sys_hydrometer_id", "sys_connec_id":"sys_connec_id", "sys_search_field_1":"Hydro ccode:",  "sys_search_field_2":"Connec ccode:",  "sys_search_field_3":"State:", "sys_parent_field":"Exploitation:"}', NULL, 'apì_search_hydrometer', NULL);

-- api search 
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_service', 'amb', NULL, 'api_search_search', NULL);

-- psector
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_psector', '{"sys_table_id":"v_edit_plan_psector", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL);

-- exploitation
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_exploitation', '{"sys_table_id":"exploitation", "sys_id_field":"expl_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}', NULL, 'apì_search_psector', NULL);

