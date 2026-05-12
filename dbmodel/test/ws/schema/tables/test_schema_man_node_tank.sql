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

-- Check table man_node_tank
SELECT has_table('man_node_tank'::name, 'Table man_node_tank should exist');

-- Check columns
SELECT columns_are(
    'man_node_tank',
    ARRAY[
        'node_id', 'tank_param_1', 'tank_param_2'
    ],
    'Table man_node_tank should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_node_tank', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_node_tank', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_node_tank', 'tank_param_1', 'integer', 'Column tank_param_1 should be integer');
SELECT col_type_is('man_node_tank', 'tank_param_2', 'date', 'Column tank_param_2 should be date');

-- Check not null constraints
SELECT col_not_null('man_node_tank', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_node_tank', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check indexes
SELECT has_index('man_node_tank', 'man_node_tank_node_id_index', 'Should have index on node_id');

SELECT * FROM finish();

ROLLBACK;