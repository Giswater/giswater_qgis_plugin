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

-- Check view v_ui_element_x_link
SELECT has_view('v_ui_element_x_link'::name, 'View v_ui_element_x_link should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_element_x_link',
    ARRAY[
        'link_id', 'element_id', 'feature_class', 'element_type', 'elementcat_id', 'descript',
        'num_elements', 'epa_type', 'state', 'state_type', 'observ', 'comment',
        'location_type', 'builtdate', 'enddate', 'link', 'publish', 'inventory',
        'link_uuid'
    ],
    'View v_ui_element_x_link should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_element_x_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('v_ui_element_x_link', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('v_ui_element_x_link', 'feature_class', 'varchar(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('v_ui_element_x_link', 'element_type', 'varchar(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_link', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('v_ui_element_x_link', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('v_ui_element_x_link', 'num_elements', 'int4', 'Column num_elements should be int4');
SELECT col_type_is('v_ui_element_x_link', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_ui_element_x_link', 'state', 'varchar(30)', 'Column state should be varchar(30)');
SELECT col_type_is('v_ui_element_x_link', 'state_type', 'varchar(30)', 'Column state_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_link', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('v_ui_element_x_link', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('v_ui_element_x_link', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('v_ui_element_x_link', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('v_ui_element_x_link', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('v_ui_element_x_link', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('v_ui_element_x_link', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('v_ui_element_x_link', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('v_ui_element_x_link', 'link_uuid', 'uuid', 'Column link_uuid should be uuid');

SELECT * FROM finish();

ROLLBACK;
