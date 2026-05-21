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
SELECT has_table('inp_valve'::name, 'Table inp_valve should exist');

-- Check columns
SELECT columns_are(
    'inp_valve',
    ARRAY[
        'node_id', 'valve_type', 'custom_dint', 'setting', 'curve_id', 'minorloss',
        'add_settings', 'init_quality', 'head', 'pattern_id', 'demand', 'demand_pattern_id',
        'emitter_coeff'
    ],
    'Table inp_valve should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_valve', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_valve', 'valve_type', 'varchar(18)', 'Column valve_type should be varchar(18)');
SELECT col_type_is('inp_valve', 'custom_dint', 'numeric(12,4)', 'Column custom_dint should be numeric(12,4)');
SELECT col_type_is('inp_valve', 'setting', 'numeric(12,4)', 'Column setting should be numeric(12,4)');
SELECT col_type_is('inp_valve', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_valve', 'minorloss', 'numeric(12,4)', 'Column minorloss should be numeric(12,4)');
SELECT col_type_is('inp_valve', 'add_settings', 'float8', 'Column add_settings should be float8');
SELECT col_type_is('inp_valve', 'init_quality', 'float8', 'Column init_quality should be float8');
SELECT col_type_is('inp_valve', 'head', 'float8', 'Column head should be float8');
SELECT col_type_is('inp_valve', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_valve', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_valve', 'demand_pattern_id', 'varchar(16)', 'Column demand_pattern_id should be varchar(16)');
SELECT col_type_is('inp_valve', 'emitter_coeff', 'float8', 'Column emitter_coeff should be float8');

-- Check foreign keys
SELECT has_fk('inp_valve', 'Table inp_valve should have foreign keys');

SELECT fk_ok('inp_valve', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');
SELECT fk_ok('inp_valve', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
