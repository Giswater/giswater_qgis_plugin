/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table
SELECT has_table('dma_graph_meter'::name, 'Table dma_graph_meter should exist');

-- Check columns
SELECT columns_are(
    'dma_graph_meter',
    ARRAY[
        'meter_id', 'expl_id', 'object_1', 'object_2', 'attrib', 'order_id',
        'the_geom'
    ],
    'Table dma_graph_meter should have the correct columns'
);

-- Check column types
SELECT col_type_is('dma_graph_meter', 'meter_id', 'int4', 'Column meter_id should be int4');
SELECT col_type_is('dma_graph_meter', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('dma_graph_meter', 'object_1', 'int4', 'Column object_1 should be int4');
SELECT col_type_is('dma_graph_meter', 'object_2', 'int4', 'Column object_2 should be int4');
SELECT col_type_is('dma_graph_meter', 'attrib', 'json', 'Column attrib should be json');
SELECT col_type_is('dma_graph_meter', 'order_id', 'int4', 'Column order_id should be int4');
SELECT col_type_is('dma_graph_meter', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
