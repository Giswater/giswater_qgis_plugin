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

-- Check table man_netsamplepoint
SELECT has_table('man_netsamplepoint'::name, 'Table man_netsamplepoint should exist');

-- Check columns
SELECT columns_are(
    'man_netsamplepoint',
    ARRAY[
        'node_id', 'lab_code'
    ],
    'Table man_netsamplepoint should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_netsamplepoint', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_netsamplepoint', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_netsamplepoint', 'lab_code', 'varchar(30)', 'Column lab_code should be varchar(30)');

-- Check not null constraints
SELECT col_not_null('man_netsamplepoint', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_netsamplepoint', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK; 