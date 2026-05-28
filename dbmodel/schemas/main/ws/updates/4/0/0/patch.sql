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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_virtualpump", "column":"energyvalue"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector_graph", "column":"expl_id"}}$$);



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


DROP VIEW IF EXISTS v_edit_pool;
DROP VIEW IF EXISTS v_edit_pond;

ALTER TABLE pool RENAME to _pool_;
ALTER TABLE pond rename TO _pond_;

DELETE FROM sys_table WHERE id IN ('v_edit_pool','v_edit_pond','pool','pond');
DELETE FROM config_form_fields WHERE formname IN ('v_edit_pool', 'v_edit_pond');

DROP FUNCTION IF EXISTS gw_trg_edit_unconnected();

ALTER TABLE node_border_sector drop CONSTRAINT node_border_expl_sector_id_fkey;
ALTER TABLE node_border_sector RENAME TO _node_border_sector;



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


ALTER TABLE cat_mat_roughness DROP CONSTRAINT cat_mat_roughness_matcat_id_fkey;
ALTER TABLE cat_mat_roughness ADD CONSTRAINT cat_mat_roughness_cat_material_fk FOREIGN KEY (matcat_id) REFERENCES cat_material(id);


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



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE arc ADD CONSTRAINT arc_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE node ADD CONSTRAINT node_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE connec ADD CONSTRAINT connec_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"supplyzone_id", "dataType":"int4"}}$$);
ALTER TABLE link ADD CONSTRAINT link_supplyzone_id_fkey FOREIGN KEY (supplyzone_id) REFERENCES supplyzone(supplyzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"verified", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"verified", "dataType":"integer"}}$$);



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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_arc", "column":"dr", "dataType":"integer", "isUtils":"False"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"arc", "column":"is_scadamap", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"node", "column":"is_scadamap", "dataType":"boolean", "isUtils":"False"}}$$);


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_valve", "column":"active"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"fluid_type", "dataType":"varchar(50)"}}$$);


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"bulk", "newName":"thickness"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"closed", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE crm_zone RENAME TO crmzone;


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_connec", "column":"estimated_depth", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


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

-- delete all views to avoid conflicts, then recreate them
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        CREATE OR REPLACE VIEW ext_municipality AS SELECT * FROM utils.municipality;

    ELSE
    
        CREATE OR REPLACE VIEW v_ext_municipality
        AS SELECT DISTINCT s.muni_id,
            m.name,
            m.expl_id,
            m.sector_id,
            m.active,
            m.the_geom
            FROM ext_municipality m, selector_municipality s
            WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

    END IF;
END; $$;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

-- drop gw_trg_presszone_check_datatype
DELETE FROM sys_function WHERE id=3306;




UPDATE inp_typevalue
SET idval='VIRTUALPUMP', id='VIRTUALPUMP'
WHERE typevalue='inp_typevalue_dscenario' AND id='VITUALPUMP';

UPDATE config_form_fields
	SET layoutname='lyt_buttons'
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='cancel' AND tabname='tab_none';
UPDATE config_form_fields
	SET layoutname='lyt_buttons'
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='hspacer_lyt_bot_3' AND tabname='tab_none';


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dma', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dma', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dqa', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dqa', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_sector', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_sector', 'form_generic', 'tab_none', 'expl_id', 'lyt_data_1', 'string', 'text', 'Expl_id', 'Expl_id', false, false, true, false, false);


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_shutoff_valve', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_check_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_reduc_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_pr_green_valve', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_break_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_outfall_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_susta_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_air_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_fl_contr_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_gen_purp_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_throttle_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pump','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_flowmeter','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_pressure_meter', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');


INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3272,'The selected arc is not directly connected to the specified node. Please ensure the arc is directly linked to the node and select one that meets this requirement.','Select one arc that is connected to the selected node',2,true,'utils','core');


UPDATE config_form_fields SET columnname='arc_type', "label"='arc_type', tooltip='arc_type' WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='arctype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_arc_type', "label"='arc_type', tooltip='cat_arc_type' WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='cat_arctype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='node_type', "label"='node_type', tooltip='node_type' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_node_type', "label"='node_type', tooltip='node_type' WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_data';



INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcp_pipes', 'View pipes for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_junction', 'View junction for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_demands', 'View demands for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_patterns', 'View patterns for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_emitters_log', 'View emiters log for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_dma_log', 'View dma for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);


INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_value_status_valve','CLOSED','CLOSED');
INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_value_status_valve','OPEN','OPEN');


INSERT INTO sys_param_user (id,formname,descript,sys_role,idval,"label",dv_querytext,isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
	VALUES ('inp_report_headloss','epaoptions','If true, value of headloss will be reported','role_epa','HEADLOSS','Headloss','SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''',true,11,'ws',false,false,'string','combo',true,'YES','lyt_reports_1',false,'core');

DELETE FROM config_form_fields WHERE columnname = 'energyvalue';


UPDATE config_form_fields SET dv_querytext_filterc = ' AND arc_type'
WHERE dv_querytext_filterc ilike '%arctype_id%';
UPDATE config_form_fields SET dv_querytext_filterc = ' AND node_type'
WHERE dv_querytext_filterc ilike '%nodetype_id%';
UPDATE config_form_fields SET dv_querytext_filterc = ' AND connec_type'
WHERE dv_querytext_filterc ilike '%connectype_id%';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_time', 'Time', 'Time', 'role_basic', NULL, NULL, 1, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_compare', 'lyt_result_1', 1, 'string', 'combo', 'Result name (to compare):', 'Result name (to compare)', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_show', 'lyt_result_1', 0, 'string', 'combo', 'Result name (to show):', 'Result name', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'tab_main', 'lyt_epa_select_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"tabs":["tab_result", "tab_time"]}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'time_compare', 'lyt_time_1', 3, 'string', 'combo', 'Time (to compare):', 'Time (to compare)', NULL, false, false, true, false, false, 'SELECT DISTINCT time as id, time as idval FROM rpt_arc WHERE result_id is not null', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'time_show', 'lyt_time_1', 2, 'string', 'combo', 'Time (to show):', 'Time show', NULL, false, false, true, false, false, 'SELECT DISTINCT time as id, time as idval FROM rpt_arc WHERE result_id is not null', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_time', '{"layouts":["lyt_time_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('epa_results', 'SELECT result_id AS id, expl_id::text, sector_id::text, network_type, status, iscorporate::text, descript, cur_user, exec_date, rpt_stats::text, addparam, export_options, network_stats, inp_options FROM v_ui_rpt_cat_result', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_edit",
      "widgetfunction": {
        "functionName": "edit",
        "params": {}
      },
      "color": "default",
      "text": "Edit",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_show_inp_data",
      "widgetfunction": {
        "functionName": "showInpData",
        "params": {}
      },
      "color": "default",
      "text": "Show inp data",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_toggle_archive",
      "widgetfunction": {
        "functionName": "toggleArchive",
        "params": {}
      },
      "color": "default",
      "text": "Toggle archive",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_toggle_corporate",
      "widgetfunction": {
        "functionName": "toggleCorporate",
        "params": {}
      },
      "color": "default",
      "text": "Toggle corporate",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);



INSERT INTO connec_add (connec_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id)
SELECT connec_id, demand, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id from _connec_add_;



INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_1', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_2', 'lyt_nvo_mng_2', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_3', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_roughness_1', 'lyt_roughness_1', 'layoutRoughness1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_curves_1', 'lyt_curves_1', 'layoutCurves1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_patterns_1', 'lyt_patterns_1', 'layoutPatterns1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_controls_1', 'lyt_controls_1', 'layoutControls1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_rules_1', 'lyt_rules_1', 'layoutRules1', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_roughness', 'tab_roughness', 'tabRoughness', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_curves', 'tab_curves', 'tabCurves', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_patterns', 'tab_patterns', 'tabPatterns', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_controls', 'tab_controls', 'tabControls', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_rules', 'tab_rules', 'tabRules', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_manager', 'nvo_manager', 'nonVisualObjectsManager', NULL);


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_roughness', 'Roughness', 'Roughness', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_curves', 'Curves', 'Curves', 'role_basic', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_patterns', 'Patterns', 'Patterns', 'role_basic', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_rules', 'Rules', 'Rules', 'role_basic', NULL, NULL, 4, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_patterns', 'tab_patterns', 'lyt_patterns_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_patterns', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_controls', 'tab_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_controls', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_rules', 'tab_rules', 'lyt_rules_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_rules', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_roughness', 'tab_roughness', 'lyt_roughness_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_roughness', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'tab_main', 'lyt_nvo_mng_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_roughness",
    "tab_curves",
    "tab_patterns",
    "tab_controls",
    "tab_rules"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "closeDlg"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_curves', 'tab_curves', 'lyt_curves_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_curves', false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_rules', 'SELECT * FROM v_edit_inp_rules WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openRules","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Rule"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openRules","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_curves', 'SELECT * FROM v_edit_inp_curve WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openCurves","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Curve"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openCurves","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_roughness', 'SELECT id, matcat_id, period_id, init_age, end_age, roughness, descript, active::text as active FROM cat_mat_roughness WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[{"id":"id","value":"","filterVariant":"text"}],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openRoughness","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Roughness"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openRoughness"},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_patterns', 'SELECT * FROM v_edit_inp_pattern WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"pattern_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openPatterns","params":{"initialHeight":570,"initialWidth":715,"minHeight":570,"minWidth":713,"title":"Pattern"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openPatterns","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_controls', 'SELECT * FROM v_edit_inp_controls WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openControls","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Control"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openControls","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'matcat_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'period_id', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'init_age', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'end_age', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'roughness', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'descript', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'active', 7, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'expl_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'pattern_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "pattern_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'observ', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'curve_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "curve_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'tscode', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'tsparameters', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'expl_id', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'log', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'log', 4, true, NULL, NULL, NULL, NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_roughness', '{"layouts":["lyt_roughness_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_curves', '{"layouts":["lyt_curves_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_patterns', '{"layouts":["lyt_patterns_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_rules', '{"layouts":["lyt_rules_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_roughness_1', 'lyt_nvo_roughness_1', 'layoutNonVisualObjectsRoughness1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_roughness', 'nvo_roughness', 'nonVisualObjectsRoughness', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'matcat_id', 'lyt_nvo_roughness_1', 0, NULL, 'combo', 'Matcat ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'active', 'lyt_nvo_roughness_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'period_id', 'lyt_nvo_roughness_1', 2, NULL, 'text', 'Period ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'init_age', 'lyt_nvo_roughness_1', 3, NULL, 'text', 'Init Age', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'end_age', 'lyt_nvo_roughness_1', 4, NULL, 'text', 'End Age', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'roughness', 'lyt_nvo_roughness_1', 5, NULL, 'text', 'Roughness', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'descript', 'lyt_nvo_roughness_1', 6, NULL, 'text', 'Descript', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 6);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_1', 'lyt_nvo_curves_1', 'layoutNonVisualObjectsCurves1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_2', 'lyt_nvo_curves_2', 'layoutNonVisualObjectsCurves2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_3', 'lyt_nvo_curves_3', 'layoutNonVisualObjectsCurves3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_curves', 'nvo_curves', 'nonVisualObjectsCurves', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'tbl_curves', 'lyt_nvo_curves_3', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_curves', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'img_plot', 'lyt_nvo_curves_3', 1, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'descript', 'lyt_nvo_curves_2', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'id', 'lyt_nvo_curves_1', 0, NULL, 'text', 'Curve ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'curve_type', 'lyt_nvo_curves_1', 1, NULL, 'combo', 'Curve Type', NULL, NULL, false, false, false, false, false, 'SELECT DISTINCT curve_type AS id, curve_type AS idval FROM v_edit_inp_curve', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'expl_id', 'lyt_nvo_curves_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_curves', 'SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id IS NOT NULL ', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_1', 'lyt_nvo_patterns_1', 'layoutNonVisualObjectsPatterns1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_2', 'lyt_nvo_patterns_2', 'layoutNonVisualObjectsPatterns2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_3', 'lyt_nvo_patterns_3', 'layoutNonVisualObjectsPatterns3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_patterns', 'nvo_patterns', 'nonVisualObjectsPatterns', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'pattern_id', 'lyt_nvo_patterns_1', 0, NULL, 'text', 'Pattern ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'observ', 'lyt_nvo_patterns_1', 1, NULL, 'text', 'Observation', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'expl_id', 'lyt_nvo_patterns_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns', 'lyt_nvo_patterns_2', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'img_plot', 'lyt_nvo_patterns_3', 0, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_controls_1', 'lyt_nvo_controls_1', 'layoutNonVisualObjectsControls1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_controls', 'nvo_controls', 'nonVisualObjectsControls', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'sector_id', 'lyt_nvo_controls_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'active', 'lyt_nvo_controls_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'text', 'lyt_nvo_controls_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_rules_1', 'lyt_nvo_rules_1', 'layoutNonVisualObjectsRules1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_rules', 'nvo_rules', 'nonVisualObjectsRules', NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'active', 'lyt_nvo_rules_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'text', 'lyt_nvo_rules_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'sector_id', 'lyt_nvo_rules_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);



UPDATE sys_style SET stylevalue = replace(stylevalue,'max_vel','vel_max_compare') WHERE layername IN ( 'v_rpt_comp_arc');

INSERT INTO inp_dscenario_demand (dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source")
SELECT dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source" FROM _inp_dscenario_demand;

INSERT INTO config_param_user (parameter, value, cur_user)
SELECT
    'plan_netscenario_current' AS parameter,
    netscenario_id AS value,
    cur_user
FROM _selector_netscenario
ON CONFLICT (parameter, cur_user)
DO UPDATE SET
    value = excluded.value;


UPDATE sys_style SET stylevalue = replace(stylevalue,'vel','vel_compare') WHERE layername IN  ('v_rpt_comp_arc_hourly');



update sys_message
set error_message = 'Feature is out of sector, feature_id: %feature_id%'
where id = 1010;

update sys_message
set error_message = 'Feature is out of dma, feature_id: %feature_id%'
where id = 1014;

update sys_message
set error_message = 'One or more arcs has the same node as Node1 and Node2. Node_id: %node_id%'
where id = 1040;

update sys_message
set error_message = 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id: %arc_id%'
where id = 1042;

update sys_message
set error_message = 'Exists one o more connecs closer than configured minimum distance, connec_id: %connec_id%'
where id = 1044;

update sys_message
set error_message = 'Exists one o more nodes closer than configured minimum distance, node_id: %node_id%'
where id = 1046;

update sys_message
set error_message = 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) = %num_arc%, %feature_id%'
where id = 1056;

update sys_message
set error_message = 'There is at least one element attached to the deleted feature. (num. element,feature_id) = %num_element%, %feature_id%'
where id = 1058;

update sys_message
set error_message = 'There is at least one document attached to the deleted feature. (num. document,feature_id) = %num_document%, %feature_id%'
where id = 1060;

update sys_message
set error_message = 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) = %num_visit%, %feature_id%'
where id = 1062;

update sys_message
set error_message = 'There is at least one link attached to the deleted feature. (num. link,feature_id) = %num_link%, %feature_id%'
where id = 1064;

update sys_message
set error_message = 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) = %num_connec%, %feature_id%'
where id = 1066;

update sys_message
set error_message = 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)= %num_gully%, %feature_id%'
where id = 1068;

