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
SELECT has_table('om_visit_x_node'::name, 'Table om_visit_x_node should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_node',
    ARRAY[
        'id', 'visit_id', 'node_id', 'is_last', 'node_uuid'
    ],
    'Table om_visit_x_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_x_node', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_x_node', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_x_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('om_visit_x_node', 'is_last', 'bool', 'Column is_last should be bool');
SELECT col_type_is('om_visit_x_node', 'node_uuid', 'uuid', 'Column node_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('om_visit_x_node', 'Table om_visit_x_node should have foreign keys');

SELECT fk_ok('om_visit_x_node', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('om_visit_x_node', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
