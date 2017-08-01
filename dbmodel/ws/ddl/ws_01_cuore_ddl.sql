/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE dimensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	
CREATE SEQUENCE point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	
CREATE SEQUENCE urn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


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

	
		
CREATE SEQUENCE pol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
  
  
CREATE SEQUENCE pond_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE SEQUENCE pool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE polygon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Table: system structure 
-- ----------------------------

CREATE TABLE cat_feature
(
  id character varying(30) NOT NULL,
  feature_type character varying(30),
  CONSTRAINT cat_feature_pkey PRIMARY KEY (id)
);

 
CREATE TABLE "arc_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"active" boolean,
"code_autofill" boolean,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "node_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(18)   NOT NULL,
"epa_default" varchar(18)   NOT NULL,
"man_table" varchar(18)   NOT NULL,
"epa_table" varchar(18)   NOT NULL,
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "element_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(18),
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "connec_type" (
"id" varchar(30)   NOT NULL,
"type" character varying(18) NOT NULL,
"man_table" character varying(18) NOT NULL,
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT connec_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "point_type" (
"id" varchar(30)   NOT NULL,
"text" text,
"descript" text,
CONSTRAINT point_type_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table: domain value system structure 
-- ----------------------------


CREATE TABLE arc_type_cat_type
(
  id character varying(18) NOT NULL,
  descript text,
  shortcut_key text,
  order by int2,
  choose_hemisphere boolean,
  i18n character varying(30),
  CONSTRAINT arc_type_cat_type_pkey PRIMARY KEY (id)
)


CREATE TABLE node_type_cat_type
(
  id character varying(18) NOT NULL,
  descript text,
  shortcut_key text,
  order by int2,
  choose_hemisphere boolean,
  i18n character varying(30),
  CONSTRAINT node_type_cat_type_pkey PRIMARY KEY (id)
)



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
"arctype_id" varchar(30)  ,
"matcat_id" varchar(30)  ,
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
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
"active" boolean,
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_node" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_node_seq'::regclass) NOT NULL,
"nodetype_id" varchar(30)  ,
"matcat_id" varchar(30)  ,
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
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
"active" boolean,
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
"svg" varchar(50),
"active" boolean,
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_connec" (
"id" varchar(30)   NOT NULL,
"connectype_id" varchar(18)  ,
"matcat_id" varchar(16)  ,
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50),
"active" boolean,
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
"id" varchar(30) NOT NULL,
"descript" varchar(512),
"link" varchar(512),
"picture" varchar(512),
workid_key1 character varying(30),
workid_key2 character varying(30),
builtdate date,
"the_geom" public.geometry(MULTIPOLYGON, SRID_VALUE),
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
id varchar (30),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512)  ,
"thickness" numeric(12,2) DEFAULT 0.00,
"m2_cost" varchar (16),
 CONSTRAINT cat_pavement_pkey PRIMARY KEY (id)
 );
 
 
 CREATE TABLE "cat_press_zone" (
id varchar (30),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_press_zone_pkey PRIMARY KEY (id)
 );


 CREATE TABLE "cat_type" (
"id" varchar (30),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_type_pkey PRIMARY KEY (id)
 );
 
 
 CREATE TABLE "cat_brand" (
"id" varchar (30),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_brand_pkey PRIMARY KEY (id)
 );

 
 CREATE TABLE "cat_brand_type" (
"id" varchar (30),
"catbrand_id" varchar (30) NOT NULL,
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_brand_type_pkey PRIMARY KEY (id)
 );
 
 


-----------
-- Table: value domain (type)
-----------

CREATE TABLE "man_type_function" (
"id" varchar(50) NOT NULL,
"observ" varchar(50),
CONSTRAINT man_type_function_pkey PRIMARY KEY (id)
);


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

CREATE TABLE exploitation(
expl_id integer  NOT NULL PRIMARY KEY,
short_descript character varying(30) NOT NULL,
descript text,
undelete boolean,
the_geom geometry(POLYGON,SRID_VALUE)
);


CREATE TABLE macrodma(
macrodma_id integer NOT NULL PRIMARY KEY,
short_descript character varying(30)NOT NULL,
expl_id integer NOT NULL,
descript character varying(100),
undelete boolean,
the_geom geometry(POLYGON,SRID_VALUE)
);


CREATE TABLE "dma" (
"dma_id" integer NOT NULL PRIMARY KEY,
"short_descript" character varying(30)NOT NULL,
"macrodma_id" integer NOT NULL,
"presszonecat_id" varchar(30),
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);


CREATE TABLE "sector" (
"sector_id" integer NOT NULL PRIMARY KEY,
"short_descript" character varying(30)NOT NULL,
"expl_id" integer NOT NULL,
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);



