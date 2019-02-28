/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- om_visit
ALTER TABLE om_visit ADD column lot_id integer;
ALTER TABLE om_visit ADD COLUMN class_id integer;
ALTER TABLE om_visit ADD COLUMN status integer;
ALTER TABLE om_visit ADD COLUMN feature_type text;

ALTER TABLE om_visit ALTER COLUMN visitcat_id DROP NOT NULL;

ALTER TABLE om_visit ALTER COLUMN startdate SET DEFAULT ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone


-- om_visit_event_photo
ALTER TABLE om_visit_event_photo ADD COLUMN hash text;
ALTER TABLE om_visit_event_photo ADD COLUMN filetype text;
ALTER TABLE om_visit_event_photo ADD COLUMN xcoord double precision;
ALTER TABLE om_visit_event_photo ADD COLUMN ycoord double precision;
ALTER TABLE om_visit_event_photo ADD COLUMN fextension varchar(16);


ALTER TABLE om_visit_parameter ADD COLUMN short_descript varchar(30);


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


CREATE TABLE om_visit_class_x_parameter (
    id serial primary key,
    class_id integer NOT NULL,
    parameter_id character varying(50) NOT NULL
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
  starttime timestamp DEFAULT now(),
  endtime timestamp,
  constraint om_visit_team_x_user_pkey PRIMARY KEY (team_id, user_id));
  
 
  CREATE TABLE om_visit_user_x_vehicle(
  user_id varchar(16),
  vehicle_id integer,
  starttime timestamp DEFAULT now(),
  endtime timestamp,
  constraint om_visit_user_x_vehicle_pkey PRIMARY KEY (user_id, vehicle_id));
  
  
 CREATE TABLE om_visit_cat_status(
  id serial NOT NULL primary key,
  idval character varying(30),
  descript text);

  
  CREATE TABLE om_visit_filetype_x_extension(
  filetype varchar (30),
  fextension varchar (16),
  CONSTRAINT om_visit_filetype_x_extension_pkey PRIMARY KEY (filetype, fextension));
