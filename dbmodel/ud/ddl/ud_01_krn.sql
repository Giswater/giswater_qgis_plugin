/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- -----------------------------
-- SEQUENCES
-- -----------------------------



CREATE SEQUENCE "element_x_gully_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ----------------------------
-- Table structure for gully type
-- ----------------------------
CREATE TABLE "gully_type" (
"id" varchar(30)   ,
"type" character varying(30) ,
"man_table" character varying(30) ,
"active" boolean,
"code_autofill" boolean,
"descript" text,
"link_path" varchar(254),
CONSTRAINT gully_type_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------


CREATE TABLE "cat_mat_arc" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"n" numeric(12,4),
"link" varchar(512)  ,
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_mat_node" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_mat_gully" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_mat_gully_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_arc" (
"id" varchar (30) DEFAULT nextval ('"SCHEMA_NAME".cat_arc_seq'::regclass) NOT NULL,
"matcat_id" varchar (16)  ,
"shape" varchar(16),
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom5" numeric(12,4) DEFAULT 0.00,
"geom6" numeric(12,4) DEFAULT 0.00,
"geom7" numeric(12,4) DEFAULT 0.00,
"geom8" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20)  ,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50)  ,
"z1" numeric (12,2),
"z2" numeric (12,2),
"width" numeric (12,2),
"area" numeric (12,4),
"estimated_depth" numeric (12,2),
"bulk" numeric (12,2),
"cost_unit" varchar (3) DEFAULT 'm',
"cost" varchar (16),
"m2bottom_cost" varchar (16),
"m3protec_cost" varchar (16),
"active" boolean,
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
);





CREATE TABLE "cat_arc_shape" (
"id" varchar (30) NOT NULL PRIMARY KEY,
"epa" varchar(30),
"tsect_id" varchar(16),
"curve_id" varchar(16),
"image" varchar(50),
"descript" text,
"active" boolean
);


CREATE TABLE "cat_node_shape" (
"id" varchar (30) NOT NULL PRIMARY KEY,
"descript" text,
"active" boolean
);



CREATE TABLE "cat_node" (
"id" varchar (30) DEFAULT nextval ('"SCHEMA_NAME".cat_node_seq'::regclass) NOT NULL,
"matcat_id" varchar (16)  ,
"shape" character varying(50),
"geom1" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"value" numeric (12,2),
"descript" varchar(255)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50)  ,
"estimated_y" numeric (12,2),
"cost_unit" varchar (3) DEFAULT 'u',
"cost" varchar (16),
"active" boolean,
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
);



CREATE TABLE "cat_connec" (
"id" varchar(30)   NOT NULL,
"matcat_id" varchar (16)  ,
"shape" varchar(16)  ,
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20)  ,
"descript" varchar(255)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50)  ,
"cost_ut" character varying(16),
"cost_ml" character varying(16),
"cost_m3" character varying(16),
"active" boolean,
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_grate" (
"id" varchar(30)   NOT NULL,
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
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50)  ,
"cost_ut" character varying(16),
"active" boolean,
CONSTRAINT cat_grate_pkey PRIMARY KEY (id)
);




-- ----------------------------
-- Table: GIS features
-- ----------------------------


CREATE TABLE "node" (
"node_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".urn_id_seq'::regclass) NOT NULL,
"code" varchar (30),
"top_elev" numeric(12,3),
"ymax" numeric(12,3),
"elev" numeric(12,3),
"custom_top_elev" numeric(12,3),
"custom_ymax" numeric(12,3),
"custom_elev" numeric(12,3),
"sys_elev" numeric(12,3),
"node_type" varchar(30),
"nodecat_id" varchar(30),
"epa_type" varchar(16),
"sector_id" integer,
"state" int2,
"state_type" int2,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" integer,
"soilcat_id" varchar(16)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"workcat_id_end" character varying(255),
"buildercat_id" varchar(30)  ,
"builtdate" date,
"enddate" date,
"ownercat_id" varchar(30)  ,
"muni_id" integer ,
"postcode"  varchar(16) ,
"streetaxis_id" varchar(16)  ,
"postnumber" integer,
"postcomplement" varchar(100),
"streetaxis2_id" varchar(16)  ,
"postnumber2" integer,
"postcomplement2" varchar (100),
"descript" varchar(254)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20) ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"xyz_date" date,
"uncertain" boolean,
"unconnected" boolean,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type" varchar (16) DEFAULT 'NODE',
"tstamp" timestamp DEFAULT now(),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
);



