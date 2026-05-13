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
SELECT has_table('rpt_subcatchwashoff_sum'::name, 'Table rpt_subcatchwashoff_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_subcatchwashoff_sum',
    ARRAY[
        'id', 'result_id', 'subc_id', 'poll_id', 'value'
    ],
    'Table rpt_subcatchwashoff_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_subcatchwashoff_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_subcatchwashoff_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_subcatchwashoff_sum', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('rpt_subcatchwashoff_sum', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('rpt_subcatchwashoff_sum', 'value', 'numeric', 'Column value should be numeric');

-- Check foreign keys
SELECT has_fk('rpt_subcatchwashoff_sum', 'Table rpt_subcatchwashoff_sum should have foreign keys');

SELECT fk_ok('rpt_subcatchwashoff_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
