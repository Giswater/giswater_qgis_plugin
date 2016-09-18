/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- MINCUT
-- ----------------------------

CREATE TABLE "anl_mincut_polygon" (
polygon_id varchar (16) NOT NULL,
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT mincut_polygon_pkey PRIMARY KEY (polygon_id)
);


CREATE TABLE "anl_mincut_node" (
node_id varchar (16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_mincut_arc" (
arc_id varchar (16) NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT anl_mincut_arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_valve" (
valve_id character varying(16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_valve_pkey PRIMARY KEY (valve_id)
);



CREATE INDEX mincut_polygon_index ON "anl_mincut_polygon" USING GIST (the_geom);
CREATE INDEX mincut_node_index ON "anl_mincut_node" USING GIST (the_geom);
CREATE INDEX mincut_arc_index ON "anl_mincut_arc" USING GIST (the_geom);
CREATE INDEX mincut_valve_index ON "anl_mincut_valve" USING GIST (the_geom);




-- ----------------------------
-- MINCUT RESULT CATALOG
-- ----------------------------


CREATE SEQUENCE "anl_mincut_result_cat_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE "anl_mincut_result_cat_type" (
id varchar(30) NOT NULL,
descript text,
CONSTRAINT mincut_result_cat_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_cat_state" (
id varchar(30) NOT NULL,
descript text,
CONSTRAINT mincut_result_cat_state_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_cat" (
id varchar (30) DEFAULT nextval('"SCHEMA_NAME".anl_mincut_result_cat_seq'::regclass) NOT NULL,
mincut_result_type varchar(30),
mincut_result_state varchar (30),
anl_tstamp timestamp default now(),
anl_user varchar(30),
anl_descript text,
exec_forecast_date date,
exec_start timestamp,
exec_end timestamp,
exec_user varchar(30),
exec_descript text, 
CONSTRAINT mincut_result_cat_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_polygon" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
polygon_id varchar (16),
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT anl_mincut_result_polygon_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_node" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
node_id varchar (16),
CONSTRAINT anl_mincut_result_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_arc" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
arc_id varchar (16),
CONSTRAINT anl_mincut_result_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_valve" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
valve_id character varying(16),
CONSTRAINT anl_mincut_result_valve_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_connec" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
connec_id character varying(16) NOT NULL,
CONSTRAINT anl_mincut_result_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_hydrometer" (
id serial NOT NULL,
mincut_result_cat_id varchar (30),
hydrometer_id character varying(16) NOT NULL,
CONSTRAINT anl_mincut_result_hydrometer_pkey PRIMARY KEY (id)
);



CREATE TABLE "anl_mincut_result_selector" (
id varchar (30),
CONSTRAINT mincut_result_selector_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_selector_compare" (
id varchar (30),
CONSTRAINT mincut_result_selector_compare_pkey PRIMARY KEY (id)
);


