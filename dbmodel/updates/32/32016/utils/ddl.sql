/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE TABLE IF NOT EXISTS ext_timeseries (
  id serial PRIMARY KEY,
  operator_id integer,
  period_id integer,
  timeseries text,-- imdp, t15, t85, fireindex, sworksindex, treeindex, qualhead, pressure, flow, inflow
  sysclass varchar(16),
  sys_id varchar(16),
  tparam json,  -- {"type":"monthly", "seconds":2345, "tsteps":24, "start":"2019-01-01", "end":"2019-01-02", "units":"mca"};
  tvalues json); -- {[1,2,3,4,5,6]};
  
  
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