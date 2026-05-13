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

-- Check view v_ui_node_x_connection_upstream
SELECT has_view('v_ui_node_x_connection_upstream'::name, 'View v_ui_node_x_connection_upstream should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_node_x_connection_upstream',
    ARRAY[
        'rid', 'node_id', 'feature_id', 'feature_code', 'featurecat_id', 'arccat_id',
        'depth', 'length', 'upstream_id', 'upstream_code', 'upstream_type', 'upstream_depth',
        'sys_type', 'x', 'y', 'descript', 'state', 'sys_table_id'
    ],
    'View v_ui_node_x_connection_upstream should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_node_x_connection_upstream', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'feature_code', 'text', 'Column feature_code should be text');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'featurecat_id', 'text', 'Column featurecat_id should be text');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'arccat_id', 'varchar', 'Column arccat_id should be varchar');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'depth', 'numeric', 'Column depth should be numeric');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'upstream_id', 'int4', 'Column upstream_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'upstream_code', 'text', 'Column upstream_code should be text');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'upstream_type', 'varchar', 'Column upstream_type should be varchar');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'upstream_depth', 'numeric', 'Column upstream_depth should be numeric');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'x', 'float8', 'Column x should be float8');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'y', 'float8', 'Column y should be float8');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'state', 'varchar(30)', 'Column state should be varchar(30)');
SELECT col_type_is('v_ui_node_x_connection_upstream', 'sys_table_id', 'text', 'Column sys_table_id should be text');

SELECT * FROM finish();

ROLLBACK;
