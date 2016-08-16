/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE "SCHEMA_NAME"."version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16)  ,
"wsoftware" varchar(16)  ,
"postgres" varchar(512)  ,
"postgis" varchar(512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT version_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."config" (
"id" varchar(18)   NOT NULL,
"node_proximity" double precision,
"arc_searchnodes" double precision,
"node2arc" double precision,
"connec_proximity" double precision,
"arc_toporepair" double precision,
"nodeinsert_arcendpoint" boolean,
"nodeinsert_catalog_vdefault" varchar (30),
"orphannode_delete" boolean,
"vnode_update_tolerance" double precision,
"nodetype_change_enabled" boolean,
"samenode_init_end_control" boolean,
"node_proximity_control" boolean,
"connec_proximity_control" boolean,
"node_duplicated_tolerance" float,
"audit_function_control" boolean,
CONSTRAINT "config_pkey" PRIMARY KEY ("id")
);



