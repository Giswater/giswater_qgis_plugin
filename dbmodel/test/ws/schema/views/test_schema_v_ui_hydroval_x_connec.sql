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

-- Check view v_ui_hydroval_x_connec
SELECT has_view('v_ui_hydroval_x_connec'::name, 'View v_ui_hydroval_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_hydroval_x_connec',
    ARRAY[
        'id', 'connec_id', 'arc_id', 'hydrometer_id', 'catalog_id', 'madeby',
        'class', 'cat_period_id', 'sum', 'custom_sum', 'value_type', 'value_status',
        'value_state'
    ],
    'View v_ui_hydroval_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_hydroval_x_connec', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('v_ui_hydroval_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_hydroval_x_connec', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_ui_hydroval_x_connec', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('v_ui_hydroval_x_connec', 'catalog_id', 'int4', 'Column catalog_id should be int4');
SELECT col_type_is('v_ui_hydroval_x_connec', 'madeby', 'varchar(100)', 'Column madeby should be varchar(100)');
SELECT col_type_is('v_ui_hydroval_x_connec', 'class', 'varchar(100)', 'Column class should be varchar(100)');
SELECT col_type_is('v_ui_hydroval_x_connec', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('v_ui_hydroval_x_connec', 'sum', 'float8', 'Column sum should be float8');
SELECT col_type_is('v_ui_hydroval_x_connec', 'custom_sum', 'float8', 'Column custom_sum should be float8');
SELECT col_type_is('v_ui_hydroval_x_connec', 'value_type', 'varchar(100)', 'Column value_type should be varchar(100)');
SELECT col_type_is('v_ui_hydroval_x_connec', 'value_status', 'varchar(100)', 'Column value_status should be varchar(100)');
SELECT col_type_is('v_ui_hydroval_x_connec', 'value_state', 'varchar(100)', 'Column value_state should be varchar(100)');

SELECT * FROM finish();

ROLLBACK;
