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

-- Check table value_state_type
SELECT has_table('value_state_type'::name, 'Table value_state_type should exist');

-- Check columns
SELECT columns_are(
    'value_state_type',
    ARRAY[
        'id', 'state', 'name', 'is_operative', 'is_doable'
    ],
    'Table value_state_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('value_state_type', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('value_state_type', 'id', 'smallint', 'Column id should be smallint');
SELECT col_type_is('value_state_type', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('value_state_type', 'name', 'character varying(30)', 'Column name should be character varying(30)');
SELECT col_type_is('value_state_type', 'is_operative', 'boolean', 'Column is_operative should be boolean');
SELECT col_type_is('value_state_type', 'is_doable', 'boolean', 'Column is_doable should be boolean');

-- Check default values
SELECT col_default_is('value_state_type', 'is_operative', 'true', 'Column is_operative should default to true');
SELECT col_default_is('value_state_type', 'is_doable', 'true', 'Column is_doable should default to true');

-- Check constraints
SELECT col_not_null('value_state_type', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('value_state_type', 'name', 'Column name should be NOT NULL');

-- Check foreign keys
SELECT has_fk('value_state_type', 'Table value_state_type should have foreign keys');
SELECT fk_ok('value_state_type', 'state', 'value_state', 'id', 'FK state should reference value_state.id');

SELECT * FROM finish();

ROLLBACK; 