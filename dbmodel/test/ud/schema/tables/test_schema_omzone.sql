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
SELECT has_table('omzone'::name, 'Table omzone should exist');

-- Check columns
SELECT columns_are(
    'omzone',
    ARRAY[
        'omzone_id', 'code', 'name', 'descript', 'omzone_type', 'expl_id',
        'macroomzone_id', 'minc', 'maxc', 'effc', 'link', 'graphconfig',
        'stylesheet', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by',
        'updated_at', 'updated_by', 'sector_id', 'muni_id', 'addparam'
    ],
    'Table omzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('omzone', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('omzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('omzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('omzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('omzone', 'omzone_type', 'varchar(16)', 'Column omzone_type should be varchar(16)');
SELECT col_type_is('omzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('omzone', 'macroomzone_id', 'int4', 'Column macroomzone_id should be int4');
SELECT col_type_is('omzone', 'minc', 'float8', 'Column minc should be float8');
SELECT col_type_is('omzone', 'maxc', 'float8', 'Column maxc should be float8');
SELECT col_type_is('omzone', 'effc', 'float8', 'Column effc should be float8');
SELECT col_type_is('omzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('omzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('omzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('omzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('omzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('omzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('omzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('omzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('omzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('omzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('omzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('omzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('omzone', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT has_fk('omzone', 'Table omzone should have foreign keys');

SELECT fk_ok('omzone', 'macroomzone_id', 'macroomzone', 'macroomzone_id', 'FK macroomzone_id → macroomzone.macroomzone_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
