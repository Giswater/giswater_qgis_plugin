/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"parent_id", "dataType":"integer", "isUtils":"False"}}$$);

--2021/12/30
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"log", "dataType":"text", "isUtils":"False"}}$$);

ALTER TABLE sys_table RENAME COLUMN qgis_role TO qgis_toc;
ALTER TABLE sys_table DROP CONSTRAINT sys_table_qgis_role_fkey;