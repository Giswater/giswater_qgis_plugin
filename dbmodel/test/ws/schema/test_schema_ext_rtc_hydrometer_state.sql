/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table ext_rtc_hydrometer_state
SELECT has_table('ext_rtc_hydrometer_state'::name, 'Table ext_rtc_hydrometer_state should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_hydrometer_state',
    ARRAY[
        'id', 'name', 'observ', 'is_operative'
    ],
    'Table ext_rtc_hydrometer_state should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_hydrometer_state', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_hydrometer_state', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('ext_rtc_hydrometer_state', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_rtc_hydrometer_state', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_rtc_hydrometer_state', 'is_operative', 'boolean', 'Column is_operative should be boolean');

-- Check foreign keys
SELECT hasnt_fk('ext_rtc_hydrometer_state', 'Table ext_rtc_hydrometer_state should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('ext_rtc_hydrometer_state_id_seq', 'Sequence ext_rtc_hydrometer_state_id_seq should exist');

-- Check constraints
SELECT col_not_null('ext_rtc_hydrometer_state', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('ext_rtc_hydrometer_state', 'name', 'Column name should be NOT NULL');
SELECT col_has_default('ext_rtc_hydrometer_state', 'id', 'Column id should have default value');
SELECT col_default_is('ext_rtc_hydrometer_state', 'is_operative', 'true', 'Column is_operative should default to true');

SELECT * FROM finish();

ROLLBACK;
