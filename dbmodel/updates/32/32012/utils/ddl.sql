/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-----------------------
-- create om tables
-----------------------

CREATE TABLE audit_cat_column
( column_id text NOT NULL,
  descript text);


CREATE TABLE edit_typevalue
( typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(100),
  descript text,
  addparam json,
  CONSTRAINT value_type_pkey PRIMARY KEY (typevalue, id)
);


-----------------------
-- create new fields
----------------------
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_class", "column":"param_options", "dataType":"json"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"visit_type", "dataType":"integer"}}$$);


--SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature", "column":"type", "dataType":"varchar(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature", "column":"shortcut_key", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature", "column":"parent_layer", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature", "column":"child_layer", "dataType":"varchar(100)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"extusercat_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"duration", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_feature_type", "column":"icon", "dataType":"varchar(30)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_addfields_parameter", "column":"orderby", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_addfields_parameter", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_addfields_parameter", "column":"iseditable", "dataType":"boolean"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_municipality", "column":"active", "dataType":"boolean", "isUtils":"True"}}$$);

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
  tableparentepa_id text,
  CONSTRAINT config_api_layer_pkey PRIMARY KEY (layer_id)
);



CREATE TABLE config_api_tableinfo_x_infotype
(  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.config_api_tableinfo_x_inforole_id_seq'::regclass),
  tableinfo_id character varying(50),
  infotype_id integer,
  tableinfotype_id text,
  CONSTRAINT config_api_tableinfo_x_inforole_pkey PRIMARY KEY (id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_fields", "column":"layout_name", "dataType":"varchar(16)"}}$$);
