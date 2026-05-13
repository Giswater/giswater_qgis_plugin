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
SELECT has_table('inp_buildup'::name, 'Table inp_buildup should exist');

-- Check columns
SELECT columns_are(
    'inp_buildup',
    ARRAY[
        'landus_id', 'poll_id', 'funcb_type', 'c1', 'c2', 'c3',
        'perunit'
    ],
    'Table inp_buildup should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_buildup', 'landus_id', 'varchar(16)', 'Column landus_id should be varchar(16)');
SELECT col_type_is('inp_buildup', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('inp_buildup', 'funcb_type', 'varchar(18)', 'Column funcb_type should be varchar(18)');
SELECT col_type_is('inp_buildup', 'c1', 'numeric(12,4)', 'Column c1 should be numeric(12,4)');
SELECT col_type_is('inp_buildup', 'c2', 'numeric(12,4)', 'Column c2 should be numeric(12,4)');
SELECT col_type_is('inp_buildup', 'c3', 'numeric(12,4)', 'Column c3 should be numeric(12,4)');
SELECT col_type_is('inp_buildup', 'perunit', 'varchar(10)', 'Column perunit should be varchar(10)');

-- Check foreign keys
SELECT has_fk('inp_buildup', 'Table inp_buildup should have foreign keys');

SELECT fk_ok('inp_buildup', 'landus_id', 'inp_landuses', 'landus_id', 'FK landus_id → inp_landuses.landus_id');
SELECT fk_ok('inp_buildup', 'poll_id', 'inp_pollutant', 'poll_id', 'FK poll_id → inp_pollutant.poll_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
