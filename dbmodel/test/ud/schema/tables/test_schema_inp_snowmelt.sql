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
SELECT has_table('inp_snowmelt'::name, 'Table inp_snowmelt should exist');

-- Check columns
SELECT columns_are(
    'inp_snowmelt',
    ARRAY[
        'stemp', 'atiwt', 'rnm', 'elev', 'lat', 'dtlong',
        'i_f0', 'i_f1', 'i_f2', 'i_f3', 'i_f4', 'i_f5',
        'i_f6', 'i_f7', 'i_f8', 'i_f9', 'p_f0', 'p_f1',
        'p_f2', 'p_f3', 'p_f4', 'p_f5', 'p_f6', 'p_f7',
        'p_f8', 'p_f9'
    ],
    'Table inp_snowmelt should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_snowmelt', 'stemp', 'numeric(12,4)', 'Column stemp should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'atiwt', 'numeric(12,4)', 'Column atiwt should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'rnm', 'numeric(12,4)', 'Column rnm should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'elev', 'numeric(12,4)', 'Column elev should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'lat', 'numeric(12,4)', 'Column lat should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'dtlong', 'numeric(12,4)', 'Column dtlong should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f0', 'numeric(12,4)', 'Column i_f0 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f1', 'numeric(12,4)', 'Column i_f1 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f2', 'numeric(12,4)', 'Column i_f2 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f3', 'numeric(12,4)', 'Column i_f3 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f4', 'numeric(12,4)', 'Column i_f4 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f5', 'numeric(12,4)', 'Column i_f5 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f6', 'numeric(12,4)', 'Column i_f6 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f7', 'numeric(12,4)', 'Column i_f7 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f8', 'numeric(12,4)', 'Column i_f8 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'i_f9', 'numeric(12,4)', 'Column i_f9 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f0', 'numeric(12,4)', 'Column p_f0 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f1', 'numeric(12,4)', 'Column p_f1 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f2', 'numeric(12,4)', 'Column p_f2 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f3', 'numeric(12,4)', 'Column p_f3 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f4', 'numeric(12,4)', 'Column p_f4 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f5', 'numeric(12,4)', 'Column p_f5 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f6', 'numeric(12,4)', 'Column p_f6 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f7', 'numeric(12,4)', 'Column p_f7 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f8', 'numeric(12,4)', 'Column p_f8 should be numeric(12,4)');
SELECT col_type_is('inp_snowmelt', 'p_f9', 'numeric(12,4)', 'Column p_f9 should be numeric(12,4)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
