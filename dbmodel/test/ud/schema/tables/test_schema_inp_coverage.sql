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
SELECT has_table('inp_coverage'::name, 'Table inp_coverage should exist');

-- Check columns
SELECT columns_are(
    'inp_coverage',
    ARRAY[
        'subc_id', 'landus_id', 'percent', 'hydrology_id'
    ],
    'Table inp_coverage should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_coverage', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('inp_coverage', 'landus_id', 'varchar(16)', 'Column landus_id should be varchar(16)');
SELECT col_type_is('inp_coverage', 'percent', 'numeric(12,4)', 'Column percent should be numeric(12,4)');
SELECT col_type_is('inp_coverage', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');

-- Check foreign keys
SELECT has_fk('inp_coverage', 'Table inp_coverage should have foreign keys');

SELECT fk_ok('inp_coverage', 'landus_id', 'inp_landuses', 'landus_id', 'FK landus_id → inp_landuses.landus_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
