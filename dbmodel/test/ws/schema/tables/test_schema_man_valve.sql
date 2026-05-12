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

-- Check table man_valve
SELECT has_table('man_valve'::name, 'Table man_valve should exist');

-- Check columns
SELECT columns_are(
    'man_valve',
    ARRAY[
        'node_id', 'closed', 'broken', 'buried', 'irrigation_indicator', 'pressure_entry', 'pressure_exit',
        'depth_valveshaft', 'regulator_situation', 'regulator_location', 'regulator_observ', 'lin_meters',
        'exit_type', 'exit_code', 'drive_type', 'cat_valve2', 'ordinarystatus', 'shutter', 'brand2',
        'model2', 'valve_type', 'to_arc', 'automated', 'connection_type', 'flowsetting'
    ],
    'Table man_valve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_valve', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_valve', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_valve', 'closed', 'boolean', 'Column closed should be boolean');
SELECT col_type_is('man_valve', 'broken', 'boolean', 'Column broken should be boolean');
SELECT col_type_is('man_valve', 'buried', 'varchar(16)', 'Column buried should be varchar(16)');
SELECT col_type_is('man_valve', 'irrigation_indicator', 'varchar(16)', 'Column irrigation_indicator should be varchar(16)');
SELECT col_type_is('man_valve', 'pressure_entry', 'numeric(12,3)', 'Column pressure_entry should be numeric(12,3)');
SELECT col_type_is('man_valve', 'pressure_exit', 'numeric(12,3)', 'Column pressure_exit should be numeric(12,3)');
SELECT col_type_is('man_valve', 'depth_valveshaft', 'numeric(12,3)', 'Column depth_valveshaft should be numeric(12,3)');
SELECT col_type_is('man_valve', 'regulator_situation', 'varchar(150)', 'Column regulator_situation should be varchar(150)');
SELECT col_type_is('man_valve', 'regulator_location', 'varchar(150)', 'Column regulator_location should be varchar(150)');
SELECT col_type_is('man_valve', 'regulator_observ', 'varchar(254)', 'Column regulator_observ should be varchar(254)');
SELECT col_type_is('man_valve', 'lin_meters', 'numeric(12,3)', 'Column lin_meters should be numeric(12,3)');
SELECT col_type_is('man_valve', 'exit_type', 'varchar(100)', 'Column exit_type should be varchar(100)');
SELECT col_type_is('man_valve', 'exit_code', 'integer', 'Column exit_code should be integer');
SELECT col_type_is('man_valve', 'drive_type', 'varchar(100)', 'Column drive_type should be varchar(100)');
SELECT col_type_is('man_valve', 'cat_valve2', 'varchar(30)', 'Column cat_valve2 should be varchar(30)');
SELECT col_type_is('man_valve', 'ordinarystatus', 'smallint', 'Column ordinarystatus should be smallint');
SELECT col_type_is('man_valve', 'shutter', 'text', 'Column shutter should be text');
SELECT col_type_is('man_valve', 'brand2', 'text', 'Column brand2 should be text');
SELECT col_type_is('man_valve', 'model2', 'text', 'Column model2 should be text');
SELECT col_type_is('man_valve', 'valve_type', 'text', 'Column valve_type should be text');
SELECT col_type_is('man_valve', 'to_arc', 'integer', 'Column to_arc should be integer');
SELECT col_type_is('man_valve', 'automated', 'boolean', 'Column automated should be boolean');
SELECT col_type_is('man_valve', 'connection_type', 'integer', 'Column connection_type should be integer');
SELECT col_type_is('man_valve', 'flowsetting', 'numeric(12,3)', 'Column flowsetting should be numeric(12,3)');

-- Check default values
SELECT col_default_is('man_valve', 'closed', 'false', 'Column closed should default to false');
SELECT col_default_is('man_valve', 'broken', 'false', 'Column broken should default to false');

-- Check foreign keys
SELECT has_fk('man_valve', 'Table man_valve should have foreign keys');
SELECT fk_ok('man_valve', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('man_valve', 'cat_valve2', 'cat_node', 'id', 'FK cat_valve2 should reference cat_node.id');

-- Check triggers
SELECT has_trigger('man_valve', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('man_valve', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check constraints
SELECT col_not_null('man_valve', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;