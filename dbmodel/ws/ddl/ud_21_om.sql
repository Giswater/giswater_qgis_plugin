/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- System tables
-- ----------------------------



CREATE TABLE om_visit_cat
(
  id serial NOT NULL,
  type character varying (18),
  short_des character varying (30),
  descript text,
  startdate date DEFAULT now(),
  enddate date,
  CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id)
);


 
CREATE TABLE "om_visit_parameter_type" (
"id" varchar(30)   NOT NULL,
"observ" varchar(255)   NOT NULL,
CONSTRAINT om_visit_parameter_type_pkey PRIMARY KEY (id)
) ;


CREATE TABLE "om_visit_parameter" (
"id" varchar(50)   NOT NULL,
"parameter_type" varchar(30) ,
"feature" varchar(30) ,
"data_type" varchar(16) ,
"descript" varchar(100) ,
CONSTRAINT om_visit_parameter_pkey PRIMARY KEY (id)
);

CREATE TABLE "om_visit_value_position" (
"id" varchar(50)   NOT NULL,
"feature" varchar(30) ,
"descript" varchar(50) ,
CONSTRAINT om_visit_value_position_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit" (
"id" serial8 NOT NULL,
"visitcat_id" integer,
"dma_id" integer,
"startdate" timestamp(6) WITHOUT TIME ZONE DEFAULT now() ,
"enddate" timestamp(6) WITHOUT TIME ZONE,
"user_name" varchar(50) DEFAULT user,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT om_visit_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_event" (
"id" serial8 NOT NULL,
"visit_id" int8 NOT NULL,
"tstamp" timestamp(6) WITHOUT TIME ZONE DEFAULT now(),
"parameter_id" varchar(50)  ,
"value" text,
"text" text,
"position_id" varchar(50),
"xcoord" float,
"ycoord" float,
"compass" float,
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


ALTER TABLE om_visit DROP CONSTRAINT IF EXISTS "om_visit_om_visit_cat_id_fkey";
ALTER TABLE om_visit   ADD CONSTRAINT om_visit_om_visit_cat_id_fkey FOREIGN KEY (visitcat_id) REFERENCES om_visit_cat (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;




CREATE INDEX visit_index ON om_visit USING GIST (the_geom);