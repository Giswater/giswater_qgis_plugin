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

-- Check table rtc_hydrometer
SELECT has_table('rtc_hydrometer'::name, 'Table rtc_hydrometer should exist');

-- Check columns
SELECT columns_are(
    'rtc_hydrometer',
    ARRAY[
        'hydrometer_id', 'link'
    ],
    'Table rtc_hydrometer should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rtc_hydrometer', ARRAY['hydrometer_id'], 'Column hydrometer_id should be primary key');

-- Check column types
SELECT col_type_is('rtc_hydrometer', 'hydrometer_id', 'character varying(16)', 'Column hydrometer_id should be character varying(16)');
SELECT col_type_is('rtc_hydrometer', 'link', 'text', 'Column link should be text');

-- Check constraints
SELECT col_not_null('rtc_hydrometer', 'hydrometer_id', 'Column hydrometer_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('rtc_hydrometer', 'gw_trg_rtc_hydrometer', 'Table rtc_hydrometer should have gw_trg_rtc_hydrometer trigger');

SELECT * FROM finish();

ROLLBACK; 