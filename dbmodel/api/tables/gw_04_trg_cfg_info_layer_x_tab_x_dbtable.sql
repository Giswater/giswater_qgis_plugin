/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;



INSERT INTO config_web_forms VALUES (30, 'v_ui_doc_x_arc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 3);
INSERT INTO config_web_forms VALUES (318, 'v_ui_om_visitman_x_node', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 3);
INSERT INTO config_web_forms VALUES (45, 'v_ui_node_x_connection_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 2);
INSERT INTO config_web_forms VALUES (37, 'v_ui_arc_x_connection', 'SELECT feature_id as sys_id, feature_type, x as sys_x, y as sys_y FROM v_ui_arc_x_connection', 1);
INSERT INTO config_web_forms VALUES (28, 'v_ui_doc_x_arc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 1);
INSERT INTO config_web_forms VALUES (46, 'v_ui_node_x_connection_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 3);
INSERT INTO config_web_forms VALUES (47, 'v_ui_node_x_connection_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 1);
INSERT INTO config_web_forms VALUES (32, 'v_ui_doc_x_connec', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 2);
INSERT INTO config_web_forms VALUES (3, 'v_ui_element_x_node', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_node', 3);
INSERT INTO config_web_forms VALUES (12, 'v_ui_element_x_gully', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 3);
INSERT INTO config_web_forms VALUES (7, 'v_ui_element_x_connec', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 1);
INSERT INTO config_web_forms VALUES (26, 'v_ui_doc_x_node', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 2);
INSERT INTO config_web_forms VALUES (48, 'v_ui_node_x_connection_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 2);
INSERT INTO config_web_forms VALUES (40, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link FROM v_ui_element', 1);
INSERT INTO config_web_forms VALUES (10, 'v_ui_element_x_gully', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 1);
INSERT INTO config_web_forms VALUES (49, 'v_ui_node_x_connection_upstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_upstream', 3);
INSERT INTO config_web_forms VALUES (20, 'v_ui_om_visit_x_connec', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_connec', 2);
INSERT INTO config_web_forms VALUES (11, 'v_ui_element_x_gully', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_gully', 2);
INSERT INTO config_web_forms VALUES (6, 'v_ui_element_x_arc', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 3);
INSERT INTO config_web_forms VALUES (21, 'v_ui_om_visit_x_connec', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_connec', 3);
INSERT INTO config_web_forms VALUES (34, 'v_ui_doc_x_gully', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 1);
INSERT INTO config_web_forms VALUES (22, 'v_ui_om_visit_x_gully', 'SELECT visit_id event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_gully', 1);
INSERT INTO config_web_forms VALUES (23, 'v_ui_om_visit_x_gully', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_gully', 2);
INSERT INTO config_web_forms VALUES (39, 'v_ui_arc_x_connection', 'SELECT feature_id as sys_id, feature_type, x as sys_x, y as sys_y FROM v_ui_arc_x_connection', 3);
INSERT INTO config_web_forms VALUES (24, 'v_ui_om_visit_x_gully', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_gully', 3);
INSERT INTO config_web_forms VALUES (324, 'v_ui_om_visitman_x_connec', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 3);
INSERT INTO config_web_forms VALUES (35, 'v_ui_doc_x_gully', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 2);
INSERT INTO config_web_forms VALUES (31, 'v_ui_doc_x_connec', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 1);
INSERT INTO config_web_forms VALUES (13, 'v_ui_om_visit_x_node', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_node', 1);
INSERT INTO config_web_forms VALUES (29, 'v_ui_doc_x_arc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 2);
INSERT INTO config_web_forms VALUES (321, 'v_ui_om_visitman_x_arc', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 3);
INSERT INTO config_web_forms VALUES (27, 'v_ui_doc_x_node', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 3);
INSERT INTO config_web_forms VALUES (322, 'v_ui_om_visitman_x_connec', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 1);
INSERT INTO config_web_forms VALUES (2, 'v_ui_element_x_node', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_node', 2);
INSERT INTO config_web_forms VALUES (9, 'v_ui_element_x_connec', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 3);
INSERT INTO config_web_forms VALUES (4, 'v_ui_element_x_arc', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 1);
INSERT INTO config_web_forms VALUES (323, 'v_ui_om_visitman_x_connec', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 2);
INSERT INTO config_web_forms VALUES (44, 'v_ui_node_x_connection_downstream', 'SELECT feature_id as sys_id, featurecat_id, x as sys_x, y as sys_y FROM v_ui_node_x_connection_downstream', 1);
INSERT INTO config_web_forms VALUES (5, 'v_ui_element_x_arc', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_arc', 2);
INSERT INTO config_web_forms VALUES (38, 'v_ui_arc_x_connection', 'SELECT feature_id as sys_id, feature_type, x as sys_x, y as sys_y FROM v_ui_arc_x_connection', 2);
INSERT INTO config_web_forms VALUES (25, 'v_ui_doc_x_node', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 1);
INSERT INTO config_web_forms VALUES (33, 'v_ui_doc_x_connec', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 3);
INSERT INTO config_web_forms VALUES (36, 'v_ui_doc_x_gully', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 3);
INSERT INTO config_web_forms VALUES (1, 'v_ui_element_x_node', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_node', 1);
INSERT INTO config_web_forms VALUES (8, 'v_ui_element_x_connec', 'SELECT element_id as sys_id, elementcat_id FROM v_ui_element_x_connec', 2);
INSERT INTO config_web_forms VALUES (14, 'v_ui_om_visit_x_node', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_node', 2);
INSERT INTO config_web_forms VALUES (16, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_arc', 1);
INSERT INTO config_web_forms VALUES (17, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_arc', 2);
INSERT INTO config_web_forms VALUES (18, 'v_ui_om_visit_x_arc', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_arc', 3);
INSERT INTO config_web_forms VALUES (19, 'v_ui_om_visit_x_connec', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_connec', 1);
INSERT INTO config_web_forms VALUES (316, 'v_ui_om_visitman_x_node', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 1);
INSERT INTO config_web_forms VALUES (317, 'v_ui_om_visitman_x_node', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 2);
INSERT INTO config_web_forms VALUES (319, 'v_ui_om_visitman_x_arc', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 1);
INSERT INTO config_web_forms VALUES (320, 'v_ui_om_visitman_x_arc', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 2);
INSERT INTO config_web_forms VALUES (325, 'v_ui_om_visitman_x_gully', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 1);
INSERT INTO config_web_forms VALUES (326, 'v_ui_om_visitman_x_gully', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 2);
INSERT INTO config_web_forms VALUES (327, 'v_ui_om_visitman_x_gully', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 3);
INSERT INTO config_web_forms VALUES (42, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link    FROM v_ui_element', 2);
INSERT INTO config_web_forms VALUES (43, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link    FROM v_ui_element', 3);
INSERT INTO config_web_forms VALUES (15, 'v_ui_om_visit_x_node', 'SELECT visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor FROM v_ui_om_visit_x_node', 3);


