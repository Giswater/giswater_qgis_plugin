/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- TOPOLOGY TOOLS
-- ----------------------------

SET search_path = "SCHEMA_NAME", public;


CREATE TABLE "topo_unconnected_node" (
node_id varchar (16) NOT NULL,
value float,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT topo_uncon_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "topo_sink_node" (
node_id varchar (16) NOT NULL,
value float,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT topo_sink_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "topo_duplicated_node" (
node_id varchar (16) NOT NULL,
value float,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT topo_duplicated_node_pkey PRIMARY KEY (node_id)
);



CREATE INDEX topo_unconnected_node_index ON topo_unconnected_node USING GIST (the_geom);
CREATE INDEX topo_sink_node_index ON topo_sink_node USING GIST (the_geom);
CREATE INDEX topo_duplicated_node_index ON topo_duplicated_node USING GIST (the_geom);

