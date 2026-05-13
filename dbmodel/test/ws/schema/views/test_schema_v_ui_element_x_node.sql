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

-- Check view v_ui_element_x_node
SELECT has_view('v_ui_element_x_node'::name, 'View v_ui_element_x_node should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_element_x_node',
    ARRAY[
        'node_id', 'element_id', 'feature_class', 'element_type', 'elementcat_id', 'descript',
        'num_elements', 'epa_type', 'state', 'state_type', 'observ', 'comment',
        'location_type', 'builtdate', 'enddate', 'link', 'publish', 'inventory',
        'node_uuid'
    ],
    'View v_ui_element_x_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_element_x_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_ui_element_x_node', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('v_ui_element_x_node', 'feature_class', 'varchar(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('v_ui_element_x_node', 'element_type', 'varchar(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_node', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('v_ui_element_x_node', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('v_ui_element_x_node', 'num_elements', 'int4', 'Column num_elements should be int4');
SELECT col_type_is('v_ui_element_x_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_ui_element_x_node', 'state', 'varchar(30)', 'Column state should be varchar(30)');
SELECT col_type_is('v_ui_element_x_node', 'state_type', 'varchar(30)', 'Column state_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_node', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('v_ui_element_x_node', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('v_ui_element_x_node', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('v_ui_element_x_node', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('v_ui_element_x_node', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('v_ui_element_x_node', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('v_ui_element_x_node', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('v_ui_element_x_node', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('v_ui_element_x_node', 'node_uuid', 'uuid', 'Column node_uuid should be uuid');

SELECT * FROM finish();

ROLLBACK;
