/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO minsector (minsector_id) VALUES(0) ON CONFLICT (minsector_id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3530, 'gw_fct_exception_others', 'utils', 'function', 'text, text, text, text, text', 'json', 'Function to return exception information.', NULL, NULL, 'core', NULL);
