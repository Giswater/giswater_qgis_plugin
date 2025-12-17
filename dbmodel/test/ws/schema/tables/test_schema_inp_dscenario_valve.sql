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

-- Check table inp_dscenario_valve
SELECT has_table('inp_dscenario_valve'::name, 'Table inp_dscenario_valve should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_valve',
    ARRAY[
        'dscenario_id', 'node_id', 'valve_type', 'setting', 'curve_id', 'minorloss', 'status', 'add_settings', 'init_quality', 'to_arc'
    ],
    'Table inp_dscenario_valve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_valve', ARRAY['node_id', 'dscenario_id'], 'Columns node_id, dscenario_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_valve', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_valve', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('inp_dscenario_valve', 'valve_type', 'varchar(18)', 'Column valve_type should be varchar(18)');
SELECT col_type_is('inp_dscenario_valve', 'setting', 'numeric(12,4)', 'Column setting should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_valve', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_valve', 'minorloss', 'numeric(12,4)', 'Column minorloss should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_valve', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_dscenario_valve', 'add_settings', 'double precision', 'Column add_settings should be double precision');
SELECT col_type_is('inp_dscenario_valve', 'init_quality', 'double precision', 'Column init_quality should be double precision');
SELECT col_type_is('inp_dscenario_valve', 'to_arc', 'integer', 'Column to_arc should be integer');

-- Check foreign keys
SELECT has_fk('inp_dscenario_valve', 'Table inp_dscenario_valve should have foreign keys');
SELECT fk_ok('inp_dscenario_valve', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');
SELECT fk_ok('inp_dscenario_valve', 'node_id', 'inp_valve', 'node_id', 'FK node_id should reference inp_valve.node_id');
SELECT fk_ok('inp_dscenario_valve', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');

-- Check triggers
SELECT has_trigger('inp_dscenario_valve', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_dscenario_valve', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_valve', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_valve', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_has_check('inp_dscenario_valve', 'status', 'Column status should have a check constraint');
SELECT col_has_check('inp_dscenario_valve', 'valve_type', 'Column valve_type should have a check constraint');
SELECT col_has_default('inp_dscenario_valve', 'status', 'Column status should have default value');

SELECT * FROM finish();

ROLLBACK;