CREATE TABLE "arc" (
"arc_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".urn_id_seq'::regclass) NOT NULL,
"code" varchar (30),
"node_1" varchar(16)  ,
"node_2" varchar(16)  ,
"y1" numeric (12,3) ,
"y2" numeric (12,3) ,
"elev1" numeric(12,3),
"elev2" numeric(12,3),
"custom_y1" numeric(12,3),
"custom_y2" numeric(12,3),
"custom_elev1" numeric(12,3),
"custom_elev2" numeric(12,3),
"sys_elev1" numeric(12,3),
"sys_elev2" numeric(12,3),
"arc_type" varchar(18),
"arccat_id" varchar(30),
"matcat_id" varchar(30),
"epa_type" varchar(16),
"sector_id" integer,
"state" int2  ,
"state_type" int2,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"sys_slope" numeric (12,4),
"inverted_slope" boolean,
"sys_length" numeric (12,2),
"custom_length" numeric (12,2),
"dma_id" integer ,
"soilcat_id" varchar(16)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"workcat_id_end" character varying(255),
"buildercat_id" varchar(30)  ,
"builtdate" date,
"enddate" date,
"ownercat_id" varchar(30)  ,
"muni_id" integer ,
"postcode"  varchar(16) ,
"streetaxis_id" varchar(16)  ,
"postnumber" integer,
"postcomplement" varchar(100),
"streetaxis2_id" varchar(16)  ,
"postnumber2" integer,
"postcomplement2" varchar (100),
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20),
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
"undelete" boolean,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"uncertain" boolean,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type" varchar (16) DEFAULT 'ARC',
"tstamp" timestamp DEFAULT now(),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE "connec" (
"connec_id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".urn_id_seq'::regclass) NOT NULL,
"code" varchar (30) ,
"top_elev" numeric(12,4),
"y1" numeric(12,4),
"y2" numeric(12,4),
"connec_type" character varying(30) ,
"connecat_id" varchar(30),
"sector_id" integer,
"customer_code" varchar(30),
"private_connecat_id" varchar(30),
"demand" numeric(12,8),
"state" int2,
"state_type" int2,
"connec_depth" numeric(12,3),
"connec_length" numeric(12,3),
"arc_id" varchar(16)  ,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" integer ,
"soilcat_id" varchar(16)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"workcat_id_end" character varying(255),
"buildercat_id" varchar(30)  ,
"builtdate" date,
"enddate" date,
"ownercat_id" varchar(30)  ,
"muni_id" integer ,
"postcode"  varchar(16) ,
"streetaxis_id" varchar(16)  ,
"postnumber" integer,
"postcomplement" varchar(100),
"streetaxis2_id" varchar(16)  ,
"postnumber2" integer,
"postcomplement2" varchar (100),
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20)  , 
"rotation" numeric (6,3),
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"featurecat_id" character varying(50),
"feature_id" character varying(16),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"accessibility" boolean,
"diagonal" character varying(50),
"publish" boolean,
"inventory" boolean,
"uncertain" boolean,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type" varchar (16) DEFAULT 'CONNEC',
"tstamp" timestamp DEFAULT now(),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);



CREATE TABLE "gully" (
"gully_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".urn_id_seq'::regclass) NOT NULL,
"code" varchar (30),
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"sandbox" numeric(12,4),
"matcat_id" varchar(18)  ,
"gully_type" varchar(30),
"gratecat_id" varchar(18)  ,
"units" int2,
"groove" boolean  ,
"siphon" boolean  ,
"connec_arccat_id" varchar(18)  ,
"connec_length" numeric(12,3),
"connec_depth" numeric(12,3),
"arc_id" varchar(16),
"pol_id" varchar(16),
"sector_id" integer,
"state" int2 ,
"state_type" int2,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" integer NOT NULL,
"soilcat_id" varchar(16)  ,
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"workcat_id_end" character varying(255),
"buildercat_id" varchar(30)  ,
"builtdate" date,
"enddate" date,
"ownercat_id" varchar(30)  ,
"muni_id" integer ,
"postcode"  varchar(16) ,
"streetaxis_id" varchar(16)  ,
"postnumber" integer,
"postcomplement" varchar(100),
"streetaxis2_id" varchar(16)  ,
"postnumber2" integer,
"postcomplement2" varchar (100),
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20),
"rotation" numeric (6,3),
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"featurecat_id" character varying(50),
"feature_id" character varying(16),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"uncertain" boolean,
"expl_id" integer ,
"num_value" numeric(12,3),
"feature_type" varchar (16) DEFAULT 'GULLY',
"tstamp" timestamp DEFAULT now(),
CONSTRAINT gully_pkey PRIMARY KEY (gully_id)
);


  
CREATE TABLE "samplepoint"(
"sample_id" character varying(16) DEFAULT nextval('"SCHEMA_NAME".sample_id_seq'::regclass) NOT NULL,
"code" varchar(30) ,
"lab_code" varchar(30),
"feature_id" varchar (16),
"featurecat_id" varchar (30),
"dma_id" integer,
"state" int2,
"builtdate" date,
"enddate" date,
"workcat_id" character varying(255),
"workcat_id_end" character varying(255),
"rotation" numeric(12,3),
"muni_id" integer ,
"postcode"  varchar(16) ,
"streetaxis_id" varchar(16)  ,
"postnumber" integer,
"postcomplement" varchar(100),
"streetaxis2_id" varchar(16)  ,
"postnumber2" integer,
"postcomplement2" varchar (100),
"place_name" character varying(254),
"cabinet" character varying(150),
"observations" character varying(254),
"verified" character varying(30),
"the_geom" geometry(Point,SRID_VALUE),
"expl_id" integer,
"tstamp" timestamp DEFAULT now(),
CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id)
);


