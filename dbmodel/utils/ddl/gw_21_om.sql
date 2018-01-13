/*
This file is part of Giswater 3
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
visit_type character varying (18),
startdate date DEFAULT now(),
enddate date,
descript text,
active boolean,
CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_parameter_form_type" (
"id" varchar(50)   NOT NULL PRIMARY KEY
);


CREATE TABLE "om_visit_parameter" (
"id" varchar(50)   NOT NULL,
"code" varchar (30),
"parameter_type" varchar(30) ,
"feature_type" varchar(30) ,
"data_type" varchar(16) ,
"criticity" int2,
"descript" varchar(100),
"form_type" varchar (30),
"vdefault" text,
CONSTRAINT om_visit_parameter_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_parameter_index" (
"id" serial8 PRIMARY KEY NOT NULL,
"parameter_id" varchar(50),
"numval_from" float, 
"numval_to" float,
"text_val" text,
"bool_val" boolean,
"index_val" int2
);


CREATE TABLE "om_visit_parameter_x_reverse" (
"id" serial8 PRIMARY KEY NOT NULL,
"parameter_id" varchar(50),
"parameter_rev" varchar(50),
"rev_value" text
);


CREATE TABLE "om_visit" (
"id" serial8 NOT NULL,
"visitcat_id" integer,
"ext_code" varchar (30),
"startdate" timestamp(6) WITHOUT TIME ZONE DEFAULT now() ,
"enddate" timestamp(6) WITHOUT TIME ZONE DEFAULT now() ,
"user_name" varchar(50) DEFAULT user,
"webclient_id" character varying(50),
"expl_id" integer,
"the_geom" public.geometry (POINT, SRID_VALUE),
"descript" text,
"is_done" boolean,
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
"text" text,
"index_val" int2,
"is_last" boolean,
CONSTRAINT om_visit_event_pkey PRIMARY KEY (id)
);

 
CREATE TABLE om_visit_event_photo(
id serial NOT NULL PRIMARY KEY,
visit_id bigint NOT NULL,
event_id bigint NOT NULL,
tstamp timestamp(6) without time zone DEFAULT now(),
value text,
text text,
compass double precision
);

-----------
-- VALUES
-----------



CREATE TABLE "om_visit_parameter_type"(
id character varying(30),
descript text,
go2plan boolean,
CONSTRAINT om_visit_value_context_pkey PRIMARY KEY (id)
);


 CREATE TABLE "om_visit_value_criticity"(
id int2,
descript text,
CONSTRAINT om_visit_value_criticity_pkey PRIMARY KEY (id)
);


CREATE TABLE "om_visit_x_node" (
"id" serial8 NOT NULL,
"visit_id" int8,
"node_id" varchar (16),
"is_last" boolean DEFAULT TRUE,
CONSTRAINT om_visit_x_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "om_visit_x_arc" (
"id" serial8 NOT NULL,
"visit_id" int8,
"arc_id" varchar (16),
"is_last" boolean DEFAULT TRUE,
CONSTRAINT om_visit_x_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "om_visit_x_connec" (
"id" serial8 NOT NULL,
"visit_id" int8,
"connec_id" varchar (16),
"is_last" boolean DEFAULT TRUE,
CONSTRAINT om_visit_x_connec_pkey PRIMARY KEY (id)
);

CREATE INDEX visit_index ON om_visit USING GIST (the_geom);