update sys_message
set error_message = 'The feature can''t be replaced, because it''s state is different than 1. State = %state_id%'
where id = 1070;

update sys_message
set error_message = 'Before downgrading the node to state 0, disconnect the associated features, node_id: %node_id%'
where id = 1072;

update sys_message
set error_message = 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: %arc_id%'
where id = 1074;

update sys_message
set error_message = 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: %connec_id%'
where id = 1076;

update sys_message
set error_message = 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: %gully_id%'
where id = 1078;

update sys_message
set error_message = 'Nonexistent arc_id: %arc_id%'
where id = 1082;

update sys_message
set error_message = 'Nonexistent node_id: %node_id%'
where id = 1084;

update sys_message
set error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is: %node_id%'
where id = 1096;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is: %node_id%'
where id = 1097;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is: %node_id%'
where id = 1100;

update sys_message
set error_message = 'Feature is out of exploitation, feature_id: %feature_id%'
where id = 2012;

update sys_message
set error_message = '(arc_id, geom type) = %arc_id%, %geom_type%'
where id = 2022;

update sys_message
set error_message = 'The feature does not have state(1) value to be replaced, state = %state_id%'
where id = 2028;

update sys_message
set error_message = 'The feature not have state(2) value to be replaced, state = %state_id%'
where id = 2030;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id, arc_id: %arc_id%'
where id = 2036;

update sys_message
set error_message = 'The exit arc must be reversed. Arc = %arc_id%'
where id = 2038;

update sys_message
set error_message = 'Reduced geometry is not a Linestring, (arc_id,geom type)= %arc_id%, %geom_type%'
where id = 2040;

update sys_message
set error_message = 'Query text = %query_text%'
where id = 2078;

update sys_message
set error_message = 'The x value is too large. The total length of the line is %line_length%'
where id = 2080;

update sys_message
set error_message = 'The extension does not exists. Extension = %extension%'
where id = 2082;

update sys_message
set error_message = 'The module does not exists. Module = %module%'
where id = 2084;

update sys_message
set error_message = 'There are [units] values nulls or not defined on price_value_unit table  = %units%'
where id = 2088;

update sys_message
set error_message = 'There is at least one node attached to the deleted feature. (num. node,feature_id)= %num_node%, %feature_id%'
where id = 2108;

update sys_message
set error_message = 'The selected arc has state=0 (num. node,feature_id)= %element_id%'
where id = 3002;

update sys_message
set error_message = 'The minimum arc length of this exportation is: %min_arc_length%'
where id = 3010;

update sys_message
set error_message = 'The position value is bigger than the full length of the arc. %arc_id%'
where id = 3012;

update sys_message
set error_message = 'The position id is not node_1 or node_2 of selected arc. %arc_id%'
where id = 3014;

update sys_message
set error_message = 'The inserted value is not present in a catalog. %catalog%'
where id = 3022;

update sys_message
set error_message = 'Can''t modify typevalue: %typevalue%'
where id = 3028;

update sys_message
set error_message = 'Can''t delete typevalue: %typevalue%'
where id = 3030;

update sys_message
set error_message = 'Can''t apply the foreign key %typevalue_name%'
where id = 3032;

update sys_message
set error_message = 'Selected state type doesn''t correspond with state %state_id%'
where id = 3036;

update sys_message
set error_message = 'Inserted value has unaccepted characters: %characters%'
where id = 3038;

update sys_message
set error_message = 'Selected node type doesn''t divide arc. Node type: %node_type%'
where id = 3046;

update sys_message
set error_message = 'Connect2network tool is not enabled for connec''s with state=2. Connec_id: %connec_id%'
where id = 3052;

update sys_message
set error_message = 'Connect2network tool is not enabled for gullies with state=2. Gully_id: %gully_id%'
where id = 3054;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id: %arc_id%'
where id = 3056;

update sys_message
set error_message = 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id: %connec_id%'
where id = 3058;

update sys_message
set error_message = 'It is impossible to validate the node without assigning value of nodecat_id. Node_id: %node_id%'
where id = 3060;

update sys_message
set error_message = 'Selected gratecat_id has NULL width or length. Gratecat_id: %gratecat_id%'
where id = 3062;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id: %connec_id%'
where id = 3076;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id: %gully_id%'
where id = 3078;

update sys_message
set error_message = 'It is not possible to relate connect with state=1 over network feature with state=2, connect: %connec_id%'
where id = 3080;

update sys_message
set error_message = 'Feature is out of any presszone, feature_id: %feature_id%'
where id = 3108;

update sys_message
set error_message = '%id% does not exists, impossible to delete it'
where id = 3116;

update sys_message
set error_message = 'Node is connected to arc which is involved in psector %psector_list%'
where id = 3140;

update sys_message
set error_message = 'Node is involved in psector %psector_list%'
where id = 3142;

update sys_message
set error_message = 'Exploitation of the feature is different than the one of the related arc. Arc_id: %arc_id%'
where id = 3144;

update sys_message
set error_message = 'Backup name already exists %backup_name%'
where id = 3148;

update sys_message
set error_message = 'Backup has no data related to table %table_name%'
where id = 3150;

update sys_message
set error_message = 'Null values on geom1 or geom2 fields on element catalog %elementcat_id%'
where id = 3152;

update sys_message
set error_message = 'Input parameter has null value %table_name%'
where id = 3156;

update sys_message
set error_message = 'This feature with state = 2 is only attached to one psector %psector_id%'
where id = 3160;

update sys_message
set error_message = 'Id value for this catalog already exists %value%'
where id = 3166;

update sys_message
set error_message = 'You are trying to modify some network element with related connects (connec / gully) on psector not selected. %debugmsg%'
where id = 3180;

update sys_message
set error_message = 'It is not allowed to downgrade (state=0) on psector tables for planned features (state=2). Planned features only must have state=1 on psector. %psector_id%'
where id = 3182;

update sys_message
set error_message = 'It is not possible to downgrade connec because has operative hydrometer associated %feature_id%'
where id = 3194;

update sys_message
set error_message = 'Shortcut key is already defined for another feature %shortcut%'
where id = 3196;

update sys_message
set error_message = 'It''s not possible to break planned arcs by using operative nodes %arc_id%'
where id = 3202;

update sys_message
set error_message = 'Inserted feature_id does not exist on node/connec table %feature_id%'
where id = 3230;

update sys_message
set error_message = 'It''s not possible to connect to this arc because it exceed the maximum diameter configured: %diameter%'
where id = 3232;

