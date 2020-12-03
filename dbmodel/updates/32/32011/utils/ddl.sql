/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- om_visit
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"lot_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"class_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"status", "dataType":"integer"}}$$);

-- om_visit_event_photo
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_event_photo", "column":"hash", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_event_photo", "column":"filetype", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_event_photo", "column":"xcoord", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_event_photo", "column":"ycoord", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_event_photo", "column":"fextension", "dataType":"varchar(16)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_parameter", "column":"short_descript", "dataType":"varchar(30)"}}$$);


ALTER TABLE om_visit ALTER COLUMN startdate SET DEFAULT ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone;
ALTER TABLE om_visit ALTER COLUMN visitcat_id DROP NOT NULL;



CREATE TABLE om_visit_type(
  id serial PRIMARY KEY,
  idval character varying(30),
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
  visit_type integer,
  CONSTRAINT om_visit_class_pkey PRIMARY KEY (id)
);


CREATE TABLE om_visit_class_x_parameter (
    id serial primary key,
    class_id integer NOT NULL,
    parameter_id character varying(50) NOT NULL
);


CREATE TABLE om_visit_lot(
  id serial NOT NULL PRIMARY KEY,
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
  the_geom public.geometry(MULTIPOLYGON, SRID_VALUE),
  rotation numeric(8,4),
  class_id character varying(5),
  exercice integer,
  serie character varying(10),
  "number" integer,
  adreca text
);
  
   

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
  
 
  CREATE TABLE om_visit_team_x_user(
  team_id integer,
  user_id varchar(16),
  starttime timestamp DEFAULT now(),
  endtime timestamp,
  constraint om_visit_team_x_user_pkey PRIMARY KEY (team_id, user_id));
    
  
 CREATE TABLE om_visit_cat_status(
  id serial NOT NULL primary key,
  idval character varying(30),
  descript text);
  
   
  CREATE TABLE om_visit_filetype_x_extension(
  filetype varchar (30),
  fextension varchar (16),
  CONSTRAINT om_visit_filetype_x_extension_pkey PRIMARY KEY (filetype, fextension));

  
  CREATE TABLE om_visit_lot_x_user(
  id serial NOT NULL,
  user_id character varying(16) NOT NULL DEFAULT "current_user"(),
  team_id integer NOT NULL,
  lot_id integer NOT NULL,
  starttime timestamp without time zone DEFAULT ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone,
  endtime timestamp without time zone,
  the_geom geometry(Point,SRID_VALUE),
  CONSTRAINT om_visit_lot_x_user_pkey PRIMARY KEY (id));