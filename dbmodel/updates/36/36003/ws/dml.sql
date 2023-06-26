/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3250, 'gw_trg_edit_minsector', 'ws', 'trigger function', NULL, NULL, 'Allows editing minsector view', 'role_edit', NULL, 'core');

UPDATE sys_style SET idval = 'v_edit_minsector' WHERE  idval = 'v_minsector';
UPDATE sys_table SET id = 'v_edit_minsector' WHERE  id = 'v_minsector';
UPDATE config_function SET layermanager = '{"visible": ["v_edit_minsector"]}' WHERE  id = 2706;
