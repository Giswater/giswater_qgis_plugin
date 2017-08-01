/*
This file is part of Giswater 2.0
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
"url" varchar(512)  ,
"picture" varchar(512)  ,
CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE "cat_mat_node" (
"id" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
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
"type" varchar(30)  ,
"model" varchar(30)  ,
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
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
"dint" numeric(12,5),
"geometry" varchar(30)  ,
"descript" varchar(512)  ,
"link" varchar(512)  ,
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
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
"brand" varchar(30)  ,
"type" varchar(30)  ,
"model" varchar(30)  ,
"pnom" varchar(16)  ,
"dnom" varchar(16)  ,
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
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


 
 CREATE TABLE "cat_presszone" (
"id" varchar (30),
"descript" text,
"link" varchar(512)  ,
"picture" varchar(512),
 CONSTRAINT cat_presszone_pkey PRIMARY KEY (id)
 );

 


-- ----------------------------
-- Table: GIS features
-- ----------------------------

CREATE TABLE "dma" (
"dma_id" integer NOT NULL PRIMARY KEY,
"short_descript" character varying(30)NOT NULL,
"macrodma_id" integer NOT NULL,
"presszonecat_id" varchar(30),
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
"cat_valve2" character varying(30),
"arc_id" character varying(16),
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
 
 
-- ----------------------------------
-- Table: selector
-- ----------------------------------


CREATE TABLE man_selector_valve (
"id" varchar(50) NOT NULL PRIMARY KEY
);



----------------
-- SPATIAL INDEX
----------------

CREATE INDEX arc_index ON arc USING GIST (the_geom);
CREATE INDEX node_index ON node USING GIST (the_geom);
CREATE INDEX connec_index ON connec USING GIST (the_geom);

