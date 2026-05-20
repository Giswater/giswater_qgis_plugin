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
SELECT has_table('dma_graph_object'::name, 'Table dma_graph_object should exist');

-- Check columns
SELECT columns_are(
    'dma_graph_object',
    ARRAY[
        'object_id', 'expl_id', 'object_type', 'object_label', 'label', 'order_id',
        'attrib', 'coord_x', 'coord_y', 'meter_1', 'meter_2', 'the_geom'
    ],
    'Table dma_graph_object should have the correct columns'
);

-- Check column types
SELECT col_type_is('dma_graph_object', 'object_id', 'int4', 'Column object_id should be int4');
SELECT col_type_is('dma_graph_object', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('dma_graph_object', 'object_type', 'text', 'Column object_type should be text');
SELECT col_type_is('dma_graph_object', 'object_label', 'text', 'Column object_label should be text');
SELECT col_type_is('dma_graph_object', 'label', 'text', 'Column label should be text');
SELECT col_type_is('dma_graph_object', 'order_id', 'int4', 'Column order_id should be int4');
SELECT col_type_is('dma_graph_object', 'attrib', 'json', 'Column attrib should be json');
SELECT col_type_is('dma_graph_object', 'coord_x', 'numeric', 'Column coord_x should be numeric');
SELECT col_type_is('dma_graph_object', 'coord_y', 'numeric', 'Column coord_y should be numeric');
SELECT col_type_is('dma_graph_object', 'meter_1', 'int4[]', 'Column meter_1 should be int4[]');
SELECT col_type_is('dma_graph_object', 'meter_2', 'int4[]', 'Column meter_2 should be int4[]');
SELECT col_type_is('dma_graph_object', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
