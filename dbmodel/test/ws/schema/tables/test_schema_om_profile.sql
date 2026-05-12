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

-- Check table om_profile
SELECT has_table('om_profile'::name, 'Table om_profile should exist');

-- Check columns
SELECT columns_are(
    'om_profile',
    ARRAY[
        'profile_id', 'values'
    ],
    'Table om_profile should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_profile', ARRAY['profile_id'], 'Column profile_id should be primary key');

-- Check column types
SELECT col_type_is('om_profile', 'profile_id', 'text', 'Column profile_id should be text');
SELECT col_type_is('om_profile', 'values', 'json', 'Column values should be json');

-- Check constraints
SELECT col_not_null('om_profile', 'profile_id', 'Column profile_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 