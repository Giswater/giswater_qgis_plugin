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

-- Check table inp_pump
SELECT has_table('inp_pump'::name, 'Table inp_pump should exist');

-- Check columns
SELECT columns_are(
    'inp_pump',
    ARRAY[
        'node_id', 'power', 'curve_id', 'speed', 'pattern_id', 'status', 'energyparam', 'energyvalue',
        'pump_type', 'effic_curve_id', 'energy_price', 'energy_pattern_id'
    ],
    'Table inp_pump should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_pump', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('inp_pump', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('inp_pump', 'power', 'varchar', 'Column power should be varchar');
SELECT col_type_is('inp_pump', 'curve_id', 'varchar', 'Column curve_id should be varchar');
SELECT col_type_is('inp_pump', 'speed', 'numeric(12,6)', 'Column speed should be numeric(12,6)');
SELECT col_type_is('inp_pump', 'pattern_id', 'varchar', 'Column pattern_id should be varchar');
SELECT col_type_is('inp_pump', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_pump', 'energyparam', 'varchar(30)', 'Column energyparam should be varchar(30)');
SELECT col_type_is('inp_pump', 'energyvalue', 'varchar(30)', 'Column energyvalue should be varchar(30)');
SELECT col_type_is('inp_pump', 'pump_type', 'varchar(16)', 'Column pump_type should be varchar(16)');
SELECT col_type_is('inp_pump', 'effic_curve_id', 'varchar(18)', 'Column effic_curve_id should be varchar(18)');
SELECT col_type_is('inp_pump', 'energy_price', 'double precision', 'Column energy_price should be double precision');
SELECT col_type_is('inp_pump', 'energy_pattern_id', 'varchar(18)', 'Column energy_pattern_id should be varchar(18)');

-- Check foreign keys
SELECT has_fk('inp_pump', 'Table inp_pump should have foreign keys');
SELECT fk_ok('inp_pump', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('inp_pump', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');
SELECT fk_ok('inp_pump', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');
SELECT fk_ok('inp_pump', 'energy_pattern_id', 'inp_pattern', 'pattern_id', 'FK energy_pattern_id should reference inp_pattern.pattern_id');

-- Check triggers
SELECT has_trigger('inp_pump', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_pump', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_pump', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_has_default('inp_pump', 'pump_type', 'Column pump_type should have default value');
SELECT col_has_check('inp_pump', 'status', 'Column status should have a check constraint');

SELECT * FROM finish();

ROLLBACK;