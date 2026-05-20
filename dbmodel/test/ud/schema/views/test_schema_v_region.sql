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

-- Check view v_region
SELECT has_view('v_region'::name, 'View v_region should exist');

-- Check view columns
SELECT columns_are(
    'v_region',
    ARRAY[
        'region_id', 'name', 'descript', 'the_geom', 'active', 'code'
    ],
    'View v_region should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_region', 'region_id', 'int4', 'Column region_id should be int4');
SELECT col_type_is('v_region', 'name', 'text', 'Column name should be text');
SELECT col_type_is('v_region', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_region', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('v_region', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_region', 'code', 'varchar(100)', 'Column code should be varchar(100)');

SELECT * FROM finish();

ROLLBACK;
