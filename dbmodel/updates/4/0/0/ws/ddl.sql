/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE node DROP CONSTRAINT node_macrominsector_id_fkey;
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
	code text NULL,
	"name" varchar(30) NULL,
	descript text NULL,
	dma_type varchar(16) NULL,
    muni_id int4[] NULL,
	expl_id int4[]  NULL,
    sector_id int4[] NULL,
	macrodma_id int4 NULL,
	minc float8 NULL,
	maxc float8 NULL,
	effc float8 NULL,
	pattern_id varchar(16) NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	avg_press numeric NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT dma_pkey PRIMARY KEY (dma_id),
	CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE presszone (
	presszone_id int4 NOT NULL,
	code text NULL,
	"name" text NOT NULL,
	descript text NULL,
	presszone_type text NULL,
    muni_id int4[] NULL,
	expl_id int4[] NOT NULL,
    sector_id int4[] NULL,
	link varchar(512) NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	head numeric(12, 2) NULL,
	avg_press float8 NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT cat_presszone_pkey PRIMARY KEY (presszone_id)
);

CREATE TABLE dqa (
	dqa_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(30) NULL,
	descript text NULL,
	dqa_type varchar(16) NULL,
    muni_id int4[] NULL,
	expl_id int4[] NULL,
    sector_id int4[] NULL,
	macrodqa_id int4 NULL,
	pattern_id varchar(16) NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	avg_press float8 NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT dqa_pkey PRIMARY KEY (dqa_id),
	CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sector (
	sector_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	sector_type varchar(16) NULL,
	expl_id int4[] NULL,
	muni_id int4[] NULL,
	macrosector_id int4 NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	parent_id int4 NULL,
	pattern_id varchar(20) NULL,
	avg_press float8 NULL,
	link text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_virtualpump", "column":"energyvalue"}}$$);

-- 21/11/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector_graph", "column":"expl_id"}}$$);

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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"active", "dataType":"boolean", "defaultValue":"true"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"active", "dataType":"boolean", "defaultValue":"true"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc_x_node", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_connec", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_node", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_polygon", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_param_user", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dimensions", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dimensions", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_dma", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_presszone", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);

-- 20/01/2025
ALTER TABLE rpt_arc_stats RENAME TO _rpt_arc_stats;
ALTER TABLE _rpt_arc_stats RENAME CONSTRAINT rpt_arc_stats_pkey TO _rpt_arc_stats_pkey;
DROP INDEX IF EXISTS rpt_arc_stats_flow_avg;
DROP INDEX IF EXISTS rpt_arc_stats_flow_max;
DROP INDEX IF EXISTS rpt_arc_stats_flow_min;
DROP INDEX IF EXISTS rpt_arc_stats_geom;
DROP INDEX IF EXISTS rpt_arc_stats_vel_avg;
DROP INDEX IF EXISTS rpt_arc_stats_vel_max;
DROP INDEX IF EXISTS rpt_arc_stats_vel_min;

ALTER TABLE archived_rpt_arc_stats RENAME TO _archived_rpt_arc_stats;
ALTER TABLE _archived_rpt_arc_stats RENAME CONSTRAINT archived_rpt_arc_stats_pkey TO _archived_rpt_arc_stats_pkey;

CREATE TABLE rpt_arc_stats (
	arc_id varchar(16) NOT NULL,
	result_id varchar(30) NOT NULL,
	arc_type varchar(30) NULL,
	sector_id int4 NULL,
	arccat_id varchar(30) NULL,
	flow_max numeric NULL,
	flow_min numeric NULL,
	flow_avg numeric(12, 2) NULL,
	vel_max numeric NULL,
	vel_min numeric NULL,
	vel_avg numeric(12, 2) NULL,
	headloss_max numeric NULL,
	headloss_min numeric NULL,
	setting_max numeric NULL,
	setting_min numeric NULL,
	reaction_max numeric NULL,
	reaction_min numeric NULL,
	ffactor_max numeric NULL,
	ffactor_min numeric NULL,
	length numeric NULL,
	tot_headloss_max numeric(12, 2) NULL,
	tot_headloss_min numeric(12, 2) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT rpt_arc_stats_pkey PRIMARY KEY (arc_id, result_id)
);
CREATE INDEX rpt_arc_stats_flow_avg ON rpt_arc_stats USING btree (flow_avg);
CREATE INDEX rpt_arc_stats_flow_max ON rpt_arc_stats USING btree (flow_max);
CREATE INDEX rpt_arc_stats_flow_min ON rpt_arc_stats USING btree (flow_min);
CREATE INDEX rpt_arc_stats_geom ON rpt_arc_stats USING gist (the_geom);
CREATE INDEX rpt_arc_stats_vel_avg ON rpt_arc_stats USING btree (vel_avg);
CREATE INDEX rpt_arc_stats_vel_max ON rpt_arc_stats USING btree (vel_max);
CREATE INDEX rpt_arc_stats_vel_min ON rpt_arc_stats USING btree (vel_min);

CREATE TABLE archived_rpt_arc_stats (
	arc_id varchar(16) NOT NULL,
	result_id varchar(30) NOT NULL,
	arc_type varchar(30) NULL,
	sector_id int4 NULL,
	arccat_id varchar(30) NULL,
	flow_max numeric NULL,
	flow_min numeric NULL,
	flow_avg numeric(12, 2) NULL,
	vel_max numeric NULL,
	vel_min numeric NULL,
	vel_avg numeric(12, 2) NULL,
	headloss_max numeric NULL,
	headloss_min numeric NULL,
	setting_max numeric NULL,
	setting_min numeric NULL,
	reaction_max numeric NULL,
	reaction_min numeric NULL,
	ffactor_max numeric NULL,
	ffactor_min numeric NULL,
	length numeric NULL,
	tot_headloss_max numeric(12, 2) NULL,
	tot_headloss_min numeric(12, 2) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT archived_rpt_arc_stats_pkey PRIMARY KEY (arc_id, result_id)
);


-- 21/01/2025
ALTER TABLE arc_add RENAME TO _arc_add_;
ALTER TABLE _arc_add_ DROP CONSTRAINT arc_add_pkey;

CREATE TABLE arc_add (
	arc_id varchar(16) NOT NULL,
	result_id text NULL,
	flow_max numeric(12, 2) NULL,
	flow_min numeric(12, 2) NULL,
	flow_avg numeric(12, 2) NULL,
	vel_max numeric(12, 2) NULL,
	vel_min numeric(12, 2) NULL,
	vel_avg numeric(12, 2) NULL,
	tot_headloss_max numeric(12, 2) NULL,
	tot_headloss_min numeric(12, 2) NULL,
	mincut_connecs int NULL,
	mincut_hydrometers int NULL,
	mincut_length numeric(12, 3) NULL,
	mincut_watervol numeric(12, 3) NULL,
	mincut_criticality numeric(12, 3) NULL,
	hydraulic_criticality numeric(12, 3) NULL,
	CONSTRAINT arc_add_pkey PRIMARY KEY (arc_id)
);

-- 27/01/25
-- Drop views
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
DROP VIEW IF EXISTS v_edit_inp_valve;

-- Rename constraints
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_pkey TO _inp_dscenario_valve_pkey_;
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_status_check TO _inp_dscenario_valve_status_check_;
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_valv_type_check TO _inp_dscenario_valve_valv_type_check_;
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_curve_id_fkey TO _inp_dscenario_valve_curve_id_fkey_;
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_dscenario_id_fkey TO _inp_dscenario_valve_dscenario_id_fkey_;
ALTER TABLE inp_dscenario_valve RENAME CONSTRAINT inp_dscenario_valve_node_id_fkey TO _inp_dscenario_valve_node_id_fkey_;

ALTER TABLE inp_dscenario_virtualvalve RENAME CONSTRAINT inp_dscenario_virtualvalve_pkey TO _inp_dscenario_virtualvalve_pkey_;
ALTER TABLE inp_dscenario_virtualvalve RENAME CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey TO _inp_dscenario_virtualvalve_arc_id_fkey_;
ALTER TABLE inp_dscenario_virtualvalve RENAME CONSTRAINT inp_dscenario_virtualvalve_curve_id_fkey TO _inp_dscenario_virtualvalve_curve_id_fkey_;
ALTER TABLE inp_dscenario_virtualvalve RENAME CONSTRAINT inp_dscenario_virtualvalve_dscenario_id_fkey TO _inp_dscenario_virtualvalve_dscenario_id_fkey_;

ALTER TABLE inp_valve RENAME CONSTRAINT inp_valve_pkey TO _inp_valve_pkey_;
ALTER TABLE inp_valve RENAME CONSTRAINT inp_valve_valv_type_check TO _inp_valve_valv_type_check_;
ALTER TABLE inp_valve RENAME CONSTRAINT inp_valve_curve_id_fkey TO _inp_valve_curve_id_fkey_;
ALTER TABLE inp_valve RENAME CONSTRAINT inp_valve_node_id_fkey TO _inp_valve_node_id_fkey_;

ALTER TABLE inp_virtualvalve RENAME CONSTRAINT inp_virtualvalve_pkey TO _inp_virtualvalve_pkey_;
ALTER TABLE inp_virtualvalve RENAME CONSTRAINT inp_virtualvalve_status_check TO _inp_virtualvalve_status_check_;
ALTER TABLE inp_virtualvalve RENAME CONSTRAINT inp_virtualvalve_valv_type_check TO _inp_virtualvalve_valv_type_check_;
ALTER TABLE inp_virtualvalve RENAME CONSTRAINT inp_virtualvalve_arc_id_fkey TO _inp_virtualvalve_arc_id_fkey_;
ALTER TABLE inp_virtualvalve RENAME CONSTRAINT inp_virtualvalve_curve_id_fkey TO _inp_virtualvalve_curve_id_fkey_;

-- Rename tables
ALTER TABLE inp_dscenario_virtualvalve RENAME TO _inp_dscenario_virtualvalve_;
ALTER TABLE inp_virtualvalve RENAME TO _inp_virtualvalve_;
ALTER TABLE inp_dscenario_valve RENAME TO _inp_dscenario_valve_;
ALTER TABLE inp_valve RENAME TO _inp_valve_;

-- Create tables with "setting" column
CREATE TABLE inp_dscenario_virtualvalve (
    dscenario_id int4 NOT NULL,
    arc_id varchar(16) NOT NULL,
    valv_type varchar(18) NULL,
    diameter numeric(12, 4) NULL,
    setting numeric(12, 4) NULL,
    curve_id varchar(16) NULL,
    minorloss numeric(12, 4) NULL,
    status varchar(12) NULL,
    init_quality float8 NULL,
    CONSTRAINT inp_dscenario_virtualvalve_pkey PRIMARY KEY (dscenario_id, arc_id)
);

CREATE TABLE inp_virtualvalve (
    arc_id varchar(16) NOT NULL,
    valv_type varchar(18) NULL,
    diameter numeric(12, 4) NULL,
    setting numeric(12, 4) NULL,
    curve_id varchar(16) NULL,
    minorloss numeric(12, 4) NULL,
    status varchar(12) NULL,
    init_quality float8 NULL,
    CONSTRAINT inp_virtualvalve_pkey PRIMARY KEY (arc_id)
);

CREATE TABLE inp_dscenario_valve (
	dscenario_id int4 NOT NULL,
	node_id varchar(16) NOT NULL,
	valv_type varchar(18) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) NULL,
	status varchar(12) DEFAULT 'ACTIVE'::character varying NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
	CONSTRAINT inp_dscenario_valve_pkey PRIMARY KEY (node_id, dscenario_id)
);

CREATE TABLE inp_valve (
	node_id varchar(16) NOT NULL,
	valv_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
	CONSTRAINT inp_valve_pkey PRIMARY KEY (node_id)
);

-- Move previous flow/coef_loss/pressure to new "setting" column
INSERT INTO inp_dscenario_valve (dscenario_id, node_id, valv_type, setting, curve_id, minorloss, status, add_settings, init_quality)
SELECT dscenario_id, node_id, valv_type,
       CASE
           WHEN valv_type = 'FCV' THEN flow
           WHEN valv_type = 'TCV' THEN coef_loss
           ELSE pressure
       END,
       curve_id, minorloss, status, add_settings, init_quality
FROM _inp_dscenario_valve_;

INSERT INTO inp_valve (node_id, valv_type, custom_dint, setting, curve_id, minorloss, add_settings, init_quality)
SELECT node_id, valv_type, custom_dint,
       CASE
           WHEN valv_type = 'FCV' THEN flow
           WHEN valv_type = 'TCV' THEN coef_loss
           ELSE pressure
       END,
       curve_id, minorloss, add_settings, init_quality
FROM _inp_valve_;

INSERT INTO inp_dscenario_virtualvalve (dscenario_id, arc_id, valv_type, diameter, setting, curve_id, minorloss, status, init_quality)
SELECT dscenario_id, arc_id, valv_type, diameter,
       CASE
           WHEN valv_type = 'FCV' THEN flow
           WHEN valv_type = 'TCV' THEN coef_loss
           ELSE pressure
       END,
       curve_id, minorloss, status, init_quality
FROM _inp_dscenario_virtualvalve_;

INSERT INTO inp_virtualvalve (arc_id, valv_type, diameter, setting, curve_id, minorloss, status, init_quality)
SELECT arc_id, valv_type, diameter,
       CASE
           WHEN valv_type = 'FCV' THEN flow
           WHEN valv_type = 'TCV' THEN coef_loss
           ELSE pressure
       END,
       curve_id, minorloss, status, init_quality
FROM _inp_virtualvalve_;

-- Table Triggers
-- inp_dscenario_virtualvalve
create trigger gw_trg_typevalue_fk_insert after
insert
    on
    inp_dscenario_virtualvalve for each row execute function gw_trg_typevalue_fk('inp_dscenario_virtualvalve');
create trigger gw_trg_typevalue_fk_update after
update
    of valv_type,
    status on
    inp_dscenario_virtualvalve for each row
    when ((((old.valv_type)::text is distinct
from
    (new.valv_type)::text)
        or ((old.status)::text is distinct
    from
        (new.status)::text))) execute function gw_trg_typevalue_fk('inp_dscenario_virtualvalve');
-- inp_virtualvalve
create trigger gw_trg_typevalue_fk_insert after
insert
    on
    inp_virtualvalve for each row execute function gw_trg_typevalue_fk('inp_virtualvalve');
create trigger gw_trg_typevalue_fk_update after
update
    of valv_type,
    status on
    inp_virtualvalve for each row
    when ((((old.valv_type)::text is distinct
from
    (new.valv_type)::text)
        or ((old.status)::text is distinct
    from
        (new.status)::text))) execute function gw_trg_typevalue_fk('inp_virtualvalve');
-- inp_valve
create trigger gw_trg_typevalue_fk_insert after
insert
    on
    inp_valve for each row execute function gw_trg_typevalue_fk('inp_valve');
create trigger gw_trg_typevalue_fk_update after
update
    of valv_type on
    inp_valve for each row
    when (((old.valv_type)::text is distinct
from
    (new.valv_type)::text)) execute function gw_trg_typevalue_fk('inp_valve');
-- inp_dscenario_valve
create trigger gw_trg_typevalue_fk_insert after
insert
    on
    inp_dscenario_valve for each row execute function gw_trg_typevalue_fk('inp_dscenario_valve');
create trigger gw_trg_typevalue_fk_update after
update
    of status,
    valv_type on
    inp_dscenario_valve for each row
    when ((((old.status)::text is distinct
from
    (new.status)::text)
        or ((old.valv_type)::text is distinct
    from
        (new.valv_type)::text))) execute function gw_trg_typevalue_fk('inp_dscenario_valve');

-- Add constraints
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_status_check CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('CLOSED'::character varying)::text, ('OPEN'::character varying)::text])));
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_valv_type_check CHECK (((valv_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text])));
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_valv_type_check CHECK (((valv_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text])));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE inp_dscenario_virtualvalve ADD CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_virtualvalve(arc_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualvalve ADD CONSTRAINT inp_dscenario_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualvalve ADD CONSTRAINT inp_dscenario_virtualvalve_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_status_check CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('CLOSED'::character varying)::text, ('OPEN'::character varying)::text])));
ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_valv_type_check CHECK (((valv_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text])));
ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_valve(node_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- 27/01/2025
CREATE TABLE IF NOT EXISTS supplyzone (
    supplyzone_id serial4,
	code text NULL,
	"name" varchar(30) NULL,
    descript text NULL,
	supplyzone_type varchar(16) NULL,
    muni_id integer[],
    expl_id integer[],
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
    parent_id integer,
    pattern_id varchar(20),
    avg_press double precision,
    link text,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
    the_geom public.geometry(MultiPolygon, SRID_VALUE),
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
    CONSTRAINT supplyzone_pkey PRIMARY KEY (supplyzone_id),
    CONSTRAINT supplyzone_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES supplyzone (supplyzone_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT supplyzone_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);


-- 29/01/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE arc ADD CONSTRAINT arc_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE node ADD CONSTRAINT node_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE connec ADD CONSTRAINT connec_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE link ADD CONSTRAINT link_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- 30/01/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"verified", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"verified", "dataType":"integer"}}$$);


