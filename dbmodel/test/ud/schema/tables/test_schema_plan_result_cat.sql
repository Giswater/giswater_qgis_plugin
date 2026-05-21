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
SELECT has_table('plan_result_cat'::name, 'Table plan_result_cat should exist');

-- Check columns
SELECT columns_are(
    'plan_result_cat',
    ARRAY[
        'result_id', 'name', 'result_type', 'coefficient', 'tstamp', 'cur_user',
        'descript', 'pricecat_id'
    ],
    'Table plan_result_cat should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_result_cat', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('plan_result_cat', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('plan_result_cat', 'result_type', 'int4', 'Column result_type should be int4');
SELECT col_type_is('plan_result_cat', 'coefficient', 'float8', 'Column coefficient should be float8');
SELECT col_type_is('plan_result_cat', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('plan_result_cat', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('plan_result_cat', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_result_cat', 'pricecat_id', 'varchar(30)', 'Column pricecat_id should be varchar(30)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
