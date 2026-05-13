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
SELECT has_table('man_storage'::name, 'Table man_storage should exist');

-- Check columns
SELECT columns_are(
    'man_storage',
    ARRAY[
        'node_id', 'length', 'width', 'custom_area', 'max_volume', 'util_volume',
        'min_height', 'accessibility', 'name'
    ],
    'Table man_storage should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_storage', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_storage', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_storage', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_storage', 'custom_area', 'numeric(12,3)', 'Column custom_area should be numeric(12,3)');
SELECT col_type_is('man_storage', 'max_volume', 'numeric(12,3)', 'Column max_volume should be numeric(12,3)');
SELECT col_type_is('man_storage', 'util_volume', 'numeric(12,3)', 'Column util_volume should be numeric(12,3)');
SELECT col_type_is('man_storage', 'min_height', 'numeric(12,3)', 'Column min_height should be numeric(12,3)');
SELECT col_type_is('man_storage', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_storage', 'name', 'varchar(255)', 'Column name should be varchar(255)');

-- Check foreign keys
SELECT has_fk('man_storage', 'Table man_storage should have foreign keys');

SELECT fk_ok('man_storage', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
