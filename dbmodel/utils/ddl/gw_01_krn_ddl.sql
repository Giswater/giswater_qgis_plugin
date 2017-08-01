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

	/*
CREATE SEQUENCE polygon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	*/
-- ----------------------------
-- Table: system structure 
-- ----------------------------

CREATE TABLE cat_feature(
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
"num_arcs" integer,
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
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50),
"active" boolean,
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
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



CREATE TABLE "sector" (
"sector_id" integer NOT NULL PRIMARY KEY,
"short_descript" character varying(30)NOT NULL,
"expl_id" integer NOT NULL,
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE)
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


 
  
CREATE TABLE "samplepoint"(
"sample_id" character varying(16) NOT NULL,
"samplepoint_state" character varying(150),
"rotation" numeric(12,3),
"code_lab" integer,
"feature_id" varchar (16),
"featurecat_id" varchar (30),
"workcat_id" character varying(255),
"workcat_id_end" character varying(255),
"street1" character varying(254),
"street2" character varying(254),
"place_name" character varying(254),
"cabinet" character varying(150),
"dma_id" integer,
"state" int2,
"observations" character varying(254),
"the_geom" geometry(Point,SRID_VALUE),
CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id)
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




-- ----------------------------------
-- Table: index
-- ----------------------------------



CREATE INDEX exploitation_index ON exploitation USING GIST (the_geom);
CREATE INDEX macrodma_index ON macrodma USING GIST (the_geom);
CREATE INDEX dma_index ON dma USING GIST (the_geom);
CREATE INDEX sector_index ON sector USING GIST (the_geom);
CREATE INDEX vnode_index ON vnode USING GIST (the_geom);
CREATE INDEX link_index ON link USING GIST (the_geom);
CREATE INDEX point_index ON point USING GIST (the_geom);
CREATE INDEX element_index ON element USING GIST (the_geom);