-- 06/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"custom_top_elev", "dataType":"numeric(12, 4)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"element", "column":"elevation", "newName":"top_elev"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"temp_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_node_stats", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_rpt_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_rpt_node_stats", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_audit_node", "column":"old_elevation", "newName":"old_top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_audit_node", "column":"new_elevation", "newName":"new_top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_inp_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_rpt_inp_node", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_node", "column":"elevation", "newName":"top_elev"}}$$);

-- 10/02/2025

-- element_x_arc
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_pkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_arc", "column":"id"}}$$);
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_pkey PRIMARY KEY (element_id, arc_id);

-- element_x_connec
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_pkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_connec", "column":"id"}}$$);
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_pkey PRIMARY KEY (element_id, connec_id);

-- element_x_node
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_pkey;
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_node", "column":"id"}}$$);
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_pkey PRIMARY KEY (element_id, node_id);

-- doc_x_arc
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_arc", "column":"id"}}$$);
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_pkey PRIMARY KEY (doc_id, arc_id);

-- doc_x_connec
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_connec", "column":"id"}}$$);
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_pkey PRIMARY KEY (doc_id, connec_id);

-- doc_x_node
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_node", "column":"id"}}$$);
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_pkey PRIMARY KEY (doc_id, node_id);

-- doc_x_psector
ALTER TABLE doc_x_psector DROP CONSTRAINT doc_x_psector_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_psector", "column":"id"}}$$);
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_pkey PRIMARY KEY (doc_id, psector_id);

