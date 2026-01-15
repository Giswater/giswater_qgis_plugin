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
	CONSTRAINT dma_graph_meter_pkey PRIMARY KEY (meter_id));