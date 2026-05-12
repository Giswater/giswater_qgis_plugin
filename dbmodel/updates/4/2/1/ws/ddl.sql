/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_demand", "column":"feature_id", "dataType":"text"}}$$);

drop table archived_psector_link;
 
CREATE TABLE archived_psector_link (
    id serial4 NOT NULL,
	psector_id int4 NOT NULL,
	psector_state int2 NOT NULL,
	doable bool NOT NULL,
	audit_tstamp timestamp DEFAULT now() NULL,
	audit_user text DEFAULT CURRENT_USER NULL,
	action varchar(16) NOT NULL,
 	link_id int4 NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev1 float8 NULL,
	depth1 numeric(12, 4) NULL,
	exit_id int4 NULL,
	exit_type varchar(16) NULL,
	top_elev2 float8 NULL,
	depth2 numeric(12, 4) NULL,
	feature_type varchar(16) NULL,
	feature_id int4 NULL,
	linkcat_id varchar(30) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	expl_id int4 NOT NULL,
	muni_id int4 NULL,
	sector_id int4 NULL,
	supplyzone_id int4 NULL,
	presszone_id int4 NULL,
	dma_id int4 NULL,
	dqa_id int4 NULL,
	omzone_id int4 NULL,
	minsector_id int4 NULL,
	location_type varchar(50) NULL,
	fluid_type varchar(50) NULL,
	custom_length numeric(12, 2) NULL,
	staticpressure1 numeric(12, 3) NULL,
	staticpressure2 numeric(12, 3) NULL,
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
	CONSTRAINT archived_psector_link_pkey PRIMARY KEY (link_id)
);
CREATE INDEX archived_psector_link_exit_id ON link USING btree (exit_id);
CREATE INDEX archived_psector_link_expl_visibility_idx ON archived_psector_link USING btree (expl_visibility);
CREATE INDEX larchived_psector_ink_feature_id ON archived_psector_link USING btree (feature_id);
CREATE INDEX archived_psector_link_index ON archived_psector_link USING gist (the_geom);
CREATE INDEX archived_psector_link_muni ON archived_psector_link USING btree (muni_id);

ALTER TABLE macrodma ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE macroomzone ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE macrodqa ALTER COLUMN expl_id DROP NOT NULL;

DROP RULE IF EXISTS dma_conflict ON dma;
DROP RULE IF EXISTS dma_undefined ON dma;
UPDATE dma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dma ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS dqa_conflict ON dqa;
DROP RULE IF EXISTS dqa_undefined ON dqa;
UPDATE dqa SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE dqa ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS omzone_conflict ON omzone;
DROP RULE IF EXISTS omzone_undefined ON omzone;
UPDATE omzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE omzone ALTER COLUMN expl_id SET NOT NULL;

DROP RULE IF EXISTS presszone_conflict ON presszone;
DROP RULE IF EXISTS presszone_undefined ON presszone;
UPDATE presszone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
ALTER TABLE presszone ALTER COLUMN expl_id SET NOT NULL;

-- 25/08/2025
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"graphconfig", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"omzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"supplyzone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"supplyzone", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"supplyzone", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
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
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"link", "dataType":"text", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodqa", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodqa", "column":"sector_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodqa", "column":"muni_id", "dataType":"int4[]", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodqa", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodqa", "column":"link", "dataType":"text", "isUtils":"False"}}$$);
