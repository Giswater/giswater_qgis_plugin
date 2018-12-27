/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-----------------------
-- remove all the tables that are refactored in the v3.2
-----------------------
/*
DROP TABLE IF EXISTS config;
DROP TABLE IF EXISTS "config_web_composer_scale";
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

DROP TABLE IF EXISTS ext_cat_hydrometer_priority;
DROP TABLE IF EXISTS ext_cat_hydrometer_type;

DROP TABLE IF EXISTS "inp_typevalue_energy";
DROP TABLE IF EXISTS "inp_typevalue_pump";
DROP TABLE IF EXISTS "inp_typevalue_reactions_gl";
DROP TABLE IF EXISTS "inp_typevalue_source";
DROP TABLE IF EXISTS "inp_typevalue_valve";
DROP TABLE IF EXISTS "inp_value_ampm";
DROP TABLE IF EXISTS "inp_value_curve";
DROP TABLE IF EXISTS "inp_value_mixing";
DROP TABLE IF EXISTS "inp_value_noneall";
DROP TABLE IF EXISTS "inp_value_opti_headloss";
DROP TABLE IF EXISTS "inp_value_opti_hyd";
DROP TABLE IF EXISTS "inp_value_opti_qual";
DROP TABLE IF EXISTS "inp_value_opti_rtc_coef";
DROP TABLE IF EXISTS "inp_value_opti_unbal";
DROP TABLE IF EXISTS "inp_value_opti_units";
DROP TABLE IF EXISTS "inp_value_opti_valvemode";
DROP TABLE IF EXISTS "inp_value_param_energy";
DROP TABLE IF EXISTS "inp_value_reactions_el";
DROP TABLE IF EXISTS "inp_value_reactions_gl";
DROP TABLE IF EXISTS "inp_value_status_pipe";
DROP TABLE IF EXISTS "inp_value_status_pump";
DROP TABLE IF EXISTS "inp_value_status_valve";
DROP TABLE IF EXISTS "inp_value_times";
DROP TABLE IF EXISTS "inp_value_yesno";
DROP TABLE IF EXISTS "inp_value_yesnofull";

DROP TABLE IF EXISTS "man_addfields_cat_combo";
DROP TABLE IF EXISTS "man_addfields_cat_datatype";
DROP TABLE IF EXISTS "man_addfields_cat_widgettype";

DROP TABLE IF EXISTS selector_composer;
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


CREATE TABLE config_api_cat_formtab
(  id character varying(30) NOT NULL,
  descript text,
  CONSTRAINT config_api_cat_formtab_pkey PRIMARY KEY (id)
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

CREATE TABLE config_api_form_actions
(  id integer NOT NULL,
  formname character varying(50),
  formaction text,
  actiontooltip text,
  sys_role text,
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

CREATE TABLE config_api_form_groupbox
(  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.config_api_form_layout_id_seq'::regclass),
  formname character varying(50) NOT NULL,
  layout_id integer,
  label text,
  CONSTRAINT config_api_form_layout_pkey PRIMARY KEY (id)
);


CREATE TABLE config_api_form_tabs
(  id integer NOT NULL,
  formname character varying(50),
  formtab text,
  headertext text,
  bodytext text,
  sys_role text,
  tablename text,
  idname text,
  tooltip text,
  CONSTRAINT config_web_tabs_pkey PRIMARY KEY (id)
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



-----------------------
-- create om tables
-----------------------
CREATE TABLE om_visit_class
(  id serial NOT NULL,
  idval character varying(30),
  descript text,
  active boolean DEFAULT true,
  ismultifeature boolean,
  ismultievent boolean,
  feature_type text,
  sys_role_id character varying(30),
  CONSTRAINT om_visit_class_pkey PRIMARY KEY (id)
);


CREATE TABLE om_visit_class_x_parameter
(  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.config_api_visit_cat_multievent_id_seq'::regclass),
  class_id integer NOT NULL,
  parameter_id character varying(50) NOT NULL,
  CONSTRAINT config_api_visit_cat_multievent_pkey PRIMARY KEY (class_id, parameter_id)
);


CREATE TABLE om_visit_typevalue
( typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(30),
  descript text,
  CONSTRAINT om_visit_typevalue_pkey PRIMARY KEY (typevalue, id)
);


CREATE TABLE rpt_selector_hourly_compare
( id serial NOT NULL,
  "time" character varying(100) NOT NULL,
  cur_user text NOT NULL,
  CONSTRAINT rpt_selector_result_hourly_compare_pkey PRIMARY KEY (id)
);

CREATE TABLE sys_combo_cat
( id serial NOT NULL,
  idval text,
  CONSTRAINT sys_combo_cat_pkey PRIMARY KEY (id)
);

CREATE TABLE sys_combo_values
( sys_combo_cat_id integer NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  CONSTRAINT sys_combo_pkey PRIMARY KEY (sys_combo_cat_id, id)
);


CREATE TABLE audit_cat_table_x_column
( id text,
  table_id text NOT NULL,
  column_id text NOT NULL,
  column_type text,
  ordinal_position smallint,
  description text,
  sys_role_id character varying(30),
  CONSTRAINT audit_cat_table_x_column_pkey PRIMARY KEY (table_id, column_id)
);


CREATE TABLE value_type
(  typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(100),
  descript text,
  CONSTRAINT value_type_pkey PRIMARY KEY (typevalue, id)
);


-----------------------
-- create new fields
-----------------------
ALTER TABLE audit_cat_param_user ADD COLUMN formname text;
ALTER TABLE audit_cat_param_user ADD COLUMN label text;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_querytext text;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_parent_id text;
ALTER TABLE audit_cat_param_user ADD COLUMN isenabled boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN layout_id integer;
ALTER TABLE audit_cat_param_user ADD COLUMN layout_order integer;
ALTER TABLE audit_cat_param_user ADD COLUMN project_type character varying(30);
ALTER TABLE audit_cat_param_user ADD COLUMN isparent boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN dv_querytext_filterc text;
ALTER TABLE audit_cat_param_user ADD COLUMN feature_field_id text;
ALTER TABLE audit_cat_param_user ADD COLUMN feature_dv_parent_value text;
ALTER TABLE audit_cat_param_user ADD COLUMN isautoupdate boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN datatype character varying(30);
ALTER TABLE audit_cat_param_user ADD COLUMN widgettype character varying(30);
ALTER TABLE audit_cat_param_user ADD COLUMN ischeckeditable boolean;
ALTER TABLE audit_cat_param_user ADD COLUMN widgetcontrols json;
ALTER TABLE audit_cat_param_user ADD COLUMN vdefault text;

ALTER TABLE cat_arc ADD COLUMN  dn integer;
ALTER TABLE cat_arc ADD COLUMN  pn integer;
ALTER TABLE cat_arc ADD COLUMN  shape character varying(30);

ALTER TABLE cat_connec ADD COLUMN dn integer;
ALTER TABLE cat_connec ADD COLUMN  pn integer;

ALTER TABLE cat_node ADD COLUMN dn integer;
ALTER TABLE cat_node ADD COLUMN  pn integer;

ALTER TABLE cat_feature ADD COLUMN  type character varying(30);
ALTER TABLE cat_feature ADD COLUMN shortcut_key character varying(100);
ALTER TABLE cat_feature ADD COLUMN parent_layer character varying(100);
ALTER TABLE cat_feature ADD COLUMN child_layer character varying(100);
ALTER TABLE cat_feature ADD COLUMN orderby integer;
ALTER TABLE cat_feature ADD COLUMN active boolean;
ALTER TABLE cat_feature ADD COLUMN code_autofill boolean;

ALTER TABLE config_param_system ADD COLUMN dt integer;
ALTER TABLE config_param_system ADD COLUMN wt integer;
ALTER TABLE config_param_system ADD COLUMN label text;
ALTER TABLE config_param_system ADD COLUMN dv_querytext text;
ALTER TABLE config_param_system ADD COLUMN dv_filterbyfield text;
ALTER TABLE config_param_system ADD COLUMN isenabled boolean;
ALTER TABLE config_param_system ADD COLUMN orderby integer;
ALTER TABLE config_param_system ADD COLUMN layout_id integer;
ALTER TABLE config_param_system ADD COLUMN layout_order integer;
ALTER TABLE config_param_system ADD COLUMN project_type character varying;
ALTER TABLE config_param_system ADD COLUMN dv_isparent boolean;
ALTER TABLE config_param_system ADD COLUMN isautoupdate boolean;
ALTER TABLE config_param_system ADD COLUMN datatype character varying;
ALTER TABLE config_param_system ADD COLUMN widgettype character varying;
ALTER TABLE config_param_system ADD COLUMN tooltip text;

--rename instead of add column?
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_id character varying(16);
ALTER TABLE ext_rtc_hydrometer ADD COLUMN client_name text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN instalation_date date;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_number integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN state smallint;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN connec_customer_code character varying(30);

ALTER TABLE om_visit ADD COLUMN class_id integer;
ALTER TABLE om_visit ADD COLUMN suspendendcat_id integer;

ALTER TABLE om_visit_cat ADD COLUMN extusercat_id integer;
ALTER TABLE om_visit_cat ADD COLUMN duration text;

ALTER TABLE om_visit_parameter ADD COLUMN  short_descript character varying(30);

ALTER TABLE sys_feature_type ADD COLUMN  icon character varying(30);

--table v_project_type???