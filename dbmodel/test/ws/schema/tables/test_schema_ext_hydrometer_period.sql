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
        'id', 'hydrometer_id', 'wmeter_number', 'cat_period_id', 'billed_volume',
        'value_date', 'value_type', 'value_status', 'value_state', 'fraud_type',
        'fraud_status', 'fraud_probability', 'submetering_value'
    ],
    'Table ext_hydrometer_period should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_hydrometer_period', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ext_hydrometer_period', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('ext_hydrometer_period', 'wmeter_number', 'text', 'Column wmeter_number should be text');
SELECT col_type_is('ext_hydrometer_period', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ext_hydrometer_period', 'billed_volume', 'float8', 'Column billed_volume should be float8');
SELECT col_type_is('ext_hydrometer_period', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_hydrometer_period', 'value_type', 'int4', 'Column value_type should be int4');
SELECT col_type_is('ext_hydrometer_period', 'value_status', 'int4', 'Column value_status should be int4');
SELECT col_type_is('ext_hydrometer_period', 'value_state', 'int4', 'Column value_state should be int4');
SELECT col_type_is('ext_hydrometer_period', 'fraud_type', 'int4', 'Column fraud_type should be int4');
SELECT col_type_is('ext_hydrometer_period', 'fraud_status', 'int4', 'Column fraud_status should be int4');
SELECT col_type_is('ext_hydrometer_period', 'fraud_probability', 'numeric(12,2)', 'Column fraud_probability should be numeric(12,2)');
SELECT col_type_is('ext_hydrometer_period', 'submetering_value', 'float8', 'Column submetering_value should be float8');

-- Check foreign keys
SELECT has_fk('ext_hydrometer_period', 'Table ext_hydrometer_period should have foreign keys');

SELECT fk_ok('ext_hydrometer_period', 'cat_period_id', 'ext_cat_period', 'id', 'FK cat_period_id → ext_cat_period.id');
SELECT fk_ok('ext_hydrometer_period', 'hydrometer_id', 'ext_hydrometer', 'hydrometer_id', 'FK hydrometer_id → ext_hydrometer.hydrometer_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
