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
SELECT has_table('omunit'::name, 'Table omunit should exist');

-- Check columns
SELECT columns_are(
    'omunit',
    ARRAY[
        'omunit_id', 'node_1', 'node_2', 'macroomunit_id',
        'order_number', 'the_geom', 'expl_id', 'muni_id', 'sector_id'
    ],
    'Table omunit should have the correct columns'
);

-- Check column types
SELECT col_type_is('omunit', 'omunit_id', 'int4', 'Column omunit_id should be int4');
SELECT col_type_is('omunit', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('omunit', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('omunit', 'macroomunit_id', 'int4', 'Column macroomunit_id should be int4');
SELECT col_type_is('omunit', 'order_number', 'int4', 'Column order_number should be int4');
SELECT col_type_is('omunit', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('omunit', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('omunit', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('omunit', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');

-- Check foreign keys
SELECT has_fk('omunit', 'Table omunit should have foreign keys');

SELECT fk_ok('omunit', 'node_1', 'node', 'node_id', 'FK node_1 → node.node_id');
SELECT fk_ok('omunit', 'node_2', 'node', 'node_id', 'FK node_2 → node.node_id');
SELECT fk_ok('omunit', 'macroomunit_id', 'macroomunit', 'macroomunit_id', 'FK macroomunit_id → macroomunit.macroomunit_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
