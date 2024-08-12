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

DROP VIEW IF EXISTS v_ui_plan_arc_cost;

ALTER TABLE cat_brand ALTER COLUMN id TYPE character varying(50);
ALTER TABLE cat_brand_model ALTER COLUMN id TYPE character varying(50);

ALTER TABLE cat_arc ALTER COLUMN brand TYPE character varying(50);
ALTER TABLE cat_arc ALTER COLUMN model TYPE character varying(50);

ALTER TABLE cat_node ALTER COLUMN brand TYPE character varying(50);
ALTER TABLE cat_node ALTER COLUMN model TYPE character varying(50);

ALTER TABLE cat_connec ALTER COLUMN brand TYPE character varying(50);
ALTER TABLE cat_connec ALTER COLUMN model TYPE character varying(50);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"serial_number", "dataType":"varchar(100)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"cat_valve", "dataType":"varchar(30)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_hydrant", "column":"customer_code", "dataType":"varchar"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_node", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_node", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_connec", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_connec", "column":"model", "newName":"model_id"}}$$);


-- man_greentap
update connec c set brand_id = a.brand, model_id = a.model from (
	select connec_id, brand, model from man_greentap
)a where c.connec_id = a.connec_id;

-- man_wjoin
update connec c set brand_id = a.brand, model_id = a.model, cat_valve = a.cat_valve from (
	select connec_id, brand, model, cat_valve from man_wjoin
)a where c.connec_id = a.connec_id;

-- man_netwjoin
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_netwjoin
)a where n.node_id = a.node_id;

-- man_tap
update connec c set cat_valve = a.cat_valve from (
select connec_id, cat_valve from man_tap
)a where c.connec_id = a.connec_id;


-- man_hydrant
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_hydrant
)a where n.node_id = a.node_id;

-- man_meter
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_meter
)a where n.node_id = a.node_id;

-- man_netelement
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_netelement
)a where n.node_id = a.node_id;

-- man_pump
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_pump
)a where n.node_id = a.node_id;

-- man_valve
update node n set brand_id = a.brand, model_id = a.model from (
	select node_id, brand, model from man_valve
)a where n.node_id = a.node_id;

-- man_netelement
update node n set serial_number = a.serial_number from (
select node_id, serial_number from man_netelement
)a where n.node_id = a.node_id;





SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_greentap", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_greentap", "column":"model"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_greentap", "column":"cat_valve"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_wjoin", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_wjoin", "column":"model"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_wjoin", "column":"cat_valve"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netwjoin", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netwjoin", "column":"model"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netwjoin", "column":"cat_valve"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_tap", "column":"cat_valve"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_hydrant", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_hydrant", "column":"model"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_meter", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_meter", "column":"model"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netelement", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netelement", "column":"model"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_pump", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_pump", "column":"model"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_valve", "column":"brand"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_valve", "column":"model"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netelement", "column":"serial_number"}}$$);

ALTER TABLE connec ADD CONSTRAINT connec_cat_valve_fkey FOREIGN KEY (cat_valve) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;