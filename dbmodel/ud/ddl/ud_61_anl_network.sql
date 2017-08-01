/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



 -- ANALYSIS
 
 CREATE TABLE "anl_node_sink" (
node_id varchar (16) NOT NULL,
num_arcs integer,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_sink_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_node_flowregulator" (
  node_id character varying(16) NOT NULL,
  the_geom geometry(Point,SRID_VALUE),
  CONSTRAINT anl_node_floregulator_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_node_exit_upper_intro"(
arc_id character varying(16),
the_geom geometry(LINESTRING,SRID_VALUE),
CONSTRAINT anl_node_exit_upper_intro_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_arc_intersection"(
arc_id character varying(16),
the_geom geometry(LINESTRING,SRID_VALUE),
CONSTRAINT anl_arc_intersection_pkey PRIMARY KEY (arc_id)
);


 CREATE TABLE "anl_arc_inverted"(
arc_id character varying(16),
the_geom geometry(LINESTRING,SRID_VALUE),
CONSTRAINT anl_arc_inverted_pkey PRIMARY KEY (arc_id)
);



CREATE INDEX anl_node_sink_index ON anl_node_sink USING GIST (the_geom);
CREATE INDEX anl_node_flowregulator_index   ON anl_node_flowregulator  USING gist(the_geom);
CREATE INDEX anl_node_exit_upper_intro_index   ON anl_node_exit_upper_intro   USING gist(the_geom);
CREATE INDEX anl_arc_intersection_index   ON anl_arc_intersection   USING gist(the_geom);
CREATE INDEX anl_arc_inverted_index   ON anl_arc_inverted   USING gist(the_geom);
