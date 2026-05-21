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
SELECT has_table('value_state'::name, 'Table value_state should exist');

-- Check columns
SELECT columns_are(
    'value_state',
    ARRAY[
        'id', 'name', 'observ', 'active'
    ],
    'Table value_state should have the correct columns'
);

-- Check column types
SELECT col_type_is('value_state', 'id', 'int2', 'Column id should be int2');
SELECT col_type_is('value_state', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('value_state', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('value_state', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
