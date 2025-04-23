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

-- Check table ext_region
SELECT has_table('ext_region'::name, 'Table ext_region should exist');

-- Check columns
SELECT columns_are(
    'ext_region',
    ARRAY[
        'region_id', 'name', 'descript', 'the_geom', 'active', 'ext_code'
    ],
    'Table ext_region should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_region', ARRAY['region_id'], 'Column region_id should be primary key');

-- Check column types
SELECT col_type_is('ext_region', 'region_id', 'integer', 'Column region_id should be integer');
SELECT col_type_is('ext_region', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_region', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ext_region', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('ext_region', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('ext_region', 'ext_code', 'varchar(50)', 'Column ext_code should be varchar(50)');

-- Check indexes

-- Check foreign keys
SELECT hasnt_fk('ext_region', 'Table ext_region should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_region', 'region_id', 'Column region_id should be NOT NULL');
SELECT col_not_null('ext_region', 'name', 'Column name should be NOT NULL');
SELECT col_default_is('ext_region', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
