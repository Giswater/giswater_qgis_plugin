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

-- Check view ve_rtc_hydro_data_x_connec
SELECT has_view('ve_rtc_hydro_data_x_connec'::name, 'View ve_rtc_hydro_data_x_connec should exist');

-- Check view columns
SELECT columns_are(
    've_rtc_hydro_data_x_connec',
    ARRAY[
        'id', 'connec_id', 'hydrometer_id', 'code', 'catalog_id', 'cat_period_id',
        'cat_period_code', 'value_date', 'sum', 'custom_sum'
    ],
    'View ve_rtc_hydro_data_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'catalog_id', 'int4', 'Column catalog_id should be int4');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'cat_period_code', 'text', 'Column cat_period_code should be text');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'sum', 'float8', 'Column sum should be float8');
SELECT col_type_is('ve_rtc_hydro_data_x_connec', 'custom_sum', 'float8', 'Column custom_sum should be float8');

SELECT * FROM finish();

ROLLBACK;
