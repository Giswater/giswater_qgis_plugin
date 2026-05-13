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
SELECT has_table('inp_gully'::name, 'Table inp_gully should exist');

-- Check columns
SELECT columns_are(
    'inp_gully',
    ARRAY[
        'gully_id', 'outlet_type', 'custom_top_elev', 'custom_width', 'custom_length', 'custom_depth',
        'gully_method', 'weir_cd', 'orifice_cd', 'custom_a_param', 'custom_b_param', 'efficiency'
    ],
    'Table inp_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('inp_gully', 'outlet_type', 'varchar(30)', 'Column outlet_type should be varchar(30)');
SELECT col_type_is('inp_gully', 'custom_top_elev', 'float8', 'Column custom_top_elev should be float8');
SELECT col_type_is('inp_gully', 'custom_width', 'float8', 'Column custom_width should be float8');
SELECT col_type_is('inp_gully', 'custom_length', 'float8', 'Column custom_length should be float8');
SELECT col_type_is('inp_gully', 'custom_depth', 'float8', 'Column custom_depth should be float8');
SELECT col_type_is('inp_gully', 'gully_method', 'varchar(30)', 'Column gully_method should be varchar(30)');
SELECT col_type_is('inp_gully', 'weir_cd', 'float8', 'Column weir_cd should be float8');
SELECT col_type_is('inp_gully', 'orifice_cd', 'float8', 'Column orifice_cd should be float8');
SELECT col_type_is('inp_gully', 'custom_a_param', 'float8', 'Column custom_a_param should be float8');
SELECT col_type_is('inp_gully', 'custom_b_param', 'float8', 'Column custom_b_param should be float8');
SELECT col_type_is('inp_gully', 'efficiency', 'float8', 'Column efficiency should be float8');

-- Check foreign keys
SELECT has_fk('inp_gully', 'Table inp_gully should have foreign keys');

SELECT fk_ok('inp_gully', 'gully_id', 'gully', 'gully_id', 'FK gully_id → gully.gully_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
