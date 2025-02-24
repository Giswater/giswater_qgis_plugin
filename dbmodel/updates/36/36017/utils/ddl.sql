/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"streetname2", "dataType":"varchar(100)"}}$$);

CREATE TABLE selector_macroexpl (
macroexpl_id integer,
cur_user text default current_user);

ALTER TABLE selector_macroexpl ADD CONSTRAINT selector_macroexpl_pkey PRIMARY KEY (macroexpl_id,cur_user);

CREATE TABLE selector_macrosector (
macrosector_id integer,
cur_user text default current_user);

ALTER TABLE selector_macrosector ADD CONSTRAINT selector_macrosector_pkey PRIMARY KEY (macrosector_id,cur_user);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);

-- 07/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"dimensions", "column":"workcat_id", "dataType":"varchar(255)", "isUtils":"False"}}$$);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- 12/02/2025
ALTER TABLE element ALTER COLUMN muni_id DROP NOT NULL;
ALTER TABLE element ALTER COLUMN sector_id DROP NOT NULL;

-- 17/02/2025
DROP FUNCTION IF EXISTS gw_trg_edit_foreignkey() CASCADE;
