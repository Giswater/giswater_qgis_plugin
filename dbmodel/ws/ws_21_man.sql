/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Sequences
-- --------------------------

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

    

-----------------
-- SYSTEM TABLE
-----------------

CREATE TABLE "SCHEMA_NAME"."element_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"event_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);



-----------------
-- CATALOGS
-----------------

CREATE TABLE "SCHEMA_NAME"."cat_mat_element" (
"id" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_element" (
"id" varchar(30) COLLATE "default" NOT NULL,
"elementtype_id" varchar(30) COLLATE "default",
"matcat_id" varchar(30) COLLATE "default",
"geometry" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_connec" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"matcat_id" varchar(16) COLLATE "default",
"pnom" varchar(16) COLLATE "default",
"dnom" varchar(16) COLLATE "default",
"geometry" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_soil" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_builder" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_work" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."cat_owner" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_owner_pkey PRIMARY KEY (id)
);



-----------
-- TYPE
-----------

CREATE TABLE "SCHEMA_NAME"."man_type_category" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."man_type_fluid" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."man_type_location" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."type_connec" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT type_connec_pkey PRIMARY KEY (id)
);



--------------------
-- Table structure
--------------------

CREATE TABLE "SCHEMA_NAME"."dma" (
"dma_id" varchar(30) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"observ" character varying(512),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
);


CREATE TABLE "SCHEMA_NAME"."connec" (
"connec_id" varchar (16) DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"code" varchar(30) COLLATE "default",
"n_hydrometer" int4,
"demand" numeric(12,8),
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" varchar(12) COLLATE "default",
"ownercat_id" varchar(30) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(16) COLLATE "default",
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);


CREATE TABLE "SCHEMA_NAME"."link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
connec_id varchar(16) COLLATE "default" NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
);



-- -----------------------------------
-- Table structure for node features
-- -----------------------------------

CREATE TABLE "SCHEMA_NAME"."man_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_junction_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_tank" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"vmax" numeric (12,4),
"area" numeric (12,4),
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_tank_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_hydrant" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_hydrant_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_valve" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_valve_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_pump" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_pump_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_filter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_filter_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."man_meter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_meter_pkey PRIMARY KEY (node_id)
);



-- ----------------------------------
-- Table structure for arc features
-- ----------------------------------

CREATE TABLE "SCHEMA_NAME"."man_pipe" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_pipe_pkey PRIMARY KEY (arc_id)
);



-- ----------------------------------
-- Table structure for element
-- ----------------------------------

CREATE TABLE "SCHEMA_NAME"."element" (
"element_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_seq'::regclass) NOT NULL,
"elementcat_id" varchar(30) COLLATE "default",
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30) COLLATE "default",
"enddate" timestamp (6) without time zone,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT element_pkey PRIMARY KEY (element_id)
);


CREATE TABLE "SCHEMA_NAME"."element_x_node" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_node_seq'::regclass) NOT NULL,
"element_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
CONSTRAINT element_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."element_x_connec" (
"id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".element_x_connec_seq'::regclass) NOT NULL,
"element_id" varchar(16) COLLATE "default",
"connec_id" varchar(16) COLLATE "default",
CONSTRAINT element_x_connec_pkey PRIMARY KEY (id)
);



--------
-- FK
--------

ALTER TABLE "SCHEMA_NAME"."cat_element" ADD FOREIGN KEY ("elementtype_id") REFERENCES "SCHEMA_NAME"."element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_element" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_connec" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_connec" ADD FOREIGN KEY ("type") REFERENCES "SCHEMA_NAME"."type_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "SCHEMA_NAME"."cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."dma" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."link" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("ownercat_id") REFERENCES "SCHEMA_NAME"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_tank" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_hydrant" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_valve" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;


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

