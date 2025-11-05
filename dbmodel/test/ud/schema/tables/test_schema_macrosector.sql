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

-- Check table macrosector
SELECT has_table('macrosector'::name, 'Table macrosector should exist');

-- Check columns
SELECT columns_are(
    'macrosector',
    ARRAY[
        'macrosector_id', 'code', 'name', 'descript', 'lock_level',
        'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'addparam', 'link', 'muni_id', 'stylesheet', 'expl_id'
    ],
    'Table macrosector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrosector', ARRAY['macrosector_id'], 'Column macrosector_id should be primary key');

-- Check column types
SELECT col_type_is('macrosector', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('macrosector', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('macrosector', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('macrosector', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('macrosector', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('macrosector', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrosector', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('macrosector', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrosector', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrosector', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrosector', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check indexes
SELECT has_index('macrosector', 'macrosector_index', 'Table should have macrosector_index');

-- Check constraints
SELECT col_default_is('macrosector', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('macrosector', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('macrosector', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK;
