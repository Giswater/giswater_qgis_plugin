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

-- Check table
SELECT has_table('man_node_shutoff_valve'::name, 'Table man_node_shutoff_valve should exist');

-- Check columns
SELECT columns_are(
    'man_node_shutoff_valve',
    ARRAY[
        'node_id', 'shtvalve_param_1', 'shtvalve_param_2'
    ],
    'Table man_node_shutoff_valve should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_node_shutoff_valve', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_node_shutoff_valve', 'shtvalve_param_1', 'text', 'Column shtvalve_param_1 should be text');
SELECT col_type_is('man_node_shutoff_valve', 'shtvalve_param_2', 'text', 'Column shtvalve_param_2 should be text');

-- Check foreign keys
SELECT has_fk('man_node_shutoff_valve', 'Table man_node_shutoff_valve should have foreign keys');

SELECT fk_ok('man_node_shutoff_valve', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
