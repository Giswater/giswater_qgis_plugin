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

-- Check view v_ui_om_visit
SELECT has_view('v_ui_om_visit'::name, 'View v_ui_om_visit should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visit',
    ARRAY[
        'id', 'visit_catalog', 'ext_code', 'startdate', 'enddate', 'user_name',
        'webclient_id', 'exploitation', 'the_geom', 'descript', 'is_done', 'visit_type'
    ],
    'View v_ui_om_visit should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_om_visit', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('v_ui_om_visit', 'visit_catalog', 'varchar(30)', 'Column visit_catalog should be varchar(30)');
SELECT col_type_is('v_ui_om_visit', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('v_ui_om_visit', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_om_visit', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_om_visit', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_om_visit', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('v_ui_om_visit', 'exploitation', 'varchar(100)', 'Column exploitation should be varchar(100)');
SELECT col_type_is('v_ui_om_visit', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_ui_om_visit', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_ui_om_visit', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('v_ui_om_visit', 'visit_type', 'int4', 'Column visit_type should be int4');

SELECT * FROM finish();

ROLLBACK;
