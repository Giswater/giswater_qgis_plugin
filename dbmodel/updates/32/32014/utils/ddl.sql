/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE plan_psector ADD COLUMN status integer;

ALTER TABLE anl_mincut_inlet_x_exploitation ADD COLUMN to_arc json;


CREATE TABLE anl_graf (
id SERIAL primary key,
grafclass varchar(16),
arc_id varchar(16),
node_1 varchar(16),
node_2 varchar(16),
water int2, 
flag int2,
checkf int2,
user_name text);

ALTER TABLE node_type ADD column graf_delimiter varchar(20);


CREATE TABLE plan_typevalue(
  typevalue text NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  addparam json,
  CONSTRAINT plan_typevalue_pkey PRIMARY KEY (typevalue, id));

CREATE TABLE om_typevalue(
  typevalue text NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  addparam json,
  CONSTRAINT om_typevalue_pkey PRIMARY KEY (typevalue, id));
  
 
ALTER TABLE cat_arc ALTER COLUMN id DROP DEFAULT;
ALTER TABLE cat_node ALTER COLUMN id DROP DEFAULT;

ALTER TABLE sector ADD COLUMN nodeparent json;
ALTER TABLE dma ADD COLUMN nodeparent json;
ALTER TABLE cat_presszone ADD COLUMN nodeparent json;

CREATE TABLE dqa (
 dqa_id serial PRIMARY KEY,
 name character varying(30),
 expl_id integer,
 macroqma_id integer,
 descript text,
 undelete boolean,
 the_geom geometry(MultiPolygon,25831),
 pattern_id character varying(16),
 nodeparent json,
 link text);