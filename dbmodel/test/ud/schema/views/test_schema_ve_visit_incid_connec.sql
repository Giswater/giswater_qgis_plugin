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

-- Check view ve_visit_incid_connec
SELECT has_view('ve_visit_incid_connec'::name, 'View ve_visit_incid_connec should exist');

-- Check view columns
SELECT columns_are(
    've_visit_incid_connec',
    ARRAY[
        'id', 'visit_id', 'connec_id', 'visitcat_id', 'ext_code', 'startdate',
        'enddate', 'user_name', 'webclient_id', 'expl_id', 'the_geom', 'descript',
        'is_done', 'class_id', 'status', 'incident_type', 'incident_comment', 'photo'
    ],
    'View ve_visit_incid_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_visit_incid_connec', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ve_visit_incid_connec', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('ve_visit_incid_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('ve_visit_incid_connec', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('ve_visit_incid_connec', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('ve_visit_incid_connec', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_incid_connec', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_incid_connec', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('ve_visit_incid_connec', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('ve_visit_incid_connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_visit_incid_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_visit_incid_connec', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_visit_incid_connec', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('ve_visit_incid_connec', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('ve_visit_incid_connec', 'status', 'int4', 'Column status should be int4');
SELECT col_type_is('ve_visit_incid_connec', 'incident_type', 'text', 'Column incident_type should be text');
SELECT col_type_is('ve_visit_incid_connec', 'incident_comment', 'text', 'Column incident_comment should be text');
SELECT col_type_is('ve_visit_incid_connec', 'photo', 'bool', 'Column photo should be bool');

SELECT * FROM finish();

ROLLBACK;
