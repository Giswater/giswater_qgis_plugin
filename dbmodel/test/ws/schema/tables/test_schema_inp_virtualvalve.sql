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

-- Check table inp_virtualvalve
SELECT has_table('inp_virtualvalve'::name, 'Table inp_virtualvalve should exist');

-- Check columns
SELECT columns_are(
    'inp_virtualvalve',
    ARRAY[
        'arc_id', 'valve_type', 'diameter', 'setting', 'curve_id', 'minorloss', 'status', 'init_quality'
    ],
    'Table inp_virtualvalve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_virtualvalve', ARRAY['arc_id'], 'Column arc_id should be primary key');

-- Check column types
SELECT col_type_is('inp_virtualvalve', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('inp_virtualvalve', 'valve_type', 'varchar(18)', 'Column valve_type should be varchar(18)');
SELECT col_type_is('inp_virtualvalve', 'diameter', 'numeric(12,4)', 'Column diameter should be numeric(12,4)');
SELECT col_type_is('inp_virtualvalve', 'setting', 'numeric(12,4)', 'Column setting should be numeric(12,4)');
SELECT col_type_is('inp_virtualvalve', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_virtualvalve', 'minorloss', 'numeric(12,4)', 'Column minorloss should be numeric(12,4)');
SELECT col_type_is('inp_virtualvalve', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_virtualvalve', 'init_quality', 'double precision', 'Column init_quality should be double precision');

-- Check foreign keys
SELECT has_fk('inp_virtualvalve', 'Table inp_virtualvalve should have foreign keys');
SELECT fk_ok('inp_virtualvalve', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('inp_virtualvalve', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');

-- Check triggers
SELECT has_trigger('inp_virtualvalve', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_virtualvalve', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_virtualvalve', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_has_check('inp_virtualvalve', 'valve_type', 'Column valve_type should have a check constraint');
SELECT col_has_check('inp_virtualvalve', 'status', 'Column status should have a check constraint');

SELECT * FROM finish();

ROLLBACK;