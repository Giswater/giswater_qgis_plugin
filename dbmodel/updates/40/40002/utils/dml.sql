/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_function SET descript='Check topology assistant. Analyze and validate the length of arcs for potential inconsistencies or errors.' WHERE id=3052;

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb, addparam = '{"pkey": "element_id"}' WHERE id='ve_genelem';

-- 03/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3482, 'gw_fct_graphanalytics_macromapzones', 'utils', 'function', 'json', 'json', 'Function to analyze network as a macro graph.', 'role_om', NULL, 'core', NULL);

DELETE FROM config_form_fields where columnname='undelete';
