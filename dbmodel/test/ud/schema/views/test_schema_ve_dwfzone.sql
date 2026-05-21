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

-- Check view ve_dwfzone
SELECT has_view('ve_dwfzone'::name, 'View ve_dwfzone should exist');

-- Check view columns
SELECT columns_are(
    've_dwfzone',
    ARRAY[
        'dwfzone_id', 'code', 'name', 'descript', 'active', 'dwfzone_type',
        'drainzone_id', 'expl_id', 'sector_id', 'muni_id', 'graphconfig', 'stylesheet',
        'lock_level', 'link', 'the_geom', 'addparam', 'created_at', 'created_by',
        'updated_at', 'updated_by'
    ],
    'View ve_dwfzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_dwfzone', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('ve_dwfzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_dwfzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_dwfzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_dwfzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_dwfzone', 'dwfzone_type', 'varchar(16)', 'Column dwfzone_type should be varchar(16)');
SELECT col_type_is('ve_dwfzone', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('ve_dwfzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_dwfzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_dwfzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_dwfzone', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('ve_dwfzone', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_dwfzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_dwfzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_dwfzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ve_dwfzone', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_dwfzone', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('ve_dwfzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_dwfzone', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('ve_dwfzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

SELECT * FROM finish();

ROLLBACK;
