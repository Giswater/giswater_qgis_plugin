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

-- Check view v_ui_node_x_relations
SELECT has_view('v_ui_node_x_relations'::name, 'View v_ui_node_x_relations should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_node_x_relations',
    ARRAY[
        'rid', 'node_id', 'node_type', 'nodecat_id', 'child_id', 'code',
        'sys_type', 'sys_table_id'
    ],
    'View v_ui_node_x_relations should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_node_x_relations', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_ui_node_x_relations', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_ui_node_x_relations', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_ui_node_x_relations', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_ui_node_x_relations', 'child_id', 'int4', 'Column child_id should be int4');
SELECT col_type_is('v_ui_node_x_relations', 'code', 'text', 'Column code should be text');
SELECT col_type_is('v_ui_node_x_relations', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('v_ui_node_x_relations', 'sys_table_id', 'text', 'Column sys_table_id should be text');

SELECT * FROM finish();

ROLLBACK;
