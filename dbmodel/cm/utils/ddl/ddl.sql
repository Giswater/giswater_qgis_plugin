/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE SCHEMA "SCHEMA_NAME";

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE cat_organitzation
(
  id serial NOT NULL,
  idval text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT cat_organitzation_pkey PRIMARY KEY (id)
);


CREATE TABLE cat_team
(
  id serial NOT NULL,
  idval text,
  organitzation_id text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT cat_team_pkey PRIMARY KEY (id, organitzation_id)
);



CREATE TABLE om_team_x_user
(
  id serial NOT NULL,
  user_id character varying(50),
  team_id integer,
  CONSTRAINT om_team_x_user_pkey PRIMARY KEY (id)
);


CREATE TABLE om_campaignclass
(
  id serial NOT NULL,
  idval text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT om_campaignclass_pkey PRIMARY KEY (id)
);


CREATE TABLE campaignclass_x_layer
(
  campaignclass_id integer NOT NULL,
  layer text NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT cat_organitzation_pkey PRIMARY KEY (visitclass_id, layer)
);


CREATE TABLE om_campaign
(
  id serial NOT NULL,
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  visitclass_id integer,
  descript text,
  active boolean DEFAULT true,
  organitzation_id integer,
  duration text,
  status integer,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  rotation numeric(8,4),
  exercise integer,
  serie character varying(10),
  address text,
  CONSTRAINT om_visit_campaign_pkey PRIMARY KEY (id)
);


CREATE TABLE selector_campaign
(
  id serial NOT NULL,
  campaing_id integer,
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_campaign_pkey PRIMARY KEY (id)
);


CREATE TABLE om_campaign_x_arc
(
  campaing_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_x_arc_pkey PRIMARY KEY (campaing_id, arc_id)
);

CREATE TABLE om_campaign_x_connec
(
  campaign_id integer NOT NULL,
  connec_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_x_connec_pkey PRIMARY KEY (campaign_id, connec_id)
);


CREATE TABLE om_campaign_x_link
(
  campaign_id integer NOT NULL,
  link_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_lot_x_link_pkey PRIMARY KEY (campaign_id, link_id)
);


CREATE TABLE om_campaign_x_node
(
  campaign_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
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
  campaign_id integer,
  descript text,
  active boolean DEFAULT true,
  team_id integer,
  duration text,
  feature_type text,
  status integer,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  rotation numeric(8,4),
  class_id character varying(5),
  exercise integer,
  serie character varying(10),
  "number" integer,
  address text,
  CONSTRAINT om_campaign_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE selector_lot
(
  id serial NOT NULL,
  lot_id integer,
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE om_campaign_lot_x_arc
(
  lot_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id)
);

CREATE TABLE om_campaign_lot_x_connec
(
  lot_id integer NOT NULL,
  connec_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id)
);


CREATE TABLE om_campaign_lot_x_link
(
  lot_id integer NOT NULL,
  link_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_link_pkey PRIMARY KEY (lot_id, link_id)
);


CREATE TABLE om_campaign_lot_x_node
(
  lot_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_campaign_lot_x_node_pkey PRIMARY KEY (lot_id, node_id)
);

CREATE TABLE config_visit_class_x_workorder
(
  visitclass_id integer NOT NULL,
  workorder_type character varying(50) NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT config_visit_class_x_workorder_pkey PRIMARY KEY (visitclass_id, workorder_type)
);

CREATE TABLE ext_workorder_type
(
  id character varying(50) NOT NULL,
  idval character varying(50),
  class_id character varying(50),
  CONSTRAINT ext_workorder_type_pkey PRIMARY KEY (id)
);

CREATE TABLE ext_workorder_class
(
  id character varying(50) NOT NULL,
  idval character varying(50),
  CONSTRAINT ext_workorder_class_pkey PRIMARY KEY (id)
);

CREATE TABLE ext_workorder
(
  workorder_id integer NOT NULL,
  workorder_name character varying(50),
  workorder_type character varying(50),
  workorder_class character varying(200),
  exercise integer,
  serie character varying(10),
  startdate date,
  address character varying(50),
  visitclass_id integer,
  observations text,
  cost numeric,
  ct text,
  CONSTRAINT ext_workorder_pkey PRIMARY KEY (workcat_id)
);
