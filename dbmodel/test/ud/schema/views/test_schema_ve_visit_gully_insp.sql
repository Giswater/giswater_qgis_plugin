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

-- Check view ve_visit_gully_insp
SELECT has_view('ve_visit_gully_insp'::name, 'View ve_visit_gully_insp should exist');

-- Check view columns
SELECT columns_are(
    've_visit_gully_insp',
    ARRAY[
        'id', 'visit_id', 'gully_id', 'visitcat_id', 'ext_code', 'startdate',
        'enddate', 'user_name', 'webclient_id', 'expl_id', 'the_geom', 'descript',
        'is_done', 'class_id', 'status', 'sediments_gully', 'defect_gully', 'clean_gully',
        'smells_gully', 'insp_observ', 'photo'
    ],
    'View ve_visit_gully_insp should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_visit_gully_insp', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ve_visit_gully_insp', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('ve_visit_gully_insp', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('ve_visit_gully_insp', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('ve_visit_gully_insp', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('ve_visit_gully_insp', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_gully_insp', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_gully_insp', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('ve_visit_gully_insp', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('ve_visit_gully_insp', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_visit_gully_insp', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_visit_gully_insp', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_visit_gully_insp', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('ve_visit_gully_insp', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('ve_visit_gully_insp', 'status', 'int4', 'Column status should be int4');
SELECT col_type_is('ve_visit_gully_insp', 'sediments_gully', 'text', 'Column sediments_gully should be text');
SELECT col_type_is('ve_visit_gully_insp', 'defect_gully', 'text', 'Column defect_gully should be text');
SELECT col_type_is('ve_visit_gully_insp', 'clean_gully', 'text', 'Column clean_gully should be text');
SELECT col_type_is('ve_visit_gully_insp', 'smells_gully', 'bool', 'Column smells_gully should be bool');
SELECT col_type_is('ve_visit_gully_insp', 'insp_observ', 'text', 'Column insp_observ should be text');
SELECT col_type_is('ve_visit_gully_insp', 'photo', 'bool', 'Column photo should be bool');

SELECT * FROM finish();

ROLLBACK;
