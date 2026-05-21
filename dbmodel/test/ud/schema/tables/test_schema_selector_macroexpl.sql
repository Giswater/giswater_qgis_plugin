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
SELECT has_table('selector_macroexpl'::name, 'Table selector_macroexpl should exist');

-- Check columns
SELECT columns_are(
    'selector_macroexpl',
    ARRAY[
        'macroexpl_id', 'cur_user'
    ],
    'Table selector_macroexpl should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_macroexpl', 'macroexpl_id', 'int4', 'Column macroexpl_id should be int4');
SELECT col_type_is('selector_macroexpl', 'cur_user', 'text', 'Column cur_user should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
