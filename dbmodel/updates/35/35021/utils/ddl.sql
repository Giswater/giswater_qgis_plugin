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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"sys_criticity", "newName":"criticity"}}$$);
UPDATE sys_table SET criticity=NULL;
UPDATE sys_table SET criticity=qgis_criticity;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_role", "newName":"context"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_message", "newName":"alias"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_criticity", "newName":"orderby"}}$$);
ALTER TABLE sys_table ALTER COLUMN context TYPE character varying(500);

-- 2022/01/05
ALTER TABLE config_typevalue ALTER COLUMN id TYPE character varying(50);

ALTER TABLE cat_dscenario DROP CONSTRAINT IF EXISTS cat_dscenario_expl_id_fkey;
ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_dscenario DROP CONSTRAINT IF EXISTS cat_dscenario_parent_id_fkey;
ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_parent_id_fkey FOREIGN KEY (parent_id) 
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);

ALTER TABLE rpt_cat_result DROP CONSTRAINT IF EXISTS rpt_cat_result_expl_id_fkey;
ALTER TABLE rpt_cat_result ADD CONSTRAINT rpt_cat_result_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE selector_inp_dscenario DROP CONSTRAINT inp_selector_dscenario_dscenario_id_fkey;
ALTER TABLE selector_inp_dscenario ADD CONSTRAINT inp_selector_dscenario_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_plan_result DROP CONSTRAINT plan_result_selector_result_id_fk;
ALTER TABLE selector_plan_result ADD CONSTRAINT plan_result_selector_result_id_fk FOREIGN KEY (result_id) 
REFERENCES plan_result_cat (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"isaudit", "dataType":"boolean", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"pavcat_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);

UPDATE arc a SET pavcat_id = p.pavcat_id FROM plan_arc_x_pavement p WHERE percent = 1 AND p.arc_id = a.arc_id;

DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;

ALTER TABLE arc ADD CONSTRAINT arc_pavcat_id_fkey FOREIGN KEY (pavcat_id) 
REFERENCES cat_pavement (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;