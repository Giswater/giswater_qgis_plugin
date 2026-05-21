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

-- Check view v_streetaxis
SELECT has_view('v_streetaxis'::name, 'View v_streetaxis should exist');

-- Check view columns
SELECT columns_are(
    'v_streetaxis',
    ARRAY[
        'id', 'code', 'type', 'name', 'text', 'the_geom',
        'muni_id', 'source'
    ],
    'View v_streetaxis should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_streetaxis', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('v_streetaxis', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('v_streetaxis', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('v_streetaxis', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('v_streetaxis', 'text', 'text', 'Column text should be text');
SELECT col_type_is('v_streetaxis', 'the_geom', 'geometry(multilinestring, SRID_VALUE)', 'Column the_geom should be geometry(multilinestring, SRID_VALUE)');
SELECT col_type_is('v_streetaxis', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('v_streetaxis', 'source', 'text', 'Column source should be text');

SELECT * FROM finish();

ROLLBACK;
