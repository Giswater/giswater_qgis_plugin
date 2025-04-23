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

-- Check table config_graph_checkvalve
SELECT has_table('config_graph_checkvalve'::name, 'Table config_graph_checkvalve should exist');

-- Check columns
SELECT columns_are(
    'config_graph_checkvalve',
    ARRAY[
        'node_id', 'to_arc', 'active'
    ],
    'Table config_graph_checkvalve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_graph_checkvalve', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('config_graph_checkvalve', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('config_graph_checkvalve', 'to_arc', 'varchar(16)', 'Column to_arc should be varchar(16)');
SELECT col_type_is('config_graph_checkvalve', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('config_graph_checkvalve', 'Table config_graph_checkvalve should have foreign keys');
SELECT fk_ok(
    'config_graph_checkvalve',
    'to_arc',
    'arc',
    'arc_id'
);

-- Check triggers

-- Check rules

-- Check sequences
-- Check constraints
SELECT col_not_null('config_graph_checkvalve', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('config_graph_checkvalve', 'to_arc', 'Column to_arc should be NOT NULL');
SELECT col_has_default('config_graph_checkvalve', 'active', 'Column active should have default value');

SELECT * FROM finish();

ROLLBACK;
