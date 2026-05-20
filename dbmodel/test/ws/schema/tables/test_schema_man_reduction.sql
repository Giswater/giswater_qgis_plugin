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
SELECT has_table('man_reduction'::name, 'Table man_reduction should exist');

-- Check columns
SELECT columns_are(
    'man_reduction',
    ARRAY[
        'node_id', 'diam1', 'diam2'
    ],
    'Table man_reduction should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_reduction', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_reduction', 'diam1', 'numeric(12,3)', 'Column diam1 should be numeric(12,3)');
SELECT col_type_is('man_reduction', 'diam2', 'numeric(12,3)', 'Column diam2 should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('man_reduction', 'Table man_reduction should have foreign keys');

SELECT fk_ok('man_reduction', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
