/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "SCHEMA_NAME";
SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME"."version_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."node_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."link_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;





-- ----------------------------
-- Table system structure 
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16) COLLATE "default",
"wsoftware" varchar(16) COLLATE "default",
"postgres" varchar(512) COLLATE "default",
"postgis" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT version_pkey PRIMARY KEY (id)
);
 
CREATE TABLE "SCHEMA_NAME"."arc_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"epa_default" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
"epa_table" varchar(18) COLLATE "default" NOT NULL,
"event_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."node_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"epa_default" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
"epa_table" varchar(18) COLLATE "default" NOT NULL,
"event_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."config" (
"id" varchar(18) COLLATE "default" NOT NULL,
"node_tolerance" numeric (10,5),
"snapping_tolerance" numeric (10,5),
"node_buffering" numeric (10,5),
"connec_buffering" numeric (10,5),
"arc_toporepair" numeric (10,5),
CONSTRAINT "config_pkey" PRIMARY KEY ("id")
);


-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."cat_mat_arc" (
"id" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"roughness" numeric(12,4),
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."cat_mat_node" (
"id" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"roughness" numeric(12,4),
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."cat_arc" (
"id" varchar(30) COLLATE "default" NOT NULL, 
"arctype_id" varchar(16) COLLATE "default",
"matcat_id" varchar(30) COLLATE "default",
"pnom" varchar(16) COLLATE "default",
"dnom" varchar(16) COLLATE "default",
"dint" numeric(12,5),
"dext" numeric(12,5),
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_node" (
"id" varchar(30) COLLATE "default" NOT NULL,
"nodetype_id" varchar(16) COLLATE "default",
"matcat_id" varchar(30) COLLATE "default",
"pnom" varchar(16) COLLATE "default",
"dnom" varchar(16) COLLATE "default",
"dint" numeric(12,5),
"geometry" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table structure for GIS features
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."sector" (
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT sector_pkey PRIMARY KEY (sector_id)
);

CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" varchar(30) COLLATE "default",
													-- to INP model
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30) COLLATE "default",
													-- to MAN model
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",

"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."arc" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"arccat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"custom_length" numeric (12,2),
"dma_id" varchar(30) COLLATE "default",
													-- to INP model
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30) COLLATE "default",
													-- to MAN model
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",

"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "SCHEMA_NAME"."value_state" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
 CONSTRAINT value_state_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."value_verified" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
 CONSTRAINT value_verified_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."value_yesno" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
 CONSTRAINT value_yesno_pkey PRIMARY KEY (id)
);



------
-- FK
------

ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("arctype_id") REFERENCES "SCHEMA_NAME"."arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("nodetype_id") REFERENCES "SCHEMA_NAME"."node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("nodecat_id") REFERENCES "SCHEMA_NAME"."cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("state") REFERENCES "SCHEMA_NAME"."value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("verified") REFERENCES "SCHEMA_NAME"."value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "SCHEMA_NAME"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_1") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_2") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("state") REFERENCES "SCHEMA_NAME"."value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("verified") REFERENCES "SCHEMA_NAME"."value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

