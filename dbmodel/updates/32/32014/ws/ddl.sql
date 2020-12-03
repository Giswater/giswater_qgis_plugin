/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER SEQUENCE anl_mincut_result_cat_seq MINVALUE -1;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_mincut_inlet_x_exploitation", "column":"to_arc", "dataType":"text[]"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_presszone", "column":"nodeparent", "dataType":"text[]"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_type", "column":"graf_delimiter", "dataType":"varchar(20)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"nodeparent", "dataType":"text[]"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"nodeparent", "dataType":"text[]"}}$$);


CREATE TABLE IF NOT EXISTS macrodqa(
  macrodqa_id serial PRIMARY KEY,
  name character varying(50) NOT NULL,
  expl_id integer NOT NULL,
  descript text,
  undelete boolean,
  the_geom geometry(MultiPolygon,SRID_VALUE));


CREATE TABLE IF NOT EXISTS dqa (
 dqa_id serial PRIMARY KEY,
 name character varying(30),
 expl_id integer,
 macrodqa_id integer,
 descript text,
 undelete boolean,
 the_geom geometry(MultiPolygon,SRID_VALUE),
 pattern_id character varying(16),
 nodeparent text[],
 dqa_type varchar(16),
 link text);
 
 
 CREATE TABLE IF NOT EXISTS anl_graf (
id SERIAL primary key,
grafclass varchar(16),
arc_id varchar(16),
node_1 varchar(16),
node_2 varchar(16),
water int2, 
flag int2,
checkf int2,
user_name text);

CREATE TABLE IF NOT EXISTS inp_connec (
"connec_id" varchar(16) PRIMARY KEY,
"demand" numeric(12,6),
"pattern_id" varchar(16)
);


