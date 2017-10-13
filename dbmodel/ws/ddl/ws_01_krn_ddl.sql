/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

 

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




-- ----------------------------
-- Table: Catalogs
-- ----------------------------


CREATE TABLE "cat_mat_arc" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_mat_node" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_arc" (
"id" varchar (30) DEFAULT nextval('"SCHEMA_NAME".cat_arc_seq'::regclass) NOT NULL,
"arctype_id" varchar(30)  ,
"matcat_id" varchar(30)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"dext" numeric(12,5),
"descript" varchar(512)  ,
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
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"dext" numeric(12,5),
"shape" character varying(50),
"descript" varchar(512)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50)  ,
"estimated_depth" numeric (12,2),
"cost_unit" varchar (3),
"cost" varchar (16),
"active" boolean,
CONSTRAINT cat_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "cat_connec" (
"id" varchar(30)   NOT NULL,
"connectype_id" varchar(18)  ,
"matcat_id" varchar(16)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"dext" numeric(12,5),
"descript" varchar(512)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"model" varchar(30)  ,
"svg" varchar(50),
"cost_ut" character varying(16),
"cost_ml" character varying(16),
"cost_m3" character varying(16),
"active" boolean,
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);

 
 CREATE TABLE "cat_presszone" (
"id" varchar (30),
"descript" text,
"link" varchar(512)  ,
 CONSTRAINT cat_presszone_pkey PRIMARY KEY (id)
 );



-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE "macrodma"(
macrodma_id serial NOT NULL PRIMARY KEY,
name character varying(50),
expl_id integer,
descript character varying(100),
undelete boolean,
the_geom geometry(POLYGON,SRID_VALUE)
);

CREATE TABLE "dma" (
"dma_id" serial NOT NULL PRIMARY KEY,
"name" character varying(30),
"expl_id" integer,
"macrodma_id" integer,
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (POLYGON, SRID_VALUE)
);


CREATE TABLE "sector" (
"sector_id" serial NOT NULL PRIMARY KEY,
"name" character varying(50),
"descript" text,
"undelete" boolean,
"the_geom" public.geometry (POLYGON, SRID_VALUE)
);


CREATE TABLE "node" (
"node_id" varchar(16) NOT NULL,
"code" varchar (30) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) NOT NULL,
"epa_type" varchar(16) NOT NULL,
"sector_id" integer NOT NULL,
"state" int2 NOT NULL,
"state_type" int2,
"annotation" text,
"observ" text,
"comment" text,
"dma_id" integer NOT NULL,
"presszonecat_id" varchar(30),
"soilcat_id" varchar(30)  ,
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
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(30),
"rotation" numeric (6,3),
"the_geom" public.geometry (POINT, SRID_VALUE) NOT NULL,
"undelete" boolean,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"hemisphere" float,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type " varchar (16) DEFAULT 'NODE',
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
"state" int2  NOT NULL,
"state_type" int2,
"annotation" text,
"observ" text,
"comment" text,
"custom_length" numeric (12,2),
"dma_id" integer NOT NULL,	
"presszonecat_id" varchar(30),	
"soilcat_id" varchar(30)  ,
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
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(30)  ,
"the_geom" public.geometry (LINESTRING, SRID_VALUE)  NOT NULL,
"undelete" boolean,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type " varchar (16) DEFAULT 'ARC',
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE "connec" (
"connec_id" varchar (16) NOT NULL,
"code" varchar (30) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30) NOT NULL,
"sector_id" integer NOT NULL,
"customer_code" varchar(30),
"state" int2 NOT NULL,
"state_type" int2,
"connec_length" numeric(12,3),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" integer NOT NULL,
"presszonecat_id" varchar(30),
"soilcat_id" varchar(16),
"function_type" varchar(50)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"workcat_id_end" character varying(255),
"buildercat_id" varchar(30)  ,
"builtdate" date ,
"enddate" date,
"ownercat_id" varchar(30)  ,
"address_01" varchar(50)  ,
"address_02" varchar(50)  ,
"address_03" varchar(50)  ,
"streetaxis_id" varchar (16)  ,
"postnumber" varchar (16)  ,
"descript" varchar(254)  ,
"link" character varying(512),
"verified" varchar(20)  ,
"rotation" numeric (6,3),
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"label_x" character varying(30),
"label_y" character varying(30),
"label_rotation" numeric(6,3),
"publish" boolean,
"inventory" boolean,
"expl_id" integer,
"num_value" numeric(12,3),
"feature_type " varchar (16) DEFAULT 'CONNEC',
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);



CREATE TABLE "pond"(
"pond_id" character varying(16) NOT NULL,
"connec_id" character varying(16),
"dma_id" integer NOT NULL,
"state" int2 NOT NULL,
"the_geom" geometry(Point,SRID_VALUE),
"expl_id" integer,
CONSTRAINT man_pond_pkey PRIMARY KEY (pond_id)
);


CREATE TABLE "pool"(
"pool_id" character varying(16) NOT NULL,
"connec_id" character varying(16),
"dma_id" integer NOT NULL,
"state" int2 NOT NULL,
"the_geom" geometry(Point,SRID_VALUE),
"expl_id" integer,
CONSTRAINT man_pool_pkey PRIMARY KEY (pool_id)
  );
  
  



-- -----------------------------------
-- Table: Add info of GIS feature 
-- -----------------------------------

CREATE TABLE "man_junction" (
"node_id" varchar(16) PRIMARY KEY
);


