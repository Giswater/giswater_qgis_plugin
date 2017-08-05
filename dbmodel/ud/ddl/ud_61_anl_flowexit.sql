/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "ud30", public, pg_catalog;


-- ----------------------------
-- FLOW EXIT
-- ----------------------------

CREATE TABLE "anl_flow_exit_node" (
id serial NOT NULL PRIMARY KEY,
cur_user varchar (30) NOT NULL, 
node_id varchar (16) NOT NULL,
the_geom public.geometry (POINT, 25831)
);


CREATE TABLE "anl_flow_exit_arc" (
id serial NOT NULL PRIMARY KEY,
cur_user varchar (30) NOT NULL, 
arc_id varchar (16) NOT NULL,
the_geom public.geometry (LINESTRING, 25831)
);



-- ----------------------------
-- FLOW TRACE
-- ----------------------------


CREATE TABLE "anl_flow_trace_node" (
id serial NOT NULL PRIMARY KEY,
cur_user varchar (30) NOT NULL, 
node_id varchar (16) NOT NULL,
the_geom public.geometry (POINT, 25831)
);


CREATE TABLE "anl_flow_trace_arc" (
id serial NOT NULL PRIMARY KEY,
cur_user varchar (30) NOT NULL, 
arc_id varchar (16) NOT NULL,
the_geom public.geometry (LINESTRING, 25831)
);



CREATE INDEX anl_flow_exit_node_index ON anl_flow_exit_node USING GIST (the_geom);
CREATE INDEX anl_flow_exit_arc_index ON anl_flow_exit_arc USING GIST (the_geom);
CREATE INDEX anl_flow_trace_node_index ON anl_flow_trace_node USING GIST (the_geom);
CREATE INDEX anl_flow_trace_arc_index ON anl_flow_trace_arc USING GIST (the_geom);


