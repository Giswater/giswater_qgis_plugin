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
SELECT has_table('selector_psector'::name, 'Table selector_psector should exist');

-- Check columns
SELECT columns_are(
    'selector_psector',
    ARRAY[
        'psector_id', 'cur_user'
    ],
    'Table selector_psector should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_psector', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('selector_psector', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_psector', 'Table selector_psector should have foreign keys');

SELECT fk_ok('selector_psector', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id → plan_psector.psector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
