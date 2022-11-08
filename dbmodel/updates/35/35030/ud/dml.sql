/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/29
INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('temp_lid_usage', 'Table used during pg2epa export for lid usage configuration', 'role_epa','core') ON CONFLICT (id) DO NOTHING;
 
UPDATE config_param_system set value = 
json_build_object('activated', value,'updateField','top_elev')::text WHERE parameter='admin_raster_dem';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (477, 'Control of sections inconsistencies between consecutive conduits', 'ud', NULL, 'core', true, 'Function process', NULL);

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source,input_params,return_type)
VALUES (3176, 'gw_graphanalytics_upstream_section_control', 'ud', 'function', 
'Control of sections inconsistencies between consecutive conduits.
Select a node in order to execute upstream analysis of conduits sections and detect inconsistencies.', 'role_edit', 'core', 'json', 'json');

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3176, 'Control conduit sections', '{"featureType":["node"]}', 
'[{"widgetname":"node", "label":"Node:", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "value":null}]', null, true);

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES (3176, 'gw_graphanalytics_upstream_section_control', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null, null);

UPDATE config_param_system SET value=value::jsonb || '{"node":"SELECT node_id AS node_id, code AS code FROM v_edit_node"}' WHERE parameter='om_profile_guitartext';