/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Sequences
-- --------------------------


CREATE SEQUENCE sample_id_seq
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

CREATE TABLE cat_feature(
id character varying(30) NOT NULL,
feature_type character varying(30),
"descript" text,
CONSTRAINT cat_feature_pkey PRIMARY KEY (id)
);

 
CREATE TABLE "arc_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(30)   NOT NULL,
"epa_default" varchar(30)   NOT NULL,
"man_table" varchar(30)   NOT NULL,
"epa_table" varchar(30)   NOT NULL,
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "node_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(30)   NOT NULL,
"epa_default" varchar(30)   NOT NULL,
"man_table" varchar(30)   NOT NULL,
"epa_table" varchar(30)   NOT NULL,
"active" boolean,
"code_autofill" boolean,
"num_arcs" integer,
"choose_hemisphere" boolean,
"descript" text,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "element_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(30),
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "connec_type" (
"id" varchar(30)   NOT NULL,
"type" character varying(30) NOT NULL,
"man_table" character varying(30) NOT NULL,
"active" boolean,
"code_autofill" boolean,
"descript" text,
CONSTRAINT connec_type_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table: domain value system structure 
-- ----------------------------


CREATE TABLE arc_type_cat_type (
  id character varying(30) NOT NULL,
  shortcut_key varchar(30) ,
  orderby int2,
  i18n character varying(30),
  descript text,
  CONSTRAINT arc_type_cat_type_pkey PRIMARY KEY (id)
);


CREATE TABLE node_type_cat_type (
  id character varying(30) NOT NULL,
  shortcut_key varchar(30),
  orderby int2,
  i18n character varying(30),
  descript text,
  CONSTRAINT node_type_cat_type_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table: Catalogs
-- ----------------------------

CREATE TABLE "cat_mat_element" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_element" (
"id" varchar(30)   NOT NULL,
"elementtype_id" varchar(30)  ,
"matcat_id" varchar(30)  ,
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50),
"active" boolean,
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_soil" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512),
"link" varchar(512),
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
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_work" (
"id" varchar(30) NOT NULL,
"descript" varchar(512),
"link" varchar(512),
workid_key1 character varying(30),
workid_key2 character varying(30),
builtdate date,
"the_geom" public.geometry(POLYGON, SRID_VALUE),
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_owner" (
"id" varchar(30)   NOT NULL,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_owner_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_pavement" (
id varchar (30),
"descript" text,
"link" varchar(512)  ,
"thickness" numeric(12,2) DEFAULT 0.00,
"m2_cost" varchar (16),
 CONSTRAINT cat_pavement_pkey PRIMARY KEY (id)
 );
 

 CREATE TABLE "cat_brand" (
"id" varchar (30),
"descript" text,
"link" varchar(512),
 CONSTRAINT cat_brand_pkey PRIMARY KEY (id)
 );

 CREATE TABLE "cat_brand_model" (
"id" varchar (30),
"catbrand_id" varchar (30) NOT NULL,
"descript" text,
"link" varchar(512)  ,
 CONSTRAINT cat_brand_type_pkey PRIMARY KEY (id)
 );
 


-----------
-- Table: value domain (type)
-----------


CREATE TABLE "man_type_function" (
"id" varchar(50) NOT NULL,
"featurecat_id" varchar(30),
"observ" varchar(50),
CONSTRAINT man_type_function_pkey PRIMARY KEY (id)
);

CREATE TABLE "man_type_category" (
"id" varchar(50) NOT NULL,
"featurecat_id" varchar(30),
"observ" varchar(50),
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_fluid" (
"id" varchar(50) NOT NULL,
"featurecat_id" varchar(30),
"observ" varchar(50),
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_location" (
"id" varchar(50) NOT NULL,
"featurecat_id" varchar(30),
"observ" varchar(50),
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);





-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE exploitation(
expl_id integer  NOT NULL PRIMARY KEY,
name character varying(50) NOT NULL,
descript text,
undelete boolean,
the_geom geometry(POLYGON,SRID_VALUE)
);



CREATE TABLE polygon(
pol_id character varying(16) NOT NULL PRIMARY KEY,
pol_type varchar(30),
text text,
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean
);


  
CREATE TABLE "samplepoint"(
"sample_id" character varying(16) NOT NULL,
"code" varchar(30) ,
"lab_code" integer,
"feature_id" varchar (16),
"featurecat_id" varchar (30),
"dma_id" integer,
"state" int2,
"workcat_id" character varying(255),
"workcat_id_end" character varying(255),
"rotation" numeric(12,3),
"street1" character varying(254),
"street2" character varying(254),
"place_name" character varying(254),
"cabinet" character varying(150),
"observations" character varying(254),
"the_geom" geometry(Point,SRID_VALUE),
"expl_id" integer,
CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id)
);



 
 
-- ----------------------------------
-- Table: Element
-- ----------------------------------

CREATE TABLE "element" (
"element_id" varchar(16) NOT NULL,
"code" varchar(30),
"elementcat_id" varchar(30),
"serial_number" varchar(30),
"dma_id" integer,
"state" int2 NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(30), 
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20),
"workcat_id_end" varchar(30),
"enddate" date,
"the_geom" public.geometry (POINT, SRID_VALUE),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"expl_id" integer,
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
-- Table: value domain
-- ----------------------------------

CREATE TABLE "value_state" (
"id" int2 NOT NULL PRIMARY KEY, 
name varchar(30) NOT NULL,
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
-- Table: index
-- ----------------------------------



CREATE INDEX exploitation_index ON exploitation USING GIST (the_geom);
CREATE INDEX element_index ON element USING GIST (the_geom);


