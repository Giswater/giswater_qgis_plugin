/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/05
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_workspace", "column":"cur_user", "dataType":"text", "isUtils":"False"}}$$);
ALTER TABLE cat_workspace ALTER COLUMN cur_user SET DEFAULT "current_user"();

ALTER TABLE temp_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE temp_arc ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE temp_arc ALTER COLUMN state DROP NOT NULL;

ALTER TABLE temp_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE temp_node ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE temp_node ALTER COLUMN state DROP NOT NULL;
