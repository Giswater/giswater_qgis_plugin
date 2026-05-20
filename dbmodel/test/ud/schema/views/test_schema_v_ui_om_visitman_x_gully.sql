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

-- Check view v_ui_om_visitman_x_gully
SELECT has_view('v_ui_om_visitman_x_gully'::name, 'View v_ui_om_visitman_x_gully should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visitman_x_gully',
    ARRAY[
        'visit_id', 'ext_code', 'visitcat_name', 'gully_id', 'visit_start', 'visit_end',
        'user_name', 'is_done', 'feature_type', 'form_type'
    ],
    'View v_ui_om_visitman_x_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_om_visitman_x_gully', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'visitcat_name', 'varchar(30)', 'Column visitcat_name should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'visit_start', 'timestamp without time zone', 'Column visit_start should be timestamp without time zone');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'visit_end', 'timestamp without time zone', 'Column visit_end should be timestamp without time zone');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'feature_type', 'varchar(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('v_ui_om_visitman_x_gully', 'form_type', 'varchar(30)', 'Column form_type should be varchar(30)');

SELECT * FROM finish();

ROLLBACK;
