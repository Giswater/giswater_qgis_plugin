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
SELECT has_table('ext_rtc_hydrometer_state'::name, 'Table ext_rtc_hydrometer_state should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_hydrometer_state',
    ARRAY[
        'id', 'name', 'observ', 'is_operative'
    ],
    'Table ext_rtc_hydrometer_state should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_rtc_hydrometer_state', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ext_rtc_hydrometer_state', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_rtc_hydrometer_state', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_rtc_hydrometer_state', 'is_operative', 'bool', 'Column is_operative should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
