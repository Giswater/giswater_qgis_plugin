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
SELECT has_table('inp_transects_value'::name, 'Table inp_transects_value should exist');

-- Check columns
SELECT columns_are(
    'inp_transects_value',
    ARRAY[
        'id', 'tsect_id', 'text'
    ],
    'Table inp_transects_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_transects_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_transects_value', 'tsect_id', 'varchar(16)', 'Column tsect_id should be varchar(16)');
SELECT col_type_is('inp_transects_value', 'text', 'text', 'Column text should be text');

-- Check foreign keys
SELECT has_fk('inp_transects_value', 'Table inp_transects_value should have foreign keys');

SELECT fk_ok('inp_transects_value', 'tsect_id', 'inp_transects', 'id', 'FK tsect_id → inp_transects.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
