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

-- Check table inp_dscenario_virtualvalve
SELECT has_table('inp_dscenario_virtualvalve'::name, 'Table inp_dscenario_virtualvalve should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_virtualvalve',
    ARRAY[
        'dscenario_id', 'arc_id', 'valv_type', 'diameter', 'setting', 'curve_id', 'minorloss', 'status', 'init_quality'
    ],
    'Table inp_dscenario_virtualvalve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_virtualvalve', ARRAY['dscenario_id', 'arc_id'], 'Columns dscenario_id, arc_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_virtualvalve', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_virtualvalve', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'valv_type', 'varchar(18)', 'Column valv_type should be varchar(18)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'diameter', 'numeric(12,4)', 'Column diameter should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'setting', 'numeric(12,4)', 'Column setting should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'minorloss', 'numeric(12,4)', 'Column minorloss should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_dscenario_virtualvalve', 'init_quality', 'double precision', 'Column init_quality should be double precision');

-- Check foreign keys
SELECT has_fk('inp_dscenario_virtualvalve', 'Table inp_dscenario_virtualvalve should have foreign keys');
SELECT fk_ok('inp_dscenario_virtualvalve', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');
SELECT fk_ok('inp_dscenario_virtualvalve', 'arc_id', 'inp_virtualvalve', 'arc_id', 'FK arc_id should reference inp_virtualvalve.arc_id');
SELECT fk_ok('inp_dscenario_virtualvalve', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');

-- Check triggers
SELECT has_trigger('inp_dscenario_virtualvalve', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_dscenario_virtualvalve', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_virtualvalve', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_virtualvalve', 'arc_id', 'Column arc_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;