/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;





-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------
CREATE SEQUENCE "anl_mincut_result_cat_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE SEQUENCE anl_mincut_result_polygon_polygon_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
	CACHE 1;





-- ----------------------------
-- MINCUT
-- ----------------------------

CREATE TABLE anl_mincut_arc_x_node
(
  arc_id varchar(16) NOT NULL,
  node_id varchar(16) NOT NULL,
  user_name varchar(50) NOT NULL,
  node_type varchar(16),
  node_id_a varchar(16),
  node_type_a varchar(16),
  water integer,
  flag1 integer,
  CONSTRAINT anl_mincut_arc_x_node_pkey PRIMARY KEY (arc_id, node_id, user_name)
);



CREATE TABLE "anl_mincut_result_cat" (
id integer DEFAULT nextval('"SCHEMA_NAME".anl_mincut_result_cat_seq'::regclass) NOT NULL PRIMARY KEY,
work_order character varying (50),
mincut_state int2,
mincut_class int2,
mincut_type varchar (30),
received_date date,
expl_id integer,
macroexpl_id integer,
muni_id integer,
postcode character varying (16),
streetaxis_id character varying (250),
postnumber  character varying (16),
anl_cause character varying (30),
anl_tstamp timestamp default now(),
anl_user varchar(30),
anl_descript text,
anl_feature_id varchar(16),
anl_feature_type varchar(16),
anl_the_geom public.geometry(POINT, SRID_VALUE),
forecast_start timestamp,
forecast_end timestamp,
assigned_to varchar(50),
exec_start timestamp,
exec_end timestamp,
exec_user varchar(30),
exec_descript text,
exec_the_geom public.geometry(POINT, SRID_VALUE),
exec_from_plot float,
exec_depth float,
exec_appropiate boolean
);


CREATE TABLE "anl_mincut_result_polygon" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
polygon_id varchar (16),
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE)
);


CREATE TABLE "anl_mincut_result_node" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
node_id varchar (16),
the_geom public.geometry (POINT, SRID_VALUE)
);


CREATE TABLE "anl_mincut_result_arc" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
arc_id varchar (16),
the_geom public.geometry (LINESTRING, SRID_VALUE)
);



CREATE TABLE IF NOT EXISTS "anl_mincut_result_connec" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
connec_id character varying(16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_hydrometer" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
hydrometer_id character varying(16) NOT NULL
);


CREATE TABLE "anl_mincut_result_valve_unaccess"(
id serial NOT NULL PRIMARY KEY,
result_id integer,
node_id character varying(16) NOT NULL
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_valve" (
id serial NOT NULL PRIMARY KEY,
result_id integer,
node_id character varying(16),
closed boolean,
broken boolean,
unaccess boolean,
proposed boolean,
the_geom public.geometry (POINT, SRID_VALUE)
);



CREATE TABLE anl_mincut_inlet_x_exploitation(
  id serial PRIMARY KEY,
  node_id varchar (16),
  expl_id integer
  );


  
-- ----------------------------
-- DVALUES
-- ----------------------------

CREATE TABLE "anl_mincut_cat_state" (
id int2 NOT NULL PRIMARY KEY,
name text,
descript text
);


CREATE TABLE "anl_mincut_cat_class" (
id int2 NOT NULL PRIMARY KEY,
name text,
descript text
);


CREATE TABLE "anl_mincut_cat_type" (
id varchar(30) NOT NULL PRIMARY KEY,
virtual boolean DEFAULT true NOT NULL,
descript text
);


CREATE TABLE "anl_mincut_cat_cause" (
id varchar(30) NOT NULL PRIMARY KEY,
descript text
);



-- ----------------------------
-- SELECTOR
-- ----------------------------


CREATE TABLE "anl_mincut_result_selector" (
"id" SERIAL PRIMARY KEY,
"result_id" integer,
"cur_user" text
);


CREATE TABLE "anl_mincut_selector_valve" (
"id" varchar(50) NOT NULL PRIMARY KEY
);




CREATE INDEX mincut_polygon_index ON "anl_mincut_result_polygon" USING GIST (the_geom);
CREATE INDEX mincut_node_index ON "anl_mincut_result_node" USING GIST (the_geom);
CREATE INDEX mincut_arc_index ON "anl_mincut_result_arc" USING GIST (the_geom);
CREATE INDEX mincut_valve_index ON "anl_mincut_result_valve" USING GIST (the_geom);


