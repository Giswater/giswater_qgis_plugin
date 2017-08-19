/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



CREATE TABLE "config" (
"id" varchar(18) NOT NULL PRIMARY KEY,
"node_proximity" double precision,
"arc_searchnodes" double precision,
"node2arc" double precision,
"connec_proximity" double precision,
"arc_toporepair" double precision,
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



CREATE TABLE config_client_dvalue(
id serial NOT NULL,
table_id text,
column_id text,
dv_table text,
dv_key_column text,
dv_value_column text,
orderby_value boolean,
allow_null boolean,
CONSTRAINT config_client_dvalue_pkey PRIMARY KEY (id)/*,
CONSTRAINT config_client_value_colum_id_fkey FOREIGN KEY (dv_table, dv_key_column) 
 REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT config_client_value_origin_id_fkey FOREIGN KEY (table_id, column_id)
 REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT*/
);




