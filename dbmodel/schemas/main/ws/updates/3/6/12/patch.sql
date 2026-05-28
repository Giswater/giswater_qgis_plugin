/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"demand", "dataType":"numeric(12,6)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"demand_pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"emitter_coeff", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"demand", "dataType":"numeric(12,6)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"demand_pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"emitter_coeff", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"to_arc", "dataType":"varchar(16)"}}$$);

ALTER TABLE man_valve ADD CONSTRAINT man_valve_to_arc_fky FOREIGN KEY (to_arc) REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"serial_number", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"serial_number", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"model_id", "dataType":"varchar(50)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"cat_valve", "dataType":"varchar(30)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_hydrant", "column":"customer_code", "dataType":"varchar(30)"}}$$);

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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"presszone", "column":"expl_id2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dqa", "column":"expl_id2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"expl_id2"}}$$);

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



CREATE TABLE macrominsector (
macrominsector_id serial PRIMARY KEY,
the_geom geometry(MultiPolygon,SRID_VALUE),
num_connec integer,
num_hydro integer,
length numeric(12,3),
addparam json,
code character varying(30),
descript text);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"macrominsector_id", "dataType":"integer"}}$$);

ALTER TABLE arc ADD CONSTRAINT arc_macrominsector_id_fkey FOREIGN KEY (macrominsector_id)
REFERENCES macrominsector (macrominsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT arc_macrominsector_id_fkey FOREIGN KEY (macrominsector_id)
REFERENCES macrominsector (macrominsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_macrominsector_id_fkey FOREIGN KEY (macrominsector_id)
REFERENCES macrominsector (macrominsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link ADD CONSTRAINT link_macrominsector_id_fkey FOREIGN KEY (macrominsector_id)
REFERENCES macrominsector (macrominsector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"dqa_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"dma_type", "dataType":"varchar(16)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"link", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"sector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"muni_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"active", "dataType":"boolean"}}$$);
ALTER TABLE man_valve ALTER COLUMN active SET default true;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_pump", "column":"to_arc", "dataType":"varchar(16)"}}$$);

ALTER TABLE man_pump ADD CONSTRAINT man_pump_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"pond", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"pool", "column":"muni_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"n_hydrometer", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_virtualpump", "column":"energyvalue", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_pump_additional", "column":"energyvalue", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_pump_additional", "column":"energyparam", "dataType":"integer"}}$$);

DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS vi_parent_node;
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS v_edit_field_valve;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"custom_dint", "dataType":"integer"}}$$);


do $$ 
declare
    v_utils boolean; 
begin
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';
	 
	 if v_utils is true then
	 
		-- create fk 
		ALTER TABLE SCHEMA_NAME.minsector ADD CONSTRAINT minsectormuni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
		
		ALTER TABLE SCHEMA_NAME.pond ADD CONSTRAINT pond_muni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	 
	 	ALTER TABLE SCHEMA_NAME.pool ADD CONSTRAINT pool_muni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
		
     else
	 
		-- create fk 
		ALTER TABLE SCHEMA_NAME.minsector ADD CONSTRAINT minsectormuni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
		
		ALTER TABLE SCHEMA_NAME.pond ADD CONSTRAINT pond_muni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	 
	 	ALTER TABLE SCHEMA_NAME.pool ADD CONSTRAINT pool_muni_id_fkey FOREIGN KEY (muni_id) 
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
				
	 end if;
end; $$;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_register", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_fountain", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_tank", "column":"_pol_id_", "dataType":"integer"}}$$);

CREATE OR REPLACE VIEW vu_sector
AS SELECT s.sector_id,
	s.name,
	s.macrosector_id,
	m.name as macrosector_name,
	et.idval,
	s.descript,
	s.parent_id,
	s.pattern_id,
	s.graphconfig::text AS graphconfig,
	s.stylesheet::text AS stylesheet,
	s.link,
	s.avg_press,
	s.active,
	s.undelete,
	s.tstamp,
	s.insert_user,
	s.lastupdate,
	s.lastupdate_user,
	s.the_geom
	FROM sector s
	JOIN macrosector m USING (macrosector_id)
	LEFT JOIN edit_typevalue et on et.id = sector_type AND typevalue = 'sector_type'
	ORDER BY s.sector_id;

CREATE OR REPLACE VIEW vu_dma
AS SELECT d.dma_id,
	d.name,
	d.macrodma_id,
	d.expl_id,
	et.idval as dma_type,
	d.descript,
	d.pattern_id,
	d.graphconfig::text AS graphconfig,
	d.stylesheet::text AS stylesheet,
	d.link,
	d.avg_press,
	d.effc,
	d.active,
	d.undelete,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user,
	d.the_geom
	FROM dma d
	LEFT JOIN edit_typevalue et on et.id = dma_type AND typevalue = 'dma_type'
	ORDER BY d.dma_id;

CREATE OR REPLACE VIEW vu_presszone
AS SELECT p.presszone_id,
	p.name,
	p.expl_id,
	et.idval as presszone_type,
	p.descript,
	p.head,
	p.graphconfig::text AS graphconfig,
	p.stylesheet::text AS stylesheet,
	p.link,
	p.avg_press,
	p.active,
	p.tstamp,
	p.insert_user,
	p.lastupdate,
	p.lastupdate_user,
	p.the_geom
	FROM presszone p
	LEFT JOIN edit_typevalue et on et.id = presszone_type AND typevalue = 'presszone_type'
	ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW vu_dqa
AS SELECT d.dqa_id,
	d.name,
	d.macrodqa_id,
	d.descript,
	d.expl_id,
	et.idval as dqa_type,
	d.pattern_id,
	d.graphconfig::text AS graphconfig,
	d.stylesheet::text AS stylesheet,
	d.link,
	d.active,
	d.undelete,
	d.tstamp,
	d.insert_user,
	d.lastupdate,
	d.lastupdate_user,
	d.the_geom
	FROM dqa d
	LEFT JOIN edit_typevalue et on et.id = dqa_type AND typevalue = 'dqa_type'
	ORDER BY d.dqa_id;


