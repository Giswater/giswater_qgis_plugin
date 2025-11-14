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

-- Check table rtc_hydrometer_x_connec
SELECT has_table('rtc_hydrometer_x_connec'::name, 'Table rtc_hydrometer_x_connec should exist');

-- Check columns
SELECT columns_are(
    'rtc_hydrometer_x_connec',
    ARRAY[
        'hydrometer_id', 'connec_id'
    ],
    'Table rtc_hydrometer_x_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rtc_hydrometer_x_connec', ARRAY['hydrometer_id'], 'Column hydrometer_id should be primary key');

-- Check column types
SELECT col_type_is('rtc_hydrometer_x_connec', 'hydrometer_id', 'character varying(16)', 'Column hydrometer_id should be character varying(16)');
SELECT col_type_is('rtc_hydrometer_x_connec', 'connec_id', 'integer', 'Column connec_id should be integer');

-- Check constraints
SELECT col_not_null('rtc_hydrometer_x_connec', 'hydrometer_id', 'Column hydrometer_id should be NOT NULL');
SELECT col_not_null('rtc_hydrometer_x_connec', 'connec_id', 'Column connec_id should be NOT NULL');
SELECT col_is_unique('rtc_hydrometer_x_connec', ARRAY['connec_id', 'hydrometer_id'], 'Columns connec_id, hydrometer_id should should be unique');

-- Check foreign keys
SELECT has_fk('rtc_hydrometer_x_connec', 'Table rtc_hydrometer_x_connec should have foreign keys');
SELECT fk_ok('rtc_hydrometer_x_connec', 'hydrometer_id', 'ext_rtc_hydrometer', 'hydrometer_id', 'FK hydrometer_id should reference ext_rtc_hydrometer.hydrometer_id');
SELECT fk_ok('rtc_hydrometer_x_connec', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');

-- Check indexes
SELECT has_index('rtc_hydrometer_x_connec', 'rtc_hydrometer_x_connec_index_connec_id', 'Index rtc_hydrometer_x_connec_index_connec_id should exist');

SELECT * FROM finish();

ROLLBACK;