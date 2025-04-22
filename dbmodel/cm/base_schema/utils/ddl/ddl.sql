/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE SCHEMA "SCHEMA_NAME";

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- system roles
DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'role_cm_admin'
   ) THEN
      CREATE role role_cm_admin WITH NOSUPERUSER NOCREATEDB NOCREATEROLE inherit NOREPLICATION NOBYPASSRLS;
   END IF;
END
$$;

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'role_cm_manager'
   ) THEN
      CREATE role role_cm_manager WITH NOSUPERUSER NOCREATEDB NOCREATEROLE inherit NOREPLICATION NOBYPASSRLS;
   END IF;
END
$$;

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'role_cm_field'
   ) THEN
      CREATE role role_cm_field WITH NOSUPERUSER NOCREATEDB NOCREATEROLE inherit NOREPLICATION NOBYPASSRLS;
   END IF;
END
$$;


-- system tables
CREATE TABLE sys_table (
	id text NOT NULL,
	descript text NULL,
	sys_role varchar(30) NULL,
	criticity int2 NULL,
	context varchar(500) NULL,
	orderby int2 NULL,
	alias text NULL,
	notify_action json NULL,
	isaudit bool NULL,
	keepauditdays int4 NULL,
	"source" text NULL,
	addparam json NULL,
	CONSTRAINT sys_table_pkey PRIMARY KEY (id)
);


CREATE TABLE config_form_fields (
	formname varchar(50) NOT NULL,
	formtype varchar(50) NOT NULL,
	tabname varchar(30) NOT NULL,
	columnname varchar(30) NOT NULL,
	layoutname text NULL,
	layoutorder int4 NULL,
	"datatype" varchar(30) NULL,
	widgettype varchar(30) NULL,
	"label" text NULL,
	tooltip text NULL,
	placeholder text NULL,
	ismandatory bool NULL,
	isparent bool NULL,
	iseditable bool NULL,
	isautoupdate bool NULL,
	isfilter bool NULL,
	dv_querytext text NULL,
	dv_orderby_id bool NULL,
	dv_isnullvalue bool NULL,
	dv_parent_id text NULL,
	dv_querytext_filterc text NULL,
	stylesheet json NULL,
	widgetcontrols json NULL,
	widgetfunction json NULL,
	linkedobject text NULL,
	hidden bool DEFAULT false NOT NULL,
	web_layoutorder int4 NULL,
	CONSTRAINT config_form_fields_pkey PRIMARY KEY (formname, formtype, columnname, tabname)
);

CREATE TABLE config_form_tabs (
	formname varchar(50) NOT NULL,
	tabname text NOT NULL,
	"label" text NULL,
	tooltip text NULL,
	sys_role text NULL,
	tabfunction json NULL,
	tabactions json NULL,
	orderby int4 NULL,
	device _int4 NULL,
	CONSTRAINT config_form_tabs_pkey PRIMARY KEY (formname, tabname)
);

CREATE TABLE config_param_system (
	"parameter" varchar(50) NOT NULL,
	value text NULL,
	descript text NULL,
	"label" text NULL,
	dv_querytext text NULL,
	dv_filterbyfield text NULL,
	isenabled bool NULL,
	layoutorder int4 NULL,
	project_type varchar NULL,
	dv_isparent bool NULL,
	isautoupdate bool NULL,
	"datatype" varchar NULL,
	widgettype varchar NULL,
	ismandatory bool NULL,
	iseditable bool NULL,
	dv_orderby_id bool NULL,
	dv_isnullvalue bool NULL,
	stylesheet json NULL,
	widgetcontrols json NULL,
	placeholder text NULL,
	standardvalue text NULL,
	layoutname text NULL,
	CONSTRAINT config_param_system_pkey PRIMARY KEY (parameter)
);


CREATE TABLE sys_typevalue (
	typevalue text NOT NULL,
	id varchar(30) NOT NULL,
	idval text NULL,
	descript text NULL,
	addparam json NULL,
	CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue, id)
);

CREATE TABLE cat_pschema
(
  pschema_id integer,
  name text,
  observ text,
  CONSTRAINT cat_pschema_pkey PRIMARY KEY (pschema_id)
);



-- catalogs
CREATE TABLE cat_role (
	role_id text PRIMARY KEY,
	descript text
);


