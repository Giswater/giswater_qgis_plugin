/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE SCHEMA "SCHEMA_NAME";

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE cat_team
(
  id serial NOT NULL,
  idval text,
  descript text,
  active boolean DEFAULT true,
  CONSTRAINT cat_team_pkey PRIMARY KEY (id)
);

CREATE TABLE om_visit_lot
(
  id serial NOT NULL,
  startdate date DEFAULT now(),
  enddate date,
  real_startdate date,
  real_enddate date,
  visitclass_id integer,
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
  CONSTRAINT om_visit_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE selector_lot
(
  id serial NOT NULL,
  lot_id integer,
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE om_visit_lot_x_arc
(
  lot_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_visit_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id)
);

CREATE TABLE om_visit_lot_x_connec
(
  lot_id integer NOT NULL,
  connec_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_visit_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id)
);

CREATE TABLE om_visit_lot_x_node
(
  lot_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_visit_lot_x_node_pkey PRIMARY KEY (lot_id, node_id)
);

CREATE TABLE config_visit_class_x_workorder
(
  visitclass_id integer NOT NULL,
  wotype_id character varying(50) NOT NULL,
  active boolean DEFAULT true,
  CONSTRAINT config_visit_class_x_workorder_pkey PRIMARY KEY (visitclass_id, wotype_id)
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
  class_id integer NOT NULL,
  class_name character varying(50),
  exercise integer,
  serie character varying(10),
  "number" integer,
  startdate date,
  address character varying(50),
  wotype_id character varying(50),
  visitclass_id integer,
  wotype_name character varying(120),
  observations text,
  cost numeric,
  ct text,
  CONSTRAINT ext_workorder_pkey PRIMARY KEY (class_id)
);

CREATE TABLE om_visit_lot_x_user
(
  id serial NOT NULL,
  user_id character varying(16) NOT NULL DEFAULT "current_user"(),
  team_id integer NOT NULL,
  lot_id integer NOT NULL,
  starttime timestamp without time zone DEFAULT ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone,
  endtime timestamp without time zone,
  the_geom geometry(Point,SRID_VALUE),
  vehicle_id integer,
  CONSTRAINT om_visit_lot_x_user_pkey PRIMARY KEY (id)
);


CREATE TABLE ext_cat_vehicle
(
  id character varying(50) NOT NULL,
  idval character varying(50),
  descript character varying(50),
  model character varying(50),
  number_plate character varying(50),
  CONSTRAINT ext_cat_vehicle_pkey PRIMARY KEY (id)
);

CREATE TABLE om_team_x_vehicle
(
  id serial NOT NULL,
  team_id integer,
  vehicle_id character varying(50),
  CONSTRAINT om_team_x_vehicle_pkey PRIMARY KEY (id)
);

CREATE TABLE om_vehicle_x_parameters
(
  id serial NOT NULL,
  vehicle_id character varying(50),
  lot_id integer,
  team_id integer,
  image text,
  load character varying(50),
  cur_user character varying(50) DEFAULT "current_user"(),
  tstamp timestamp without time zone,
  CONSTRAINT om_vehicle_x_parameters_pkey PRIMARY KEY (id)
);

CREATE TABLE om_team_x_visitclass
(
  id serial NOT NULL,
  team_id integer,
  visitclass_id integer,
  CONSTRAINT om_team_x_visitclass_pkey PRIMARY KEY (id)
);

CREATE TABLE om_team_x_user
(
  id serial NOT NULL,
  user_id character varying(50),
  team_id integer,
  CONSTRAINT om_team_x_user_pkey PRIMARY KEY (id)
);