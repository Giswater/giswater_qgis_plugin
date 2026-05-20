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

-- Check view v_ui_element_x_connec
SELECT has_view('v_ui_element_x_connec'::name, 'View v_ui_element_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_element_x_connec',
    ARRAY[
        'connec_id', 'element_id', 'feature_class', 'element_type', 'elementcat_id', 'descript',
        'num_elements', 'epa_type', 'state', 'state_type', 'observ', 'comment',
        'location_type', 'builtdate', 'enddate', 'link', 'publish', 'inventory',
        'connec_uuid'
    ],
    'View v_ui_element_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_element_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_element_x_connec', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('v_ui_element_x_connec', 'feature_class', 'varchar(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('v_ui_element_x_connec', 'element_type', 'varchar(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_connec', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('v_ui_element_x_connec', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('v_ui_element_x_connec', 'num_elements', 'int4', 'Column num_elements should be int4');
SELECT col_type_is('v_ui_element_x_connec', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_ui_element_x_connec', 'state', 'varchar(30)', 'Column state should be varchar(30)');
SELECT col_type_is('v_ui_element_x_connec', 'state_type', 'varchar(30)', 'Column state_type should be varchar(30)');
SELECT col_type_is('v_ui_element_x_connec', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('v_ui_element_x_connec', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('v_ui_element_x_connec', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('v_ui_element_x_connec', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('v_ui_element_x_connec', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('v_ui_element_x_connec', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('v_ui_element_x_connec', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('v_ui_element_x_connec', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('v_ui_element_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

SELECT * FROM finish();

ROLLBACK;
