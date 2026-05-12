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

-- Check table ext_rtc_hydrometer_x_data
SELECT has_table('ext_rtc_hydrometer_x_data'::name, 'Table ext_rtc_hydrometer_x_data should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_hydrometer_x_data',
    ARRAY[
        'id', 'hydrometer_id', 'min', 'max', 'avg', 'sum', 'custom_sum', 'cat_period_id',
        'value_date', 'pattern_id', 'value_type', 'value_status', 'value_state', 'crm_number'
    ],
    'Table ext_rtc_hydrometer_x_data should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_hydrometer_x_data', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'hydrometer_id', 'integer', 'Column hydrometer_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'min', 'double precision', 'Column min should be double precision');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'max', 'double precision', 'Column max should be double precision');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'avg', 'double precision', 'Column avg should be double precision');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'sum', 'double precision', 'Column sum should be double precision');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'custom_sum', 'double precision', 'Column custom_sum should be double precision');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'value_type', 'integer', 'Column value_type should be integer');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'value_status', 'integer', 'Column value_status should be integer');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'value_state', 'integer', 'Column value_state should be integer');
SELECT col_type_is('ext_rtc_hydrometer_x_data', 'crm_number', 'text', 'Column crm_number should be text');

-- Check indexes
SELECT has_index('ext_rtc_hydrometer_x_data', 'ext_rtc_hydrometer_x_data_index_cat_period_id', 'Table should have index on cat_period_id');
SELECT has_index('ext_rtc_hydrometer_x_data', 'ext_rtc_hydrometer_x_data_index_hydrometer_id', 'Table should have index on hydrometer_id');

-- Check foreign keys
SELECT has_fk('ext_rtc_hydrometer_x_data', 'Table ext_rtc_hydrometer_x_data should have foreign keys');
SELECT fk_ok('ext_rtc_hydrometer_x_data', 'cat_period_id', 'ext_cat_period', 'id', 'FK cat_period_id_fk should exist');

-- Check sequences
SELECT has_sequence('ext_rtc_hydrometer_x_data_seq', 'Sequence ext_rtc_hydrometer_x_data_seq should exist');

-- Check constraints
SELECT col_not_null('ext_rtc_hydrometer_x_data', 'id', 'Column id should be NOT NULL');
SELECT col_has_default('ext_rtc_hydrometer_x_data', 'id', 'Column id should have default value');

SELECT * FROM finish();

ROLLBACK;
