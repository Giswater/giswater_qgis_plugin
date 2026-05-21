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
SELECT has_table('inp_landuses'::name, 'Table inp_landuses should exist');

-- Check columns
SELECT columns_are(
    'inp_landuses',
    ARRAY[
        'landus_id', 'sweepint', 'availab', 'lastsweep'
    ],
    'Table inp_landuses should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_landuses', 'landus_id', 'varchar(16)', 'Column landus_id should be varchar(16)');
SELECT col_type_is('inp_landuses', 'sweepint', 'numeric(12,4)', 'Column sweepint should be numeric(12,4)');
SELECT col_type_is('inp_landuses', 'availab', 'numeric(12,4)', 'Column availab should be numeric(12,4)');
SELECT col_type_is('inp_landuses', 'lastsweep', 'numeric(12,4)', 'Column lastsweep should be numeric(12,4)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
