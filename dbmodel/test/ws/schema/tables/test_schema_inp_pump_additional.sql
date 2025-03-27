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

-- Check table inp_pump_additional
SELECT has_table('inp_pump_additional'::name, 'Table inp_pump_additional should exist');

-- Check columns
SELECT columns_are(
    'inp_pump_additional',
    ARRAY[
        'id', 'node_id', 'order_id', 'power', 'curve_id', 'speed', 'pattern_id', 'status', 'energyparam',
        'energyvalue', 'effic_curve_id', 'energy_price', 'energy_pattern_id'
    ],
    'Table inp_pump_additional should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_pump_additional', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_pump_additional', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_pump_additional', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('inp_pump_additional', 'order_id', 'smallint', 'Column order_id should be smallint');
SELECT col_type_is('inp_pump_additional', 'power', 'varchar', 'Column power should be varchar');
SELECT col_type_is('inp_pump_additional', 'curve_id', 'varchar', 'Column curve_id should be varchar');
SELECT col_type_is('inp_pump_additional', 'speed', 'numeric(12,6)', 'Column speed should be numeric(12,6)');
SELECT col_type_is('inp_pump_additional', 'pattern_id', 'varchar', 'Column pattern_id should be varchar');
SELECT col_type_is('inp_pump_additional', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_pump_additional', 'energyparam', 'varchar(30)', 'Column energyparam should be varchar(30)');
SELECT col_type_is('inp_pump_additional', 'energyvalue', 'varchar(30)', 'Column energyvalue should be varchar(30)');
SELECT col_type_is('inp_pump_additional', 'effic_curve_id', 'varchar(18)', 'Column effic_curve_id should be varchar(18)');
SELECT col_type_is('inp_pump_additional', 'energy_price', 'double precision', 'Column energy_price should be double precision');
SELECT col_type_is('inp_pump_additional', 'energy_pattern_id', 'varchar(18)', 'Column energy_pattern_id should be varchar(18)');

-- Check foreign keys
SELECT has_fk('inp_pump_additional', 'Table inp_pump_additional should have foreign keys');
SELECT fk_ok('inp_pump_additional', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('inp_pump_additional', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');
SELECT fk_ok('inp_pump_additional', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');
SELECT fk_ok('inp_pump_additional', 'energy_pattern_id', 'inp_pattern', 'pattern_id', 'FK energy_pattern_id should reference inp_pattern.pattern_id');

-- Check triggers
SELECT has_trigger('inp_pump_additional', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_pump_additional', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_pump_additional', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('inp_pump_additional', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_has_check('inp_pump_additional', 'status', 'Column status should have a check constraint');
SELECT col_is_unique('inp_pump_additional', ARRAY['node_id', 'order_id'], 'Table should have a unique constraint on node_id, order_id');

-- Check indexes
SELECT has_index('inp_pump_additional', 'idx_inp_pump_additional_energy_pattern_id', 'Should have index on energy_pattern_id');
SELECT has_index('inp_pump_additional', 'idx_inp_pump_additional_id', 'Should have index on id');
SELECT has_index('inp_pump_additional', 'idx_inp_pump_additional_node_id', 'Should have index on node_id');
SELECT has_index('inp_pump_additional', 'idx_inp_pump_additional_pattern_id', 'Should have index on pattern_id');

SELECT * FROM finish();

ROLLBACK;