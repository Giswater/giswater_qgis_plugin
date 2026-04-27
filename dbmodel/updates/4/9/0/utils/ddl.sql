/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view if exists v_ext_raster_dem;
drop view if exists v_ext_municipality;
drop view if exists v_ext_streetaxis;
drop view if exists v_ext_address;
drop view if exists v_ext_plot;


drop view if exists v_plan_result_arc;
drop view if exists v_plan_psector;
drop view if exists v_plan_current_psector;
drop view if exists v_plan_psector_budget;
drop view if exists v_plan_psector_budget_arc;
drop view if exists v_plan_psector_budget_detail;
drop view if exists v_plan_psector_all;
drop view if exists v_ui_plan_arc_cost;
drop view if exists v_plan_arc;
drop view if exists v_ui_arc_x_relations;
drop view if exists ve_inp_dscenario_connec;
drop view if exists ve_inp_connec;
drop view if exists v_ui_workcat_x_feature_end;
drop view if exists v_ui_node_x_connection_upstream;

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"data":{"action":"MULTI-DELETE"}, "feature":{"parentLayer":"ve_connec"}}$$);
drop view if exists v_edit_connec;
drop view if exists ve_connec;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_municipality", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_municipality", "column":"sector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_address", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_streetaxis", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_plot", "column":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_address", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_municipality", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_district", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_plot", "column":"plot_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_province", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_region", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"plot_code", "newName":"plot_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_address", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_streetaxis", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_district", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_plot", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_municipality", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_province", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_region", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"plot_id", "dataType":"varchar(100)"}}$$);


CREATE SEQUENCE ext_plot_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

ALTER TABLE ext_plot ALTER COLUMN id SET DEFAULT nextval('ext_plot_id_seq');
ALTER TABLE ext_streetaxis ALTER COLUMN id SET DEFAULT nextval('ext_streetaxis_id_seq');
ALTER TABLE ext_address ALTER COLUMN id SET DEFAULT nextval('ext_address_id_seq');


-- 02/04/2026
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer", "column":"customer_code", "dataType":"varchar(30)"}}$$);

-- 12/04/2026
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"state_type", "dataType":"int2"}}$$);

-- 13/04/2026
-- trgs at this point are broken, they recreate after in [ud|ws]/trg.sql
-- we disable them to avoid errors
ALTER TABLE exploitation DISABLE TRIGGER ALL;
ALTER TABLE sector DISABLE TRIGGER ALL;
ALTER TABLE macrosector DISABLE TRIGGER ALL;
ALTER TABLE dma DISABLE TRIGGER ALL;
ALTER TABLE omzone DISABLE TRIGGER ALL;
ALTER TABLE macroomzone DISABLE TRIGGER ALL;

UPDATE exploitation SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
UPDATE exploitation SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
ALTER TABLE exploitation ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE exploitation ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE exploitation ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE exploitation ALTER COLUMN sector_id SET NOT NULL;

UPDATE sector SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE sector SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE sector ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE sector ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE sector ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE sector ALTER COLUMN muni_id SET NOT NULL;

UPDATE macrosector SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE macrosector SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE macrosector ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE macrosector ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE macrosector ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE macrosector ALTER COLUMN muni_id SET NOT NULL;

UPDATE dma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE dma SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE dma SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE dma ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE dma ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE dma ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE dma ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE dma ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE dma ALTER COLUMN muni_id SET NOT NULL;

UPDATE omzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE omzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE omzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE omzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE omzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE omzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
--ALTER TABLE omzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE omzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
--ALTER TABLE omzone ALTER COLUMN muni_id SET NOT NULL;

UPDATE macroomzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE macroomzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE macroomzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE macroomzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE macroomzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE macroomzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomzone ALTER COLUMN muni_id SET NOT NULL;

ALTER TABLE exploitation ENABLE TRIGGER ALL;
ALTER TABLE sector ENABLE TRIGGER ALL;
ALTER TABLE macrosector ENABLE TRIGGER ALL;
ALTER TABLE dma ENABLE TRIGGER ALL;
ALTER TABLE omzone ENABLE TRIGGER ALL;
ALTER TABLE macroomzone ENABLE TRIGGER ALL;

-- 21/04/2026
DROP RULE IF EXISTS dma_expl ON dma;

-- 22/04/2026
ALTER TABLE om_visit
    ADD COLUMN address text,
    ADD COLUMN process_rejection_date timestamp,
    ADD COLUMN reassignment varchar(50),
    ADD COLUMN "comment" text,
    ADD COLUMN comment_extra text,
    ADD CONSTRAINT om_visit_reassignment_fkey FOREIGN KEY (reassignment) REFERENCES cat_users(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE cat_users
    ADD COLUMN mail text NULL;

-- 27/04/2026
CREATE INDEX IF NOT EXISTS idx_connec_arc_id ON connec USING btree (arc_id);
