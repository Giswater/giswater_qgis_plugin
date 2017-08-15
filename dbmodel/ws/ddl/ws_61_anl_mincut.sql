/*
This file is part of Giswater 2.0
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





-- ----------------------------
-- MINCUT
-- ----------------------------


CREATE TABLE "anl_mincut_result_cat" (
id varchar (30) DEFAULT nextval('"SCHEMA_NAME".anl_mincut_result_cat_seq'::regclass) NOT NULL,
mincut_state int2,
mincut_class int2,
mincut_type varchar (30),
received_date date,
expl_id integer,
address_1 character varying (250),
address_2 character varying (250),
anl_cause character varying (30),
anl_tstamp timestamp default now(),
anl_user varchar(30),
anl_descript text,
anl_the_geom public.geometry(POINT, SRID_VALUE),
forecast_start timestamp,
forecast_end timestamp,
exec_start timestamp,
exec_end timestamp,
exec_user varchar(30),
exec_descript text,
exec_the_geom public.geometry(POINT, SRID_VALUE),
exec_from_plot float,
exec_depth float,
exec_appropiate boolean,	
CONSTRAINT mincut_result_cat_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_polygon" (
id serial NOT NULL,
result_id varchar (30),
polygon_id varchar (16),
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT anl_mincut_result_polygon_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_node" (
id serial NOT NULL,
result_id varchar (30),
node_id varchar (16),
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_result_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_arc" (
id serial NOT NULL,
result_id varchar (30),
arc_id varchar (16),
the_geom public.geometry (LINESTRING, SRID_VALUE)
CONSTRAINT anl_mincut_result_arc_pkey PRIMARY KEY (id)
);



CREATE TABLE IF NOT EXISTS "anl_mincut_result_connec" (
id serial NOT NULL,
result_id varchar (30),
connec_id character varying(16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_result_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_hydrometer" (
id serial NOT NULL,
result_id varchar (30),
hydrometer_id character varying(16) NOT NULL,
CONSTRAINT anl_mincut_result_hydrometer_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_result_valve_unaccess"(
id serial NOT NULL PRIMARY KEY,
result_id character varying(16) NOT NULL,
node_id character varying(16) NOT NULL
);


CREATE TABLE IF NOT EXISTS "anl_mincut_result_valve" (
id serial NOT NULL,
result_id varchar (30),
node_id character varying(16),
closed boolean,
broken boolean,
unaccess boolean,
proposed boolean,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_result_valve_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- DVALUES
-- ----------------------------



CREATE TABLE "anl_mincut_cat_state" (
id int2 NOT NULL PRIMARY KEY,
name text,
descript text
);


CREATE TABLE "anl_mincut_cat_type" (
id int2 NOT NULL PRIMARY KEY,
name text,
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
"id" varchar (16) NOT NULL DEFAULT nextval('anl_mincut_result_selector_seq'::regclass),
"result_id" varchar (30),
"cur_user" text,
CONSTRAINT anl_mincut_result_selector_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_mincut_selector_valve" (
"id" varchar(50) NOT NULL PRIMARY KEY
);




CREATE INDEX mincut_polygon_index ON "anl_mincut_result_polygon" USING GIST (the_geom);
CREATE INDEX mincut_node_index ON "anl_mincut_result_node" USING GIST (the_geom);
CREATE INDEX mincut_arc_index ON "anl_mincut_result_arc" USING GIST (the_geom);
CREATE INDEX mincut_valve_index ON "anl_mincut_result_valve" USING GIST (the_geom);


