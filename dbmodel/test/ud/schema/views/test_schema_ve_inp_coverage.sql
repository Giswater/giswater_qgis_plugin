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

-- Check view ve_inp_coverage
SELECT has_view('ve_inp_coverage'::name, 'View ve_inp_coverage should exist');

-- Check view columns
SELECT columns_are(
    've_inp_coverage',
    ARRAY[
        'subc_id', 'landus_id', 'percent', 'hydrology_id'
    ],
    'View ve_inp_coverage should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_coverage', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('ve_inp_coverage', 'landus_id', 'varchar(16)', 'Column landus_id should be varchar(16)');
SELECT col_type_is('ve_inp_coverage', 'percent', 'numeric(12,4)', 'Column percent should be numeric(12,4)');
SELECT col_type_is('ve_inp_coverage', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');

SELECT * FROM finish();

ROLLBACK;
