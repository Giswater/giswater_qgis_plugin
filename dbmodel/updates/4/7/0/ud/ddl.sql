/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 13/01/2026
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"treatment_type", "dataType":"int4", "isUtils":"False"}}$$);

-- 19/01/2026
DROP VIEW IF EXISTS ve_dma;
ALTER TABLE dma ALTER COLUMN the_geom TYPE public.geometry(multipolygon, 25831) USING the_geom::public.geometry::public.geometry(multipolygon, 25831);
ALTER TABLE dma ALTER COLUMN graphconfig SET DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json;

-- 22/01/2026
CREATE TABLE dwfzone_graph (
	node_id_parent_1 int4 NOT NULL,
	feature_class_1 varchar(30),
	dwfzone_1 int4,
	node_id_parent_2 int4,
	feature_class_2 varchar(30),
	dwfzone_2 int4,
	cost float4 DEFAULT 1 NOT NULL,
	reverse_cost float4 DEFAULT 1 NOT NULL,
	the_geom geometry(LINESTRING, SRID_VALUE),
	CONSTRAINT dwfzone_graph_pkey PRIMARY KEY (node_id_parent_1, dwfzone_1, node_id_parent_2, dwfzone_2)
);

CREATE INDEX IF NOT EXISTS dwfzone_graph_node_id_parent_1_idx ON dwfzone_graph USING btree (node_id_parent_1);
CREATE INDEX IF NOT EXISTS dwfzone_graph_node_id_parent_2_idx ON dwfzone_graph USING btree (node_id_parent_2);
CREATE INDEX IF NOT EXISTS the_geom_graph_idx ON dwfzone_graph USING gist (the_geom);
