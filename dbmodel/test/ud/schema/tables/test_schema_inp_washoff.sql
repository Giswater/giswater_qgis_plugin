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
SELECT has_table('inp_washoff'::name, 'Table inp_washoff should exist');

-- Check columns
SELECT columns_are(
    'inp_washoff',
    ARRAY[
        'landus_id', 'poll_id', 'funcw_type', 'c1', 'c2', 'sweepeffic',
        'bmpeffic'
    ],
    'Table inp_washoff should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_washoff', 'landus_id', 'varchar(16)', 'Column landus_id should be varchar(16)');
SELECT col_type_is('inp_washoff', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('inp_washoff', 'funcw_type', 'varchar(18)', 'Column funcw_type should be varchar(18)');
SELECT col_type_is('inp_washoff', 'c1', 'numeric(12,4)', 'Column c1 should be numeric(12,4)');
SELECT col_type_is('inp_washoff', 'c2', 'numeric(12,4)', 'Column c2 should be numeric(12,4)');
SELECT col_type_is('inp_washoff', 'sweepeffic', 'numeric(12,4)', 'Column sweepeffic should be numeric(12,4)');
SELECT col_type_is('inp_washoff', 'bmpeffic', 'numeric(12,4)', 'Column bmpeffic should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_washoff', 'Table inp_washoff should have foreign keys');

SELECT fk_ok('inp_washoff', 'landus_id', 'inp_landuses', 'landus_id', 'FK landus_id → inp_landuses.landus_id');
SELECT fk_ok('inp_washoff', 'poll_id', 'inp_pollutant', 'poll_id', 'FK poll_id → inp_pollutant.poll_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
