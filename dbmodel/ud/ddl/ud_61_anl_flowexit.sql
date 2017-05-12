/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
-- ----------------------------
-- FLOW EXIT
-- ----------------------------

CREATE TABLE "anl_flow_exit_node" (
node_id varchar (16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_flow_exit_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_flow_exit_arc" (
arc_id varchar (16) NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT anl_flow_exit_arc_pkey PRIMARY KEY (arc_id)
);


CREATE INDEX anl_flow_exit_node_index ON anl_flow_exit_node USING GIST (the_geom);
CREATE INDEX anl_flow_exit_arc_index ON anl_flow_exit_arc USING GIST (the_geom);

