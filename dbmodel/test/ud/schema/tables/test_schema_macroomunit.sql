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

-- Check table macroomunit
SELECT has_table('macroomunit'::name, 'Table macroomunit should exist');

-- Check columns
SELECT columns_are(
    'macroomunit',
    ARRAY[
        'macroomunit_id', 'node_1', 'node_2', 'is_way_in', 'is_way_out',
        'the_geom', 'expl_id', 'muni_id', 'sector_id', 'catchment_node', 'order_number'
    ],
    'Table macroomunit should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macroomunit', ARRAY['macroomunit_id'], 'Column macroomunit_id should be primary key');

-- Check column types
SELECT col_type_is('macroomunit', 'macroomunit_id', 'integer', 'Column macroomunit_id should be integer');
SELECT col_type_is('macroomunit', 'node_1', 'integer', 'Column node_1 should be integer');
SELECT col_type_is('macroomunit', 'node_2', 'integer', 'Column node_2 should be integer');
SELECT col_type_is('macroomunit', 'is_way_in', 'boolean', 'Column is_way_in should be boolean');
SELECT col_type_is('macroomunit', 'is_way_out', 'boolean', 'Column is_way_out should be boolean');
SELECT col_type_is('macroomunit', 'the_geom', 'geometry(multilinestring,SRID_VALUE)', 'Column the_geom should be geometry(multilinestring,SRID_VALUE)');
SELECT col_type_is('macroomunit', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('macroomunit', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('macroomunit', 'sector_id', 'integer[]', 'Column sector_id should be integer[]');
SELECT col_type_is('macroomunit', 'catchment_node', 'integer', 'Column catchment_node should be integer');
SELECT col_type_is('macroomunit', 'order_number', 'integer', 'Column order_number should be integer');

-- Check default values
SELECT col_has_default('macroomunit', 'macroomunit_id', 'Column macroomunit_id should have default value');
SELECT col_has_default('macroomunit', 'order_number', 'Column order_number should have default value');
SELECT col_default_is('macroomunit', 'order_number', '0', 'Column order_number should default to 0');

-- Check foreign keys
SELECT has_fk('macroomunit', 'Table macroomunit should have foreign keys');
SELECT fk_ok('macroomunit', 'node_1', 'node', 'node_id', 'FK macroomunit_node_1_fkey should exist');
SELECT fk_ok('macroomunit', 'node_2', 'node', 'node_id', 'FK macroomunit_node_2_fkey should exist');

-- Check indexes
SELECT has_index('macroomunit', 'macroomunit_pkey', ARRAY['macroomunit_id'], 'Primary key index macroomunit_pkey should exist');
SELECT has_index('macroomunit', 'macroomunit_catchment_node_idx', ARRAY['catchment_node'], 'Index macroomunit_catchment_node_idx should exist');
SELECT has_index('macroomunit', 'macroomunit_node_1_idx', ARRAY['node_1'], 'Index macroomunit_node_1_idx should exist');
SELECT has_index('macroomunit', 'macroomunit_node_2_idx', ARRAY['node_2'], 'Index macroomunit_node_2_idx should exist');

-- Check sequence
SELECT has_sequence('macroomunit_macroomunit_id_seq', 'Sequence macroomunit_macroomunit_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
