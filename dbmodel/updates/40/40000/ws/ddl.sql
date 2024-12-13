/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE node DROP CONSTRAINT arc_macrominsector_id_fkey; -- arc_ prefix because wrong name in before version
ALTER TABLE arc DROP CONSTRAINT arc_macrominsector_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_macrominsector_id_fkey;
ALTER TABLE link DROP CONSTRAINT link_macrominsector_id_fkey;

ALTER TABLE macrominsector RENAME to _macrominsector;

-- to change presszone_id::varchar to presszone_id::integer
-- drop foreign key
ALTER TABLE arc DROP CONSTRAINT arc_presszonecat_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_presszonecat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_presszonecat_id_fkey;

ALTER TABLE minsector DROP CONSTRAINT minsector_presszonecat_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_presszonecat_id_fkey;

ALTER TABLE plan_netscenario_presszone DROP CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey;
ALTER TABLE plan_netscenario_arc DROP CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey;
ALTER TABLE plan_netscenario_node DROP CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey;
ALTER TABLE plan_netscenario_connec DROP CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey;

-- drop triggers
DROP TRIGGER IF EXISTS gw_trg_presszone_check_datatype ON presszone;
DROP TRIGGER IF EXISTS gw_trg_presszone_check_datatype ON plan_netscenario_presszone;

-- drop rules
DROP RULE IF EXISTS presszone_conflict ON presszone;
DROP RULE IF EXISTS presszone_del_uconflict ON presszone;
DROP RULE IF EXISTS presszone_del_undefined ON presszone;
DROP RULE IF EXISTS presszone_undefined ON presszone;

-- change presszone_id to integer arc/node/connec/link/presszone/plan_netscenario_presszone
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"presszone", "column":"presszone_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"minsector", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"presszone_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_presszone", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_arc", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_node", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_connec", "column":"presszone_id", "dataType":"integer"}}$$);

-- drop depth and staticpressure from arc
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"depth"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"staticpressure"}}$$);

-- remove references to dma_id to recreate dma table
ALTER TABLE arc DROP CONSTRAINT arc_dma_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_dma_id_fkey;
ALTER TABLE minsector DROP CONSTRAINT minsector_dma_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_dma_id_fkey;
ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_dma_id_fkey;
ALTER TABLE pond DROP CONSTRAINT pond_dma_id_fkey;
ALTER TABLE pool DROP CONSTRAINT pool_dma_id_fkey;
ALTER TABLE rpt_inp_pattern_value DROP CONSTRAINT rpt_inp_pattern_value_dma_id_fkey;
ALTER TABLE om_waterbalance_dma_graph DROP CONSTRAINT rtc_scada_x_dma_dma_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_verified_fkey;

ALTER TABLE dma RENAME to _dma;
ALTER TABLE _dma DROP CONSTRAINT dma_pkey;
ALTER TABLE _dma DROP CONSTRAINT dma_expl_id_fkey;
ALTER TABLE _dma DROP CONSTRAINT dma_macrodma_id_fkey;
ALTER TABLE _dma DROP CONSTRAINT dma_pattern_id_fkey;

ALTER SEQUENCE SCHEMA_NAME.dma_dma_id_seq RENAME TO dma_dma_id_seq1;

DROP RULE IF EXISTS dma_conflict ON _dma;
DROP RULE IF EXISTS dma_del_conflict ON _dma;
DROP RULE IF EXISTS dma_del_undefined ON _dma;
DROP RULE IF EXISTS dma_undefined ON _dma;
DROP RULE IF EXISTS undelete_dma ON _dma;


ALTER TABLE presszone RENAME TO _presszone;
ALTER TABLE _presszone DROP CONSTRAINT cat_presszone_pkey;
ALTER TABLE _presszone DROP CONSTRAINT cat_presszone_expl_id_fkey;


ALTER TABLE arc DROP CONSTRAINT arc_dqa_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_dqa_id_fkey;
ALTER TABLE minsector DROP CONSTRAINT minsector_dqa_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_dqa_id_fkey;

ALTER TABLE dqa RENAME TO _dqa;
ALTER TABLE _dqa DROP CONSTRAINT dqa_pkey;
ALTER TABLE _dqa DROP CONSTRAINT dqa_expl_id_fkey;
ALTER TABLE _dqa DROP CONSTRAINT dqa_macrodqa_id_fkey;
ALTER TABLE _dqa DROP CONSTRAINT dqa_pattern_id_fkey;

ALTER SEQUENCE SCHEMA_NAME.dqa_dqa_id_seq RENAME TO dqa_dqa_id_seq1;

