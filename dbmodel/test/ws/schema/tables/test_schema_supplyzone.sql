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
SELECT has_table('supplyzone'::name, 'Table supplyzone should exist');

-- Check columns
SELECT columns_are(
    'supplyzone',
    ARRAY[
        'supplyzone_id', 'code', 'name', 'descript', 'supplyzone_type', 'muni_id',
        'expl_id', 'graphconfig', 'stylesheet', 'parent_id', 'pattern_id', 'avg_press',
        'link', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by',
        'updated_at', 'updated_by', 'addparam', 'sector_id'
    ],
    'Table supplyzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('supplyzone', 'supplyzone_id', 'int4', 'Column supplyzone_id should be int4');
SELECT col_type_is('supplyzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('supplyzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('supplyzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('supplyzone', 'supplyzone_type', 'varchar(16)', 'Column supplyzone_type should be varchar(16)');
SELECT col_type_is('supplyzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('supplyzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('supplyzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('supplyzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('supplyzone', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('supplyzone', 'pattern_id', 'varchar(20)', 'Column pattern_id should be varchar(20)');
SELECT col_type_is('supplyzone', 'avg_press', 'float8', 'Column avg_press should be float8');
SELECT col_type_is('supplyzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('supplyzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('supplyzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('supplyzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('supplyzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('supplyzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('supplyzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('supplyzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('supplyzone', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('supplyzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');

-- Check foreign keys
SELECT has_fk('supplyzone', 'Table supplyzone should have foreign keys');

SELECT fk_ok('supplyzone', 'parent_id', 'supplyzone', 'supplyzone_id', 'FK parent_id → supplyzone.supplyzone_id');
SELECT fk_ok('supplyzone', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
