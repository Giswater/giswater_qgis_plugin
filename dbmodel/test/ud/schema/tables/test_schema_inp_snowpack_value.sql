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
SELECT has_table('inp_snowpack_value'::name, 'Table inp_snowpack_value should exist');

-- Check columns
SELECT columns_are(
    'inp_snowpack_value',
    ARRAY[
        'id', 'snow_id', 'snow_type', 'value_1', 'value_2', 'value_3',
        'value_4', 'value_5', 'value_6', 'value_7'
    ],
    'Table inp_snowpack_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_snowpack_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_snowpack_value', 'snow_id', 'varchar(16)', 'Column snow_id should be varchar(16)');
SELECT col_type_is('inp_snowpack_value', 'snow_type', 'varchar(16)', 'Column snow_type should be varchar(16)');
SELECT col_type_is('inp_snowpack_value', 'value_1', 'numeric(12,3)', 'Column value_1 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_2', 'numeric(12,3)', 'Column value_2 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_3', 'numeric(12,3)', 'Column value_3 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_4', 'numeric(12,3)', 'Column value_4 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_5', 'numeric(12,3)', 'Column value_5 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_6', 'numeric(12,3)', 'Column value_6 should be numeric(12,3)');
SELECT col_type_is('inp_snowpack_value', 'value_7', 'numeric(12,3)', 'Column value_7 should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('inp_snowpack_value', 'Table inp_snowpack_value should have foreign keys');

SELECT fk_ok('inp_snowpack_value', 'snow_id', 'inp_snowpack', 'snow_id', 'FK snow_id → inp_snowpack.snow_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
