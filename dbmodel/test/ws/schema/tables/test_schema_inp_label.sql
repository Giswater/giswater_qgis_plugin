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

-- Check table inp_label
SELECT has_table('inp_label'::name, 'Table inp_label should exist');

-- Check columns
SELECT columns_are(
    'inp_label',
    ARRAY[
        'id', 'xcoord', 'ycoord', 'label', 'node_id'
    ],
    'Table inp_label should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_label', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_label', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_label', 'xcoord', 'numeric(18,6)', 'Column xcoord should be numeric(18,6)');
SELECT col_type_is('inp_label', 'ycoord', 'numeric(18,6)', 'Column ycoord should be numeric(18,6)');
SELECT col_type_is('inp_label', 'label', 'varchar(50)', 'Column label should be varchar(50)');
SELECT col_type_is('inp_label', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_label', 'Table inp_label should have foreign keys');
SELECT fk_ok('inp_label', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_label', 'id', 'Column id should be NOT NULL');
SELECT col_has_default('inp_label', 'id', 'Column id should have default value');

SELECT * FROM finish();

ROLLBACK; 