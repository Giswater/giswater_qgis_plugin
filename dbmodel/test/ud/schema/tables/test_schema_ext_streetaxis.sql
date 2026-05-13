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
SELECT has_table('ext_streetaxis'::name, 'Table ext_streetaxis should exist');

-- Check columns
SELECT columns_are(
    'ext_streetaxis',
    ARRAY[
        'id', 'code', 'type', 'name', 'text', 'the_geom',
        'muni_id', 'source'
    ],
    'Table ext_streetaxis should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_streetaxis', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_streetaxis', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ext_streetaxis', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('ext_streetaxis', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ext_streetaxis', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ext_streetaxis', 'the_geom', 'geometry(multilinestring, SRID_VALUE)', 'Column the_geom should be geometry(multilinestring, SRID_VALUE)');
SELECT col_type_is('ext_streetaxis', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_streetaxis', 'source', 'text', 'Column source should be text');

-- Check foreign keys
SELECT has_fk('ext_streetaxis', 'Table ext_streetaxis should have foreign keys');

SELECT fk_ok('ext_streetaxis', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');
SELECT fk_ok('ext_streetaxis', 'type', 'ext_type_street', 'id', 'FK type → ext_type_street.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
