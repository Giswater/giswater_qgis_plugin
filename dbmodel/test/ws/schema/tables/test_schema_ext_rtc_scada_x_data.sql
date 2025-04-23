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

-- Check table ext_rtc_scada_x_data
SELECT has_table('ext_rtc_scada_x_data'::name, 'Table ext_rtc_scada_x_data should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_scada_x_data',
    ARRAY[
        'scada_id', 'node_id', 'value_date', 'value', 'value_status', 'annotation'
    ],
    'Table ext_rtc_scada_x_data should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_scada_x_data', ARRAY['scada_id', 'value_date'], 'Columns scada_id, value_date should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_scada_x_data', 'scada_id', 'text', 'Column scada_id should be text');
SELECT col_type_is('ext_rtc_scada_x_data', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_rtc_scada_x_data', 'value', 'double precision', 'Column value should be double precision');
SELECT col_type_is('ext_rtc_scada_x_data', 'value_status', 'integer', 'Column value_status should be integer');
SELECT col_type_is('ext_rtc_scada_x_data', 'annotation', 'text', 'Column annotation should be text');

-- Check foreign keys
SELECT has_fk('ext_rtc_scada_x_data', 'Table ext_rtc_scada_x_data should have foreign keys');
SELECT fk_ok('ext_rtc_scada_x_data', 'node_id', 'node', 'node_id', 'FK ext_rtc_scada_x_data_node_id_fkey should exist');

-- Check constraints
SELECT col_not_null('ext_rtc_scada_x_data', 'scada_id', 'Column scada_id should be NOT NULL');
SELECT col_not_null('ext_rtc_scada_x_data', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('ext_rtc_scada_x_data', 'value_date', 'Column value_date should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
