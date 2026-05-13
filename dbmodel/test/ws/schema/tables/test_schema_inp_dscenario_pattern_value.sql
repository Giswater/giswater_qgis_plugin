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
SELECT has_table('inp_dscenario_pattern_value'::name, 'Table inp_dscenario_pattern_value should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_pattern_value',
    ARRAY[
        'id', 'dscenario_id', 'pattern_id', 'factor_1', 'factor_2', 'factor_3',
        'factor_4', 'factor_5', 'factor_6', 'factor_7', 'factor_8', 'factor_9',
        'factor_10', 'factor_11', 'factor_12', 'factor_13', 'factor_14', 'factor_15',
        'factor_16', 'factor_17', 'factor_18'
    ],
    'Table inp_dscenario_pattern_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_dscenario_pattern_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_dscenario_pattern_value', 'dscenario_id', 'int4', 'Column dscenario_id should be int4');
SELECT col_type_is('inp_dscenario_pattern_value', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_1', 'numeric(12,4)', 'Column factor_1 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_2', 'numeric(12,4)', 'Column factor_2 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_3', 'numeric(12,4)', 'Column factor_3 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_4', 'numeric(12,4)', 'Column factor_4 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_5', 'numeric(12,4)', 'Column factor_5 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_6', 'numeric(12,4)', 'Column factor_6 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_7', 'numeric(12,4)', 'Column factor_7 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_8', 'numeric(12,4)', 'Column factor_8 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_9', 'numeric(12,4)', 'Column factor_9 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_10', 'numeric(12,4)', 'Column factor_10 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_11', 'numeric(12,4)', 'Column factor_11 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_12', 'numeric(12,4)', 'Column factor_12 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_13', 'numeric(12,4)', 'Column factor_13 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_14', 'numeric(12,4)', 'Column factor_14 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_15', 'numeric(12,4)', 'Column factor_15 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_16', 'numeric(12,4)', 'Column factor_16 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_17', 'numeric(12,4)', 'Column factor_17 should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_pattern_value', 'factor_18', 'numeric(12,4)', 'Column factor_18 should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_dscenario_pattern_value', 'Table inp_dscenario_pattern_value should have foreign keys');

SELECT fk_ok('inp_dscenario_pattern_value', ARRAY['dscenario_id', 'pattern_id'], 'inp_dscenario_pattern', ARRAY['dscenario_id', 'pattern_id'], 'FK (dscenario_id, pattern_id) → inp_dscenario_pattern(dscenario_id, pattern_id)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
