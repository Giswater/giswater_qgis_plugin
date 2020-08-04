/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14
UPDATE config_param_system SET project_type = 'ws' WHERE parameter = 'om_mincut_enable_alerts';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2988, 'gw_fct_getmincut', 'ws', 'function', 'json', 'json', 'Get mincut values', 'role_ws');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2990, 'gw_fct_setmincutstart', 'ws', 'function', 'json', 'json', 'Set mincut start', 'role_ws');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2992, 'gw_fct_setmincutend', 'ws', 'function', 'json', 'json', 'Set mincut end', 'role_ws');