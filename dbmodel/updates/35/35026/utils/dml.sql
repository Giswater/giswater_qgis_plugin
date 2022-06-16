/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
UPDATE sys_fprocess SET fprocess_type='Function process' WHERE fprocess_type='"Function process"';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (453, 'Node planified duplicated', 'utils', null, 'core', true, 'Check plan-data', null) ON CONFLICT (fid) DO NOTHING;

--2022/06/09
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(454, 'Check node_1 and node_2 on temp_table', 'utils', NULL, 'core', true, 'Function process', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3152, 'gw_fct_admin_reset_sequences', 'utils', 'function', null, 'json', 'Function for reserting ids and sequences for audit, anl and temp tables', 
'role_admin','core')
ON CONFLICT (id) DO NOTHING;

--2022/06/16
INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3154, 'gw_fct_settopology', 'utils', 'function', null, 'json', 'Function for reset topology by using node ids', 
'role_edit','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, project_type)
VALUES ('admin_message_debug','false','It allows debug on message with more detailed log', 'utils');
