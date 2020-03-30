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

--2020/03/03
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (117,'Connect to network','edit','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (118,'Define addfields','edit','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (119,'Define visit class','edit','utils') ON CONFLICT (id) DO NOTHING;


--2020/03/06
INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated, standardvalue) 
VALUES ('i18n_update_mode', '1', 'system', 'Manage updates of i18n labels and tooltips. (0: update always owerwriting current values, 1: update only when value is null, 2:newer update}', 
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
VALUES (2826, 'gw_fct_grafanalytics_lrs', 'utils', 'function', null, null, null,'Grafanalytics using LRS', 'role_edit',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_param_user(id, formname, descript, sys_role_id, label, isenabled, layoutname, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated, vdefault)
VALUES ('debug_mode',null,'Variable to configure the debug mode of user',
'role_basic', 'Debug mode:', true, null, null,'utils',false, false, 'boolean','text',true, false, 'false');

-- 2020/03/12
UPDATE audit_cat_param_user SET layoutname = 'lyt_basic' WHERE layout_id = 1 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_om' WHERE layout_id = 2 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' WHERE layout_id = 3 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_mapzones' WHERE layout_id = 4 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_edit' WHERE layout_id = 5 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_epa' WHERE layout_id = 6 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_masterplan' WHERE layout_id = 7 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' WHERE layout_id = 8 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_node_vdef' WHERE layout_id = 9 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_arc_vdef' WHERE layout_id = 10 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_utils_vdef' WHERE layout_id = 11 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_connec_gully_vdef' WHERE layout_id = 12 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_topology' WHERE layout_id = 13 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_builder' WHERE layout_id = 14 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_review' WHERE layout_id = 15 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_analysis' WHERE layout_id = 16 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_system' WHERE layout_id = 17 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_fluid_type' WHERE layout_id = 18 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_location_type' WHERE layout_id = 19 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_category_type' WHERE layout_id = 20 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_function_type' WHERE layout_id = 21 AND formname = 'config';
UPDATE audit_cat_param_user SET layoutname = 'lyt_addfields' WHERE layout_id = 22 AND formname = 'config';

UPDATE config_param_system SET layoutname = 'lyt_topology' WHERE layout_id = 13;
UPDATE config_param_system SET layoutname = 'lyt_builder' WHERE layout_id = 14;
UPDATE config_param_system SET layoutname = 'lyt_review' WHERE layout_id = 15;
UPDATE config_param_system SET layoutname = 'lyt_analysis' WHERE layout_id = 16;
UPDATE config_param_system SET layoutname = 'lyt_system' WHERE layout_id = 17;

UPDATE audit_cat_function set sample_query =
'{"WS":{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{"type":"NODE"},"data":{"old_feature_id":"node_id","workcat_id_end":"work1", "enddate":"2019-05-17","keep_elements":true }},
"UD":{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{"type":"NODE"},"data":{"old_feature_id":"node_id","workcat_id_end":"work1", "enddate":"2019-05-17","keep_elements":true }}}'
where function_name = 'gw_fct_feature_replace';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2824, 'gw_api_getdimensioning', 'utils', 'function', null, null, null,'Function to show dimensioning form of api', 'role_basic',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_param_user SET id = 'statetype_0_vdefault' WHERE id = 'statetype_end_vdefault';
UPDATE audit_cat_param_user SET id = 'statetype_1_vdefault' WHERE id = 'statetype_vdefault';
UPDATE audit_cat_param_user SET id = 'statetype_2_vdefault' WHERE id = 'statetype_plan_vdefault';

UPDATE config_param_user SET parameter = 'statetype_0_vdefault' WHERE parameter = 'statetype_end_vdefault';
UPDATE config_param_user SET parameter = 'statetype_1_vdefault' WHERE parameter = 'statetype_vdefault';
UPDATE config_param_user SET parameter = 'statetype_2_vdefault' WHERE parameter = 'statetype_plan_vdefault';