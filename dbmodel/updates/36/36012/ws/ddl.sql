/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE archived_rpt_arc RENAME TO _archived_rpt_arc;
ALTER TABLE _archived_rpt_arc RENAME CONSTRAINT archived_rpt_arc_pkey TO _archived_rpt_arc_pkey;

CREATE TABLE archived_rpt_inp_arc(
    id serial NOT NULL,
    result_id character varying(30) NOT NULL,
	arc_id varchar(16) NULL,
	node_1 varchar(16) NULL,
	node_2 varchar(16) NULL,
	arc_type varchar(30) NULL,
	arccat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	diameter numeric(12, 3) NULL,
	roughness numeric(12, 6) NULL,
	length numeric(12, 3) NULL,
	status varchar(18) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	expl_id int4 NULL,
	flw_code text NULL,
	minorloss numeric(12, 6) NULL,
	addparam text NULL,
	arcparent varchar(16) NULL,
	dma_id int4 NULL,
	presszone_id text NULL,
	dqa_id int4 NULL,
	minsector_id int4 NULL,
	age int4 NULL,
	CONSTRAINT archived_rpt_inp_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_arc(
	id serial4 NOT NULL,
	result_id varchar(30) NOT NULL,
	arc_id varchar(16) NULL,
	length numeric NULL,
	diameter numeric NULL,
	flow numeric NULL,
	vel numeric NULL,
	headloss numeric NULL,
	setting numeric NULL,
	reaction numeric NULL,
	ffactor numeric NULL,
	other varchar(100) NULL,
	"time" varchar(100) NULL,
	status varchar(16) NULL,
	CONSTRAINT archived_rpt_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_arc_stats(
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
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT archived_rpt_arc_stats_pkey PRIMARY KEY (arc_id, result_id),
	CONSTRAINT archived_rpt_arc_stats_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON DELETE CASCADE ON UPDATE CASCADE
);


ALTER TABLE archived_rpt_node RENAME TO _archived_rpt_node;
ALTER TABLE _archived_rpt_node RENAME CONSTRAINT archived_rpt_node_pkey TO _archived_rpt_node_pkey;

CREATE TABLE archived_rpt_inp_node (
	id serial4 NOT NULL,
	result_id varchar(30) NOT NULL,
	node_id varchar(16) NULL,
	elevation numeric(12, 3) NULL,
	elev numeric(12, 3) NULL,
	node_type varchar(30) NULL,
	nodecat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	demand float8 NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	expl_id int4 NULL,
	pattern_id varchar(16) NULL,
	addparam text NULL,
	nodeparent varchar(16) NULL,
	arcposition int2 NULL,
	dma_id int4 NULL,
	presszone_id text NULL,
	dqa_id int4 NULL,
	minsector_id int4 NULL,
	age int4 NULL,
	CONSTRAINT archived_rpt_inp_node_pkey PRIMARY KEY (id),
	CONSTRAINT archived_rpt_inp_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE archived_rpt_node (
	id serial4 NOT NULL,
	result_id varchar(30) NOT NULL,
	node_id varchar(16) NULL,
	elevation numeric NULL,
	demand numeric NULL,
	head numeric NULL,
	press numeric NULL,
	other varchar(100) NULL,
	"time" varchar(100) NULL,
	quality numeric(12, 4) NULL,
	CONSTRAINT archived_rpt_node_pkey PRIMARY KEY (id),
	CONSTRAINT archived_rpt_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE archived_rpt_node_stats (
	node_id varchar(16) NOT NULL,
	result_id varchar(30) NOT NULL,
	node_type varchar(30) NULL,
	sector_id int4 NULL,
	nodecat_id varchar(30) NULL,
	elevation numeric NULL,
	demand_max numeric NULL,
	demand_min numeric NULL,
	demand_avg numeric(12, 2) NULL,
	head_max numeric NULL,
	head_min numeric NULL,
	head_avg numeric(12, 2) NULL,
	press_max numeric NULL,
	press_min numeric NULL,
	press_avg numeric(12, 2) NULL,
	quality_max numeric NULL,
	quality_min numeric NULL,
	quality_avg numeric(12, 2) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT archived_rpt_node_stats_pkey PRIMARY KEY (node_id, result_id),
	CONSTRAINT archived_rpt_node_stats_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 2024/08/11
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"demand", "dataType":"numeric(12,6)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"demand_pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"emitter_coeff", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"demand", "dataType":"numeric(12,6)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"demand_pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"emitter_coeff", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"to_arc", "dataType":"varchar(16)"}}$$);

ALTER TABLE man_valve ADD CONSTRAINT man_valve_to_arc_fky FOREIGN KEY (to_arc) REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;





