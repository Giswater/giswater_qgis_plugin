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
VALUES (3160,'gw_fct_graphanalytics_hidrant','ws','function','json','json','Function to create influence buffer for hidrants.','role_om','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3162,'gw_fct_graphanalytics_hidrant_recursive','ws','function','json','json','Function to create influence buffer for hidrants.','role_om','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3160, 'Calculate the reach of hydrants', '{"featureType":["node"]}', 
'[{"widgetname":"distance", "label":"Firehose range:", "widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":1,"value":200}]',
'Function requires street data inserted on table om_streetaxis, where each street is divided into short lines between intersections.', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES ('3160','gw_fct_graphanalytics_hidrant','{"style":{"point":{"style":"unique", "values":{"width":3.5, "color":[255,165,1], "transparency":1}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":1}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null,null) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (463, 'Graph analysis for hydrants', 'ws',null, 'core', false, 'Function process',null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (464, 'Graph analysis for hydrants - marking crossroads', 'ws',null, 'core', false, 'Function process',null) ON CONFLICT (fid) DO NOTHING;
