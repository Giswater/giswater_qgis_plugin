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
SELECT has_table('dwfzone'::name, 'Table dwfzone should exist');

-- Check columns
SELECT columns_are(
    'dwfzone',
    ARRAY[
        'dwfzone_id', 'code', 'name', 'dwfzone_type', 'expl_id', 'sector_id',
        'muni_id', 'descript', 'link', 'graphconfig', 'stylesheet', 'lock_level',
        'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'drainzone_id', 'addparam'
    ],
    'Table dwfzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('dwfzone', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('dwfzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('dwfzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('dwfzone', 'dwfzone_type', 'varchar(16)', 'Column dwfzone_type should be varchar(16)');
SELECT col_type_is('dwfzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('dwfzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('dwfzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('dwfzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('dwfzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('dwfzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('dwfzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('dwfzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('dwfzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('dwfzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('dwfzone', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('dwfzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('dwfzone', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('dwfzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('dwfzone', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('dwfzone', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT has_fk('dwfzone', 'Table dwfzone should have foreign keys');

SELECT fk_ok('dwfzone', 'drainzone_id', 'drainzone', 'drainzone_id', 'FK drainzone_id → drainzone.drainzone_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