CREATE TABLE "node" (
"node_id" varchar(16) NOT NULL,
"code" varchar (30) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) NOT NULL,,
"epa_type" varchar(16) NOT NULL,,
"sector_id" integer NOT NULL,
"state" int2 NOT NULL,
"annotation" text,
"observ" text,
"dma_id" integer NOT NULL,
"soilcat_id" varchar(30)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(30),
"rotation" numeric (6,3),
"the_geom" public.geometry (POINT, SRID_VALUE) NOT NULL,,
"undelete" boolean,
"workcat_id_end" character varying(255)
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"hemisphere" float,
CONSTRAINT node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "arc" (
"arc_id" varchar(16) NOT NULL,
"code" varchar (30) NOT NULL,
"node_1" varchar(16) NOT NULL, 
"node_2" varchar(16) NOT NULL, 
"arccat_id" varchar(30)  NOT NULL,
"epa_type" varchar(16)   NOT NULL,
"sector_id" integer NOT NULL,
"state" int2  NOT NULL,,
"annotation" text,
"observ" text,
"custom_length" numeric (12,2),
"dma_id" integer NOT NULL,		
"soilcat_id" varchar(30)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(30)  ,
"the_geom" public.geometry (LINESTRING, SRID_VALUE)  NOT NULL,,
"undelete" boolean,
"workcat_id_end" character varying(255),
"end_date" date,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE "connec" (
"connec_id" varchar (16) DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"code" varchar (30) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connec_type" character varying(30),
"connecat_id" varchar(30) NOT NULL,
"sector_id" integer NOT NULL,
"crm_code" varchar(30),
"n_hydrometer" int4,
"state" int2 NOT NULL
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" integer NOT NULL,
"soilcat_id" varchar(16),
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date ,
"ownercat_id" varchar(30)  ,
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"streetaxis_id" varchar (16)  ,
"postnumber" varchar (16)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"workcat_id_end" character varying(255),
"end_date" date,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);


CREATE TABLE polygon(
pol_id character varying(16) NOT NULL PRIMARY KEY,
pol_type varchar(30),
text text,
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean
);



CREATE TABLE "vnode" (
"vnode_id" serial NOT NULL PRIMARY KEY,
"arc_id" varchar(16),
"vnode_type" varchar(18),
"dma_id" integer NOT NULL,  
"state" int2 NOT NULL, 
"annotation" varchar(254),
"userdefined_pos" bool,
"the_geom" public.geometry (POINT, SRID_VALUE)
);


CREATE TABLE "link" (
link_id serial NOT NULL PRIMARY KEY,
feature_id varchar(16),
featurecat_id varchar(30), 
vnode_id integer NOT NULL,
custom_length numeric (12,3),
the_geom public.geometry (LINESTRING, SRID_VALUE)
);



CREATE TABLE "point" (
"point_id" varchar(30)   NOT NULL,
"point_type" varchar(18),
"dma_id" integer,
"state" int2 NOT NULL,
"observ" character varying(512),
"text" text,
"link" text,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
CONSTRAINT point_pkey PRIMARY KEY (point_id)
);



CREATE TABLE "presszone" (
"presszone_id" varchar (30) NOT NULL,
"text" text,
CONSTRAINT presszone_pkey PRIMARY KEY (id)
);


CREATE TABLE "pond"(
"pond_id" character varying(16) NOT NULL,
"connec_id" character varying(16),
"dma_id" integer NOT NULL,
"state" int2 NOT NULL,
"the_geom" geometry(Point,SRID_VALUE),
CONSTRAINT man_pond_pkey PRIMARY KEY (pond_id)
);


CREATE TABLE "pool"(
"pool_id" character varying(16) NOT NULL,
"connec_id" character varying(16),
"dma_id" integer NOT NULL,
"state" int2 NOT NULL,
"the_geom" geometry(Point,SRID_VALUE),
CONSTRAINT man_pool_pkey PRIMARY KEY (pool_id)
  );
  
  
CREATE TABLE "samplepoint"(
"sample_id" character varying(16) NOT NULL,
"samplepoint_state" character varying(150),
"rotation" numeric(12,3),
"code_lab" integer,
"element_type" character varying(150),
"workcat_id" character varying(255),
"workcat_id_end" character varying(255),
"street1" character varying(254),
"street2" character varying(254),
"place" character varying(254),
"element_code" integer,
"cabinet" character varying(150),
"dma_id" integer,
"state" int2,
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
"pol_id" varchar(16),
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
"broken" boolean DEFAULT true,
"buried" character varying(16),
"irrigation_indicator" character varying(16),
"depth_valveshaft" numeric(12,3),
"lin_meters" numeric(12,3),
"exit_type" character varying(100),
"exit_code" integer,
"location" character varying(254),
"valve_diam" numeric(12,3),
"valve" character varying(30),
"cat_valve2" character varying(30),
CONSTRAINT man_valve_pkey PRIMARY KEY (node_id)
);



CREATE TABLE "man_pump" (
"node_id" varchar(16) NOT NULL,
"flow" numeric(12,4),
"power" numeric(12,4),
"elev_height" numeric(12,4),
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
"pol_id" character varying(16)
"linked_connec" character varying(16),
"vmax" numeric(12,3),
"vtotal" numeric(12,3),
"container_number" integer,
"pump_number" integer,
"power" numeric(12,3),
"regulation_tank" character varying(150),
"name" character varying(254),
"connection" character varying(100),
"chlorinator" character varying(100),
"add_info" varchar(255),
  CONSTRAINT man_fountain_pkey PRIMARY KEY (connec_id)
 );
  
  
  CREATE TABLE "man_greentap"(
"connec_id" character varying(16) NOT NULL,
"linked_connec" character varying(16),
"add_info" character varying(255),
CONSTRAINT man_greentap_pkey PRIMARY KEY (connec_id)
 );
  
  
CREATE TABLE "man_tap"(
"connec_id" character varying(16) NOT NULL,
"linked_connec" character varying(16)
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
"cat_valve2" character varying(30),
"add_info" varchar(255),
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
"cat_valve2" character varying(30),
"add_info" varchar(255),
CONSTRAINT man_wjoin_pkey PRIMARY KEY (connec_id)
);


CREATE TABLE "man_register" (
"node_id" varchar(16) NOT NULL,
"pol_id" varchar(16),
"add_info" varchar(255),
CONSTRAINT man_register_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_netwjoin" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
"demand numeric"(12,8),
"streetaxis_id" character varying(16),
"postnumber" character varying(16),
"top_floor" integer,
"lead_verified" date,
"lead_facade" character varying(254),
"cat_valve2" character varying(30),
"add_info" varchar(255),
CONSTRAINT man_netwjoin_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_expansiontank" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_expansiontank_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_flexunion" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_flexunion_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_netsamplepoint"(
"node_id" varchar(16) NOT NULL,
"code_lab" character varying(30),
"add_info" varchar(255)
); 


CREATE TABLE "man_netelement"(
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255)
); 


