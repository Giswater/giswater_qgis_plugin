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

-- Check table ext_district
SELECT has_table('ext_district'::name, 'Table ext_district should exist');

-- Check columns
SELECT columns_are(
    'ext_district',
    ARRAY[
        'district_id', 'name', 'muni_id', 'observ', 'active', 'the_geom', 'ext_code'
    ],
    'Table ext_district should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_district', ARRAY['district_id'], 'Column district_id should be primary key');

-- Check column types
SELECT col_type_is('ext_district', 'district_id', 'integer', 'Column district_id should be integer');
SELECT col_type_is('ext_district', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_district', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_district', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_district', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('ext_district', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('ext_district', 'ext_code', 'text', 'Column ext_code should be text');

-- Check foreign keys
SELECT has_fk('ext_district', 'Table ext_district should have foreign keys');
SELECT fk_ok('ext_district', 'muni_id', 'ext_municipality', 'muni_id', 'FK ext_district_muni_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_district', 'district_id', 'Column district_id should be NOT NULL');
SELECT col_not_null('ext_district', 'muni_id', 'Column muni_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
