/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;






 -- PROFILE TOOLS

CREATE TABLE anl_arc_profile_value
(
  id serial NOT NULL,
  profile_id character varying(30) NOT NULL,
  arc_id varchar NOT NULL,
  start_point varchar,
  end_point varchar,
  CONSTRAINT anl_arc_profile_value_pkey PRIMARY KEY (id)
);


 -- ANALYSIS
 
 CREATE TABLE "anl_node_sink" (
node_id varchar (16) NOT NULL,
num_arcs integer,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_sink_pkey PRIMARY KEY (node_id)
);

CREATE INDEX anl_node_sink_index ON anl_node_sink USING GIST (the_geom);

 