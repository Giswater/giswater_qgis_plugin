/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/12/20
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (107,'Role upsertuser','admin','Role upsertuser','utils') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function set function_name = 'fct_plan_check_data' WHERE id = 2436;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2788, 'gw_api_get_widgetcontrols', 'api', 'function', 'Api function to manage widgetcontrols', 'role_om', false, false, null,false);


-- 2019/12/23
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (108,'Nodes ischange without change of dn/pn/material','edit','Nodes ischange without change of dn/pn/material','ws') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (109,'Change of dn/pn/material without node ischange','edit','Change of dn/pn/material without node ischange','ws') ON CONFLICT (id) DO NOTHING;


-- 2020/01/07
INSERT INTO audit_cat_param_user VALUES 
('audit_project_epa_result', 'config', 'Id of EPA results to analyze when audit check project function', 'role_epa', NULL, NULL, 'EPA result to check database on load project', NULL, NULL, true, 8, 14, 'utils', false, NULL, NULL, NULL, 
false, 'string', 'text', true, NULL, 'gw_check_project', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_param_user VALUES 
('audit_project_plan_result', 'config', 'Id of PLAN results to analyze when audit check project function', 'role_master', NULL, NULL, 'PLAN result to check database on load project', NULL, NULL, true, 8, 15, 'utils', false, NULL, NULL, NULL, 
false, 'string', 'text', true, NULL, 'gw_check_project', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

UPDATE config_param_system SET standardvalue = 'FALSE' WHERE parameter IN ('edit_enable_arc_nodes_update','edit_topocontrol_dsbl_error', 'sys_raster_dem', 'geom_slp_direction', 'sys_exploitation_x_user');
UPDATE config_param_system SET standardvalue = 'TRUE' WHERE parameter IN ('state_topocontrol');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (110,'Connecs with customer code null','edit','Connecs with customer code null','utils') ON CONFLICT (id) DO NOTHING;


--2019/12/23
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='arc_id' AND formname LIKE 've_arc%';
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='node_id' AND formname LIKE 've_node%';
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='connec_id' AND formname LIKE 've_connec%';

UPDATE config_param_system SET context='api_search_visit' WHERE parameter='api_search_visit';