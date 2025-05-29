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

-- Check table inp_tank
SELECT has_table('inp_tank'::name, 'Table inp_tank should exist');

-- Check columns
SELECT columns_are(
    'inp_tank',
    ARRAY[
        'node_id', 'initlevel', 'minlevel', 'maxlevel', 'diameter', 'minvol', 'curve_id',
        'overflow', 'mixing_model', 'mixing_fraction', 'reaction_coeff', 'init_quality',
        'source_type', 'source_quality', 'source_pattern_id'
    ],
    'Table inp_tank should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_tank', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('inp_tank', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('inp_tank', 'initlevel', 'numeric(12,4)', 'Column initlevel should be numeric(12,4)');
SELECT col_type_is('inp_tank', 'minlevel', 'numeric(12,4)', 'Column minlevel should be numeric(12,4)');
SELECT col_type_is('inp_tank', 'maxlevel', 'numeric(12,4)', 'Column maxlevel should be numeric(12,4)');
SELECT col_type_is('inp_tank', 'diameter', 'numeric(12,4)', 'Column diameter should be numeric(12,4)');
SELECT col_type_is('inp_tank', 'minvol', 'numeric(12,4)', 'Column minvol should be numeric(12,4)');
SELECT col_type_is('inp_tank', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_tank', 'overflow', 'varchar(3)', 'Column overflow should be varchar(3)');
SELECT col_type_is('inp_tank', 'mixing_model', 'varchar(18)', 'Column mixing_model should be varchar(18)');
SELECT col_type_is('inp_tank', 'mixing_fraction', 'double precision', 'Column mixing_fraction should be double precision');
SELECT col_type_is('inp_tank', 'reaction_coeff', 'double precision', 'Column reaction_coeff should be double precision');
SELECT col_type_is('inp_tank', 'init_quality', 'double precision', 'Column init_quality should be double precision');
SELECT col_type_is('inp_tank', 'source_type', 'varchar(18)', 'Column source_type should be varchar(18)');
SELECT col_type_is('inp_tank', 'source_quality', 'double precision', 'Column source_quality should be double precision');
SELECT col_type_is('inp_tank', 'source_pattern_id', 'varchar(16)', 'Column source_pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_tank', 'Table inp_tank should have foreign keys');
SELECT fk_ok('inp_tank', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('inp_tank', 'curve_id', 'inp_curve', 'id', 'FK curve_id should reference inp_curve.id');

-- Check triggers
SELECT has_trigger('inp_tank', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_tank', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_tank', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;