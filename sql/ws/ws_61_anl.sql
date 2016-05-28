/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- MINCUT
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."anl_mincut_polygon" (
polygon_id varchar (16) NOT NULL,
the_geom public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT mincut_polygon_pkey PRIMARY KEY (polygon_id)
);


CREATE TABLE "SCHEMA_NAME"."anl_mincut_node" (
node_id varchar (16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_mincut_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."anl_mincut_arc" (
arc_id varchar (16) NOT NULL,
the_geom public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT anl_mincut_arc_pkey PRIMARY KEY (arc_id)
);


ALTER TABLE "SCHEMA_NAME"."anl_mincut_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."anl_mincut_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;



CREATE INDEX mincut_polygon_index ON anl_mincut_polygon USING GIST (the_geom);
CREATE INDEX mincut_node_index ON anl_mincut_node USING GIST (the_geom);
CREATE INDEX mincut_arc_index ON anl_mincut_arc USING GIST (the_geom);



