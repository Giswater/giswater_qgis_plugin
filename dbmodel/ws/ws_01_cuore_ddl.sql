/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE "version_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "cat_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "cat_arc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "node_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "vnode_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "link_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "element_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "element_x_arc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "element_x_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "element_x_connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




-- ----------------------------
-- Table: system structure 
-- ----------------------------

 
CREATE TABLE "arc_type" (
"id" varchar(18)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "node_type" (
"id" varchar(18)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);

CREATE TABLE "element_type" (
"id" varchar(18)   NOT NULL,
"event_table" varchar(18),
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "connec_type" (
"id" varchar(50) NOT NULL,
"type" character varying(18) NOT NULL,
"man_table" character varying(18) NOT NULL,
"event_table" varchar(18)   NOT NULL,
CONSTRAINT connec_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "point_type" (
"id" varchar(18)   NOT NULL,
"text" text,
CONSTRAINT point_type_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- Table: Catalogs
-- ----------------------------


CREATE TABLE "cat_mat_arc" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_mat_node" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"roughness" numeric(12,4),
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_arc" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_arc_seq'::regclass) NOT NULL,
"arctype_id" varchar(18)  ,
"matcat_id" varchar(30)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"dext" numeric(12,5),
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
"z1" numeric (12,2),
"z2" numeric (12,2),
"width" numeric (12,2),
"area" numeric (12,4),
"estimated_depth" numeric (12,2),
"bulk" numeric (12,2),
"cost_unit" varchar (3),
"cost" varchar (16),
"m2bottom_cost" varchar (16),
"m3protec_cost" varchar (16),
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_node" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_node_seq'::regclass) NOT NULL,
"nodetype_id" varchar(18)  ,
"matcat_id" varchar(30)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
"estimated_depth" numeric (12,2),
"cost_unit" varchar (3),
"cost" varchar (16),
"num_arcs" integer,
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_mat_element" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_element" (
"id" varchar(30)   NOT NULL,
"elementtype_id" varchar(18)  ,
"matcat_id" varchar(30)  ,
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_connec" (
"id" varchar(30)   NOT NULL,
"type" varchar(18)  ,
"matcat_id" varchar(16)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_soil" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512),
"link" varchar(512),
"url" varchar(512),
"picture" varchar(512),
"y_param" numeric(5,2),
"b" numeric(5,2),
"trenchlining" numeric(3,2),
"m3exc_cost" varchar (16),
"m3fill_cost" varchar (16),
"m3excess_cost" varchar (16),
"m2trenchl_cost" varchar (16),
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_builder" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_work" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_owner" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_owner_pkey PRIMARY KEY (id)
);



CREATE TABLE "cat_pavement" (
id varchar (18),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512)  ,
"thickness" numeric(12,2) DEFAULT 0.00,
"m2_cost" varchar (16),
 CONSTRAINT cat_pavement_pkey PRIMARY KEY (id)
 );
 
 
 CREATE TABLE "cat_press_zone" (
id varchar (18),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_press_zone_pkey PRIMARY KEY (id)
 );



-----------
-- Table: value domain (type)
-----------


CREATE TABLE "man_type_category" (
"id" varchar(50) NOT NULL,
"observ" varchar(50),
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_fluid" (
"id" varchar(50) NOT NULL,
"observ" varchar(50),
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_location" (
"id" varchar(50) NOT NULL,
"observ" varchar(50),
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE "sector" (
"sector_id" varchar(30) NOT NULL,
"descript" varchar(100),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
"undelete" boolean,
CONSTRAINT sector_pkey PRIMARY KEY (sector_id)
);

CREATE TABLE "node" (
"node_id" varchar(16) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"node_type" varchar(18),
"nodecat_id" varchar(30),
"epa_type" varchar(16)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" varchar(30)  ,
													-- to INP model
"soilcat_id" varchar(16)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"workcat_id_end" character varying(255),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "arc" (
"arc_id" varchar(16) NOT NULL,
"node_1" varchar(16)  ,
"node_2" varchar(16)  ,
"arccat_id" varchar(30) ,
"epa_type" varchar(16)  ,
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"custom_length" numeric (12,2),
"dma_id" varchar(30)  ,
													-- to INP model
"soilcat_id" varchar(16)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
"undelete" boolean,
"workcat_id_end" character varying(255),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "dma" (
"dma_id" varchar(30) NOT NULL,
"sector_id" varchar(30),
"presszonecat_id" varchar(30),
"descript" varchar(255),
"observ" character varying(512),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
"undelete" boolean,
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
);



CREATE TABLE "connec" (
"connec_id" varchar (16) DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30),
"sector_id" varchar(30),
"code" varchar(30),
"n_hydrometer" int4,
"demand" numeric(12,8),
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30),
"soilcat_id" varchar(16),
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date ,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"streetaxis_id" varchar (16)  ,
"postnumber" varchar (16)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"connec_type" character varying(30),
"workcat_id_end" character varying(255),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);


CREATE TABLE "vnode" (
"vnode_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".vnode_seq'::regclass) NOT NULL,
"arc_id" varchar(16),
"userdefined_pos" bool,
"vnode_type" varchar(18),
"sector_id" varchar(30),
"state" varchar(16),
"annotation" varchar(254),
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT "vnode_pkey" PRIMARY KEY ("vnode_id")
);


CREATE TABLE "link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
connec_id varchar(16),
vnode_id varchar(16),
custom_length numeric (12,3),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
);



CREATE TABLE "point" (
"point_id" varchar(30)   NOT NULL,
"point_type" varchar(18),
"observ" character varying(512),
"text" text,
"link" text,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
CONSTRAINT point_pkey PRIMARY KEY (point_id)
);


CREATE TABLE "presszone" (
"id" serial NOT NULL,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
"presszonecat_id" varchar(18),
"sector" character varying(512),
"text" text,
"undelete" boolean,
CONSTRAINT presszone_pkey PRIMARY KEY (id)
);

CREATE TABLE "pond"(
"pond_id" character varying(16) NOT NULL,
"connec_id" character varying(16),
"code_comercial" integer,
"orto2005" integer,
"date_production" date,
"the_geom" geometry(Point,SRID_VALUE),
  CONSTRAINT man_pond_pkey PRIMARY KEY (pond_id)
);


CREATE TABLE "pool"(
  "pool_id" character varying(16) NOT NULL,
  "connec_id" character varying(16),
  "code_comercial" integer,
  "orto2005" integer,
  "date_production" date,
  "the_geom" geometry(Point,SRID_VALUE),
  CONSTRAINT man_pool_pkey PRIMARY KEY (pool_id)
  );
  
  
  CREATE TABLE "samplepoint"(
  "sample_id" character varying(16) NOT NULL,
  "state" character varying(150),
  "rotation" numeric(12,3),
  "code_lab" integer,
  "element_type" character varying(150),
  "date_production" date,
  "workcat_id" character varying(255),
  "workcat_id_end" character varying(255),
  "street1" character varying(254),
  "street2" character varying(254),
  "place" character varying(254),
  "element_code" integer,
  "cabinet" character varying(150),
  "dma_id2" character varying(30),
  "observations" character varying(254),
  "the_geom" geometry(Point,SRID_VALUE),
  CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id)
);


-- -----------------------------------
-- Table: Add info of GIS feature 
-- -----------------------------------

CREATE TABLE "man_junction" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_junction_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_tank" (
"node_id" varchar(16)   NOT NULL,
"vmax" numeric (12,4),
"area" numeric (12,4),
"add_info" varchar(255),
"chlorination" character varying(255),
"function" character varying(255),
CONSTRAINT man_tank_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_hydrant" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
"communication" character varying(254),
"valve" character varying(100),
"valve_diam" numeric(12,3),
"distance_left" numeric(12,3),
"distance_right" numeric(12,3),
"distance_perpendicular" numeric(12,3),
"location" character varying(254),
"location_sign" character varying(254),
CONSTRAINT man_hydrant_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_valve" (
"node_id" varchar(16) NOT NULL,
"type" varchar(18),
"opened" boolean DEFAULT true,
"acessibility" boolean DEFAULT true,
"broken" boolean DEFAULT true,
"add_info" varchar(255),
"mincut_anl" boolean DEFAULT true,
"hydraulic_anl" boolean DEFAULT true,
"burried" character varying(16),
"irrigation_indicator" character varying(16),
"pression_entry" numeric(12,3),
"pression_exit" numeric(12,3),
"depth_valveshaft" numeric(12,3),
"regulator_situation" character varying(150),
"regulator_location" character varying(150),
"regulator_observ" character varying(254),
"lin_meters" numeric(12,3),
"exit_type" character varying(100),
"exit_code" integer,
"drive_type" character varying(100),
"location" character varying(254),
"valve_diam" numeric(12,3),
"valve" character varying(30),
CONSTRAINT man_valve_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_pump" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_pump_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_filter" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_filter_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_meter" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_meter_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_pipe" (
"arc_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_pipe_pkey PRIMARY KEY (arc_id)
);

  CREATE TABLE "man_manhole"(
"node_id" character varying(16) NOT NULL,
"add_info" character varying(255),
CONSTRAINT man_manhole_pkey PRIMARY KEY (node_id)
);

CREATE TABLE "man_reduction"(
"node_id" character varying(16) NOT NULL,
"diam_initial" numeric(12,3),
"diam_final" numeric(12,3),
"add_info" character varying(255),
CONSTRAINT man_reduction_pkey PRIMARY KEY (node_id)
  );

CREATE TABLE "man_source"(
"node_id" character varying(16) NOT NULL,
"add_info" character varying(255),
  CONSTRAINT man_source_pkey PRIMARY KEY (node_id)
  );
  
CREATE TABLE "man_waterwell"(
"node_id" character varying(16) NOT NULL,
"add_info" character varying(255),
CONSTRAINT man_waterwell_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_fountain"(
"connec_id" character varying(16) NOT NULL,
"vmax" numeric(12,3),
"vtotal" numeric(12,3),
"container_number" integer,
"pump_number" integer,
"power" numeric(12,3),
"regulation_tank" character varying(150),
"name" character varying(254),
"connection" character varying(100),
"chlorinator" character varying(100),
"add_info" character varying(255),
  CONSTRAINT man_fountain_pkey PRIMARY KEY (connec_id)
 );
  
  
  CREATE TABLE "man_greentap"(
"connec_id" character varying(16) NOT NULL,
"add_info" character varying(255),
CONSTRAINT man_greentap_pkey PRIMARY KEY (connec_id)
 );
  
  
CREATE TABLE "man_tap"(
"connec_id" character varying(16) NOT NULL,
"type" character varying(100),
"connection" character varying(100),
"continous" character varying(100),
"shutvalve_type" character varying(100),
"shutvalve_diam" numeric(12,3),
"shutvalve_number" character varying(100),
"drain_diam" numeric(12,3),
"drain_exit" character varying(100),
"drain_gully" character varying(100),
"drain_distance" numeric(12,3),
"arquitect_patrimony" character varying(254),
"communication" character varying(254),
"add_info" character varying(255),
CONSTRAINT man_tap_pkey PRIMARY KEY (connec_id)
);
  
  CREATE TABLE "man_wjoin"(
"connec_id" character varying(16) NOT NULL,
"arc_id" character varying(16),
"zone" integer,
"length" numeric(12,3),
"top_floor" integer,
"lead_verified" date,
"lead_facade" character varying(254),
"add_info" character varying(255),
CONSTRAINT man_wjoin_pkey PRIMARY KEY (connec_id)
);
  
-- ----------------------------------
-- Table: Element
-- ----------------------------------

CREATE TABLE "element" (
"element_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_seq'::regclass) NOT NULL,
"elementcat_id" varchar(30)  ,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30)  ,
"enddate" timestamp (6) without time zone,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20)   NOT NULL,
"workcat_id_end" varchar(255),
CONSTRAINT element_pkey PRIMARY KEY (element_id)
);


