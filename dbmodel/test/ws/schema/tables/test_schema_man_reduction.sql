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

-- Check table man_reduction
SELECT has_table('man_reduction'::name, 'Table man_reduction should exist');

-- Check columns
SELECT columns_are(
    'man_reduction',
    ARRAY[
        'node_id', 'diam1', 'diam2'
    ],
    'Table man_reduction should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_reduction', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_reduction', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_reduction', 'diam1', 'numeric(12,3)', 'Column diam1 should be numeric(12,3)');
SELECT col_type_is('man_reduction', 'diam2', 'numeric(12,3)', 'Column diam2 should be numeric(12,3)');

-- Check not null constraints
SELECT col_not_null('man_reduction', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_reduction', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK; 