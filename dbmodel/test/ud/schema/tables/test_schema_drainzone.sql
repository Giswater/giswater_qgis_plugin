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
SELECT has_table('drainzone'::name, 'Table drainzone should exist');

-- Check columns
SELECT columns_are(
    'drainzone',
    ARRAY[
        'drainzone_id', 'code', 'name', 'drainzone_type', 'descript', 'expl_id',
        'sector_id', 'muni_id', 'link', 'graphconfig', 'stylesheet', 'lock_level',
        'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'addparam'
    ],
    'Table drainzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('drainzone', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('drainzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('drainzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('drainzone', 'drainzone_type', 'varchar(16)', 'Column drainzone_type should be varchar(16)');
SELECT col_type_is('drainzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('drainzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('drainzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('drainzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('drainzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('drainzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('drainzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('drainzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('drainzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('drainzone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('drainzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('drainzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('drainzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('drainzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('drainzone', 'addparam', 'json', 'Column addparam should be json');

-- Finish
SELECT * FROM finish();

ROLLBACK;
