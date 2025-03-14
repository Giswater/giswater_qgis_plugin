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

-- Check table ext_region_x_province
SELECT has_table('ext_region_x_province'::name, 'Table ext_region_x_province should exist');

-- Check columns
SELECT columns_are(
    'ext_region_x_province',
    ARRAY[
        'region_id', 'province_id'
    ],
    'Table ext_region_x_province should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_region_x_province', ARRAY['region_id', 'province_id'], 'Columns region_id and province_id should be primary key');

-- Check column types
SELECT col_type_is('ext_region_x_province', 'region_id', 'integer', 'Column region_id should be integer');
SELECT col_type_is('ext_region_x_province', 'province_id', 'integer', 'Column province_id should be integer');

-- Check foreign keys
SELECT hasnt_fk('ext_region_x_province', 'Table ext_region_x_province should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_region_x_province', 'region_id', 'Column region_id should be NOT NULL');
SELECT col_not_null('ext_region_x_province', 'province_id', 'Column province_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