-- doc_x_visit
ALTER TABLE doc_x_visit DROP CONSTRAINT doc_x_visit_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_visit", "column":"id"}}$$);
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_pkey PRIMARY KEY (doc_id, visit_id);

-- doc_x_workcat
ALTER TABLE doc_x_workcat DROP CONSTRAINT doc_x_workcat_pkey;
ALTER TABLE doc_x_workcat DROP CONSTRAINT unique_doc_id_workcat_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_workcat", "column":"id"}}$$);
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_pkey PRIMARY KEY (doc_id, workcat_id);

-- 10/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_arc", "column":"dr", "dataType":"integer", "isUtils":"False"}}$$);

-- 17/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);

-- 19/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"arc", "column":"is_scadamap", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"node", "column":"is_scadamap", "dataType":"boolean", "isUtils":"False"}}$$);

--21/02/2025
-- node
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"pavcat_id", "dataType":"text", "isUtils":"False"}}$$);
ALTER TABLE node ADD CONSTRAINT cat_pavement_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- man_valve
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"automated", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"connection_type", "dataType":"integer", "isUtils":"False"}}$$);
UPDATE man_valve SET connection_type=0 WHERE connection_type IS NULL;
ALTER TABLE man_valve ALTER COLUMN connection_type SET DEFAULT 0;
ALTER TABLE man_valve ALTER COLUMN connection_type SET NOT NULL;

-- man_tank
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"automated", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"length", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"width", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"shape", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"fence_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"fence_length", "dataType":"float", "isUtils":"False"}}$$);
UPDATE man_tank SET shape=0 WHERE shape IS NULL;
ALTER TABLE man_tank ALTER COLUMN shape SET DEFAULT 0;
ALTER TABLE man_tank ALTER COLUMN shape SET NOT NULL;

-- man_netelement
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netelement", "column":"automated", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netelement", "column":"fence_type", "dataType":"integer", "isUtils":"False"}}$$);

-- man_hydrant
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_hydrant", "column":"hydrant_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_hydrant", "column":"hydrant_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_hydrant", "column":"security_cover", "dataType":"boolean", "isUtils":"False"}}$$);

-- connec
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"block_zone", "dataType":"text", "isUtils":"False"}}$$);

-- link
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"n_hydrometer", "dataType":"integer", "isUtils":"False"}}$$);

-- man_wtp
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"maxflow", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"opsflow", "dataType":"float", "isUtils":"False"}}$$);

-- man_meter
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"automated", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_meter", "column":"meter_code", "dataType":"text"}}$$);

-- man_source
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"source_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"source_code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"aquifer_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"aquifer_name", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"wtp_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"registered_flow", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"auth_code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"basin_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"subbasin_id", "dataType":"integer", "isUtils":"False"}}$$);

UPDATE man_source SET source_type=0 WHERE source_type IS NULL;
ALTER TABLE man_source ALTER COLUMN source_type SET DEFAULT 0;
ALTER TABLE man_source ALTER COLUMN source_type SET NOT NULL;

UPDATE man_source SET aquifer_type=0 WHERE aquifer_type IS NULL;
ALTER TABLE man_source ALTER COLUMN aquifer_type SET DEFAULT 0;
ALTER TABLE man_source ALTER COLUMN aquifer_type SET NOT NULL;

UPDATE man_source SET basin_id=0 WHERE basin_id IS NULL;
ALTER TABLE man_source ALTER COLUMN basin_id SET DEFAULT 0;
ALTER TABLE man_source ALTER COLUMN basin_id SET NOT NULL;

UPDATE man_source SET subbasin_id=0 WHERE subbasin_id IS NULL;
ALTER TABLE man_source ALTER COLUMN subbasin_id SET DEFAULT 0;
ALTER TABLE man_source ALTER COLUMN subbasin_id SET NOT NULL;


-- 03/03/2025

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_junction"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_reservoir"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_tank"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_pipe"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_pump"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"n_valve"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"head_form"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"hydra_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"hydra_acc"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"st_ch_freq"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"max_tr_ch"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"dam_li_thr"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"max_trials"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"q_analysis"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"spec_grav"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"r_kin_visc"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"r_che_diff"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"dem_multi"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"total_dura"}}$$);

-- WS
DROP RULE IF EXISTS undelete_macrodqa ON macrodqa;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS v_ui_macrodma;
DROP RULE IF EXISTS undelete_macrodma ON macrodma;

DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS vu_sector;

-- 04/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_valve", "column":"active"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"fluid_type", "dataType":"varchar(50)"}}$$);

-- 06/03/2025
ALTER TABLE inp_pattern RENAME TO _inp_pattern;

-- Drop foreign keys that reference inp_pattern
ALTER TABLE ext_hydrometer_category DROP CONSTRAINT ext_hydrometer_category_pattern_id_fkey;
ALTER TABLE ext_rtc_dma_period DROP CONSTRAINT ext_rtc_dma_period_pattern_id_fkey;
ALTER TABLE inp_inlet DROP CONSTRAINT inp_inlet_pattern_id_fkey;
ALTER TABLE inp_pattern_value DROP CONSTRAINT inp_pattern_value_pattern_id_fkey;
ALTER TABLE inp_connec DROP CONSTRAINT inp_connec_pattern_id_fkey;
ALTER TABLE inp_dscenario_connec DROP CONSTRAINT inp_demand_pattern_id_fkey;
ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT inp_dscenario_inlet_pattern_id_fkey;
ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_energy_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_energy_pattern_id_fkey;
ALTER TABLE inp_dscenario_reservoir DROP CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey;
ALTER TABLE inp_dscenario_virtualpump DROP CONSTRAINT inp_dscenario_virtualpump_pattern_id_fkey;
ALTER TABLE inp_dscenario_virtualpump DROP CONSTRAINT inp_dscenario_virtualpump_energy_pattern_id_fkey;
ALTER TABLE inp_junction DROP CONSTRAINT inp_junction_pattern_id_fkey;
ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_pattern_id_fkey;
ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_energy_pattern_id_fkey;
ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_pattern_id_fkey;
ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_energy_pattern_id_fkey;
ALTER TABLE inp_reservoir DROP CONSTRAINT inp_reservoir_pattern_id_fkey;
ALTER TABLE inp_virtualpump DROP CONSTRAINT inp_virtualpump_pattern_id_fkey;
ALTER TABLE inp_virtualpump DROP CONSTRAINT inp_virtualpump_energy_pattern_id_fkey;
ALTER TABLE dma DROP CONSTRAINT dma_pattern_id_fkey;
ALTER TABLE dqa DROP CONSTRAINT dqa_pattern_id_fkey;
ALTER TABLE sector DROP CONSTRAINT sector_pattern_id_fkey;
ALTER TABLE inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pattern_id_fkey;
ALTER TABLE supplyzone DROP CONSTRAINT supplyzone_pattern_id_fkey;
ALTER TABLE IF EXISTS _inp_source_ DROP CONSTRAINT IF EXISTS inp_source_pattern_id_fkey;


