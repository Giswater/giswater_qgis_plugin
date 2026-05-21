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
SELECT has_table('ext_rtc_scada_x_data'::name, 'Table ext_rtc_scada_x_data should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_scada_x_data',
    ARRAY[
        'node_id', 'value_date', 'value', 'value_type', 'value_status', 'value_state',
        'data_type'
    ],
    'Table ext_rtc_scada_x_data should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_rtc_scada_x_data', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_rtc_scada_x_data', 'value', 'float8', 'Column value should be float8');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_type', 'int4', 'Column value_type should be int4');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_status', 'int4', 'Column value_status should be int4');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_state', 'int4', 'Column value_state should be int4');
SELECT col_type_is('ext_rtc_scada_x_data', 'data_type', 'text', 'Column data_type should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
