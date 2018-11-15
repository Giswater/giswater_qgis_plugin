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

INSERT INTO audit_cat_function VALUES (2510, 'gw_fct_utils_csv2pg_import_dbprices', 'edit', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2512, 'gw_fct_utils_csv2pg_import_omvisit', 'edit', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2514, 'gw_fct_utils_csv2pg_import_elements', 'edit', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2516, 'gw_fct_utils_csv2pg_import_addfields', 'edit', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2518, 'gw_fct_utils_csv2pg_export_epainp', 'epa', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2520, 'gw_fct_utils_csv2pg_import_epanet_rpt', 'epa', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2522, 'gw_fct_utils_csv2pg_import_epanet_inp', 'admin', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2524, 'gw_fct_utils_csv2pg_import_swmm_inp', 'admin', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2526, 'gw_fct_utils_csv2pg_export_epanet_inp', 'epa', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2528, 'gw_fct_utils_csv2pg_export_swmm_inp', 'epa', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2530, 'gw_fct_utils_csv2pg_import_swmm_rpt', 'epa', NULL, '', '', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2532, 'gw_fct_utils_csv2pg_import_epa_inp', 'epa', NULL, '', '', NULL, NULL, NULL);


-- 2018/11/08
INSERT INTO audit_cat_function VALUES (2534, 'gw_fct_repair_link', 'edit', NULL, '', '', NULL, NULL, NULL);


-- 2018/11/11
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('utils_csv2pg_om_visit_parameters', '{"p1", "p2", "p3"}', 'array', 'System', 'Utils');

INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dminsector', 'om', 'om_mincut_analysis_dminsector', 'role_edit');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_pipehazard', 'om', 'om_mincut_analysis_pipehazard', 'role_plan');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dinletsector', 'om', 'om_mincut_analysis_pipehazard', 'role_om');

INSERT INTO sys_fprocess_cat VALUES (34, 'Dynamic minimun sector analysis', 'EDIT', 'Mincut minimun sector analysis', 'ws');

INSERT INTO audit_cat_table VALUES ('dattrib', 'om', 'Table to store dynamic mapzones', role_om, 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('dattrib_type', 'om' 'Table to store the different types of dynamic mapzones', role_admin, 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('anl_mincut_inlet_x_arc', 'om' 'Table to arcs as a inlets', role_admin, 0, NULL, NULL, 0, NULL, NULL, NULL);


INSERT INTO dsector_type VALUES (1, dminsector, 'Dynamic mapzone defined as a minimun portion of network limited by operative valves');
INSERT INTO dsector_type VALUES (2, pipehazard, 'Dyapzone defined as district meter area');
INSERT INTO dsector_type VALUES (3, dinletsector, 'Dynamic mapzone defined as area supplied from the same inlet');


-- AUDIT CONTROL 
---------------------------------------------

ALTER TABLE SCHEMA_NAME.audit_log_project ALTER COLUMN user_name SET DEFAULT "31104"();

-- ENABLED by using the AUTOMATIC update project data schema  (LOG)
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'New parameter sys_custom_views');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'New parameter sys_currency');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'sys_fprocess_cat', TRUE, 'New process catalog to audit project data schema');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'om_visit_parameter', TRUE, 'New field ismultifeature');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'insert_plan_arc_x_pavement', TRUE, 'Bug fix on rule');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'node_type', TRUE, 'New field isarcdivide');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2510) - gw_fct_utils_csv2pg_import_dbprices');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2512) - gw_fct_utils_csv2pg_import_omvisit');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2514) - gw_fct_utils_csv2pg_import_elements');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2516) - gw_fct_utils_csv2pg_import_addfields');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2518) - gw_fct_utils_csv2pg_export_epainp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2520) - gw_fct_utils_csv2pg_import_epa_rpt');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2522) - gw_fct_utils_csv2pg_import_epanet_inp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2524) - gw_fct_utils_csv2pg_import_swmm_inp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2526) - gw_fct_utils_csv2pg_export_epanet_inp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2528) - gw_fct_utils_csv2pg_export_swmm_inp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2530) - gw_fct_utils_csv2pg_import_swmm_rpt');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2532) - gw_fct_utils_csv2pg_import_epa_inp');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New function (2534) - gw_fct_repair_link');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New parameter utils_csv2pg_om_visit_parameters');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New parameter om_mincut_analysis_dminsector');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New parameter om_mincut_analysis_pipehazard');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New parameter om_mincut_analysis_dinletsector');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New process (34) - mincut analysis dynamic minimun sector');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New process (35) - mincut analysis dynamic inlet sector');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New table - dattrib');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'audit_cat_function', TRUE, 'New table - dattrib_type');


-- NOT ALLOWED by using the AUTOMATIC update project data schema (LOG)
--INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'v_edit_node', FALSE, 'Bug fix');

ALTER TABLE SCHEMA_NAME.audit_log_project ALTER COLUMN user_name SET DEFAULT "current_user"();
