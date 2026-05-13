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

-- Check view v_ui_visit_incid_link
SELECT has_view('v_ui_visit_incid_link'::name, 'View v_ui_visit_incid_link should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_visit_incid_link',
    ARRAY[
        'visit_id', 'link_id', 'Start date', 'End date', 'User', 'Visit class',
        'Status', 'Incident type', 'Comment', 'Photo'
    ],
    'View v_ui_visit_incid_link should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_visit_incid_link', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_visit_incid_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('v_ui_visit_incid_link', 'Start date', 'timestamp(6) without time zone', 'Column Start date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_visit_incid_link', 'End date', 'timestamp(6) without time zone', 'Column End date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_visit_incid_link', 'User', 'varchar(50)', 'Column User should be varchar(50)');
SELECT col_type_is('v_ui_visit_incid_link', 'Visit class', 'varchar(30)', 'Column Visit class should be varchar(30)');
SELECT col_type_is('v_ui_visit_incid_link', 'Status', 'text', 'Column Status should be text');
SELECT col_type_is('v_ui_visit_incid_link', 'Incident type', 'text', 'Column Incident type should be text');
SELECT col_type_is('v_ui_visit_incid_link', 'Comment', 'text', 'Column Comment should be text');
SELECT col_type_is('v_ui_visit_incid_link', 'Photo', 'bool', 'Column Photo should be bool');

SELECT * FROM finish();

ROLLBACK;
