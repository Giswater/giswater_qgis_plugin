/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (500, 'Import valve status', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (500, 'Import valve status','The csv file must have the folloWing fields:
dscenario_name, node_id, status', 'gw_fct_import_valve_status', true, null,null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3252, 'gw_fct_import_valve_status', 'ws', 'function', 'json', 'json', 'Function to import valve status', 'role_epa', null, 'core') ON CONFLICT (id) DO NOTHING;