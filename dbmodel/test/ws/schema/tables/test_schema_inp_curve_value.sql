/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table inp_curve_value
SELECT has_table('inp_curve_value'::name, 'Table inp_curve_value should exist');

-- Check columns
SELECT columns_are(
    'inp_curve_value',
    ARRAY[
        'id', 'curve_id', 'x_value', 'y_value'
    ],
    'Table inp_curve_value should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_curve_value', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_curve_value', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_curve_value', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_curve_value', 'x_value', 'numeric(12,4)', 'Column x_value should be numeric(12,4)');
SELECT col_type_is('inp_curve_value', 'y_value', 'numeric(12,4)', 'Column y_value should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_curve_value', 'Table inp_curve_value should have foreign keys');
SELECT fk_ok('inp_curve_value', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('inp_curve_value_id_seq', 'Sequence inp_curve_value_id_seq should exist');


-- Check constraints
SELECT col_not_null('inp_curve_value', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('inp_curve_value', 'curve_id', 'Column curve_id should be NOT NULL');
SELECT col_not_null('inp_curve_value', 'x_value', 'Column x_value should be NOT NULL');
SELECT col_not_null('inp_curve_value', 'y_value', 'Column y_value should be NOT NULL');

-- Check indexes
SELECT has_index('inp_curve_value', 'inp_curve_value_curve_id', 'Should have index on curve_id');

SELECT * FROM finish();

ROLLBACK;