DROP VIEW IF EXISTS v_edit_sector;
CREATE OR REPLACE VIEW v_edit_sector as
select vu_sector.* from vu_sector, selector_sector
WHERE (vu_sector.sector_id = selector_sector.sector_id) AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dma as
select vu_dma.* from vu_dma, selector_expl
WHERE ((vu_dma.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR vu_dma.expl_id is null
order by 1 asc;

CREATE OR REPLACE VIEW v_edit_presszone as
select vu_presszone.* from vu_presszone, selector_expl
WHERE ((vu_presszone.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR vu_presszone.expl_id is null
order by 1 asc;

CREATE OR REPLACE VIEW v_edit_dqa as
select vu_dqa.* from vu_dqa, selector_expl
WHERE ((vu_dqa.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR vu_dqa.expl_id is null
order by 1 asc;



CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s, rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text
  AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);

DROP VIEW IF EXISTS v_edit_minsector;
DROP VIEW IF EXISTS v_edit_element;

DROP VIEW IF EXISTS v_edit_samplepoint;

DROP VIEW IF EXISTS v_ext_municipality;
DROP VIEW IF EXISTS v_ext_address;
DROP VIEW IF EXISTS v_ext_streetaxis;
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.views
        WHERE table_schema = 'SCHEMA_NAME'
          AND table_name = 'ext_streetaxis'
    ) THEN
        DROP VIEW ext_streetaxis;
    END IF;
END $$;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"minsector", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"om_streetaxis", "column":"code", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_streetaxis", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"code", "dataType":"text"}}$$);

-- recreate v_edit_element, v_edit_samplepoint, v_ext_streetaxis, v_ext_municipality views
-----------------------------------

CREATE OR REPLACE VIEW v_edit_minsector
AS SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam::text AS addparam,
    m.the_geom
    FROM selector_expl,  minsector m,  selector_sector, selector_municipality
	WHERE ((m.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text OR m.expl_id is null)
	AND((m.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text) OR m.sector_id is null)
	AND((m.muni_id = selector_municipality.muni_id AND selector_sector.cur_user = "current_user"()::text) OR m.muni_id is null);

CREATE OR REPLACE VIEW v_edit_element AS
SELECT e.* FROM ( SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.elevation,
    element.expl_id2,
    element.trace_featuregeom,
    element.muni_id,
    element.sector_id
   FROM selector_expl, element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  join selector_sector s using (sector_id)
  LEFT JOIN selector_municipality m using (muni_id)
  where s.cur_user = current_user
  and (m.cur_user = current_user or e.muni_id is null);


CREATE OR REPLACE VIEW v_edit_samplepoint AS
SELECT sm.* FROM ( SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.presszone_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link,
    samplepoint.sector_id
    FROM selector_expl, samplepoint
    JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
    LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
	WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) sm
	join selector_sector s using (sector_id)
    LEFT JOIN selector_municipality m using (muni_id)
    where s.cur_user = current_user
    and (m.cur_user = current_user or sm.muni_id is null);

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 IF v_utils IS true THEN
        CREATE OR REPLACE VIEW ext_streetaxis
        AS SELECT streetaxis.id,
            streetaxis.code,
            streetaxis.type,
            streetaxis.name,
            streetaxis.text,
            streetaxis.the_geom,
            streetaxis.ws_expl_id AS expl_id,
            streetaxis.muni_id
        FROM utils.streetaxis;
    END IF;
END; $$;

CREATE OR REPLACE VIEW v_ext_address
AS SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom
   FROM selector_expl,
    ext_address
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = ext_address.streetaxis_id::text
  WHERE ext_address.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ext_streetaxis
AS SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
            WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
            WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
            ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
        END AS descript
	FROM selector_municipality, ext_streetaxis
	WHERE ext_streetaxis.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ext_municipality
AS SELECT DISTINCT m.muni_id,
    m.name,
    m.active,
    m.the_geom
    FROM ext_municipality m, selector_municipality
    WHERE m.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text;


-- recreate all deleted views: arc, node, connec and dependencies
-----------------------------------
CREATE OR REPLACE VIEW vu_arc AS
WITH
streetaxis as (SELECT id, descript FROM v_ext_streetaxis),
typevalue as (SELECT typevalue, id, idval FROM edit_typevalue WHERE typevalue in ('sector_type','presszone_type','dma_type','dqa_type'))
SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.elevation1,
    arc.depth1,
    arc.staticpress1,
    arc.node_2,
    arc.nodetype_2,
    arc.staticpress2,
    arc.elevation2,
    arc.depth2,
    ((coalesce(depth1)+coalesce(depth2))/2)::numeric(12,2) as depth,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    cat_arc.dint AS cat_dint,
    arc.epa_type,
    arc.state,
    arc.state_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name as sector_name,
    sector.macrosector_id,
    et1.idval::varchar(16) as sector_type,
    arc.presszone_id,
    presszone.name as presszone_name,
    et2.idval::varchar(16) as presszone_type,
    presszone.head as presszone_head,
    arc.dma_id,
    dma.name as dma_name,
    et3.idval::varchar(16) as dma_type,
    dma.macrodma_id,
    arc.dqa_id,
    dqa.name as dqa_name,
    et4.idval::varchar(16) as dqa_type,
    dqa.macrodqa_id,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.workcat_id_plan,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    mu.region_id,
    mu.province_id,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.label_quadrant,
    arc.publish,
    arc.inventory,
    arc.num_value,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    CASE
        WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
        ELSE arc.brand_id
    END AS brand_id,
    CASE
        WHEN arc.model_id IS NULL THEN cat_arc.model_id
        ELSE arc.model_id
    END AS model_id,
    arc.serial_number,
	arc.minsector_id,
	arc.macrominsector_id,
	e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
	date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
	case when arc.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN arc_add e ON arc.arc_id::text = e.arc_id::text
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 on et1.id = sector.sector_type AND et1.typevalue = 'sector_type'
     LEFT JOIN typevalue et2 on et2.id = presszone.presszone_type AND et2.typevalue = 'presszone_type'
     LEFT JOIN typevalue et3 on et3.id = dma.dma_type AND et3.typevalue = 'dma_type'
     LEFT JOIN typevalue et4 on et4.id = dqa.dqa_type AND et4.typevalue = 'dqa_type';

create or replace view v_edit_arc as
select a.* FROM (
select a.* FROM ( SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER) s, vu_arc a
JOIN v_state_arc USING (arc_id)
WHERE a.expl_id = s.expl_id OR a.expl_id2 = s.expl_id) a
join selector_sector s using (sector_id)
LEFT JOIN selector_municipality m using (muni_id)
where s.cur_user = current_user
and (m.cur_user = current_user or a.muni_id is null);


CREATE OR REPLACE VIEW vu_node AS
WITH
streetaxis as (SELECT id, descript FROM v_ext_streetaxis),
typevalue as (SELECT typevalue, id, idval FROM edit_typevalue WHERE typevalue in ('sector_type','presszone_type','dma_type','dqa_type'))
SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id AS node_type,
    cat_feature.system_id AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    cat_node.dint AS cat_dint,
    node.epa_type,
    node.state,
    node.state_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    et1.idval::varchar(16) AS sector_type,
    node.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::varchar(16) AS presszone_type,
    presszone.head AS presszone_head,
    node.dma_id,
    dma.name AS dma_name,
    et3.idval::varchar(16) AS dma_type,
    dma.macrodma_id,
    node.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::varchar(16) AS dqa_type,
    dqa.macrodqa_id,
    node.arc_id,
    node.parent_id,
    node.annotation,
    node.observ,
    node.comment,
    node.staticpressure,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.workcat_id_plan,
    node.builtdate,
    node.enddate,
    node.buildercat_id,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.district_id,
    a.descript::character varying(100) AS streetname,
    node.postnumber,
    node.postcomplement,
    b.descript::character varying(100) AS streetname2,
    node.postnumber2,
    node.postcomplement2,
    mu.region_id,
    mu.province_id,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(cat_feature.link_path, node.link) AS link,
    node.verified,
    node.undelete,
    cat_node.label,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.label_quadrant,
    node.publish,
    node.inventory,
    node.hemisphere,
    node.num_value,
    node.adate,
    node.adescript,
    node.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    node.expl_id2,
    vst.is_operative,
    CASE
    WHEN node.brand_id IS NULL THEN cat_node.brand_id
    ELSE node.brand_id
    END AS brand_id,
    CASE
        WHEN node.model_id IS NULL THEN cat_node.model_id
        ELSE node.model_id
    END AS model_id,
    node.serial_number,
    node.minsector_id,
    node.macrominsector_id,
    e.demand_max,
    e.demand_min,
    e.demand_avg,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.head_max,
    e.head_min,
    e.head_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom
    FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id
     LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = node.presszone_id::text
     LEFT JOIN streetaxis a ON a.id::text = node.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = node.streetaxis2_id::text
     LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
     LEFT JOIN value_state_type vst ON vst.id = node.state_type
     LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 on et1.id = sector.sector_type AND et1.typevalue = 'sector_type'
     LEFT JOIN typevalue et2 on et2.id = presszone.presszone_type AND et2.typevalue = 'presszone_type'
     LEFT JOIN typevalue et3 on et3.id = dma.dma_type AND et3.typevalue = 'dma_type'
     LEFT JOIN typevalue et4 on et4.id = dqa.dqa_type AND et4.typevalue = 'dqa_type';

create or replace view v_edit_node as
select a.*, case when s.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type,
v.closed as closed_valve, v.broken as broken_valve
 FROM (select n.* FROM
( SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER) s, vu_node n
JOIN v_state_node USING (node_id)
WHERE n.expl_id = s.expl_id OR n.expl_id2 = s.expl_id) a
LEFT JOIN man_valve v USING (node_id)
join v_sector_node s using (node_id)
LEFT JOIN selector_municipality m using (muni_id)
where (m.cur_user = current_user or a.muni_id is null);


CREATE OR REPLACE VIEW vu_connec AS
WITH
streetaxis as (SELECT id, descript FROM v_ext_streetaxis),
typevalue as (SELECT typevalue, id, idval FROM edit_typevalue WHERE typevalue in ('sector_type','presszone_type','dma_type','dqa_type'))
	SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    connec.epa_type,
    connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
	sector.name as sector_name,
    sector.macrosector_id,
	et1.idval::varchar(16) as sector_type,
	connec.presszone_id,
	presszone.name as presszone_name,
	et2.idval::varchar(16) as presszone_type,
    presszone.head as presszone_head,
	connec.dma_id,
	dma.name as dma_name,
	et3.idval::varchar(16) as dma_type,
    dma.macrodma_id,
    connec.dqa_id,
	dqa.name as dqa_name,
	et4.idval::varchar(16) as dqa_type,
    dqa.macrodqa_id,
    connec.crmzone_id,
    crm_zone.name as crmzone_name,
    connec.customer_code,
    connec.connec_length,
    connec.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.staticpressure,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.workcat_id_plan,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    b.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
	mu.region_id,
    mu.province_id,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.label_quadrant,
    connec.publish,
    connec.inventory,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    connec.asset_id,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.expl_id2,
    vst.is_operative,
    connec.plot_code,
    CASE
        WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
        ELSE connec.brand_id
    END AS brand_id,
    CASE
        WHEN connec.model_id IS NULL THEN cat_connec.model_id
        ELSE connec.model_id
    END AS model_id,
    connec.serial_number,
    connec.cat_valve,
    connec.minsector_id,
	connec.macrominsector_id,
	e.demand,
	e.press_max,
    e.press_min,
    e.press_avg,
	e.quality_max,
    e.quality_min,
    e.quality_avg,
	date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    case when connec.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type
    FROM connec
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = connec.presszone_id::text
     LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 on et1.id = sector.sector_type AND et1.typevalue = 'sector_type'
     LEFT JOIN typevalue et2 on et2.id = presszone.presszone_type AND et2.typevalue = 'presszone_type'
     LEFT JOIN typevalue et3 on et3.id = dma.dma_type AND et3.typevalue = 'dma_type'
     LEFT JOIN typevalue et4 on et4.id = dqa.dqa_type AND et4.typevalue = 'dqa_type';

DROP view if exists v_edit_link;
DROP view if exists v_link;
DROP view if exists v_link_connec;
DROP view if exists vu_link;

-- link views
CREATE OR REPLACE VIEW vu_link AS
WITH
typevalue as (SELECT typevalue, id, idval FROM edit_typevalue WHERE typevalue in ('sector_type','presszone_type','dma_type','dqa_type'))
	SELECT l.link_id,
	l.feature_type,
	l.feature_id,
	l.exit_type,
	l.exit_id,
	l.state,
	l.expl_id,
	l.sector_id,
	s.name as sector_name,
	et1.idval::varchar(16) as sector_type,
	s.macrosector_id,
	presszone_id::character varying(16) AS presszone_id,
	p.name as presszone_name,
	et2.idval::varchar(16) as presszone_type,
	p.head as presszone_head,
	l.dma_id,
	d.name as dma_name,
	et3.idval::varchar(16) as dma_type,
	d.macrodma_id,
	l.dqa_id,
	q.name as dqa_name,
	et4.idval::varchar(16) as dqa_type,
	q.macrodqa_id,
	l.exit_topelev,
	l.exit_elev,
	l.fluid_type,
	st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
	l.the_geom,
	l.muni_id,
	l.expl_id2,
	l.epa_type,
	l.is_operative,
	l.staticpressure,
	l.connecat_id,
	l.workcat_id,
	l.workcat_id_end,
	l.builtdate,
	l.enddate,
	date_trunc('second'::text, l.lastupdate) AS lastupdate,
	l.lastupdate_user,
	l.uncertain,
	l.minsector_id,
	l.macrominsector_id
	FROM link l
	LEFT JOIN sector s USING (sector_id)
	LEFT JOIN presszone p USING (presszone_id)
	LEFT JOIN dma d USING (dma_id)
	LEFT JOIN dqa q USING (dqa_id)
	LEFT JOIN typevalue et1 on et1.id = s.sector_type AND et1.typevalue = 'sector_type'
	LEFT JOIN typevalue et2 on et2.id = p.presszone_type AND et2.typevalue = 'presszone_type'
	LEFT JOIN typevalue et3 on et3.id = d.dma_type AND et3.typevalue = 'dma_type'
	LEFT JOIN typevalue et4 on et4.id = q.dqa_type AND et4.typevalue = 'dqa_type';

CREATE OR REPLACE VIEW v_edit_link AS
	SELECT l.* FROM (
	SELECT *
	FROM vu_link
	JOIN v_state_link USING (link_id)) l
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user and (m.cur_user = current_user or l.muni_id is null);


CREATE OR REPLACE VIEW v_edit_connec AS
SELECT  c.* FROM (
    WITH s AS (
    SELECT selector_expl.expl_id
   FROM selector_expl
  WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
	vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
	vu_connec.cat_dint,
	vu_connec.epa_type,
	vu_connec.inp_type,
	vu_connec.state,
    vu_connec.state_type,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
	CASE
		WHEN a.sector_id IS NULL THEN vu_connec.sector_id
		ELSE a.sector_id
	END AS sector_id,
	CASE
		WHEN a.sector_name IS NULL THEN vu_connec.sector_name
		ELSE a.sector_name
	END AS sector_name,
    vu_connec.macrosector_id,
	CASE
		WHEN a.presszone_id IS NULL THEN vu_connec.presszone_id
		ELSE a.presszone_id
	END AS presszone_id,
	CASE
		WHEN a.presszone_name IS NULL THEN vu_connec.presszone_name
		ELSE a.presszone_name
	END AS presszone_name,
	CASE
		WHEN a.presszone_type IS NULL THEN vu_connec.presszone_type
		ELSE a.presszone_type
	END AS presszone_type,
	CASE
		WHEN a.presszone_head IS NULL THEN vu_connec.presszone_head
		ELSE a.presszone_head
	END AS presszone_head,
	CASE
		WHEN a.dma_id IS NULL THEN vu_connec.dma_id
		ELSE a.dma_id
	END AS dma_id,
	CASE
		WHEN a.dma_name IS NULL THEN vu_connec.dma_name
		ELSE a.dma_name
	END AS dma_name,
	CASE
		WHEN a.dma_type IS NULL THEN vu_connec.dma_type
		ELSE a.dma_type::character varying(30)
	END AS dma_type,
	CASE
		WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
		ELSE a.macrodma_id
	END AS macrodma_id,
	CASE
		WHEN a.dqa_id IS NULL THEN vu_connec.dqa_id
		ELSE a.dqa_id
	END AS dqa_id,
	CASE
		WHEN a.dqa_name IS NULL THEN vu_connec.dqa_name
		ELSE a.dqa_name
	END AS dqa_name,
	CASE
		WHEN a.dqa_type IS NULL THEN vu_connec.dqa_type
		ELSE a.dqa_type
	END AS dqa_type,
	CASE
		WHEN a.macrodqa_id IS NULL THEN vu_connec.macrodqa_id
		ELSE a.macrodqa_id
	END AS macrodqa_id,
	vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.customer_code,
    vu_connec.connec_length,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
    CASE
	WHEN a.staticpressure IS NULL THEN vu_connec.staticpressure
	ELSE a.staticpressure
    END AS staticpressure,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.workcat_id_plan,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.label_quadrant,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    CASE
	WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
	ELSE a.exit_id
    END AS pjoint_id,
    CASE
	WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
	ELSE a.exit_type
    END AS pjoint_type,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.om_state,
    vu_connec.conserv_state,
    vu_connec.expl_id2,
    vu_connec.is_operative,
    vu_connec.plot_code,
    vu_connec.brand_id,
    vu_connec.model_id,
    vu_connec.serial_number,
    vu_connec.cat_valve,
    CASE
	WHEN a.minsector_id IS NULL THEN vu_connec.minsector_id
	ELSE a.minsector_id
    END AS minsector_id,
    vu_connec.macrominsector_id,
    vu_connec.demand,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
	vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg,
	vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom
   FROM s, vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.sector_type,
            vu_link.dma_id,
            vu_link.dma_type,
            vu_link.presszone_id,
	    vu_link.presszone_head,
	    vu_link.presszone_type,
            vu_link.dqa_id,
            vu_link.dqa_type,
            vu_link.minsector_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.dma_name,
            vu_link.dqa_name,
            vu_link.presszone_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id,
            vu_link.macrodqa_id,
            vu_link.expl_id2,
            vu_link.staticpressure
           FROM vu_link, s s_1
          WHERE (vu_link.expl_id = s_1.expl_id OR vu_link.expl_id2 = s_1.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text
	WHERE vu_connec.expl_id = s.expl_id OR vu_connec.expl_id2 = s.expl_id) c
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user
	and (m.cur_user = current_user or c.muni_id is null);


-- dependent views
CREATE OR REPLACE VIEW v_plan_aux_arc_pavement
AS SELECT plan_arc_x_pavement.arc_id,
    sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
    sum(v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id)
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM v_edit_arc
     JOIN cat_pavement c ON c.id::text = v_edit_arc.pavcat_id::text
     JOIN v_price_x_catpavement USING (pavcat_id)
     LEFT JOIN v_price_compost p ON c.m2_cost::text = p.id::text
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id)
  WHERE a.arc_id IS NULL;

CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.sector_id,
    d.expl_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.depth1,
                            v_edit_arc.depth2,
                                CASE
                                    WHEN (v_edit_arc.depth1 * v_edit_arc.depth2) = 0::numeric OR (v_edit_arc.depth1 * v_edit_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.depth1 + v_edit_arc.depth2) / 2::numeric)::numeric(12,2)
                                END AS mean_depth,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.dint / 1000::numeric, 0::numeric)::numeric(12,4) AS dint,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,4) AS bulk,
                            v_price_x_catarc.cost_unit,
                            COALESCE(v_price_x_catarc.cost, 0::numeric)::numeric(12,2) AS arc_cost,
                            COALESCE(v_price_x_catarc.m2bottom_cost, 0::numeric)::numeric(12,2) AS m2bottom_cost,
                            COALESCE(v_price_x_catarc.m3protec_cost, 0::numeric)::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            COALESCE(v_price_x_catsoil.y_param, 10::numeric)::numeric(5,2) AS y_param,
                            COALESCE(v_price_x_catsoil.b, 0::numeric)::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, 0::numeric) AS trenchlining,
                            COALESCE(v_price_x_catsoil.m3exc_cost, 0::numeric)::numeric(12,2) AS m3exc_cost,
                            COALESCE(v_price_x_catsoil.m3fill_cost, 0::numeric)::numeric(12,2) AS m3fill_cost,
                            COALESCE(v_price_x_catsoil.m3excess_cost, 0::numeric)::numeric(12,2) AS m3excess_cost,
                            COALESCE(v_price_x_catsoil.m2trenchl_cost, 0::numeric)::numeric(12,2) AS m2trenchl_cost,
                            COALESCE(v_plan_aux_arc_pavement.thickness, 0::numeric)::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, 0::numeric) AS m2pav_cost,
                            v_edit_arc.state,
                            v_edit_arc.expl_id,
                            v_edit_arc.the_geom
                           FROM v_edit_arc
                             LEFT JOIN v_price_x_catarc ON v_edit_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_edit_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_edit_arc.arc_id::text
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_depth - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.dint)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.dint + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
                END::numeric(12,3) AS pav_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
                END::numeric(12,3) AS exc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
                END::numeric(12,3) AS trenchl_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
                END::numeric(12,3) AS base_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
                END::numeric(12,3) AS protec_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
                END::numeric(12,3) AS fill_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
                END::numeric(12,3) AS excess_cost,
            v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
                END::numeric(12,2) AS cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
                END::numeric(12,2) AS length,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
                END::numeric(14,2) AS budget,
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                END::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON arc.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (p.price * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d
  WHERE d.arc_id IS NOT NULL;


CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM v_ext_municipality a, ext_raster_dem r
   JOIN ext_cat_raster c ON c.id = r.rastercat_id
   WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);

CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_element e
    JOIN polygon USING (pol_id);

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_node
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;


CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_connec
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;


CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_arc
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    v_edit_connec.arc_id,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    a.state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link l ON v_edit_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_connec.arc_id::text
  WHERE v_edit_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_connec c ON c.connec_id::text = n.feature_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_node
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    st_x(a.the_geom) AS x1,
    st_y(a.the_geom) AS y1,
    v_edit_arc.node_2,
    st_x(b.the_geom) AS x2,
    st_y(b.the_geom) AS y2
   FROM v_edit_arc
     LEFT JOIN node a ON a.node_id::text = v_edit_arc.node_1::text
     LEFT JOIN node b ON b.node_id::text = v_edit_arc.node_2::text;

CREATE OR REPLACE VIEW v_ui_node_x_relations AS
SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.parent_id AS node_id,
    v_edit_node.node_type,
    v_edit_node.nodecat_id,
    v_edit_node.node_id AS child_id,
    v_edit_node.code,
    v_edit_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_edit_node
  WHERE v_edit_node.parent_id IS NOT NULL;


CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_connec c
    JOIN polygon ON polygon.feature_id::text = c.connec_id::text;

CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));


CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


CREATE OR REPLACE VIEW ve_pol_node as
SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM polygon
   JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_node
AS SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_edit_node.node_id,
            v_edit_node.nodecat_id,
            v_edit_node.sys_type AS node_type,
            v_edit_node.elevation AS top_elev,
            v_edit_node.elevation - v_edit_node.depth AS elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END * v_price_x_catnode.cost
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_tank ON man_tank.node_id::text = v_edit_node.node_id::text
             LEFT JOIN man_pump ON man_pump.node_id::text = v_edit_node.node_id::text
             LEFT JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_ui_plan_node_cost
AS SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    NULL::double precision AS length
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_result_node
AS SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;


CREATE OR REPLACE VIEW v_edit_inp_junction
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    inp_junction.peak_factor,
    inp_junction.emitter_coeff,
    inp_junction.init_quality,
    inp_junction.source_type,
    inp_junction.source_quality,
    inp_junction.source_pattern_id,
    n.the_geom
   FROM v_edit_node n
   JOIN inp_junction USING (node_id)
   WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction
AS SELECT p.dscenario_id,
    p.node_id,
    p.demand,
    p.pattern_id,
    p.emitter_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_junction p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    man_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_pump USING (node_id)
	JOIN man_pump USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pipe
AS SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.expl_id,
    a.sector_id,
    a.dma_id,
    a.state,
    a.state_type,
    a.custom_length,
    a.annotation,
    inp_pipe.minorloss,
    inp_pipe.status,
    r.roughness as cat_roughness,
    inp_pipe.custom_roughness,
    a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    a.the_geom
	FROM v_edit_arc a
	JOIN inp_pipe USING (arc_id)
	LEFT JOIN cat_mat_roughness r ON cat_matcat_id = matcat_id
	WHERE a.is_operative IS TRUE
	AND (now()::date - (CASE WHEN builtdate IS NULL THEN '1900-01-01'::date ELSE builtdate END))/365 >= r.init_age
	AND (now()::date - (CASE WHEN builtdate IS NULL THEN '1900-01-01'::date ELSE builtdate END))/365 < r.end_age AND r.active is true;


