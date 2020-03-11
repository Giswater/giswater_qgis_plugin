/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET id = 've_config_sysfields' WHERE id = 've_config_sys_fields';
UPDATE audit_cat_function SET function_name = 'gw_api_get_widgetvalues' WHERE function_name = 'gw_api_get_widgetcontrols';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2808, 'gw_trg_edit_config_addfields', 'utils', 'trigger function', null, null, null,'Trigger to manage ve_config_addfields', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;


UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_table_id'::text, 'cat_work'::text) WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_id_field'::text, 'id'::text) WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_search_field'::text, 'id'::text) WHERE parameter = 'api_search_workcat';


UPDATE audit_cat_table SET isdeprecated = TRUE where id IN ('v_ui_workcat_polygon_all','v_ui_workcat_polygon_aux');

--2020/03/03
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (117,'Connect to network','edit','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (118,'Define addfields','edit','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (119,'Define visit class','edit','utils') ON CONFLICT (id) DO NOTHING;


--2020/03/06
INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated, standardvalue) 
VALUES ('i18n_update_mode', '0', 'system', 'Manage updates of i18n labels and tooltips. (0: update always owerwriting current values, 1: update only when value is null, 2:newer update}', 
'Update label & tooltips mode:', TRUE, 'utils', 'integer', 'linetext', true, false, '0') 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2810, 'gw_fct_admin_schema_i18n', 'utils', 'function', null, null, null,'Function to manage how the updates of tooltips and labels must be executed (overwrting old values, only when null or never', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2812, 'gw_trg_vi', 'utils', 'trigger function', null, null, null,'Trigger function to import inp files from temp_table to inp tables', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2814, 'gw_trg_gully_proximity', 'ud', 'trigger function', null, null, null,'Trigger function to control proximity againts gullys', 'role_edit',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2816, 'gw_trg_config_control', 'utils', 'trigger function', null, null, null,'Trigger to control and manage config_api_form_fields table', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2818, 'gw_fct_admin_schema_manage_triggers', 'utils', 'function', null, null, null,'Function to activate custom foreign keys of bbdd', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

--2002/03/09
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2820, 'gw_fct_getmessage', 'utils', 'function', null, null, null,'Function that manages error messages', 'role_basic',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (120,'Flow trace','om','ud') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (121,'Flow exit','om','ud') ON CONFLICT (id) DO NOTHING;

--2002/03/11
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2822, 'gw_fct_manage_roles', 'utils', 'function', null, null, null,'Function to manage system roles', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

--update audit_cat_param_user with cat_feature vdefaults
UPDATE cat_feature SET id=id;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2824, 'gw_fct_debug', 'utils', 'function', null, null, null,'Function to manage debugs', 'role_edit',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2826, 'gw_fct_grafanalytics_lrs', 'utils', 'function', null, null, null,'Grafanalytics using LRS', 'role_edit',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_param_user(id, formname, descript, sys_role_id, label, isenabled, layoutname, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated, vdefault)
VALUES ('debug_mode',null,'Variable to configure the debug mode of user',
'role_basic', 'Debug mode:', true, null, null,'utils',false, false, 'json','text',true, false, '{"status":FALSE, "mode":"NOTICE"}');

