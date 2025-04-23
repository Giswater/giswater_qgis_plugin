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

-- Check table selector_date
SELECT has_table('selector_date'::name, 'Table selector_date should exist');

-- Check columns
SELECT columns_are(
    'selector_date',
    ARRAY[
        'from_date', 'to_date', 'context', 'cur_user'
    ],
    'Table selector_date should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_date', ARRAY['context', 'cur_user'], 'Columns context, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_date', 'from_date', 'date', 'Column from_date should be date');
SELECT col_type_is('selector_date', 'to_date', 'date', 'Column to_date should be date');
SELECT col_type_is('selector_date', 'context', 'character varying(30)', 'Column context should be character varying(30)');
SELECT col_type_is('selector_date', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_date', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_date', 'context', 'Column context should be NOT NULL');
SELECT col_not_null('selector_date', 'cur_user', 'Column cur_user should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 