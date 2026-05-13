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
SELECT has_table('selector_state'::name, 'Table selector_state should exist');

-- Check columns
SELECT columns_are(
    'selector_state',
    ARRAY[
        'state_id', 'cur_user'
    ],
    'Table selector_state should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_state', 'state_id', 'int4', 'Column state_id should be int4');
SELECT col_type_is('selector_state', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_state', 'Table selector_state should have foreign keys');

SELECT fk_ok('selector_state', 'state_id', 'value_state', 'id', 'FK state_id → value_state.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
