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
SELECT has_table('man_manhole'::name, 'Table man_manhole should exist');

-- Check columns
SELECT columns_are(
    'man_manhole',
    ARRAY[
        'node_id', 'length', 'width', 'sander_depth', 'prot_surface', 'inlet',
        'bottom_channel', 'accessibility', 'bottom_mat', 'height', 'manhole_code'
    ],
    'Table man_manhole should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_manhole', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_manhole', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_manhole', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_manhole', 'sander_depth', 'numeric(12,3)', 'Column sander_depth should be numeric(12,3)');
SELECT col_type_is('man_manhole', 'prot_surface', 'bool', 'Column prot_surface should be bool');
SELECT col_type_is('man_manhole', 'inlet', 'bool', 'Column inlet should be bool');
SELECT col_type_is('man_manhole', 'bottom_channel', 'bool', 'Column bottom_channel should be bool');
SELECT col_type_is('man_manhole', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_manhole', 'bottom_mat', 'text', 'Column bottom_mat should be text');
SELECT col_type_is('man_manhole', 'height', 'numeric(12,4)', 'Column height should be numeric(12,4)');
SELECT col_type_is('man_manhole', 'manhole_code', 'text', 'Column manhole_code should be text');

-- Check foreign keys
SELECT has_fk('man_manhole', 'Table man_manhole should have foreign keys');

SELECT fk_ok('man_manhole', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
