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
SELECT has_table('selector_date'::name, 'Table selector_date should exist');

-- Check columns
SELECT columns_are(
    'selector_date',
    ARRAY[
        'from_date', 'to_date', 'context', 'cur_user'
    ],
    'Table selector_date should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_date', 'from_date', 'date', 'Column from_date should be date');
SELECT col_type_is('selector_date', 'to_date', 'date', 'Column to_date should be date');
SELECT col_type_is('selector_date', 'context', 'varchar(30)', 'Column context should be varchar(30)');
SELECT col_type_is('selector_date', 'cur_user', 'text', 'Column cur_user should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
