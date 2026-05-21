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

-- Check view v_ui_visit_incid_connec
SELECT has_view('v_ui_visit_incid_connec'::name, 'View v_ui_visit_incid_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_visit_incid_connec',
    ARRAY[
        'visit_id', 'connec_id', 'Start date', 'End date', 'User', 'Visit class',
        'Status', 'Incident type', 'Comment', 'Photo', 'the_geom'
    ],
    'View v_ui_visit_incid_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_visit_incid_connec', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_visit_incid_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_visit_incid_connec', 'Start date', 'timestamp(6) without time zone', 'Column Start date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_visit_incid_connec', 'End date', 'timestamp(6) without time zone', 'Column End date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_visit_incid_connec', 'User', 'varchar(50)', 'Column User should be varchar(50)');
SELECT col_type_is('v_ui_visit_incid_connec', 'Visit class', 'varchar(30)', 'Column Visit class should be varchar(30)');
SELECT col_type_is('v_ui_visit_incid_connec', 'Status', 'text', 'Column Status should be text');
SELECT col_type_is('v_ui_visit_incid_connec', 'Incident type', 'text', 'Column Incident type should be text');
SELECT col_type_is('v_ui_visit_incid_connec', 'Comment', 'text', 'Column Comment should be text');
SELECT col_type_is('v_ui_visit_incid_connec', 'Photo', 'bool', 'Column Photo should be bool');
SELECT col_type_is('v_ui_visit_incid_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
