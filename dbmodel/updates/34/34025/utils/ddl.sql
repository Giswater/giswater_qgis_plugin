/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
ALTER TABLE IF EXISTS ext_cat_scada RENAME TO _ext_cat_scada_;
ALTER TABLE IF EXISTS ext_rtc_scada RENAME TO _ext_rtc_scada_;


CREATE TABLE IF NOT EXISTS ext_arc(
  id serial8 PRIMARY KEY,
  fid int4, 
  arc_id varchar(16),
  val float,
  tstamp timestamp,
  observ text,
  cur_user text);


CREATE TABLE IF NOT EXISTS ext_node(
  id serial8 PRIMARY KEY,
  fid int4, 
  node_id varchar(16),
  val float,
  tstamp timestamp,
  observ text,
  cur_user text);



-- 2020/12/03
ALTER TABLE cat_feature ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_arc ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_node ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_connec ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_element ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_users ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE exploitation ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE sys_addfields ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE sys_style ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_arc_shape ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE IF EXISTS ext_municipality ALTER COLUMN active SET DEFAULT TRUE;
