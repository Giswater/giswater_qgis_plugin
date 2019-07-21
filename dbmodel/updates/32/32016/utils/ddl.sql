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
  timeseries -- imdp, t15, t85, fireindex, sworksindex, treeindex, qualhead, pressure, flow, inflow
  sysclass varchar(16),
  sys_id varchar(16),
  tparam json,  -- {"type":"monthly", "seconds":2345, "tsteps":24, "start":"2019-01-01", "end":"2019-01-02", "units":"mca"};
  tvalues json); -- {[1,2,3,4,5,6]};