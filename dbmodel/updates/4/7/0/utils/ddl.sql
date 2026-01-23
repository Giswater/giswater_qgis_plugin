/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/01/2026
ALTER TABLE anl_polygon ALTER COLUMN the_geom TYPE geometry(MULTIPOLYGON, SRID_VALUE) USING the_geom;

-- 13/01/2026
CREATE TABLE inp_family(
    family_id character varying(100) NOT NULL,
    descript text,
    age integer,
    PRIMARY KEY (family_id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_material", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);

ALTER TABLE cat_material ADD CONSTRAINT fk_cat_material_family FOREIGN KEY (family) REFERENCES inp_family(family_id);

-- 22/01/2026
CREATE TABLE sector_graph (
	node_1 int4 NOT NULL,
	sector_id int4 NOT NULL,
	node_2 int4,
	expl_id int4[] NULL,
	muni_id int4[] NULL,
	the_geom geometry(MULTILINESTRING, SRID_VALUE),
	CONSTRAINT sector_graph_pkey PRIMARY KEY (node_1, node_2)
);

CREATE INDEX IF NOT EXISTS sector_graph_node_1_idx ON sector_graph USING btree (node_1);
CREATE INDEX IF NOT EXISTS sector_graph_node_2_idx ON sector_graph USING btree (node_2);
CREATE INDEX IF NOT EXISTS the_geom_graph_idx ON sector_graph USING gist (the_geom);

CREATE TABLE dma_graph (
	node_1 int4 NOT NULL,
	dma_id int4 NOT NULL,
	node_2 int4 NOT NULL,
	expl_id int4[] NULL,
	muni_id int4[] NULL,
	sector_id int4[] NULL,
	the_geom geometry(MULTILINESTRING, SRID_VALUE),
	CONSTRAINT dma_graph_pkey PRIMARY KEY (node_1, node_2)
);

CREATE INDEX IF NOT EXISTS dma_graph_node_1_idx ON dma_graph USING btree (node_1);
CREATE INDEX IF NOT EXISTS dma_graph_node_2_idx ON dma_graph USING btree (node_2);
CREATE INDEX IF NOT EXISTS the_geom_graph_idx ON dma_graph USING gist (the_geom);