CREATE TABLE cat_organization (
	organization_id serial4,
	code text NULL,
	orgname text NULL,
	descript text NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT cat_organization_unique UNIQUE (orgname),
	CONSTRAINT cat_organization_pkey PRIMARY KEY (organization_id)
);


CREATE TABLE cat_team (
	team_id serial4,
	code text NULL,
	teamname text not NULL,
	organization_id int4 NOT NULL,
	descript text NULL,
	role_id TEXT NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT cat_team_pkey PRIMARY KEY (team_id),
	CONSTRAINT cat_team_unique UNIQUE (teamname, organization_id),
	CONSTRAINT cat_team_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES cat_organization(organization_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE cat_user (
    user_id serial4 PRIMARY KEY,
	code text NULL,
    loginname text not NULL,
	username text not NULL,
    fullname varchar(200) not null,
    descript text,
    team_id int4,
    active boolean DEFAULT TRUE,
    CONSTRAINT cat_user_unique UNIQUE (username),
    CONSTRAINT cat_user_team_id_fkey FOREIGN KEY (team_id) REFERENCES cat_team(team_id)
);


---- reviewclass & visitclass

CREATE TABLE om_reviewclass
(
  id serial NOT NULL,
  idval text,
  pschema_id text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_pkey PRIMARY KEY (id)
);

CREATE TABLE om_reviewclass_x_object
(
  reviewclass_id integer NOT NULL, -- fk om_reviewclass
  object_id text NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_x_object_pkey PRIMARY KEY (reviewclass_id, object_id)
);


CREATE TABLE om_visitclass
(
  id serial NOT NULL,
  idval text,
  pschema_id text,
  descript text,
  feature_type text,
  active boolean DEFAULT true,
  CONSTRAINT om_visitclass_pkey PRIMARY KEY (id)
);


-- campaign
CREATE TABLE om_campaign
(
  campaign_id serial NOT NULL,
  name text not null, -- must add constraint unique
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  campaign_type integer not null ,  -- visit / review
  descript text,
  active boolean DEFAULT true,
  organization_id integer,
  duration text,
  status integer not NULL,
  the_geom geometry(MultiPolygon,25831),
  rotation numeric(8,4),
  exercise integer,
  serie character varying(10),
  address text,
  CONSTRAINT om_campaign_pkey PRIMARY KEY (campaign_id),
  CONSTRAINT om_campaign_check_type check (campaign_type in (1,2))
);

CREATE TABLE om_campaign_visit
(
  campaign_id integer NOT NULL,-- fk om_campaign
  visitclass_id integer, -- fk om_visitclass
  CONSTRAINT om_campaign_visit_pkey PRIMARY KEY (campaign_id)
);


CREATE TABLE om_campaign_review
(
  campaign_id integer NOT NULL, -- fk om_campaign
  reviewclass_id integer, -- fk om_reviewclass
  CONSTRAINT om_campaign_review_pkey PRIMARY KEY (campaign_id)
);


CREATE TABLE om_campaign_x_arc
(
  campaign_id integer NOT NULL, -- fk om_campaign
  arc_id character varying(16) NOT NULL, -- fk arc
  code character varying(30),
  status integer,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_x_arc_pkey PRIMARY KEY (campaign_id, arc_id)
);

CREATE TABLE om_campaign_x_connec
(
  campaign_id integer NOT NULL, -- fk om_campaign
  connec_id character varying(16) NOT NULL, -- fk connec
  code character varying(30),
  status integer,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_x_connec_pkey PRIMARY KEY (campaign_id, connec_id)
);


CREATE TABLE om_campaign_x_link
(
  campaign_id integer NOT NULL, -- fk om_campaign
  link_id integer NOT NULL, -- fk link
  code character varying(30),
  status integer,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_lot_x_link_pkey PRIMARY KEY (campaign_id, link_id)
);


CREATE TABLE om_campaign_x_node
(
  campaign_id integer NOT NULL, -- fk om_campaign
  node_id character varying(16) NOT NULL, -- fk node
  code character varying(30),
  status integer,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_x_node_pkey PRIMARY KEY (campaign_id, node_id)
);

CREATE TABLE om_campaign_x_gully
(
  campaign_id integer NOT NULL, -- fk om_campaign
  gully_id character varying(16) NOT NULL, -- fk gully
  code character varying(30),
  status integer,
  admin_observ text,
  org_observ text,
  CONSTRAINT oom_campaign_x_gully_pkey PRIMARY KEY (campaign_id, gully_id)
);


CREATE TABLE om_campaign_lot
(
  lot_id serial NOT NULL,
  name text not null, -- must add constraint unique
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  campaign_id integer not NULL, -- fk om_campaign
  workorder_id integer, -- fk workorder
  descript text,
  active boolean DEFAULT true,
  team_id integer, -- fk cat_team
  duration text,
  status integer not NULL,
  the_geom geometry(MultiPolygon,25831),
  rotation numeric(8,4),
  address text,
  CONSTRAINT om_campaign_lot_pkey PRIMARY KEY (lot_id)
);


CREATE TABLE om_campaign_lot_x_arc
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  arc_id character varying(16) NOT NULL, -- fk arc
  code character varying(30),
  status integer,
  org_observ text,
  team_observ text,
  update_at timestamp,
  update_by text,
  update_count integer,
  update_log json,
  qindex1 numeric(12,3),
  qindex2 numeric(12,3),
  CONSTRAINT om_campaign_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id)
);

