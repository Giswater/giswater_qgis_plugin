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

-- Check view ve_visit_connec_incident
SELECT has_view('ve_visit_connec_incident'::name, 'View ve_visit_connec_incident should exist');

-- Check view columns
SELECT columns_are(
    've_visit_connec_incident',
    ARRAY[
        'id', 'visit_id', 'connec_id', 'visitcat_id', 'ext_code', 'startdate',
        'enddate', 'user_name', 'webclient_id', 'expl_id', 'the_geom', 'descript',
        'address', 'process_rejection_date', 'reassignment', 'comment', 'is_done', 'class_id',
        'status', 'generic_incident', 'photo'
    ],
    'View ve_visit_connec_incident should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_visit_connec_incident', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ve_visit_connec_incident', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('ve_visit_connec_incident', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('ve_visit_connec_incident', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('ve_visit_connec_incident', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('ve_visit_connec_incident', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_connec_incident', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_connec_incident', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('ve_visit_connec_incident', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('ve_visit_connec_incident', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_visit_connec_incident', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_visit_connec_incident', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_visit_connec_incident', 'address', 'text', 'Column address should be text');
SELECT col_type_is('ve_visit_connec_incident', 'process_rejection_date', 'timestamp without time zone', 'Column process_rejection_date should be timestamp without time zone');
SELECT col_type_is('ve_visit_connec_incident', 'reassignment', 'varchar(50)', 'Column reassignment should be varchar(50)');
SELECT col_type_is('ve_visit_connec_incident', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('ve_visit_connec_incident', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('ve_visit_connec_incident', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('ve_visit_connec_incident', 'status', 'int4', 'Column status should be int4');
SELECT col_type_is('ve_visit_connec_incident', 'generic_incident', 'text', 'Column generic_incident should be text');
SELECT col_type_is('ve_visit_connec_incident', 'photo', 'text', 'Column photo should be text');

SELECT * FROM finish();

ROLLBACK;
