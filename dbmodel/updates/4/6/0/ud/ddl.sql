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

-- 01/12/2025
CREATE INDEX IF NOT EXISTS omunit_node_1_idx ON omunit USING btree ("node_1");
CREATE INDEX IF NOT EXISTS omunit_node_2_idx ON omunit USING btree ("node_2");
CREATE INDEX IF NOT EXISTS omunit_macroomunit_id_idx ON omunit USING btree ("macroomunit_id");

CREATE INDEX IF NOT EXISTS macroomunit_node_1_idx ON macroomunit USING btree ("node_1");
CREATE INDEX IF NOT EXISTS macroomunit_node_2_idx ON macroomunit USING btree ("node_2");
CREATE INDEX IF NOT EXISTS macroomunit_catchment_node_idx ON macroomunit USING btree ("catchment_node");

ALTER TABLE inp_dscenario_inflows ADD active boolean NULL;
ALTER TABLE inp_dscenario_inflows ALTER COLUMN active SET DEFAULT true;
ALTER TABLE temp_node_other ADD active boolean NULL;

ALTER TABLE temp_node_other drop CONSTRAINT temp_node_other_unique;
ALTER TABLE temp_node_other ADD CONSTRAINT temp_node_other_unique UNIQUE (node_id, other, type);

-- Drop trigger that depends on custom_ymax column in node
DROP TRIGGER IF EXISTS gw_trg_topocontrol_node ON node;

-- Drop all dependent views in dependency order due to dependency on custom_ymax in node via ve_node
DROP VIEW IF EXISTS 
    v_ui_plan_node_cost,
    v_plan_result_node,
    v_plan_psector_budget_node,
    v_plan_current_psector,
    v_plan_psector_all,
    v_plan_psector_budget,
    v_plan_psector,
    v_plan_node,
    ve_pol_storage,
    ve_pol_wwtp,
    ve_pol_chamber,
    ve_pol_netgully,
    ve_inp_dscenario_outfall,
    ve_inp_outfall,
    ve_inp_dscenario_storage,
    ve_inp_storage,
    ve_inp_netgully,
    ve_inp_dscenario_inflows,
    ve_inp_dscenario_inflows_poll,
    ve_inp_dscenario_junction,
    ve_inp_dscenario_treatment,
    ve_inp_dwf,
    ve_inp_inflows,
    ve_inp_inflows_poll,
    ve_inp_treatment,
    ve_inp_junction,
    ve_inp_divider,
    ve_inp_inlet,
    ve_inp_dscenario_inlet,
    v_ui_workcat_x_feature_end,
    ve_node_chamber,
    ve_node_change,
    ve_node_circ_manhole,
    ve_node_highpoint,
    ve_node_jump,
    ve_node_junction,
    ve_node_netelement,
    ve_node_netgully,
    ve_node_netinit,
    ve_node_out_manhole,
    ve_node_outfall,
    ve_node_pump_station,
    ve_node_rect_manhole,
    ve_node_register,
    ve_node_sandbox,
    ve_node_sewer_storage,
    ve_node_valve,
    ve_node_virtual_node,
    ve_node_weir,
    ve_node_wwtp,
    ve_node_overflow_storage,
    ve_node,
    v_edit_node;

ALTER TABLE node DROP COLUMN custom_ymax;


-- Drop dependent views in correct order before dropping the column
DROP VIEW IF EXISTS ve_arc_waccel;
DROP VIEW IF EXISTS ve_arc_varc;
DROP VIEW IF EXISTS ve_arc_siphon;
DROP VIEW IF EXISTS ve_arc_pump_pipe;
DROP VIEW IF EXISTS ve_arc_conduit;
DROP VIEW IF EXISTS ve_inp_weir;
DROP VIEW IF EXISTS ve_inp_virtual;
DROP VIEW IF EXISTS ve_inp_pump;
DROP VIEW IF EXISTS ve_inp_outlet;
DROP VIEW IF EXISTS ve_inp_orifice;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS ve_inp_dscenario_conduit;
DROP VIEW IF EXISTS ve_inp_conduit;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;
DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;
DROP VIEW IF EXISTS ve_arc;
DROP VIEW IF EXISTS v_edit_arc;

-- Drop the trigger that depends on the column
DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON arc;

-- create and rename columns
-- node_1
ALTER TABLE arc RENAME COLUMN node_sys_top_elev_1 TO node_top_elev_1;
ALTER TABLE arc ADD COLUMN node_custom_top_elev_1 numeric(12,3) NULL;
ALTER TABLE arc RENAME COLUMN node_sys_elev_1 TO node_elev_1;
ALTER TABLE arc ADD COLUMN node_custom_elev_1 numeric(12,3) NULL;

-- node_2
ALTER TABLE arc RENAME COLUMN node_sys_top_elev_2 TO node_top_elev_2;
ALTER TABLE arc ADD COLUMN node_custom_top_elev_2 numeric(12,3) NULL;
ALTER TABLE arc RENAME COLUMN node_sys_elev_2 TO node_elev_2;
ALTER TABLE arc ADD COLUMN node_custom_elev_2 numeric(12,3) NULL;

CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom, y1, y2, elev1, elev2, custom_elev1, custom_elev2, state, inverted_slope ON
arc FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_arc();

CREATE TRIGGER gw_trg_autoupdate_arc_topology BEFORE INSERT OR UPDATE OF node_top_elev_1, node_top_elev_2, node_elev_1, node_elev_2 ON
arc FOR EACH ROW EXECUTE FUNCTION gw_trg_autoupdate_arc_topology();

-- node_1
UPDATE arc SET node_top_elev_1 = top_elev
FROM node WHERE node.node_id = arc.node_1 AND node.top_elev IS NOT NULL;

UPDATE arc SET node_custom_top_elev_1 = custom_top_elev
FROM node WHERE node.node_id = arc.node_1 AND node.custom_top_elev IS NOT NULL;

UPDATE arc SET node_elev_1 = elev
FROM node WHERE node.node_id = arc.node_1 AND node.elev IS NOT NULL;

UPDATE arc SET node_custom_elev_1 = custom_elev
FROM node WHERE node.node_id = arc.node_1 AND node.custom_elev IS NOT NULL;

UPDATE arc SET elev1 = sys_elev1
WHERE elev1 IS NULL;

-- node_2
UPDATE arc SET node_top_elev_2 = top_elev
FROM node WHERE node.node_id = arc.node_2 AND node.top_elev IS NOT NULL;

UPDATE arc SET node_custom_top_elev_2 = custom_top_elev
FROM node WHERE node.node_id = arc.node_2 AND node.custom_top_elev IS NOT NULL;

UPDATE arc SET node_elev_2 = elev
FROM node WHERE node.node_id = arc.node_2 AND node.elev IS NOT NULL;

UPDATE arc SET node_custom_elev_2 = custom_elev
FROM node WHERE node.node_id = arc.node_2 AND node.custom_elev IS NOT NULL;

UPDATE arc SET elev2 = sys_elev2
WHERE elev2 IS NULL;

-- drop columns
-- node_1
ALTER TABLE arc drop column sys_elev1;
ALTER TABLE arc drop column custom_y1;

-- node_2
ALTER TABLE arc drop column sys_elev2;
ALTER TABLE arc drop column custom_y2;

-- 15/12/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"expl_id2", "newName":"_expl_id2"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dma", "column":"dma_type", "dataType":"varchar(32)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dma", "column":"pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dma", "column":"avg_press", "dataType":"numeric(12,2)"}}$$);
ALTER TABLE dma ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
