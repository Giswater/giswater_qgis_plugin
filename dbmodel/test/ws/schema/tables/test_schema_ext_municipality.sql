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

-- Check table ext_municipality
SELECT has_table('ext_municipality'::name, 'Table ext_municipality should exist');

-- Check columns
SELECT columns_are(
    'ext_municipality',
    ARRAY[
        'muni_id', 'name', 'observ', 'the_geom', 'active', 'region_id', 'province_id', 'ext_code'
    ],
    'Table ext_municipality should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_municipality', ARRAY['muni_id'], 'Column muni_id should be primary key');

-- Check column types
SELECT col_type_is('ext_municipality', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_municipality', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_municipality', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_municipality', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('ext_municipality', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('ext_municipality', 'region_id', 'integer', 'Column region_id should be integer');
SELECT col_type_is('ext_municipality', 'province_id', 'integer', 'Column province_id should be integer');
SELECT col_type_is('ext_municipality', 'ext_code', 'varchar(50)', 'Column ext_code should be varchar(50)');

-- Check foreign keys
SELECT has_fk('ext_municipality', 'Table ext_municipality should have foreign keys');
SELECT fk_ok('ext_municipality', 'province_id', 'ext_province', 'province_id', 'FK ext_municipality_province_id_fkey should exist');
SELECT fk_ok('ext_municipality', 'region_id', 'ext_region', 'region_id', 'FK ext_municipality_region_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_municipality', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('ext_municipality', 'name', 'Column name should be NOT NULL');

-- Check indexes
SELECT has_index('ext_municipality', 'idx_ext_municipality_name', 'Should have index on name');
SELECT has_index('ext_municipality', 'idx_ext_municipality_the_geom', 'Should have index on the_geom');

SELECT * FROM finish();

ROLLBACK;
