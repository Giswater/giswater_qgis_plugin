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

-- Check table selector_municipality
SELECT has_table('selector_municipality'::name, 'Table selector_municipality should exist');

-- Check columns
SELECT columns_are(
    'selector_municipality',
    ARRAY[
        'muni_id', 'cur_user'
    ],
    'Table selector_municipality should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_municipality', ARRAY['muni_id', 'cur_user'], 'Columns muni_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_municipality', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('selector_municipality', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_municipality', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_municipality', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('selector_municipality', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_municipality', 'Table selector_municipality should have foreign keys');
SELECT fk_ok('selector_municipality', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');

SELECT * FROM finish();

ROLLBACK; 