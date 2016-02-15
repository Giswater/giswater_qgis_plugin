/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-----
-- MAIN (ARC-NODE)
-----


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





-----
-- DERIVADED (ARC-NODE)
-----


-- ----------------------------
-- Table structure for addtional catalog
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."cat_man_cover" (
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
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_junction_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_tank" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"vmax" numeric (12,4),
"area" numeric (12,4),
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_tank_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_hydrant" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_hydrant_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_valve" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_valve_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_node_meter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_node_meter_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


-- ----------------------------
-- Table structure for arc derivades
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."man_arc_pipe" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_pipe_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_arc_valve" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_valve_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_arc_pump" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_pump_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_arc_filter" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_filter_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."man_arc_meter" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_arc_flowmeter_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;



--------
-- FK
--------

ALTER TABLE "SCHEMA_NAME"."man_node_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_tank" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_hydrant" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_valve" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;



ALTER TABLE "SCHEMA_NAME"."man_arc_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_valve" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_filter" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_arc_flowmeter" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;


