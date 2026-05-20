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
SELECT has_table('macroomunit'::name, 'Table macroomunit should exist');

-- Check columns
SELECT columns_are(
    'macroomunit',
    ARRAY[
        'macroomunit_id', 'node_1', 'node_2', 'is_way_in', 'is_way_out', 'the_geom',
        'expl_id', 'muni_id', 'sector_id', 'catchment_node', 'order_number'
    ],
    'Table macroomunit should have the correct columns'
);

-- Check column types
SELECT col_type_is('macroomunit', 'macroomunit_id', 'int4', 'Column macroomunit_id should be int4');
SELECT col_type_is('macroomunit', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('macroomunit', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('macroomunit', 'is_way_in', 'bool', 'Column is_way_in should be bool');
SELECT col_type_is('macroomunit', 'is_way_out', 'bool', 'Column is_way_out should be bool');
SELECT col_type_is('macroomunit', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('macroomunit', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('macroomunit', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('macroomunit', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('macroomunit', 'catchment_node', 'int4', 'Column catchment_node should be int4');
SELECT col_type_is('macroomunit', 'order_number', 'int4', 'Column order_number should be int4');

-- Check foreign keys
SELECT has_fk('macroomunit', 'Table macroomunit should have foreign keys');

SELECT fk_ok('macroomunit', 'node_1', 'node', 'node_id', 'FK node_1 → node.node_id');
SELECT fk_ok('macroomunit', 'node_2', 'node', 'node_id', 'FK node_2 → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
