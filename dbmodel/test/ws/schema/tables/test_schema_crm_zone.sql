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

-- Check table crm_zone
SELECT has_table('crm_zone'::name, 'Table crm_zone should exist');

-- Check columns
SELECT columns_are(
    'crm_zone',
    ARRAY[
        'id', 'name', 'descript', 'the_geom', 'active'
    ],
    'Table crm_zone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('crm_zone', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('crm_zone', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('crm_zone', 'name', 'text', 'Column name should be text');
SELECT col_type_is('crm_zone', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('crm_zone', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('crm_zone', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('crm_zone', 'Table crm_zone should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('crm_zone', 'id', 'Column id should be NOT NULL');
SELECT col_default_is('crm_zone', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
