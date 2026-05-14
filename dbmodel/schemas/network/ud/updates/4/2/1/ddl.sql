/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


alter table archived_psector_gully add column psector_descript text;
 
drop table archived_psector_link;

CREATE TABLE archived_psector_link  (
	id serial4 NOT NULL,
	psector_id int4 NOT NULL,
	psector_state int2 NOT NULL,
	doable bool NOT NULL,
	addparam json NULL,
	audit_tstamp timestamp DEFAULT now() NULL,
	audit_user text DEFAULT CURRENT_USER NULL,
	action varchar(16) NOT NULL,
 	link_id integer,
	code text NULL,
	sys_code text NULL,
	top_elev1 float8 NULL,
	y1 numeric(12, 4) NULL,
	exit_id int4 NULL,
	exit_type varchar(16) NULL,
	top_elev2 float8 NULL,
	y2 numeric(12, 4) NULL,
	feature_type varchar(16) NULL,
	feature_id int4 NULL,
	link_type varchar(30) NOT NULL,
	linkcat_id varchar(30) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	expl_id2 int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	dma_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall _int4 NULL,
	dwfzone_outfall _int4 NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	custom_length numeric(12, 2) NULL,
	sys_slope numeric(12, 3) NULL,
	annotation text NULL,
	observ text NULL,
	"comment" text NULL,
	descript varchar(254) NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	private_linkcat_id varchar(30) NULL,
	verified int2 NULL,
	uncertain bool NULL,
	userdefined_geom bool NULL,
	datasource int4 NULL,
	is_operative bool NULL,
	lock_level int4 NULL,
	expl_visibility _int2 NULL,
	created_at timestamptz DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamptz NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT archived_psector_link_pkey PRIMARY KEY (id)
);
CREATE INDEX archived_psector_link_exit_id ON archived_psector_link USING btree (exit_id);
CREATE INDEX archived_psector_link_expl_visibility_idx ON link USING btree (expl_visibility);
CREATE INDEX archived_psector_link_feature_id ON archived_psector_link USING btree (feature_id);
CREATE INDEX archived_psector_link_index ON archived_psector_link USING gist (the_geom);
CREATE INDEX archived_psector_link_muni ON archived_psector_link USING btree (muni_id);

ALTER TABLE macroomzone ALTER COLUMN expl_id DROP NOT NULL;

-- 25/08/2025
ALTER TABLE om_waterbalance_dma_graph DROP CONSTRAINT IF EXISTS om_waterbalance_dma_graph_dma_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_dma_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_dma_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_dma_id_fkey;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_dma_id_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_dma_id_fkey;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;
DROP TABLE IF EXISTS dma;
CREATE TABLE IF NOT EXISTS dma (
    dma_id SERIAL,
    code TEXT,
    name TEXT,
    descript TEXT,
    dma_type VARCHAR(16),
    muni_id INT4[],
    expl_id INT4[],
    sector_id INT4[],
    avg_press INT4,
    pattern_id INT4,
    effc INT4,
    graphconfig JSON,
    stylesheet TEXT,
    lock_level INT4,
    link TEXT,
    addparam JSON,
    active BOOLEAN DEFAULT TRUE,
    the_geom GEOMETRY(POLYGON, SRID_VALUE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by TEXT DEFAULT current_user,
    updated_at TIMESTAMP,
    updated_by TEXT,
    CONSTRAINT dma_pk PRIMARY KEY (dma_id)
);

SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dwfzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"expl_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"link", "dataType":"text", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"expl_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroomzone", "column":"link", "dataType":"text", "isUtils":"False"}}$$);

-- Redo omzone
DROP VIEW IF EXISTS v_ui_omzone;
DROP VIEW IF EXISTS ve_omzone cascade;
DROP VIEW IF EXISTS v_edit_omzone cascade;

ALTER TABLE omzone DROP CONSTRAINT IF EXISTS omzone_expl_id_fkey;
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"omzone", "column":"expl_id", "dataType":"int4[]"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);


DROP RULE IF EXISTS dma_conflict ON dma;
DROP RULE IF EXISTS dma_undefined ON dma;
UPDATE dma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dma ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS omzone_conflict ON omzone;
DROP RULE IF EXISTS omzone_undefined ON omzone;
UPDATE omzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE omzone ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS dwfzone_conflict ON dwfzone;
DROP RULE IF EXISTS dwfzone_undefined ON dwfzone;
UPDATE dwfzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dwfzone ALTER COLUMN expl_id SET NOT NULL;