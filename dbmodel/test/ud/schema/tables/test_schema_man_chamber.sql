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
SELECT has_table('man_chamber'::name, 'Table man_chamber should exist');

-- Check columns
SELECT columns_are(
    'man_chamber',
    ARRAY[
        'node_id', 'length', 'width', 'sander_depth', 'max_volume', 'util_volume',
        'inlet', 'bottom_channel', 'accessibility', 'name', 'bottom_mat', 'slope',
        'height'
    ],
    'Table man_chamber should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_chamber', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_chamber', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_chamber', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_chamber', 'sander_depth', 'numeric(12,3)', 'Column sander_depth should be numeric(12,3)');
SELECT col_type_is('man_chamber', 'max_volume', 'numeric(12,3)', 'Column max_volume should be numeric(12,3)');
SELECT col_type_is('man_chamber', 'util_volume', 'numeric(12,3)', 'Column util_volume should be numeric(12,3)');
SELECT col_type_is('man_chamber', 'inlet', 'bool', 'Column inlet should be bool');
SELECT col_type_is('man_chamber', 'bottom_channel', 'bool', 'Column bottom_channel should be bool');
SELECT col_type_is('man_chamber', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_chamber', 'name', 'varchar(255)', 'Column name should be varchar(255)');
SELECT col_type_is('man_chamber', 'bottom_mat', 'text', 'Column bottom_mat should be text');
SELECT col_type_is('man_chamber', 'slope', 'numeric', 'Column slope should be numeric');
SELECT col_type_is('man_chamber', 'height', 'numeric(12,4)', 'Column height should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('man_chamber', 'Table man_chamber should have foreign keys');

SELECT fk_ok('man_chamber', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
