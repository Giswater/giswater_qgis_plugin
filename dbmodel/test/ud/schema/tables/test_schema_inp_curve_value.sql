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
SELECT has_table('inp_curve_value'::name, 'Table inp_curve_value should exist');

-- Check columns
SELECT columns_are(
    'inp_curve_value',
    ARRAY[
        'id', 'curve_id', 'x_value', 'y_value'
    ],
    'Table inp_curve_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_curve_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_curve_value', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_curve_value', 'x_value', 'numeric(18,6)', 'Column x_value should be numeric(18,6)');
SELECT col_type_is('inp_curve_value', 'y_value', 'numeric(18,6)', 'Column y_value should be numeric(18,6)');

-- Check foreign keys
SELECT has_fk('inp_curve_value', 'Table inp_curve_value should have foreign keys');

SELECT fk_ok('inp_curve_value', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
