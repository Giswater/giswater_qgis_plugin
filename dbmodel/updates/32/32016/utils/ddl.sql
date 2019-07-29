/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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
	cost numeric,
	ct text
);
	