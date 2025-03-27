/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table man_filter
SELECT has_table('man_filter'::name, 'Table man_filter should exist');

-- Check columns
SELECT columns_are(
    'man_filter',
    ARRAY[
        'node_id'
    ],
    'Table man_filter should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_filter', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_filter', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');

-- Check not null constraints
SELECT col_not_null('man_filter', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_filter', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK; 