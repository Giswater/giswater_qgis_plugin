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
CREATE SEQUENCE "plan_other_x_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "plan_arc_x_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "plan_node_x_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "plan_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
  
CREATE SEQUENCE "plan_arc_x_pavement_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

  
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


CREATE SEQUENCE "price_compost_value_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  


----------------------------------------------
-- TABLE STRUCTURE FOR PLAN
---------------------------------------------

CREATE TABLE "plan_psector" (
"psector_id" varchar DEFAULT nextval ('"SCHEMA_NAME".plan_psector_seq'::regclass) NOT NULL,
"descript" varchar(254) COLLATE "default",
"priority" varchar(16) COLLATE "default",
"text1" varchar(254) COLLATE "default",
"text2" varchar(254) COLLATE "default",
"observ" varchar(254) COLLATE "default",
"rotation" numeric (8,4),
"scale" numeric (8,2),
"sector_id" varchar(30) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"gexpenses" numeric (4,2),
"vat" numeric (4,2),
"other" numeric (4,2),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
 CONSTRAINT plan_psector_pkey PRIMARY KEY (psector_id)
);

CREATE TABLE "plan_arc_x_psector" (
"id" int4 DEFAULT nextval ('"SCHEMA_NAME".plan_arc_x_psector_seq'::regclass) NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_arc_x_psector_pkey PRIMARY KEY (id)
);


CREATE TABLE "plan_node_x_psector" (
"id" int4 DEFAULT nextval ('"SCHEMA_NAME".plan_node_x_psector_seq'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default",
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_node_x_psector_pkey PRIMARY KEY (id)
);



CREATE TABLE "plan_other_x_psector" (
"id" int4 DEFAULT nextval ('"SCHEMA_NAME".plan_other_x_psector_seq'::regclass) NOT NULL,
"price_id" varchar(16) COLLATE "default",
"measurement" numeric (12,2),
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_other_x_psector_pkey PRIMARY KEY (id)
);


CREATE TABLE plan_arc_x_pavement
(
  "id" int4 DEFAULT nextval ('"SCHEMA_NAME".plan_arc_x_pavement_seq'::regclass) NOT NULL,
  arc_id character varying(16),
  pavcat_id character varying(16),
  percent numeric (3,2),
  CONSTRAINT plan_arc_x_pavement_pkey PRIMARY KEY (id)
);



CREATE TABLE "plan_value_ps_priority" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
 CONSTRAINT plan_value_ps_priority_pkey PRIMARY KEY (id)
);


CREATE TABLE "plan_selector_economic"  -- Used to show economic data
(
  id character varying(16) NOT NULL,
  observ character varying(254),
  CONSTRAINT plan_selector_economic_pkey PRIMARY KEY (id)
);


CREATE TABLE "plan_selector_psector" -- Used to show a defined range of psector features on map composer
(
  id character varying(16) NOT NULL,
  observ character varying(254),
  CONSTRAINT plan_selector_psector_pkey PRIMARY KEY (id)
);






----------------------------------------------
-- TABLE SCTRUCTURE FOR PRICE
---------------------------------------------



CREATE TABLE price_simple
(
  id character varying(16) NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text text,
  price numeric(12,4),
  obs character varying(16),
  CONSTRAINT price_simple_id_pkey PRIMARY KEY (id)
);




CREATE TABLE price_compost
(
  id character varying(16) NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text text,
  price numeric(12,4),
  CONSTRAINT price_compost_id_pkey PRIMARY KEY (id)
);




CREATE TABLE price_compost_value
(
  "id" int4 DEFAULT nextval ('"SCHEMA_NAME".price_compost_value_seq'::regclass) NOT NULL,
  compost_id character varying(16),
  simple_id character varying(16),
  value numeric (16,4),
  CONSTRAINT price_compost_value_pkey PRIMARY KEY (id)
);


CREATE TABLE price_value_unit
(
  id character varying(16) NOT NULL,
  descript character varying(100),
  CONSTRAINT price_value_unit_pkey PRIMARY KEY (id)
);

