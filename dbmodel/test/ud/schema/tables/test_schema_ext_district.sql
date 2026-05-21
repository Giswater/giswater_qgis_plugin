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
SELECT has_table('ext_district'::name, 'Table ext_district should exist');

-- Check columns
SELECT columns_are(
    'ext_district',
    ARRAY[
        'district_id', 'name', 'muni_id', 'observ', 'active', 'the_geom',
        'code'
    ],
    'Table ext_district should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_district', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('ext_district', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ext_district', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_district', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_district', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ext_district', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ext_district', 'code', 'varchar(100)', 'Column code should be varchar(100)');

-- Check foreign keys
SELECT has_fk('ext_district', 'Table ext_district should have foreign keys');

SELECT fk_ok('ext_district', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
