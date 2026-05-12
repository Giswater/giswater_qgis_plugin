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

-- Check table value_state
SELECT has_table('value_state'::name, 'Table value_state should exist');

-- Check columns
SELECT columns_are(
    'value_state',
    ARRAY[
        'id', 'name', 'observ', 'active'
    ],
    'Table value_state should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('value_state', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('value_state', 'id', 'smallint', 'Column id should be smallint');
SELECT col_type_is('value_state', 'name', 'character varying(30)', 'Column name should be character varying(30)');
SELECT col_type_is('value_state', 'observ', 'text', 'Column observ should be text');

-- Check constraints
SELECT col_not_null('value_state', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('value_state', 'name', 'Column name should be NOT NULL');
SELECT col_has_check('value_state', 'id', 'Column id should have a check constraint');

SELECT * FROM finish();

ROLLBACK;