DROP VIEW IF EXISTS ve_epa_pipe;
CREATE OR REPLACE VIEW ve_epa_pipe AS
SELECT inp_pipe.arc_id,
    inp_pipe.minorloss,
    inp_pipe.status,
    r.roughness AS cat_roughness,
    inp_pipe.custom_roughness,
    a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.reactionparam,
    inp_pipe.reactionvalue,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max,
    v_rpt_arc.flow_min,
    v_rpt_arc.flow_avg,
    v_rpt_arc.vel_max,
    v_rpt_arc.vel_min,
    v_rpt_arc.vel_avg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM vu_arc a
   	JOIN inp_pipe USING (arc_id)
     LEFT JOIN v_rpt_arc ON split_part(v_rpt_arc.arc_id::text, 'P'::text, 1) = inp_pipe.arc_id::text
     LEFT JOIN cat_mat_roughness r ON a.cat_matcat_id::text = r.matcat_id::text
       WHERE ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) >= r.init_age AND ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) < r.end_age AND r.active IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_virtualpump
AS SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.sector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.expl_id,
    a.dma_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.energyvalue,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    p.pump_type,
    a.the_geom
    FROM v_edit_arc a
    JOIN inp_virtualpump p USING (arc_id)
	WHERE a.is_operative IS TRUE;

-- ve_epa_virtualpump is not neeed to reformulate


CREATE OR REPLACE VIEW v_edit_inp_virtualvalve
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.arccat_id,
    v_edit_arc.expl_id,
    v_edit_arc.sector_id,
    v_edit_arc.dma_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.custom_length,
    v_edit_arc.annotation,
    v.valv_type,
    v.pressure,
    v.flow,
    v.coef_loss,
    v.curve_id,
    v.minorloss,
    v.status,
    v.init_quality,
    v_edit_arc.the_geom
	FROM v_edit_arc
	JOIN inp_virtualvalve v USING (arc_id)
	WHERE v_edit_arc.is_operative IS TRUE;

