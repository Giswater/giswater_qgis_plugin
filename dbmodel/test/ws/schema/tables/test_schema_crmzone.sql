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
        'id', 'name', 'descript', 'the_geom', 'active'
    ],
    'Table crmzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('crmzone', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('crmzone', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('crmzone', 'name', 'text', 'Column name should be text');
SELECT col_type_is('crmzone', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('crmzone', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('crmzone', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('crmzone', 'Table crmzone should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('crmzone', 'id', 'Column id should be NOT NULL');
SELECT col_default_is('crmzone', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
