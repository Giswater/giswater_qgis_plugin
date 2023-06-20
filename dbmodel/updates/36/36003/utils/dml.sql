/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3248, 'gw_fct_node_interpolate_massive', 'utils', 'function', 'json', 'json', 'Function to interpolate node massively', 'role_admin', NULL, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(496, 'Massive node interpolation', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;
