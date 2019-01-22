/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



CREATE TABLE "anl_flow_node" (
id serial NOT NULL PRIMARY KEY,
node_id varchar (16) NOT NULL,
node_type varchar (30),
expl_id integer,
context varchar (30),
cur_user varchar (30) DEFAULT "current_user"(),
the_geom public.geometry (POINT, SRID_VALUE)
);


CREATE TABLE "anl_flow_arc" (
id serial NOT NULL PRIMARY KEY,
arc_id varchar (16) NOT NULL,
arc_type varchar (30),
expl_id integer,
context varchar (30),
cur_user varchar (30) DEFAULT "current_user"(),
the_geom public.geometry (LINESTRING, SRID_VALUE)
);


CREATE TABLE anl_arc_profile_value
(
  id serial NOT NULL PRIMARY KEY,
  profile_id character varying(30),
  arc_id varchar,
  start_point varchar,
  end_point varchar
);




CREATE INDEX anl_flow_node_index ON anl_flow_node USING GIST (the_geom);
CREATE INDEX anl_flow_arc_index ON anl_flow_arc USING GIST (the_geom);