CREATE TABLE "man_varc" (
"arc_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_varc_pkey PRIMARY KEY (arc_id)
);
 
 
-- ----------------------------
-- CUSTOM FIELDS
-- ----------------------------

DROP TABLE IF EXISTS man_custom_field_parameter;
CREATE TABLE man_custom_field_parameter(
field_id character varying (50) NOT NULL PRIMARY KEY,
descript character varying (254),
feature_type character varying (18) NOT NULL,
data_type character varying (18) NOT NULL,
not_null boolean,
fk_table character varying (50),
fk_key_field character varying (50),
fk_value_field character varying (50)
);


DROP TABLE IF EXISTS man_custom_field;
CREATE TABLE man_custom_field(
id serial NOT NULL PRIMARY KEY,
feature_id character varying (16),
field_id character varying (50) NOT NULL,
value character varying (50),
tstamp timestamp default now()
);
 
 
-- ----------------------------------
-- Table: Element
-- ----------------------------------

CREATE TABLE "element" (
"element_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_seq'::regclass) NOT NULL,
"code" varchar(30) NOT NULL,
"elementcat_id" varchar(30),
"dma_id" integer,
"state" int2 NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(30), ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"enddate" date,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20),
"workcat_id_end" varchar(30),
"end_date" date,
"the_geom" public.geometry (POINT, SRID_VALUE),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
CONSTRAINT element_pkey PRIMARY KEY (element_id)
);


CREATE TABLE "element_x_arc" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16) NOT NULL,
"arc_id" varchar(16) NOT NULL
);


CREATE TABLE "element_x_node" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16) NOT NULL,
"node_id" varchar(16) NOT NULL
);


CREATE TABLE "element_x_connec" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16) NOT NULL,
"connec_id" varchar(16) NOT NULL
);



-- ----------------------------------
-- Table: Dimensions
-- ----------------------------------



CREATE TABLE dimensions
(
  id bigserial NOT NULL,
  distance numeric(12,4),
  depth numeric(12,4),
  the_geom geometry(LineString,SRID_VALUE),
  x_label double precision,
  y_label double precision,
  rotation_label double precision,
  offset_label double precision,
  direction_arrow boolean,
  x_symbol double precision,
  y_symbol double precision,
  feature_id character varying,
  feature_type character varying,
  CONSTRAINT id PRIMARY KEY (id));
  


-- ----------------------------------
-- Table: value domain
-- ----------------------------------

CREATE TABLE "value_state" (
"id" int2 NOT NULL PRIMARY KEY, 
short_descript varchar(30) NOT NULL,
"observ" text
);


CREATE TABLE "value_verified" (
"id" varchar(30) NOT NULL PRIMARY KEY, 
"observ" text
);


CREATE TABLE "value_yesno" (
"id" varchar(30) NOT NULL PRIMARY KEY,
"observ" text
);


-- ----------------------------------
-- Table: selector
-- ----------------------------------


CREATE TABLE man_selector_valve (
"id" varchar(50) NOT NULL PRIMARY KEY
);


CREATE TABLE expl_selector (
expl_id integer NOT NULL PRIMARY KEY,
cur_user text
);

CREATE TABLE selector_psector (
psector_id integer NOT NULL PRIMARY KEY,
cur_user text
)

CREATE TABLE selector_state (
expl_id integer NOT NULL PRIMARY KEY,
cur_user text
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
CREATE INDEX element_index ON element USING GIST (the_geom);