update sys_message
set error_message = 'It''s not possible to upsert the arc because node_1 and node_2 belong to different mapzones. %zone%'
where id = 3236;

update sys_message
set error_message = 'It''s not possible to configure this node as mapzone header, because it''s not an operative nor planified node %zone%'
where id = 3242;

update sys_message
set error_message = 'It''s not possible to use selected arcs. They are not connected to node parent %nodeparent%'
where id = 3244;

update sys_message
set error_message = 'No arc exists with a smaller diameter than the maximum configuered on edit_link_check_arcdnom: %edit_link_check_arcdnom%'
where id = 3260;

update sys_message
set error_message = 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname: %parentname%'
where id = 3264;

update sys_message
set error_message = left(error_message, length(error_message)-1)
where error_message ilike '%.';


INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_results', 'SELECT dscenario_id as id, name, descript, dscenario_type, parent_id, expl_id, active::TEXT, log FROM v_edit_cat_dscenario WHERE dscenario_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_toggle_active",
      "widgetfunction": {
        "functionName": "toggle_active",
        "params": {}
      },
      "color": "default",
      "text": "Toggle active",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_create_crm",
      "widgetfunction": {
        "functionName": "create_crm",
        "params": {}
      },
      "color": "success",
      "text": "Create from CRM",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_create_mincut",
      "widgetfunction": {
        "functionName": "create_mincut",
        "params": {}
      },
      "color": "success",
      "text": "Create from Mincut",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pump_1', 'lyt_pump_1', 'lytPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_virtualvalve_1', 'lyt_virtualvalve_1', 'lytVirtualValve1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_additional_1', 'lyt_additional_1', 'lytAdditional1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_junction_1', 'lyt_junction_1', 'lytJunction1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connec_1', 'lyt_connec_1', 'lytConnec1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_inlet_1', 'lyt_inlet_1', 'lytInlet1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_demand_1', 'lyt_demand_1', 'lytDemand1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pipe_1', 'lyt_pipe_1', 'lytPipe1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_virtualpump_1', 'lyt_virtualpump_1', 'lytVirtualPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_shortpipe_1', 'lyt_shortpipe_1', 'lytShortPipe1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_valve_1', 'lyt_valve_1', 'lytValve1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_tank_1', 'lyt_tank_1', 'lytTank1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_reservoir_1', 'lyt_reservoir_1', 'lytReservoir1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_virtualvalve', 'tab_virtualvalve', 'tabVirtualValve', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pump', 'tab_pump', 'tabPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_additional', 'tab_additional', 'tabAdditional', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_junction', 'tab_junction', 'tabJunction', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_connec', 'tab_connec', 'tabConnec', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_inlet', 'tab_inlet', 'tabInlet', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_demand', 'tab_demand', 'tabDemand', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pipe', 'tab_pipe', 'tabPipe', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_virtualpump', 'tab_virtualpump', 'tabVirtualPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_shortpipe', 'tab_shortpipe', 'tabShortPipe', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_valve', 'tab_valve', 'tabValve', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_tank', 'tab_tank', 'tabTank', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_reservoir', 'tab_reservoir', 'tabReservoir', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pump', 'Pump', 'Pump', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_virtualvalve', 'Virtualvalve', 'Virtualvalve', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_additional', 'Additional', 'Additional', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_junction', 'Junction', 'Junction', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_connec', 'Connec', 'Connec', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_inlet', 'Inlet', 'Inlet', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_demand', 'Demand', 'Demand', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pipe', 'Pipe', 'Pipe', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_virtualpump', 'Virtualpump', 'Virtualpump', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_shortpipe', 'Shortpipe', 'Shortpipe', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_valve', 'Valve', 'Valve', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_tank', 'Tank', 'Tank', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_reservoir', 'Reservoir', 'Reservoir', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_rules', 'Rules', 'Rules', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pump', '{"layouts":["lyt_pump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_virtualvalve', '{"layouts":["lyt_virtualvalve_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_additional', '{"layouts":["lyt_additional_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_junction', '{"layouts":["lyt_junction_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_connec', '{"layouts":["lyt_connec_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_inlet', '{"layouts":["lyt_inlet_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_demand', '{"layouts":["lyt_demand_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pipe', '{"layouts":["lyt_pipe_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_virtualpump', '{"layouts":["lyt_virtualpump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_shortpipe', '{"layouts":["lyt_shortpipe_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_valve', '{"layouts":["lyt_valve_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_tank', '{"layouts":["lyt_tank_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_reservoir', '{"layouts":["lyt_reservoir_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_controls', '{"layouts":["lyt_controls"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_rules', '{"layouts":["lyt_rules"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'tab_main', 'lyt_dscenario_1', 1, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_virtualvalve",
    "tab_pump",
    "tab_additional",
    "tab_controls",
    "tab_rules",
    "tab_junction",
    "tab_connec",
    "tab_inlet",
    "tab_demand",
    "tab_pipe",
    "tab_virtualpump",
    "tab_shortpipe",
    "tab_valve",
    "tab_tank",
    "tab_reservoir"
  ]
}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_demand', 'tbl_demand', 'lyt_demand_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_demand', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pipe', 'tbl_pipe', 'lyt_pipe_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pipe', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_virtualpump', 'tbl_virtualpump', 'lyt_virtualpump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_virtualpump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_shortpipe', 'tbl_shortpipe', 'lyt_shortpipe_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_shortpipe', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_valve', 'tbl_valve', 'lyt_valve_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_valve', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_tank', 'tbl_tank', 'lyt_tank_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_tank', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_reservoir', 'tbl_reservoir', 'lyt_reservoir_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_reservoir', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_virtualvalve', 'tbl_virtualvalve', 'lyt_virtualvalve_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_virtualvalve', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pump', 'tbl_pump', 'lyt_pump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_additional', 'tbl_additional', 'lyt_additional_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_additional', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_controls', 'tbl_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_controls', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_rules', 'tbl_rules', 'lyt_rules_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_rules', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_junction', 'tbl_junction', 'lyt_junction_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_junction', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_connec', 'tbl_connec', 'lyt_connec_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_connec', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_inlet', 'tbl_inlet', 'lyt_inlet_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_inlet', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pipe', 'SELECT dscenario_id AS id, arc_id, minorloss, status, roughness, dint, bulk_coeff, wall_coeff FROM inp_dscenario_pipe where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_additional', 'SELECT id, node_id, order_id, power, curve_id, speed, pattern_id, status, energy_price, energy_pattern_id, effic_curve_id FROM inp_dscenario_pump_additional where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_rules', 'SELECT id, sector_id, "text", active::text FROM inp_dscenario_rules where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_virtualpump', 'SELECT dscenario_id AS id, arc_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id, pump_type FROM inp_dscenario_virtualpump where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_inlet', 'SELECT dscenario_id AS id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, head, pattern_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id, demand, demand_pattern_id, emitter_coeff FROM inp_dscenario_inlet where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_shortpipe', 'SELECT dscenario_id AS id, node_id, minorloss, status, bulk_coeff, wall_coeff FROM inp_dscenario_shortpipe where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_reservoir', 'SELECT dscenario_id AS id, node_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_reservoir where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_virtualvalve', 'SELECT dscenario_id AS id, arc_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status FROM inp_dscenario_virtualvalve where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_controls', 'SELECT id, sector_id, "text", active::text FROM inp_dscenario_controls where id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_junction', 'SELECT dscenario_id AS id, node_id, demand, pattern_id, peak_factor,emitter_coeff,init_quality,source_type,source_quality,source_pattern_id FROM inp_dscenario_junction where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_valve', 'SELECT dscenario_id AS id, node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM inp_dscenario_valve where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_demand', 'SELECT dscenario_id AS id, feature_id, feature_type,demand,pattern_id,demand_type,"source" FROM inp_dscenario_demand where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "feature_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "feature_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_tank', 'SELECT dscenario_id AS id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_tank  where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pump', 'SELECT dscenario_id AS id, node_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id FROM inp_dscenario_pump where dscenario_id is not null', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_connec', 'SELECT dscenario_id AS id, connec_id, demand, pattern_id, peak_factor, status, minorloss, custom_roughness, custom_length, custom_dint, emitter_coeff, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_connec where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "connec_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "connec_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_junction', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_connec', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_additional', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_controls', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_inlet', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_rules', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_demand', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pipe', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_virtualpump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_shortpipe', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_valve', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_tank', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_reservoir', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_virtualvalve', 'id', NULL, false, NULL, NULL, NULL, NULL);

UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "name",
    "label": "Scenario name:",
    "widgettype": "text",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "value": ""
  },
  {
    "widgetname": "descript",
    "label": "Scenario descript:",
    "widgettype": "text",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "value": ""
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4,
    "dvQueryText": "SELECT expl_id as id, name as idval FROM v_edit_exploitation",
    "selectedId": "",
    "comboIds": [],
    "comboNames": []
  },
  {
    "widgetname": "period",
    "label": "Source CRM period:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "dvQueryText": "SELECT id, code as idval FROM ext_cat_period",
    "selectedId": "",
    "comboIds": [],
    "comboNames": []
  },
  {
    "widgetname": "onlyIsWaterBal",
    "label": "Only hydrometers with waterbal true:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "pattern",
    "label": "Feature pattern:",
    "widgettype": "combo",
    "tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "comboIds": [
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ],
    "comboNames": [
      "NONE",
      "SECTOR-DEFAULT",
      "DMA-DEFAULT",
      "DMA-PERIOD",
      "HYDROMETER-PERIOD",
      "HYDROMETER-CATEGORY",
      "FEATURE-PATTERN"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "demandUnits",
    "label": "Demand units:",
    "tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "comboIds": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "comboNames": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "selectedId": ""
  }
]'::json WHERE id=3110;


DROP FUNCTION IF EXISTS gw_fct_import_epanet_inp(p_data json);

DELETE FROM config_function
	WHERE id=2522; --gw_fct_import_epanet_inp

DELETE FROM config_toolbox
	WHERE id=2522; --gw_fct_import_epanet_inp

DELETE FROM sys_function
	WHERE id=2522; --gw_fct_import_epanet_inp

UPDATE config_form_fields SET formname = 'v_rpt_node_stats' WHERE formname = 'v_rpt_node';
UPDATE config_form_fields SET formname = 'v_rpt_node' WHERE formname = 'v_rpt_node_all';
UPDATE config_form_fields SET formname = 'v_rpt_arc_stats' WHERE formname = 'v_rpt_arc';
UPDATE config_form_fields SET formname = 'v_rpt_arc' WHERE formname = 'v_rpt_arc_all';

-- recover data from old tables
INSERT INTO rpt_arc_stats
SELECT arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, NULL,
NULL, NULL, the_geom
FROM _rpt_arc_stats;

