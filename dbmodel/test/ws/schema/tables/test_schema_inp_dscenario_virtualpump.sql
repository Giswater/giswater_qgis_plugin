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

-- Check table inp_dscenario_virtualpump
SELECT has_table('inp_dscenario_virtualpump'::name, 'Table inp_dscenario_virtualpump should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_virtualpump',
    ARRAY[
        'dscenario_id', 'arc_id', 'power', 'curve_id', 'speed', 'pattern_id', 'status', 'effic_curve_id',
        'energy_price', 'energy_pattern_id', 'pump_type'
    ],
    'Table inp_dscenario_virtualpump should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_virtualpump', ARRAY['dscenario_id', 'arc_id'], 'Columns dscenario_id, arc_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_virtualpump', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_virtualpump', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_virtualpump', 'power', 'varchar', 'Column power should be varchar');
SELECT col_type_is('inp_dscenario_virtualpump', 'curve_id', 'varchar', 'Column curve_id should be varchar');
SELECT col_type_is('inp_dscenario_virtualpump', 'speed', 'numeric(12,6)', 'Column speed should be numeric(12,6)');
SELECT col_type_is('inp_dscenario_virtualpump', 'pattern_id', 'varchar', 'Column pattern_id should be varchar');
SELECT col_type_is('inp_dscenario_virtualpump', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_dscenario_virtualpump', 'effic_curve_id', 'varchar(18)', 'Column effic_curve_id should be varchar(18)');
SELECT col_type_is('inp_dscenario_virtualpump', 'energy_price', 'double precision', 'Column energy_price should be double precision');
SELECT col_type_is('inp_dscenario_virtualpump', 'energy_pattern_id', 'varchar(18)', 'Column energy_pattern_id should be varchar(18)');
SELECT col_type_is('inp_dscenario_virtualpump', 'pump_type', 'varchar(16)', 'Column pump_type should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_dscenario_virtualpump', 'Table inp_dscenario_virtualpump should have foreign keys');
SELECT fk_ok('inp_dscenario_virtualpump', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');
SELECT fk_ok('inp_dscenario_virtualpump', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');
SELECT fk_ok('inp_dscenario_virtualpump', 'energy_pattern_id', 'inp_pattern', 'pattern_id', 'FK energy_pattern_id should reference inp_pattern.pattern_id');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_virtualpump', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_virtualpump', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_default_is('inp_dscenario_virtualpump', 'pump_type', 'POWERPUMP', 'Column pump_type should default to POWERPUMP');

SELECT * FROM finish();

ROLLBACK;