/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;




CREATE TABLE "config_web_fields_cat_datatype" (
id text PRIMARY KEY
);


CREATE TABLE "config_web_layer_cat_formtab" (
id text PRIMARY KEY
);

CREATE TABLE "config_web_layer_cat_form" (
id text PRIMARY KEY,
name  text);


CREATE TABLE "config_web_fields_cat_type" (
id text PRIMARY KEY
);


CREATE TABLE "config_web_layer"(
  layer_id text NOT NULL,
  is_parent boolean,
  tableparent_id text,
  is_editable boolean,
  tableinfo_id text,
  formid text,
  formname text,
  orderby integer,
  link_id text,
  CONSTRAINT config_web_layer_pkey PRIMARY KEY (layer_id)
);



CREATE TABLE "config_web_layer_child"(
  featurecat_id character varying(30) NOT NULL,
  tableinfo_id text,
  CONSTRAINT config_web_layer_child_pkey PRIMARY KEY (featurecat_id)
);




CREATE TABLE config_web_tabs
( id integer NOT NULL,
  layer_id character varying(50),
  formtab text,
  tablabel text,
  tabtext text,
  CONSTRAINT config_web_tabs_pkey PRIMARY KEY (id),
  CONSTRAINT config_web_layer_tab_fkey FOREIGN KEY (formtab)
      REFERENCES config_web_layer_cat_formtab (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT);

	  
	  
CREATE TABLE "config_web_tableinfo_x_inforole"(
  id serial NOT NULL,
  tableinfo_id character varying(50),
  inforole_id integer,
  tableinforole_id text,
  CONSTRAINT config_web_tableinfo_x_inforole_pkey PRIMARY KEY (id)
);




CREATE TABLE "config_web_fields"
( id serial NOT NULL,
  table_id character varying(50),
  name character varying(30),
  is_mandatory boolean,
  "dataType" text,
  field_length integer,
  num_decimals integer,
  placeholder text,
  label text,
  type text,
  dv_table text,
  dv_id_column text,
  dv_name_column text,
  sql_text text,
  is_enabled boolean,
  orderby integer,
  CONSTRAINT config_web_fields_pkey PRIMARY KEY (id)
  );



CREATE TABLE "config_web_forms" (
id serial NOT NULL,
table_id character varying(50),
query_text text,
device integer,
CONSTRAINT config_client_forms_web_pkey PRIMARY KEY (id)
);



CREATE TABLE config_web_composer_scale(
  id integer NOT NULL,
  idval text,
  descript text,
  orderby integer,
  CONSTRAINT config_web_composer_scale_pkey PRIMARY KEY (id));

  
  
CREATE TABLE selector_composer(
  field_id text NOT NULL,
  field_value text,
  user_name text NOT NULL,
  CONSTRAINT selector_composer_pkey PRIMARY KEY (field_id, user_name));
 
