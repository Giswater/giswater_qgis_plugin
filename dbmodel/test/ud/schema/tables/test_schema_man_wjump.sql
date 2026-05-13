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
SELECT has_table('man_wjump'::name, 'Table man_wjump should exist');

-- Check columns
SELECT columns_are(
    'man_wjump',
    ARRAY[
        'node_id', 'length', 'width', 'sander_depth', 'prot_surface', 'accessibility',
        'name', 'wjump_code'
    ],
    'Table man_wjump should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_wjump', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_wjump', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_wjump', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_wjump', 'sander_depth', 'numeric(12,3)', 'Column sander_depth should be numeric(12,3)');
SELECT col_type_is('man_wjump', 'prot_surface', 'bool', 'Column prot_surface should be bool');
SELECT col_type_is('man_wjump', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_wjump', 'name', 'varchar(255)', 'Column name should be varchar(255)');
SELECT col_type_is('man_wjump', 'wjump_code', 'text', 'Column wjump_code should be text');

-- Check foreign keys
SELECT has_fk('man_wjump', 'Table man_wjump should have foreign keys');

SELECT fk_ok('man_wjump', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
