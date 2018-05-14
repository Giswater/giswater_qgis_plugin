/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;



INSERT INTO config_web_forms VALUES (30, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 3);
INSERT INTO config_web_forms VALUES (318, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 3);
INSERT INTO config_web_forms VALUES (45, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 2);
INSERT INTO config_web_forms VALUES (28, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 1);
INSERT INTO config_web_forms VALUES (46, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 3);
INSERT INTO config_web_forms VALUES (47, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 1);
INSERT INTO config_web_forms VALUES (32, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 2);
INSERT INTO config_web_forms VALUES (12, 'gully_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 3);
INSERT INTO config_web_forms VALUES (7, 'connec_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 1);
INSERT INTO config_web_forms VALUES (26, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 2);
INSERT INTO config_web_forms VALUES (48, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 2);
INSERT INTO config_web_forms VALUES (10, 'gully_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 1);
INSERT INTO config_web_forms VALUES (49, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 3);
INSERT INTO config_web_forms VALUES (11, 'gully_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 2);
INSERT INTO config_web_forms VALUES (6, 'arc_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 3);
INSERT INTO config_web_forms VALUES (34, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 1);
INSERT INTO config_web_forms VALUES (324, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 3);
INSERT INTO config_web_forms VALUES (35, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 2);
INSERT INTO config_web_forms VALUES (31, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 1);
INSERT INTO config_web_forms VALUES (29, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 2);
INSERT INTO config_web_forms VALUES (321, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 3);
INSERT INTO config_web_forms VALUES (27, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 3);
INSERT INTO config_web_forms VALUES (322, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 1);
INSERT INTO config_web_forms VALUES (9, 'connec_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 3);
INSERT INTO config_web_forms VALUES (4, 'arc_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 1);
INSERT INTO config_web_forms VALUES (323, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 2);
INSERT INTO config_web_forms VALUES (44, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 1);
INSERT INTO config_web_forms VALUES (5, 'arc_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 2);
INSERT INTO config_web_forms VALUES (25, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 1);
INSERT INTO config_web_forms VALUES (33, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 3);
INSERT INTO config_web_forms VALUES (36, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 3);
INSERT INTO config_web_forms VALUES (8, 'connec_x_element', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 2);
INSERT INTO config_web_forms VALUES (316, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 1);
INSERT INTO config_web_forms VALUES (317, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 2);
INSERT INTO config_web_forms VALUES (319, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 1);
INSERT INTO config_web_forms VALUES (2, 'node_x_element', 'SELECT element_id as sys_id, element_id, elementcat_id FROM v_ui_element_x_node', 2);
INSERT INTO config_web_forms VALUES (3, 'node_x_element', 'SELECT element_id as sys_id, element_id, elementcat_id FROM v_ui_element_x_node', 3);
INSERT INTO config_web_forms VALUES (320, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 2);
INSERT INTO config_web_forms VALUES (325, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 1);
INSERT INTO config_web_forms VALUES (17, 'arc_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_arc', 2);
INSERT INTO config_web_forms VALUES (18, 'arc_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_arc', 3);
INSERT INTO config_web_forms VALUES (20, 'connec_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_connec', 2);
INSERT INTO config_web_forms VALUES (21, 'connec_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_connec', 3);
INSERT INTO config_web_forms VALUES (23, 'gully_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_gully', 2);
INSERT INTO config_web_forms VALUES (19, 'connec_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_connec', 1);
INSERT INTO config_web_forms VALUES (24, 'gully_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_gully', 3);
INSERT INTO config_web_forms VALUES (38, 'arc_x_connect', 'SELECT feature_id as sys_id, x as sys_x, y as sys_y, featurecat_id  FROM v_ui_arc_x_relations', 2);
INSERT INTO config_web_forms VALUES (39, 'arc_x_connect', 'SELECT feature_id as sys_id, x as sys_x, y as sys_y, featurecat_id  FROM v_ui_arc_x_relations', 3);
INSERT INTO config_web_forms VALUES (37, 'arc_x_connect', 'SELECT feature_id as sys_id, x as sys_x, y as sys_y, featurecat_id  FROM v_ui_arc_x_relations', 1);
INSERT INTO config_web_forms VALUES (326, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 2);
INSERT INTO config_web_forms VALUES (327, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 3);
INSERT INTO config_web_forms VALUES (1, 'node_x_element', 'SELECT element_id as sys_id, element_id, elementcat_id FROM v_ui_element_x_node', 1);
INSERT INTO config_web_forms VALUES (40, 'v_ui_element', 'SELECT id as element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link FROM v_ui_element', 1);
INSERT INTO config_web_forms VALUES (42, 'v_ui_element', 'SELECT id as element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link FROM v_ui_element', 2);
INSERT INTO config_web_forms VALUES (43, 'v_ui_element', 'SELECT id as element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link FROM v_ui_element', 3);
INSERT INTO config_web_forms VALUES (1005, 'hydrometer', 'SELECT * FROM v_rtc_hydrometer', 3);
INSERT INTO config_web_forms VALUES (13, 'node_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text as date FROM v_ui_om_visit_x_node', 1);
INSERT INTO config_web_forms VALUES (14, 'node_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text as date FROM v_ui_om_visit_x_node', 2);
INSERT INTO config_web_forms VALUES (15, 'node_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text as date FROM v_ui_om_visit_x_node', 3);
INSERT INTO config_web_forms VALUES (16, 'arc_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_arc', 1);
INSERT INTO config_web_forms VALUES (22, 'gully_x_visit', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_gully', 1);
INSERT INTO config_web_forms VALUES (1000, 'connec_x_hydrometer', 'SELECT hydrometer_id as sys_id, hydrometer_customer_code as code,  name as state, hydrometer_category as category FROM v_rtc_hydrometer', 1);
INSERT INTO config_web_forms VALUES (1001, 'connec_x_hydrometer', 'SELECT hydrometer_id as sys_id, hydrometer_customer_code as code,  name as state, hydrometer_category as category FROM v_rtc_hydrometer', 2);
INSERT INTO config_web_forms VALUES (1002, 'connec_x_hydrometer', 'SELECT hydrometer_id as sys_id, hydrometer_customer_code as code,  name as state, hydrometer_category as category FROM v_rtc_hydrometer', 3);
INSERT INTO config_web_forms VALUES (1003, 'hydrometer', 'SELECT * FROM v_rtc_hydrometer', 1);
INSERT INTO config_web_forms VALUES (1004, 'hydrometer', 'SELECT * FROM v_rtc_hydrometer', 2);


