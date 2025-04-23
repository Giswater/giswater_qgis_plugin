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

-- Check table selector_macrosector
SELECT has_table('selector_macrosector'::name, 'Table selector_macrosector should exist');

-- Check columns
SELECT columns_are(
    'selector_macrosector',
    ARRAY[
        'macrosector_id', 'cur_user'
    ],
    'Table selector_macrosector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_macrosector', ARRAY['macrosector_id', 'cur_user'], 'Columns macrosector_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_macrosector', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('selector_macrosector', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_macrosector', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_macrosector', 'macrosector_id', 'Column macrosector_id should be NOT NULL');
SELECT col_not_null('selector_macrosector', 'cur_user', 'Column cur_user should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;