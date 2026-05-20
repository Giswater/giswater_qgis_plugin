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
SELECT has_table('macrosector'::name, 'Table macrosector should exist');

-- Check columns
SELECT columns_are(
    'macrosector',
    ARRAY[
        'macrosector_id', 'code', 'name', 'descript', 'lock_level', 'active',
        'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam',
        'expl_id', 'muni_id', 'stylesheet', 'link'
    ],
    'Table macrosector should have the correct columns'
);

-- Check column types
SELECT col_type_is('macrosector', 'macrosector_id', 'int4', 'Column macrosector_id should be int4');
SELECT col_type_is('macrosector', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('macrosector', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('macrosector', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('macrosector', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('macrosector', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('macrosector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('macrosector', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrosector', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrosector', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrosector', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('macrosector', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('macrosector', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('macrosector', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('macrosector', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('macrosector', 'link', 'text', 'Column link should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
