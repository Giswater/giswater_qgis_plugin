/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


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
  visitclass_id integer NOT NULL,
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
  periodicity integer,
  last_restart date,
  CONSTRAINT om_visit_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE selector_lot
(
  id serial NOT NULL,
  lot_id integer,
  cur_user text DEFAULT "current_user"(),
  CONSTRAINT selector_lot_pkey PRIMARY KEY (id)
);

CREATE TABLE om_visit_lot_x_arc (
    lot_id integer NOT NULL,
    arc_id character varying(16) NOT NULL,
    code character varying(30),
    status integer,
    observ text,
	unit_id int4 NULL,
	"source" varchar(16) NULL,
	length float8 NULL,
	macrounit_id int4 NULL,
	CONSTRAINT om_visit_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id),
	CONSTRAINT om_visit_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES ud.om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_visit_lot_x_arc_unit_id_fk FOREIGN KEY (lot_id,unit_id) REFERENCES ud.om_visit_lot_x_unit(lot_id,unit_id) ON DELETE SET NULL ON UPDATE CASCADE
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

CREATE TABLE om_visit_lot_x_gully (
	lot_id int4 NOT NULL,
	gully_id varchar(16) NOT NULL,
	code varchar(30) NULL,
	status int4 NULL,
	observ text NULL,
	unit_id int4 NULL,
	"source" varchar(16) NULL,
	length float8 NULL,
	macrounit_id int4 NULL,
	CONSTRAINT om_visit_lot_x_gully_pkey PRIMARY KEY (lot_id, gully_id),
	CONSTRAINT om_visit_lot_x_gully_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES ud.om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_visit_lot_x_gully_unit_id_fk FOREIGN KEY (lot_id,unit_id) REFERENCES ud.om_visit_lot_x_unit(lot_id,unit_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE om_visit_lot_x_node (
	lot_id int4 NOT NULL,
	node_id varchar(16) NOT NULL,
	code varchar(30) NULL,
	status int4 NULL,
	observ text NULL,
	unit_id int4 NULL,
	"source" varchar(16) NULL,
	macrounit_id int4 NULL,
	CONSTRAINT om_visit_lot_x_node_pkey PRIMARY KEY (lot_id, node_id),
	CONSTRAINT om_visit_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES ud.om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_visit_lot_x_node_unit_id_fk FOREIGN KEY (lot_id,unit_id) REFERENCES ud.om_visit_lot_x_unit(lot_id,unit_id) ON DELETE SET NULL ON UPDATE CASCADE
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

/*
UM data model
*/

CREATE TABLE om_visit_lot_x_unit (
	unit_id serial4 NOT NULL,
	lot_id int4 NOT NULL,
	status int4,
	orderby int4,
	the_geom geometry(multipolygon, SRID_VALUE),
	unit_type varchar(25),
    length double precision,
    way_type varchar (30),
    way_in varchar (30),
    way_out varchar (30),
    macrounit_id integer,
    trace_type varchar (30),
    trace_id integer,
    node_1 varchar (16),
    node_2 varchar (16),
    orderby_2 int4,
    user_defined boolean DEFAULT False,
    tstamp timestamp DEFAULT now(),
	CONSTRAINT om_visit_lot_x_unit_pkey PRIMARY KEY (lot_id, unit_id),
	CONSTRAINT om_visit_lot_x_unit_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES ud.om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE
);

GRANT ALL ON SEQUENCE om_visit_lot_x_unit_unit_id_seq TO role_basic;


CREATE TABLE om_visit_lot_x_macrounit (
    macrounit_id integer,
    lot_id integer,
    orderby integer,
    length double precision,
    the_geom GEOMETRY(MULTIPOLYGON, SRID_VALUE),
	CONSTRAINT om_visit_lot_x_macrounit_pkey PRIMARY KEY (macrounit_id, lot_id),
	CONSTRAINT om_visit_lot_x_macrounit_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE temp_lot_unit (
arc_id varchar(16) PRIMARY KEY,
sourcenode varchar (16),
targetnode varchar (16),
nodetype varchar(30),
isprofilesurface boolean,
direction text ,
geom1 numeric (12,4),
area  numeric (12,4),
azimuth double precision,
sys_elev numeric (12,4),
f_factor double precision,
best_candidate boolean,
coupled_arc varchar(16),
unit_id integer,
macrounit_id integer
);

ALTER TABLE om_visit_lot_x_arc ADD COLUMN unit_id integer;
ALTER TABLE om_visit_lot_x_arc ADD COLUMN source varchar(16);
ALTER TABLE om_visit_lot_x_arc ADD COLUMN length double precision;
ALTER TABLE om_visit_lot_x_arc ADD COLUMN macrounit_id integer;

ALTER TABLE om_visit_lot_x_node ADD COLUMN unit_id integer;
ALTER TABLE om_visit_lot_x_node ADD COLUMN source varchar(16);
ALTER TABLE om_visit_lot_x_node ADD COLUMN macrounit_id integer;

ALTER TABLE om_visit_lot_x_gully ADD COLUMN unit_id integer;
ALTER TABLE om_visit_lot_x_gully ADD COLUMN source varchar(16);
ALTER TABLE om_visit_lot_x_gully ADD COLUMN length double precision;
ALTER TABLE om_visit_lot_x_gully ADD COLUMN macrounit_id integer;

CREATE INDEX om_visit_lot_x_unit_lot_id ON om_visit_lot_x_unit USING btree (lot_id);
CREATE INDEX om_visit_lot_x_unit_way_type ON om_visit_lot_x_unit USING btree (way_type);
CREATE INDEX om_visit_lot_x_unit_way_in ON om_visit_lot_x_unit USING btree (way_in);
CREATE INDEX om_visit_lot_x_unit_way_out ON om_visit_lot_x_unit USING btree (way_out);
CREATE INDEX om_visit_lot_x_unit_macrounit_id ON om_visit_lot_x_unit USING btree (macrounit_id);
CREATE INDEX om_visit_lot_x_unit_parent_id ON om_visit_lot_x_unit USING btree (parent_id);
CREATE INDEX om_visit_lot_x_unit_trace_id ON om_visit_lot_x_unit USING btree (trace_id);

CREATE INDEX om_visit_lot_x_arc_arc_id ON om_visit_lot_x_arc USING btree (arc_id);
CREATE INDEX om_visit_lot_x_node_node_id ON om_visit_lot_x_node USING btree (node_id);
CREATE INDEX om_visit_lot_x_gully_gully_id ON om_visit_lot_x_gully USING btree (gully_id);
CREATE INDEX om_visit_lot_x_connec_connec_id ON om_visit_lot_x_connec USING btree (connec_id);

DELETE FROM config_param_system where parameter = 'om_lotmanage_units';
INSERT INTO config_param_system VALUES ('om_lotmanage_units', '{"arcBuffer":2, "linkBuffer":1, "nodeBuffer":5, "unitBuffer":2, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}',
'Specific configuration for plugin om_lotmanage, relate to buffer of the units and the weight for choose the best candidate on the intersections with isprofilesurface false', 
NULL, NULL, NULL, FALSE, NULL, 'ud') ON CONFLICT (parameter) DO NOTHING;


CREATE TABLE om_macrocategory (
	macrocategory_id serial NOT NULL,
	idval varchar(50) NOT NULL,
	descript text,
	CONSTRAINT om_macrocategory_pkey PRIMARY KEY (macrocategory_id)
);

GRANT ALL ON SEQUENCE om_macrocategory_macrocategory_id_seq TO role_admin;

CREATE TABLE om_category (
	category_id serial NOT NULL,
	idval varchar (50) NOT NULL,
	descript text,
	macrocategory_id integer,
	visitclass_id integer,
	feature_type varchar(10),
	the_geom geometry(MultiPolygon,SRID_VALUE),
	CONSTRAINT om_category_pkey PRIMARY KEY (category_id),
	CONSTRAINT om_category_macrocategory_id_fkey FOREIGN KEY (macrocategory_id) REFERENCES om_macrocategory(macrocategory_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_category_visitclass_id_fkey FOREIGN KEY (visitclass_id) REFERENCES config_visit_class(id) ON DELETE SET NULL ON UPDATE CASCADE
);

GRANT ALL ON SEQUENCE om_category_category_id_seq TO role_basic;

CREATE TABLE om_category_x_arc (
	arc_id varchar(16) NOT NULL,
	category_id integer NOT NULL,
	CONSTRAINT om_category_x_arc_pkey PRIMARY KEY (arc_id, category_id),
	CONSTRAINT om_category_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_category_x_arc_category_id_fkey FOREIGN KEY (category_id) REFERENCES om_category(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_category_x_node (
	node_id varchar(16) NOT NULL,
	category_id integer NOT NULL,
	CONSTRAINT om_category_x_node_pkey PRIMARY KEY (node_id, category_id),
	CONSTRAINT om_category_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_category_x_node_category_id_fkey FOREIGN KEY (category_id) REFERENCES om_category(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_category_x_connec (
	connec_id varchar(16) NOT NULL,
	category_id integer NOT NULL,
	CONSTRAINT om_category_x_connec_pkey PRIMARY KEY (connec_id, category_id),
	CONSTRAINT om_category_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_category_x_connec_category_id_fkey FOREIGN KEY (category_id) REFERENCES om_category(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE om_category_x_gully (
	gully_id varchar(16) NOT NULL,
	category_id integer NOT NULL,
	CONSTRAINT om_category_x_gully_pkey PRIMARY KEY (gully_id, category_id),
	CONSTRAINT om_category_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_category_x_gully_category_id_fkey FOREIGN KEY (category_id) REFERENCES om_category(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE temp_anlgraf (
	id serial4 NOT NULL,
	arc_id varchar(20) NULL,
	node_1 varchar(20) NULL,
	node_2 varchar(20) NULL,
	water int2 NULL,
	flag int2 NULL,
	checkf int2 NULL,
	length numeric(12, 4) NULL,
	"cost" numeric(12, 4) NULL,
	value numeric(12, 4) NULL,
	trace int4 NULL,
	orderby int4 NULL,
	isheader bool NULL,
	user_defined bool DEFAULT False,
	CONSTRAINT temp_anlgraf_pkey PRIMARY KEY (id),
	CONSTRAINT temp_anlgraf_unique UNIQUE (arc_id, node_1)
);
CREATE INDEX temp_anlgraf_arc_id ON temp_anlgraf USING btree (arc_id);
CREATE INDEX temp_anlgraf_node_1 ON temp_anlgraf USING btree (node_1);
CREATE INDEX temp_anlgraf_node_2 ON temp_anlgraf USING btree (node_2);