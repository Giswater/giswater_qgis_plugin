/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/09
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_report", "column":"sys_role", "dataType":"text", "isUtils":"False"}}$$);

--2022/03/26
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_workspace", "column":"private", "dataType":"BOOLEAN"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraf", "column":"isheader", "dataType":"BOOLEAN"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"polygon", "column":"state", "dataType":"int2"}}$$);
ALTER TABLE polygon ALTER COLUMN state SET DEFAULT 1;


