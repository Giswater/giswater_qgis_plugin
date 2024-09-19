/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3326, 'gw_fct_graphanalytics_arrangenetwork', 'utils', 'function', NULL, 'json', 'Function to arrenge the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3328, 'gw_fct_graphanalytics_initnetwork', 'utils', 'function', NULL, 'json', 'Function to init the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3330, 'gw_fct_graphanalytics_temptables', 'utils', 'function', NULL, 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;