ALTER TABLE IF EXISTS _inp_pattern DROP CONSTRAINT IF EXISTS inp_pattern_pkey;
ALTER TABLE IF EXISTS _inp_pattern DROP CONSTRAINT IF EXISTS inp_pattern_expl_id_fkey;

CREATE TABLE inp_pattern (
	pattern_id varchar(16) NOT NULL,
	pattern_type varchar(30) NULL,
	observ text NULL,
	tscode text NULL,
	tsparameters json NULL,
	expl_id int4 NULL,
	log text NULL,
	active bool DEFAULT true NULL,
	CONSTRAINT inp_pattern_pkey PRIMARY KEY (pattern_id),
	CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 12/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"bulk", "newName":"thickness"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"closed", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE crm_zone RENAME TO crmzone;

-- 13/03/2025
-- arc
ALTER TABLE arc RENAME TO _arc;


-- Drop foreign keys that reference arc
ALTER TABLE config_graph_checkvalve DROP CONSTRAINT config_graph_checkvalve_to_arc_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_arc_id_fkey;
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_arc_id_fkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_arc_id_fkey;
ALTER TABLE inp_pipe DROP CONSTRAINT inp_pipe_arc_id_fkey;
ALTER TABLE inp_virtualvalve DROP CONSTRAINT inp_virtualvalve_arc_id_fkey;
ALTER TABLE man_pipe DROP CONSTRAINT man_pipe_arc_id_fkey;
ALTER TABLE man_pump DROP CONSTRAINT man_pump_to_arc_fkey;
ALTER TABLE man_valve DROP CONSTRAINT man_valve_to_arc_fky;
ALTER TABLE man_varc DROP CONSTRAINT man_varc_arc_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_arc_id_fkey;
ALTER TABLE om_visit_x_arc DROP CONSTRAINT om_visit_x_arc_arc_id_fkey;
ALTER TABLE plan_arc_x_pavement DROP CONSTRAINT plan_arc_x_pavement_arc_id_fkey;
ALTER TABLE plan_psector_x_arc DROP CONSTRAINT plan_psector_x_arc_arc_id_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_arc_id_fkey;


ALTER TABLE IF EXISTS _arc_border_expl_ DROP CONSTRAINT IF EXISTS arc_border_expl_arc_id_fkey;
ALTER TABLE IF EXISTS _inp_valve_importinp_ DROP CONSTRAINT IF EXISTS inp_valve_importinp_to_arc_fkey;
ALTER TABLE IF EXISTS _inp_virtualvalve_ DROP CONSTRAINT IF EXISTS _inp_virtualvalve_arc_id_fkey_;

-- Drop foreign keys from table arc

ALTER TABLE _arc DROP CONSTRAINT arc_arccat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_buildercat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_district_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_expl_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_expl_id2_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_feature_type_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_muni_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_ownercat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_pavcat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_soilcat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_state_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_state_type_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_streetaxis2_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_streetaxis_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_supplyzone_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_workcat_id_end_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_workcat_id_fkey;

-- Drop restrictions from table arc
ALTER TABLE _arc DROP CONSTRAINT arc_epa_type_check;
ALTER TABLE _arc DROP CONSTRAINT arc_pkey;


-- Drop rules from table arc

DROP RULE IF EXISTS insert_plan_psector_x_arc ON _arc;
DROP RULE IF EXISTS undelete_arc ON _arc;


-- Drop indexes from table arc

DROP INDEX IF EXISTS arc_arccat;
DROP INDEX IF EXISTS arc_dma;
DROP INDEX IF EXISTS arc_dqa;
DROP INDEX IF EXISTS arc_exploitation;
DROP INDEX IF EXISTS arc_exploitation2;
DROP INDEX IF EXISTS arc_index;
DROP INDEX IF EXISTS arc_muni;
DROP INDEX IF EXISTS arc_node1;
DROP INDEX IF EXISTS arc_node2;
DROP INDEX IF EXISTS arc_pkey;
DROP INDEX IF EXISTS arc_presszone;
DROP INDEX IF EXISTS arc_sector;
DROP INDEX IF EXISTS arc_street1;
DROP INDEX IF EXISTS arc_street2;
DROP INDEX IF EXISTS arc_streetname;
DROP INDEX IF EXISTS arc_streetname2;


-- New order to table arc
CREATE TABLE arc (
	arc_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	node_1 int4 NULL,
	nodetype_1 varchar(30) NULL,
	elevation1 numeric(12, 4) NULL,
	depth1 numeric(12, 4) NULL,
	staticpress1 numeric(12, 3) NULL,
	node_2 int4 NULL,
	nodetype_2 varchar(30) NULL,
	elevation2 numeric(12, 4) NULL,
	depth2 numeric(12, 4) NULL,
	staticpress2 numeric(12, 3) NULL,
	feature_type varchar(16) DEFAULT 'ARC'::character varying NULL,
	arccat_id varchar(30) NOT NULL,
	epa_type varchar(16) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	parent_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	supplyzone_id int4 DEFAULT 0 NULL,
	presszone_id int4 DEFAULT 0 NULL,
	dma_id int4 DEFAULT 0 NULL,
	dqa_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	pavcat_id varchar(30) NULL,
	soilcat_id varchar(30) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	fluid_type varchar(50) NULL,
	descript varchar(254) NULL,
	custom_length numeric(12, 2) NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	om_state text NULL,
	conserv_state text NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(100) NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	is_scadamap bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT arc_pkey PRIMARY KEY (arc_id),
	CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_pavcat_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT arc_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['PIPE'::text, 'UNDEFINED'::text, 'VIRTUALPUMP'::text, 'VIRTUALVALVE'::text])))
);


CREATE INDEX arc_arccat ON arc USING btree (arccat_id);
CREATE INDEX arc_dma ON arc USING btree (dma_id);
CREATE INDEX arc_dqa ON arc USING btree (dqa_id);
CREATE INDEX arc_exploitation ON arc USING btree (expl_id);
CREATE INDEX arc_expl_visibility_idx ON arc USING btree (expl_visibility);
CREATE INDEX arc_index ON arc USING gist (the_geom);
CREATE INDEX arc_muni ON arc USING btree (muni_id);
CREATE INDEX arc_node1 ON arc USING btree (node_1);
CREATE INDEX arc_node2 ON arc USING btree (node_2);
CREATE INDEX arc_presszone ON arc USING btree (presszone_id);
CREATE INDEX arc_sector ON arc USING btree (sector_id);
CREATE INDEX arc_street1 ON arc USING btree (streetaxis_id);
CREATE INDEX arc_street2 ON arc USING btree (streetaxis2_id);
CREATE INDEX arc_sys_code_idx ON arc USING btree (sys_code);
CREATE INDEX arc_asset_id_idx ON arc USING btree (asset_id);


DO $$
DECLARE
    rec record;
    v_element_id varchar(16);
	v_link_id integer;
    v_midpoint geometry;
BEGIN
    -- Process each connec with cat_valve value
    FOR rec IN SELECT connec_id, cat_valve, the_geom FROM connec WHERE cat_valve IS NOT NULL AND cat_valve != ''
    LOOP
        SELECT ST_LineInterpolatePoint(the_geom, 0.5), link_id INTO v_midpoint, v_link_id
        FROM link
        WHERE feature_id = rec.connec_id AND feature_type = 'CONNEC'
        LIMIT 1;

        INSERT INTO element (elementcat_id, state, expl_id, the_geom)
        VALUES (rec.cat_valve, 1, (SELECT expl_id FROM connec WHERE connec_id = rec.connec_id), COALESCE(v_midpoint, rec.the_geom))
        RETURNING element_id INTO v_element_id;

        INSERT INTO element_x_link (link_id, element_id)
        SELECT v_link_id, v_element_id;
    END LOOP;
