/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE arc_type SET active = TRUE WHERE active IS NULL;
UPDATE connec_type SET active = TRUE WHERE active IS NULL;
UPDATE node_type SET active = TRUE WHERE active IS NULL;

INSERT INTO sys_fprocess_cat VALUES (63, 'Get layers name into TOC', 'config', 'Get layer name into TOC', 'utils');

-- 01/10/2019
UPDATE audit_cat_param_user SET label = 'Keep opened edition on update feature:' WHERE id = 'cf_keep_opened_edition';

-- 03/10/2019
UPDATE audit_cat_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] from temp_table where fprocesscat_id = 63)) as id, UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] 
FROM temp_table WHERE fprocesscat_id = 63)) as idval ' WHERE id = 'cad_tools_base_layer_vdefault';
