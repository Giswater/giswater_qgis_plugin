/*
This file is part of Giswater 2.0
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



-- -----------------------------
-- SEQUENCES
-- -----------------------------

CREATE SEQUENCE "SCHEMA_NAME"."version_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."cat_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."cat_arc_seq"
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

	
CREATE SEQUENCE "SCHEMA_NAME"."pol_id_seq"
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

CREATE SEQUENCE "SCHEMA_NAME"."vnode_seq"
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


CREATE SEQUENCE "SCHEMA_NAME"."gully_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."element_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."element_x_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."element_x_connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."element_x_gully_seq"
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
"giswater" varchar(16)  ,
"wsoftware" varchar(16)  ,
"postgres" varchar(512)  ,
"postgis" varchar(512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT version_pkey PRIMARY KEY (id)
);
 
CREATE TABLE "SCHEMA_NAME"."arc_type" (
"id" varchar(18)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."node_type" (
"id" varchar(18)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."element_type" (
"id" varchar(18)   NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."config" (
"id" varchar(18)   NOT NULL,
"node_proximity" double precision,
"arc_searchnodes" double precision,
"node2arc" double precision,
"connec_proximity" double precision,
"arc_toporepair" double precision,
"nodeinsert_arcendpoint" boolean,
"nodeinsert_nodetype_vdefault" varchar (30),
"orphannode_delete" boolean,
CONSTRAINT "config_pkey" PRIMARY KEY ("id")
);



-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."cat_mat_arc" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"n" numeric(12,4),
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."cat_mat_node" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_arc" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_arc_seq'::regclass) NOT NULL,
"matcat_id" varchar (16)  ,
"shape" varchar(16)  ,
"tsect_id" varchar(16)  ,
"curve_id" varchar(16)  ,
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20)  ,
"short_des" varchar(16)  ,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_node" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_node_seq'::regclass) NOT NULL,
"matcat_id" varchar (16)  ,
"geom1" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"value" numeric (12,2),
"short_des" varchar(30)  ,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_mat_element" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_element" (
"id" varchar(30)   NOT NULL,
"elementtype_id" varchar(30)  ,
"matcat_id" varchar(30)  ,
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."cat_connec" (
"id" varchar(30)   NOT NULL,
"type" varchar(16)  ,
"matcat_id" varchar (16)  ,
"shape" varchar(16)  ,
"tsect_id" varchar(16)  ,
"curve_id" varchar(16)  ,
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20)  ,
"short_des" varchar(16)  ,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_grate" (
"id" varchar(30)   NOT NULL,
"type" varchar(30)   NOT NULL,
"matcat_id" varchar (16)  ,
"length" numeric(12,4),
"width" numeric(12,4) DEFAULT 0.00,
"total_area" numeric(12,4) DEFAULT 0.00,
"efective_area" numeric(12,4) DEFAULT 0.00,
"n_barr_l" numeric(12,4) DEFAULT 0.00,
"n_barr_w" numeric(12,4) DEFAULT 0.00,
"n_barr_diag" numeric(12,4) DEFAULT 0.00,
"a_param" numeric(12,4) DEFAULT 0.00,
"b_param" numeric(12,4) DEFAULT 0.00,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_grate_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_soil" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_builder" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_work" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_owner" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_owner_pkey PRIMARY KEY (id)
);



-----------
-- Table: Value domain (type)
-----------

CREATE TABLE "SCHEMA_NAME"."man_type_category" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."man_type_fluid" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."man_type_location" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."connec_type" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT connec_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."man_type_street" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT man_type_street_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table: GIS environment
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."streetaxis" (
"id" varchar(16) NOT NULL,
"type" varchar(18)  ,
"name" varchar(100)  ,
CONSTRAINT streeaxis_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."sector" (
"sector_id" varchar(30)   NOT NULL,
"descript" varchar(100)  ,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT sector_pkey PRIMARY KEY (sector_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16)   NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"sander" numeric(12,4),
"node_type" varchar(16)  ,
"nodecat_id" varchar(30)  ,
"epa_type" varchar(16)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" varchar(30)  ,
														-- to INP model
"soilcat_id" varchar(16)  ,
"category_type" varchar(18)  ,
"fluid_type" varchar(18)  ,
"location_type" varchar(18)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,

"est_top_elev" varchar(6),
"est_ymax" varchar(6),
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) ,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
);



CREATE TABLE "SCHEMA_NAME"."arc" (
"arc_id" varchar(16)   NOT NULL,
"node_1" varchar(16)  ,
"node_2" varchar(16)  ,
"y1" numeric (12,3),
"y2" numeric (12,3),
"arc_type" varchar(16)  ,
"arccat_id" varchar(30)  ,
"epa_type" varchar(16)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"direction" character varying(2),
"custom_length" numeric (12,2),
"dma_id" varchar(30)  ,
													-- to INP model
"soilcat_id" varchar(16)  ,
"category_type" varchar(18)  ,
"fluid_type" varchar(18)  ,
"location_type" varchar(18)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,

"est_y1" boolean,
"est_y2" boolean,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16),
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE "SCHEMA_NAME"."polygon" (
"pol_id" varchar(16)   NOT NULL,
"node_id" varchar(16)  ,
"text" varchar(254)  ,
"the_geom" public.geometry (POLYGON, SRID_VALUE),
CONSTRAINT polygon_pkey PRIMARY KEY (pol_id)
);



CREATE TABLE "SCHEMA_NAME"."dma" (
"dma_id" varchar(30)   NOT NULL,
"sector_id" varchar(30)  ,
"descript" varchar(255)  ,
"observ" character varying(512),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
);


CREATE TABLE "SCHEMA_NAME"."connec" (
"connec_id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"connecat_id" varchar(30)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30)  ,
"soilcat_id" varchar(16)  ,
"category_type" varchar(18)  ,
"fluid_type" varchar(18)  ,
"location_type" varchar(18)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"streetaxis_id" varchar (16)  ,
"postnumber" varchar (16)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(16)  , 
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);



CREATE TABLE "SCHEMA_NAME"."vnode" (
"vnode_id" varchar(16) DEFAULT nextval('"test_ws".vnode_seq'::regclass) NOT NULL,
"arc_id" varchar(16),
"userdefined_pos" bool,
"vnode_type" varchar(30),
"sector_id" varchar(30),
"state" varchar(16),
"annotation" varchar(254),
"the_geom" "public"."geometry",
CONSTRAINT "vnode_pkey" PRIMARY KEY ("vnode_id")
);


CREATE TABLE "SCHEMA_NAME"."link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
connec_id varchar(16) ,
vnode_id varchar(16) ,
custom_length numeric (12,3),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
);



CREATE TABLE "SCHEMA_NAME"."gully" (
"gully_id" varchar(16)   NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"sandbox" numeric(12,4),
"matcat_id" varchar(18)  ,
"gratecat_id" varchar(18)  ,
"units" int2,
"groove" varchar(3)  ,
"arccat_id" varchar(18)  ,
"siphon" varchar(3)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30)  ,
"soilcat_id" varchar(16)  ,
"category_type" varchar(18)  ,
"fluid_type" varchar(18)  ,
"location_type" varchar(18)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(4)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT gully_pkey PRIMARY KEY (gully_id)
);



-- ----------------------------
-- Table: Add info feature 
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."man_junction" (
"node_id" varchar(16)   NOT NULL,
"add_info" varchar(255)  ,
CONSTRAINT man_junction_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_storage" (
"node_id" varchar(16)   NOT NULL,
"add_info" varchar(255)  ,
CONSTRAINT man_storage_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_outfall" (
"node_id" varchar(16)   NOT NULL,
"add_info" varchar(255)  ,
CONSTRAINT man_outfall_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_virtual" (
"arc_id" varchar(16)   NOT NULL,
CONSTRAINT man_virtualarc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "SCHEMA_NAME"."man_conduit" (
"arc_id" varchar(16)   NOT NULL,
"add_info" varchar(255)  ,
CONSTRAINT man_conduit_pkey PRIMARY KEY (arc_id)
);




-- ----------------------------------
-- Table: Element
-- ----------------------------------

CREATE TABLE "SCHEMA_NAME"."element" (
"element_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_seq'::regclass) NOT NULL,
"elementcat_id" varchar(30)  ,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"location_type" varchar(18)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"enddate" timestamp (6) without time zone,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16)   NOT NULL,
CONSTRAINT element_pkey PRIMARY KEY (element_id)
);


CREATE TABLE "SCHEMA_NAME"."element_x_node" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_node_seq'::regclass) NOT NULL,
"element_id" varchar(16)  ,
"node_id" varchar(16)  ,
CONSTRAINT element_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."element_x_connec" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_connec_seq'::regclass) NOT NULL,
"element_id" varchar(16)  ,
"connec_id" varchar(16)  ,
CONSTRAINT element_x_connec_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."element_x_gully" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_gully_seq'::regclass) NOT NULL,
"element_id" varchar(16)  ,
"gully_id" varchar(16)  ,
CONSTRAINT element_x_gully_pkey PRIMARY KEY (id)
);


-- ----------------------------------
-- Table: value domain
-- ----------------------------------


CREATE TABLE "SCHEMA_NAME"."value_state" (
"id" varchar(16)   NOT NULL,
"observ" varchar(254)  ,
 CONSTRAINT value_state_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."value_verified" (
"id" varchar(16)   NOT NULL,
"observ" varchar(254)  ,
 CONSTRAINT value_verified_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."value_yesno" (
"id" varchar(16)   NOT NULL,
"observ" varchar(254)  ,
 CONSTRAINT value_yesno_pkey PRIMARY KEY (id)
);




------
-- FK
------

ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("arc_type") REFERENCES "SCHEMA_NAME"."arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("node_type") REFERENCES "SCHEMA_NAME"."node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

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

ALTER TABLE "SCHEMA_NAME"."polygon" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_element" ADD FOREIGN KEY ("elementtype_id") REFERENCES "SCHEMA_NAME"."element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_element" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_connec" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_connec" ADD FOREIGN KEY ("type") REFERENCES "SCHEMA_NAME"."connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "SCHEMA_NAME"."cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."dma" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."link" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."link" ADD FOREIGN KEY ("vnode_id") REFERENCES "SCHEMA_NAME"."vnode" ("vnode_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("gratecat_id") REFERENCES "SCHEMA_NAME"."cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("arccat_id") REFERENCES "SCHEMA_NAME"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("groove") REFERENCES "SCHEMA_NAME"."value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("siphon") REFERENCES "SCHEMA_NAME"."value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."gully" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."streetaxis" ADD FOREIGN KEY ("type") REFERENCES "SCHEMA_NAME"."man_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("streetaxis_id") REFERENCES "SCHEMA_NAME"."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."vnode" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_storage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_virtual" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("elementcat_id") REFERENCES "SCHEMA_NAME"."cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("state") REFERENCES "SCHEMA_NAME"."value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element" ADD FOREIGN KEY ("verified") REFERENCES "SCHEMA_NAME"."value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "SCHEMA_NAME"."element_x_node" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."element_x_connec" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."element_x_gully" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."element_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "SCHEMA_NAME"."gully" ("gully_id") ON DELETE CASCADE ON UPDATE CASCADE;




----------------
-- SPATIAL INDEX
----------------

CREATE INDEX arc_index ON arc USING GIST (the_geom);
CREATE INDEX node_index ON node USING GIST (the_geom);
CREATE INDEX dma_index ON dma USING GIST (the_geom);
CREATE INDEX sector_index ON sector USING GIST (the_geom);
CREATE INDEX connec_index ON connec USING GIST (the_geom);
CREATE INDEX vnode_index ON vnode USING GIST (the_geom);
CREATE INDEX link_index ON link USING GIST (the_geom);
CREATE INDEX gully_index ON gully USING GIST (the_geom);


