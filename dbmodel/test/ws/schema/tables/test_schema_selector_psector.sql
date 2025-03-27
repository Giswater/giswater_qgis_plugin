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

-- Check table selector_psector
SELECT has_table('selector_psector'::name, 'Table selector_psector should exist');

-- Check columns
SELECT columns_are(
    'selector_psector',
    ARRAY[
        'psector_id', 'cur_user'
    ],
    'Table selector_psector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_psector', ARRAY['psector_id', 'cur_user'], 'Columns psector_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_psector', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('selector_psector', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_psector', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_psector', 'psector_id', 'Column psector_id should be NOT NULL');
SELECT col_not_null('selector_psector', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_psector', 'Table selector_psector should have foreign keys');
SELECT fk_ok('selector_psector', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id should reference plan_psector.psector_id');

SELECT * FROM finish();

ROLLBACK; 