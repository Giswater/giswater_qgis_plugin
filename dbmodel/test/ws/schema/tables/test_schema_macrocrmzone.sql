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

-- Check table macrocrmzone
SELECT has_table('macrocrmzone'::name, 'Table macrocrmzone should exist');

-- Check columns
SELECT columns_are(
    'macrocrmzone',
    ARRAY[
        'macrocrmzone_id', 'code', 'name', 'descript', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'Table macrocrmzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrocrmzone', ARRAY['macrocrmzone_id'], 'Column macrocrmzone_id should be primary key');

-- Check column types
SELECT col_type_is('macrocrmzone', 'macrocrmzone_id', 'integer', 'Column macrocrmzone_id should be integer');
SELECT col_type_is('macrocrmzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('macrocrmzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('macrocrmzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('macrocrmzone', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('macrocrmzone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrocrmzone', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('macrocrmzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrocrmzone', 'created_by', 'character varying(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrocrmzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrocrmzone', 'updated_by', 'character varying(50)', 'Column updated_by should be varchar(50)');

-- Check foreign keys
SELECT hasnt_fk('macrocrmzone', 'Table macrocrmzone should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('macrocrmzone', 'macrocrmzone_id', 'Column macrocrmzone_id should be NOT NULL');
SELECT col_not_null('macrocrmzone', 'name', 'Column name should be NOT NULL');
SELECT col_default_is('macrocrmzone', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('macrocrmzone', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('macrocrmzone', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK;
