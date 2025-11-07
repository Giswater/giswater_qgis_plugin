/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
DROP VIEW IF EXISTS ve_plan_netscenario_dma;
DROP VIEW IF EXISTS ve_plan_netscenario_presszone;

ALTER TABLE plan_netscenario_dma RENAME COLUMN expl_id2 TO expl_id;
ALTER TABLE plan_netscenario_dma ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE plan_netscenario_dma ADD muni_id _int4 NULL;
ALTER TABLE plan_netscenario_dma ADD sector_id _int4 NULL;

ALTER TABLE plan_netscenario_presszone RENAME COLUMN expl_id2 TO expl_id;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE plan_netscenario_presszone ADD muni_id _int4 NULL;
ALTER TABLE plan_netscenario_presszone ADD sector_id _int4 NULL;

ALTER TABLE om_mincut
ADD CONSTRAINT chk_forecast_order
CHECK (
  forecast_end >= forecast_start
);

ALTER TABLE om_mincut
ADD CONSTRAINT chk_exec_order
CHECK (
  exec_end >= exec_start
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"uncertain", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"uncertain", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"uncertain", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE node ALTER COLUMN dma_id SET DEFAULT 0;
ALTER TABLE node ALTER COLUMN dqa_id SET DEFAULT 0;
ALTER TABLE node ALTER COLUMN presszone_id SET DEFAULT 0;
ALTER TABLE node ALTER COLUMN supplyzone_id SET DEFAULT 0;
ALTER TABLE node ALTER COLUMN omzone_id SET DEFAULT 0;
ALTER TABLE node ALTER COLUMN minsector_id SET DEFAULT 0;
ALTER TABLE arc ALTER COLUMN minsector_id SET DEFAULT 0;

DROP VIEW IF EXISTS v_ui_macrodma;
DROP VIEW IF EXISTS ve_macrodma;
DROP VIEW IF EXISTS v_ui_supplyzone;
DROP VIEW IF EXISTS ve_supplyzone;
DROP VIEW IF EXISTS v_ui_presszone;
DROP VIEW IF EXISTS ve_presszone;
DROP VIEW IF EXISTS v_ui_dqa;
DROP VIEW IF EXISTS ve_dqa;
DROP VIEW IF EXISTS v_ui_macrodqa;
DROP VIEW IF EXISTS ve_macrodqa;

ALTER TABLE macrodma ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macrodma ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macrodma ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE supplyzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE supplyzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE supplyzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE presszone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE presszone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE presszone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE dqa ALTER COLUMN code TYPE varchar(100);
ALTER TABLE dqa ALTER COLUMN name TYPE varchar(100);
ALTER TABLE dqa ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE macrodqa ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macrodqa ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macrodqa ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE macrocrmzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macrocrmzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macrocrmzone ALTER COLUMN descript TYPE varchar(255);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"xyz_date", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"xyz_date", "dataType":"date", "isUtils":"False"}}$$);

-- 07/11/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"reagent_lot", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"equipment_code", "dataType":"varchar(50)", "isUtils":"False"}}$$);
