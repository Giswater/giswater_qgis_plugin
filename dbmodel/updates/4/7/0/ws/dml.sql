/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 05/01/2026
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3528, 'gw_fct_get_epa_result_families', 'ws', 'function', 'text, integer', 'json', 'Function to get json with EPA result families.', NULL, NULL, 'core', NULL);
