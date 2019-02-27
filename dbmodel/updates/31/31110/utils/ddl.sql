/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--audit_cat_param_user
ALTER TABLE audit_cat_param_user RENAME context  TO formname;
ALTER TABLE audit_cat_param_user RENAME data_type TO idval;
ALTER TABLE audit_cat_param_user DROP COLUMN dv_table;
ALTER TABLE audit_cat_param_user DROP COLUMN dv_column;
ALTER TABLE audit_cat_param_user DROP COLUMN dv_clause;
ALTER TABLE audit_cat_param_user ADD COLUMN label text;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_querytext text;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_parent_id text;
ALTER TABLE audit_cat_param_user ADD COLUMN isenabled boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN layout_id integer;
ALTER TABLE audit_cat_param_user ADD COLUMN layout_order integer;
ALTER TABLE audit_cat_param_user ADD COLUMN project_type character varying;
ALTER TABLE audit_cat_param_user ADD COLUMN isparent boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_querytext_filterc text;
ALTER TABLE audit_cat_param_user ADD COLUMN feature_field_id text;
ALTER TABLE audit_cat_param_user ADD COLUMN feature_dv_parent_value text;
ALTER TABLE audit_cat_param_user ADD COLUMN isautoupdate boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN datatype character varying(30);
ALTER TABLE audit_cat_param_user ADD COLUMN widgettype character varying(30);
ALTER TABLE audit_cat_param_user ADD COLUMN ismandatory boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN widgetcontrols json;
ALTER TABLE audit_cat_param_user ADD COLUMN vdefault text;
ALTER TABLE audit_cat_param_user ADD COLUMN layout_name text;
ALTER TABLE audit_cat_param_user ADD COLUMN reg_exp text;
ALTER TABLE audit_cat_param_user ADD COLUMN iseditable boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_orderby_id boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_isnullvalue boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN stylesheet json;
ALTER TABLE audit_cat_param_user ADD COLUMN placeholder text;


ALTER TABLE rpt_cat_result ADD COLUMN user_name text;
ALTER TABLE rpt_cat_result ALTER COLUMN user_name SET DEFAULT current_user;

ALTER TABLE dma ADD COLUMN effc double precision;
ALTER TABLE dma ADD COLUMN pattern_id double precision;

ALTER TABLE audit_cat_function ADD COLUMN istoolbox boolean;
ALTER TABLE audit_cat_function ADD COLUMN alias varchar(30);
ALTER TABLE audit_cat_function ADD COLUMN isparametric boolean;



ALTER TABLE config_param_system ADD COLUMN label text;
ALTER TABLE config_param_system ADD COLUMN dv_querytext text;
ALTER TABLE config_param_system ADD COLUMN dv_filterbyfield text;
ALTER TABLE config_param_system ADD COLUMN isenabled boolean;
ALTER TABLE config_param_system ADD COLUMN layout_id integer;
ALTER TABLE config_param_system ADD COLUMN layout_order integer;
ALTER TABLE config_param_system ADD COLUMN project_type character varying;
ALTER TABLE config_param_system ADD COLUMN dv_isparent boolean;
ALTER TABLE config_param_system ADD COLUMN isautoupdate boolean;
ALTER TABLE config_param_system ADD COLUMN datatype character varying;
ALTER TABLE config_param_system ADD COLUMN widgettype character varying;
ALTER TABLE config_param_system ADD COLUMN tooltip text;
ALTER TABLE config_param_system ADD COLUMN ismandatory boolean;
ALTER TABLE config_param_system ADD COLUMN iseditable boolean;
ALTER TABLE config_param_system ADD COLUMN reg_exp text;
ALTER TABLE config_param_system ADD COLUMN dv_orderby_id boolean;
ALTER TABLE config_param_system ADD COLUMN dv_isnullvalue boolean;
ALTER TABLE config_param_system ADD COLUMN stylesheet json;
ALTER TABLE config_param_system ADD COLUMN widgetcontrols json;
ALTER TABLE config_param_system ADD COLUMN placeholder text;


ALTER TABLE temp_csv2pg RENAME TO old_temp_csv2pg;
ALTER SEQUENCE temp_csv2pg_id_seq RENAME TO temp_csv2pg_id_seq2;

CREATE TABLE temp_csv2pg(
  id serial PRIMARY KEY,
  csv2pgcat_id integer,
  user_name text DEFAULT "current_user"(),
  source text,
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
  tstamp timestamp without time zone DEFAULT now(),
  csv21 text,
  csv22 text,
  csv23 text,
  csv24 text,
  csv25 text,
  csv26 text,
  csv27 text,
  csv28 text,
  csv29 text,
  csv30 text,
  CONSTRAINT temp_csv2pg_csv2pgcat_id_fkey2 FOREIGN KEY (csv2pgcat_id)
      REFERENCES sys_csv2pg_cat (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT);



CREATE TABLE sys_csv2pg_config
(
  id serial NOT NULL PRIMARY KEY,
  pg2csvcat_id integer,
  tablename text,
  target text,
  fields text,
  reverse_pg2csvcat_id integer
);

-----------------------
-- create inp tables
-----------------------
CREATE TABLE inp_typevalue
(  typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(30),
  descript text,
  CONSTRAINT inp_typevalue_pkey PRIMARY KEY (typevalue, id)
);