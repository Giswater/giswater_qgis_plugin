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

-- Check table inp_dscenario_junction
SELECT has_table('inp_dscenario_junction'::name, 'Table inp_dscenario_junction should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_junction',
    ARRAY[
        'dscenario_id', 'node_id', 'demand', 'pattern_id', 'peak_factor', 'emitter_coeff', 'init_quality',
        'source_type', 'source_quality', 'source_pattern_id'
    ],
    'Table inp_dscenario_junction should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_junction', ARRAY['dscenario_id', 'node_id'], 'Columns dscenario_id, node_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_junction', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_junction', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_junction', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_dscenario_junction', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_junction', 'peak_factor', 'numeric(12,4)', 'Column peak_factor should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_junction', 'emitter_coeff', 'double precision', 'Column emitter_coeff should be double precision');
SELECT col_type_is('inp_dscenario_junction', 'init_quality', 'double precision', 'Column init_quality should be double precision');
SELECT col_type_is('inp_dscenario_junction', 'source_type', 'varchar(18)', 'Column source_type should be varchar(18)');
SELECT col_type_is('inp_dscenario_junction', 'source_quality', 'double precision', 'Column source_quality should be double precision');
SELECT col_type_is('inp_dscenario_junction', 'source_pattern_id', 'varchar(16)', 'Column source_pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_dscenario_junction', 'Table inp_dscenario_junction should have foreign keys');
SELECT fk_ok('inp_dscenario_junction', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');
SELECT fk_ok('inp_dscenario_junction', 'node_id', 'inp_junction', 'node_id', 'FK node_id should reference inp_junction.node_id');
SELECT fk_ok('inp_dscenario_junction', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');

-- Check triggers
SELECT has_trigger('inp_dscenario_junction', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_dscenario_junction', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_junction', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_junction', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;