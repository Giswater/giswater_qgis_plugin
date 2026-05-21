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

-- Check view ve_district
SELECT has_view('ve_district'::name, 'View ve_district should exist');

-- Check view columns
SELECT columns_are(
    've_district',
    ARRAY[
        'district_id', 'name', 'muni_id', 'observ', 'active', 'the_geom',
        'code'
    ],
    'View ve_district should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_district', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('ve_district', 'name', 'text', 'Column name should be text');
SELECT col_type_is('ve_district', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ve_district', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_district', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_district', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ve_district', 'code', 'varchar(100)', 'Column code should be varchar(100)');

SELECT * FROM finish();

ROLLBACK;
