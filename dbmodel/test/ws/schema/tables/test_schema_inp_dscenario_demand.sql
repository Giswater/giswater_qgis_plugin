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

-- Check table inp_dscenario_demand
SELECT has_table('inp_dscenario_demand'::name, 'Table inp_dscenario_demand should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_demand',
    ARRAY[
        'dscenario_id', 'id', 'feature_id', 'feature_type', 'demand', 'pattern_id', 'demand_type', 'source'
    ],
    'Table inp_dscenario_demand should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_demand', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_demand', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_demand', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_dscenario_demand', 'feature_id', 'varchar(16)', 'Column feature_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_demand', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('inp_dscenario_demand', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_dscenario_demand', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_dscenario_demand', 'demand_type', 'varchar(18)', 'Column demand_type should be varchar(18)');
SELECT col_type_is('inp_dscenario_demand', 'source', 'text', 'Column source should be text');

-- Check foreign keys
SELECT has_fk('inp_dscenario_demand', 'Table inp_dscenario_demand should have foreign keys');
SELECT fk_ok('inp_dscenario_demand', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');
SELECT fk_ok('inp_dscenario_demand', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');
SELECT fk_ok('inp_dscenario_demand', 'feature_type', 'sys_feature_type', 'id', 'FK feature_type should reference sys_feature_type.id');

-- Check triggers
SELECT has_trigger('inp_dscenario_demand', 'gw_trg_dscenario_demand_feature', 'Trigger gw_trg_dscenario_demand_feature should exist');
SELECT has_trigger('inp_dscenario_demand', 'gw_trg_typevalue_fk', 'Trigger gw_trg_typevalue_fk should exist');

-- Check rules

-- Check sequences

-- Check indexes
SELECT has_index('inp_dscenario_demand', 'idx_inp_dscenario_demand_dscenario_id', ARRAY['dscenario_id'], 'Should have index on dscenario_id');
SELECT has_index('inp_dscenario_demand', 'idx_inp_dscenario_demand_source', ARRAY['source'], 'Should have index on source');

-- Check constraints
SELECT col_not_null('inp_dscenario_demand', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_demand', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('inp_dscenario_demand', 'feature_id', 'Column feature_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;