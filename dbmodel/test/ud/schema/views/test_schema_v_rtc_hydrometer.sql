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

-- Check view v_rtc_hydrometer
SELECT has_view('v_rtc_hydrometer'::name, 'View v_rtc_hydrometer should exist');

-- Check view columns
SELECT columns_are(
    'v_rtc_hydrometer',
    ARRAY[
        'hydrometer_id', 'hydrometer_customer_code', 'feature_id', 'feature_type', 'customer_code', 'state',
        'muni_name', 'expl_id', 'expl_name', 'plot_code', 'priority_id', 'catalog_id',
        'category_id', 'hydro_number', 'hydro_man_date', 'crm_number', 'customer_name', 'address1',
        'address2', 'address3', 'address2_1', 'address2_2', 'address2_3', 'm3_volume',
        'start_date', 'end_date', 'update_date', 'hydrometer_link', 'is_operative', 'shutdown_date'
    ],
    'View v_rtc_hydrometer should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rtc_hydrometer', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'hydrometer_customer_code', 'text', 'Column hydrometer_customer_code should be text');
SELECT col_type_is('v_rtc_hydrometer', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('v_rtc_hydrometer', 'customer_code', 'varchar', 'Column customer_code should be varchar');
SELECT col_type_is('v_rtc_hydrometer', 'state', 'text', 'Column state should be text');
SELECT col_type_is('v_rtc_hydrometer', 'muni_name', 'text', 'Column muni_name should be text');
SELECT col_type_is('v_rtc_hydrometer', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_rtc_hydrometer', 'plot_code', 'int4', 'Column plot_code should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'priority_id', 'int4', 'Column priority_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'catalog_id', 'int4', 'Column catalog_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'category_id', 'int4', 'Column category_id should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'hydro_number', 'text', 'Column hydro_number should be text');
SELECT col_type_is('v_rtc_hydrometer', 'hydro_man_date', 'date', 'Column hydro_man_date should be date');
SELECT col_type_is('v_rtc_hydrometer', 'crm_number', 'int4', 'Column crm_number should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'customer_name', 'text', 'Column customer_name should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address1', 'text', 'Column address1 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address2', 'text', 'Column address2 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address3', 'text', 'Column address3 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address2_1', 'text', 'Column address2_1 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address2_2', 'text', 'Column address2_2 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'address2_3', 'text', 'Column address2_3 should be text');
SELECT col_type_is('v_rtc_hydrometer', 'm3_volume', 'int4', 'Column m3_volume should be int4');
SELECT col_type_is('v_rtc_hydrometer', 'start_date', 'date', 'Column start_date should be date');
SELECT col_type_is('v_rtc_hydrometer', 'end_date', 'date', 'Column end_date should be date');
SELECT col_type_is('v_rtc_hydrometer', 'update_date', 'date', 'Column update_date should be date');
SELECT col_type_is('v_rtc_hydrometer', 'hydrometer_link', 'text', 'Column hydrometer_link should be text');
SELECT col_type_is('v_rtc_hydrometer', 'is_operative', 'bool', 'Column is_operative should be bool');
SELECT col_type_is('v_rtc_hydrometer', 'shutdown_date', 'date', 'Column shutdown_date should be date');

SELECT * FROM finish();

ROLLBACK;
