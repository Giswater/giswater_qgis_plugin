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

-- Check table man_node_hydrant
SELECT has_table('man_node_hydrant'::name, 'Table man_node_hydrant should exist');

-- Check columns
SELECT columns_are(
    'man_node_hydrant',
    ARRAY[
        'node_id', 'hydrant_param_1', 'hydrant_param_2'
    ],
    'Table man_node_hydrant should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_node_hydrant', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_node_hydrant', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_node_hydrant', 'hydrant_param_1', 'text', 'Column hydrant_param_1 should be text');
SELECT col_type_is('man_node_hydrant', 'hydrant_param_2', 'integer', 'Column hydrant_param_2 should be integer');

-- Check not null constraints
SELECT col_not_null('man_node_hydrant', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_node_hydrant', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check indexes
SELECT has_index('man_node_hydrant', 'man_node_hydrant_node_id_index', 'Should have index on node_id');

-- Check triggers
SELECT has_trigger('man_node_hydrant', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('man_node_hydrant', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

SELECT * FROM finish();

ROLLBACK;