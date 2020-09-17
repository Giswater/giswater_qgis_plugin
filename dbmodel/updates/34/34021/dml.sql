/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/17/09
UPDATE sys_param_user SET dv_querytext =$$SELECT UNNEST(ARRAY (select (text_column::json->>'list_tables_name')::text[] from temp_table where fid =163 and cur_user = current_user)) as id, 
UNNEST(ARRAY (select (text_column::json->>'list_layers_name')::text[] FROM temp_table WHERE fid = 163 and cur_user = current_user)) as idval $$ WHERE id = 'edit_cadtools_baselayer_vdefault';
