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
SELECT has_table('inp_pollutant'::name, 'Table inp_pollutant should exist');

-- Check columns
SELECT columns_are(
    'inp_pollutant',
    ARRAY[
        'poll_id', 'units_type', 'crain', 'cgw', 'cii', 'kd',
        'sflag', 'copoll_id', 'cofract', 'cdwf', 'cinit'
    ],
    'Table inp_pollutant should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_pollutant', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('inp_pollutant', 'units_type', 'varchar(18)', 'Column units_type should be varchar(18)');
SELECT col_type_is('inp_pollutant', 'crain', 'numeric(12,4)', 'Column crain should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'cgw', 'numeric(12,4)', 'Column cgw should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'cii', 'numeric(12,4)', 'Column cii should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'kd', 'numeric(12,4)', 'Column kd should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'sflag', 'varchar(3)', 'Column sflag should be varchar(3)');
SELECT col_type_is('inp_pollutant', 'copoll_id', 'varchar(16)', 'Column copoll_id should be varchar(16)');
SELECT col_type_is('inp_pollutant', 'cofract', 'numeric(12,4)', 'Column cofract should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'cdwf', 'numeric(12,4)', 'Column cdwf should be numeric(12,4)');
SELECT col_type_is('inp_pollutant', 'cinit', 'numeric(12,4)', 'Column cinit should be numeric(12,4)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