ALTER TABLE arc DROP CONSTRAINT arc_sector_id_fkey;
ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_sector_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_sector_id_fkey;
ALTER TABLE inp_controls DROP CONSTRAINT inp_controls_x_sector_id_fkey;
ALTER TABLE inp_dscenario_controls DROP CONSTRAINT inp_dscenario_controls_sector_id_fkey;
ALTER TABLE inp_dscenario_rules DROP CONSTRAINT inp_dscenario_rules_sector_id_fkey;
ALTER TABLE inp_rules DROP CONSTRAINT inp_rules_sector_id_fkey;
ALTER TABLE selector_sector DROP CONSTRAINT inp_selector_sector_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_sector_id_fkey;
ALTER TABLE sector DROP CONSTRAINT sector_parent_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_sector_id;
ALTER TABLE element DROP CONSTRAINT element_sector_id;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_sector_id;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_sector_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_sector_id;

ALTER TABLE sector RENAME TO _sector;
ALTER TABLE _sector RENAME CONSTRAINT sector_pkey TO _sector_pkey;
ALTER TABLE _sector DROP CONSTRAINT sector_macrosector_id_fkey;
ALTER TABLE _sector DROP CONSTRAINT sector_pattern_id_fkey;

ALTER SEQUENCE SCHEMA_NAME.sector_sector_id_seq RENAME TO sector_sector_id_seq1;

DROP RULE IF EXISTS sector_conflict ON _sector;
DROP RULE IF EXISTS sector_del_conflict ON _sector;
DROP RULE IF EXISTS sector_del_undefined ON _sector;
DROP RULE IF EXISTS sector_undefined ON _sector;
DROP RULE IF EXISTS undelete_sector ON _sector;


