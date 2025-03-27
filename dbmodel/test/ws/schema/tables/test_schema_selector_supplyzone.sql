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

-- Check table selector_supplyzone
SELECT has_table('selector_supplyzone'::name, 'Table selector_supplyzone should exist');

-- Check columns
SELECT columns_are(
    'selector_supplyzone',
    ARRAY[
        'supplyzone_id', 'cur_user'
    ],
    'Table selector_supplyzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_supplyzone', ARRAY['supplyzone_id', 'cur_user'], 'Columns supplyzone_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_supplyzone', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('selector_supplyzone', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_supplyzone', 'cur_user', '"current_user"()', 'Column cur_user should default to "current_user"()');

-- Check constraints
SELECT col_not_null('selector_supplyzone', 'supplyzone_id', 'Column supplyzone_id should be NOT NULL');
SELECT col_not_null('selector_supplyzone', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_supplyzone', 'Table selector_supplyzone should have foreign keys');
SELECT fk_ok('selector_supplyzone', 'supplyzone_id', 'supplyzone', 'supplyzone_id', 'FK supplyzone_id should reference supplyzone.supplyzone_id');

SELECT * FROM finish();

ROLLBACK; 