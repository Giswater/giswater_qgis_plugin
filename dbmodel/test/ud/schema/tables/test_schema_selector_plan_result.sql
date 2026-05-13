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
SELECT has_table('selector_plan_result'::name, 'Table selector_plan_result should exist');

-- Check columns
SELECT columns_are(
    'selector_plan_result',
    ARRAY[
        'result_id', 'cur_user'
    ],
    'Table selector_plan_result should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_plan_result', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('selector_plan_result', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_plan_result', 'Table selector_plan_result should have foreign keys');

SELECT fk_ok('selector_plan_result', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id → plan_result_cat.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
