/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 18/12/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"shutoff_required", "dataType":"boolean", "defaultValue":"true", "isUtils":"False"}}$$);

-- add columns to tables for EPA families export
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_node","column":"builtdate","dataType":"date","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc","column":"builtdate","dataType":"date","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc","column":"family","dataType":"varchar(100)","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_inp_node", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_inp_arc", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_arc", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_node", "column":"presszone_id", "dataType":"int4"}}$$);

-- 14/01/2026
DROP VIEW IF EXISTS v_om_mincut;
DROP VIEW IF EXISTS v_om_mincut_current_initpoint;
DROP VIEW IF EXISTS v_ui_mincut;
DROP VIEW IF EXISTS v_om_mincut_initpoint;
DROP VIEW IF EXISTS v_om_mincut_polygon;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"om_mincut", "column":"anl_feature_id", "dataType":"int4"}}$$);

CREATE TABLE dma_graph_object (
	object_id INTEGER NOT NULL,
	expl_id INTEGER,
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
	CONSTRAINT dma_graph_object_pkey PRIMARY KEY (object_id));

CREATE TABLE dma_graph_meter(
	meter_id int4 NOT NULL,
	expl_id int4 NULL,
	object_1 int4 NULL,
	object_2 int4 NULL,
	attrib json NULL,
	order_id int4 NULL,
	the_geom public.geometry(LINESTRING, SRID_VALUE),
	CONSTRAINT dma_graph_meter_pkey PRIMARY KEY (meter_id),
	CONSTRAINT dma_graph_meter_meter_expl_unique UNIQUE (meter_id, expl_id)
);

ALTER TABLE cat_element DROP CONSTRAINT IF EXISTS cat_element_fkey_element_type;
ALTER TABLE cat_element ADD CONSTRAINT cat_element_fkey_element_type FOREIGN KEY (element_type) REFERENCES cat_feature_element(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- 22/01/2026
ALTER TABLE minsector_graph RENAME COLUMN nodecat_id TO feature_class;
ALTER TABLE minsector_graph ADD "cost" float4 DEFAULT 1 NOT NULL;
ALTER TABLE minsector_graph ADD reverse_cost float4 DEFAULT 1 NOT NULL;
ALTER TABLE minsector_graph DROP CONSTRAINT minsector_graph_pkey;
ALTER TABLE minsector_graph ADD CONSTRAINT minsector_graph_pk PRIMARY KEY (node_id,minsector_1,minsector_2);

CREATE TABLE presszone_graph (
	node_id_parent_1 int4 NOT NULL,
	feature_class_1 varchar(30),
	presszone_1 int4,
	node_id_parent_2 int4,
	feature_class_2 varchar(30),
	presszone_2 int4,
	cost float4 DEFAULT 1 NOT NULL,
	reverse_cost float4 DEFAULT 1 NOT NULL,
	the_geom geometry(LINESTRING, SRID_VALUE),
	CONSTRAINT presszone_graph_pkey PRIMARY KEY (node_id_parent_1, presszone_1, node_id_parent_2, presszone_2)
);

CREATE INDEX IF NOT EXISTS presszone_graph_node_id_parent_1_idx ON presszone_graph USING btree (node_id_parent_1);
CREATE INDEX IF NOT EXISTS presszone_graph_node_id_parent_2_idx ON presszone_graph USING btree (node_id_parent_2);
CREATE INDEX IF NOT EXISTS the_geom_graph_idx ON presszone_graph USING gist (the_geom);
