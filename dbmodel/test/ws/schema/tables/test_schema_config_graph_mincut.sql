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

-- Check table config_graph_mincut
SELECT has_table('config_graph_mincut'::name, 'Table config_graph_mincut should exist');

-- Check columns
SELECT columns_are(
    'config_graph_mincut',
    ARRAY[
        'node_id', 'parameters', 'active'
    ],
    'Table config_graph_mincut should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_graph_mincut', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('config_graph_mincut', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('config_graph_mincut', 'parameters', 'json', 'Column parameters should be json');
SELECT col_type_is('config_graph_mincut', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('config_graph_mincut', 'Table config_graph_mincut should have foreign keys');
SELECT fk_ok(
    'config_graph_mincut',
    'node_id',
    'node',
    'node_id'
);

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_graph_mincut', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_has_default('config_graph_mincut', 'active', 'Column active should have default value');

SELECT * FROM finish();

ROLLBACK;
