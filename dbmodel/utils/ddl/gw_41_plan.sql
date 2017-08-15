/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

---------------------------------------------------------------
-- COMMON SQL (WS & UD)
---------------------------------------------------------------

-- ----------------------------
-- Sequence structure
-- ----------------------------

  
CREATE SEQUENCE "price_simple_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
	
CREATE SEQUENCE "price_compost_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	

CREATE SEQUENCE "price_simple_value_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  

----------------------------------------------
-- TABLE STRUCTURE FOR PLAN
---------------------------------------------

CREATE TABLE "plan_psector" (
"psector_id" serial NOT NULL PRIMARY KEY,
"name" varchar (50) NOT NULL,
"descript" text COLLATE "default",
"expl_id" integer,
"priority" varchar(16) COLLATE "default",
"text1" text COLLATE "default",
"text2" text COLLATE "default",
"observ" text COLLATE "default",
"rotation" numeric (8,4),
"scale" numeric (8,2),
"sector_id" varchar(30) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"gexpenses" numeric (4,2),
"vat" numeric (4,2),
"other" numeric (4,2),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);


CREATE TABLE "plan_arc_x_psector" (
"id" serial NOT NULL PRIMARY KEY,
"arc_id" varchar(16) COLLATE "default",
"psector_id" integer NOT NULL,
"state" int2 NOT NULL,
"doable" boolean NOT NULL,
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" 
);


CREATE TABLE "plan_node_x_psector" (
"id" serial NOT NULL PRIMARY KEY,
"node_id" varchar(16) COLLATE "default",
"psector_id" integer NOT NULL,
"state" int2 NOT NULL,
"doable" boolean NOT NULL,
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" 
);


CREATE TABLE "plan_other_x_psector" (
"id" serial NOT NULL PRIMARY KEY,
"price_id" varchar(16) COLLATE "default",
"measurement" numeric (12,2),
"psector_id" integer,
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" 
);


CREATE TABLE plan_arc_x_pavement (
"id" serial NOT NULL PRIMARY KEY,
"arc_id" character varying(16),
"pavcat_id" character varying(16),
"percent" numeric (3,2)
);


CREATE TABLE "plan_value_ps_priority" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default"
);



----------------------------------------------
-- TABLE SCTRUCTURE FOR PRICE
---------------------------------------------


CREATE TABLE price_simple (
  id character varying(16) PRIMARY KEY NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text text,
  price numeric(12,4),
  obs character varying(16)
);


CREATE TABLE price_compost (
  id character varying(16) PRIMARY KEY NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text text,
  price numeric(12,4)
);


CREATE TABLE price_compost_value (
  id serial PRIMARY KEY NOT NULL,
  compost_id character varying(16),
  simple_id character varying(16),
  value numeric (16,4)
);


CREATE TABLE price_value_unit (
  id character varying(16) PRIMARY KEY NOT NULL,
  descript character varying(100)
);



----------------------------------------------
-- TABLE SCTRUCTURE FOR BUDGET
---------------------------------------------


-- ----------------------------
-- Table CATALOG
-- ----------------------------

CREATE TABLE "plan_result_cat" (
"result_id" serial PRIMARY KEY,
"name" varchar (30),
"network_price_coeff" float,
timestamp default now(),
user default cur_user(),
"descript" text
);




-- ----------------------------
-- Table structure for Selector
-- ----------------------------

CREATE TABLE plan_selector_result (
id serial NOT NULL PRIMARY KEY,
result_id integer),
cur_user text



-- ----------------------------
-- Table structure for budget
-- ----------------------------


CREATE TABLE "plan_result_node" (
"id" serial PRIMARY KEY NOT NULL,
"result_id" varchar(16) NOT NULL,
"node_id" varchar(16) NOT NULL,
"elevation" numeric(12,3),
"elev" numeric(12,3),
"node_type" varchar(18)  ,
"nodecat_id" varchar(30)  ,
"epa_type" varchar(16)  ,
"sector_id" integer NOT NULL,
"state" int2  NOT NULL,
"annotation" character varying(254),
"the_geom" public.geometry (POINT, SRID_VALUE)
"cost_unit" varchar(3),
"calculated_depth" numeric(12,2),
"cost" numeric(12,3),
"budget" numeric(12,2)
);



CREATE TABLE "plan_result_arc" (
"id" serial PRIMARY KEY NOT NULL,
"result_id" varchar(16) NOT NULL,
"arc_id" varchar(16) ,
"node_1" varchar(16) ,
"node_2" varchar(16) ,
"arc_type" varchar(18)  ,
"arccat_id" varchar(30)  ,
"epa_type" varchar(16)  ,
"sector_id" integer NOT NULL,
"state" int2  NOT NULL,
"annotation" character varying(254),
"length" numeric(12,3),
"the_geom" public.geometry (LINESTRING, SRID_VALUE)
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
"bulk_bottom" numeric(12,2),
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
"cost_unit" numeric(12,2),
"pav_cost" numeric(12,2),
"exc_cost" numeric(12,2),
"trenchl_cost" numeric(12,2),
"base_cost" numeric(12,2),
"protec_cost" numeric(12,2),
"fill_cost" numeric(12,2),
"arc_cost" numeric(12,2),
"cost " numeric(12,2)
);


