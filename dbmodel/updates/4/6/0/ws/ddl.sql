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

-- 12/11/2025
-- Drop constraints to avoid errors
ALTER TABLE rtc_hydrometer_x_connec DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_connec_hydrometer_id_fkey;
ALTER TABLE rtc_hydrometer_x_node DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_node_hydrometer_id_fkey;

-- Drop views to avoid errors
DROP VIEW IF EXISTS v_rtc_hydrometer;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node;
DROP VIEW IF EXISTS v_ui_mincut_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_hydrometer;
DROP VIEW IF EXISTS v_ui_hydroval_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval;
DROP VIEW IF EXISTS ve_rtc_hydro_data_x_connec;
DROP VIEW IF EXISTS v_om_mincut_current_hydrometer;

-- Add link column to ext_rtc_hydrometer table
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer", "column":"link", "dataType":"text", "isUtils":"False"}}$$);

-- Create sequence and add constraint to ext_rtc_hydrometer table
CREATE SEQUENCE ext_rtc_hydrometer_hydrometer_id_seq;
ALTER TABLE ext_rtc_hydrometer ADD CONSTRAINT ext_rtc_hydrometer_code_unique UNIQUE (code);

-- Update code column to id column
UPDATE ext_rtc_hydrometer SET code = id;

-- Create constraints to autoupdate the hydrometer_id column
ALTER TABLE ext_rtc_hydrometer_x_data ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_connec ADD CONSTRAINT rtc_hydrometer_x_connec_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_node ADD CONSTRAINT rtc_hydrometer_x_node_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Update id column to the new sequence
UPDATE ext_rtc_hydrometer SET id = concat(id, '_temp');
UPDATE ext_rtc_hydrometer SET id = nextval('ext_rtc_hydrometer_hydrometer_id_seq');

-- Insert new records into ext_rtc_hydrometer table
INSERT INTO ext_rtc_hydrometer (id, code, link)
SELECT nextval('ext_rtc_hydrometer_hydrometer_id_seq'), hydrometer_id, link FROM rtc_hydrometer
ON CONFLICT (code) DO UPDATE SET link = EXCLUDED.link;

-- Drop rtc_hydrometer table
DROP TABLE IF EXISTS rtc_hydrometer;

-- Insert new records into rtc_hydrometer_x_connec table
INSERT INTO rtc_hydrometer_x_connec (hydrometer_id, connec_id)
SELECT id, connec.connec_id
FROM ext_rtc_hydrometer
	JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
ON CONFLICT (hydrometer_id) DO UPDATE SET connec_id = EXCLUDED.connec_id;

ALTER TABLE rtc_hydrometer_x_node ADD CONSTRAINT rtc_hydrometer_x_node_unique UNIQUE (node_id, hydrometer_id);

-- Insert new records into rtc_hydrometer_x_node table
INSERT INTO rtc_hydrometer_x_node (hydrometer_id, node_id)
SELECT id, node.node_id
FROM ext_rtc_hydrometer
	JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
    JOIN node ON node.node_id = man_netwjoin.node_id
ON CONFLICT (hydrometer_id, node_id) DO UPDATE SET node_id = EXCLUDED.node_id;

-- Drop connec_id column from ext_rtc_hydrometer table
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_hydrometer", "column":"connec_id", "isUtils":"False"}}$$);

-- Rename id column to hydrometer_id
ALTER TABLE ext_rtc_hydrometer RENAME COLUMN id TO hydrometer_id;

-- Drop constraints to avoid errors
ALTER TABLE ext_rtc_hydrometer_x_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE om_mincut_hydrometer DROP CONSTRAINT IF EXISTS om_mincut_hydrometer_hydrometer_id_fkey;
ALTER TABLE rtc_hydrometer_x_connec DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_connec_hydrometer_id_fkey;
ALTER TABLE rtc_hydrometer_x_node DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_node_hydrometer_id_fkey;

-- Alter columns to int4
ALTER TABLE ext_rtc_hydrometer ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE rtc_hydrometer_x_node ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE om_mincut_hydrometer ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE ext_rtc_hydrometer_x_data ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;

-- Set default value to the new sequence
ALTER TABLE ext_rtc_hydrometer ALTER COLUMN hydrometer_id SET DEFAULT nextval('ext_rtc_hydrometer_hydrometer_id_seq');

-- Create constraints to autoupdate the hydrometer_id column
ALTER TABLE rtc_hydrometer_x_connec ADD CONSTRAINT rtc_hydrometer_x_connec_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_node ADD CONSTRAINT rtc_hydrometer_x_node_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ext_rtc_hydrometer_x_data ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Drop selector_hydrometer table
DROP TABLE IF EXISTS selector_hydrometer;
