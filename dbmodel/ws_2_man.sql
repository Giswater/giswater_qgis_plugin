/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-----------------
-- CATALOGS
-----------------

CREATE TABLE "SCHEMA_NAME"."cat_connec" (
"id" varchar(30) COLLATE "default" NOT NULL,
"matcat_id" varchar(16) COLLATE "default",
"matcat_2" varchar(16) COLLATE "default",
"matcat_3" varchar(16) COLLATE "default",
"dnom" varchar(16) COLLATE "default",
"pnom" varchar(16) COLLATE "default",
"dint" numeric (12,5),
"dext" numeric (12,5),
"geom1" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"value" numeric (12,2),
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."cat_soil" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."cat_builder" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."cat_work" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."cat_man_cover" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_man_cover_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);



-----------
-- TYPE
-----------

CREATE TABLE "SCHEMA_NAME"."man_type_category" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_type_fluid" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_type_location" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);



--------------------
-- Table structure
--------------------

CREATE TABLE "SCHEMA_NAME"."dma" (
"dma_id" varchar(30) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"observ" character varying(512),
"the_geom" public.geometry (MULTIPOLYGON, 25831),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."connec" (
"connec_id" varchar DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
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
"builtdate" timestamp (6) without time zone,
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
connec_id varchar(16) COLLATE "default",
the_geom public.geometry (LINESTRING, 25831),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
)WITH (OIDS=FALSE);



-- -----------------------------------
-- Table structure for node derivades
-- -----------------------------------

CREATE TABLE "SCHEMA_NAME"."man_node_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_junction_pkey PRIMARY KEY (node_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_node_tank" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"vmax" numeric (12,4),
"area" numeric (12,4),
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_tank_pkey PRIMARY KEY (node_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_node_hydrant" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_hydrant_pkey PRIMARY KEY (node_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_node_valve" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_valve_pkey PRIMARY KEY (node_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_node_meter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_meter_pkey PRIMARY KEY (node_id)
)WITH (OIDS=FALSE);



-- ----------------------------------
-- Table structure for arc derivades
-- ----------------------------------

CREATE TABLE "SCHEMA_NAME"."man_arc_pipe" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_pipe_pkey PRIMARY KEY (arc_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_arc_valve" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_valve_pkey PRIMARY KEY (arc_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_arc_pump" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_pump_pkey PRIMARY KEY (arc_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_arc_filter" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_filter_pkey PRIMARY KEY (arc_id)
)WITH (OIDS=FALSE);


CREATE TABLE "SCHEMA_NAME"."man_arc_meter" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_meter_pkey PRIMARY KEY (arc_id)
)WITH (OIDS=FALSE);



--------
-- FK
--------

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


ALTER TABLE "SCHEMA_NAME"."man_node_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_tank" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_hydrant" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_valve" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SCHEMA_NAME"."man_arc_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_valve" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_filter" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_meter" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

