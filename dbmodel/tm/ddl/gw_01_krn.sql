/*
This file is part of Giswater 3
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





	
-- ----------------------------
-- Table: system structure 
-- ----------------------------
CREATE TABLE "cat_users"(
id varchar(50) NOT NULL PRIMARY KEY,
"name" varchar(150),
"context" varchar(50)
);


CREATE TABLE "cat_feature"(
id character varying(30) NOT NULL,
system_id character varying(30),
feature_type character varying(30),
CONSTRAINT cat_feature_pkey PRIMARY KEY (id)
);

 
CREATE TABLE "arc_type" (
"id" varchar(30) ,
"type" varchar(30) ,
"epa_default" varchar(30)  ,
"man_table" varchar(30) ,
"epa_table" varchar(30) ,
"active" boolean,
"code_autofill" boolean,
"descript" text,
"link_path" varchar(254),
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "node_type" (
"id" varchar(30)   NOT NULL,
"type" varchar(30),
"epa_default" varchar(30) ,
"man_table" varchar(30) ,
"epa_table" varchar(30),
"active" boolean,
"code_autofill" boolean,
"num_arcs" integer,
"choose_hemisphere" boolean,
"descript" text,
"link_path" varchar(254),
CONSTRAINT node_type_pkey PRIMARY KEY (id)
);



CREATE TABLE "connec_type" (
"id" varchar(30)   NOT NULL,
"type" character varying(30),
"man_table" character varying(30),
"active" boolean,
"code_autofill" boolean,
"descript" text,
"link_path" varchar(254),
CONSTRAINT connec_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "element_type" (
"id" varchar(30)   NOT NULL,
"active" boolean,
"code_autofill" boolean,
"descript" text,
"link_path" varchar(254),
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table: domain value system structure 
-- ----------------------------


CREATE TABLE sys_feature_type (
  id character varying(30)  PRIMARY KEY,
  net_category smallint
);


CREATE TABLE sys_feature_cat (
  id character varying(30) PRIMARY KEY,
  type character varying(30),
  orderby integer,
  tablename character varying(100),
  shortcut_key character varying(100)
);





-- ----------------------------
-- Table: Catalogs
-- ----------------------------

CREATE TABLE "cat_arc_class" (
"id" serial PRIMARY KEY,
"arc_id" varchar(30),
"class_type" integer,
"catclass_id" integer
);


CREATE TABLE "cat_arc_class_cat" (
"id" serial PRIMARY KEY,
"class_type" integer,
"catclass_id" integer,
"name" varchar(50),
"from_val" text,
"to_val" text,
"observ" text
);


CREATE TABLE "cat_arc_class_type" (
"id" serial PRIMARY KEY,
"name" varchar(50),
"observ" text
);

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
"catbrand_id" varchar (30),
"descript" text,
"link" varchar(512)  ,
 CONSTRAINT cat_brand_type_pkey PRIMARY KEY (id)
 );
 
 
 -----------
-- Temporal tables
-----------
 

CREATE TABLE temp_table (
id serial PRIMARY KEY,
fprocesscat_id smallint,
text_column text,
geom_point public.geometry(POINT, SRID_VALUE),
geom_line public.geometry(LINESTRING, SRID_VALUE),
geom_polygon public.geometry(MULTIPOLYGON, SRID_VALUE),
user_name text DEFAULT current_user
);



 -----------
-- Link/ vnode
-----------



CREATE TABLE "vnode" (
"vnode_id" serial NOT NULL PRIMARY KEY,
"vnode_type" varchar(30),
"annotation" varchar(254),
"sector_id" integer,
"dma_id" integer,
"state" int2,
"expl_id" integer,
"the_geom" public.geometry (POINT, SRID_VALUE),
"tstamp" timestamp DEFAULT now()
);



CREATE TABLE "link" (
link_id serial NOT NULL PRIMARY KEY,
feature_id varchar(16),
feature_type varchar(16), 
exit_id varchar(16),
exit_type varchar(16), 
userdefined_geom bool,
"state" int2,
expl_id integer,
the_geom public.geometry (LINESTRING, SRID_VALUE),
tstamp timestamp DEFAULT now()
);



-----------
-- Table: value domain (type)
-----------


CREATE TABLE "man_type_function" (
"id" serial NOT NULL,
"function_type" varchar(50),
"feature_type" varchar(30),
"featurecat_id" varchar(300),
"observ" varchar(150),
CONSTRAINT man_type_function_pkey PRIMARY KEY (id)
);

CREATE TABLE "man_type_category" (
"id" serial NOT NULL,
"category_type" varchar(50),
"feature_type" varchar(30),
"featurecat_id" varchar(300),
"observ" varchar(150),
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_fluid" (
"id" serial NOT NULL,
"fluid_type" varchar(50),
"feature_type" varchar(30),
"featurecat_id" varchar(300),
"observ" varchar(150),
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "man_type_location" (
"id" serial NOT NULL,
"location_type" varchar(50),
"feature_type" varchar(30),
"featurecat_id" varchar(300),
"observ" varchar(150),
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);





-- ----------------------------
-- Table: GIS map zones
-- ----------------------------

CREATE TABLE "macroexploitation"(
macroexpl_id integer NOT NULL PRIMARY KEY,
name character varying(50) ,
descript character varying(100),
undelete boolean
);


CREATE TABLE exploitation(
expl_id integer  NOT NULL PRIMARY KEY,
name character varying(50),
macroexpl_id integer,
descript text,
undelete boolean,
the_geom geometry(MULTIPOLYGON,SRID_VALUE),
tstamp timestamp DEFAULT now()
);


CREATE TABLE "macrodma"(
macrodma_id serial NOT NULL PRIMARY KEY,
name character varying(50) ,
expl_id integer,
descript text,
undelete boolean,
the_geom geometry(MULTIPOLYGON,SRID_VALUE)
);


CREATE TABLE "dma" (
"dma_id" serial NOT NULL PRIMARY KEY,
"name" character varying(30),
"expl_id" integer,
"macrodma_id" integer,
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);


CREATE TABLE macrosector (
macrosector_id serial NOT NULL PRIMARY KEY,
name character varying(50),
descript text,
undelete boolean,
the_geom geometry (MULTIPOLYGON, SRID_VALUE)
);


CREATE TABLE "sector" (
"sector_id" serial NOT NULL PRIMARY KEY,
"name" character varying(50),
"macrosector_id" integer,
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
);



CREATE TABLE exploitation_x_user(
id SERIAL PRIMARY KEY,
expl_id integer,
username character varying(50)
);



-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE polygon(
pol_id character varying(16) NOT NULL PRIMARY KEY,
sys_type varchar(30),
text text,
the_geom geometry(MULTIPOLYGON,SRID_VALUE),
undelete boolean,
tstamp timestamp DEFAULT now()
);



CREATE TABLE "element" (
"element_id" varchar(16) PRIMARY KEY DEFAULT nextval('SCHEMA_NAME.urn_id_seq'::regclass),
"code" varchar(30),
"elementcat_id" varchar(30),
"serial_number" varchar(30),
"num_elements" integer,
"state" int2,
"state_type" int2,
"observ" character varying(254),
"comment" character varying(254),
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(30), 
"workcat_id_end" varchar(30),
"buildercat_id" varchar(30)  ,
"builtdate" date,
"enddate" date,
"ownercat_id" varchar(30)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20),
"the_geom" public.geometry (POINT, SRID_VALUE),
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"undelete" boolean,
"publish" boolean,
"inventory" boolean,
"expl_id" integer,
"feature_type" varchar (16) DEFAULT 'ELEMENT',
"tstamp" timestamp DEFAULT now()
);


CREATE TABLE "element_x_arc" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16),
"arc_id" varchar(16)
);


CREATE TABLE "element_x_node" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16),
"node_id" varchar(16)
);


CREATE TABLE "element_x_connec" (
"id" serial8 NOT NULL PRIMARY KEY,
"element_id" varchar(16),
"connec_id" varchar(16)
);




-- ----------------------------------
-- Table: value domain
-- ----------------------------------

CREATE TABLE "value_state" (
"id" int2 NOT NULL PRIMARY KEY, 
name varchar(30),
"observ" text
);

CREATE TABLE "value_state_type" (
"id" int2 NOT NULL PRIMARY KEY, 
state int2,
name varchar(30),
is_operative boolean,
is_doable boolean
);

CREATE TABLE "value_verified" (
"id" varchar(30) NOT NULL PRIMARY KEY, 
"observ" text
);


CREATE TABLE "value_yesno" (
"id" varchar(30) NOT NULL PRIMARY KEY,
"observ" text
);


CREATE TABLE value_priority (
id character varying(16) NOT NULL PRIMARY KEY,
observ character varying(254)
);



CREATE TABLE value_review_status(  
id smallint PRIMARY KEY,
descript text,
name text);

CREATE TABLE value_review_validation( 
id smallint PRIMARY KEY,
name text);

-- ----------------------------------
-- Table: index
-- ----------------------------------



CREATE INDEX exploitation_index ON exploitation USING GIST (the_geom);
CREATE INDEX element_index ON element USING GIST (the_geom);


