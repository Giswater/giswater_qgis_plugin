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

-- Check view v_ui_om_visit_x_connec
SELECT has_view('v_ui_om_visit_x_connec'::name, 'View v_ui_om_visit_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visit_x_connec',
    ARRAY[
        'event_id', 'visit_id', 'code', 'visitcat_id', 'visit_start', 'visit_end',
        'user_name', 'is_done', 'tstamp', 'connec_id', 'parameter_id', 'parameter_type',
        'feature_type', 'form_type', 'descript', 'value', 'xcoord', 'ycoord',
        'compass', 'event_code', 'gallery', 'document', 'class_id', 'connec_uuid'
    ],
    'View v_ui_om_visit_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_om_visit_x_connec', 'event_id', 'int8', 'Column event_id should be int8');
SELECT col_type_is('v_ui_om_visit_x_connec', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_om_visit_x_connec', 'code', 'varchar(30)', 'Column code should be varchar(30)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('v_ui_om_visit_x_connec', 'visit_start', 'timestamp(6) without time zone', 'Column visit_start should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_om_visit_x_connec', 'visit_end', 'timestamp(6) without time zone', 'Column visit_end should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_om_visit_x_connec', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('v_ui_om_visit_x_connec', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('v_ui_om_visit_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_om_visit_x_connec', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'parameter_type', 'varchar(30)', 'Column parameter_type should be varchar(30)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'feature_type', 'varchar(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'form_type', 'varchar(30)', 'Column form_type should be varchar(30)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'value', 'text', 'Column value should be text');
SELECT col_type_is('v_ui_om_visit_x_connec', 'xcoord', 'float8', 'Column xcoord should be float8');
SELECT col_type_is('v_ui_om_visit_x_connec', 'ycoord', 'float8', 'Column ycoord should be float8');
SELECT col_type_is('v_ui_om_visit_x_connec', 'compass', 'float8', 'Column compass should be float8');
SELECT col_type_is('v_ui_om_visit_x_connec', 'event_code', 'varchar(16)', 'Column event_code should be varchar(16)');
SELECT col_type_is('v_ui_om_visit_x_connec', 'gallery', 'bool', 'Column gallery should be bool');
SELECT col_type_is('v_ui_om_visit_x_connec', 'document', 'bool', 'Column document should be bool');
SELECT col_type_is('v_ui_om_visit_x_connec', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('v_ui_om_visit_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

SELECT * FROM finish();

ROLLBACK;
