/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;



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
  dv_key_column text,
  dv_value_column text,
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




CREATE TABLE "config_web_layer_tab" (
id serial NOT NULL PRIMARY KEY,
table_id character varying(50),
formtab text,
formname text,
formid text
);



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