-- add new columns [sector_id, muni_id, expl_id] to dma, presszone, dqa, sector
CREATE TABLE dma (
	dma_id serial4 NOT NULL,
	"name" varchar(30) NULL,
	dma_type varchar(16) NULL,
    muni_id int4[] NULL,
	expl_id int4[]  NULL,
    sector_id int4[] NULL,
	macrodma_id int4 NULL,
	descript text NULL,
	undelete bool NULL,
	the_geom public.geometry(multipolygon, 25831) NULL,
	minc float8 NULL,
	maxc float8 NULL,
	effc float8 NULL,
	pattern_id varchar(16) NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	active bool DEFAULT true NULL,
	avg_press numeric NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(15) DEFAULT CURRENT_USER NULL,
	lastupdate timestamp NULL,
	lastupdate_user varchar(15) NULL,
	CONSTRAINT dma_pkey PRIMARY KEY (dma_id),
	CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE presszone (
	presszone_id int4 NOT NULL,
	"name" text NOT NULL,
	presszone_type text NULL,
    muni_id int4[] NULL,
	expl_id int4[] NOT NULL,
    sector_id int4[] NULL,
	link varchar(512) NULL,
	the_geom public.geometry(multipolygon, 25831) NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	head numeric(12, 2) NULL,
	active bool DEFAULT true NULL,
	descript text NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(15) DEFAULT CURRENT_USER NULL,
	lastupdate timestamp NULL,
	lastupdate_user varchar(15) NULL,
	avg_press float8 NULL,
	CONSTRAINT cat_presszone_pkey PRIMARY KEY (presszone_id)
);

CREATE TABLE dqa (
	dqa_id serial4 NOT NULL,
	"name" varchar(30) NULL,
	dqa_type varchar(16) NULL,
    muni_id int4[] NULL,
	expl_id int4[] NULL,
    sector_id int4[] NULL,
	macrodqa_id int4 NULL,
	descript text NULL,
	undelete bool NULL,
	the_geom public.geometry(multipolygon, 25831) NULL,
	pattern_id varchar(16) NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	active bool DEFAULT true NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(15) DEFAULT CURRENT_USER NULL,
	lastupdate timestamp NULL,
	lastupdate_user varchar(15) NULL,
	avg_press float8 NULL,
	CONSTRAINT dqa_pkey PRIMARY KEY (dqa_id),
	CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sector (
	sector_id serial4 NOT NULL,
	"name" varchar(50) NOT NULL,
	sector_type varchar(16) NULL,
    muni_id int4[] NULL,
    expl_id int4[] NULL,
	macrosector_id int4 NULL,
	descript text NULL,
	undelete bool NULL,
	the_geom public.geometry(multipolygon, 25831) NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	active bool DEFAULT true NULL,
	parent_id int4 NULL,
	pattern_id varchar(20) NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(15) DEFAULT CURRENT_USER NULL,
	lastupdate timestamp NULL,
	lastupdate_user varchar(15) NULL,
	avg_press float8 NULL,
	link text NULL,
	CONSTRAINT sector_pkey PRIMARY KEY (sector_id),
	CONSTRAINT sector_macrosector_id_fkey FOREIGN KEY (macrosector_id) REFERENCES macrosector(macrosector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT sector_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT sector_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"arctype_id", "newName":"arc_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_node", "column":"nodetype_id", "newName":"node_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_connec", "column":"connectype_id", "newName":"connec_type"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"private_connecat_id", "newName":"private_conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"connecat_id", "newName":"conneccat_id"}}$$);

-- 12/11/24
DROP VIEW ve_epa_virtualpump;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_virtualpump", "column":"energyvalue"}}$$);

-- 21/11/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector_graph", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector_graph", "column":"macrominsector_id", "dataType":"integer"}}$$);

-- 29/11/24
ALTER TABLE node ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE arc ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE connec ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE link ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE minsector_graph ALTER COLUMN macrominsector_id SET DEFAULT 0;

-- 02/12/2024

ALTER TABLE connec_add RENAME to _connec_add_;
ALTER TABLE _connec_add_ DROP CONSTRAINT connec_add_pkey;

CREATE TABLE connec_add
(connec_id character varying(16) NOT NULl PRIMARY KEY,
demand_base numeric(12,2),
demand_max numeric(12,2),
demand_min numeric(12,2),
demand_avg numeric(12,2),
press_max numeric(12,2),
press_min numeric(12,2),
press_avg numeric(12,2),
quality_max numeric(12,4),
quality_min numeric(12,4),
quality_avg numeric(12,4),
flow_max numeric(12,2),
flow_min numeric(12,2),
flow_avg numeric(12,2),
vel_max numeric(12,2),
vel_min numeric(12,2),
vel_avg numeric(12,2),
result_id text);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_virtualvalve", "column":"_to_arc_"}}$$);

-- 3/12/2024
DROP VIEW IF EXISTS v_edit_pool;
DROP VIEW IF EXISTS v_edit_pond;

ALTER TABLE pool RENAME to _pool_;
ALTER TABLE pond rename TO _pond_;

DELETE FROM sys_table WHERE id IN ('v_edit_pool','v_edit_pond','pool','pond');
DELETE FROM config_form_fields WHERE formname IN ('v_edit_pool', 'v_edit_pond');

DROP FUNCTION IF EXISTS gw_trg_edit_unconnected();

ALTER TABLE node_border_sector drop CONSTRAINT node_border_expl_sector_id_fkey;
ALTER TABLE node_border_sector RENAME TO _node_border_sector;


-- 05/12/2024
ALTER TABLE inp_dscenario_demand RENAME TO _inp_dscenario_demand;
ALTER TABLE _inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pkey;
ALTER TABLE _inp_dscenario_demand DROP CONSTRAINT inp_demand_dscenario_id_fkey;
ALTER TABLE _inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_feature_type_fkey;
ALTER TABLE _inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pattern_id_fkey;

ALTER TABLE _inp_dscenario_demand ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS SCHEMA_NAME.inp_dscenario_demand_id_seq1;
ALTER SEQUENCE SCHEMA_NAME.inp_dscenario_demand_id_seq RENAME TO inp_dscenario_demand_id_seq1;

DROP INDEX IF EXISTS inp_dscenario_demand_dscenario_id;
DROP INDEX IF EXISTS inp_dscenario_demand_source;

CREATE TABLE inp_dscenario_demand (
    dscenario_id int4 NOT NULL,
    id serial4 NOT NULL,
    feature_id varchar(16) NOT NULL,
    feature_type varchar(16) NULL,
    demand numeric(12, 6) NULL,
    pattern_id varchar(16) NULL,
    demand_type varchar(18) NULL,
    "source" text NULL,
    CONSTRAINT inp_dscenario_demand_pkey PRIMARY KEY (id),
    CONSTRAINT inp_demand_dscenario_id_fkey FOREIGN KEY (dscenario_id)
        REFERENCES cat_dscenario(dscenario_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_demand_feature_type_fkey FOREIGN KEY (feature_type)
        REFERENCES sys_feature_type(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
        REFERENCES inp_pattern(pattern_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_inp_dscenario_demand_dscenario_id ON inp_dscenario_demand USING btree (dscenario_id);
CREATE INDEX idx_inp_dscenario_demand_source ON inp_dscenario_demand USING btree ("source");

ALTER TABLE selector_netscenario RENAME TO _selector_netscenario;

-- 12/12/2024
ALTER TABLE cat_mat_roughness DROP CONSTRAINT cat_mat_roughness_matcat_id_fkey;
ALTER TABLE cat_mat_roughness ADD CONSTRAINT cat_mat_roughness_cat_material_fk FOREIGN KEY (matcat_id) REFERENCES cat_material(id);

-- 13/12/2024
CREATE INDEX idx_inp_pump_additional_id ON inp_pump_additional USING btree (id);
CREATE INDEX idx_inp_pump_additional_node_id ON inp_pump_additional USING btree (node_id);
CREATE INDEX idx_inp_pump_additional_energy_pattern_id ON inp_pump_additional USING btree (energy_pattern_id);
CREATE INDEX idx_inp_pump_additional_pattern_id ON inp_pump_additional USING btree (pattern_id);
