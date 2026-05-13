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

-- Check view ve_inp_subc2outlet
SELECT has_view('ve_inp_subc2outlet'::name, 'View ve_inp_subc2outlet should exist');

-- Check view columns
SELECT columns_are(
    've_inp_subc2outlet',
    ARRAY[
        'subc_id', 'outlet_id', 'outlet_type', 'length', 'hydrology_id', 'the_geom'
    ],
    'View ve_inp_subc2outlet should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_subc2outlet', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('ve_inp_subc2outlet', 'outlet_id', 'varchar(100)', 'Column outlet_id should be varchar(100)');
SELECT col_type_is('ve_inp_subc2outlet', 'outlet_type', 'text', 'Column outlet_type should be text');
SELECT col_type_is('ve_inp_subc2outlet', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('ve_inp_subc2outlet', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');
SELECT col_type_is('ve_inp_subc2outlet', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
