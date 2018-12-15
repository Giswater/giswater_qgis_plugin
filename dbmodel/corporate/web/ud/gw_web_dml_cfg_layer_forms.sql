/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO config_web_forms VALUES (453, 'gully_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_gully', 3);
INSERT INTO config_web_forms VALUES (461, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 1);
INSERT INTO config_web_forms VALUES (462, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 2);
INSERT INTO config_web_forms VALUES (463, 'gully_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_gully', 3);
INSERT INTO config_web_forms VALUES (411, 'gully_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_gully', 1);
INSERT INTO config_web_forms VALUES (412, 'gully_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_gully', 2);
INSERT INTO config_web_forms VALUES (413, 'gully_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_gully', 3);
INSERT INTO config_web_forms VALUES (451, 'gully_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_gully', 1);
INSERT INTO config_web_forms VALUES (452, 'gully_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_gully', 2);
INSERT INTO config_web_forms VALUES (454, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 1);
INSERT INTO config_web_forms VALUES (455, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 2);
INSERT INTO config_web_forms VALUES (456, 'gully_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 3);