END $$;


-- connec
ALTER TABLE connec RENAME TO _connec;


-- Drop foreign keys that reference connec
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_connec_id_fkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_connec_id_fkey;
ALTER TABLE inp_connec DROP CONSTRAINT inp_connec_connec_id_FKEY;
ALTER TABLE man_fountain DROP CONSTRAINT man_fountain_connec_id_fkey;
ALTER TABLE man_fountain DROP CONSTRAINT man_fountain_linked_connec_fkey;
ALTER TABLE man_greentap DROP CONSTRAINT man_greentap_connec_id_fkey;
ALTER TABLE man_greentap DROP CONSTRAINT man_greentap_linked_connec_fkey;
ALTER TABLE man_tap DROP CONSTRAINT man_tap_connec_id_fkey;
ALTER TABLE man_tap DROP CONSTRAINT man_tap_linked_connec_fkey;
ALTER TABLE man_wjoin DROP CONSTRAINT man_wjoin_connec_id_fkey;
ALTER TABLE om_visit_x_connec DROP CONSTRAINT om_visit_x_connec_connec_id_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_connec_id_fkey;
ALTER TABLE rtc_hydrometer_x_connec DROP CONSTRAINT rtc_hydrometer_x_connec_connec_id_fkey;


ALTER TABLE _pond_ DROP CONSTRAINT pond_connec_id_fkey;
ALTER TABLE _pool_ DROP CONSTRAINT pool_connec_id_fkey;

-- Drop foreign keys from table connec

ALTER TABLE _connec DROP CONSTRAINT connec_cat_valve_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_connecat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_buildercat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_district_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_expl_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_expl_id2_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_feature_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_muni_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_ownercat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_pjoint_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_soilcat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_state_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_state_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_streetaxis_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_streetaxis2_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_supplyzone_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_workcat_id_end_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_workcat_id_fkey;


-- Drop restrictions from table arc
ALTER TABLE _connec DROP CONSTRAINT connec_epa_type_check;
ALTER TABLE _connec DROP CONSTRAINT connec_pkey;
ALTER TABLE _connec DROP CONSTRAINT connec_pjoint_type_check;


-- Drop rules from table connec

DROP RULE IF EXISTS undelete_connec ON _connec;

-- Drop indexes from table connec

DROP INDEX IF EXISTS connec_connecat;
DROP INDEX IF EXISTS connec_dma;
DROP INDEX IF EXISTS connec_dqa;
DROP INDEX IF EXISTS connec_exploitation;
DROP INDEX IF EXISTS connec_exploitation2;
DROP INDEX IF EXISTS connec_index;
DROP INDEX IF EXISTS connec_muni;
DROP INDEX IF EXISTS connec_pkey;
DROP INDEX IF EXISTS connec_presszone;
DROP INDEX IF EXISTS connec_sector;
DROP INDEX IF EXISTS connec_street1;
DROP INDEX IF EXISTS connec_street2;
DROP INDEX IF EXISTS connec_streetname;
DROP INDEX IF EXISTS connec_streetname2;


