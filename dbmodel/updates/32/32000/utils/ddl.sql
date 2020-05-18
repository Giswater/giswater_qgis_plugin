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


ALTER TABLE audit_cat_function ADD COLUMN istoolbox boolean;
ALTER TABLE audit_cat_function ADD COLUMN alias varchar(60);
ALTER TABLE audit_cat_function ADD COLUMN isparametric boolean DEFAULT false;


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
ALTER TABLE config_param_system ADD COLUMN isdeprecated text;


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
  csv31 text,
  csv32 text,
  csv33 text,
  csv34 text,
  csv35 text,
  csv36 text,
  csv37 text,
  csv38 text,
  csv39 text,
  csv40 text,
  tstamp timestamp without time zone DEFAULT now(),

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


CREATE TABLE config_api_form(
  id serial PRIMARY KEY,
  formname character varying(50),
  projecttype character varying,
  actions json,
  layermanager json);
  


CREATE TABLE config_api_form_tabs(
  id integer NOT NULL,
  formname character varying(50),
  tabname text,
  tablabel text,
  tabtext text,
  sys_role text,
  tooltip text,
  tabfunction json,
  tabactions json,
  device integer,
  CONSTRAINT config_api_form_tabs_pkey PRIMARY KEY (id)
);  


CREATE TABLE config_api_list(
  id serial NOT NULL,
  tablename character varying(50),
  query_text text,
  device smallint,
  actionfields json,
  listtype character varying(30),
  listclass character varying(30),
  vdefault json,
  CONSTRAINT config_api_list_pkey PRIMARY KEY (id)
);




CREATE TABLE config_api_message(
  id integer NOT NULL,
  loglevel integer,
  message text,
  hintmessage text,
  mtype text,
  CONSTRAINT config_api_message_pkey PRIMARY KEY (id)
);



CREATE TABLE config_api_images (
  id serial,
  idval text,
  image bytea,
  CONSTRAINT config_web_images_pkey PRIMARY KEY (id)
);


CREATE TABLE config_api_visit (
  visitclass_id serial NOT NULL,
  formname character varying(30),
  tablename character varying(30),
  CONSTRAINT config_api_visit_pkey PRIMARY KEY (visitclass_id),
  CONSTRAINT config_api_visit_formname_key UNIQUE (formname)
);



CREATE TABLE config_api_form_groupbox(
  id SERIAL PRIMARY KEY,
  formname character varying(50) NOT NULL,
  layout_id integer,
  label text
);

CREATE TABLE config_api_visit_x_featuretable(
  tablename character varying(30) NOT NULL,
  visitclass_id integer NOT NULL,
  CONSTRAINT config_api_visit_x_table_pkey PRIMARY KEY (visitclass_id, tablename)
);


/*
COMMENT ON TABLE config_api_toolbar_buttons IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table buttons on toolbar are configured.
The function gw_api_gettoolbarbuttons is called when session is started passing the list of project buttons. 
In function of role of user, buttons are parameters are passed to client';
*/

/*
COMMENT ON TABLE config_api_form IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table actions on form are configured
Actions are builded on form using this table, but not are activated
Actions are activated and configurated on tab. 
To activate and configurate actions please use config_api_form_tabs (not attributeTable) or config_api_list (attributeTable)';
*/

COMMENT ON TABLE config_api_form_fields IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table form fields are configured:
The function gw_api_get_formfields is called to build widget forms using this table.
formname: warning with formname. If it is used to work with listFilter fields tablename of an existing relation on database must be mandatory to put here
formtype: There are diferent formtypes:
	feature: the standard one. Used to show fields from feature tables
	info: used to build the infoplan widget
	visit: used on visit forms
	form: used on specific forms (search, mincut)
	catalog: used on catalog forms (workcat and featurecatalog)
	listfilter: used to filter list
	editbuttons:  buttons on form bottom used to edit (accept, cancel)
	navbuttons: buttons on form bottom used to navigate (goback....)
layout_id and layout_order, used to define the position';


COMMENT ON TABLE config_api_images IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table images on forms are configured:
To load a new image into this table use:
INSERT INTO config_api_images (idval, image) VALUES (''imagename'', pg_read_binary_file(''imagename.png'')::bytea)
Image must be located on the server (folder data of postgres instalation path. On linux /var/lib/postgresql/x.x/main, on windows postrgreSQL/x.x/data )';


COMMENT ON TABLE config_api_list IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table lists are configured. There are two types of lists: List on tabs and lists on attribute table
tablename must be mandatory to use a name of an existing relation on database. Code needs to identify the datatype of filter to work with
The field actionfields is required only for list on attribute table (listtype attributeTable). 
In case of different listtype actions must be defined on config_api_form_tabs';


COMMENT ON TABLE config_api_message IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table api messages are configured. The field mtype it means message type and there are two options. With feature or alone.
Using with feature the message is writted using the feature id before. Alone it means tha message is alone without nothing else merged';


COMMENT ON TABLE config_api_visit IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table visit are configured. Use it in combination with the om_visit_class table. Only visits with visitclass_id !=0 must be configured ';


COMMENT ON TABLE config_api_form_tabs IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table tabs on form are configured
Field actions is mandatory in exception of attributeTable. In case of attribute table actions must be defined on config_api_list';


COMMENT ON TABLE config_api_visit_x_featuretable
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is mandatory to relate table with visitclass. In case of offline funcionality client devices needs projects with tables related only with one visitclass, 
because on the previous download process only one visitclass form per layer stored on project will be downloaded. 
In case of only online projects more than one visitclass must be related to layer.'

