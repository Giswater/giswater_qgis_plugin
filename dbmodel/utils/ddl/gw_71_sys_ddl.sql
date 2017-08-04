/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------------
-- Table: Version
-- ----------------------------------


CREATE TABLE "version" (
"id" serial NOT NULL PRIMARY KEY,
"giswater" varchar(16)  ,
"wsoftware" varchar(16)  ,
"postgres" varchar(512)  ,
"postgis" varchar(512)  ,
"date" timestamp(6) DEFAULT now(),
"language" varchar (50),
"epsg" int4,
);


-- ----------------------------------
-- Table: Traceability
-- ----------------------------------


CREATE TABLE "om_traceability" (
id serial PRIMARY KEY NOT NULL,
type character varying(50) NOT NULL,
arc_id character varying(16) NOT NULL,
arc_id1 character varying(16) NOT NULL ,
arc_id2 character varying(16) NOT NULL,
node_id character varying(16) NOT NULL,
tstamp timestamp(6) without time zone,
"user" character varying(50)
);



-- ----------------------------------
-- Table: Dimensions
-- ----------------------------------



CREATE TABLE dimensions(
id bigserial NOT NULL PRIMARY KEY,
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
feature_type character varying
);
  


-- ----------------------------------
-- Table: db catalogs 
-- ----------------------------------
  
DROP TABLE IF EXISTS db_cat_table CASCADE; 
CREATE TABLE db_cat_table (
id text NOT NULL PRIMARY KEY,
context text,
description text
);


-- Catalog of columns
DROP TABLE IF EXISTS db_cat_table_x_column CASCADE; 
CREATE TABLE db_cat_table_x_column (
id text NOT NULL PRIMARY KEY,
table_id text,
column_id text,
column_type text,
description text
);


DROP TABLE IF EXISTS db_cat_clientlayer CASCADE; 
CREATE TABLE db_cat_clientlayer (
qgis_layer_id text NOT NULL,
db_cat_table_id text NOT NULL,
layer_alias text,
client_id text,
description text,
pre_dependences text,
post_dependences text,
db_cat_client_layer_agrupation_id varchar(50),
styleqml_use_asdefault boolean,
styleqml_file text,
geometry_field text,
project_criticity smallint,
automatic_reload_layer boolean,
CONSTRAINT db_cat_clientlayer_pkey PRIMARY KEY (qgis_layer_id));


