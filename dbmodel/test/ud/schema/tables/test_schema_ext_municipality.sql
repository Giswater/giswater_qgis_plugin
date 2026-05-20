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
SELECT has_table('ext_municipality'::name, 'Table ext_municipality should exist');

-- Check columns
SELECT columns_are(
    'ext_municipality',
    ARRAY[
        'muni_id', 'name', 'observ', 'the_geom', 'active', 'region_id',
        'province_id', 'code'
    ],
    'Table ext_municipality should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_municipality', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_municipality', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_municipality', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_municipality', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ext_municipality', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ext_municipality', 'region_id', 'int4', 'Column region_id should be int4');
SELECT col_type_is('ext_municipality', 'province_id', 'int4', 'Column province_id should be int4');
SELECT col_type_is('ext_municipality', 'code', 'varchar(100)', 'Column code should be varchar(100)');

-- Check foreign keys
SELECT has_fk('ext_municipality', 'Table ext_municipality should have foreign keys');

SELECT fk_ok('ext_municipality', 'region_id', 'ext_region', 'region_id', 'FK region_id → ext_region.region_id');
SELECT fk_ok('ext_municipality', 'province_id', 'ext_province', 'province_id', 'FK province_id → ext_province.province_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
