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

-- Check table drainzone
SELECT has_table('drainzone'::name, 'Table drainzone should exist');

-- Check columns
SELECT columns_are(
    'drainzone',
    ARRAY[
        'drainzone_id', 'code', 'name', 'drainzone_type', 'descript', 'expl_id', 'link', 'graphconfig',
        'stylesheet', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'Table drainzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('drainzone', ARRAY['drainzone_id'], 'Column drainzone_id should be primary key');

-- Check column types
SELECT col_type_is('drainzone', 'drainzone_id', 'integer', 'Column drainzone_id should be integer');
SELECT col_type_is('drainzone', 'code', 'text', 'Column code should be text');
SELECT col_type_is('drainzone', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('drainzone', 'drainzone_type', 'varchar(16)', 'Column drainzone_type should be varchar(16)');
SELECT col_type_is('drainzone', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('drainzone', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('drainzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('drainzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('drainzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('drainzone', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('drainzone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('drainzone', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('drainzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('drainzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('drainzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('drainzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check indexes
SELECT has_index('drainzone', 'drainzone_index', 'Table should have drainzone_index');

-- Check sequences
SELECT has_sequence('drainzone_drainzone_id_seq', 'Sequence drainzone_drainzone_id_seq should exist');

-- Check constraints
SELECT col_has_default('drainzone', 'graphconfig', 'Column graphconfig should have default value');
SELECT col_has_default('drainzone', 'active', 'Column active should have default value');
SELECT col_default_is('drainzone', 'active', 'true', 'Column active should default to true');
SELECT col_has_default('drainzone', 'created_at', 'Column created_at should have default value');
SELECT col_default_is('drainzone', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_has_default('drainzone', 'created_by', 'Column created_by should have default value');
SELECT col_default_is('drainzone', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK;
