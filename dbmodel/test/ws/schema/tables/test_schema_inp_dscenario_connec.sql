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

-- Check table inp_dscenario_connec
SELECT has_table('inp_dscenario_connec'::name, 'Table inp_dscenario_connec should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_connec',
    ARRAY[
        'dscenario_id', 'connec_id', 'demand', 'pattern_id', 'peak_factor', 'status', 'minorloss', 'custom_roughness',
        'custom_length', 'custom_dint', 'emitter_coeff', 'init_quality', 'source_type', 'source_quality', 'source_pattern_id'
    ],
    'Table inp_dscenario_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_connec', ARRAY['dscenario_id', 'connec_id'], 'Columns dscenario_id, connec_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_connec', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_connec', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_dscenario_connec', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_connec', 'peak_factor', 'numeric(12,4)', 'Column peak_factor should be numeric(12,4)');
SELECT col_type_is('inp_dscenario_connec', 'status', 'varchar(16)', 'Column status should be varchar(16)');
SELECT col_type_is('inp_dscenario_connec', 'minorloss', 'double precision', 'Column minorloss should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'custom_roughness', 'double precision', 'Column custom_roughness should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'custom_length', 'double precision', 'Column custom_length should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'custom_dint', 'double precision', 'Column custom_dint should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'emitter_coeff', 'double precision', 'Column emitter_coeff should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'init_quality', 'double precision', 'Column init_quality should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'source_type', 'varchar(18)', 'Column source_type should be varchar(18)');
SELECT col_type_is('inp_dscenario_connec', 'source_quality', 'double precision', 'Column source_quality should be double precision');
SELECT col_type_is('inp_dscenario_connec', 'source_pattern_id', 'varchar(16)', 'Column source_pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_dscenario_connec', 'Table inp_dscenario_connec should have foreign keys');
SELECT fk_ok('inp_dscenario_connec', 'connec_id', 'inp_connec', 'connec_id', 'FK connec_id should reference inp_connec.connec_id');
SELECT fk_ok('inp_dscenario_connec', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');

-- Check triggers
SELECT has_trigger('inp_dscenario_connec', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_dscenario_connec', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_connec', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_connec', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
