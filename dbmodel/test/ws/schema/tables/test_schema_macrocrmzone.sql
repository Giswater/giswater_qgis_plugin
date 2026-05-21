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
SELECT has_table('macrocrmzone'::name, 'Table macrocrmzone should exist');

-- Check columns
SELECT columns_are(
    'macrocrmzone',
    ARRAY[
        'macrocrmzone_id', 'code', 'name', 'descript', 'lock_level', 'active',
        'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'Table macrocrmzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('macrocrmzone', 'macrocrmzone_id', 'int4', 'Column macrocrmzone_id should be int4');
SELECT col_type_is('macrocrmzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('macrocrmzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('macrocrmzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('macrocrmzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('macrocrmzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('macrocrmzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('macrocrmzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrocrmzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrocrmzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrocrmzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
