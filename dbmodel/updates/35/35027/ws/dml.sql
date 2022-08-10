/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/11

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(462, 'Planified EPANET pumps with more than two acs', 'ws', NULL, 'core', true, 'Check plan-data', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3160,'gw_fct_graphanalytics_hydrant','ws','function','json','json','Function to create influence buffer for hydrants.','role_om','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3162,'gw_fct_graphanalytics_hydrant_recursive','ws','function','json','json','Function to create influence buffer for hydrants.','role_om','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3160, 'Calculate the reach of hydrants', '{"featureType":["node"]}', 
'[{"widgetname":"distance", "label":"Firehose range:", "widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":"1","value":"100"},
{"widgetname":"mode", "label":"Process mode:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":"2","comboIds":["0","1"],"comboNames":["Influence area","Hydrant proposal"], "selectedId":"0"},
{"widgetname":"useProposal", "label":"Use proposed hydrants:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"3", "value":""}]',
'Function requires street data inserted on table om_streetaxis, where each street is divided into short lines between intersections.', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES ('3160','gw_fct_graphanalytics_hydrant','{"style":{"point":{"style":"unique", "values":{"width":3.5, "color":[255,165,1], "transparency":1}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":1}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null,null) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (463, 'Graph analysis for hydrants', 'ws',null, 'core', false, 'Function process',null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (464, 'Graph analysis for hydrants - marking crossroads', 'ws',null, 'core', false, 'Function process',null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (465, 'Graph analysis for hydrants - hydrant proposal', 'ws',null, 'core', false, 'Function process',null) ON CONFLICT (fid) DO NOTHING;

UPDATE config_param_system SET parameter='utils_graphanalytics_automatic_config' WHERE parameter ='utils_grafanalytics_automatic_config';
UPDATE config_param_system SET parameter='utils_graphanalytics_automatic_trigger' WHERE parameter ='utils_grafanalytics_automatic_trigger';
UPDATE config_param_system SET parameter='utils_graphanalytics_custom_geometry_constructor' WHERE parameter ='utils_grafanalytics_custom_geometry_constructor';
UPDATE config_param_system SET parameter='utils_graphanalytics_dynamic_symbology' WHERE parameter ='utils_grafanalytics_dynamic_symbology';
UPDATE config_param_system SET parameter='utils_graphanalytics_lrs_feature' WHERE parameter ='utils_grafanalytics_lrs_feature';
UPDATE config_param_system SET parameter='utils_graphanalytics_lrs_graf' WHERE parameter ='utils_grafanalytics_lrs_graph';
UPDATE config_param_system SET parameter='utils_graphanalytics_status' WHERE parameter ='utils_grafanalytics_status';
UPDATE config_param_system SET parameter='utils_graphanalytics_vdefault' WHERE parameter ='utils_grafanalytics_vdefault';

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3164,'gw_trg_edit_anl_hydrant','ws','trigger function','json','json','Function trigger to edit proposed hidrant layer - v_edit_anl_hydrant.',
'role_om','core') ON CONFLICT (id) DO NOTHING;