/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE SCHEMA "SCHEMA_NAME";

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE cm.cat_role (
	role_id serial4 PRIMARY KEY,
	descript text,
	active boolean DEFAULT true
);

CREATE TABLE cm.cat_organization (
	organization_id serial4 NOT NULL,
	code text NULL,
	name text NULL,
	descript text NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT cat_organization_pkey PRIMARY KEY (organization_id)
);

CREATE TABLE cm.cat_team (
	team_id serial4 NOT NULL,
	code text NULL,
	name text NULL,
	organization_id int4 NOT NULL,
	descript text NULL,
	role_id TEXT NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT cat_team_pkey PRIMARY KEY (team_id, organization_id),
	CONSTRAINT cat_team_unique UNIQUE (team_id),
	CONSTRAINT cat_team_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES cm.cat_organization(organization_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cat_user (
    user_id text PRIMARY KEY,
    loginname varchar(100) NOT NULL,
    code varchar(50),
    name varchar(200),
    descript text,
    team_id int4,
    active boolean DEFAULT TRUE,
    CONSTRAINT cat_user_team_id_fkey FOREIGN KEY (team_id) REFERENCES cat_team(team_id)
);

CREATE TABLE om_team_x_user (
	id serial4 NOT NULL,
	user_id text NULL,
	team_id int4 NULL,
	CONSTRAINT om_team_x_user_pkey PRIMARY KEY (id),
	CONSTRAINT om_team_x_user_unique UNIQUE (user_id, team_id),
	CONSTRAINT om_team_x_user_team_id_fkey FOREIGN KEY (team_id) REFERENCES cm.cat_team(team_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_team_x_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES cm.cat_user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);


---- reviewclass & visitclass

CREATE TABLE om_reviewclass
(
  id serial NOT NULL, 
  idval text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_pkey PRIMARY KEY (id)
);

CREATE TABLE om_reviewclass_x_layer
(
  reviewclass_id integer NOT NULL, -- fk om_reviewclass
  layer_id text NOT NULL,
  schema_name text,
  feature_type text,
  active boolean DEFAULT true,
  CONSTRAINT om_reviewclass_x_layer_pkey PRIMARY KEY (schema_name, reviewclass_id, layer_id)
);


CREATE TABLE om_visitclass
(
  id serial NOT NULL,
  idval text,
  descript text,
  feature_type text,
  layer_id text NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT om_visitclass_pkey PRIMARY KEY (id)
);


-- campaign
CREATE TABLE om_campaign
(
  id serial NOT NULL,
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  campaign_type integer,  -- visit / review
  descript text,
  active boolean DEFAULT true,
  organization_id integer,
  duration text,
  status integer,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  rotation numeric(8,4),
  exercise integer,
  serie character varying(10),
  address text,
  CONSTRAINT om_campaign_pkey PRIMARY KEY (id)
);

CREATE TABLE om_campaign_visit
(
  campaign_id integer NOT NULL,-- fk om_campaign
  visitclass_id integer, -- fk om_visitclass
  CONSTRAINT om_campaign_visit_pkey PRIMARY KEY (campaign_id, visitclass_id)
);


CREATE TABLE om_campaign_review
(
  campaign_id integer NOT NULL, -- fk om_campaign
  reviewclass_id integer, -- fk om_reviewclass
  CONSTRAINT om_campaign_review_pkey PRIMARY KEY (campaign_id, reviewclass_id)
);

CREATE TABLE selector_campaign
(
  id serial NOT NULL,
  campaign_id integer, -- fk om_campaign
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_campaign_pkey PRIMARY KEY (id)
);


CREATE TABLE om_campaign_x_arc
(
  campaign_id integer NOT NULL, -- fk om_campaign
  arc_id character varying(16) NOT NULL, -- fk arc
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_x_arc_pkey PRIMARY KEY (campaign_id, arc_id)
);

CREATE TABLE om_campaign_x_connec
(
  campaign_id integer NOT NULL, -- fk om_campaign
  connec_id character varying(16) NOT NULL, -- fk connec
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_x_connec_pkey PRIMARY KEY (campaign_id, connec_id)
);


CREATE TABLE om_campaign_x_link
(
  campaign_id integer NOT NULL, -- fk om_campaign
  link_id integer NOT NULL, -- fk link
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_lot_x_link_pkey PRIMARY KEY (campaign_id, link_id)
);


CREATE TABLE om_campaign_x_node
(
  campaign_id integer NOT NULL, -- fk om_campaign
  node_id character varying(16) NOT NULL, -- fk node
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_x_node_pkey PRIMARY KEY (campaign_id, node_id)
);


CREATE TABLE om_campaign_lot
(
  id serial NOT NULL,
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  campaign_id integer, -- fk om_campaign
  workorder_id integer, -- fk workorder
  descript text,
  active boolean DEFAULT true,
  team_id integer, -- fk cat_team
  duration text,
  status integer,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  rotation numeric(8,4),
  address text,
  CONSTRAINT om_campaign_lot_pkey PRIMARY KEY (id)
);


CREATE TABLE selector_lot
(
  id serial NOT NULL,
  lot_id integer, -- fk om_campaign_lot
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE om_campaign_lot_x_arc
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  arc_id character varying(16) NOT NULL, -- fk arc
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id)
);

CREATE TABLE om_campaign_lot_x_connec
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  connec_id character varying(16) NOT NULL, -- fk connec
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id)
);


CREATE TABLE om_campaign_lot_x_link
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  link_id integer NOT NULL, -- fk link
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_link_pkey PRIMARY KEY (lot_id, link_id)
);


CREATE TABLE om_campaign_lot_x_node
(
  lot_id integer NOT NULL, -- fk om_campaign_lot
  node_id character varying(16) NOT NULL, -- fk node
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_node_pkey PRIMARY KEY (lot_id, node_id)
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

CREATE TABLE cm.selector_campaign_lot (
	id serial4 NOT NULL,
	lot_id int4 NULL,
	cur_user text NULL DEFAULT "current_user"(),
	CONSTRAINT selector_campaign_lot_pkey PRIMARY KEY (id),
	CONSTRAINT selector_campaign_lot_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES cm.om_campaign_lot(id) ON DELETE CASCADE ON UPDATE CASCADE
);