CREATE TABLE "man_tank" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"pol_id" varchar(16),
"vmax" numeric (12,4),
"vutil" numeric (12,4),
"area" numeric (12,4),
"chlorination" character varying(255),
"name" varchar (50)
);


CREATE TABLE "man_hydrant" (
"node_id" varchar(16) NOT NULL,
"fire_code" varchar(30) NOT NULL,
"communication" character varying(254),
"valve" character varying(100),
"valve_diam" numeric(12,3),
CONSTRAINT man_hydrant_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_valve" (
"node_id" varchar(16) NOT NULL,
"closed" boolean DEFAULT true,
"broken" boolean DEFAULT true,
"buried" character varying(16),
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
"valve_diam" numeric(12,3),
"cat_valve2" character varying(30),
"arc_id" character varying(16),
CONSTRAINT man_valve_pkey PRIMARY KEY (node_id)
);



CREATE TABLE "man_pump" (
"node_id" varchar(16) NOT NULL,
"max_flow" numeric(12,4),
"min_flow" numeric(12,4),
"nom_flow" numeric(12,4),
"power" numeric(12,4),
"pressure" numeric(12,4),
"elev_height" numeric(12,4),
"name" varchar (50),
CONSTRAINT man_pump_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_filter" (
"node_id" varchar(16) NOT NULL,
CONSTRAINT man_filter_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_meter" (
"node_id" varchar(16) NOT NULL,
CONSTRAINT man_meter_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_pipe" (
"arc_id" varchar(16) NOT NULL,
CONSTRAINT man_pipe_pkey PRIMARY KEY (arc_id)
);

  CREATE TABLE "man_manhole"(
"node_id" character varying(16) NOT NULL,
"name" varchar (50),
CONSTRAINT man_manhole_pkey PRIMARY KEY (node_id)
);

CREATE TABLE "man_reduction"(
"node_id" character varying(16) NOT NULL,
"diam1" numeric(12,3),
"diam2" numeric(12,3),
CONSTRAINT man_reduction_pkey PRIMARY KEY (node_id)
  );

CREATE TABLE "man_source"(
"node_id" character varying(16) NOT NULL,
"name" varchar (50),
CONSTRAINT man_source_pkey PRIMARY KEY (node_id)
  );
  
CREATE TABLE "man_waterwell"(
"node_id" character varying(16) NOT NULL,
"name" varchar (50),
CONSTRAINT man_waterwell_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_register" (
"node_id" varchar(16) NOT NULL,
"pol_id" varchar(16),
CONSTRAINT man_register_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_netwjoin" (
"node_id" varchar(16) NOT NULL,
"customer_code" varchar(30),
"streetaxis_id" character varying(16),
"postnumber" character varying(16), 
"top_floor" integer,
"cat_valve" character varying(30),
CONSTRAINT man_netwjoin_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_expansiontank" (
"node_id" varchar(16) NOT NULL PRIMARY KEY
);


CREATE TABLE "man_flexunion" (
"node_id" varchar(16) NOT NULL PRIMARY KEY
);

CREATE TABLE "man_wtp" (
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"name" varchar(50)
);

CREATE TABLE "man_netsamplepoint"(
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"lab_code" character varying(30)
); 


CREATE TABLE "man_netelement"(
"node_id" varchar(16) NOT NULL PRIMARY KEY,
"serial_number" varchar(30)
); 


CREATE TABLE "man_varc" (
"arc_id" varchar(16) NOT NULL,
CONSTRAINT man_varc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE "man_fountain"(
"connec_id" character varying(16) NOT NULL,
"pol_id" character varying(16),
"linked_connec" character varying(16),
"vmax" numeric(12,3),
"vtotal" numeric(12,3),
"container_number" integer,
"pump_number" integer,
"power" numeric(12,3),
"regulation_tank" character varying(150),
"chlorinator" character varying(100),
"arq_patrimony" boolean,
"name" character varying(254),
 CONSTRAINT man_fountain_pkey PRIMARY KEY (connec_id)
 );
  
  
 CREATE TABLE "man_greentap"(
"connec_id" character varying(16) NOT NULL,
"linked_connec" character varying(16),
CONSTRAINT man_greentap_pkey PRIMARY KEY (connec_id)
 );
  
  
CREATE TABLE "man_tap"(
"connec_id" character varying(16) NOT NULL,
"linked_connec" character varying(16),
"cat_valve" character varying(30),
"drain_diam" numeric(12,3),
"drain_exit" character varying(100),
"drain_gully" character varying(100),
"drain_distance" numeric(12,3),
"arq_patrimony" boolean,
"com_state" character varying(254),
CONSTRAINT man_tap_pkey PRIMARY KEY (connec_id)
);
  
  
CREATE TABLE "man_wjoin"(
"connec_id" character varying(16) NOT NULL,
"top_floor" integer,
"cat_valve" character varying(30),
CONSTRAINT man_wjoin_pkey PRIMARY KEY (connec_id)
);




----------------
-- SPATIAL INDEX
----------------

CREATE INDEX macrodma_index ON macrodma USING GIST (the_geom);
CREATE INDEX dma_index ON dma USING GIST (the_geom);
CREATE INDEX sector_index ON sector USING GIST (the_geom);
CREATE INDEX arc_index ON arc USING GIST (the_geom);
CREATE INDEX node_index ON node USING GIST (the_geom);
CREATE INDEX connec_index ON connec USING GIST (the_geom);
CREATE INDEX vnode_index ON vnode USING GIST (the_geom);
CREATE INDEX link_index ON link USING GIST (the_geom);

