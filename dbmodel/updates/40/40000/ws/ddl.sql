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

DROP TABLE IF EXISTS macrominsector;

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
ALTER TABLE node_border_sector DROP CONSTRAINT node_border_expl_sector_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_sector_id_fkey;
ALTER TABLE sector DROP CONSTRAINT sector_parent_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_sector_id;
ALTER TABLE element DROP CONSTRAINT element_sector_id;
ALTER TABLE link DROP CONSTRAINT link_sector_id;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_sector_id;

ALTER TABLE sector RENAME TO _sector;
ALTER TABLE _sector DROP CONSTRAINT sector_pkey;
ALTER TABLE _sector DROP CONSTRAINT sector_macrosector_id_fkey;
ALTER TABLE _sector DROP CONSTRAINT sector_pattern_id_fkey;

ALTER SEQUENCE SCHEMA_NAME.sector_sector_id_seq RENAME TO sector_sector_id_seq1;

DROP RULE IF EXISTS sector_conflict ON _sector;
DROP RULE IF EXISTS sector_del_conflict ON _sector;
DROP RULE IF EXISTS sector_del_undefined ON _sector;
DROP RULE IF EXISTS sector_undefined ON _sector;
DROP RULE IF EXISTS undelete_sector ON _sector;


-- add new columns [sector, muni, expl] to dma, presszone, dqa, sector
CREATE TABLE dma (
	dma_id serial4 NOT NULL,
	"name" varchar(30) NULL,
	dma_type varchar(16) NULL,
	expl_id int4[]  NULL,
    sector int4[] NULL,
    muni int4[] NULL,
    expl int4[] NULL,
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
	CONSTRAINT dma_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE presszone (
	presszone_id int4 NOT NULL,
	"name" text NOT NULL,
	presszone_type text NULL,
	expl_id int4[] NOT NULL,
    sector int4[] NULL,
    muni int4[] NULL,
    expl int4[] NULL,
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
	CONSTRAINT cat_presszone_pkey PRIMARY KEY (presszone_id),
	CONSTRAINT cat_presszone_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dqa (
	dqa_id serial4 NOT NULL,
	"name" varchar(30) NULL,
	dqa_type varchar(16) NULL,
	expl_id int4[] NULL,
    sector int4[] NULL,
    muni int4[] NULL,
    expl int4[] NULL,
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
	CONSTRAINT dqa_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sector (
	sector_id serial4 NOT NULL,
	"name" varchar(50) NOT NULL,
	sector_type varchar(16) NULL,
    muni int4[] NULL,
    expl int4[] NULL,
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