INSERT INTO archived_rpt_arc_stats
SELECT arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, NULL,
NULL, NULL, the_geom
FROM _archived_rpt_arc_stats;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'tot_headloss_max', 'lyt_epa_data_2', 21, 'string', 'text', 'Max Tot Headloss:', 'Max Tot Headloss', NULL,
false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'tot_headloss_min', 'lyt_epa_data_2', 22, 'string', 'text', 'Min Tot Headloss:', 'Min Tot Headloss', NULL,
false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc', 'form_feature', 'tab_none', 'length', NULL, NULL, 'double', 'text', 'length', 'length', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc', 'form_feature', 'tab_none', 'tot_headloss', NULL, NULL, 'double', 'text', 'tot_headloss', 'tot_headloss', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'length', NULL, NULL, 'double', 'text', 'length', 'length', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'tot_headloss_max', NULL, NULL, 'double', 'text', 'tot_headloss_max', 'tot_headloss_max', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'tot_headloss_min', NULL, NULL, 'double', 'text', 'tot_headloss_min', 'tot_headloss_min', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


INSERT INTO arc_add (arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, tot_headloss_max, tot_headloss_min, result_id)
SELECT arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, NULL, NULL, result_id
FROM _arc_add_;



UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false,"text":"Cancel mincut", "onContextMenu":"Cancel mincut"}'::json
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='cancel_mincut';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false,"text":"Delete mincut", "onContextMenu":"Delete mincut"}'::json
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='delete';

UPDATE config_function SET "style"='{
  "style": {
    "point": {
      "style": "unique",
      "values": {
        "width": 3.5,
        "color": [
          255,
          165,
          1
        ],
        "transparency": 1
      }
    },
    "line": {
      "style": "categorized",
      "field": "hydrant_id",
      "width": 2,
      "transparency": 0.5
    },
    "polygon": {
      "style": "unique",
      "values": {
        "width": 3,
        "color": [
          255,
          1,
          1
        ],
        "transparency": 0.5
      }
    }
  }
}'::json WHERE id=3160;




-- update
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7, "datatype"='integer', widgettype='combo', "label"='lock_level', tooltip='lock_level', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7, "datatype"='integer', widgettype='combo', "label"='lock_level', tooltip='lock_level', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7, "datatype"='integer', widgettype='combo', "label"='lock_level', tooltip='lock_level', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';

-- Insert missing mapzone sector widgets
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','expl_id','lyt_data_1',5,'text','text','expl_id','expl_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','avg_press','lyt_data_1',14,'numeric','text','average pressure','avg_press', NULL,false,false,true,false,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','link','lyt_data_1',15,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone sector widgets
UPDATE config_form_fields SET label='macrosector', tooltip='macrosector' WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='macrosector' AND tabname='tab_none';

-- Insert missing mapzone dma widgets
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','minc','lyt_data_1',11,'double','text','minc','minc', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','maxc','lyt_data_1',12,'double','text','maxc','maxc', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone dma widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = '1,2' WHERE formname = 'v_ui_dma' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';
UPDATE config_form_fields SET columnname='macrodma', datatype='string', label='macrodma', tooltip='macrodma', dv_querytext='SELECT name as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', hidden=false WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_none';

-- Insert missing mapzone presszone widgets
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','lock_level','lyt_data_1',6,'integer','combo','lock_level','lock_level',NULL,false,false,true,false, NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL',true,false, NULL, NULL,NULL,NULL, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','link','lyt_data_1',9,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','avg_press','lyt_data_1',13,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone presszone widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = 'Ex: 1,2' WHERE formname = 'v_ui_presszone' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';

-- Insert missing mapzone dqa widgets
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','1,2',false,false,true,false, NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','avg_press','lyt_data_1',15,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone dqa widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = 'Ex: 1,2' WHERE formname = 'v_ui_dqa' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';
UPDATE config_form_fields SET "datatype"='string', "label"='macrodqa', tooltip='macrodqa', columnname='macrodqa', dv_querytext='SELECT name as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL' WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_none';

-- Insert supplyzone types
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'DISTRIBUTION', 'DISTRIBUTION', NULL, NULL);
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'SOURCE', 'SOURCE', NULL, NULL);
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'UNDEFINED', 'UNDEFINED', NULL, NULL);



-- Insert new error messages
INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3276, 'Some exploitation ids don''t exist', 'Insert exploitation ids that exist', 1, true, 'utils', 'core');

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3278,'Some municipality ids don''t exist','Insert municipality ids that exist',1,true,'utils','core');

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3280,'Some sector ids don''t exist','Insert sector ids that exist',1,true,'utils','core');

-- Insert new supplyzone trigger to sys_function
INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3378, 'gw_trg_edit_supplyzone', 'ws', 'trigger', NULL, NULL, 'Trigger to insert, update or delete elements in supplyzone from v_ui_supplyzone or v_edit_supplyzone', 'role_edit', NULL, 'core');


UPDATE config_param_system SET value='{"sys_display_name":"concat(connec_id, '' : '', conneccat_id)","sys_tablename":"v_edit_connec","sys_pk":"connec_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}' WHERE "parameter"='basic_search_v2_tab_network_connec';

UPDATE config_form_fields SET datatype = 'integer', widgettype = 'combo', label = 'Verified', tooltip = 'verified', iseditable = true,
dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',
dv_orderby_id = true, dv_isnullvalue = true, widgetcontrols = '{"setMultiline": false, "labelPosition": "top"}'::json WHERE columnname = 'verified';



UPDATE config_csv SET descript='The csv file must have the following fields:
dscenario_name, feature_id, feature_type, value, demand_type, pattern_id, source' WHERE fid=501;



UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';

-- sys_foreignkey
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'node', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'arc', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'connec', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'element', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden,web_layoutorder) VALUES ('ve_node','form_feature','tab_data','custom_top_elev','lyt_data_1',3,'double','text','custom_top_elev','custom_top_elev',false,false,true,false,'{"setMultiline":false}',false,10) ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden,web_layoutorder) VALUES ('ve_node','form_feature','tab_data','datasource','lyt_data_1',4,'integer','combo','datasource','datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''',true,true,'{"setMultiline":false}',false,10) ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden,web_layoutorder) VALUES ('ve_arc','form_feature','tab_data','datasource','lyt_data_1',4,'integer','combo','datasource','datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''',true,true,'{"setMultiline":false}',false,10) ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden,web_layoutorder) VALUES ('ve_connec','form_feature','tab_data','datasource','lyt_data_1',4,'integer','combo','datasource','datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''',true,true,'{"setMultiline":false}',false,10) ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;;

UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_inlet' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_junction' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_pump' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_reservoir' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_shortpipe' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_tank' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_valve' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_element' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_review_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_rpt_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_rpt_node_stats' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';

UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname ILIKE 've_connec_%*' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';


INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'node', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'arc', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'connec', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'element', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL
WHERE (formname='v_edit_arc' OR formname ILIKE 've_arc_%' OR formname='v_edit_connec' OR formname ILIKE 've_connec_%' OR formname='v_edit_node' OR formname ILIKE 've_node_%' OR formname='v_edit_element' OR formname ILIKE 've_element_%' )
AND formtype='form_feature' AND columnname='lock_level' AND tabname='tab_data';


UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=1 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=2 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=3 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=4 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=5 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=6 WHERE (formname = 've_node' OR formname = 've_arc' OR formname = 've_connec') AND formtype='form_feature' AND columnname='state_type' AND tabname='tab_data';


UPDATE config_form_fields SET layoutorder=1 WHERE (formname ILIKE '%_node_%' OR formname ILIKE '%_arc_%' OR formname ILIKE '%_connec_%') AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=3 WHERE (formname ILIKE '%_node_%' OR formname ILIKE '%_arc_%' OR formname ILIKE '%_connec_%') AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=5 WHERE (formname ILIKE '%_node_%' OR formname ILIKE '%_arc_%' OR formname ILIKE '%_connec_%') AND formtype='form_feature' AND columnname='state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=6 WHERE (formname ILIKE '%_node_%' OR formname ILIKE '%_arc_%' OR formname ILIKE '%_connec_%') AND formtype='form_feature' AND columnname='state_type' AND tabname='tab_data';

UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=1 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=2 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=3 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=4 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=5 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_bot_1', layoutorder=6 WHERE (formname = 'v_edit_node' OR formname = 'v_edit_arc' OR formname = 'v_edit_connec') AND formtype='form_feature' AND columnname='state_type' AND tabname='tab_data';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations', 'tab_relations_arc', 'lyt_relations_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_relations_arc",
    "tab_relations_node",
    "tab_relations_connec"
  ]
}'::json, NULL, NULL, false, 0);


-- man_valve
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_valve_connectiontype', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_valve_connectiontype', '1', 'FLANGE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_valve_connectiontype', '2', 'THREADED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_valve_connectiontype', '3', 'OTHER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_valve_connectiontype', 'man_valve', 'connection_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_valve_connectiontype''', dv_isnullvalue=False
WHERE formname ILIKE 've_node%_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';

-- man_tank
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_tank_shape', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_tank_shape', '1', 'CIRCULAR', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_tank_shape', '2', 'RECTANGULAR', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_tank_shape', '3', 'OTHER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_tank_shape', 'man_tank', 'shape', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_tank_shape''', dv_isnullvalue=false
WHERE formname ILIKE 've_node%_tank' AND formtype='form_feature' AND columnname='shape' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_fencetype', '1', 'MESH', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_fencetype', '2', 'BRICK', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_fencetype', '3', 'OTHER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_fencetype', 'man_tank', 'fence_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_fencetype''', dv_isnullvalue=true
WHERE formname ILIKE 've_node%_tank' AND formtype='form_feature' AND columnname='fence_type' AND tabname='tab_data';

-- man_netelement
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_fencetype', 'man_netelement', 'fence_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_fencetype''', dv_isnullvalue=true
WHERE formname ILIKE 've_node%_netelement' AND formtype='form_feature' AND columnname='fence_type' AND tabname='tab_data';

-- man_hydrant
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_hydrant_hydranttype', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_hydrant_hydranttype', '1', 'SUCTION', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_hydrant_hydranttype', '2', 'HEAD', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_hydrant_hydranttype', '3', 'OTHER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_hydrant_hydranttype', 'man_hydrant', 'hydrant_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_hydrant_hydranttype''', dv_isnullvalue=true
WHERE formname ILIKE 've_node%_hydrant' AND formtype='form_feature' AND columnname='hydrant_type' AND tabname='tab_data';