-- New order to table connec
CREATE TABLE connec (
	connec_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 4) NULL,
	"depth" numeric(12, 4) NULL,
	feature_type varchar(16) DEFAULT 'CONNEC'::character varying NULL,
	conneccat_id varchar(30) NOT NULL,
	customer_code varchar(30) NULL,
	connec_length numeric(12, 3) NULL,
	epa_type text NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	arc_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	supplyzone_id int4 DEFAULT 0 NULL,
	presszone_id int4 DEFAULT 0 NULL,
	dma_id int4 DEFAULT 0 NULL,
	dqa_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	crmzone_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	soilcat_id varchar(16) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	fluid_type varchar(50) NULL,
	n_hydrometer int4 NULL,
	n_inhabitants int4 NULL,
	staticpressure numeric(12, 3) NULL,
	descript text NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	block_code text NULL,
	plot_code text NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	pjoint_id int4 NULL,
	pjoint_type varchar(16) NULL,
	om_state text NULL,
	conserv_state text NULL,
	accessibility int2 NULL,
	access_type text NULL,
	placement_type text NULL,
	priority text NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(100) NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	_valve_type text NULL, -- added prefix '_'
	_shutoff_valve text NULL, -- added prefix '_'
	CONSTRAINT connec_epa_type_check CHECK ((epa_type = ANY (ARRAY['JUNCTION'::text, 'UNDEFINED'::text]))),
	CONSTRAINT connec_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text]))),
	CONSTRAINT connec_pkey PRIMARY KEY (connec_id),
	CONSTRAINT connec_connecat_id_fkey FOREIGN KEY (conneccat_id) REFERENCES cat_connec(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_crmzone_id_fkey FOREIGN KEY (crmzone_id) REFERENCES crmzone(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX connec_connecat ON connec USING btree (conneccat_id);
CREATE INDEX connec_dma ON connec USING btree (dma_id);
CREATE INDEX connec_dqa ON connec USING btree (dqa_id);
CREATE INDEX connec_exploitation ON connec USING btree (expl_id);
CREATE INDEX connec_expl_visibility_idx ON connec USING btree (expl_visibility);
CREATE INDEX connec_index ON connec USING gist (the_geom);
CREATE INDEX connec_muni ON connec USING btree (muni_id);
CREATE INDEX connec_presszone ON connec USING btree (presszone_id);
CREATE INDEX connec_sector ON connec USING btree (sector_id);
CREATE INDEX connec_street1 ON connec USING btree (streetaxis_id);
CREATE INDEX connec_street2 ON connec USING btree (streetaxis2_id);
CREATE INDEX connec_sys_code_idx ON connec USING btree (sys_code);
CREATE INDEX connec_asset_id_idx ON connec USING btree (asset_id);



-- element
ALTER TABLE element RENAME TO _element;


-- Drop foreign keys that reference element
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_element_id_fkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_element_id_fkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_element_id_fkey;
ALTER TABLE element_x_link DROP CONSTRAINT element_x_link_element_id_fkey;

-- Drop foreign keys from table element


ALTER TABLE _element DROP CONSTRAINT element_brand_id;
ALTER TABLE _element DROP CONSTRAINT element_category_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_elementcat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_buildercat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_fluid_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_function_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_location_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_model_id;
ALTER TABLE _element DROP CONSTRAINT element_muni_id;
ALTER TABLE _element DROP CONSTRAINT element_muni_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_ownercat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_state_fkey;
ALTER TABLE _element DROP CONSTRAINT element_state_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_workcat_id_end_fkey;
ALTER TABLE _element DROP CONSTRAINT element_workcat_id_fkey;


-- Drop restrictions from table arc
ALTER TABLE _element DROP CONSTRAINT element_pkey;


-- Drop rules from table connec

-- Drop indexes from table connec

DROP INDEX IF EXISTS element_index;
DROP INDEX IF EXISTS element_muni;
DROP INDEX IF EXISTS element_pkey;
DROP INDEX IF EXISTS element_sector;


-- New order to table element
CREATE TABLE element (
	element_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 4) NULL,
	feature_type varchar(16) DEFAULT 'ELEMENT'::character varying NULL,
	elementcat_id varchar(30) NOT NULL,
	epa_type varchar(16) NULL,
	num_elements int4 NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	omzone_id int4 DEFAULT 0 NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	observ varchar(254) NULL,
	"comment" varchar(254) NULL,
	link varchar(512) NULL,
	workcat_id varchar(30) NULL,
	workcat_id_end varchar(30) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(30) NULL,
	asset_id varchar(50) NULL,
	verified int4 NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	inventory bool NULL,
	publish bool NULL,
	trace_featuregeom bool DEFAULT true NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	geometry_type text NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT element_pkey PRIMARY KEY (element_id),
	CONSTRAINT element_brand_id FOREIGN KEY (brand_id) REFERENCES cat_brand(id),
	CONSTRAINT element_elementcat_id_fkey FOREIGN KEY (elementcat_id) REFERENCES cat_element(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_model_id FOREIGN KEY (model_id) REFERENCES cat_brand_model(id),
	--CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_epa_type_check CHECK ((epa_type = ANY (ARRAY['FRPUMP'::text, 'VALVE'::text])))
);

CREATE INDEX element_index ON element USING gist (the_geom);
CREATE INDEX element_muni ON element USING btree (muni_id);
CREATE INDEX element_sys_code_idx ON element USING btree (sys_code);
CREATE INDEX element_sector ON element USING btree (sector_id);
CREATE INDEX element_asset_id_idx ON element USING btree (asset_id);


-- node
ALTER TABLE node RENAME TO _node;

-- Drop foreign keys that reference node
ALTER TABLE _arc DROP CONSTRAINT arc_node_1_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_node_2_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_parent_id_fkey;
ALTER TABLE config_graph_mincut DROP CONSTRAINT config_graph_inlet_node_id_fkey;
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_node_id_fkey;
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_node_id_fkey;
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_node_id_fkey;
ALTER TABLE inp_inlet DROP CONSTRAINT inp_inlet_node_id_fkey;
ALTER TABLE inp_junction DROP CONSTRAINT inp_junction_node_id_fkey;
ALTER TABLE inp_label DROP CONSTRAINT inp_label_node_id_fkey;
ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_node_id_fkey;
ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_node_id_fkey;
ALTER TABLE inp_reservoir DROP CONSTRAINT inp_reservoir_node_id_fkey;
ALTER TABLE inp_shortpipe DROP CONSTRAINT inp_shortpipe_node_id_fkey;
ALTER TABLE inp_tank DROP CONSTRAINT inp_tank_node_id_fkey;
ALTER TABLE inp_valve DROP CONSTRAINT inp_valve_node_id_fkey;
ALTER TABLE man_expansiontank DROP CONSTRAINT man_expansiontank_node_id_fkey;
ALTER TABLE man_filter DROP CONSTRAINT man_filter_node_id_fkey;
ALTER TABLE man_flexunion DROP CONSTRAINT man_flexunion_node_id_fkey;
ALTER TABLE man_hydrant DROP CONSTRAINT man_hydrant_node_id_fkey;
ALTER TABLE man_junction DROP CONSTRAINT man_junction_node_id_fkey;
ALTER TABLE man_manhole DROP CONSTRAINT man_manhole_node_id_fkey;
ALTER TABLE man_meter DROP CONSTRAINT man_meter_node_id_fkey;
ALTER TABLE man_netelement DROP CONSTRAINT man_netelement_node_id_fkey;
ALTER TABLE man_netsamplepoint DROP CONSTRAINT man_netsamplepoint_node_id_fkey;
ALTER TABLE man_netwjoin DROP CONSTRAINT man_netwjoin_node_id_fkey;
ALTER TABLE man_pump DROP CONSTRAINT man_pump_node_id_fkey;
ALTER TABLE man_reduction DROP CONSTRAINT man_reduction_node_id_fkey;
ALTER TABLE man_register DROP CONSTRAINT man_register_node_id_fkey;
ALTER TABLE man_source DROP CONSTRAINT man_source_node_id_fkey;
ALTER TABLE man_tank DROP CONSTRAINT man_tank_node_id_fkey;
ALTER TABLE man_valve DROP CONSTRAINT man_valve_node_id_fkey;
ALTER TABLE man_waterwell DROP CONSTRAINT man_waterwell_node_id_fkey;
ALTER TABLE man_wtp DROP CONSTRAINT man_wtp_node_id_fkey;
ALTER TABLE om_visit_x_node DROP CONSTRAINT om_visit_x_node_node_id_fkey;
ALTER TABLE plan_psector_x_node DROP CONSTRAINT plan_psector_x_node_node_id_fkey;
ALTER TABLE rtc_hydrometer_x_node DROP CONSTRAINT rtc_hydrometer_x_node_node_id_fkey;
ALTER TABLE ext_rtc_scada_x_data DROP CONSTRAINT ext_rtc_scada_x_data_node_id_fkey;

ALTER TABLE IF EXISTS _node_border_sector DROP CONSTRAINT IF EXISTS arc_border_expl_node_id_fkey;
ALTER TABLE IF EXISTS _inp_emitter_ DROP CONSTRAINT IF EXISTS inp_emitter_node_id_fkey;
ALTER TABLE IF EXISTS _inp_mixing_ DROP CONSTRAINT IF EXISTS inp_mixing_node_id_fkey;
ALTER TABLE IF EXISTS _inp_quality_ DROP CONSTRAINT IF EXISTS inp_quality_node_id_fkey;
ALTER TABLE IF EXISTS _inp_source_ DROP CONSTRAINT IF EXISTS inp_source_node_id_fkey;
ALTER TABLE IF EXISTS _inp_valve_ DROP CONSTRAINT IF EXISTS _inp_valve_node_id_fkey_;
ALTER TABLE om_visit_event DROP CONSTRAINT om_visit_event_position_id_fkey;

-- Drop foreign keys from table node
ALTER TABLE _node DROP CONSTRAINT node_parent_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_pkey CASCADE;

ALTER TABLE _node DROP CONSTRAINT node_epa_type_check;

ALTER TABLE _node DROP CONSTRAINT node_buildercat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_district_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_expl_fkey;
ALTER TABLE _node DROP CONSTRAINT node_expl_id2_fkey;
ALTER TABLE _node DROP CONSTRAINT node_feature_type_fkey;
ALTER TABLE _node DROP CONSTRAINT node_muni_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_nodecat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_ownercat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_soilcat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_state_fkey;
ALTER TABLE _node DROP CONSTRAINT node_state_type_fkey;
ALTER TABLE _node DROP CONSTRAINT node_streetaxis2_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_streetaxis_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_workcat_id_end_fkey;
ALTER TABLE _node DROP CONSTRAINT node_workcat_id_fkey;

-- Drop restrictions from table node
ALTER TABLE _node DROP CONSTRAINT cat_pavement_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_supplyzone_id_fkey;

-- Drop rules from table node
DROP RULE IF EXISTS insert_plan_psector_x_node ON _node;
DROP RULE IF EXISTS undelete_node ON _node;


-- Drop indexes from table node
DROP INDEX IF EXISTS node_arc_id;
DROP INDEX IF EXISTS node_dma;
DROP INDEX IF EXISTS node_dqa;
DROP INDEX IF EXISTS node_exploitation;
DROP INDEX IF EXISTS node_exploitation2;
DROP INDEX IF EXISTS node_index;
DROP INDEX IF EXISTS node_muni;
DROP INDEX IF EXISTS node_nodecat;
DROP INDEX IF EXISTS node_presszone;
DROP INDEX IF EXISTS node_sector;
DROP INDEX IF EXISTS node_street1;
DROP INDEX IF EXISTS node_street2;
DROP INDEX IF EXISTS node_streetname;
DROP INDEX IF EXISTS node_streetname2;


CREATE TABLE node (
	node_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 4) NULL,
	custom_top_elev numeric(12, 4) NULL,
	"depth" numeric(12, 4) NULL,
	feature_type varchar(16) DEFAULT 'NODE'::character varying NULL,
	nodecat_id varchar(30) NOT NULL,
	epa_type varchar(16) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	arc_id int4 NULL,
	parent_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	supplyzone_id int4 NULL,
	presszone_id int4 NULL,
	dma_id int4 NULL,
	dqa_id int4 NULL,
	omzone_id int4 NULL,
	minsector_id int4 NULL,
	pavcat_id text NULL,
	soilcat_id varchar(30) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	fluid_type varchar(50) NULL,
	staticpressure numeric(12, 3) NULL,
	annotation text NULL,
	observ text NULL,
	"comment" text NULL,
	descript varchar(254) NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	streetaxis_id varchar(16) NULL,
	postcode varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	accessibility int2 NULL,
	om_state text NULL,
	conserv_state text NULL,
	access_type text NULL,
	placement_type text NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(100) NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	datasource int4 NULL,
	hemisphere float8 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	is_scadamap bool NULL,
	lock_level int4 NULL,
	expl_visibility integer[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT node_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['JUNCTION'::text, 'RESERVOIR'::text, 'TANK'::text, 'INLET'::text, 'UNDEFINED'::text, 'SHORTPIPE'::text, 'VALVE'::text, 'PUMP'::text]))),
	CONSTRAINT node_pkey PRIMARY KEY (node_id),
	CONSTRAINT node_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_pavement_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX node_arc_id ON node USING btree (arc_id);
