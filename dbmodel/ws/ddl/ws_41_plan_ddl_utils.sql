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
"psector_id" integer NOT NULL PRIMARY KEY,
"short_descript" varchar (50) NOT NULL,
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
"psector_id" varchar(16) COLLATE "default",
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


-- Used to filter features by planning issues
CREATE TABLE "plan_selector_state" (
  "id" character varying(16) PRIMARY KEY NOT NULL
);


-- Used to filter show a defined range of psector features on map composer
CREATE TABLE "plan_selector_psector" (
  "id" character varying(16) PRIMARY KEY NOT NULL,
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

