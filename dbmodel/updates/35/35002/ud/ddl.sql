/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dwf_scenario", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_dwf_scenario ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_hydrology", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_hydrology ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_mat_grate", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_mat_grate ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_mat_gully", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_mat_gully ALTER COLUMN active SET DEFAULT TRUE;