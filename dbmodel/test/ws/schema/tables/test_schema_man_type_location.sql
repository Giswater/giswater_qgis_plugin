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

-- Check table man_type_location
SELECT has_table('man_type_location'::name, 'Table man_type_location should exist');

-- Check columns
SELECT columns_are(
    'man_type_location',
    ARRAY[
        'location_type', 'feature_type', 'featurecat_id', 'observ', 'active'
    ],
    'Table man_type_location should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_type_location', ARRAY['location_type'], 'Column location_type should be primary key');

-- Check column types
SELECT col_type_is('man_type_location', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('man_type_location', 'feature_type', 'text[]', 'Column feature_type should be text[]');
SELECT col_type_is('man_type_location', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');
SELECT col_type_is('man_type_location', 'observ', 'varchar(150)', 'Column observ should be varchar(150)');
SELECT col_type_is('man_type_location', 'active', 'boolean', 'Column active should be boolean');

-- Check default values
SELECT col_default_is('man_type_location', 'active', 'true', 'Column active should default to true');

-- Check unique constraints

-- Check foreign keys

-- Check not null constraints
SELECT col_not_null('man_type_location', 'location_type', 'Column location_type should be NOT NULL');

-- Check triggers
SELECT has_trigger('man_type_location', 'gw_trg_config_control', 'Table should have trigger gw_trg_config_control');

SELECT * FROM finish();

ROLLBACK;