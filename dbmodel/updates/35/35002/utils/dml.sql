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
UPDATE sys_param_user SET dv_querytext =$$SELECT UNNEST(ARRAY (select (text_column::json->>'list_tables_name')::text[] from temp_table where fid =163 and cur_user = current_user)) as id, 
UNNEST(ARRAY (select (text_column::json->>'list_layers_name')::text[] FROM temp_table WHERE fid = 163 and cur_user = current_user)) as idval $$ WHERE id = 'edit_cadtools_baselayer_vdefault';

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
