/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','NETWORK','NETWORK');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3308, 'gw_fct_admin_create_message', 'utils', 'function', 'json', 'json', 'Function to create sys_message efficiently', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;
