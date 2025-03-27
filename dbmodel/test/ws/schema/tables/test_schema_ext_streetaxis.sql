/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table ext_streetaxis
SELECT has_table('ext_streetaxis'::name, 'Table ext_streetaxis should exist');

-- Check columns
SELECT columns_are(
    'ext_streetaxis',
    ARRAY[
        'id', 'code', 'type', 'name', 'text', 'the_geom', 'expl_id', 'muni_id', 'source'
    ],
    'Table ext_streetaxis should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_streetaxis', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_streetaxis', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_streetaxis', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_streetaxis', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('ext_streetaxis', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ext_streetaxis', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ext_streetaxis', 'the_geom', 'geometry(MultiLineString,25831)', 'Column the_geom should be geometry(MultiLineString,25831)');
SELECT col_type_is('ext_streetaxis', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('ext_streetaxis', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_streetaxis', 'source', 'text', 'Column source should be text');

-- Check unique constraints
SELECT col_is_unique('ext_streetaxis', ARRAY['muni_id', 'id'], 'Column muni_id and id should be unique');

-- Check indexes
SELECT has_index('ext_streetaxis', 'idx_ext_streetaxis_code', 'Table should have index on code');
SELECT has_index('ext_streetaxis', 'idx_ext_streetaxis_muni_id', 'Table should have index on muni_id');
SELECT has_index('ext_streetaxis', 'idx_ext_streetaxis_name', 'Table should have index on name');
SELECT has_index('ext_streetaxis', 'idx_ext_streetaxis_the_geom', 'Table should have index on the_geom');

-- Check foreign keys
SELECT has_fk('ext_streetaxis', 'Table ext_streetaxis should have foreign keys');
SELECT fk_ok('ext_streetaxis', 'expl_id', 'exploitation', 'expl_id', 'FK ext_streetaxis_exploitation_id_fkey should exist');
SELECT fk_ok('ext_streetaxis', 'muni_id', 'ext_municipality', 'muni_id', 'FK ext_streetaxis_muni_id_fkey should exist');
SELECT fk_ok('ext_streetaxis', 'type', 'ext_type_street', 'id', 'FK ext_streetaxis_type_street_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_streetaxis', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('ext_streetaxis', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('ext_streetaxis', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('ext_streetaxis', 'muni_id', 'Column muni_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
