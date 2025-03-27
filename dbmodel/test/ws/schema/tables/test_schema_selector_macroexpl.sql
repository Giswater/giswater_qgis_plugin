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

-- Check table selector_macroexpl
SELECT has_table('selector_macroexpl'::name, 'Table selector_macroexpl should exist');

-- Check columns
SELECT columns_are(
    'selector_macroexpl',
    ARRAY[
        'macroexpl_id', 'cur_user'
    ],
    'Table selector_macroexpl should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_macroexpl', ARRAY['macroexpl_id', 'cur_user'], 'Columns macroexpl_id, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_macroexpl', 'macroexpl_id', 'integer', 'Column macroexpl_id should be integer');
SELECT col_type_is('selector_macroexpl', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_macroexpl', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_macroexpl', 'macroexpl_id', 'Column macroexpl_id should be NOT NULL');
SELECT col_not_null('selector_macroexpl', 'cur_user', 'Column cur_user should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;