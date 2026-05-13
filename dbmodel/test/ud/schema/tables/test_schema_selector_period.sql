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
SELECT has_table('selector_period'::name, 'Table selector_period should exist');

-- Check columns
SELECT columns_are(
    'selector_period',
    ARRAY[
        'period_id', 'cur_user'
    ],
    'Table selector_period should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_period', 'period_id', 'text', 'Column period_id should be text');
SELECT col_type_is('selector_period', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_period', 'Table selector_period should have foreign keys');

SELECT fk_ok('selector_period', 'period_id', 'ext_cat_period', 'id', 'FK period_id → ext_cat_period.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
