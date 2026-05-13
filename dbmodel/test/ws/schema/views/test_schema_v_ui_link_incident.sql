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

-- Check view v_ui_link_incident
SELECT has_view('v_ui_link_incident'::name, 'View v_ui_link_incident should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_link_incident',
    ARRAY[
        'visit_id', 'link_id', 'Start date', 'Process rejection date', 'End date', 'User',
        'Visit class', 'Status', 'Description', 'Address', 'Observations', 'Reassignment',
        'Is done', 'Generic incident', 'Photo', 'Geom'
    ],
    'View v_ui_link_incident should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_link_incident', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('v_ui_link_incident', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('v_ui_link_incident', 'Start date', 'timestamp(6) without time zone', 'Column Start date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_link_incident', 'Process rejection date', 'timestamp without time zone', 'Column Process rejection date should be timestamp without time zone');
SELECT col_type_is('v_ui_link_incident', 'End date', 'timestamp(6) without time zone', 'Column End date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_link_incident', 'User', 'varchar(50)', 'Column User should be varchar(50)');
SELECT col_type_is('v_ui_link_incident', 'Visit class', 'varchar(30)', 'Column Visit class should be varchar(30)');
SELECT col_type_is('v_ui_link_incident', 'Status', 'text', 'Column Status should be text');
SELECT col_type_is('v_ui_link_incident', 'Description', 'text', 'Column Description should be text');
SELECT col_type_is('v_ui_link_incident', 'Address', 'text', 'Column Address should be text');
SELECT col_type_is('v_ui_link_incident', 'Observations', 'text', 'Column Observations should be text');
SELECT col_type_is('v_ui_link_incident', 'Reassignment', 'varchar(50)', 'Column Reassignment should be varchar(50)');
SELECT col_type_is('v_ui_link_incident', 'Is done', 'bool', 'Column Is done should be bool');
SELECT col_type_is('v_ui_link_incident', 'Generic incident', 'text', 'Column Generic incident should be text');
SELECT col_type_is('v_ui_link_incident', 'Photo', 'text', 'Column Photo should be text');
SELECT col_type_is('v_ui_link_incident', 'Geom', 'geometry(linestring, SRID_VALUE)', 'Column Geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
