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
SELECT has_table('ext_hydrometer_period'::name, 'Table ext_hydrometer_period should exist');

-- Check columns
SELECT columns_are(
    'ext_hydrometer_period',
    ARRAY[
        'id', 'hydrometer_id', 'min', 'max', 'avg', 'sum',
        'custom_sum', 'cat_period_id', 'value_date', 'pattern_id', 'value_type', 'value_status',
        'value_state', 'wmeter_number'
    ],
    'Table ext_hydrometer_period should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_hydrometer_period', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ext_hydrometer_period', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('ext_hydrometer_period', 'min', 'float8', 'Column min should be float8');
SELECT col_type_is('ext_hydrometer_period', 'max', 'float8', 'Column max should be float8');
SELECT col_type_is('ext_hydrometer_period', 'avg', 'float8', 'Column avg should be float8');
SELECT col_type_is('ext_hydrometer_period', 'sum', 'float8', 'Column sum should be float8');
SELECT col_type_is('ext_hydrometer_period', 'custom_sum', 'float8', 'Column custom_sum should be float8');
SELECT col_type_is('ext_hydrometer_period', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ext_hydrometer_period', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_hydrometer_period', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ext_hydrometer_period', 'value_type', 'int4', 'Column value_type should be int4');
SELECT col_type_is('ext_hydrometer_period', 'value_status', 'int4', 'Column value_status should be int4');
SELECT col_type_is('ext_hydrometer_period', 'value_state', 'int4', 'Column value_state should be int4');
SELECT col_type_is('ext_hydrometer_period', 'wmeter_number', 'text', 'Column wmeter_number should be text');

-- Check foreign keys
SELECT has_fk('ext_hydrometer_period', 'Table ext_hydrometer_period should have foreign keys');

SELECT fk_ok('ext_hydrometer_period', 'hydrometer_id', 'ext_hydrometer', 'hydrometer_id', 'FK hydrometer_id → ext_hydrometer.hydrometer_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
