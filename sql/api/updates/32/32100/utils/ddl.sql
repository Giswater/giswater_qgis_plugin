/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-----------------------
-- remove all the tables that are refactored in the v3.2
-----------------------
/*DROP TABLE IF EXISTS "config_web_composer_scale";
DROP TABLE IF EXISTS "config_web_fields";
DROP TABLE IF EXISTS "config_web_fields_cat_datatype";
DROP TABLE IF EXISTS "config_web_fields_cat_type";
DROP TABLE IF EXISTS "config_web_forms";
DROP TABLE IF EXISTS "config_web_layer";
DROP TABLE IF EXISTS "config_web_layer_cat_form";
DROP TABLE IF EXISTS "config_web_layer_cat_formtab";
DROP TABLE IF EXISTS "config_web_layer_child";
DROP TABLE IF EXISTS "config_web_tableinfo_x_inforole";
DROP TABLE IF EXISTS "config_web_tabs";
*/

-----------------------
-- create sequences
-----------------------

CREATE SEQUENCE config_api_form_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE config_api_tableinfo_x_inforole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE config_api_visit_cat_multievent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    


-----------------------
-- create api config tables
-----------------------


CREATE TABLE config_api_cat_datatype
(  id character varying(30) NOT NULL,
  descript text,
  CONSTRAINT config_api_cat_datatype_pkey PRIMARY KEY (id)
);



CREATE TABLE config_api_cat_formtemplate
(  id character varying(30) NOT NULL,
  descript text,
  CONSTRAINT config_api_cat_form_pkey PRIMARY KEY (id)
);


CREATE TABLE config_api_cat_widgettype
(  id character varying(30) NOT NULL,
  descript text,
  CONSTRAINT config_api_cat_widgettype_pkey PRIMARY KEY (id)
);

CREATE TABLE config_api_form_groupbox
(  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.config_api_form_layout_id_seq'::regclass),
  formname character varying(50) NOT NULL,
  layout_id integer,
  label text,
  CONSTRAINT config_api_form_layout_pkey PRIMARY KEY (id)
);



CREATE TABLE config_api_layer
(  layer_id text NOT NULL,
  is_parent boolean,
  tableparent_id text,
  is_editable boolean,
  tableinfo_id text,
  formtemplate text,
  headertext text,
  orderby integer,
  link_id text,
  is_tiled boolean,
  CONSTRAINT config_web_layer_pkey PRIMARY KEY (layer_id)
);


CREATE TABLE config_api_layer_child
(  featurecat_id character varying(30) NOT NULL,
  tableinfo_id text,
  CONSTRAINT config_api_layer_child_pkey PRIMARY KEY (featurecat_id)
);



CREATE TABLE config_api_tableinfo_x_infotype
(  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.config_api_tableinfo_x_inforole_id_seq'::regclass),
  tableinfo_id character varying(50),
  infotype_id integer,
  tableinfotype_id text,
  CONSTRAINT config_api_tableinfo_x_inforole_pkey PRIMARY KEY (id)
);



CREATE TABLE config_api_visit
(  visitclass_id serial NOT NULL,
  formname character varying(30),
  tablename character varying(30),
  CONSTRAINT config_api_visit_pkey PRIMARY KEY (visitclass_id)
);

/* created in 3.106
CREATE TABLE config_api_form_actions
(  id integer NOT NULL,
  formname character varying(50),
  formaction text,
  project_type character varying,
  CONSTRAINT config_api_actions_pkey PRIMARY KEY (id)
);


CREATE TABLE config_api_form_fields
(  id serial NOT NULL,
  formname character varying(50) NOT NULL,
  formtype character varying(50) NOT NULL,
  column_id character varying(30) NOT NULL,
  layout_id integer,
  layout_order integer,
  isenabled boolean,
  datatype character varying(30),
  widgettype character varying(30),
  label text,
  widgetdim integer,
  tooltip text,
  placeholder text,
  field_length integer,
  num_decimals integer,
  ismandatory boolean,
  isparent boolean,
  iseditable boolean,
  isautoupdate boolean,
  dv_querytext text,
  dv_orderby_id boolean,
  dv_isnullvalue boolean,
  dv_parent_id text,
  dv_querytext_filterc text,
  widgetfunction text,
  action_function text,
  isreload boolean,
  CONSTRAINT config_api_form_fields_pkey PRIMARY KEY (id)
);

CREATE TABLE config_api_cat_formtab
(  id character varying(30) NOT NULL,
  descript text,
  CONSTRAINT config_api_cat_formtab_pkey PRIMARY KEY (id)
);

CREATE TABLE config_api_list
(  id serial NOT NULL,
  tablename character varying(50),
  query_text text,
  device smallint,
  action_fields json,
  CONSTRAINT config_api_list_pkey PRIMARY KEY (id)
);

CREATE TABLE config_api_message
(  id integer NOT NULL,
  loglevel integer,
  message text,
  hintmessage text,
  CONSTRAINT config_api_message_pkey PRIMARY KEY (id)
);

*/