CREATE TABLE "element_x_arc" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_arc_seq'::regclass) NOT NULL,
"element_id" varchar(16),
"arc_id" varchar(16),
CONSTRAINT element_x_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "element_x_node" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_node_seq'::regclass) NOT NULL,
"element_id" varchar(16),
"node_id" varchar(16),
CONSTRAINT element_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "element_x_connec" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_connec_seq'::regclass) NOT NULL,
"element_id" varchar(16),
"connec_id" varchar(16),
CONSTRAINT element_x_connec_pkey PRIMARY KEY (id)
);


-- ----------------------------------
-- Table: value domain
-- ----------------------------------

CREATE TABLE "value_state" (
"id" varchar(16) NOT NULL,
"observ" varchar(254),
 CONSTRAINT value_state_pkey PRIMARY KEY (id)
);


CREATE TABLE "value_verified" (
"id" varchar(16) NOT NULL,
"observ" varchar(254),
 CONSTRAINT value_verified_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."value_yesno" (
"id" varchar(16) NOT NULL,
"observ" varchar(254),
 CONSTRAINT value_yesno_pkey PRIMARY KEY (id)
);


-- ----------------------------------
-- Table: selector
-- ----------------------------------


CREATE TABLE "man_selector_valve" (
"id" varchar(50) NOT NULL,
 CONSTRAINT man_selector_valve_pkey PRIMARY KEY (id)
);


-- Used to filter features by management issues
CREATE TABLE "man_selector_state" (
  "id" character varying(16) NOT NULL,
  CONSTRAINT man_selector_state_pkey PRIMARY KEY (id)
);


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
CREATE INDEX point_index ON point USING GIST (the_geom);
CREATE INDEX presszone_index ON presszone USING GIST (the_geom);


