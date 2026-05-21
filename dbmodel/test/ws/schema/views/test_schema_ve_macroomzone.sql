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

-- Check view ve_macroomzone
SELECT has_view('ve_macroomzone'::name, 'View ve_macroomzone should exist');

-- Check view columns
SELECT columns_are(
    've_macroomzone',
    ARRAY[
        'macroomzone_id', 'code', 'name', 'descript', 'active', 'expl_id',
        'sector_id', 'muni_id', 'stylesheet', 'lock_level', 'link', 'addparam',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'the_geom'
    ],
    'View ve_macroomzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_macroomzone', 'macroomzone_id', 'int4', 'Column macroomzone_id should be int4');
SELECT col_type_is('ve_macroomzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_macroomzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_macroomzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_macroomzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_macroomzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_macroomzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_macroomzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_macroomzone', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_macroomzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_macroomzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_macroomzone', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_macroomzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('ve_macroomzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_macroomzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('ve_macroomzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('ve_macroomzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
