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
SELECT has_table('selector_rpt_compare'::name, 'Table selector_rpt_compare should exist');

-- Check columns
SELECT columns_are(
    'selector_rpt_compare',
    ARRAY[
        'result_id', 'cur_user'
    ],
    'Table selector_rpt_compare should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_rpt_compare', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('selector_rpt_compare', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_rpt_compare', 'Table selector_rpt_compare should have foreign keys');

SELECT fk_ok('selector_rpt_compare', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
