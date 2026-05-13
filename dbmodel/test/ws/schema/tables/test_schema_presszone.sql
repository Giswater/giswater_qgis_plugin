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
SELECT has_table('presszone'::name, 'Table presszone should exist');

-- Check columns
SELECT columns_are(
    'presszone',
    ARRAY[
        'presszone_id', 'code', 'name', 'descript', 'presszone_type', 'muni_id',
        'expl_id', 'sector_id', 'link', 'graphconfig', 'stylesheet', 'head',
        'avg_press', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by',
        'updated_at', 'updated_by', 'addparam'
    ],
    'Table presszone should have the correct columns'
);

-- Check column types
SELECT col_type_is('presszone', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('presszone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('presszone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('presszone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('presszone', 'presszone_type', 'text', 'Column presszone_type should be text');
SELECT col_type_is('presszone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('presszone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('presszone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('presszone', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('presszone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('presszone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('presszone', 'head', 'numeric(12,2)', 'Column head should be numeric(12,2)');
SELECT col_type_is('presszone', 'avg_press', 'float8', 'Column avg_press should be float8');
SELECT col_type_is('presszone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('presszone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('presszone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('presszone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('presszone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('presszone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('presszone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('presszone', 'addparam', 'json', 'Column addparam should be json');

-- Finish
SELECT * FROM finish();

ROLLBACK;
