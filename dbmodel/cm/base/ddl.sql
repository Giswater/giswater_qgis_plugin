/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cm, public, pg_catalog;


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

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'role_cm_edit'
   ) THEN
      CREATE role role_cm_edit WITH NOSUPERUSER NOCREATEDB NOCREATEROLE inherit NOREPLICATION NOBYPASSRLS;
   END IF;
END
$$;


-- system tables
CREATE TABLE sys_table (
	id text NOT NULL,
	descript text NULL,
	sys_role varchar(30) NULL,
	project_template jsonb NULL,
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

CREATE TABLE sys_version (
	id serial4 NOT NULL,
	giswater varchar(16) NOT NULL,
	project_type varchar(16) NOT NULL,
	postgres varchar(512) NOT NULL,
	postgis varchar(512) NOT NULL,
	"date" timestamp(6) NOT NULL DEFAULT now(),
	"language" varchar(50) NOT NULL,
	epsg int4 NOT NULL,
	CONSTRAINT sys_version_pkey PRIMARY KEY (id)
);

CREATE TABLE sys_param_user (
	id text NOT NULL,
	formname text NULL,
	descript text NULL,
	sys_role varchar(30) NULL,
	idval text NULL,
	"label" text NULL,
	dv_querytext text NULL,
	dv_parent_id text NULL,
	isenabled bool NULL,
	layoutorder int4 NULL,
	project_type varchar NULL,
	isparent bool NULL,
	dv_querytext_filterc text NULL,
	feature_field_id text NULL,
	feature_dv_parent_value text NULL,
	isautoupdate bool NULL,
	"datatype" varchar(30) NULL,
	widgettype varchar(30) NULL,
	ismandatory bool NULL,
	widgetcontrols json NULL,
	vdefault text NULL,
	layoutname text NULL,
	iseditable bool NULL,
	dv_orderby_id bool NULL,
	dv_isnullvalue bool NULL,
	stylesheet json NULL,
	placeholder text NULL,
	"source" text NULL,
	CONSTRAINT sys_param_user_pkey PRIMARY KEY (id)
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
	field_layoutorder int4 NULL,
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

CREATE TABLE cm_form_config (
    id serial PRIMARY KEY,
    campaign_ids integer[] NOT NULL,
    layer_name varchar(255) NOT NULL,
    field_name varchar(255) NOT NULL,
    field_order integer,
    is_hidden boolean DEFAULT false
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

CREATE TABLE config_param_user (
	"parameter" varchar(50) NOT NULL,
	value text NULL,
	cur_user varchar(50) NOT NULL,
	CONSTRAINT config_param_user_pkey PRIMARY KEY (parameter, cur_user)
);

CREATE INDEX IF NOT EXISTS config_param_user_cur_user ON config_param_user USING btree (cur_user);
CREATE INDEX IF NOT EXISTS config_param_user_value ON config_param_user USING btree (value);

CREATE TABLE sys_typevalue (
	typevalue text NOT NULL,
	id varchar(30) NOT NULL,
	idval text NULL,
	descript text NULL,
	addparam json NULL,
	CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue, id)
);

CREATE TABLE cat_pschema (
  pschema_id serial2,
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
	expl_id int[],
	sector_id int[],
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
	role_id TEXT NULL DEFAULT 'role_cm_field',
	active bool NULL DEFAULT true,
	CONSTRAINT cat_team_pkey PRIMARY KEY (team_id),
	CONSTRAINT cat_team_unique UNIQUE (teamname, organization_id),
	CONSTRAINT cat_team_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES cat_organization(organization_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE cat_user (
  user_id serial4 PRIMARY KEY,
  username text not NULL,
  team_id int4,
  roles text[],
  active boolean DEFAULT TRUE,
  CONSTRAINT cat_user_unique UNIQUE (username),
  CONSTRAINT cat_user_team_id_fkey FOREIGN KEY (team_id) REFERENCES cat_team(team_id)
);

---- workorder
CREATE TABLE workorder_type (
  id character varying(50) NOT NULL,
  idval character varying(50),
  CONSTRAINT ext_workorder_type_pkey PRIMARY KEY (id)
);

CREATE TABLE workorder_class (
  id character varying(50) NOT NULL,
  idval character varying(50),
  CONSTRAINT ext_workorder_class_pkey PRIMARY KEY (id)
);

CREATE TABLE workorder (
  workorder_id serial4 NOT NULL,
  workorder_name character varying(50),
  workorder_type character varying(50),
  workorder_class character varying(200),
  exercise integer,
  serie character varying(10),
  startdate date,
  address character varying(50),
  observ text,
  cost numeric,
  CONSTRAINT workorder_pkey PRIMARY KEY (workorder_id),
  CONSTRAINT ext_workorder_workorder_type_fkey FOREIGN KEY (workorder_type) REFERENCES workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT workorder_workorder_class_fkey FOREIGN KEY (workorder_class) REFERENCES workorder_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE om_reviewclass (
  id serial NOT NULL,
  idval text,
  pschema_id text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_pkey PRIMARY KEY (id)
);

CREATE TABLE om_reviewclass_x_object (
  reviewclass_id integer NOT NULL,
  object_id text NOT NULL,
  orderby int2,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_x_object_pkey PRIMARY KEY (reviewclass_id, object_id)
);

CREATE TABLE om_inventoryclass (
  id serial NOT NULL,
  idval text,
  pschema_id text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT om_inventoryclass_pkey PRIMARY KEY (id)
);

CREATE TABLE om_inventory_x_object (
  inventoryclass_id integer NOT NULL,
  object_id text NOT NULL,
  orderby int2,
  active boolean DEFAULT true,
  CONSTRAINT om_inventory_x_object_pkey PRIMARY KEY (inventoryclass_id, object_id)
);

CREATE TABLE om_visitclass (
  id serial NOT NULL,
  idval text,
  pschema_id text,
  descript text,
  feature_type text,
  active boolean DEFAULT true,
  CONSTRAINT om_visitclass_pkey PRIMARY KEY (id)
);


-- campaign
CREATE TABLE om_campaign (
  campaign_id serial NOT NULL,
  name text not null,
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  campaign_type integer not null,
  descript text,
  active boolean DEFAULT true,
  organization_id integer,
  status integer not NULL,
  expl_id integer,
  sector_id integer,
  qindex1 numeric(12, 3) NULL,
  qindex2 numeric(12, 3) NULL,
  rating int2 NULL,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  CONSTRAINT om_campaign_pkey PRIMARY KEY (campaign_id),
  CONSTRAINT om_campaign_check_type check (campaign_type in (1,2,3)),
  CONSTRAINT om_campaign_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES cat_organization(organization_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE om_campaign_visit (
  campaign_id integer NOT NULL,
  visitclass_id integer,
  CONSTRAINT om_campaign_visit_pkey PRIMARY KEY (campaign_id),
  CONSTRAINT om_campaign_visit_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_team_x_user_visitclass_id_fkey FOREIGN KEY (visitclass_id) REFERENCES om_visitclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE om_campaign_review (
  campaign_id integer NOT NULL,
  reviewclass_id integer,
  CONSTRAINT om_campaign_review_pkey PRIMARY KEY (campaign_id),
  CONSTRAINT om_campaign_review_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_campaign_review_reviewclass_id_fkey FOREIGN KEY (reviewclass_id) REFERENCES om_reviewclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE om_campaign_inventory (
  campaign_id integer NOT NULL,
  inventoryclass_id integer,
  CONSTRAINT om_campaign_inventory_pkey PRIMARY KEY (campaign_id),
  CONSTRAINT om_campaign_inventory_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_campaign_inventory_inventoryclass_id_fkey FOREIGN KEY (inventoryclass_id) REFERENCES om_inventoryclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE om_campaign_inventory_x_arc (
  id serial4 NOT NULL,
  campaign_id integer NOT NULL,
  arc_id int4 NOT NULL,
  code character varying(30),
  status int2,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_inventory_x_arc_pkey PRIMARY KEY (id),
  CONSTRAINT om_campaign_inventory_x_arc_un UNIQUE (campaign_id, arc_id),
  CONSTRAINT om_campaign_inventory_x_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES cm.om_campaign_inventory (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE om_campaign_inventory_x_node (
  id serial4 NOT NULL,
  campaign_id integer NOT NULL,
  node_id int4 NOT NULL,
  code character varying(30),
  status int2,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_inventory_x_node_pkey PRIMARY KEY (id),
  CONSTRAINT om_campaign_inventory_x_node_un UNIQUE (campaign_id, node_id),
  CONSTRAINT om_campaign_inventory_x_node_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES cm.om_campaign_inventory (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE om_campaign_inventory_x_connec (
  id serial4 NOT NULL,
  campaign_id integer NOT NULL,
  connec_id int4 NOT NULL,
  code character varying(30),
  status int2,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_inventory_x_connec_pkey PRIMARY KEY (id),
  CONSTRAINT om_campaign_inventory_x_connec_un UNIQUE (campaign_id, connec_id),
  CONSTRAINT om_campaign_inventory_x_connec_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES cm.om_campaign_inventory (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE om_campaign_inventory_x_link (
  id serial4 NOT NULL,
  campaign_id integer NOT NULL,
  link_id int4 NOT NULL,
  code character varying(30),
  status int2,
  admin_observ text,
  org_observ text,
  CONSTRAINT om_campaign_inventory_x_link_pkey PRIMARY KEY (id),
  CONSTRAINT om_campaign_inventory_x_link_un UNIQUE (campaign_id, link_id),
  CONSTRAINT om_campaign_inventory_x_link_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES cm.om_campaign_inventory (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE om_campaign_x_arc (
	id serial4 NOT NULL,
	campaign_id int4 NOT NULL,
	arc_id int4 NOT NULL,
	node_1 int4 NULL,
	node_2 int4 NULL,
	code varchar(30) NULL,
	status int2 NULL,
	admin_observ text NULL,
	org_observ text NULL,
	arccat_id text NULL,
	arc_type text NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	the_geom geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT om_campaign_x_arc_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_x_arc_un UNIQUE (campaign_id, arc_id),
	CONSTRAINT om_campaign_x_arc_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign(campaign_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_campaign_x_connec (
	id serial4 NOT NULL,
	campaign_id int4 NOT NULL,
	connec_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	admin_observ text NULL,
	org_observ text NULL,
	conneccat_id text NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	the_geom geometry(point, SRID_VALUE) NULL,
	CONSTRAINT om_campaign_x_connec_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_x_connec_un UNIQUE (campaign_id, connec_id),
	CONSTRAINT om_campaign_x_connec_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign(campaign_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE om_campaign_x_link (
	id serial4 NOT NULL,
	campaign_id int4 NOT NULL,
	link_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	admin_observ text NULL,
	org_observ text NULL,
	linkcat_id text NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	the_geom geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT om_campaign_x_link_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_x_link_un UNIQUE (campaign_id, link_id),
	CONSTRAINT om_campaign_x_link_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign(campaign_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_campaign_x_node (
	id serial4 NOT NULL,
	campaign_id int4 NOT NULL,
	node_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	admin_observ text NULL,
	org_observ text NULL,
	nodecat_id text NULL,
	node_type text NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	the_geom geometry(point, SRID_VALUE) NULL,
	CONSTRAINT om_campaign_x_node_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_x_node_un UNIQUE (campaign_id, node_id),
	CONSTRAINT om_campaign_x_node_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign(campaign_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_campaign_lot (
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
  status int2 not NULL,
  expl_id integer,
  sector_id integer,
  qindex1 numeric(12, 3) NULL,
  qindex2 numeric(12, 3) NULL,
  rating int2 NULL,
  the_geom geometry(MULTIPOLYGON,SRID_VALUE),
  CONSTRAINT om_campaign_lot_pkey PRIMARY KEY (lot_id),
  CONSTRAINT om_campaign_lot_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT om_campaign_lot_workorder_id_fkey FOREIGN KEY (workorder_id) REFERENCES workorder (workorder_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT om_campaign_lot_team_id_fkey FOREIGN KEY (team_id) REFERENCES cat_team (team_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE om_campaign_lot_x_arc (
	id serial4 NOT NULL,
	lot_id int4 NOT NULL,
	arc_id int4 NOT NULL,
	node_1 int4 NULL,
	node_2 int4 NULL,
	code varchar(30) NULL,
	status int2 NULL,
	org_observ text NULL,
	team_observ text NULL,
	update_count int4 NULL,
	update_log jsonb NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	action int2 NULL,
	CONSTRAINT om_campaign_lot_x_arc_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_lot_x_arc_un UNIQUE (lot_id, arc_id),
	CONSTRAINT om_campaign_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot(lot_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_campaign_lot_x_connec (
	id serial4 NOT NULL,
	lot_id int4 NOT NULL,
	connec_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	org_observ text NULL,
	team_observ text NULL,
	update_count int4 NULL,
	update_log jsonb NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	action int2 NULL,
	CONSTRAINT om_campaign_lot_x_connec_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_lot_x_connec_un UNIQUE (lot_id, connec_id),
	CONSTRAINT om_campaign_lot_x_connec_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot(lot_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE om_campaign_lot_x_link (
	id serial4 NOT NULL,
	lot_id int4 NOT NULL,
	link_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	org_observ text NULL,
	team_observ text NULL,
	update_count int4 NULL,
	update_log jsonb NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	action int2 NULL,
	CONSTRAINT om_campaign_lot_x_link_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_lot_x_link_un UNIQUE (lot_id, link_id),
	CONSTRAINT om_campaign_lot_x_link_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot(lot_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE om_campaign_lot_x_node (
	id serial4 NOT NULL,
	lot_id int4 NOT NULL,
	node_id int4 NOT NULL,
	code varchar(30) NULL,
	status int2 NULL,
	org_observ text NULL,
	team_observ text NULL,
	update_count int4 NULL,
	update_log jsonb NULL,
	qindex1 numeric(12, 3) NULL,
	qindex2 numeric(12, 3) NULL,
	action int2 NULL,
	CONSTRAINT om_campaign_lot_x_node_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_lot_x_node_un UNIQUE (lot_id, node_id),
	CONSTRAINT om_campaign_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot(lot_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE config_outlayers (
	feature_type text[] NOT NULL,
	column_name text NOT NULL,
	min_value text,
	max_value text,
	except_error boolean,
	except_message text,
	CONSTRAINT config_outlayers_pkey PRIMARY KEY (feature_type, column_name)
);

-- New rating configuration tables
CREATE TABLE config_qindex_rating (
  id serial4 PRIMARY KEY,
  minval numeric(12,3),
  maxval numeric(12,3),
  rating text
);

CREATE TABLE config_qindex_keyparam (
  layer text[] NOT NULL,
  column_name text NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT config_qindex_keyparam_pkey PRIMARY KEY (layer, column_name)
);

CREATE TABLE selector_campaign (
  campaign_id integer, -- fk om_campaign
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_campaign_pkey PRIMARY KEY (campaign_id, cur_user),
  CONSTRAINT selector_campaign_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE selector_lot (
  lot_id integer, -- fk om_campaign_lot
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (lot_id, cur_user),
  CONSTRAINT selector_lot_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot (lot_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT selector_lot_lot_id_cur_user_unique UNIQUE (lot_id, cur_user)
);

CREATE TABLE sys_fprocess (
	fid int4 NOT NULL,
	fprocess_name varchar(100) NULL,
	project_type varchar(6) NULL,
	parameters json NULL,
	"source" text NULL,
	isaudit bool NULL,
	fprocess_type text NULL,
	addparam json NULL,
	except_level int4 NULL,
	except_msg text NULL,
	except_table text NULL,
	except_table_msg text NULL,
	query_text text NULL,
	info_msg text NULL,
	function_name text NULL,
	active bool NULL,
	CONSTRAINT sys_fprocess_pkey PRIMARY KEY (fid)
);

CREATE TABLE config_form_tableview (
	location_type varchar(50) NOT NULL,
	project_type varchar(50) NOT NULL,
	objectname varchar(50) NOT NULL,
	columnname varchar(50) NOT NULL,
	columnindex int2 NULL,
	visible bool NULL,
	width int4 NULL,
	alias varchar(50) NULL,
	"style" json NULL,
	addparam json NULL,
	CONSTRAINT config_form_tableview_pkey PRIMARY KEY (objectname, columnname)
);

CREATE TABLE audit_check_data (
	id serial4 NOT NULL,
	fid int2 NULL,
	result_id varchar(50) NULL,
	table_id text NULL,
	column_id text NULL,
	criticity int2 NULL,
	enabled bool NULL,
	error_message text NULL,
	tstamp timestamp NULL DEFAULT now(),
	cur_user text NULL DEFAULT "current_user"(),
	feature_type text NULL,
	feature_id text NULL,
	addparam json NULL,
	fcount int4 NULL,
	CONSTRAINT audit_check_data_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE cm.cm_urn_id_seq
    INCREMENT BY -1
    MAXVALUE 1
    MINVALUE -9223372036854775807
    START -1
    CACHE 1
    NO CYCLE;

-- CM AUDIT TABLES (in audit schema):
CREATE SCHEMA IF NOT EXISTS audit;
CREATE TABLE audit.cm_log (
	table_name text NOT NULL,
  mission_type text NOT NULL,
	mission_id int4 NOT NULL,
	feature_id int4 NOT NULL,
	feature_type text NULL,
	"action" text NULL,
	sql varchar(100) NULL,
	old_value json NULL,
	new_value json NULL,
	insert_by TEXT NULL,
	insert_at timestamptz NOT NULL,
	CONSTRAINT audit_cm_log_pkey PRIMARY KEY (table_name, mission_type, mission_id, feature_id, insert_at)
);

CREATE INDEX IF NOT EXISTS audit_cm_log_insert_at ON audit.cm_log USING btree (insert_at);
CREATE INDEX IF NOT EXISTS audit_cm_log_mission_type ON audit.cm_log USING btree (mission_type);
CREATE INDEX IF NOT EXISTS audit_cm_log_action_insert_at ON audit.cm_log USING btree ("action", insert_at);

CREATE TABLE audit.cm_log_error (
  id serial4 NOT NULL,
  context text NOT NULL,
  error_code text NOT NULL,
  error_message text NOT NULL,
  insert_by TEXT NULL,
  insert_at timestamptz NOT NULL,
  CONSTRAINT audit_cm_log_error_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS audit_cm_log_error_insert_at ON audit.cm_log_error USING btree (insert_at);
CREATE INDEX IF NOT EXISTS audit_cm_log_error_error_code ON audit.cm_log_error USING btree (error_code);

CREATE TABLE cm.doc (
	id serial NOT NULL,
	name text NULL,
	doc_type varchar(30) NULL,
	"path" text NULL,
	observ varchar(512) NULL,
	"date" timestamp(6) DEFAULT now() NULL,
	user_name varchar(50) DEFAULT USER NULL,
	tstamp timestamp DEFAULT now() NULL,
	the_geom public.geometry(point, 8908) NULL,
	CONSTRAINT doc_pkey PRIMARY KEY (id),
	CONSTRAINT name_chk UNIQUE (name)
);

--drop table cm.doc_x_node;
CREATE TABLE cm.doc_x_node (
	doc_id int4 NOT NULL,
	node_id int4 NULL,
	node_uuid uuid NOT NULL,
	featurecat_id varchar(30),
	CONSTRAINT doc_x_node_pkey PRIMARY KEY (doc_id, node_uuid)
);

ALTER TABLE cm.doc_x_node ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES cm.doc(id) ON DELETE CASCADE ON UPDATE CASCADE;

--drop table cm.doc_x_arc;
CREATE TABLE cm.doc_x_arc (
	doc_id int4 NOT NULL,
	arc_id int4 NULL,
	arc_uuid uuid NOT NULL,
	featurecat_id varchar(30),
	CONSTRAINT doc_x_arc_pkey PRIMARY KEY (doc_id, arc_uuid)
);

ALTER TABLE cm.doc_x_arc ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES cm.doc(id) ON DELETE CASCADE ON UPDATE CASCADE;

--drop table cm.doc_x_connec;
CREATE TABLE cm.doc_x_connec (
	doc_id int4 NOT NULL,
	connec_id int4 NULL,
	connec_uuid uuid NOT NULL,
	CONSTRAINT doc_x_connec_pkey PRIMARY KEY (doc_id, connec_uuid)
);

ALTER TABLE cm.doc_x_connec ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES cm.doc(id) ON DELETE CASCADE ON UPDATE CASCADE;

--drop table cm.doc_x_link;
CREATE TABLE cm.doc_x_link (
	doc_id int4 NOT NULL,
	link_id int4 NULL,
	link_uuid uuid NOT NULL,
	CONSTRAINT doc_x_link_pkey PRIMARY KEY (doc_id, link_uuid)
);

ALTER TABLE cm.doc_x_link ADD CONSTRAINT doc_x_link_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES cm.doc(id) ON DELETE CASCADE ON UPDATE CASCADE;

