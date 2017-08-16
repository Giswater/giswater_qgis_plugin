/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- TOPOLOGY TOOLS
-- ----------------------------

SET search_path = "SCHEMA_NAME", public;


CREATE TABLE "anl_node_orphan" (
node_id varchar(16),
node_type varchar (30),
the_geom public.geometry(POINT, SRID_VALUE),
CONSTRAINT anl_node_orphan_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_node_duplicated" (
node_id varchar (16) NOT NULL,
node_conserv varchar (16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_node_duplicated_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "anl_connec_duplicated"(
id serial NOT NULL,
connec_id character varying(16),
connec_conserv character varying(16),
the_geom geometry(POINT, SRID_VALUE),
CONSTRAINT anl_connec_duplicated_pkey PRIMARY KEY (id)
);


CREATE TABLE "anl_arc_same_startend"(
arc_id character varying(16),
length float,
the_geom geometry(LINESTRING,SRID_VALUE),
CONSTRAINT anl_arc_same_startend_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "anl_arc_no_startend_node"(
id serial NOT NULL PRIMARY KEY,
arc_id character varying(16),
the_geom geometry(LINESTRING,SRID_VALUE),
the_geom_p geometry(POINT,SRID_VALUE)
);



CREATE INDEX anl_node_orphan_index ON anl_node_orphan USING GIST (the_geom);
CREATE INDEX anl_node_duplicated_index ON anl_node_duplicated USING GIST (the_geom);
CREATE INDEX anl_connec_duplicated_index ON anl_connec_duplicated USING gist (the_geom);
CREATE INDEX anl_arc_same_startend_index ON anl_arc_same_startend USING gist (the_geom);
CREATE INDEX anl_arc_no_startend_node_index ON anl_arc_no_startend_node USING GIST (the_geom);