CREATE INDEX node_dma ON node USING btree (dma_id);
CREATE INDEX node_dqa ON node USING btree (dqa_id);
CREATE INDEX node_exploitation ON node USING btree (expl_id);
CREATE INDEX node_expl_visibility_idx ON node USING btree (expl_visibility);
CREATE INDEX node_index ON node USING gist (the_geom);
CREATE INDEX node_muni ON node USING btree (muni_id);
CREATE INDEX node_nodecat ON node USING btree (nodecat_id);
CREATE INDEX node_presszone ON node USING btree (presszone_id);
CREATE INDEX node_sector ON node USING btree (sector_id);
CREATE INDEX node_street1 ON node USING btree (streetaxis_id);
CREATE INDEX node_street2 ON node USING btree (streetaxis2_id);
CREATE INDEX node_sys_code_idx ON node USING btree (sys_code);
CREATE INDEX node_asset_id_idx ON node USING btree (asset_id);

ALTER TABLE link RENAME TO _link;

-- Drop foreign keys from table link
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_link_id_fkey;
ALTER TABLE om_visit_x_link DROP CONSTRAINT om_visit_x_link_link_id_fkey;
ALTER TABLE doc_x_link DROP CONSTRAINT doc_x_link_link_id_fkey;
ALTER TABLE element_x_link DROP CONSTRAINT element_x_link_link_id_fkey;

-- Drop constraints from table link
ALTER TABLE _link DROP CONSTRAINT link_pkey;
ALTER TABLE _link DROP CONSTRAINT link_connecat_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_exit_type_fkey;
ALTER TABLE _link DROP CONSTRAINT link_exploitation_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_feature_type_fkey;
ALTER TABLE _link DROP CONSTRAINT link_muni_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_state_fkey;
ALTER TABLE _link DROP CONSTRAINT link_supplyzone_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_workcat_id_end_fkey;
ALTER TABLE _link DROP CONSTRAINT link_workcat_id_fkey;

-- Drop indexes from table link
DROP INDEX IF EXISTS link_exit_id;
DROP INDEX IF EXISTS link_expl_id2;
DROP INDEX IF EXISTS link_exploitation2;
DROP INDEX IF EXISTS link_feature_id;
DROP INDEX IF EXISTS link_index;
DROP INDEX IF EXISTS link_muni;

CREATE TABLE link (
	link_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
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
	epa_type varchar(16) NULL,
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
	staticpressure numeric(12, 3) NULL,
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
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT link_pkey PRIMARY KEY (link_id),
	CONSTRAINT link_linkcat_id_fkey FOREIGN KEY (linkcat_id) REFERENCES cat_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE, -- UPDATED reference on 4.0.001
	CONSTRAINT link_exit_type_fkey FOREIGN KEY (exit_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	--CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id),
	CONSTRAINT link_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX link_exit_id ON link USING btree (exit_id);
CREATE INDEX link_expl_visibility_idx ON link USING btree (expl_visibility);
CREATE INDEX link_feature_id ON link USING btree (feature_id);
CREATE INDEX link_index ON link USING gist (the_geom);
CREATE INDEX link_muni ON link USING btree (muni_id);


--25/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"screening", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"desander", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"chemcond", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"oxidation", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"coagulation", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"floculation", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"presendiment", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"sediment", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"filtration", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"disinfection", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"chemtreatment", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"storage", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"sludgeman", "dataType":"int4", "isUtils":"False"}}$$);

--26/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_connec", "column":"estimated_depth", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

-- 02/04/2025
-- fix archived_psector_*_traceability


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_connec_traceability", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_connec_traceability", "column":"elevation", "newName":"top_elev"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_connec_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_connec_traceability", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"valve_location"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"shutoff_valve"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"n_inhabitants", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"supplyzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"block_zone", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"n_hydrometer", "dataType":"int4", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"_sys_length"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"depth"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"staticpressure"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_arc_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"supplyzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"is_scadamap", "dataType":"bool", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_node_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"top_elev", "dataType":"numeric(12, 4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"custom_top_elev", "dataType":"numeric(12, 4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"supplyzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"is_scadamap", "dataType":"bool", "isUtils":"False"}}$$);

-- 09/04/2025
-- macrosector
ALTER TABLE macrosector RENAME TO _macrosector;

-- Drop foreign keys that reference macrosector
ALTER TABLE sector DROP CONSTRAINT sector_macrosector_id_fkey;

-- Drop restrictions from table macrosector
ALTER TABLE _macrosector DROP CONSTRAINT macrosector_pkey;

ALTER SEQUENCE macrosector_macrosector_id_seq RENAME TO macrosector_macrosector_id_seq1;

-- Drop rules from table macrosector
DROP RULE IF EXISTS macrosector_del_undefined ON _macrosector;
DROP RULE IF EXISTS macrosector_undefined ON _macrosector;


-- Drop indexes from table macrosector
DROP INDEX IF EXISTS macrosector_index;
DROP INDEX IF EXISTS macrosector_pkey;


CREATE TABLE macrosector (
	macrosector_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macrosector_pkey PRIMARY KEY (macrosector_id)
);

CREATE INDEX macrosector_index ON macrosector USING gist (the_geom);


-- macrodma
ALTER TABLE macrodma RENAME TO _macrodma;

-- Drop foreign keys that reference macrodma
ALTER TABLE dma DROP CONSTRAINT dma_macrodma_id_fkey;

-- Drop foreign keys from table macrodma
ALTER TABLE _macrodma DROP CONSTRAINT IF EXISTS macrodma_expl_id_fkey;

-- Drop restrictions from table macrodma
ALTER TABLE _macrodma DROP CONSTRAINT macrodma_pkey;

ALTER SEQUENCE macrodma_macrodma_id_seq RENAME TO macrodma_macrodma_id_seq1;

-- Drop rules from table macrodma
DROP RULE IF EXISTS macrodma_del_undefined ON _macrodma;
DROP RULE IF EXISTS macrodma_undefined ON _macrodma;


-- Drop indexes from table macrodma
DROP INDEX IF EXISTS macrodma_index;
DROP INDEX IF EXISTS macrodma_pkey;


CREATE TABLE macrodma (
	macrodma_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	expl_id int4[] NOT NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macrodma_pkey PRIMARY KEY (macrodma_id)
);
CREATE INDEX macrodma_index ON macrodma USING gist (the_geom);

-- macrodqa
ALTER TABLE macrodqa RENAME TO _macrodqa;

-- Drop foreign keys that reference macrodqa
ALTER TABLE dqa DROP CONSTRAINT dqa_macrodqa_id_fkey;

-- Drop foreign keys from table macrodqa
ALTER TABLE _macrodqa DROP CONSTRAINT IF EXISTS macrodqa_expl_id_fkey;

-- Drop restrictions from table macrodqa
ALTER TABLE _macrodqa DROP CONSTRAINT macrodqa_pkey;

ALTER SEQUENCE macrodqa_macrodqa_id_seq RENAME TO macrodqa_macrodqa_id_seq1;

-- Drop rules from table macrodqa
DROP RULE IF EXISTS macrodqa_del_undefined ON _macrodqa;
DROP RULE IF EXISTS macrodqa_undefined ON _macrodqa;


-- Drop indexes from table macrodqa
DROP INDEX IF EXISTS macrodqa_pkey;


CREATE TABLE macrodqa (
	macrodqa_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	expl_id int4[] NOT NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macrodqa_pkey PRIMARY KEY (macrodqa_id)
);

-- macroexploitation
ALTER TABLE macroexploitation RENAME TO _macroexploitation;

-- Drop foreign keys that reference macroexploitation
ALTER TABLE exploitation DROP CONSTRAINT macroexpl_id_fkey;

-- Drop restrictions from table macroexploitation
ALTER TABLE _macroexploitation DROP CONSTRAINT macroexploitation_pkey;

-- Drop rules from table macroexploitation
DROP RULE IF EXISTS macroexploitation_del_undefined ON _macroexploitation;
DROP RULE IF EXISTS macroexploitation_undefined ON _macroexploitation;

-- Drop indexes from table macroexploitation
DROP INDEX IF EXISTS macroexploitation_pkey;


CREATE TABLE macroexploitation (
	macroexpl_id int4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript varchar(100) NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macroexploitation_pkey PRIMARY KEY (macroexpl_id)
);


