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
SELECT has_table('inp_adjustments'::name, 'Table inp_adjustments should exist');

-- Check columns
SELECT columns_are(
    'inp_adjustments',
    ARRAY[
        'id', 'adj_type', 'value_1', 'value_2', 'value_3', 'value_4',
        'value_5', 'value_6', 'value_7', 'value_8', 'value_9', 'value_10',
        'value_11', 'value_12'
    ],
    'Table inp_adjustments should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_adjustments', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('inp_adjustments', 'adj_type', 'varchar(16)', 'Column adj_type should be varchar(16)');
SELECT col_type_is('inp_adjustments', 'value_1', 'numeric(12,4)', 'Column value_1 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_2', 'numeric(12,4)', 'Column value_2 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_3', 'numeric(12,4)', 'Column value_3 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_4', 'numeric(12,4)', 'Column value_4 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_5', 'numeric(12,4)', 'Column value_5 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_6', 'numeric(12,4)', 'Column value_6 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_7', 'numeric(12,4)', 'Column value_7 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_8', 'numeric(12,4)', 'Column value_8 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_9', 'numeric(12,4)', 'Column value_9 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_10', 'numeric(12,4)', 'Column value_10 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_11', 'numeric(12,4)', 'Column value_11 should be numeric(12,4)');
SELECT col_type_is('inp_adjustments', 'value_12', 'numeric(12,4)', 'Column value_12 should be numeric(12,4)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
