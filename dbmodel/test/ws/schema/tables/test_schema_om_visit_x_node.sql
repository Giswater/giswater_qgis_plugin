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

-- Check table om_visit_x_node
SELECT has_table('om_visit_x_node'::name, 'Table om_visit_x_node should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_node',
    ARRAY[
        'id', 'visit_id', 'node_id', 'is_last', 'node_uuid'
    ],
    'Table om_visit_x_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_x_node', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_x_node', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit_x_node', 'visit_id', 'bigint', 'Column visit_id should be bigint');
SELECT col_type_is('om_visit_x_node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('om_visit_x_node', 'is_last', 'boolean', 'Column is_last should be boolean');
SELECT col_type_is('om_visit_x_node', 'node_uuid', 'uuid', 'Column node_uuid should be uuid');

-- Check default values
SELECT col_default_is('om_visit_x_node', 'is_last', 'true', 'Column is_last should default to true');

-- Check unique constraints
SELECT col_is_unique('om_visit_x_node', ARRAY['node_id', 'visit_id'], 'Columns node_id and visit_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_visit_x_node', 'Table om_visit_x_node should have foreign keys');
SELECT fk_ok('om_visit_x_node', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('om_visit_x_node', 'visit_id', 'om_visit', 'id', 'FK visit_id should reference om_visit.id');

-- Check constraints
SELECT col_not_null('om_visit_x_node', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit_x_node', 'visit_id', 'Column visit_id should be NOT NULL');
SELECT col_not_null('om_visit_x_node', 'node_id', 'Column node_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_visit_x_node', 'gw_trg_om_visit', 'Table should have gw_trg_om_visit trigger');

SELECT * FROM finish();

ROLLBACK;