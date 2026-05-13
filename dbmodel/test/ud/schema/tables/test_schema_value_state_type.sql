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
SELECT has_table('value_state_type'::name, 'Table value_state_type should exist');

-- Check columns
SELECT columns_are(
    'value_state_type',
    ARRAY[
        'id', 'state', 'name', 'is_operative', 'is_doable'
    ],
    'Table value_state_type should have the correct columns'
);

-- Check column types
SELECT col_type_is('value_state_type', 'id', 'int2', 'Column id should be int2');
SELECT col_type_is('value_state_type', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('value_state_type', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('value_state_type', 'is_operative', 'bool', 'Column is_operative should be bool');
SELECT col_type_is('value_state_type', 'is_doable', 'bool', 'Column is_doable should be bool');

-- Check foreign keys
SELECT has_fk('value_state_type', 'Table value_state_type should have foreign keys');

SELECT fk_ok('value_state_type', 'state', 'value_state', 'id', 'FK state → value_state.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