DROP VIEW ve_epa_virtualvalve;
CREATE OR REPLACE VIEW ve_epa_virtualvalve AS
 SELECT inp_virtualvalve.arc_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.diameter,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    inp_virtualvalve.init_quality,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
    FROM inp_virtualvalve
    LEFT JOIN v_rpt_arc USING (arc_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe
AS SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    p.bulk_coeff,
    p.wall_coeff,
    a.the_geom
	FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_pipe p USING (arc_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve
AS SELECT d.dscenario_id,
    p.arc_id,
    p.valv_type,
    p.pressure,
    p.diameter,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.init_quality,
    a.the_geom
    FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_virtualvalve p USING (arc_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualpump
AS SELECT v.dscenario_id,
    p.arc_id,
    v.power,
    v.curve_id,
    v.speed,
    v.pattern_id,
    v.status,
    v.pump_type,
    v.effic_curve_id,
    v.energy_price,
    v.energy_pattern_id,
    p.the_geom
    FROM selector_inp_dscenario s, v_edit_inp_virtualpump p
    JOIN inp_dscenario_virtualpump v USING (arc_id)
    WHERE v.dscenario_id = s.dscenario_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_connec
AS SELECT v_edit_connec.connec_id,
    v_edit_connec.elevation,
    v_edit_connec.depth,
    v_edit_connec.connecat_id,
    v_edit_connec.arc_id,
    v_edit_connec.expl_id,
    v_edit_connec.sector_id,
    v_edit_connec.dma_id,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.pjoint_type,
    v_edit_connec.pjoint_id,
    v_edit_connec.annotation,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_edit_connec.the_geom
    FROM v_edit_connec
    JOIN inp_connec USING (connec_id)
	WHERE v_edit_connec.is_operative IS TRUE;


CREATE OR REPLACE VIEW ve_pol_register
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'REGISTER'::text;

CREATE OR REPLACE VIEW ve_pol_fountain
AS SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'FOUNTAIN'::text;

CREATE OR REPLACE VIEW ve_pol_tank
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'TANK'::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump as
SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_pump p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump_additional
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.dma_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_pump_additional p USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional
AS SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_pump_additional p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_shortpipe p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_connec
AS SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    c.emitter_coeff,
    c.init_quality,
    c.source_type,
    c.source_quality,
    c.source_pattern_id,
    connec.the_geom
    FROM selector_inp_dscenario, v_edit_inp_connec connec
    JOIN inp_dscenario_connec c USING (connec_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE c.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_shortpipe
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    CASE
	WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
        WHEN v.closed IS FALSE AND v.active IS TRUE AND v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
        WHEN v.closed IS FALSE AND active IS FALSE THEN 'OPEN'::character varying(12)
        ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_shortpipe using (node_id)
    LEFT JOIN man_valve v ON v.node_id::text = n.node_id::text
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank
AS SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_tank p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    JOIN v_sector_node s ON s.node_id::text = n.node_id::text
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_tank USING (node_id)
    WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir
AS SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_reservoir p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_reservoir
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_reservoir USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_valve p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_valve
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
	CASE
	WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
        WHEN v.closed IS FALSE AND v.active IS TRUE THEN 'ACTIVE'::character varying(12)
        WHEN v.closed IS FALSE AND active IS FALSE THEN 'OPEN'::character varying(12)
        ELSE NULL::character varying(12)
        END AS status,
	n.cat_dint,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_valve USING (node_id)
	JOIN man_valve v USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet
AS SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
	p.head,
    p.pattern_id,
	p.demand,
	p.demand_pattern_id,
	p.emitter_coeff,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_inlet p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	JOIN v_sector_node s ON s.node_id::text = n.node_id::text
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_inlet
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.overflow,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
	inp_inlet.pattern_id,
    inp_inlet.head,
	inp_inlet.demand,
	inp_inlet.demand_pattern_id,
	inp_inlet.emitter_coeff,
    n.the_geom
	FROM v_edit_node n
    JOIN inp_inlet USING (node_id)
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.sector_id,
            v_plan_arc.expl_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.arctype_id,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
            a.descript,
            a.link,
            a.brand_id,
            a.model_id,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.shape,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM v_plan_arc
             JOIN cat_arc a ON a.id::text = v_plan_arc.arccat_id::text
             JOIN cat_soil s ON s.id::text = v_plan_arc.soilcat_id::text
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    p.m2mlbottom * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2bottom_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    p.m3mlprotec * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3_protec_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    p.m3mlexc * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3exc_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    p.m3mlfill * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3fill_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    p.m3mlexcess * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3excess_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    p.m2mltrenchl * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2trenchl_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN a.price_id IS NULL THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id::text = p.arc_id::text
     JOIN cat_pavement c ON a.pavcat_id::text = c.id::text
     LEFT JOIN v_price_compost r ON a.price_id::text = c.m2_cost::text
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (min(v.price) * count(v_edit_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature
AS SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1 AND arc.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1 AND node.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1 AND connec.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1 AND element.workcat_id IS NOT NULL;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end as
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_edit_connec.connecat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;

CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.nodetype_id,
    cat_feature.system_id,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.connecat_id,
    cat_connec.connectype_id,
    cat_feature.system_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN cat_connec ON cat_connec.id::text = connec.connecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arctype_id,
    cat_feature.system_id,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_current_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.value::integer = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_all
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999 AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;

CREATE OR REPLACE VIEW v_plan_psector_budget_arc
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget_detail
AS SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


-- delete views definitely
-----------------------------------
DROP VIEW IF EXISTS v_state_link_connec;



CREATE OR REPLACE VIEW v_om_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

drop view ve_epa_inlet;
CREATE OR REPLACE VIEW ve_epa_inlet AS
 SELECT inp_inlet.node_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    inp_inlet.overflow,
    inp_inlet.head,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
	inp_inlet.demand,
	inp_inlet.demand_pattern_id,
	inp_inlet.emitter_coeff,
    v_rpt_node.result_id,
    v_rpt_node.demand_max AS demandmax,
    v_rpt_node.demand_min AS demandmin,
    v_rpt_node.demand_avg AS demandavg,
    v_rpt_node.head_max AS headmax,
    v_rpt_node.head_min AS headmin,
    v_rpt_node.head_avg AS headavg,
    v_rpt_node.press_max AS pressmax,
    v_rpt_node.press_min AS pressmin,
    v_rpt_node.press_avg AS pressavg,
    v_rpt_node.quality_max AS qualmax,
    v_rpt_node.quality_min AS qualmin,
    v_rpt_node.quality_avg AS qualavg
    FROM inp_inlet
    LEFT JOIN v_rpt_node USING (node_id);


drop view ve_epa_shortpipe;
CREATE OR REPLACE VIEW ve_epa_shortpipe AS
 SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    cat_dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
    CASE
        WHEN v.active is true and v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
        WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
        WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
        ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
    FROM vu_node
    JOIN inp_shortpipe USING (node_id)
    LEFT JOIN v_rpt_arc ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc.arc_id::text
    LEFT JOIN man_valve v ON v.node_id::text = inp_shortpipe.node_id::text;


drop view ve_epa_valve;
CREATE OR REPLACE VIEW ve_epa_valve AS
 SELECT inp_valve.node_id,
    inp_valve.valv_type,
    inp_valve.pressure,
	cat_dint,
    inp_valve.custom_dint,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
	v.to_arc,
    CASE
	WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
        WHEN v.closed IS FALSE AND v.active IS TRUE THEN 'ACTIVE'::character varying(12)
        WHEN v.closed IS FALSE AND active IS FALSE THEN 'OPEN'::character varying(12)
        ELSE NULL::character varying(12)
    END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    concat(inp_valve.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
    FROM vu_node
    JOIN inp_valve USING (node_id)
    LEFT JOIN v_rpt_arc ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc.arc_id::text
    LEFT JOIN man_valve v ON v.node_id::text = inp_valve.node_id::text;


CREATE OR REPLACE VIEW ve_epa_pump AS
 SELECT inp_pump.node_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    inp_pump.status,
    p.to_arc,
    inp_pump.energyparam,
    inp_pump.energyvalue,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    concat(inp_pump.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
    FROM inp_pump
    LEFT JOIN v_rpt_arc ON concat(inp_pump.node_id, '_n2a') = v_rpt_arc.arc_id::text
	LEFT JOIN man_pump p ON p.node_id::text = inp_pump.node_id::text;

CREATE OR REPLACE VIEW v_edit_pond AS
	SELECT pond.pond_id,
    pond.connec_id,
    pond.dma_id,
    dma.macrodma_id,
    pond.state,
    pond.the_geom,
    pond.expl_id,
	pond.muni_id
    FROM selector_expl,   pond
    LEFT JOIN dma ON pond.dma_id = dma.dma_id
	LEFT JOIN selector_municipality m using (muni_id)
	where (m.cur_user = current_user or pond.muni_id is null) and
    pond.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_pool AS
	SELECT pool.pool_id,
    pool.connec_id,
    pool.dma_id,
    dma.macrodma_id,
    pool.state,
    pool.the_geom,
    pool.expl_id,
	pool.muni_id
    FROM selector_expl, pool
    LEFT JOIN dma ON pool.dma_id = dma.dma_id
	LEFT JOIN selector_municipality m using (muni_id)
	where (m.cur_user = current_user or pool.muni_id is null)
	and pool.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

INSERT INTO sys_function VALUES (3322, 'gw_fct_setpsectorcostremovedpipes', 'ws', 'function', 'json', 'json',
'Function to set cost for removed material on specific psectors. 
Choose the material that has to be removed and the price that costs to remove 1 lineal meter of that material (this price has to exist in column ''id''
of table plan_price. The result is the sum of meters of the chosen material to be removed and the total cost of it for the selected exploitation grouped by psector.
The result will be shown in tab Other of psectors.', 'role_master', null, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (523, 'fprocess to set cost for removed material on psectors','ws',null,'core',FALSE, 'Function process')
ON CONFLICT (fid) DO NOTHING;

DELETE from sys_fprocess WHERE fid = 522;

INSERT INTO config_toolbox VALUES (3322, 'Set cost for removed material on psectors', '{"featureType":[]}',
'[
{"widgetname":"expl", "label":"Exploitation:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
{"widgetname":"material", "label":"Material:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, descript as idval FROM cat_mat_arc", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
{"widgetname":"price", "label":"Price:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Code of removal material price", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Descriptive text for removal (it apears on psector_x_other observ)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}
]',
null, TRUE, '{4}');


UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_arc' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_arc' AND tabname='tab_relations';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_arc' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_arc' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_arc' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_connec' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_connec' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_connec' AND tabname='tab_documents';

UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_node' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_node' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_node' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=7
	WHERE formname='v_edit_node' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer_val';



INSERT INTO archived_rpt_inp_arc(
	result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
	presszone_id, dqa_id, minsector_id, age)
SELECT
	result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
	presszone_id, dqa_id, minsector_id, age
FROM _archived_rpt_arc;


INSERT INTO archived_rpt_arc(
	result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status)
SELECT
	result_id, arc_id, rpt_length, rpt_diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, rpt_status
FROM _archived_rpt_arc;


INSERT INTO archived_rpt_inp_node(
	result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
	demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
	minsector_id, age)
SELECT
	result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
	demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
	minsector_id, age
FROM _archived_rpt_node;


INSERT INTO archived_rpt_node(
	result_id, node_id, elevation, demand, head, press, other, time, quality)
SELECT
	result_id, node_id, rpt_elevation, rpt_demand, head, press, other, time, quality
FROM _archived_rpt_node;

-- move data from confif_graph_checkvalve to man_valve
UPDATE man_valve v SET to_arc = c.to_arc, active = true FROM config_graph_checkvalve c WHERE c.node_id = v.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"to_arc"}}$$);

-- move to_arc from inp_pump to man_pump
UPDATE man_pump m SET to_arc = i.to_arc FROM inp_pump i WHERE i.node_id = m.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump", "column":"to_arc"}}$$);

-- move to_arc from inp_valve to man_valve
UPDATE man_valve m SET to_arc = i.to_arc FROM inp_valve i where i.node_id = m.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_valve", "column":"to_arc"}}$$);

-- move status from inp_valve to man_valve
UPDATE man_valve m SET active = true FROM inp_valve i where i.node_id = m.node_id AND i.status IN ('ACTIVE', 'CLOSED');
UPDATE man_valve m SET active = false FROM inp_valve i where i.node_id = m.node_id AND i.status ='OPEN';
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_valve", "column":"status"}}$$);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'presszone_type', 'presszone', 'presszone_type', true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'dma_type', 'dma', 'dma_type', true);

INSERT INTO edit_typevalue VALUES ('dma_type','UNDEFINED', 'UNDEFINED');

ALTER TABLE edit_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE edit_typevalue SET id = upper(id), idval=upper(idval) WHERE typevalue IN ('sector_type');
ALTER TABLE edit_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;


INSERT INTO config_style VALUES (101, 'GwBasic', NULL, 'role_basic', '{"orderBy":1}', false, true);
INSERT INTO config_style VALUES (102, 'GwEpa', NULL, 'role_basic', '{"orderBy":2}', false, true);
INSERT INTO config_style VALUES (103, 'GwGraphConfig', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (104, 'GwInpLog', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (105, 'GwMincutOverlap', NULL, NULL, NULL, true, true);

UPDATE sys_style SET layername='line', styleconfig_id = 104 WHERE layername='INP result line';
UPDATE sys_style SET layername='point', styleconfig_id = 104 WHERE layername='INP result point';
UPDATE sys_style SET layername='line', styleconfig_id = 105 WHERE layername='Overlap affected arcs';
UPDATE sys_style SET layername='point', styleconfig_id = 105 WHERE layername='Overlap affected connecs';
UPDATE sys_style SET layername='point', styleconfig_id = 103 WHERE layername='Temporal-Graphconfig';

UPDATE sys_style SET layername='v_edit_arc', styleconfig_id = 102 WHERE layername='v_edit_arc EPANET point of view';
UPDATE sys_style SET layername='v_edit_connec', styleconfig_id = 102 WHERE layername='v_edit_connec EPANET point of view';
UPDATE sys_style SET layername='v_edit_node', styleconfig_id = 102 WHERE layername='v_edit_node EPANET point of view';
UPDATE sys_style SET layername='v_edit_link', styleconfig_id = 102 WHERE layername='v_edit_link EPANET point of view';

UPDATE sys_style SET styleconfig_id = 101 WHERE styleconfig_id is null;

DELETE FROM sys_style WHERE layername ilike 'flow%'; -- flow trace & flow exit does not make sense for ws


INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('macrominsector', 'Table of macrominsectors', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);


delete from config_form_fields where columnname = 'nodetype_id' and formname ilike 've_%';
delete from config_form_fields where columnname = 'connectype_id' and formname ilike 've_%';
delete from config_form_fields where columnname = 'cat_arctype_id' and formname ilike 've_%';

delete from sys_table where id = 'vi_parent_arc';
delete from sys_table where id = 'vi_parent_connec';
delete from sys_table where id = 'vi_parent_hydrometer';
delete from sys_table where id = 'v_edit_field_valve';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_dma', 'form_feature', 'tab_none', 'dma_type', 'lyt_data_1', 18, 'string', 'combo', 'dma_type', 'dma_type', false, false, true, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dma_type''', false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 17, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 18, 'string', 'combo', 'Demand pattern:', 'Demand pattern', false, false, true, false,
'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern', true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 19, 'string', 'text', 'Emitter coef:', 'Emitter coef', false, false, true, false, NULL, false);


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 14, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 15, 'string', 'combo', 'Demand pattern:', 'Demand pattern', false, false, true, false,
'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern', true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 16, 'string', 'text', 'Emitter coef:', 'Emitter coef', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false, dv_querytext=null, dv_parent_id=null where formname='v_edit_inp_shortpipe' and columnname='to_arc';
UPDATE config_form_fields SET iseditable=false, dv_orderby_id=null, dv_isnullvalue=null where formname='v_edit_inp_shortpipe' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_shortpipe', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_data_1', 15, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_shortpipe', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_data_1', 16, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false where formname='ve_epa_shortpipe' and columnname='to_arc';
UPDATE config_form_fields SET dv_orderby_id=null, dv_isnullvalue=null where formname='ve_epa_shortpipe' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_epa_data_1', 7, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_epa_data_1', 8, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false where formname='ve_epa_valve' and columnname='to_arc';
UPDATE config_form_fields SET widgettype='text', iseditable=false, dv_querytext=null, dv_orderby_id=null, dv_isnullvalue=null where formname='ve_epa_valve' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_valve', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_epa_data_1', 13, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
UPDATE config_form_fields SET layoutorder=14 where formname='ve_epa_valve' and columnname='custom_dint';


UPDATE config_form_fields SET iseditable=false, dv_querytext=null where formname='v_edit_inp_valve' and columnname='to_arc';
UPDATE config_form_fields SET iseditable=false, dv_querytext=null, dv_orderby_id=null, dv_isnullvalue=null where formname='v_edit_inp_valve' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_valve', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_data_1', 20, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_valve', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_data_1', 21, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);

UPDATE config_form_fields SET iseditable=false where columnname='macrominsector_id';
UPDATE config_form_fields SET iseditable=false where columnname='to_arc' and formname like 've_node%';

update config_form_fields SET iseditable=true where formtype = 'form_mincut' and widgettype = 'button';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'cat_dint', 'lyt_data_1', max(layoutorder)+1,
'string', 'text', 'cat_dint', 'cat_dint',  false, false, false, false, false
FROM cat_feature
join config_form_fields on formname = child_layer
where formtype = 'form_feature' and tabname = 'tab_data' and layoutname = 'lyt_data_1' and layoutorder < 900
group by child_layer, formname, formtype, tabname
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3266, 'Selected epa_type cannot be used in this feature',
'For valve and pump, feature type and epa type must correspond ', 2, true, 'utils', 'core') on conflict (id) do nothing;


UPDATE config_form_fields SET layoutorder=layoutorder+1 where formname='ve_epa_pipe' and layoutname='lyt_epa_data_1' and layoutorder > 2;

UPDATE config_form_fields SET layoutorder=layoutorder+1 where formname='ve_epa_pipe' and layoutname='lyt_epa_data_1' and layoutorder > 4;
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_pipe', 'form_feature', 'tab_epa', 'cat_roughness', 'lyt_epa_data_1', 3, 'string', 'text', 'Cat roughness:', 'Cat roughness', false, false, false, false, NULL, false);

UPDATE config_form_fields SET layoutorder=layoutorder+1 where formname='ve_epa_pipe' and layoutname='lyt_epa_data_1' and layoutorder > 4;

UPDATE config_form_fields SET layoutorder=layoutorder+1 where formname='ve_epa_pipe' and layoutname='lyt_epa_data_1' and layoutorder > 4;
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_pipe', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_epa_data_1', 5, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_pipe', 'form_feature', 'tab_none', 'cat_dint', 'lyt_data_1', 16, 'string', 'text', 'cat_dint', 'cat_dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_pipe', 'form_feature', 'tab_none', 'cat_roughness', 'lyt_data_1', 17, 'string', 'text', 'cat_roughness', 'cat_roughness', false, false, false, false, NULL, false);


UPDATE config_form_fields SET layoutorder=1 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=2 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=3 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=4 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='head' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=9, tabname='tab_none' WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='presszone_type';
DELETE FROM config_form_fields WHERE formname='v_edit_presszone' AND formtype='form_feature' AND columnname='expl_id2';

UPDATE config_form_fields SET layoutorder=1 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=2 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=3 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=4 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='dqa_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='expl_id2' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='v_edit_dqa' AND formtype='form_feature' AND columnname='expl_id2';

UPDATE config_form_fields SET layoutorder=1 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=2 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=3 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=4 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='minc';
DELETE FROM config_form_fields WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='maxc';
DELETE FROM config_form_fields WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='expl_id2';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='v_edit_dma' AND formtype='form_feature' AND columnname='effc' AND tabname='tab_none';

UPDATE config_form_fields SET web_layoutorder=1 WHERE formname='mincut' AND formtype='form_mincut' AND columnname='btn_valve_status' AND tabname='tab_mincut';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='mincut' AND formtype='form_mincut' AND columnname='btn_refresh_mincut' AND tabname='tab_mincut';
UPDATE config_form_fields SET web_layoutorder=0 WHERE formname='mincut' AND formtype='form_mincut' AND columnname='btn_custom_mincut' AND tabname='tab_mincut';
UPDATE config_form_fields SET web_layoutorder=NULL WHERE formname='mincut' AND formtype='form_mincut' AND columnname='btn_mincut' AND tabname='tab_mincut';


INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_energy_usage', NULL, 'role_epa', 'core')ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_dqa', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('selector_period', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('inp_dscenario_virtualpump', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_rtc_hydrometer_x_node', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_arc', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_node', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_hydraulic_status', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rtc_hydrometer_x_node', NULL, 'role_edit', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_rpt_compare_node', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_rpt_compare_arc', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_hydroval', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_minsector_graph', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_sector', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_dma', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_presszone', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;



INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, hidden, web_layoutorder)
	VALUES ('mincut', 'form_mincut', 'tab_mincut', 'btn_apply', 'lyt_bot_1', 'button', false, false, true, false, false, '{"text":"Apply"}'::json, '{"functionName":"apply","params": {}}'::json, false, 1);
UPDATE config_form_fields SET web_layoutorder = 2 WHERE formname='mincut' AND formtype='form_mincut' AND tabname='tab_mincut' AND columnname = 'btn_cancel';

UPDATE config_form_fields SET web_layoutorder=NULL WHERE formname='mincut' AND formtype='form_mincut' AND columnname='chk_use_planified' AND tabname='tab_mincut';

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('om_mincut_vdefault', '{"mincut_type":"(SELECT id FROM om_mincut_cat_type ORDER BY id ASC LIMIT 1)", "exec_appropiate":"false", "received_date":"now()", "anl_cause":"1", "assigned_to":"current_user"}', 'Default values used when creating a new mincut', 'Default mincut values:', NULL, NULL, true, 3, 'ws', NULL, NULL, 'json', 'linetext', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_om');



UPDATE config_toolbox SET functionparams='{"featureType": {"node":["v_edit_inp_reservoir", "v_edit_inp_tank", "v_edit_inp_inlet", "v_edit_inp_junction", "v_edit_inp_shortpipe", "v_edit_inp_valve", "v_edit_inp_pump", "v_edit_inp_pump_additional"], "arc":["v_edit_inp_pipe", "v_edit_inp_virtualvalve", "v_edit_inp_virtualpump"], "connec":["v_edit_inp_connec"]}}'::json WHERE id = 3108;

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
		UPDATE pond p SET muni_id = a.muni_id FROM (
			SELECT p.pond_id,m.muni_id FROM pond p
			LEFT JOIN exploitation e USING (expl_id)
			LEFT JOIN utils.municipality m ON st_intersects(m.the_geom, e.the_geom)
		) a
		WHERE p.pond_id = a.pond_id;

		UPDATE pool p SET muni_id = p.muni_id FROM (
			SELECT p.pool_id, m.muni_id FROM pool p
			LEFT JOIN exploitation e USING (expl_id)
			LEFT JOIN utils.municipality m ON st_intersects(m.the_geom, e.the_geom)
		) a
		WHERE p.pool_id = a.pool_id;

    ELSE

		UPDATE pond p SET muni_id = a.muni_id FROM (
			SELECT p.pond_id,m.muni_id FROM pond p
			LEFT JOIN exploitation e USING (expl_id)
			LEFT JOIN ext_municipality m ON st_intersects(m.the_geom, e.the_geom)
		) a
		WHERE p.pond_id = a.pond_id;

		UPDATE pool p SET muni_id = p.muni_id FROM (
			SELECT p.pool_id, m.muni_id FROM pool p
			LEFT JOIN exploitation e USING (expl_id)
			LEFT JOIN ext_municipality m ON st_intersects(m.the_geom, e.the_geom)
		) a
		WHERE p.pool_id = a.pool_id;
    END IF;
END; $$;

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology|Labeling" labelsEnabled="1">
  <renderer-v2 enableorderby="0" forceraster="0" symbollevels="0" type="RuleRenderer" referencescale="-1">
    <rules key="{b8c29f9a-2182-4e01-bcea-1687a6a41b0d}">
      <rule key="{4d314a8c-24ee-482e-841d-8aa27d5ca772}" label="PIPE" filter="&quot;inp_type&quot; = ''PIPE''" symbol="0"/>
      <rule key="{921510fd-6923-4853-bb07-46f67356dd71}" label="VIRTUALPUMP" filter="&quot;inp_type&quot; = ''VIRTUALPUMP''" symbol="1"/>
      <rule key="{bb6e6bf4-12b0-4337-b08a-1753a74e27fd}" label="VIRTUALVALVE" filter="&quot;inp_type&quot; = ''VIRTUALVALVE''" symbol="2"/>
      <rule key="{a29214e4-605a-4928-913f-0c7bf0d499f4}" label="NOT USED" filter="&quot;inp_type&quot; IS NULL" symbol="3"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.5" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.535714" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@1@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="0,106,253,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.2" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="P" name="chr" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="MS Shell Dlg 2" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.5" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.541667" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@2@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2.6" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="0.433333" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="206,206,206,255" name="line_color" type="QString"/>
            <Option value="dot" name="line_style" type="QString"/>
            <Option value="0.5" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{08a8c2aa-57b2-43c5-987a-a7766bc15ab6}">
      <rule key="{004702f4-250f-4738-a932-ddfe44d0c66a}" filter="&quot;inp_type&quot; IS NOT NULL">
        <settings calloutType="simple">
          <text-style multilineHeightUnit="Percentage" fontUnderline="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" blendMode="0" useSubstitutions="0" fontLetterSpacing="0" fontKerning="1" legendString="Aa" fontWordSpacing="0" fontWeight="50" textOrientation="horizontal" multilineHeight="1" allowHtml="0" textOpacity="1" forcedItalic="0" textColor="0,0,0,255" namedStyle="Normal" previewBkgrdColor="255,255,255,255" fontItalic="0" capitalization="0" fontFamily="MS Shell Dlg 2" fontStrikeout="0" fontSize="8" forcedBold="0" isExpression="0" fontSizeUnit="Point" fieldName="arccat_id">
            <families/>
            <text-buffer bufferColor="255,255,255,255" bufferOpacity="1" bufferBlendMode="0" bufferNoFill="1" bufferSize="1" bufferDraw="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128"/>
            <text-mask maskType="0" maskedSymbolLayers="" maskSize="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskSizeUnits="MM" maskJoinStyle="128" maskOpacity="1" maskEnabled="0"/>
            <background shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeRotationType="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="MM" shapeRadiiUnit="MM" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeType="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeDraw="0" shapeJoinStyle="64" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeSVGFile="" shapeSizeType="0" shapeRotation="0" shapeRadiiX="0" shapeRadiiY="0" shapeOffsetX="0" shapeSizeY="0" shapeBorderWidth="0" shapeOpacity="1">
              <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="markerSymbol" type="marker">
                <data_defined_properties>
                  <Option type="Map">
                    <Option value="" name="name" type="QString"/>
                    <Option name="properties"/>
                    <Option value="collection" name="type" type="QString"/>
                  </Option>
                </data_defined_properties>
                <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
                  <Option type="Map">
                    <Option value="0" name="angle" type="QString"/>
                    <Option value="square" name="cap_style" type="QString"/>
                    <Option value="243,166,178,255" name="color" type="QString"/>
                    <Option value="1" name="horizontal_anchor_point" type="QString"/>
                    <Option value="bevel" name="joinstyle" type="QString"/>
                    <Option value="circle" name="name" type="QString"/>
                    <Option value="0,0" name="offset" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                    <Option value="MM" name="offset_unit" type="QString"/>
                    <Option value="35,35,35,255" name="outline_color" type="QString"/>
                    <Option value="solid" name="outline_style" type="QString"/>
                    <Option value="0" name="outline_width" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                    <Option value="MM" name="outline_width_unit" type="QString"/>
                    <Option value="diameter" name="scale_method" type="QString"/>
                    <Option value="2" name="size" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                    <Option value="MM" name="size_unit" type="QString"/>
                    <Option value="1" name="vertical_anchor_point" type="QString"/>
                  </Option>
                  <data_defined_properties>
                    <Option type="Map">
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
              <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="fillSymbol" type="fill">
                <data_defined_properties>
                  <Option type="Map">
                    <Option value="" name="name" type="QString"/>
                    <Option name="properties"/>
                    <Option value="collection" name="type" type="QString"/>
                  </Option>
                </data_defined_properties>
                <layer locked="0" enabled="1" pass="0" class="SimpleFill">
                  <Option type="Map">
                    <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                    <Option value="255,255,255,255" name="color" type="QString"/>
                    <Option value="bevel" name="joinstyle" type="QString"/>
                    <Option value="0,0" name="offset" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                    <Option value="MM" name="offset_unit" type="QString"/>
                    <Option value="128,128,128,255" name="outline_color" type="QString"/>
                    <Option value="no" name="outline_style" type="QString"/>
                    <Option value="0" name="outline_width" type="QString"/>
                    <Option value="MM" name="outline_width_unit" type="QString"/>
                    <Option value="solid" name="style" type="QString"/>
                  </Option>
                  <data_defined_properties>
                    <Option type="Map">
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetAngle="135" shadowUnder="0" shadowOffsetGlobal="1" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowRadius="1.5" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.69999999999999996" shadowColor="0,0,0,255" shadowDraw="0" shadowRadiusUnit="MM" shadowBlendMode="6" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format reverseDirectionSymbol="0" autoWrapLength="0" placeDirectionSymbol="0" addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" multilineAlign="0" decimals="3" plussign="0" formatNumbers="0" wrapChar="" leftDirectionSymbol="&lt;"/>
          <placement centroidInside="0" polygonPlacementFlags="2" distUnits="MM" maxCurvedCharAngleOut="-25" fitInPolygonOnly="0" yOffset="0" overrunDistanceUnit="MM" overrunDistance="0" centroidWhole="0" priority="5" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overlapHandling="PreventOverlap" repeatDistanceUnits="MM" lineAnchorType="0" preserveRotation="1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" distMapUnitScale="3x:0,0,0,0,0,0" offsetType="0" lineAnchorPercent="0.5" geometryGeneratorEnabled="0" lineAnchorTextPoint="CenterOfText" maxCurvedCharAngleIn="25" placementFlags="10" allowDegraded="0" repeatDistance="0" geometryGenerator="" placement="2" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorClipping="0" dist="0" rotationUnit="AngleDegrees" offsetUnits="MM" geometryGeneratorType="PointGeometry" rotationAngle="0" xOffset="0" layerType="LineGeometry"/>
          <rendering obstacleType="0" zIndex="0" scaleMin="0" mergeLines="0" unplacedVisibility="0" fontLimitPixelSize="0" scaleVisibility="1" obstacleFactor="1" labelPerPart="0" maxNumLabels="2000" minFeatureSize="0" fontMinPixelSize="3" scaleMax="1000" limitNumLabels="0" upsidedownLabels="0" fontMaxPixelSize="10000" drawLabels="1" obstacle="1"/>
          <dd_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
              <Option value="0" name="blendMode" type="int"/>
              <Option name="ddProperties" type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
              <Option value="false" name="drawToAllParts" type="bool"/>
              <Option value="0" name="enabled" type="QString"/>
              <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
              <Option value="&lt;symbol force_rhr=&quot;0&quot; alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; is_animated=&quot;0&quot; frame_rate=&quot;10&quot; name=&quot;symbol&quot; type=&quot;line&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
              <Option value="0" name="minLength" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
              <Option value="MM" name="minLengthUnit" type="QString"/>
              <Option value="0" name="offsetFromAnchor" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
              <Option value="0" name="offsetFromLabel" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
    </rules>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE styleconfig_id=102 and layername='v_edit_arc';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 enableorderby="0" forceraster="0" symbollevels="0" type="RuleRenderer" referencescale="-1">
    <rules key="{43f34189-9dbc-4806-8d81-936039a35645}">
      <rule key="{4f3368ad-0218-4d14-802c-a0e002f9461e}" label="INLET" filter="&quot;inp_type&quot; = ''INLET''" symbol="0"/>
      <rule key="{2e8da878-6321-4ccd-b1ed-6e77c448474a}" label="JUNCTION" filter="&quot;inp_type&quot; = ''JUNCTION''" symbol="1"/>
      <rule key="{0da10b08-539c-4c76-a75a-ab5d00becb5e}" label="PUMP" filter="&quot;inp_type&quot; = ''PUMP''" symbol="2"/>
      <rule key="{8f5b8a5c-e9e2-4127-8232-47604ba61b91}" label="RESERVOIR" filter="&quot;inp_type&quot; = ''RESERVOIR''" symbol="3"/>
      <rule key="{94b0034e-0a9b-4f1d-8106-89f9c21ceea8}" label="SHORTPIPE" filter="&quot;inp_type&quot; = ''SHORTPIPE''" symbol="4"/>
      <rule key="{13f589fe-67f6-446b-be88-4df0babdfbea}" label="VALVE" filter="&quot;inp_type&quot; = ''VALVE''" symbol="5"/>
      <rule key="{741750ef-98a7-4e62-80ea-60d097569eba}" label="TANK" filter="&quot;inp_type&quot; = ''TANK''" symbol="6"/>
      <rule key="{ef7b5a46-8243-4258-b59b-6986e3ed00bd}" label="NOT USED" filter="&quot;inp_type&quot; IS NULL" symbol="7"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="5,163,242,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="83,83,83,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="FontMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="P" name="chr" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="MS Shell Dlg 2" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="2.88" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="44,171,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="4" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="5" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.2" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="2.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,0,0,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="0.56875" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="6" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="7" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="215,215,215,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="215,215,215,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE styleconfig_id=102 and layername='v_edit_node';


UPDATE config_function
	SET "style"='{"style": {"point": {"style": "qml", "id": "103"}}}'::json
	WHERE id=3302;

UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml", "id":"105"},  "line":{"style":"qml", "id":"105"}, "polygon":{"style":"qml", "id":"105"}}}'::json
	WHERE id=2244;

UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml", "id":"104"}, "line":{"style":"qml", "id":"104"}}}'::json
	WHERE id=2848;

UPDATE sys_style SET stylevalue = '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.28.4-Firenze">
  <renderer-v2 referencescale="-1" enableorderby="0" forceraster="0" type="RuleRenderer" symbollevels="0">
    <rules key="{f9bd1dda-e8cb-4456-b498-a3f1312029f9}">
      <rule symbol="0" key="{d0729bdd-7dcb-4e5d-9962-cd92c35d405e}" label="Wtp" filter="&quot;sys_type&quot; = ''WTP''" scalemaxdenom="25000"/>
      <rule symbol="1" key="{2ecb80ea-9da6-4533-aad0-7275c5a08550}" label="Waterwell" filter="&quot;sys_type&quot; = ''WATERWELL''" scalemaxdenom="25000"/>
      <rule symbol="2" key="{88ef1cea-1727-4681-9d7e-964bcfee179f}" label="Source" filter="&quot;sys_type&quot; = ''SOURCE''" scalemaxdenom="25000"/>
      <rule symbol="3" key="{5d885b4a-fd95-42b2-8da9-717face5a272}" label="Tank" filter="&quot;sys_type&quot; = ''TANK''" scalemaxdenom="25000"/>
      <rule symbol="4" key="{eed06555-2d38-4bfe-b114-13e014b63af1}" label="Expantank" filter="&quot;sys_type&quot; = ''EXPANSIONTANK''" scalemaxdenom="10000"/>
      <rule symbol="5" key="{d2138541-5cb8-4896-b97e-494fa6df6d40}" label="Filter" filter="&quot;sys_type&quot; = ''FILTER''" scalemaxdenom="10000"/>
      <rule symbol="6" key="{9f0ffeda-84af-4676-9263-119eb6042786}" label="Flexunion" filter="&quot;sys_type&quot; = ''FLEXUNION''" scalemaxdenom="10000"/>
      <rule symbol="7" key="{bfe404fe-23c9-4c26-a91e-bc5e89b7203b}" label="Hydrant" filter="&quot;sys_type&quot; = ''HYDRANT''" scalemaxdenom="10000"/>
      <rule symbol="8" key="{70f23680-8f8d-4eb8-ad9d-b6c222b1359a}" label="Meter" filter="&quot;sys_type&quot; = ''METER''" scalemaxdenom="10000"/>
      <rule symbol="9" key="{086f2a29-0a69-4a25-9b96-9f5d9f2955c1}" label="Netelement" filter="&quot;sys_type&quot; = ''NETELEMENT''" scalemaxdenom="10000"/>
      <rule symbol="10" key="{c0f1b0c8-34ee-4ec4-a914-97824ad2c467}" label="Netsamplepoint" filter="&quot;sys_type&quot; = ''NETSAMPLEPOINT''" scalemaxdenom="10000"/>
      <rule symbol="11" key="{01479095-8f9e-40cf-b92b-6e13874561ae}" label="Pump" filter="&quot;sys_type&quot; = ''PUMP''" scalemaxdenom="10000"/>
      <rule symbol="12" key="{8e1a0afb-c274-48ae-95a9-9c35583776c7}" label="Register" filter="&quot;sys_type&quot; = ''REGISTER''" scalemaxdenom="10000"/>
      <rule symbol="13" key="{118313b2-195c-4998-a2e3-965b368f9482}" label="Manhole" filter="&quot;sys_type&quot; = ''MANHOLE''" scalemaxdenom="10000"/>
      <rule symbol="14" key="{94bc6268-f342-4b79-a7f0-d8ba6498eb62}" label="Reduction" filter="&quot;sys_type&quot; = ''REDUCTION''" scalemaxdenom="10000"/>
      <rule symbol="15" key="{4006148d-3986-44fc-b269-0707485e9bd0}" label="Junction" filter="&quot;sys_type&quot; = ''JUNCTION''" scalemaxdenom="5000"/>
      <rule symbol="16" key="{2efa5954-7163-4c85-b608-6e6326bf4b5b}" label="Netwjoin" filter="&quot;sys_type&quot; = ''NETWJOIN''" scalemaxdenom="10000"/>
      <rule symbol="17" key="{d6c2b118-3f7e-4809-a8e8-e6857e5a3f87}" label="Valve Open" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  false or  &quot;closed_valve&quot; =  NULL )" scalemaxdenom="10000"/>
      <rule symbol="18" key="{82481050-9411-4920-bf5b-aa8cde85e324}" label="Valve Closed" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  true )" scalemaxdenom="10000"/>
    </rules>
    <symbols>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="0" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="50,48,55,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.36999999999999994"/>
                      <Option name="maxSize" type="double" value="2"/>
                      <Option name="maxValue" type="double" value="25000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="W"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value="Normal"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0.20000000000000001,-0.20000000000000001"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="1" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,127,0,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.36999999999999994"/>
                      <Option name="maxSize" type="double" value="2"/>
                      <Option name="maxValue" type="double" value="25000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="W"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0.20000000000000001,-0.20000000000000001"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="10" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="0,100,200,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="square"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="3"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="4.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="S"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="2.5"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.0666667*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.833333*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="11" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,127,0,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="P"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="12" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="32,10,129,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="R"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="13" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="166,206,227,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="M"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="14" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="237,183,25,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="R"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="15" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="0,242,255,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="50,48,55,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="1.8"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="1"/>
                      <Option name="maxValue" type="double" value="5000"/>
                      <Option name="minSize" type="double" value="2"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="16" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="70,151,75,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="3.75"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.75*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="cross"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="5"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="17" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="31,120,180,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" type="bool" value="false"/>
                  <Option name="field" type="QString" value="rotation"/>
                  <Option name="type" type="int" value="2"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="V"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" type="bool" value="false"/>
                  <Option name="field" type="QString" value="rotation"/>
                  <Option name="type" type="int" value="2"/>
                </Option>
                <Option name="char" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="18" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="199,28,31,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="V"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="char" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="2" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="35,200,120,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.36999999999999994"/>
                      <Option name="maxSize" type="double" value="2"/>
                      <Option name="maxValue" type="double" value="25000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="S"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0.20000000000000001,-0.20000000000000001"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="3" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="26,115,162,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.37"/>
                      <Option name="maxSize" type="double" value="2"/>
                      <Option name="maxValue" type="double" value="25000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="D"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0.20000000000000001,-0.20000000000000001"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="4" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="25,237,206,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="E"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="5" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="251,154,153,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="F"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="6" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="191,246,61,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="F"/>
            <Option name="color" type="QString" value="0,0,0,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="7" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="249,53,57,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="square"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" type="bool" value="false"/>
                  <Option name="field" type="QString" value="rotation"/>
                  <Option name="type" type="int" value="2"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="4.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="H"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,-0.00000000000000006"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" type="bool" value="false"/>
                  <Option name="field" type="QString" value="rotation"/>
                  <Option name="type" type="int" value="2"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0)))|| '','' || ''0''"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="8" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="133,133,133,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="M"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="9" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="129,10,78,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,0"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="var(''map_scale'')"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" type="double" value="0.52"/>
                      <Option name="maxSize" type="double" value="0.7"/>
                      <Option name="maxValue" type="double" value="10000"/>
                      <Option name="minSize" type="double" value="5.5"/>
                      <Option name="minValue" type="double" value="0"/>
                      <Option name="nullSize" type="double" value="0"/>
                      <Option name="scaleType" type="int" value="3"/>
                    </Option>
                    <Option name="t" type="int" value="1"/>
                  </Option>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="FontMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="E"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value=""/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="255,255,255,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3.2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" type="bool" value="true"/>
                  <Option name="expression" type="QString" value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>' WHERE layername = 'v_edit_node' AND styleconfig_id = 101;

ALTER TABLE presszone DROP CONSTRAINT IF EXISTS presszone_presszone_type_check;
ALTER TABLE sys_style ADD CONSTRAINT sys_style_pkey PRIMARY KEY (layername, styleconfig_id);
ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;

ALTER TABLE element ADD CONSTRAINT element_brand_id FOREIGN KEY (brand_id) references cat_brand(id);
ALTER TABLE element ADD CONSTRAINT element_model_id FOREIGN KEY (model_id) references cat_brand_model(id);



DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        ALTER TABLE pond ADD CONSTRAINT pond_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE "pool" ADD CONSTRAINT pool_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
    ELSE
        ALTER TABLE pond ADD CONSTRAINT pond_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE "pool" ADD CONSTRAINT pool_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
    END IF;
END; $$;

CREATE TRIGGER gw_trg_ui_rpt_cat_result
INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();


CREATE TRIGGER gw_trg_edit_minsector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_minsector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('element');

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_samplepoint
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_edit_streetaxis INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_streetaxis
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_streetaxis();

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_arc');

CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_dscenario_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualpump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PIPE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALVALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALPUMP');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_register
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_register_pol');

CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_fountain
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol('man_fountain_pol');

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump_additional');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP_ADDITIONAL');

CREATE TRIGGER gw_trg_edit_inp_dscenario_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('SHORTPIPE');

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pipe');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_inp_dscenario_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TANK');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_tank');

CREATE TRIGGER gw_trg_edit_inp_dscenario_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('RESERVOIR');

CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_reservoir');

CREATE TRIGGER gw_trg_edit_inp_dscenario_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VALVE');

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_valve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualvalve INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_virtualvalve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('virtualvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_shorpipe INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_shortpipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_valve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('valve');

CREATE TRIGGER gw_trg_edit_ve_epa_inlet INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_inlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('inlet');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_link();

CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('dma');

CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_presszone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone();

CREATE TRIGGER gw_trg_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_dqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa();

CREATE TRIGGER gw_trg_edit_address INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_address
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_address();
