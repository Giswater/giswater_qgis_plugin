/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP TABLE IF EXISTS temp_dma_order;
DROP TABLE IF EXISTS dma_graph_object;
DROP TABLE IF EXISTS dma_graph_meter;

CREATE TABLE dma_graph_object (
	object_id INTEGER NOT NULL,
	expl_id INTEGER NOT NULL,
	object_type TEXT,
	object_label TEXT,
    label TEXT,
	order_id INTEGER,
	attrib json,
    coord_x numeric,
    coord_y numeric,
	meter_1 _int4 NULL,
	meter_2 _int4 NULL,
	the_geom public.geometry(POINT, SRID_VALUE),
	CONSTRAINT dma_graph_object_pkey PRIMARY KEY (object_id, expl_id));

CREATE TABLE dma_graph_meter(
	meter_id int4 NOT NULL,
	expl_id int4 NOT NULL,
	object_1 int4 NULL,
	object_2 int4 NULL,
	attrib json NULL,
	order_id int4 NULL,
	the_geom public.geometry(LINESTRING, SRID_VALUE),
	CONSTRAINT dma_graph_meter_pkey PRIMARY KEY (meter_id, expl_id));

CREATE TABLE temp_dma_order (
    meter_id int,
    dma_1 int, --source
    dma_2 int, --target
    agg_cost int,
    constraint pkey primary key (meter_id, dma_1, dma_2)
);

CREATE TABLE dma_graph_json (
	expl_id int PRIMARY KEY,
	dma_graph_json json,
	insert_tstamp timestamp default now(),
	update_tstamp timestamp default null
);