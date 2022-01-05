/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"parent_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);

--2021/12/30
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"log", "dataType":"text", "isUtils":"False"}}$$);

ALTER TABLE sys_table DROP CONSTRAINT sys_table_qgis_role_fkey;

ALTER TABLE sector DROP CONSTRAINT IF EXISTS sector_parent_id_fkey;
ALTER TABLE sector ADD CONSTRAINT sector_parent_id_fkey 
FOREIGN KEY (parent_id) REFERENCES sector (sector_id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_role", "newName":"context"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_message", "newName":"alias"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_criticity", "newName":"orderby"}}$$);
ALTER TABLE sys_table ALTER COLUMN context TYPE character varying(500);

-- 2022/01/05
ALTER TABLE config_typevalue ALTER COLUMN id TYPE character varying(50);

ALTER TABLE cat_dscenario DROP CONSTRAINT IF EXISTS cat_dscenario_expl_id_fkey;
ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);