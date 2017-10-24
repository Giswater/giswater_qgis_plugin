/*
This file is part of Giswater 3
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
"epsg" int4
);



-- ----------------------------------
-- Tables: configs
-- ----------------------------------

CREATE TABLE "config" (
"id" varchar(18) NOT NULL PRIMARY KEY,
"node_proximity" double precision,
"arc_searchnodes" double precision,
"node2arc" double precision,
"connec_proximity" double precision,
"nodeinsert_arcendpoint" boolean,
"orphannode_delete" boolean,
"vnode_update_tolerance" double precision,
"nodetype_change_enabled" boolean,
"samenode_init_end_control" boolean,
"node_proximity_control" boolean,
"connec_proximity_control" boolean,
"node_duplicated_tolerance" float,
"connec_duplicated_tolerance" float,
"audit_function_control" boolean,
"arc_searchnodes_control" boolean,
"insert_double_geometry" boolean,
"buffer_value" double precision,
CONSTRAINT "config_check" CHECK(id = '1')
);


CREATE TABLE "config_param_system" (
"id" serial NOT NULL PRIMARY KEY,
"parameter"  varchar (50),
"value" text NOT NULL,
"data_type" varchar(20),
"context" varchar (50),
"descript" text
);


CREATE TABLE "config_param_user" (
"id" serial PRIMARY KEY,
"parameter" character varying (50),
"value" text,
"data_type" varchar(20),
"cur_user" character varying (30),
"context" varchar (50),
"descript" text
);



CREATE TABLE "config_client_forms" (
"id" serial NOT NULL PRIMARY KEY,
"table_id" varchar (50),
"status" boolean,
"width" int4,
"column_index" int2,
"alias" varchar (50)
);


CREATE TABLE "config_web_forms" (
id serial NOT NULL,
table_id character varying(50),
query_text text,
device integer,
CONSTRAINT config_client_forms_web_pkey PRIMARY KEY (id)
);



CREATE TABLE "config_web_fields" (
id serial NOT NULL,
table_id text,
column_id text,
dv_table text,
dv_key_column text,
dv_value_column text,
orderby_value boolean,
allow_null boolean,
data_type text,
form_widget text,
sql_text text,
CONSTRAINT config_web_fields_pkey PRIMARY KEY (id)
);






-- ----------------------------------
-- Tables: selectors
-- ----------------------------------

CREATE TABLE selector_expl (
id serial PRIMARY KEY,
expl_id integer,
cur_user text
);

CREATE TABLE selector_psector (
id serial PRIMARY KEY,
psector_id integer,
cur_user text
);

CREATE TABLE selector_state (
id serial PRIMARY KEY,
state_id integer,
cur_user text
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
feature_type character varying,
state int2,
expl_id integer
);
  


-- ----------------------------------
-- Table: db catalogs 
-- ----------------------------------
  
-- Catalog of tables and views
DROP TABLE IF EXISTS db_cat_table CASCADE; 
CREATE TABLE db_cat_table (
id text NOT NULL PRIMARY KEY,
context text,
description text
);


-- Catalog of columns
DROP TABLE IF EXISTS db_cat_table_x_column CASCADE; 
CREATE TABLE db_cat_table_x_column (
id text,
table_id text,
column_id text,
column_type text,
description text,
CONSTRAINT db_cat_table_x_column_pkey PRIMARY KEY (table_id, column_id)
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


  
  
DROP TABLE IF EXISTS db_cat_client_agrupation CASCADE; 
CREATE TABLE db_cat_client_agrupation(
id varchar(50) NOT NULL,
description text,
workflow text,
pre_dependences text,
post_dependences text,
db_cat_client_layer_agrupation_id varchar(50),
CONSTRAINT db_cat_client_agrupation_pkey PRIMARY KEY (id));
  
  
  
-- ---------------------------------
-- Table: db audit
-- ----------------------------------
 
-- Catalog of functions
DROP TABLE IF EXISTS audit_cat_function CASCADE; 
CREATE TABLE audit_cat_function (
id int4 PRIMARY KEY,
name text NOT NULL,
function_type text,
context text,
input_params text, 
return_type text
);



-- Catalog of errors
DROP TABLE IF EXISTS audit_cat_error CASCADE;  
CREATE TABLE audit_cat_error (
id integer PRIMARY KEY,
error_message text,
hint_message text,
log_level int2 CHECK (log_level IN (0,1,2,3)) DEFAULT 1,
show_user boolean DEFAULT 'True',
context text DEFAULT 'generic'
);



DROP TABLE IF EXISTS audit_function_actions CASCADE; 
CREATE TABLE IF NOT EXISTS audit_function_actions (
id bigserial PRIMARY KEY,
tstamp TIMESTAMP NOT NULL DEFAULT date_trunc('second', current_timestamp), 
audit_cat_error_id integer NOT NULL,
audit_cat_function_id int4,
query text,
user_name text,
addr inet,
debug_info text
);


