/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--audit_cat_param_user
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
ALTER TABLE audit_cat_param_user ADD COLUMN vdefault text;


--SYS TABLES
CREATE TABLE sys_combo_cat(
  id serial NOT NULL,
  idval text,
  CONSTRAINT sys_combo_cat_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE sys_combo_values(
  sys_combo_cat_id integer NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  CONSTRAINT sys_combo_pkey PRIMARY KEY (sys_combo_cat_id, id)
)
WITH (
  OIDS=FALSE
);

---OM TABLES

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
  visitcat_id integer,
  descript text,
  active boolean DEFAULT true,
  team_id integer,
  duration text,
  feature_type text);
  

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
  
  
  CREATE TABLE om_visit_filetype_x_extension
(
  filetype varchar (30),
  fextension varchar (16),
  CONSTRAINT om_visit_filetype_x_extension_pkey PRIMARY KEY (filetype, fextension)
);

ALTER TABLE om_visit ADD column lot_id integer;
ALTER TABLE om_visit ADD COLUMN class_id integer;
ALTER TABLE om_visit ADD COLUMN suspendendcat_id integer;
ALTER TABLE om_visit_lot DROP COLUMN active;
ALTER TABLE om_visit_lot DROP COLUMN visitcat_id;
ALTER TABLE om_visit_lot ADD column status integer;

