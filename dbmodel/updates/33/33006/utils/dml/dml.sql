/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 11/10/2019
UPDATE config_param_user SET parameter = 'qgis_toolbar_hide_actions', value = '{"actions_index":[199,74,75,76]}' WHERE parameter = 'actions_to_hide';

UPDATE audit_cat_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] from temp_table where fprocesscat_id = 63 and user_name = current_user)) as id, UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] 
FROM temp_table WHERE fprocesscat_id = 63 and user_name = current_user)) as idval ' WHERE id = 'cad_tools_base_layer_vdefault';

-- 14/10/2019
INSERT INTO sys_fprocess_cat VALUES (64, 'Nodes without elevation', 'epa', 'Nodes without elevation', 'ws');
INSERT INTO sys_fprocess_cat VALUES (65, 'Nodes with elevation=0', 'epa', 'Nodes with elevation=0', 'ws');
INSERT INTO sys_fprocess_cat VALUES (66, 'Node2arc with more than two arcs', 'epa', 'Node2arc with more than two arcs', 'ws');
INSERT INTO sys_fprocess_cat VALUES (67, 'Node2arc with less than two arcs', 'epa', 'Node2arc with less than two arcs', 'ws');

