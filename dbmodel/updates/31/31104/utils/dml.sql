/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2018/10/28
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('sys_custom_views', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('sys_currency', '{"id":"EUR", "descript":"EURO", "symbol":€"}', 'Boolean', 'System', 'Utils');

-- 2018/11/03
INSERT INTO sys_fprocess_cat VALUES (33, 'Update project data schema', 'System', 'Project data schema', 'utils');



-- AUDIT CONTROL 
---------------------------------------------

ALTER TABLE ws_sample.audit_log_project ALTER COLUMN user_name SET DEFAULT "31104"();

-- ENABLED by using the AUTOMATIC update project data schema  (LOG)
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'New parameter sys_custom_views');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'New parameter sys_currency');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'sys_fprocess_cat', TRUE, 'New process catalog to audit project data schema');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'om_visit_parameter', TRUE, 'New field ismultifeature');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'insert_plan_arc_x_pavement', TRUE, 'Bug fix on rule');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'node_type', TRUE, 'New field isarcdivide');

-- NOT ALLOWED by using the AUTOMATIC update project data schema (LOG)
--INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'v_edit_node', FALSE, 'Bug fix');

ALTER TABLE ws_sample.audit_log_project ALTER COLUMN user_name SET DEFAULT "current_user"();
