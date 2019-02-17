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


ALTER TABLE rpt_cat_result ADD COLUMN user_name text;
ALTER TABLE rpt_cat_result ALTER COLUMN user_name SET DEFAULT current_user;

ALTER TABLE dma ADD COLUMN effc double precision;

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


-- om_visit
ALTER TABLE om_visit ADD column lot_id integer;
ALTER TABLE om_visit ADD COLUMN class_id integer;
ALTER TABLE om_visit ADD COLUMN status integer;


ALTER TABLE temp_csv2pg RENAME TO _temp_csv2pg;
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


---OM TABLES

CREATE TABLE om_visit_typevalue(
  parameter_id text PRIMARY KEY,
  id integer NOT NULL,
  idval text,
  descript text
);


CREATE TABLE om_visit_class
( id serial NOT NULL,
  idval character varying(30),
  descript text,
  active boolean DEFAULT true,
  ismultifeature boolean,
  ismultievent boolean,
  feature_type text,
  sys_role_id character varying(30),
  CONSTRAINT om_visit_class_pkey PRIMARY KEY (id)
);

ALTER TABLE om_visit ADD COLUMN feature_type text;
ALTER TABLE om_visit_parameter ADD COLUMN short_descript varchar(30);

CREATE TABLE om_visit_class_x_parameter (
    id serial primary key,
    class_id integer NOT NULL,
    parameter_id character varying(50) NOT NULL
);

CREATE TABLE om_visit_file(
  id bigserial NOT NULL PRIMARY KEY,
  visit_id bigint NOT NULL,
  filetype varchar(30),
  hash text,
  url text,
  xcoord float,
  ycoord float,
  compass double precision,
  fextension varchar(16),
  tstamp timestamp(6) without time zone DEFAULT now()
);

CREATE TABLE om_visit_lot(
  id serial NOT NULL primary key,
  idval character varying(30),
  startdate date DEFAULT now(),
  enddate date,
  visitclass_id integer,
  descript text,
  active boolean DEFAULT true,
  team_id integer,
  duration text,
  feature_type text,
  status integer,
  the_geom public.geometry(POLYGON, SRID_VALUE));
  
   

CREATE TABLE om_visit_lot_x_arc( 
  lot_id integer,
  arc_id varchar (16),
  code varchar(30),
  status integer,
  observ text,
  constraint om_visit_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id));

  CREATE TABLE om_visit_lot_x_node( 
  lot_id integer,
  node_id varchar (16),
  code varchar(30),
  status integer,
  observ text,
  constraint om_visit_lot_x_node_pkey PRIMARY KEY (lot_id, node_id));

  CREATE TABLE om_visit_lot_x_connec( 
  lot_id integer,
  connec_id varchar (16),
  code varchar(30),
  status integer,
  observ text,
  constraint om_visit_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id));

  
  CREATE TABLE selector_lot(
  id serial PRIMARY KEY,
  lot_id integer ,
  cur_user text ,
  CONSTRAINT selector_lot_lot_id_cur_user_unique UNIQUE (lot_id, cur_user));


  CREATE TABLE cat_team(
  id serial PRIMARY KEY,
  idval text,
  descript text,
  active boolean DEFAULT true);
  

  CREATE TABLE cat_vehicle(
  id serial NOT NULL,
  idval text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT cat_vehicle_pkey PRIMARY KEY (id));

 
  CREATE TABLE om_visit_team_x_user(
  team_id integer,
  user_id varchar(16),
  constraint om_visit_team_x_user_pkey PRIMARY KEY (team_id, user_id));
  
 
  CREATE TABLE om_visit_user_x_vehicle(
  user_id varchar(16),
  vehicle_id integer,
  constraint om_visit_user_x_vehicle_pkey PRIMARY KEY (user_id, vehicle_id));
  
 
  
  CREATE TABLE om_visit_filetype_x_extension
(
  filetype varchar (30),
  fextension varchar (16),
  CONSTRAINT om_visit_filetype_x_extension_pkey PRIMARY KEY (filetype, fextension)
);



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