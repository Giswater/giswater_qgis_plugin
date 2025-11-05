/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
ALTER TABLE link ALTER COLUMN omunit_id SET DEFAULT 0;


CREATE TABLE IF NOT EXISTS macroomunit (
    macroomunit_id serial4 NOT NULL,
    node_1 int4 NOT NULL,
    node_2 int4 NOT NULL,
    is_way_in bool NOT NULL,
    is_way_out bool NOT NULL,
    the_geom geometry(linestring, SRID_VALUE) NOT NULL,
    expl_id _int4 NOT NULL,
    muni_id _int4 NOT NULL,
    sector_id _int4 NOT NULL,
    --mapzones_id int4 NOT NULL,
    CONSTRAINT macroomunit_pkey PRIMARY KEY (macroomunit_id),
    CONSTRAINT macroomunit_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT macroomunit_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS omunit (
    omunit_id serial4 NOT NULL,
    node_1 int4 NOT NULL,
    node_2 int4 NOT NULL,
    is_way_in bool NOT NULL,
    is_way_out bool NOT NULL,
    macroomunit_id int4 NOT NULL,
    order_id int4 NOT NULL,
    the_geom geometry(linestring, SRID_VALUE) NOT NULL,
    expl_id _int4 NOT NULL,
    muni_id _int4 NOT NULL,
    sector_id _int4 NOT NULL,
    --mapzones_id int4 NOT NULL,
    CONSTRAINT omunit_pkey PRIMARY KEY (omunit_id),
    CONSTRAINT omunit_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT omunit_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT omunit_macroomunit_id_fkey FOREIGN KEY (macroomunit_id) REFERENCES macroomunit(macroomunit_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP VIEW IF EXISTS v_ui_dwfzone;
DROP VIEW IF EXISTS ve_dwfzone;
DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS ve_drainzone;

ALTER TABLE dwfzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE dwfzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE dwfzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE drainzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE drainzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE drainzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE node ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE arc ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE connec ALTER COLUMN treatment_type SET DEFAULT 0;
ALTER TABLE gully ALTER COLUMN treatment_type SET DEFAULT 0;