-- man_source
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_sourcetype', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_sourcetype', '1', 'SPRING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_sourcetype', '2', 'GROUNDWATER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_sourcetype', '3', 'SURFACE WATER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_source_sourcetype', 'man_source', 'source_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_source_sourcetype''', dv_isnullvalue=false
WHERE formname ILIKE 've_node%_source' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_aquifertype', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_aquifertype', '1', 'CONFINED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_aquifertype', '2', 'FREE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_aquifertype', '3', 'OTHER', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_source_aquifertype', 'man_source', 'aquifer_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_source_aquifertype''', dv_isnullvalue=false
WHERE formname ILIKE 've_node%_source' AND formtype='form_feature' AND columnname='aquifer_type' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_basinid', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_source_basinid', 'man_source', 'basin_id', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_source_basinid''', dv_isnullvalue=false
WHERE formname ILIKE 've_node%_source' AND formtype='form_feature' AND columnname='basin_id' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_source_subbasinid', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_source_subbasinid', 'man_source', 'subbasin_id', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_source_subbasinid''', dv_isnullvalue=false
WHERE formname ILIKE 've_node%_source' AND formtype='form_feature' AND columnname='subbasin_id' AND tabname='tab_data';

UPDATE config_form_fields
SET dv_querytext='SELECT node_id as id, node_type as idval FROM man_wtp WHERE id IS NOT NULL'
WHERE formname ILIKE 've_node%_source' AND formtype='form_feature' AND columnname='wtp_id' AND tabname='tab_data';


INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)	VALUES ('v_edit_link','form_feature','tab_none','n_hydrometer','lyt_data_1',35,'integer','text','N_hydrometer','N_hydrometer',false,false,true,false,'{"setMultiline":false}'::json,false);

-- node
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname ILIKE 've_node_%' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_arc', 'form_feature', 'tab_data', 'cat_dr', 'lyt_data_1', 55, 'integer', 'text', 'cat_dr', 'cat_dr', NULL, false, NULL, false, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


UPDATE config_form_fields SET formname='generic' WHERE formname='visit_manager' AND formtype='form_visit' AND columnname='tbl_visit_edit' AND tabname='tab_none';

INSERT INTO inp_pattern (pattern_id, observ, tscode, tsparameters, expl_id, log, active)
SELECT pattern_id, observ, tscode, tsparameters, expl_id, log, true
FROM _inp_pattern;


DELETE FROM config_form_fields WHERE columnname='buildercat_id';

-- move data from old tables to new tables
INSERT INTO macroexploitation (macroexpl_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macroexpl_id, macroexpl_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macroexploitation;

INSERT INTO exploitation (expl_id, code, "name", descript, macroexpl_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT expl_id, expl_id::text, "name", descript, macroexpl_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _exploitation;

INSERT INTO macrosector (macrosector_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macrosector_id, macrosector_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macrosector;

INSERT INTO macrodma (macrodma_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodma_id, macrodma_id::text, "name", descript, ARRAY[expl_id], NULL, active, the_geom, now()
FROM _macrodma;

INSERT INTO macrodqa (macrodqa_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodqa_id, macrodqa_id::text, "name", descript, ARRAY[expl_id], NULL, active, the_geom, now()
FROM _macrodqa;

INSERT INTO dma (dma_id, code, "name", descript, dma_type, muni_id, expl_id, sector_id, macrodma_id, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dma_id, dma_id::text, "name", descript, dma_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodma_id, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO presszone (presszone_id, code, "name", descript, presszone_type, muni_id, expl_id, sector_id, link, graphconfig, stylesheet, head, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT presszone_id, presszone_id::text, "name", descript, presszone_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], link, graphconfig, stylesheet, head, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _presszone;

INSERT INTO dqa (dqa_id, code, "name", descript, dqa_type, muni_id, expl_id, sector_id, macrodqa_id, pattern_id, link, graphconfig, stylesheet, avg_press, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dqa_id, dqa_id::text, "name", descript, dqa_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodqa_id, pattern_id, link, graphconfig, stylesheet, avg_press, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dqa;

INSERT INTO sector (sector_id, code, descript, "name", sector_type, muni_id, expl_id, macrosector_id, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT sector_id, sector_id::text, descript, "name", sector_type, NULL::int4[], NULL::int4[], NULL, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _sector;


INSERT INTO supplyzone VALUES (0, 'Undefined', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL) ON CONFLICT DO NOTHING;

INSERT INTO macroomzone (macroomzone_id, code, "name", expl_id, descript, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by) VALUES(0, '0', 'Undefined', '{0}', NULL, NULL, true, NULL, '2025-04-14 12:57:25.809', current_user, NULL, NULL) ON CONFLICT DO NOTHING;

INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by) VALUES(0, '0', 'Undefined', NULL, NULL, NULL, 0, NULL, true, NULL, '2025-04-14 12:57:25.809', current_user, NULL, NULL) ON CONFLICT DO NOTHING;

INSERT INTO crmzone VALUES (0, 'Undefined', NULL, NULL, true) ON CONFLICT DO NOTHING;

INSERT INTO macrocrmzone (macrocrmzone_id, name, active) VALUES(0, 'Undefined', true) ON CONFLICT DO NOTHING;


-- supplyzone is new
-- omzone is new


-- todo: disable triggers


INSERT INTO arc (arc_id, code, sys_code, node_1, node_2, arccat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", custom_length, dma_id, presszone_id,
soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id,
postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish,
inventory, expl_id, num_value, feature_type, created_at, created_by, updated_at, updated_by, minsector_id, dqa_id, district_id, adate, adescript, workcat_id_plan,
asset_id, pavcat_id, nodetype_1, elevation1, depth1, staticpress1, nodetype_2, elevation2, depth2, staticpress2, om_state, conserv_state, parent_id, expl_visibility, brand_id,
model_id, serial_number, label_quadrant, supplyzone_id, lock_level, is_scadamap)
SELECT arc_id::int4, code, code, node_1::int4, node_2::int4, arccat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", custom_length, dma_id, presszone_id,
soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id,
postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish,
inventory, expl_id, num_value, feature_type, tstamp, insert_user, lastupdate, lastupdate_user, minsector_id, dqa_id, district_id, adate, adescript, workcat_id_plan,
asset_id, pavcat_id, nodetype_1, elevation1, depth1, staticpress1, nodetype_2, elevation2, depth2, staticpress2, om_state, conserv_state, parent_id::int4, ARRAY[expl_id2], brand_id,
model_id, serial_number, label_quadrant, supplyzone_id, lock_level, is_scadamap
FROM _arc;


INSERT INTO connec (connec_id, code, top_elev, "depth", conneccat_id, sector_id, customer_code, state, state_type, arc_id, connec_length, annotation, observ, "comment",
dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id,
postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x,
label_y, label_rotation, publish, inventory, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at, updated_by, created_by, minsector_id,
dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, epa_type, om_state, conserv_state, priority,
_valve_type, _shutoff_valve, access_type, placement_type, crmzone_id, expl_visibility, plot_code, brand_id, model_id, serial_number, label_quadrant,
n_hydrometer, n_inhabitants, supplyzone_id, lock_level, block_code)
SELECT connec_id::int4, code, top_elev, "depth", conneccat_id, sector_id, customer_code, state, state_type, arc_id::int4, connec_length, annotation, observ, "comment",
dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id,
postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x,
label_y, label_rotation, publish, inventory, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id::int4, lastupdate, lastupdate_user, insert_user, minsector_id,
dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, epa_type, om_state, conserv_state, priority,
valve_type, shutoff_valve, access_type, placement_type, crmzone_id, ARRAY[expl_id2], plot_code, brand_id, model_id, serial_number, label_quadrant,
n_hydrometer, n_inhabitants, supplyzone_id, lock_level, block_zone
FROM _connec;


INSERT INTO element (element_id, code, sys_code, elementcat_id, serial_number, num_elements, state, state_type, observ, "comment", function_type, category_type,
location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish,
inventory, expl_id, feature_type, created_at, updated_at, created_by, updated_by, top_elev, expl_visibility, trace_featuregeom, muni_id, sector_id, brand_id,
model_id, asset_id, lock_level)
SELECT element_id::int4, code, code, elementcat_id, serial_number, num_elements, state, state_type, observ, "comment", function_type, category_type,
location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish,
inventory, expl_id, feature_type, tstamp, lastupdate, lastupdate_user, insert_user, top_elev, ARRAY[expl_id2], trace_featuregeom, muni_id, sector_id, brand_id,
model_id, asset_id, lock_level
FROM _element;


INSERT INTO node (node_id, code, top_elev, custom_top_elev, "depth", nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation,
observ, "comment", dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation,
the_geom, label_x, label_y, label_rotation, publish, inventory, hemisphere, expl_id, num_value, feature_type, created_at, updated_at, updated_by,
created_by, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, om_state, conserv_state, access_type,
placement_type, expl_visibility, brand_id, model_id, serial_number, label_quadrant, supplyzone_id, lock_level, is_scadamap,
pavcat_id)
SELECT node_id::int4, code, top_elev, custom_top_elev, "depth", nodecat_id, epa_type, sector_id, arc_id::int4, parent_id::int4, state, state_type, annotation,
observ, "comment", dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation,
the_geom, label_x, label_y, label_rotation, publish, inventory, hemisphere, expl_id, num_value, feature_type, tstamp, lastupdate, lastupdate_user,
insert_user, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, om_state, conserv_state, access_type,
placement_type, ARRAY[expl_id2], brand_id, model_id, serial_number, label_quadrant, supplyzone_id, lock_level, is_scadamap,
pavcat_id
FROM _node;



INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','datasource','lyt_data_1',36,'integer','combo','Datasource','Datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','custom_length','lyt_data_1',37,'double','text','Custom length','Custom length',false,false,true,false,'{"setMultiline":false}'::json,false);

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('cat_connec','form_feature','tab_none','estimated_depth','double','text','Estimated depth:','Estimated depth',false,false,true,false,'{"setMultiline":false}'::json,false);



UPDATE config_form_fields
	SET tooltip='chemcond',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='chemcond' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='chemtreatment',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='chemtreatment' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='coagulation',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='coagulation' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='desander',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='desander' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='disinfection',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='disinfection' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='filtration',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='filtration' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='floculation',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='floculation' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='oxidation',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='oxidation' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='presendiment',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='presendiment' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='screening',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='screening' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='sediment',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='sediment' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='sludgeman',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='sludgeman' AND tabname='tab_data';
UPDATE config_form_fields
	SET tooltip='storage',widgettype='combo',dv_isnullvalue=false,dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_boolean''',widgetcontrols='{"setMultiline":false}'::json
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='storage' AND tabname='tab_data';

INSERT INTO edit_typevalue VALUES('omzone_type', 'UNDEFINED', 'UNDEFINED', NULL, NULL);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

DROP TRIGGER gw_trg_typevalue_fk ON sys_table;
DELETE FROM sys_foreignkey WHERE typevalue_table = 'config_typevalue' AND typevalue_name = 'sys_table_context' AND target_table = 'sys_table' AND target_field = 'context';

UPDATE sys_table SET id = 'crmzone'	WHERE id = 'crm_zone';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'crm_zone', 'crmzone')
WHERE dv_querytext ILIKE '%crm_zone%';


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

    INSERT INTO utils.municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM utils.municipality;

  ELSE

    INSERT INTO ext_municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM _ext_municipality;

  END IF;
END; $$;

--sys_style qml file for v_rpt_comp_node and v_rpt_comp_node_hourly

