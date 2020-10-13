/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_param_user SET id = 'edit_insert_elevation_from_dem', label = 'Insert elevation from DEM:'
WHERE id = 'edit_upsert_elevation_from_dem';

UPDATE sys_param_user SET layoutorder = layoutorder+1 WHERE layoutorder > 17 AND layoutname = 'lyt_other';


INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable,  isdeprecated)
VALUES ('edit_update_elevation_from_dem', 'config', 'If true, the the elevation will be automatically updated from the DEM raster',
'role_edit', 'Update elevation from DEM:', TRUE, 18, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_other',
TRUE, FALSE) ON CONFLICT (id) DO NOTHING;


DELETE FROM sys_table WHERE id = 'config_form_groupbox';


--2020/09/15
UPDATE config_visit_parameter SET data_type = lower(data_type);

-- 2020/16/09
UPDATE config_function set layermanager = '{"visible": ["v_edit_dimensions"]}' WHERE id = 2824;

--2020/09/16
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('2998', 'gw_fct_user_check_data', 'utils', 'function','json', 'json', 
'Function to analyze data quality using queries defined by user', 'role_om', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3000', 'gw_fct_audit_log_project', 'utils', 'function','json', 'json', 
'Function that executes all check functions and copy data into statistic table (audit_fid_log)', 'role_om', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, isparametric, functionparams, inputparams, observ, active)
VALUES (2998,'User check data', TRUE, '{"featureType":[]}', 
'[{"widgetname":"checkType", "label":"Check type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["User"],"comboNames":["User"], "selectedId":"User"}]',
null, TRUE) ON CONFLICT (id) DO NOTHING;

--2020/09/17
DELETE FROM sys_param_user WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path','qgis_qml_polygonlayer_path');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3002', 'gw_fct_setplan', 'utils', 'function','json', 'json', 
'Function that returns qgis layer configuration for masterplan', 'role_master', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES ('3002', 'gw_fct_setplan','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',
'{"visible": ["v_plan_current_psector"], "zoom":{"layer":"v_plan_current_psector", "margin":20}}',null) ON CONFLICT (id) DO NOTHING;


--2020/09/24
DELETE FROM sys_function WHERE id = 2660;
DELETE FROM sys_function WHERE id = 2588;
DELETE FROM sys_function WHERE id = 2722;

--2020/09/25
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3140, 'Node is connected to arc which is involved in psector', 
	'Try replacing node with feature replace tool or disconnect it using end feature tool', 2,TRUE,'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3142, 'Node is involved in psector', 
	'Node is going to be disconnected and set to obsolete.', 1,TRUE,'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3004, 'gw_fct_setendfeature', 'utils', 'function','json', 'json', 
'Function that controls actions related to setting feature to obsolete', 'role_edit', NULL) ON CONFLICT (id) DO NOTHING;

UPDATE sys_function SET function_name='gw_fct_getcheckdelete' WHERE function_name='gw_fct_check_delete';

--2020/10/13
UPDATE sys_function SET function_name = 'gw_fct_setarcdivide' WHERE function_name='gw_fct_arc_divide';
UPDATE config_function SET  function_name = 'gw_fct_setarcdivide' WHERE function_name='gw_fct_arc_divide';