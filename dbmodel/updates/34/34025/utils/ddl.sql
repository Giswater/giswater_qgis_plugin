/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
ALTER TABLE ext_cat_scada RENAME TO _ext_cat_scada_;
ALTER TABLE ext_rtc_scada RENAME TO _ext_rtc_scada_;


CREATE TABLE ext_arc(
  id serial8 PRIMARY KEY,
  fid int4, 
  arc_id varchar(16),
  val float,
  tstamp timestamp,
  observ text,
  cur_user text);


CREATE TABLE ext_node(
  id serial8 PRIMARY KEY,
  fid int4, 
  node_id varchar(16),
  val float,
  tstamp timestamp,
  observ text,
  cur_user text);