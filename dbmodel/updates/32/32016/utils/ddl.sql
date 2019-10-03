/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_controls_x_arc", "column":"active", "dataType":"boolean"}}$$);

ALTER TABLE temp_table ADD COLUMN addparam json;

CREATE TABLE IF NOT EXISTS ext_timeseries (
  id serial PRIMARY KEY,
  code text,
  operator_id integer,
  catalog_id text,
  element json,
  param json,  
  period json,
  timestep json,
  val double precision[],
  descript text); 
 
COMMENT ON TABLE ext_timeseries IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
code: external code or internal identifier....
operator_id, to indetify different operators
catalog_id, imdp, t15, t85, fireindex, sworksindex, treeindex, qualhead, pressure, flow, inflow
element, {"type":"exploitation", 
	    "id":[1,2,3,4]} -- expl_id, muni_id, arc_id, node_id, dma_id, sector_id, dqa_id
param, {"isUnitary":false, it means if sumatory of all values of ts is 1 (true) or not
	"units":"BAR"  in case of no units put any value you want (adimensional, nounits...). WARNING: use CMH or LPS in case of VOLUME patterns for EPANET
 	"epa":{"projectType":"WS", "class":"pattern", "id":"test1", "type":"UNITARY", "dmaRtcParameters":{"dmaId":"", "periodId":""} 
		If this timeseries is used for EPA, please fill this projectType and PatterType. Use ''UNITARY'', for sum of values = 1 or ''VOLUME'', when are real volume values
			If pattern is related to dma x rtc period please fill dmaRtcParameters parameters
	"source":{"type":"flowmeter", "id":"V2323", "import":{"type":"file", "id":"test.csv"}},
period {"type":"monthly", "id":201903", "start":"2019-01-01", "end":"2019-01-02"} 
timestep {"units":"minute", "value":"15", "number":2345}};
val, {1,2,3,4,5,6}
descript text';

   
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_arc", "column":"addparam", "dataType":"json"}}$$);

CREATE TABLE ext_workorder_class(
  id character varying(50) PRIMARY KEY NOT NULL,
  idval character varying(50));

CREATE TABLE ext_workorder_type(
  id character varying(50) PRIMARY KEY NOT NULL,
  idval character varying(50),
  class_id character varying(50));
  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_class", "column":"param_options", "dataType":"json"}}$$);

CREATE TABLE om_visit_class_x_wo(
  id serial PRIMARY KEY NOT NULL,
  visitclass_id integer,
  wotype_id character varying(50));
  
CREATE TABLE ext_workorder(
	class_id integer PRIMARY KEY,
	class_name character varying(50),
	exercice integer,
	serie character varying(10),
	number integer,
	startdate date,
	address character varying(50),
	wotype_id character varying(50),
	visitclass_id integer,
    wotype_name character varying(120),
	cost numeric,
	ct text
);
	
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"publish", "dataType":"boolean"}}$$);


CREATE TABLE typevalue_fk(
  id serial NOT NULL  PRIMARY KEY,
  typevalue_table character varying(50),
  typevalue_name character varying(50),
  target_table character varying(50),
  target_field character varying(50),
  parameter_id integer
);

CREATE TABLE sys_typevalue_cat(
	id serial NOT NULL PRIMARY KEY,
	typevalue_table character varying(50),
	typevalue_name character varying(50)
);

ALTER TABLE audit_cat_table ADD COLUMN notify_action json;

--2019/09/02
ALTER TABLE inp_options RENAME TO _inp_options_;
ALTER TABLE om_psector RENAME TO _om_psector_;
ALTER TABLE om_psector_cat_type RENAME TO _om_psector_cat_type_;
ALTER TABLE om_psector_selector RENAME TO _om_psector_selector_;
ALTER TABLE om_psector_x_arc RENAME TO _om_psector_x_arc_;
ALTER TABLE om_psector_x_node RENAME TO _om_psector_x_node_;
ALTER TABLE om_psector_x_other RENAME TO _om_psector_x_other_;


CREATE TABLE cat_manager
(
  id serial NOT NULL PRIMARY KEY,
  idval text,
  expl_id integer[],
  username text[],
  active boolean DEFAULT true);
  
  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation_x_user", "column":"manager_id", "dataType":"integer"}}$$);

CREATE TABLE ext_cat_vehicle(
	id character varying(50) NOT NULL PRIMARY KEY,
	idval character varying(50),
	descript character varying(50)
);

CREATE TABLE om_vehicle_x_parameters(
	id serial NOT NULL PRIMARY KEY,
	vehicle_id character varying(50),
    lot_id integer,
    team_id integer,
    image text,
    load character varying(50),
    cur_user character varying(50) DEFAULT current_user,
	tstamp timestamp without time zone
);

CREATE TABLE om_team_x_vehicle(
	id serial NOT NULL PRIMARY KEY,
	team_id integer,
	vehicle_id character varying(50)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_users", "column":"sys_role", "dataType":"varchar(30)"}}$$);


