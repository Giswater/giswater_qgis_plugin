/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/05
UPDATE arc SET inverted_slope = FALSE WHERE inverted_slope IS NULL;

DELETE FROM sys_param_user WHERE id = 'inp_scenario_dwf';
DELETE FROM sys_param_user WHERE id = 'inp_scenario_hydrology';

DELETE FROM config_param_user WHERE parameter = 'inp_scenario_dwf';
DELETE FROM config_param_user WHERE parameter = 'inp_scenario_hydrology';

UPDATE sys_function SET function_name = 'gw_fct_copy_dscenario_values', function_type  ='function',  input_params='json', return_type = 'json', project_type = 'utils' WHERE id = 3042;

INSERT INTO sys_fprocess VALUES (398, 'Copy EPA hydrology values)', 'ud') ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess VALUES (399, 'Copy EPA DWF values)', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3100', 'gw_fct_copy_hydrology_values', 'ud', 'function','json', 'json', 
'Function to copy values from one hydrology catalog to other one', 'role_epa', NULL) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3102', 'gw_fct_copy_dwf_values', 'ud', 'function','json', 'json', 
'Function to copy values from one dwf catalog to other one', 'role_epa', NULL) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3100,'Copy hydrology values', '{"featureType":[]}', 
'[{"widgetname":"source", "label":"Source:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology JOIN v_edit_inp_subcatchment USING (hydrology_id) WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":1, "selectedId":""},
  {"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology JOIN v_edit_inp_subcatchment USING (hydrology_id) WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":2, "selectedId":"$userHydrology"}
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3102,'Copy DWF values', '{"featureType":[]}', 
'[{"widgetname":"source", "label":"Source:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT d.id, idval FROM cat_dwf_scenario c JOIN v_edit_inp_dwf d ON dwfscenario_id = d.id WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
  {"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT d.id, idval FROM cat_dwf_scenario c JOIN v_edit_inp_dwf d ON dwfscenario_id = d.id WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userDwf"}
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_fprocess VALUES (401, 'Y0 higger than ymax on nodes)', 'ud')
ON CONFLICT (fid) DO NOTHING;


INSERT INTO config_param_system (parameter, value, descript, standardvalue, isenabled, project_type) VALUES(
'epa_automatic_man2inp_values', 
'{"status":false, "values":[
{"source":{"table":"ve_node_outfall", "column":"min_height"}, "target":{"table":"inp_storage", "column":"y0"}}]}',
'Before trigger go2epa, automatic loop updating values on inp tables',
'{"status":false}'
, FALSE, 'ws')
ON CONFLICT (parameter) DO NOTHING;
