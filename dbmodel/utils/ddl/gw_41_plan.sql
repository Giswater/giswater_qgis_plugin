/*
This file is part of Giswater 3
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
"psector_id" integer NOT NULL PRIMARY KEY,
"name" varchar (50),
"psector_type" integer,
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


CREATE TABLE "plan_psector_x_arc" (
"id" serial NOT NULL PRIMARY KEY,
"arc_id" varchar(16) ,
"psector_id" integer, 
"state" int2,
"doable" boolean,
"descript" varchar(254)  
);


CREATE TABLE "plan_psector_x_node" (
"id" serial NOT NULL PRIMARY KEY,
"node_id" varchar(16) ,
"psector_id" integer,
"state" int2,
"doable" boolean,
"descript" varchar(254)  
);


CREATE TABLE "plan_psector_x_other" (
"id" serial NOT NULL PRIMARY KEY,
"price_id" varchar(16) ,
"measurement" numeric (12,2),
"psector_id" integer,
"descript" varchar(254)  
);


CREATE TABLE "plan_arc_x_pavement" (
"id" serial NOT NULL PRIMARY KEY,
"arc_id" character varying(16),
"pavcat_id" character varying(16),
"percent" numeric (3,2)
);


CREATE TABLE "plan_psector_cat_type" (
"id" integer  NOT NULL PRIMARY KEY,
"name" varchar(254) 
);


CREATE TABLE plan_psector_selector(
  "id" serial NOT NULL PRIMARY KEY,
  "psector_id" integer NOT NULL,
  "cur_user" text NOT NULL
);


----------------------------------------------
-- TABLE SCTRUCTURE FOR PRICE
---------------------------------------------

CREATE TABLE price_cat_simple (
"id" varchar (30) PRIMARY KEY NOT NULL,
"descript" text,
"tstamp" timestamp default now(),
"cur_user" text
);


CREATE TABLE audit_price_simple (
  id character varying(16) PRIMARY KEY NOT NULL,
  pricecat_id varchar(16),
  unit character varying(5),
  descript character varying(100),
  text text,
  price numeric(12,4),
  obs character varying(16),
  tstamp timestamp default now(),
  cur_user text
);


CREATE TABLE price_simple (
  id character varying(16) PRIMARY KEY NOT NULL,
  pricecat_id varchar(16),
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



CREATE TABLE "plan_result_selector" (
"id" serial PRIMARY KEY,
"result_id" integer,
"cur_user" text
);



CREATE TABLE "plan_result_type" (
"id" integer  NOT NULL PRIMARY KEY,
"name" varchar(254) 
);