UPDATE sys_style SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.11-Prizren" styleCategories="Symbology|Symbology3D|Labeling|Legend" labelsEnabled="1">
  <renderer-v2 enableorderby="0" graduatedMethod="GraduatedColor" referencescale="-1" type="graduatedSymbol" attr="press_compare" symbollevels="0" forceraster="0">
    <ranges>
      <range symbol="0" lower="-10000.000000000000000" render="true" label="Negative pressures" uuid="0" upper="0.000000000000000"/>
      <range symbol="1" lower="0.000000000000000" render="true" label="0-15 wcm" uuid="1" upper="15.000000000000000"/>
      <range symbol="2" lower="15.000000000000000" render="true" label="15-60 wcm" uuid="2" upper="60.000000000000000"/>
      <range symbol="3" lower="60.000000000000000" render="true" label="60-75 wcm" uuid="3" upper="75.000000000000000"/>
      <range symbol="4" lower="75.000000000000000" render="true" label="> 75 wcm" uuid="4" upper="10000.000000000000000"/>
    </ranges>
    <symbols>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="0" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{2061bf71-cf9e-4d4c-bc30-f3f06856250f}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="43,131,186,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="1" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{d0583368-a204-4639-87d6-66e8cdc7b485}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="171,221,164,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="2" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{f4456cd4-2d33-4ea6-91e6-f28da2e87914}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,255,191,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="3" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{50747584-6e96-43fd-aab3-05a2ff4af642}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="253,174,97,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="4" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{0e8b0c28-cb87-43ef-a412-a31cf2c72a6b}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="215,25,28,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="0" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{70ca6e89-f23a-458c-be20-a105215aa6b0}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="163,86,107,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp type="gradient" name="[source]">
      <Option type="Map">
        <Option type="QString" name="color1" value="215,25,28,255"/>
        <Option type="QString" name="color2" value="43,131,186,255"/>
        <Option type="QString" name="direction" value="ccw"/>
        <Option type="QString" name="discrete" value="0"/>
        <Option type="QString" name="rampType" value="gradient"/>
        <Option type="QString" name="spec" value="rgb"/>
        <Option type="QString" name="stops" value="0.25;253,174,97,255;rgb;ccw:0.5;255,255,191,255;rgb;ccw:0.75;171,221,164,255;rgb;ccw"/>
      </Option>
    </colorramp>
    <classificationMethod id="EqualInterval">
      <symmetricMode symmetrypoint="0" astride="0" enabled="0"/>
      <labelFormat trimtrailingzeroes="0" labelprecision="4" format="%1 - %2"/>
      <parameters>
        <Option/>
      </parameters>
      <extraInformation/>
    </classificationMethod>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{30b7806b-e5d6-4950-bc21-a006b4b2774c}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style multilineHeightUnit="Percentage" fontStrikeout="0" isExpression="1" forcedBold="0" previewBkgrdColor="255,255,255,255" blendMode="0" textOrientation="horizontal" textColor="55,55,55,255" fontItalic="0" fontSize="7" fontLetterSpacing="0" legendString="Aa" multilineHeight="1" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontFamily="Arial" capitalization="0" fontKerning="1" fontWordSpacing="0" textOpacity="1" namedStyle="Normal" allowHtml="0" fontSizeUnit="Point" useSubstitutions="0" fontUnderline="0" fontWeight="50" fieldName="&quot;press_compare&quot; || '' wcm'' " forcedItalic="0">
        <families/>
        <text-buffer bufferSize="0.5" bufferNoFill="0" bufferDraw="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferOpacity="1" bufferColor="255,255,255,255" bufferJoinStyle="64" bufferSizeUnits="MM"/>
        <text-mask maskOpacity="1" maskSize="1.5" maskType="0" maskEnabled="0" maskSizeUnits="MM" maskedSymbolLayers="" maskSize2="1.5" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskJoinStyle="128"/>
        <background shapeOffsetY="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeSizeX="0" shapeSizeY="0" shapeJoinStyle="64" shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeOffsetX="0" shapeRadiiX="0" shapeRotation="0" shapeType="0" shapeBlendMode="0" shapeBorderWidth="0" shapeOpacity="1" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeOffsetUnit="MM" shapeRotationType="0" shapeFillColor="255,255,255,255" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiY="0" shapeDraw="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0">
          <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="markerSymbol" clip_to_extent="1" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" pass="0" id="" enabled="1" class="SimpleMarker">
              <Option type="Map">
                <Option type="QString" name="angle" value="0"/>
                <Option type="QString" name="cap_style" value="square"/>
                <Option type="QString" name="color" value="229,182,54,255"/>
                <Option type="QString" name="horizontal_anchor_point" value="1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="name" value="circle"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="35,35,35,255"/>
                <Option type="QString" name="outline_style" value="solid"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="scale_method" value="diameter"/>
                <Option type="QString" name="size" value="2"/>
                <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="size_unit" value="MM"/>
                <Option type="QString" name="vertical_anchor_point" value="1"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol force_rhr="0" is_animated="0" type="fill" alpha="1" name="fillSymbol" clip_to_extent="1" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" pass="0" id="" enabled="1" class="SimpleFill">
              <Option type="Map">
                <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="color" value="255,255,255,255"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="128,128,128,255"/>
                <Option type="QString" name="outline_style" value="no"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="style" value="solid"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowColor="0,0,0,255" shadowRadiusAlphaOnly="0" shadowOffsetAngle="135" shadowUnder="0" shadowRadiusUnit="MM" shadowDraw="0" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowScale="100" shadowOffsetDist="1" shadowOffsetUnit="MM"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format multilineAlign="0" rightDirectionSymbol=">" autoWrapLength="0" wrapChar="_" useMaxLineLengthForAutoWrap="1" addDirectionSymbol="0" placeDirectionSymbol="0" decimals="3" formatNumbers="0" plussign="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0"/>
      <placement rotationUnit="AngleDegrees" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" placement="0" geometryGeneratorEnabled="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" repeatDistance="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" layerType="PointGeometry" dist="0.5" allowDegraded="0" lineAnchorType="0" lineAnchorClipping="0" centroidInside="0" centroidWhole="0" lineAnchorTextPoint="CenterOfText" geometryGenerator="" offsetType="0" placementFlags="0" maxCurvedCharAngleIn="20" repeatDistanceUnits="MM" preserveRotation="1" quadOffset="4" fitInPolygonOnly="0" distUnits="MM" xOffset="0" maxCurvedCharAngleOut="-20" overrunDistanceUnit="MM" offsetUnits="MapUnit" overrunDistance="0" priority="5" polygonPlacementFlags="2" overlapHandling="PreventOverlap" lineAnchorPercent="0.5" yOffset="0"/>
      <rendering fontMaxPixelSize="10000" labelPerPart="0" obstacleType="0" upsidedownLabels="0" obstacleFactor="1" obstacle="1" scaleVisibility="1" fontMinPixelSize="3" scaleMax="1000" minFeatureSize="0" unplacedVisibility="0" limitNumLabels="0" zIndex="0" scaleMin="1" mergeLines="0" drawLabels="1" fontLimitPixelSize="0" maxNumLabels="2000"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" name="name" value=""/>
          <Option name="properties"/>
          <Option type="QString" name="type" value="collection"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" name="anchorPoint" value="pole_of_inaccessibility"/>
          <Option type="int" name="blendMode" value="0"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
          <Option type="bool" name="drawToAllParts" value="false"/>
          <Option type="QString" name="enabled" value="0"/>
          <Option type="QString" name="labelAnchorPoint" value="point_on_exterior"/>
          <Option type="QString" name="lineSymbol" value="&lt;symbol force_rhr=&quot;0&quot; is_animated=&quot;0&quot; type=&quot;line&quot; alpha=&quot;1&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; frame_rate=&quot;10&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; pass=&quot;0&quot; id=&quot;{25f75b13-fc42-4245-81d9-c5e74ee614a8}&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;align_dash_pattern&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;capstyle&quot; value=&quot;square&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash&quot; value=&quot;5;2&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;draw_inside_polygon&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;joinstyle&quot; value=&quot;bevel&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_color&quot; value=&quot;60,60,60,255&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_style&quot; value=&quot;solid&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width&quot; value=&quot;0.3&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;ring_filter&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;tweak_dash_pattern_on_corners&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;use_custom_dash&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;width_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>"/>
          <Option type="double" name="minLength" value="0"/>
          <Option type="QString" name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="minLengthUnit" value="MM"/>
          <Option type="double" name="offsetFromAnchor" value="0"/>
          <Option type="QString" name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromAnchorUnit" value="MM"/>
          <Option type="double" name="offsetFromLabel" value="0"/>
          <Option type="QString" name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromLabelUnit" value="MM"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <legend type="default-vector" showLabelLegend="0"/>
  <layerGeometryType>0</layerGeometryType>
</qgis>
', active=true WHERE layername='v_rpt_comp_node_hourly' AND styleconfig_id=101;