-- ----------------------------
-- Table: Add info feature 
-- ----------------------------

CREATE TABLE "man_netinit" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"length" numeric(12,3),
"width" numeric(12,3),
"inlet" boolean,
"bottom_channel" boolean,
"accessibility" varchar(16),
"name" varchar(50),
"sander_depth" numeric(12,3)
);


CREATE TABLE "man_junction" (
"node_id" varchar(16) NOT NULL PRIMARY KEY
);


CREATE TABLE "man_manhole" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"length" numeric(12,3),
"width" numeric(12,3),
"sander_depth" numeric(12,3),
"prot_surface" bool,
"inlet" boolean,
"bottom_channel" boolean,
"accessibility" varchar(16)
);


CREATE TABLE "man_wjump" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"length" numeric(12,3),
"width" numeric(12,3),
"sander_depth" numeric(12,3),
"prot_surface" bool,
"accessibility" varchar(16),
"name" varchar(255)
);


CREATE TABLE "man_valve" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"name" varchar(255)
);


CREATE TABLE "man_outfall" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"name" varchar(255)
);


CREATE TABLE "man_netelement" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"serial_number" varchar(30)
);


CREATE TABLE "man_netgully" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"pol_id" character varying(16),
"sander_depth" numeric(12,4),
"gratecat_id" varchar(18)  ,
"units" int2,
"groove" boolean  ,
"siphon" boolean  
);


CREATE TABLE "man_chamber" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"pol_id" character varying(16),
"length" numeric(12,3),
"width" numeric(12,3),
"sander_depth" numeric(12,3),
"max_volume" numeric(12,3),
"util_volume" numeric(12,3),
"inlet" boolean,
"bottom_channel" boolean,
"accessibility" varchar(16),
"name" varchar(255)
);


CREATE TABLE "man_storage" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"pol_id" character varying(16),
"length" numeric(12,3),
"width" numeric(12,3),
"custom_area" numeric (12,3),
"max_volume" numeric(12,3),
"util_volume" numeric(12,3),
"min_height" numeric(12,3),
"accessibility" varchar(16),
"name" varchar(255)
);


CREATE TABLE "man_wwtp" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"pol_id" character varying(16),
"name" varchar(255)
);

CREATE TABLE "man_conduit" (
"arc_id" varchar(16) NOT NULL PRIMARY KEY
);

CREATE TABLE "man_siphon" (
"arc_id" varchar(16) NOT NULL PRIMARY KEY,
"name" varchar(255)
);


CREATE TABLE "man_waccel" (
"arc_id" varchar(16) NOT NULL PRIMARY KEY,
"sander_length" numeric(12,3),
"sander_depth" numeric(12,3),
"prot_surface" bool,
"accessibility" varchar(16),
"name" varchar(255)
);

CREATE TABLE "man_varc"(
"arc_id" character varying(16) NOT NULL PRIMARY KEY
);



 
-- ----------------------------------
-- Table: Element
-- ----------------------------------


CREATE TABLE "element_x_gully" (
"id" varchar(16) DEFAULT nextval ('"SCHEMA_NAME".element_x_gully_seq'::regclass) NOT NULL,
"element_id" varchar(16),
"gully_id" varchar(16),
CONSTRAINT element_x_gully_pkey PRIMARY KEY (id)
);

----------------
-- INDEX
----------------

CREATE INDEX arc_node1 ON arc(node_1);
CREATE INDEX arc_node2 ON arc(node_2);


----------------
-- SPATIAL INDEX
----------------
CREATE INDEX macrosector_index ON macrosector USING GIST (the_geom);
CREATE INDEX dma_index ON dma USING GIST (the_geom);
CREATE INDEX sector_index ON sector USING GIST (the_geom);
CREATE INDEX arc_index ON arc USING GIST (the_geom);
CREATE INDEX node_index ON node USING GIST (the_geom);
CREATE INDEX connec_index ON connec USING GIST (the_geom);
CREATE INDEX gully_index ON gully USING GIST (the_geom);
CREATE INDEX vnode_index ON vnode USING GIST (the_geom);
CREATE INDEX link_index ON link USING GIST (the_geom);

