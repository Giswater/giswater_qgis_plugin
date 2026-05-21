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
SELECT has_table('plan_psector_x_node'::name, 'Table plan_psector_x_node should exist');

-- Check columns
SELECT columns_are(
    'plan_psector_x_node',
    ARRAY[
        'id', 'node_id', 'psector_id', 'state', 'doable', 'descript',
        'addparam', 'insert_tstamp', 'insert_user', 'archived'
    ],
    'Table plan_psector_x_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_psector_x_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('plan_psector_x_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('plan_psector_x_node', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('plan_psector_x_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('plan_psector_x_node', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('plan_psector_x_node', 'descript', 'varchar(254)', 'Column descript should be varchar(254)');
SELECT col_type_is('plan_psector_x_node', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('plan_psector_x_node', 'insert_tstamp', 'timestamp without time zone', 'Column insert_tstamp should be timestamp without time zone');
SELECT col_type_is('plan_psector_x_node', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('plan_psector_x_node', 'archived', 'bool', 'Column archived should be bool');

-- Check foreign keys
SELECT has_fk('plan_psector_x_node', 'Table plan_psector_x_node should have foreign keys');

SELECT fk_ok('plan_psector_x_node', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id → plan_psector.psector_id');
SELECT fk_ok('plan_psector_x_node', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
