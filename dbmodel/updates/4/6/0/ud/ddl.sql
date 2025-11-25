/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
ALTER TABLE link ALTER COLUMN omunit_id SET DEFAULT 0;

DROP TABLE IF EXISTS macroomunit;
CREATE TABLE macroomunit (
    macroomunit_id serial4 NOT NULL,
    node_1 int4,
    node_2 int4,
    is_way_in bool,
    is_way_out bool,
    the_geom geometry(linestring, SRID_VALUE),
    expl_id _int4,
    muni_id _int4,
    sector_id _int4,
    catchment_node integer,
    order_number INTEGER DEFAULT 0,
    CONSTRAINT macroomunit_pkey PRIMARY KEY (macroomunit_id),
    CONSTRAINT macroomunit_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT macroomunit_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS omunit;
CREATE TABLE omunit (
    omunit_id serial4 NOT NULL,
    node_1 int4,
    node_2 int4,
    is_way_in bool,
    is_way_out bool,
    macroomunit_id integer DEFAULT 0,
    order_number integer DEFAULT 0,
    the_geom geometry(linestring, SRID_VALUE),
    expl_id _int4,
    muni_id _int4,
    sector_id _int4,
    CONSTRAINT omunit_pkey PRIMARY KEY (omunit_id),
    CONSTRAINT omunit_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT omunit_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT omunit_macroomunit_id_fkey FOREIGN KEY (macroomunit_id) REFERENCES macroomunit(macroomunit_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP VIEW IF EXISTS v_ui_dwfzone;
DROP VIEW IF EXISTS ve_dwfzone;
DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS ve_drainzone;

ALTER TABLE dwfzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE dwfzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE dwfzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE drainzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE drainzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE drainzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE node ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE arc ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE connec ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE gully ALTER COLUMN treatment_type SET DEFAULT 0;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"xyz_date", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"xyz_date", "dataType":"date", "isUtils":"False"}}$$);

-- 12/11/2025
-- Drop constraints to avoid errors
ALTER TABLE IF EXISTS rtc_hydrometer_x_connec DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_connec_hydrometer_id_fkey;

-- Drop views to avoid errors
DROP VIEW IF EXISTS v_ui_hydroval_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval;
DROP VIEW IF EXISTS ve_rtc_hydro_data_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;

-- Add link column to ext_rtc_hydrometer table
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer", "column":"link", "dataType":"text", "isUtils":"False"}}$$);

-- Create sequence and add constraint to ext_rtc_hydrometer table
CREATE SEQUENCE ext_rtc_hydrometer_hydrometer_id_seq;
ALTER TABLE ext_rtc_hydrometer ADD CONSTRAINT ext_rtc_hydrometer_code_unique UNIQUE (code);

-- Update code column to id column
UPDATE ext_rtc_hydrometer SET code = id;

-- Create constraints to autoupdate the hydrometer_id column
ALTER TABLE ext_rtc_hydrometer_x_data ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_connec ADD CONSTRAINT rtc_hydrometer_x_connec_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(id) ON UPDATE CASCADE ON DELETE CASCADE;

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
ALTER TABLE rtc_hydrometer_x_connec
ADD CONSTRAINT rtc_hydrometer_x_connec_unique
UNIQUE (connec_id, hydrometer_id);

INSERT INTO rtc_hydrometer_x_connec (hydrometer_id, connec_id)
SELECT id, connec.connec_id
FROM ext_rtc_hydrometer
	JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
ON CONFLICT (hydrometer_id) DO UPDATE SET connec_id = EXCLUDED.connec_id;

-- Drop connec_id column from ext_rtc_hydrometer table
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_hydrometer", "column":"connec_id", "isUtils":"False"}}$$);

-- Rename id column to hydrometer_id
ALTER TABLE IF EXISTS ext_rtc_hydrometer RENAME COLUMN id TO hydrometer_id;

-- Drop constraints to avoid errors
ALTER TABLE ext_rtc_hydrometer_x_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE rtc_hydrometer_x_connec DROP CONSTRAINT IF EXISTS rtc_hydrometer_x_connec_hydrometer_id_fkey;

-- Alter columns to int4
ALTER TABLE ext_rtc_hydrometer ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE ext_rtc_hydrometer_x_data ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;
ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN hydrometer_id TYPE int4 USING hydrometer_id::integer;

-- Set default value to the new sequence
ALTER TABLE ext_rtc_hydrometer ALTER COLUMN hydrometer_id SET DEFAULT nextval('ext_rtc_hydrometer_hydrometer_id_seq');

-- Create constraints to autoupdate the hydrometer_id column
ALTER TABLE IF EXISTS ext_rtc_hydrometer_x_data ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES ext_rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Drop selector_hydrometer table
DROP TABLE IF EXISTS selector_hydrometer;