UPDATE sys_style SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.11-Prizren" styleCategories="Symbology|Symbology3D|Labeling|Legend" labelsEnabled="1">
  <renderer-v2 enableorderby="0" graduatedMethod="GraduatedColor" referencescale="-1" type="graduatedSymbol" attr="press_max_compare" symbollevels="0" forceraster="0">
    <ranges>
      <range symbol="0" lower="-10000.000000000000000" render="true" label="Negative pressures" uuid="0" upper="0.000000000000000"/>
      <range symbol="1" lower="0.000000000000000" render="true" label="0-15 wcm" uuid="1" upper="15.000000000000000"/>
      <range symbol="2" lower="15.000000000000000" render="true" label="15-60 wcm" uuid="2" upper="60.000000000000000"/>
      <range symbol="3" lower="60.000000000000000" render="true" label="60-75 wcm" uuid="3" upper="75.000000000000000"/>
      <range symbol="4" lower="75.000000000000000" render="true" label="> 75 wcm" uuid="4" upper="10000.000000000000000"/>
    </ranges>
    <symbols>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="0" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{f6e16cff-8e1b-45d5-bdf3-212f3941e62c}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="43,131,186,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="1" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{d9bb1c09-4cfd-4552-a310-3cc9d64b833a}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="171,221,164,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="2" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{6ffc6b42-19cd-4ed0-b0fb-8e60719eac31}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,255,191,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="3" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{098867d2-014d-427e-a81d-98a924f81831}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="253,174,97,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="4" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{24cd238b-80b2-4cca-8563-7fc1417ced21}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="215,25,28,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="0" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{1151dcda-9a5f-47e9-9513-98c91f5af820}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="163,86,107,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,0,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="area"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp type="gradient" name="[source]">
      <Option type="Map">
        <Option type="QString" name="color1" value="215,25,28,255"/>
        <Option type="QString" name="color2" value="43,131,186,255"/>
        <Option type="QString" name="direction" value="ccw"/>
        <Option type="QString" name="discrete" value="0"/>
        <Option type="QString" name="rampType" value="gradient"/>
        <Option type="QString" name="spec" value="rgb"/>
        <Option type="QString" name="stops" value="0.25;253,174,97,255;rgb;ccw:0.5;255,255,191,255;rgb;ccw:0.75;171,221,164,255;rgb;ccw"/>
      </Option>
    </colorramp>
    <classificationMethod id="EqualInterval">
      <symmetricMode symmetrypoint="0" astride="0" enabled="0"/>
      <labelFormat trimtrailingzeroes="0" labelprecision="4" format="%1 - %2"/>
      <parameters>
        <Option/>
      </parameters>
      <extraInformation/>
    </classificationMethod>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="" clip_to_extent="1" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" pass="0" id="{b4b751b5-6b3d-44bd-926a-8cd4272bd853}" enabled="1" class="SimpleMarker">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style multilineHeightUnit="Percentage" fontStrikeout="0" isExpression="1" forcedBold="0" previewBkgrdColor="255,255,255,255" blendMode="0" textOrientation="horizontal" textColor="55,55,55,255" fontItalic="0" fontSize="7" fontLetterSpacing="0" legendString="Aa" multilineHeight="1" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontFamily="Arial" capitalization="0" fontKerning="1" fontWordSpacing="0" textOpacity="1" namedStyle="Normal" allowHtml="0" fontSizeUnit="Point" useSubstitutions="0" fontUnderline="0" fontWeight="50" fieldName="''min: '' || &quot;press_min_compare&quot; || '' wcm'' || ''_'' || ''max: '' || &quot;press_max_compare&quot; || '' wcm''" forcedItalic="0">
        <families/>
        <text-buffer bufferSize="0.5" bufferNoFill="0" bufferDraw="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferOpacity="1" bufferColor="255,255,255,255" bufferJoinStyle="64" bufferSizeUnits="MM"/>
        <text-mask maskOpacity="1" maskSize="1.5" maskType="0" maskEnabled="0" maskSizeUnits="MM" maskedSymbolLayers="" maskSize2="1.5" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskJoinStyle="128"/>
        <background shapeOffsetY="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeSizeX="0" shapeSizeY="0" shapeJoinStyle="64" shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeOffsetX="0" shapeRadiiX="0" shapeRotation="0" shapeType="0" shapeBlendMode="0" shapeBorderWidth="0" shapeOpacity="1" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeOffsetUnit="MM" shapeRotationType="0" shapeFillColor="255,255,255,255" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiY="0" shapeDraw="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0">
          <symbol force_rhr="0" is_animated="0" type="marker" alpha="1" name="markerSymbol" clip_to_extent="1" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" pass="0" id="" enabled="1" class="SimpleMarker">
              <Option type="Map">
                <Option type="QString" name="angle" value="0"/>
                <Option type="QString" name="cap_style" value="square"/>
                <Option type="QString" name="color" value="243,166,178,255"/>
                <Option type="QString" name="horizontal_anchor_point" value="1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="name" value="circle"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="35,35,35,255"/>
                <Option type="QString" name="outline_style" value="solid"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="scale_method" value="diameter"/>
                <Option type="QString" name="size" value="2"/>
                <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="size_unit" value="MM"/>
                <Option type="QString" name="vertical_anchor_point" value="1"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol force_rhr="0" is_animated="0" type="fill" alpha="1" name="fillSymbol" clip_to_extent="1" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" pass="0" id="" enabled="1" class="SimpleFill">
              <Option type="Map">
                <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="color" value="255,255,255,255"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="128,128,128,255"/>
                <Option type="QString" name="outline_style" value="no"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="style" value="solid"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowColor="0,0,0,255" shadowRadiusAlphaOnly="0" shadowOffsetAngle="135" shadowUnder="0" shadowRadiusUnit="MM" shadowDraw="0" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowScale="100" shadowOffsetDist="1" shadowOffsetUnit="MM"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format multilineAlign="0" rightDirectionSymbol=">" autoWrapLength="0" wrapChar="_" useMaxLineLengthForAutoWrap="1" addDirectionSymbol="0" placeDirectionSymbol="0" decimals="3" formatNumbers="0" plussign="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0"/>
      <placement rotationUnit="AngleDegrees" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" placement="0" geometryGeneratorEnabled="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" repeatDistance="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" layerType="PointGeometry" dist="0" allowDegraded="0" lineAnchorType="0" lineAnchorClipping="0" centroidInside="0" centroidWhole="0" lineAnchorTextPoint="CenterOfText" geometryGenerator="" offsetType="0" placementFlags="0" maxCurvedCharAngleIn="20" repeatDistanceUnits="MM" preserveRotation="1" quadOffset="4" fitInPolygonOnly="0" distUnits="MM" xOffset="0" maxCurvedCharAngleOut="-20" overrunDistanceUnit="MM" offsetUnits="MapUnit" overrunDistance="0" priority="5" polygonPlacementFlags="2" overlapHandling="PreventOverlap" lineAnchorPercent="0.5" yOffset="0"/>
      <rendering fontMaxPixelSize="10000" labelPerPart="0" obstacleType="0" upsidedownLabels="0" obstacleFactor="1" obstacle="1" scaleVisibility="1" fontMinPixelSize="3" scaleMax="1000" minFeatureSize="0" unplacedVisibility="0" limitNumLabels="0" zIndex="0" scaleMin="1" mergeLines="0" drawLabels="1" fontLimitPixelSize="0" maxNumLabels="2000"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" name="name" value=""/>
          <Option name="properties"/>
          <Option type="QString" name="type" value="collection"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" name="anchorPoint" value="pole_of_inaccessibility"/>
          <Option type="int" name="blendMode" value="0"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
          <Option type="bool" name="drawToAllParts" value="false"/>
          <Option type="QString" name="enabled" value="0"/>
          <Option type="QString" name="labelAnchorPoint" value="point_on_exterior"/>
          <Option type="QString" name="lineSymbol" value="&lt;symbol force_rhr=&quot;0&quot; is_animated=&quot;0&quot; type=&quot;line&quot; alpha=&quot;1&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; frame_rate=&quot;10&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; pass=&quot;0&quot; id=&quot;{6193a69d-69bf-4532-b655-b52ce87c567a}&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;align_dash_pattern&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;capstyle&quot; value=&quot;square&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash&quot; value=&quot;5;2&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;customdash_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;dash_pattern_offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;draw_inside_polygon&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;joinstyle&quot; value=&quot;bevel&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_color&quot; value=&quot;60,60,60,255&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_style&quot; value=&quot;solid&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width&quot; value=&quot;0.3&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;line_width_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;offset_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;ring_filter&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_end_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;trim_distance_start_unit&quot; value=&quot;MM&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;tweak_dash_pattern_on_corners&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;use_custom_dash&quot; value=&quot;0&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;width_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>"/>
          <Option type="double" name="minLength" value="0"/>
          <Option type="QString" name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="minLengthUnit" value="MM"/>
          <Option type="double" name="offsetFromAnchor" value="0"/>
          <Option type="QString" name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromAnchorUnit" value="MM"/>
          <Option type="double" name="offsetFromLabel" value="0"/>
          <Option type="QString" name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromLabelUnit" value="MM"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <legend type="default-vector" showLabelLegend="0"/>
  <layerGeometryType>0</layerGeometryType>
</qgis>
', active=true WHERE layername='v_rpt_comp_node' AND styleconfig_id=101;

-- add foreign key for presszone_id
ALTER TABLE arc ADD CONSTRAINT arc_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector ADD CONSTRAINT minsector_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE plan_netscenario_presszone ADD CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey FOREIGN KEY (netscenario_id) REFERENCES plan_netscenario(netscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_arc ADD CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_node ADD CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_connec ADD CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- create rules to avoid presszone_id = -1 or 0
CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = -1) OR (OLD.presszone_id = -1)) DO INSTEAD NOTHING;

CREATE RULE presszone_del_uconflict AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = -1) DO INSTEAD NOTHING;

CREATE RULE presszone_del_undefined AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = 0) DO INSTEAD NOTHING;

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = 0) OR (OLD.presszone_id = 0)) DO INSTEAD NOTHING;



ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE minsector ADD CONSTRAINT minsector_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE rpt_inp_pattern_value ADD CONSTRAINT rpt_inp_pattern_value_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance_dma_graph ADD CONSTRAINT rtc_scada_x_dma_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_verified_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dma_del_conflict AS
    ON DELETE TO dma
   WHERE (old.dma_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE dma_del_undefined AS
    ON DELETE TO dma
   WHERE (old.dma_id = 0) DO INSTEAD NOTHING;

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE arc ADD CONSTRAINT arc_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE minsector ADD CONSTRAINT minsector_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


CREATE RULE dqa_conflict AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = '-1'::integer) OR (old.dqa_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dqa_del_conflict AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE dqa_del_undefined AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = 0) DO INSTEAD NOTHING;

CREATE RULE dqa_undefined AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE arc ADD CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_controls ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_rules ADD CONSTRAINT inp_dscenario_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_rules ADD CONSTRAINT inp_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_sector ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE "element" ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);


CREATE RULE sector_conflict AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = '-1'::integer) OR (old.sector_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE sector_del_conflict AS
    ON DELETE TO sector
   WHERE (old.sector_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE sector_del_undefined AS
    ON DELETE TO sector
   WHERE (old.sector_id = 0) DO INSTEAD NOTHING;

CREATE RULE sector_undefined AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = 0) OR (old.sector_id = 0)) DO INSTEAD NOTHING;






