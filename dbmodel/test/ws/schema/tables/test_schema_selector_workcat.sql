/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table selector_workcat
SELECT has_table('selector_workcat'::name, 'Table selector_workcat should exist');

-- Check columns
SELECT columns_are(
    'selector_workcat',
    ARRAY[
        'workcat_id', 'cur_user'
    ],
    'Table selector_workcat should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_workcat', ARRAY['workcat_id', 'cur_user'], 'Columns workcat_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_workcat', 'workcat_id', 'text', 'Column workcat_id should be text');
SELECT col_type_is('selector_workcat', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_workcat', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_workcat', 'workcat_id', 'Column workcat_id should be NOT NULL');
SELECT col_not_null('selector_workcat', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_workcat', 'Table selector_workcat should have foreign keys');
SELECT fk_ok('selector_workcat', 'workcat_id', 'cat_work', 'id', 'FK workcat_id should reference cat_work.id');

SELECT * FROM finish();

ROLLBACK; 