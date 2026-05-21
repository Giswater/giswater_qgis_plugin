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
SELECT has_table('inp_pump_additional'::name, 'Table inp_pump_additional should exist');

-- Check columns
SELECT columns_are(
    'inp_pump_additional',
    ARRAY[
        'id', 'node_id', 'order_id', 'power', 'curve_id', 'speed',
        'pattern_id', 'status', 'energyparam', 'energyvalue', 'effic_curve_id', 'energy_price',
        'energy_pattern_id'
    ],
    'Table inp_pump_additional should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_pump_additional', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_pump_additional', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_pump_additional', 'order_id', 'int2', 'Column order_id should be int2');
SELECT col_type_is('inp_pump_additional', 'power', 'varchar', 'Column power should be varchar');
SELECT col_type_is('inp_pump_additional', 'curve_id', 'varchar', 'Column curve_id should be varchar');
SELECT col_type_is('inp_pump_additional', 'speed', 'numeric(12,6)', 'Column speed should be numeric(12,6)');
SELECT col_type_is('inp_pump_additional', 'pattern_id', 'varchar', 'Column pattern_id should be varchar');
SELECT col_type_is('inp_pump_additional', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_pump_additional', 'energyparam', 'varchar(30)', 'Column energyparam should be varchar(30)');
SELECT col_type_is('inp_pump_additional', 'energyvalue', 'varchar(30)', 'Column energyvalue should be varchar(30)');
SELECT col_type_is('inp_pump_additional', 'effic_curve_id', 'varchar(18)', 'Column effic_curve_id should be varchar(18)');
SELECT col_type_is('inp_pump_additional', 'energy_price', 'float8', 'Column energy_price should be float8');
SELECT col_type_is('inp_pump_additional', 'energy_pattern_id', 'varchar(18)', 'Column energy_pattern_id should be varchar(18)');

-- Check foreign keys
SELECT has_fk('inp_pump_additional', 'Table inp_pump_additional should have foreign keys');

SELECT fk_ok('inp_pump_additional', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');
SELECT fk_ok('inp_pump_additional', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('inp_pump_additional', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');
SELECT fk_ok('inp_pump_additional', 'energy_pattern_id', 'inp_pattern', 'pattern_id', 'FK energy_pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
