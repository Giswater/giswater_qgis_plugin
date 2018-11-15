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
"cur_user" character varying (30)
);



CREATE TABLE config_client_forms(
  id serial NOT NULL,
  location_type character varying(50) NOT NULL,
  project_type character varying(50) NOT NULL,
  table_id character varying(50) NOT NULL,
  column_id character varying(50) NOT NULL,
  column_index smallint,
  status boolean,
  width integer,
  alias character varying(50),
  dev1_status boolean,
  dev2_status boolean,
  dev3_status boolean,
  dev_alias character varying(50),
  CONSTRAINT config_client_forms_pkey PRIMARY KEY (id)
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

CREATE TABLE selector_date(
id serial PRIMARY KEY,
from_date date,
to_date date,
context varchar(30),
cur_user text
);


CREATE TABLE selector_audit(
id serial PRIMARY KEY,
fprocesscat_id integer,
cur_user text
);


CREATE TABLE selector_workcat(
id serial PRIMARY KEY,
workcat_id text,
cur_user text
);


-- ----------------------------------
-- Table: Traceability
-- ----------------------------------

CREATE TABLE "audit_log_arc_traceability" (
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
-- Table: Import CSV to PostgreSQL
-- ----------------------------------
  
CREATE TABLE temp_csv2pg (
id serial PRIMARY KEY,
csv2pgcat_id integer,
user_name text DEFAULT current_user,
csv1 text, 
csv2 text,   
csv3 text, 
csv4 text, 
csv5 text, 
csv6 text, 
csv7 text, 
csv8 text, 
csv9 text, 
csv10 text, 
csv11 text,
csv12 text, 
csv13 text, 
csv14 text,
csv15 text,
csv16 text,
csv17 text,
csv18 text,
csv19 text,
csv20 text,
tstamp timestamp DEFAULT now()
);
  

CREATE TABLE sys_csv2pg_cat (
id serial PRIMARY KEY,
name text,
name_i18n text,
csv_structure text,
sys_role text
);

  
  
-- ----------------------------------
-- Table: Audit table
-- ----------------------------------


-- Catalog of system roles
CREATE TABLE sys_role(
id character varying(30) PRIMARY KEY,
context character varying(30),
descript text,
CONSTRAINT sys_role_context_unique UNIQUE (context)
);


-- Catalog of function's process of system
CREATE TABLE sys_fprocess_cat (
id integer PRIMARY KEY,
fprocess_name varchar(50),
context	varchar (30),
fprocess_i18n varchar (50),
project_type varchar(6)
);


-- Catalog of tables and views
CREATE TABLE audit_cat_table(
id text NOT NULL PRIMARY KEY,
context text,
description text,
sys_role_id character varying(30),
sys_criticity smallint,
sys_rows text,
qgis_role_id character varying(30),
qgis_criticity smallint,
qgis_message text,
sys_sequence text,
sys_sequence_field text
);

-- Catalog of user parameters
CREATE TABLE audit_cat_param_user(
id text NOT NULL PRIMARY KEY,
context text,
description text,
sys_role_id character varying(30),
qgis_message text,
dv_table text,
dv_column text,
dv_clause text,
data_type text
);

  
-- Catalog of functions
CREATE TABLE audit_cat_function (
id integer NOT NULL PRIMARY KEY,
function_name text NOT NULL,
project_type text,
function_type text,
input_params text,
return_type text,
context text,
descript text,
sys_role_id text
);


-- Catalog of errors
CREATE TABLE audit_cat_error (
id integer PRIMARY KEY,
error_message text,
hint_message text,
log_level int2 CHECK (log_level IN (0,1,2,3)) DEFAULT 1,
show_user boolean DEFAULT 'True',
project_type text DEFAULT 'utils'
);


-- Audit project check table
CREATE TABLE audit_check_project(
id serial PRIMARY KEY,
table_id text,
table_host text,
table_dbname text,
table_schema text,
fprocesscat_id integer,
criticity smallint,
enabled boolean,
message text,
tstamp timestamp DEFAULT now(),
user_name text DEFAULT "current_user"(),
observ text
 );

-- Audit data check table
CREATE TABLE audit_check_data(
id serial PRIMARY KEY,
fprocesscat_id smallint,
result_id varchar(30),
table_id text,
column_id text,
criticity smallint,
enabled boolean,
error_message text,
tstamp timestamp DEFAULT now(),
user_name text DEFAULT "current_user"()
 );


 -- Audit feature check table
CREATE TABLE audit_check_feature(
id serial PRIMARY KEY,
fprocesscat_id smallint,
result_id varchar(30),
feature_id text,
feature_type text,
criticity smallint,
enabled boolean,
error_message text,
tstamp timestamp DEFAULT now(),
user_name text DEFAULT "current_user"()
 );


 -- Audit data log project
 CREATE TABLE audit_log_project (
  id serial NOT NULL PRIMARY KEY,
  fprocesscat_id smallint,
  table_id text,
  column_id text,
  enabled boolean,
  log_message text,
  tstamp timestamp without time zone DEFAULT now(),
  user_name text DEFAULT "current_user"()
);


CREATE TABLE audit_log_data (
  id serial NOT NULL PRIMARY KEY,
  fprocesscat_id smallint,
  feature_type varchar(16),
  feature_id varchar(16),
  enabled boolean,
  log_message text,
  tstamp timestamp without time zone DEFAULT now(),
  user_name text DEFAULT "current_user"()
);


CREATE TABLE audit_log_feature (
  id serial NOT NULL PRIMARY KEY,
  fprocesscat_id smallint,
  feature_type character varying(16),
  log_message text,
  feature_id character varying(16),
  code character varying(30),
  state smallint,
  state_type smallint,
  observ text,
  comment text,
  function_type character varying(50),
  category_type character varying(50),
  fluid_type character varying(50),
  location_type character varying(50),
  workcat_id character varying(255),
  workcat_id_end character varying(255),
  buildercat_id character varying(30),
  builtdate date,
  enddate date,
  ownercat_id character varying(30),
  link character varying(512),
  verified character varying(30),
  the_geom_point geometry(Point,25831),
  the_geom_line geometry(LineString,25831),
  undelete boolean,
  label_x character varying(30),
  label_y character varying(30),
  label_rotation numeric(6,3),
  publish boolean,
  inventory boolean,
  expl_id integer,
  tstamp timestamp without time zone DEFAULT now(),
  user_name text DEFAULT "current_user"()
 );
 
 
  -- Audit data log csv2pg
CREATE TABLE audit_log_csv2pg(
id bigserial PRIMARY KEY,
csv2pgcat_id integer,
user_name text,
csv1 text, 
csv2 text,   
csv3 text, 
csv4 text, 
csv5 text, 
csv6 text, 
csv7 text, 
csv8 text, 
csv9 text, 
csv10 text, 
csv11 text,
csv12 text, 
csv13 text, 
csv14 text,
csv15 text,
csv16 text,
csv17 text,
csv18 text,
csv19 text,
csv20 text,
tstamp timestamp DEFAULT now()
 );
 