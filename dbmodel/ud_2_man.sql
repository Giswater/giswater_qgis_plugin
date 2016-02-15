/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




-----
-- MAIN (ARC-NODE)
-----


CREATE TABLE "SCHEMA_NAME"."man_type_function" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_type_function_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."man_type_category" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."man_type_fluid" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."man_type_location" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_type_direction" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_type_direction_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



-----
-- DERIVADED (ARC-NODE)
-----



-- ----------------------------
-- Table structure for additional catalog
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."cat_man_cover" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default"
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_man_step" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default"
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_man_hydrometer" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default"
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."cat_man_flap" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default"
)
WITH (OIDS=FALSE)
;




-- ----------------------------
-- Table structure for node derivades
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."man_node_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"covercat_id" varchar(30) COLLATE "default",
"stepcat_id" varchar(30) COLLATE "default",
"step_n" int2,
"stepcat_id2" varchar(30) COLLATE "default",
"step_n2" int2,
CONSTRAINT man_node_mhole_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_storage" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_node_storage_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_outfall" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_node_outfall_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;



-- ----------------------------
-- Table structure for arc derivades
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."man_arc_conduit" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"func_type" varchar(16) COLLATE "default",
"hydrocat_id" varchar(30) COLLATE "default",
"flapcat_id" varchar(30) COLLATE "default",
CONSTRAINT man_arc_conduit_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;

CREATE TABLE "SCHEMA_NAME"."man_arc_pump" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_arc_pump_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_arc_virtual" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_arc_virtual_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;






--------
-- FK
--------

ALTER TABLE "SCHEMA_NAME"."man_node_mhole" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_weir" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_storage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;



ALTER TABLE "SCHEMA_NAME"."man_arc_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