-- exploitation
ALTER TABLE exploitation RENAME TO _exploitation;

-- Drop foreign keys that reference exploitation
DO $$
DECLARE
	v_utils boolean;
BEGIN
	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS NOT TRUE THEN
		ALTER TABLE ext_streetaxis DROP CONSTRAINT ext_streetaxis_exploitation_id_fkey;
		ALTER TABLE ext_address DROP CONSTRAINT ext_address_exploitation_id_fkey;
		ALTER TABLE ext_plot DROP CONSTRAINT ext_plot_exploitation_id_fkey;
	END IF;
END $$;
ALTER TABLE node DROP CONSTRAINT node_expl_fkey;
ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_expl_id_fkey;
ALTER TABLE om_streetaxis DROP CONSTRAINT om_streetaxis_exploitation_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_expl_fkey;
ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_expl_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_exploitation_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_exploitation_id_fkey;
ALTER TABLE om_mincut DROP CONSTRAINT om_mincut_expl_id_fkey;
ALTER TABLE selector_expl DROP CONSTRAINT selector_expl_id_fkey;
ALTER TABLE plan_psector DROP CONSTRAINT plan_psector_expl_id_fkey;
ALTER TABLE plan_netscenario DROP CONSTRAINT plan_netscenario_expl_id_fkey;
ALTER TABLE om_visit DROP CONSTRAINT om_visit_expl_id_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_expl_fkey;
ALTER TABLE link DROP CONSTRAINT link_exploitation_id_fkey;
ALTER TABLE inp_pattern DROP CONSTRAINT inp_pattern_expl_id_fkey;
ALTER TABLE minsector DROP CONSTRAINT minsector_expl_id_fkey;
ALTER TABLE cat_dscenario DROP CONSTRAINT cat_dscenario_expl_id_fkey;
ALTER TABLE inp_curve DROP CONSTRAINT inp_curve_expl_id_fkey;
ALTER TABLE IF EXISTS _arc_border_expl_ DROP CONSTRAINT IF EXISTS arc_border_expl_expl_id_fkey;
ALTER TABLE IF EXISTS _pond_ DROP CONSTRAINT IF EXISTS pond_exploitation_id_fkey;
ALTER TABLE IF EXISTS _pool_ DROP CONSTRAINT IF EXISTS pool_exploitation_id_fkey;


-- Drop foreign keys from table exploitation
--ALTER TABLE _exploitation DROP CONSTRAINT exploitation_id_fkey;

-- Drop restrictions from table exploitation
ALTER TABLE _exploitation DROP CONSTRAINT exploitation_pkey;

-- Drop rules from table exploitation
DROP RULE IF EXISTS exploitation_del_undefined ON _exploitation;
DROP RULE IF EXISTS exploitation_undefined ON _exploitation;
DROP RULE IF EXISTS undelete_exploitation ON _exploitation;


-- Drop indexes from table exploitation
DROP INDEX IF EXISTS exploitation_index;
--DROP INDEX IF EXISTS exploitation_pkey;


CREATE TABLE exploitation (
	expl_id int4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	sector_id int4[] NULL,
	muni_id int4[] NULL,
	macroexpl_id int4 NOT NULL,
	avg_press numeric(12,3) NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT exploitation_pkey PRIMARY KEY (expl_id),
	CONSTRAINT macroexpl_id_fkey FOREIGN KEY (macroexpl_id) REFERENCES macroexploitation(macroexpl_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX exploitation_index ON exploitation USING gist (the_geom);



-- 10/04/2025
CREATE TABLE IF NOT EXISTS macroomzone (
    macroomzone_id serial4,
    code text NULL,
    "name" varchar(50) NOT NULL,
    descript text NULL,
	expl_id int4[] NOT NULL,
    lock_level int4 NULL,
	active bool DEFAULT true NULL,
    the_geom public.geometry(MultiPolygon, SRID_VALUE),
    created_at timestamp with time zone DEFAULT now() NULL,
    created_by varchar(50) DEFAULT CURRENT_USER NULL,
    updated_at timestamp with time zone NULL,
    updated_by varchar(50) NULL,
    CONSTRAINT macroomzone_pkey PRIMARY KEY (macroomzone_id)
);


CREATE TABLE IF NOT EXISTS omzone (
    omzone_id serial4,
	code text NULL,
	"name" varchar(30) NULL,
    descript text NULL,
	omzone_type varchar(16) NULL,
    muni_id integer[],
    expl_id integer[],
    macroomzone_id integer,
    link text,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
    the_geom public.geometry(MultiPolygon, SRID_VALUE),
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
    CONSTRAINT omzone_pkey PRIMARY KEY (omzone_id),
    CONSTRAINT omzone_macroomzone_id_fkey FOREIGN KEY (macroomzone_id) REFERENCES macroomzone (macroomzone_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE macrocrmzone (
	macrocrmzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macrocrmzone_pkey PRIMARY KEY (macrocrmzone_id)
);

ALTER TABLE crmzone ADD COLUMN macrocrmzone_id integer;
ALTER TABLE crmzone ADD CONSTRAINT crmzone_macrocrmzone_id_fkey FOREIGN KEY (macrocrmzone_id) REFERENCES macrocrmzone (macrocrmzone_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE crmzone ADD COLUMN created_at timestamp with time zone DEFAULT now() NULL;
ALTER TABLE crmzone ADD COLUMN created_by varchar(50) DEFAULT CURRENT_USER NULL;
ALTER TABLE crmzone ADD COLUMN updated_at timestamp with time zone NULL;
ALTER TABLE crmzone ADD COLUMN updated_by varchar(50) NULL;

-- Drop foreign keys for muni_id
ALTER TABLE selector_municipality DROP CONSTRAINT selector_municipality_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id;
ALTER TABLE om_visit DROP CONSTRAINT om_visit_muni_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		DROP INDEX IF EXISTS idx_municipality_name;
		DROP INDEX IF EXISTS idx_municipality_the_geom;

		DROP VIEW ext_municipality;

		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_pkey TO _municipality_pkey;
		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_region_id_fkey TO _municipality_region_id_fkey;
		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_province_id_fkey TO _municipality_province_id_fkey;
		ALTER TABLE utils.municipality RENAME TO _municipality;

		CREATE TABLE utils.municipality (
			muni_id integer NOT NULL,
			name text NOT NULL,
			expl_id INT4[] NULL,
			sector_id INT4[] NULL,
			observ text,
			the_geom public.geometry(MultiPolygon,SRID_VALUE),
			active boolean DEFAULT true,
			region_id int4 NULL,
			province_id int4 NULL,
			ext_code text NULL,
			CONSTRAINT municipality_pkey PRIMARY KEY (muni_id),
			CONSTRAINT municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES ext_region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
			CONSTRAINT municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
		);

    ELSE

		DROP INDEX IF EXISTS idx_ext_municipality_name;
		DROP INDEX IF EXISTS idx_ext_municipality_the_geom;

		ALTER TABLE ext_address DROP CONSTRAINT ext_address_muni_id_fkey;
		ALTER TABLE ext_district DROP CONSTRAINT ext_district_muni_id_fkey;
		ALTER TABLE ext_plot DROP CONSTRAINT ext_plot_muni_id_fkey;
		ALTER TABLE ext_streetaxis DROP CONSTRAINT ext_streetaxis_muni_id_fkey;
		ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_streetaxis_muni_id_fkey;

		DROP VIEW IF EXISTS v_ext_municipality;

		-- DROP TABLE ext_municipality;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_pkey TO _ext_municipality_pkey;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_region_id_fkey TO _ext_municipality_region_id_fkey;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_province_id_fkey TO _ext_municipality_province_id_fkey;
		ALTER TABLE ext_municipality RENAME TO _ext_municipality;

		CREATE TABLE ext_municipality (
			muni_id integer NOT NULL,
			name text NOT NULL,
			expl_id INT4[] NULL,
			sector_id INT4[] NULL,
			observ text,
			the_geom public.geometry(MultiPolygon,SRID_VALUE),
			active boolean DEFAULT true,
			region_id int4 NULL,
			province_id int4 NULL,
			ext_code varchar(50) NULL,
			CONSTRAINT ext_municipality_pkey PRIMARY KEY (muni_id),
			CONSTRAINT ext_municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES ext_region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
			CONSTRAINT ext_municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
		);

    END IF;
END; $$;