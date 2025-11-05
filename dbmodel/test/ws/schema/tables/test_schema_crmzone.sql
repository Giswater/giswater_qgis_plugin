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

-- Check table crmzone
SELECT has_table('crmzone'::name, 'Table crmzone should exist');

-- Check columns
SELECT columns_are(
    'crmzone',
    ARRAY[
        'id', 'code', 'name', 'descript', 'the_geom', 'active', 'macrocrmzone_id', 'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'Table crmzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('crmzone', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('crmzone', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('crmzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('crmzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('crmzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('crmzone', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('crmzone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('crmzone', 'macrocrmzone_id', 'integer', 'Column macrocrmzone_id should be integer');
SELECT col_type_is('crmzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('crmzone', 'created_by', 'character varying(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('crmzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('crmzone', 'updated_by', 'character varying(50)', 'Column updated_by should be varchar(50)');

-- Check foreign keys
SELECT has_fk('crmzone', 'Table crmzone should have foreign keys');
SELECT fk_ok('crmzone', 'macrocrmzone_id', 'macrocrmzone', 'macrocrmzone_id', 'FK crmzone_macrocrmzone_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('crmzone', 'id', 'Column id should be NOT NULL');
SELECT col_default_is('crmzone', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
