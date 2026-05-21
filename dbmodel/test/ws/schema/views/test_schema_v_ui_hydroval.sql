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

-- Check view v_ui_hydroval
SELECT has_view('v_ui_hydroval'::name, 'View v_ui_hydroval should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_hydroval',
    ARRAY[
        'id', 'feature_id', 'arc_id', 'hydrometer_id', 'hydrometer_customer_code', 'catalog_id',
        'madeby', 'class', 'cat_period_id', 'sum', 'custom_sum', 'value_type',
        'value_status', 'value_state'
    ],
    'View v_ui_hydroval should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_hydroval', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('v_ui_hydroval', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_ui_hydroval', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_ui_hydroval', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('v_ui_hydroval', 'hydrometer_customer_code', 'text', 'Column hydrometer_customer_code should be text');
SELECT col_type_is('v_ui_hydroval', 'catalog_id', 'int4', 'Column catalog_id should be int4');
SELECT col_type_is('v_ui_hydroval', 'madeby', 'varchar(100)', 'Column madeby should be varchar(100)');
SELECT col_type_is('v_ui_hydroval', 'class', 'varchar(100)', 'Column class should be varchar(100)');
SELECT col_type_is('v_ui_hydroval', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('v_ui_hydroval', 'sum', 'float8', 'Column sum should be float8');
SELECT col_type_is('v_ui_hydroval', 'custom_sum', 'float8', 'Column custom_sum should be float8');
SELECT col_type_is('v_ui_hydroval', 'value_type', 'varchar(100)', 'Column value_type should be varchar(100)');
SELECT col_type_is('v_ui_hydroval', 'value_status', 'varchar(100)', 'Column value_status should be varchar(100)');
SELECT col_type_is('v_ui_hydroval', 'value_state', 'varchar(100)', 'Column value_state should be varchar(100)');

SELECT * FROM finish();

ROLLBACK;
