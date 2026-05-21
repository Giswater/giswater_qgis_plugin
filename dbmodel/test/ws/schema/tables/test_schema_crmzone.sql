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
SELECT has_table('crmzone'::name, 'Table crmzone should exist');

-- Check columns
SELECT columns_are(
    'crmzone',
    ARRAY[
        'crmzone_id', 'name', 'descript', 'the_geom', 'active', 'macrocrmzone_id',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'code', 'expl_id',
        'sector_id', 'muni_id'
    ],
    'Table crmzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('crmzone', 'crmzone_id', 'int4', 'Column crmzone_id should be int4');
SELECT col_type_is('crmzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('crmzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('crmzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('crmzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('crmzone', 'macrocrmzone_id', 'int4', 'Column macrocrmzone_id should be int4');
SELECT col_type_is('crmzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('crmzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('crmzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('crmzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('crmzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('crmzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('crmzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('crmzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');

-- Check foreign keys
SELECT has_fk('crmzone', 'Table crmzone should have foreign keys');

SELECT fk_ok('crmzone', 'macrocrmzone_id', 'macrocrmzone', 'macrocrmzone_id', 'FK macrocrmzone_id → macrocrmzone.macrocrmzone_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
