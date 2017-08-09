/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- System tables
-- ----------------------------

CREATE TABLE om_visit_cat(
id serial NOT NULL,
name character varying (30),
type character varying (18),
startdate date DEFAULT now(),
enddate date,
descript text,
CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_parameter_type" (
"id" varchar(50)   NOT NULL,
"form_type" int2,
"descript" varchar(100),
CONSTRAINT om_visit_parameter_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_parameter" (
"id" varchar(50)   NOT NULL,
"code" varchar (30),
"parameter_type" varchar(30) ,
"featurecat_id" varchar(30) ,
"data_type" varchar(16) ,
"criticity" int2,
"descript" varchar(100),
CONSTRAINT om_visit_parameter_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit" (
"id" serial8 NOT NULL,
"visitcat_id" integer,
"ext_code" varchar (30),
"startdate" timestamp(6) WITHOUT TIME ZONE DEFAULT now() ,
"enddate" timestamp(6) WITHOUT TIME ZONE,
"user_name" varchar(50) DEFAULT user,
"webclient_id" character varying(50),
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT om_visit_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_event" (
"id" serial8 NOT NULL,
"ext_code" varchar(16),
"visit_id" int8 NOT NULL,
"position_id" varchar(50),
"position_value" float,
"parameter_id" varchar(50)  ,
"value" text,
"value1" integer,
"value2" integer,
"geom1" float,
"geom2" float,
"geom3" float,
"xcoord" float,
"ycoord" float,
"compass" float,
"tstamp" timestamp(6) WITHOUT TIME ZONE DEFAULT now(),
"status" float,
CONSTRAINT om_visit_event_pkey PRIMARY KEY (id)
);

 
CREATE TABLE om_visit_event_photo(
id serial NOT NULL,
visit_id bigint NOT NULL,
event_id bigint NOT NULL,
tstamp timestamp(6) without time zone DEFAULT now(),
value text,
text text,
compass double precision,
CONSTRAINT om_visit_event_foto_pkey PRIMARY KEY (id),
CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)
 REFERENCES om_visit_event (id) MATCH SIMPLE
 ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)
 REFERENCES om_visit (id) MATCH SIMPLE
 ON UPDATE CASCADE ON DELETE RESTRICT
);

-----------
-- VALUES
-----------

CREATE TABLE "om_visit_value_position" (
"id" varchar(50)   NOT NULL,
"feature" varchar(30) ,
"descript" varchar(50) ,
CONSTRAINT om_visit_value_position_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_value_parameter_type"(
id character varying(16),
obs text,
CONSTRAINT om_visit_value_context_pkey PRIMARY KEY (id)
);


 CREATE TABLE "om_visit_value_criticity"(
id int2,
obs text,
CONSTRAINT om_visit_value_criticity_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_x_node" (
"id" serial8 NOT NULL,
"visit_id" int8,
"node_id" varchar (16),
CONSTRAINT om_visit_x_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "om_visit_x_arc" (
"id" serial8 NOT NULL,
"visit_id" int8,
"arc_id" varchar (16),
CONSTRAINT om_visit_x_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "om_visit_x_connec" (
"id" serial8 NOT NULL,
"visit_id" int8,
"connec_id" varchar (16),
CONSTRAINT om_visit_x_connec_pkey PRIMARY KEY (id)
);

CREATE INDEX visit_index ON om_visit USING GIST (the_geom);