CREATE RULE supplyzone_conflict AS
    ON UPDATE TO supplyzone
   WHERE ((new.supplyzone_id = '-1'::integer) OR (old.supplyzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE supplyzone_del_conflict AS
    ON DELETE TO supplyzone
   WHERE (old.supplyzone_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE supplyzone_del_undefined AS
    ON DELETE TO supplyzone
   WHERE (old.supplyzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE supplyzone_undefined AS
    ON UPDATE TO supplyzone
   WHERE ((new.supplyzone_id = 0) OR (old.supplyzone_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE arc ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE config_graph_mincut ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE config_graph_mincut ADD CONSTRAINT config_graph_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT inp_dscenario_inlet_node_id_fkey;
ALTER TABLE inp_inlet ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_inlet ADD CONSTRAINT inp_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_inlet ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_inlet(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_node_id_fkey;
ALTER TABLE inp_junction ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_junction ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_junction(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_label ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_label ADD CONSTRAINT inp_label_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_pump_id_fkey;
ALTER TABLE inp_pump_additional ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_node_id_fkey;
ALTER TABLE inp_pump ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_pump(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_pump_id_fkey FOREIGN KEY (node_id, order_id) REFERENCES inp_pump_additional(node_id,order_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_reservoir DROP CONSTRAINT inp_dscenario_reservoir_node_id_fkey;
ALTER TABLE inp_reservoir ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_reservoir ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_reservoir ADD CONSTRAINT inp_dscenario_reservoir_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_reservoir(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_shortpipe DROP CONSTRAINT inp_dscenario_shortpipe_node_id_fkey;
ALTER TABLE inp_shortpipe ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_shortpipe ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_shortpipe ADD CONSTRAINT inp_dscenario_shortpipe_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_shortpipe(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_tank DROP CONSTRAINT inp_dscenario_tank_node_id_fkey;
ALTER TABLE inp_tank ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_tank ADD CONSTRAINT inp_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_tank ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_tank ADD CONSTRAINT inp_dscenario_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_tank(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_valve DROP CONSTRAINT inp_dscenario_valve_node_id_fkey;
ALTER TABLE inp_valve ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_valve ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE inp_dscenario_valve ADD CONSTRAINT inp_dscenario_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_valve(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_expansiontank ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_expansiontank ADD CONSTRAINT man_expansiontank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_filter ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_filter ADD CONSTRAINT man_filter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_flexunion ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_flexunion ADD CONSTRAINT man_flexunion_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_hydrant ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_hydrant ADD CONSTRAINT man_hydrant_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_junction ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_junction ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_manhole ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_manhole ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_meter ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_meter ADD CONSTRAINT man_meter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netelement ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_netelement ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netsamplepoint ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_netsamplepoint ADD CONSTRAINT man_netsamplepoint_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netwjoin ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_netwjoin ADD CONSTRAINT man_netwjoin_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_pump ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_pump ADD CONSTRAINT man_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_reduction ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_reduction ADD CONSTRAINT man_reduction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_register ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_register ADD CONSTRAINT man_register_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_source ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_source ADD CONSTRAINT man_source_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_tank ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_tank ADD CONSTRAINT man_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_netscenario_valve DROP CONSTRAINT plan_netscenario_valve_node_id_fkey;
ALTER TABLE man_valve ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_netscenario_valve ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE plan_netscenario_valve ADD CONSTRAINT plan_netscenario_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES man_valve(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_waterwell ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_waterwell ADD CONSTRAINT man_waterwell_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_wtp ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE man_wtp ADD CONSTRAINT man_wtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_source ALTER COLUMN wtp_id TYPE int4 USING wtp_id::int4;
ALTER TABLE man_source ADD CONSTRAINT man_source_wtp_id_fkey FOREIGN KEY (wtp_id) REFERENCES man_wtp(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON plan_psector_x_node;
ALTER TABLE plan_psector_x_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE rtc_hydrometer_x_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE rtc_hydrometer_x_node ADD CONSTRAINT rtc_hydrometer_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ext_rtc_scada_x_data ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE ext_rtc_scada_x_data ADD CONSTRAINT ext_rtc_scada_x_data_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;



ALTER TABLE ext_hydrometer_category ADD CONSTRAINT ext_hydrometer_category_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE ext_rtc_dma_period ADD CONSTRAINT ext_rtc_dma_period_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_inlet ADD CONSTRAINT inp_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_value_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_reservoir ADD CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dma ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dqa ADD CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE sector ADD CONSTRAINT sector_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE supplyzone ADD CONSTRAINT supplyzone_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"node", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"element", "column":"buildercat_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"buildercat_id"}}$$);

DROP TABLE cat_builder;




ALTER TABLE config_graph_checkvalve ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE config_graph_checkvalve ADD CONSTRAINT config_graph_checkvalve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE config_graph_checkvalve ALTER COLUMN to_arc TYPE int4 USING to_arc::int4;
ALTER TABLE config_graph_checkvalve ADD CONSTRAINT config_graph_checkvalve_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_pipe DROP CONSTRAINT inp_dscenario_pipe_arc_id_fkey;
ALTER TABLE inp_pipe ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_pipe ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_dscenario_pipe ADD CONSTRAINT inp_dscenario_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_pipe(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_virtualvalve DROP CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey;
ALTER TABLE inp_virtualvalve ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_virtualvalve ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_dscenario_virtualvalve ADD CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_virtualvalve(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_virtualpump ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualpump ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_virtualpump(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pipe ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE man_pipe ADD CONSTRAINT man_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pump ALTER COLUMN to_arc TYPE int4 USING to_arc::int4;
ALTER TABLE man_pump ADD CONSTRAINT man_pump_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_valve ALTER COLUMN to_arc TYPE int4 USING to_arc::int4;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_to_arc_fky FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_varc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE man_varc ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE plan_arc_x_pavement ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON plan_psector_x_arc;
ALTER TABLE plan_psector_x_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_connec ON plan_psector_x_connec;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_link ON plan_psector_x_connec;
ALTER TABLE plan_psector_x_connec ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE doc_x_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_connec DROP CONSTRAINT inp_dscenario_connec_connec_id_fkey;
ALTER TABLE inp_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE inp_dscenario_connec ADD CONSTRAINT inp_dscenario_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES inp_connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_fountain ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE man_fountain ALTER COLUMN linked_connec TYPE int4 USING linked_connec::int4;
ALTER TABLE man_fountain ADD CONSTRAINT man_fountain_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_fountain ADD CONSTRAINT man_fountain_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_greentap ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE man_greentap ALTER COLUMN linked_connec TYPE int4 USING linked_connec::int4;
ALTER TABLE man_greentap ADD CONSTRAINT man_greentap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_greentap ADD CONSTRAINT man_greentap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_tap ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE man_tap ALTER COLUMN linked_connec TYPE int4 USING linked_connec::int4;
ALTER TABLE man_tap ADD CONSTRAINT man_tap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_tap ADD CONSTRAINT man_tap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wjoin ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE man_wjoin ADD CONSTRAINT man_wjoin_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE rtc_hydrometer_x_connec ADD CONSTRAINT rtc_hydrometer_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE element_x_node ALTER COLUMN element_id TYPE int4 USING element_id::int4;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN element_id TYPE int4 USING element_id::int4;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ALTER COLUMN element_id TYPE int4 USING element_id::int4;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_link ALTER COLUMN element_id TYPE int4 USING element_id::int4;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_link ADD CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;



-- macrosector
ALTER TABLE sector ADD CONSTRAINT sector_macrosector_id_fkey FOREIGN KEY (macrosector_id) REFERENCES macrosector(macrosector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;

-- macrodma
ALTER TABLE dma ADD CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrodma_del_undefined AS
    ON DELETE TO macrodma
   WHERE (old.macrodma_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrodma_undefined AS
    ON UPDATE TO macrodma
   WHERE ((new.macrodma_id = 0) OR (old.macrodma_id = 0)) DO INSTEAD NOTHING;

-- macrodqa
ALTER TABLE dqa ADD CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrodqa_del_undefined AS
    ON DELETE TO macrodqa
   WHERE (old.macrodqa_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrodqa_undefined AS
    ON UPDATE TO macrodqa
   WHERE ((new.macrodqa_id = 0) OR (old.macrodqa_id = 0)) DO INSTEAD NOTHING;


CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


-- macroexploitation
CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;

ALTER TABLE node ADD CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_expl ADD CONSTRAINT selector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario ADD CONSTRAINT plan_netscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE minsector ADD CONSTRAINT minsector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_curve ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_del_conflict AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE omzone_del_undefined AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

ALTER TABLE arc ADD CONSTRAINT arc_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;



CREATE RULE insert_plan_psector_x_arc AS
    ON INSERT TO arc
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
  VALUES (new.arc_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);

CREATE RULE insert_plan_psector_x_node AS
    ON INSERT TO node
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
  VALUES (new.node_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);

ALTER TABLE polygon ALTER COLUMN feature_id TYPE int4 USING feature_id::int4;
ALTER TABLE minsector_graph ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE plan_netscenario_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE plan_netscenario_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE plan_netscenario_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;

ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;

ALTER TABLE inp_dscenario_demand ALTER COLUMN feature_id TYPE int4 USING feature_id::int4;

ALTER TABLE plan_rec_result_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE plan_rec_result_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_1 TYPE int4 USING node_1::int4;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_2 TYPE int4 USING node_2::int4;

ALTER TABLE temp_anlgraph ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE temp_anlgraph ALTER COLUMN node_1 TYPE int4 USING node_1::int4;
ALTER TABLE temp_anlgraph ALTER COLUMN node_2 TYPE int4 USING node_2::int4;
ALTER TABLE temp_data ALTER COLUMN feature_id TYPE int4 USING feature_id::int4;

ALTER TABLE om_mincut_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE om_mincut_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE om_mincut_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;

ALTER TABLE om_mincut_valve_unaccess ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE om_mincut_valve ALTER COLUMN node_id TYPE int4 USING node_id::int4;

ALTER TABLE temp_demand ALTER COLUMN feature_id TYPE int4 USING feature_id::int4;

ALTER TABLE review_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE review_audit_node ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE review_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE review_audit_arc ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE review_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE review_audit_connec ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;

ALTER TABLE ext_rtc_scada ALTER COLUMN node_id TYPE integer USING node_id::integer;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

     IF v_utils THEN
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

    ELSE
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE ext_streetaxis ADD CONSTRAINT ext_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_address ADD CONSTRAINT ext_address_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_plot ADD CONSTRAINT ext_plot_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;


DO $$
DECLARE
    v_rec RECORD;
    v_table_name text;
    v_feature_name text;
BEGIN
    FOR v_rec IN
        SELECT DISTINCT cf.id, cf.feature_type
        FROM sys_addfields sa
        JOIN cat_feature cf ON cf.id = sa.cat_feature_id
    LOOP
        v_feature_name := lower(v_rec.feature_type) || '_id';
        v_table_name := 'man_' || lower(v_rec.feature_type) || '_' || lower(v_rec.id);

        EXECUTE 'ALTER TABLE ' || v_table_name || ' ALTER COLUMN ' || v_feature_name || ' TYPE int4 USING ' || v_feature_name || '::int4';
        EXECUTE 'ALTER TABLE ' || v_table_name || ' ADD CONSTRAINT ' || v_table_name || '_' || v_feature_name || '_fkey FOREIGN KEY (' || v_feature_name || ') REFERENCES '|| v_rec.feature_type ||'(' || v_feature_name || ') ON DELETE CASCADE';
    END LOOP;
END $$;


-- Recreate foreign keys for muni_id
DO $$
DECLARE
    v_utils boolean;
BEGIN
    SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

    IF v_utils THEN

        -- Index
        CREATE INDEX idx_municipality_name ON utils.municipality USING btree (name);
        CREATE INDEX idx_municipality_the_geom ON utils.municipality USING gist(the_geom);
        
        -- ext_municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        -- No utils.municipality BEFORE
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    ELSE 

        -- Index
        CREATE INDEX idx_ext_municipality_name ON ext_municipality USING btree (name);
        CREATE INDEX idx_ext_municipality_the_geom ON ext_municipality USING gist(the_geom);

        -- ext_municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        -- No utils.municipality
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;

-- MAPZONES
-- Create fk for arrays thorught triggers:
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodqa
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
    
    ELSE
    
        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodqa
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"ext_municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"ext_municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    END IF;
END; $$;
