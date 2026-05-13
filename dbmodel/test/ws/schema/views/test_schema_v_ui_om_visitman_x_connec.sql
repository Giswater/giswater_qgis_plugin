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

-- Check view v_ui_om_visitman_x_connec
SELECT has_view('v_ui_om_visitman_x_connec'::name, 'View v_ui_om_visitman_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visitman_x_connec',
    ARRAY[
        'visit_id', 'code', 'visitcat_name', 'connec_id', 'visit_start', 'visit_end',
        'user_name', 'is_done', 'feature_type', 'form_type'
    ],
    'View v_ui_om_visitman_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_om_visitman_x_connec', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'code', 'varchar(30)', 'Column code should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'visitcat_name', 'varchar(30)', 'Column visitcat_name should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'visit_start', 'timestamp without time zone', 'Column visit_start should be timestamp without time zone');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'visit_end', 'timestamp without time zone', 'Column visit_end should be timestamp without time zone');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'feature_type', 'varchar(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_connec', 'form_type', 'varchar(30)', 'Column form_type should be varchar(30)');

SELECT * FROM finish();

ROLLBACK;
