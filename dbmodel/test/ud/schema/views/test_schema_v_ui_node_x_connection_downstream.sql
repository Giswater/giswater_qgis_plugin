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

-- Check view v_ui_node_x_connection_downstream
SELECT has_view('v_ui_node_x_connection_downstream'::name, 'View v_ui_node_x_connection_downstream should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_node_x_connection_downstream',
    ARRAY[
        'rid', 'node_id', 'feature_id', 'feature_code', 'featurecat_id', 'arccat_id',
        'depth', 'length', 'downstream_id', 'downstream_code', 'downstream_type', 'downstream_depth',
        'sys_type', 'x', 'y', 'descript', 'state', 'sys_table_id'
    ],
    'View v_ui_node_x_connection_downstream should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_node_x_connection_downstream', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'feature_code', 'text', 'Column feature_code should be text');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'featurecat_id', 'text', 'Column featurecat_id should be text');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'depth', 'numeric(12,3)', 'Column depth should be numeric(12,3)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'length', 'numeric(12,2)', 'Column length should be numeric(12,2)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'downstream_id', 'int4', 'Column downstream_id should be int4');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'downstream_code', 'text', 'Column downstream_code should be text');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'downstream_type', 'text', 'Column downstream_type should be text');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'downstream_depth', 'numeric(12,3)', 'Column downstream_depth should be numeric(12,3)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'x', 'float8', 'Column x should be float8');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'y', 'float8', 'Column y should be float8');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'state', 'varchar(30)', 'Column state should be varchar(30)');
SELECT col_type_is('v_ui_node_x_connection_downstream', 'sys_table_id', 'text', 'Column sys_table_id should be text');

SELECT * FROM finish();

ROLLBACK;
