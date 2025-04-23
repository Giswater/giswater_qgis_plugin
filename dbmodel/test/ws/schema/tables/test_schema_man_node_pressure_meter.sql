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

-- Check table man_node_pressure_meter
SELECT has_table('man_node_pressure_meter'::name, 'Table man_node_pressure_meter should exist');

-- Check columns
SELECT columns_are(
    'man_node_pressure_meter',
    ARRAY[
        'node_id', 'pressmeter_param_1', 'pressmeter_param_2'
    ],
    'Table man_node_pressure_meter should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_node_pressure_meter', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_node_pressure_meter', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_node_pressure_meter', 'pressmeter_param_1', 'text', 'Column pressmeter_param_1 should be text');
SELECT col_type_is('man_node_pressure_meter', 'pressmeter_param_2', 'date', 'Column pressmeter_param_2 should be date');

-- Check not null constraints
SELECT col_not_null('man_node_pressure_meter', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_node_pressure_meter', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check indexes
SELECT has_index('man_node_pressure_meter', 'man_node_pressure_meter_node_id_index', 'Should have index on node_id');

-- Check triggers
SELECT has_trigger('man_node_pressure_meter', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('man_node_pressure_meter', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

SELECT * FROM finish();

ROLLBACK;