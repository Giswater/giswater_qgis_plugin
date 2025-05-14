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

-- Check table man_register
SELECT has_table('man_register'::name, 'Table man_register should exist');

-- Check columns
SELECT columns_are(
    'man_register',
    ARRAY[
        'node_id', 'length', 'width', 'height', 'max_volume', 'util_volume'
    ],
    'Table man_register should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_register', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_register', 'node_id', 'varchar(16)', 'Column node_id should be numeric(12,3)');
SELECT col_type_is('man_register', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_register', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_register', 'height', 'numeric(12,3)', 'Column height should be numeric(12,3)');
SELECT col_type_is('man_register', 'max_volume', 'numeric(12,3)', 'Column max_volume should be numeric(12,3)');
SELECT col_type_is('man_register', 'util_volume', 'numeric(12,3)', 'Column util_volume should be numeric(12,3)');

-- Check not null constraints
SELECT col_not_null('man_register', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_register', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id with ON DELETE CASCADE ON UPDATE CASCADE');

SELECT * FROM finish();

ROLLBACK;