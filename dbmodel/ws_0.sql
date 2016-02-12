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

CREATE SEQUENCE "SCHEMA_NAME"."node_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."arc_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."node_flow_exit_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."arc_flow_exit_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;



-- ----------------------------
-- Table main structure 
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16) COLLATE "default",
"wsoftware" varchar(16) COLLATE "default",
"postgres" varchar(512) COLLATE "default",
"postgis" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT version_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;
 

CREATE TABLE "SCHEMA_NAME"."arc_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"arc_type" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"epa_type" varchar(18) COLLATE "default" NOT NULL,
"inp_table" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)

;


CREATE TABLE "SCHEMA_NAME"."node_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"node_type" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"epa_type" varchar(18) COLLATE "default" NOT NULL,
"inp_table" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."cat_mat" (
"id" varchar(16) COLLATE "default",
"descript" varchar(100) COLLATE "default",
"roughness" numeric(12,4),
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_mat_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_arc" (
"id" varchar(30) COLLATE "default" NOT NULL, 
"arctype_id" varchar(16) COLLATE "default",
"matcat_id" varchar(16) COLLATE "default",
"pn_atm" int2,
"dnom" int4,
"dint" numeric(12,5),
"dext" numeric(12,5),
"short_des" varchar(16) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)

;


CREATE TABLE "SCHEMA_NAME"."cat_node" (
"id" varchar(30) COLLATE "default" NOT NULL,
"nodetype_id" varchar(16) COLLATE "default",
"matcat_id" varchar(16) COLLATE "default",
"matcat_2" varchar(16) COLLATE "default",
"matcat_3" varchar(16) COLLATE "default",
"pnominal" int4,
"dnom" int4,
"dnom_2" int4,
"dnom_3" int4,
"geom1" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"value" numeric (12,2),
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_connec" (
"id" varchar(30) COLLATE "default" NOT NULL,
"matcat_id" varchar(16) COLLATE "default",
"matcat_2" varchar(16) COLLATE "default",
"matcat_3" varchar(16) COLLATE "default",
"diameter" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"geom4" numeric (12,2),
"value" numeric (12,2),
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_soil" (
"id" varchar(16) COLLATE "default" NOT NULL,
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_manager" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_manager_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_builder" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;

CREATE TABLE "SCHEMA_NAME"."cat_work" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



-- ----------------------------
-- Table structure for GIS features
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."sector" (
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT sector_pkey PRIMARY KEY (sector_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."dma" (
"dma_id" varchar(30) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(255) COLLATE "default",
"observ" character varying(512),
"event" character varying(30),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(512),
"observ" character varying(254),
"text" character varying(100),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(16) COLLATE "default",
"fluid_type" varchar(16) COLLATE "default",
"location_type" varchar(16) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"link" character varying(512),
"value_db" numeric(12,4),
"value_int2" int2,
"value_int4" int4,
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
"descript" varchar(100) COLLATE "default",
"event" varchar(30) COLLATE "default",
"temp" varchar(30) COLLATE "default",
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."arc" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"arccat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(512),
"observ" character varying(254),
"event" character varying(30),
"rotation" numeric (6,3),
"direction" character varying(2),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(16) COLLATE "default",
"fluid_type" varchar(16) COLLATE "default",
"location_type" varchar(16) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"link" character varying(512),
"real_length" numeric (12,2),
"value_db" numeric(12,4),
"value_int2" int2,
"value_int4" int4,
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
"descript" varchar(100) COLLATE "default",
"text" varchar(30) COLLATE "default",
"temp" varchar(30) COLLATE "default",
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."connec" (
"connec_id" varchar DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(512),
"observ" character varying(254),
"text" character varying(100),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(16) COLLATE "default",
"fluid_type" varchar(16) COLLATE "default",
"location_type" varchar(16) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"link" character varying(512),
"value_db" numeric(12,4),
"value_int2" int2,
"value_int4" int4,
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
"descript" varchar(100) COLLATE "default",
"event" varchar(30) COLLATE "default",
"temp" varchar(30) COLLATE "default",
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
connec_id varchar(16) COLLATE "default",
the_geom public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
)
WITH (OIDS=FALSE)
;




------
-- FK
------

ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("arctype_id") REFERENCES "SCHEMA_NAME"."arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("nodetype_id") REFERENCES "SCHEMA_NAME"."node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("nodecat_id") REFERENCES "SCHEMA_NAME"."cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "SCHEMA_NAME"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_1") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_2") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


/*
-- ----------------------------
-- Records of arc_type
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PIPE','PIPE','inp_pipe', 'man_arc_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('SHUTOFF VALVE','PIPE','inp_pipe', 'man_arc_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('CHECK VALVE','PIPE','inp_pipe','man_arc_valve'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FL-CONTR. VALVE','VALVE','inp_valve', 'man_arc_valve'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-BREAK. VALVE', 'VALVE','inp_valve', 'man_arc_valve'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-REDUC. VALVE', 'VALVE','inp_valve', 'man_arc_valve'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-SUSTA. VALVE', 'VALVE','inp_valve', 'man_arc_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('THROTTLE VALVE', 'VALVE','inp_valve', 'man_arc_valve'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('GEN.PURP. VALVE', 'VALVE','inp_valve', 'man_arc_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PUMP','PUMP', 'PUMP','inp_pump', 'man_arc_pump'); 
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FLOW METER','PIPE','inp_pipe', 'man_arc_flowmeter');  
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FILTER','PIPE','inp_pipe', 'man_arc_filter'); 



-- ----------------------------
-- Records of node_type
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('RESERVOIR','RESERVOIR', 'inp_reservoir', 'man_node_tank');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('TANK','TANK', 'inp_tank', 'man_node_tank');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('HYDRANT','JUNCTION', 'inp_junction', 'man_node_hydrant');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('GREENHYDRANT','JUNCTION', 'inp_junction', 'man_node_valve');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('DISCHARGE','JUNCTION', 'inp_junction', 'man_node_valve');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('SUCTION','JUNCTION', 'inp_junction', 'man_node_valve');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('JUNCTION','JUNCTION', 'inp`_junction', 'man_node_accessory');


*/


