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

-- Check table selector_period
SELECT has_table('selector_period'::name, 'Table selector_period should exist');

-- Check columns
SELECT columns_are(
    'selector_period',
    ARRAY[
        'period_id', 'cur_user'
    ],
    'Table selector_period should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_period', ARRAY['period_id', 'cur_user'], 'Columns period_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_period', 'period_id', 'text', 'Column period_id should be text');
SELECT col_type_is('selector_period', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_period', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_period', 'period_id', 'Column period_id should be NOT NULL');
SELECT col_not_null('selector_period', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_period', 'Table selector_period should have foreign keys');
SELECT fk_ok('selector_period', 'period_id', 'ext_cat_period', 'id', 'FK period_id should reference ext_cat_period.id');

SELECT * FROM finish();

ROLLBACK; 