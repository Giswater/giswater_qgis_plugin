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

-- Check table omunit
SELECT has_table('omunit'::name, 'Table omunit should exist');

-- Check columns
SELECT columns_are(
    'omunit',
    ARRAY[
        'omunit_id', 'node_1', 'node_2', 'is_way_in', 'is_way_out',
        'macroomunit_id', 'order_number', 'the_geom', 'expl_id', 'muni_id', 'sector_id'
    ],
    'Table omunit should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('omunit', ARRAY['omunit_id'], 'Column omunit_id should be primary key');

-- Check column types
SELECT col_type_is('omunit', 'omunit_id', 'integer', 'Column omunit_id should be integer');
SELECT col_type_is('omunit', 'node_1', 'integer', 'Column node_1 should be integer');
SELECT col_type_is('omunit', 'node_2', 'integer', 'Column node_2 should be integer');
SELECT col_type_is('omunit', 'is_way_in', 'boolean', 'Column is_way_in should be boolean');
SELECT col_type_is('omunit', 'is_way_out', 'boolean', 'Column is_way_out should be boolean');
SELECT col_type_is('omunit', 'macroomunit_id', 'integer', 'Column macroomunit_id should be integer');
SELECT col_type_is('omunit', 'order_number', 'integer', 'Column order_number should be integer');
SELECT col_type_is('omunit', 'the_geom', 'geometry(multilinestring,SRID_VALUE)', 'Column the_geom should be geometry(multilinestring,SRID_VALUE)');
SELECT col_type_is('omunit', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('omunit', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('omunit', 'sector_id', 'integer[]', 'Column sector_id should be integer[]');

-- Check default values
SELECT col_has_default('omunit', 'omunit_id', 'Column omunit_id should have default value');
SELECT col_has_default('omunit', 'macroomunit_id', 'Column macroomunit_id should have default value');
SELECT col_default_is('omunit', 'macroomunit_id', '0', 'Column macroomunit_id should default to 0');
SELECT col_has_default('omunit', 'order_number', 'Column order_number should have default value');
SELECT col_default_is('omunit', 'order_number', '0', 'Column order_number should default to 0');

-- Check foreign keys
SELECT has_fk('omunit', 'Table omunit should have foreign keys');
SELECT fk_ok('omunit', 'macroomunit_id', 'macroomunit', 'macroomunit_id', 'FK omunit_macroomunit_id_fkey should exist');
SELECT fk_ok('omunit', 'node_1', 'node', 'node_id', 'FK omunit_node_1_fkey should exist');
SELECT fk_ok('omunit', 'node_2', 'node', 'node_id', 'FK omunit_node_2_fkey should exist');

-- Check indexes
SELECT has_index('omunit', 'omunit_pkey', ARRAY['omunit_id'], 'Primary key index omunit_pkey should exist');
SELECT has_index('omunit', 'omunit_macroomunit_id_idx', ARRAY['macroomunit_id'], 'Index omunit_macroomunit_id_idx should exist');
SELECT has_index('omunit', 'omunit_node_1_idx', ARRAY['node_1'], 'Index omunit_node_1_idx should exist');
SELECT has_index('omunit', 'omunit_node_2_idx', ARRAY['node_2'], 'Index omunit_node_2_idx should exist');

-- Check sequence
SELECT has_sequence('omunit_omunit_id_seq', 'Sequence omunit_omunit_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
