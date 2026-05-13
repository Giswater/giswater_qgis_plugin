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
SELECT has_table('selector_expl'::name, 'Table selector_expl should exist');

-- Check columns
SELECT columns_are(
    'selector_expl',
    ARRAY[
        'expl_id', 'cur_user'
    ],
    'Table selector_expl should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_expl', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('selector_expl', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_expl', 'Table selector_expl should have foreign keys');

SELECT fk_ok('selector_expl', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
