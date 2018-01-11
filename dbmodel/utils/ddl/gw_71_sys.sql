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
"value" text,
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



CREATE TABLE "config_web_fields"(
  id serial NOT NULL PRIMARY KEY,
  table_id character varying(50),
  column_id character varying(30),
  is_mandatory boolean,
  datatype_id text,
  field_length integer,
  num_decimals integer,
  default_value text,
  form_label text,
  widgettype_id text,
  dv_table text,
  dv_key_column text,
  dv_value_column text,
  sql_text text,
  is_enabled boolean
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
type character varying(50),
arc_id character varying(16),
arc_id1 character varying(16),
arc_id2 character varying(16),
node_id character varying(16),
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
-- Table: Audit table
-- ----------------------------------


-- Catalog of system roles
DROP TABLE IF EXISTS sys_role CASCADE; 
CREATE TABLE sys_role(
id character varying(30) PRIMARY KEY,
context character varying(30),
descript text,
CONSTRAINT sys_role_context_unique UNIQUE (context)
);


-- Catalog of function's process of system
DROP TABLE IF EXISTS sys_fprocess_cat CASCADE;  
CREATE TABLE sys_fprocess_cat (
id integer PRIMARY KEY,
fprocess_name varchar(30),
context	varchar (30),
fprocess_i18n varchar (30),
project_type varchar(6)
);




-- Catalog of tables and views
DROP TABLE IF EXISTS audit_cat_table CASCADE;
CREATE TABLE audit_cat_table(
  id text NOT NULL PRIMARY KEY,
  context text,
  description text,
  sys_role_id character varying(30),
  sys_criticity smallint,
  sys_rows text,
  qgis_role_id character varying(30),
  qgis_criticity smallint,
  qgis_message text
);




-- Catalog of columns
DROP TABLE IF EXISTS audit_cat_table_x_column CASCADE; 
CREATE TABLE audit_cat_table_x_column (
id text,
table_id text,
column_id text,
column_type text,
ordinal_position smallint,
description text,
sys_role_id varchar(30)
,CONSTRAINT audit_cat_table_x_column_pkey PRIMARY KEY (table_id, column_id)
);


   
-- Catalog of functions
DROP TABLE IF EXISTS audit_cat_function CASCADE; 
CREATE TABLE audit_cat_function (
id integer NOT NULL,
function_name text NOT NULL,
project_type text,
function_type text,
input_params text,
return_type text,
context text,
descript text,
sys_rol_id text
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


-- Audit project
DROP TABLE IF EXISTS audit_project CASCADE;
CREATE TABLE audit_project(
 table_id text NOT NULL PRIMARY KEY,
 fprocesscat_id integer,
 criticity smallint,
 enabled boolean,
 message text,
 user_name text DEFAULT "current_user"(),
 observ text
 );


