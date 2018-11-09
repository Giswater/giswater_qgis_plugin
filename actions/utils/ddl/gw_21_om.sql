/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Sequences
-- ----------------------------

CREATE SEQUENCE psector_psector_id_seq
  INCREMENT 1
  NO MINVALUE 
  NO MAXVALUE 
  START 1
  CACHE 1;

-- ----------------------------
-- System tables
-- ----------------------------

CREATE TABLE om_visit_cat(
id serial NOT NULL,
name character varying (30),
startdate date DEFAULT now(),
enddate date,
descript text,
active boolean default true,
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


CREATE TABLE "om_visit_parameter_x_parameter" (
"pxp_id" serial8 PRIMARY KEY NOT NULL,
"parameter_id1" varchar(50),
"parameter_id2" varchar(50),
"action_type" integer,
"action_value" text
);

CREATE TABLE "om_visit_parameter_cat_action" (
"id" integer PRIMARY KEY NOT NULL,
"action_name" text
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
"event_code" varchar(16),
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
id serial8 NOT NULL PRIMARY KEY,
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





CREATE TABLE "om_result_cat" (
"result_id" serial PRIMARY KEY,
"name" varchar (30),
"result_type" integer, 
"network_price_coeff" float,
"tstamp" timestamp default now(),
"cur_user" text,
"descript" text,
"pricecat_id" varchar(30)
);



CREATE TABLE "om_rec_result_node" (
"id" serial PRIMARY KEY,
"result_id" integer,
"node_id" varchar(16) ,
"node_type" varchar(18)  ,
"nodecat_id" varchar(30)  ,
"top_elev" numeric(12,3),
"elev" numeric(12,3),
"epa_type" varchar(16)  ,
"sector_id" integer,
"state" int2 ,
"annotation" character varying(254),
"the_geom" public.geometry (POINT, SRID_VALUE),
"cost_unit" varchar(3),
"descript" text,
"measurement" numeric(12,2),
"cost" numeric(12,3),
"budget" numeric(12,2),
"expl_id" integer
);



CREATE TABLE "om_rec_result_arc" (
"id" serial PRIMARY KEY,
"result_id" integer,
"arc_id" varchar(16) ,
"node_1" varchar(16) ,
"node_2" varchar(16) ,
"arc_type" varchar(18)  ,
"arccat_id" varchar(30)  ,
"epa_type" varchar(16)  ,
"sector_id" integer,
"state" int2,
"annotation" character varying(254),
"soilcat_id" varchar(30),
"y1" numeric(12,2),
"y2" numeric(12,2),
"mean_y" numeric(12,2),
"z1" numeric(12,2),
"z2" numeric(12,2),
"thickness" numeric(12,2),
"width" numeric(12,2),
"b" numeric(12,2),
"bulk" numeric(12,2),
"geom1" numeric(12,2),
"area" numeric(12,2),
"y_param" numeric(12,2),
"total_y" numeric(12,2),
"rec_y" numeric(12,2),
"geom1_ext" numeric(12,2),
"calculed_y" numeric(12,2),
"m3mlexc" numeric(12,2),
"m2mltrenchl" numeric(12,2),
"m2mlbottom" numeric(12,2),
"m2mlpav" numeric(12,2),
"m3mlprotec" numeric(12,2),
"m3mlfill" numeric(12,2),
"m3mlexcess" numeric(12,2),
"m3exc_cost" numeric(12,2),
"m2trenchl_cost" numeric(12,2),
"m2bottom_cost" numeric(12,2),
"m2pav_cost" numeric(12,2),
"m3protec_cost" numeric(12,2),
"m3fill_cost" numeric(12,2),
"m3excess_cost" numeric(12,2),
"cost_unit" varchar(16),
"pav_cost" numeric(12,2),
"exc_cost" numeric(12,2),
"trenchl_cost" numeric(12,2),
"base_cost" numeric(12,2),
"protec_cost" numeric(12,2),
"fill_cost" numeric(12,2),
"excess_cost" numeric(12,2),
"arc_cost" numeric(12,2),
"cost" numeric(12,2),
"length" numeric(12,3),
"budget" numeric(12,2),
"other_budget" numeric(12,2),
"total_budget" numeric(12,2),
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
"expl_id" integer
);




CREATE TABLE om_reh_result_arc (
id serial PRIMARY KEY,
result_id integer,
arc_id varchar (16),
node_1 varchar(16) ,
node_2 varchar(16) ,
arc_type varchar(18)  ,
arccat_id varchar(30)  ,
sector_id integer,
state int2,
expl_id integer,
parameter_id varchar(30) ,
work_id varchar(30) ,
init_condition float,
end_condition float,
loc_condition text,
pcompost_id varchar(16),
cost float,
ymax float,
length float,
measurement float,
budget float,
the_geom public.geometry(LINESTRING, SRID_VALUE)
);


CREATE TABLE om_reh_result_node (
id serial PRIMARY KEY,
result_id integer,
node_id varchar (16),
node_type varchar(18)  ,
nodecat_id varchar(30)  ,
sector_id integer,
state int2,
expl_id integer,
parameter_id varchar(30) ,
work_id varchar(30) ,
pcompost_id varchar(16),
cost float,
ymax float,
measurement float,
budget float,
the_geom public.geometry(POINT, SRID_VALUE)
);




CREATE TABLE "om_psector" (
"psector_id" integer NOT NULL PRIMARY KEY,
"name" varchar (50),
"psector_type" integer,
"result_id" integer,
"descript" text ,
"expl_id" integer,
"priority" varchar(16) ,
"text1" text ,
"text2" text ,
"observ" text ,
"rotation" numeric (8,4),
"scale" numeric (8,2),
"sector_id" integer,
"atlas_id" varchar(16) ,
"gexpenses" numeric (4,2),
"vat" numeric (4,2),
"other" numeric (4,2),
"active" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);

CREATE TABLE om_psector_selector(
  id serial NOT NULL PRIMARY KEY,
  psector_id integer NOT NULL,
  cur_user text NOT NULL
);


CREATE TABLE "om_psector_x_arc" (
"id" serial NOT NULL PRIMARY KEY,
"arc_id" varchar(16) ,
"psector_id" integer, 
"descript" varchar(254)  
);


CREATE TABLE "om_psector_x_node" (
"id" serial NOT NULL PRIMARY KEY,
"node_id" varchar(16) ,
"psector_id" integer,
"descript" varchar(254)  
);


CREATE TABLE "om_psector_x_other" (
"id" serial NOT NULL PRIMARY KEY,
"price_id" varchar(16) ,
"measurement" numeric (12,2),
"psector_id" integer,
"descript" varchar(254)  
);


CREATE TABLE "om_psector_cat_type" (
"id" integer  NOT NULL PRIMARY KEY,
"name" varchar(254) 
);