CREATE TABLE om_campaign_lot_x_connec
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  connec_id character varying(16) NOT NULL, -- fk connec
  code character varying(30),
  status integer,
  org_observ text,
  team_observ text,
  update_at timestamp,
  update_by text,
  update_count integer,
  update_log json,
  qindex1 numeric(12,3),
  qindex2 numeric(12,3),
  CONSTRAINT om_campaign_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id)
);


CREATE TABLE om_campaign_lot_x_link
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  link_id integer NOT NULL, -- fk link
  code character varying(30),
  status integer,
  org_observ text,
  team_observ text,
  update_at timestamp,
  update_by text,
  update_count integer,
  update_log json,
  qindex1 numeric(12,3),
  qindex2 numeric(12,3),
  CONSTRAINT om_campaign_lot_x_link_pkey PRIMARY KEY (lot_id, link_id)
);


CREATE TABLE om_campaign_lot_x_node
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  node_id character varying(16) NOT NULL, -- fk node
  code character varying(30),
  status integer,
  org_observ text,
  team_observ text,
  update_at timestamp,
  update_by text,
  update_count integer,
  update_log json, 	
  qindex1 numeric(12,3),
  qindex2 numeric(12,3),
  CONSTRAINT om_campaign_lot_x_node_pkey PRIMARY KEY (lot_id, node_id)
);

CREATE TABLE om_campaign_lot_x_gully
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  connec_id character varying(16) NOT NULL, -- fk connec
  code character varying(30),
  status integer,
  org_observ text,
  team_observ text,
  update_at timestamp,
  update_by text,
  update_count integer,
  update_log json, 
  qindex1 numeric(12,3),
  qindex2 numeric(12,3),
  CONSTRAINT om_campaign_lot_x_gully_pkey PRIMARY KEY (lot_id, connec_id)
);


CREATE TABLE workorder_type
(
  id character varying(50) NOT NULL,
  idval character varying(50),
  CONSTRAINT ext_workorder_type_pkey PRIMARY KEY (id)
);

CREATE TABLE workorder_class
(
  id character varying(50) NOT NULL,
  idval character varying(50),
  CONSTRAINT ext_workorder_class_pkey PRIMARY KEY (id)
);

CREATE TABLE workorder
(
  workorder_id integer NOT NULL,
  workorder_name character varying(50),
  workorder_type character varying(50), --fk workorder_type
  workorder_class character varying(200), --fk workorder_class
  exercise integer,
  serie character varying(10),
  startdate date,
  address character varying(50),
  observ text,
  cost numeric,
  ct text,
  CONSTRAINT workorder_pkey PRIMARY KEY (workorder_id)
);


CREATE TABLE selector_campaign
(
  campaign_id integer, -- fk om_campaign
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_campaign_pkey PRIMARY KEY (campaign_id, cur_user)
);

CREATE TABLE selector_lot
(
  lot_id integer, -- fk om_campaign_lot
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (lot_id, cur_user)
);