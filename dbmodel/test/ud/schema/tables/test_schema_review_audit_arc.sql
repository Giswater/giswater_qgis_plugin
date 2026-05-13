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

-- Check table
SELECT has_table('review_audit_arc'::name, 'Table review_audit_arc should exist');

-- Check columns
SELECT columns_are(
    'review_audit_arc',
    ARRAY[
        'id', 'arc_id', 'old_y1', 'new_y1', 'old_y2', 'new_y2',
        'old_arc_type', 'new_arc_type', 'old_matcat_id', 'new_matcat_id', 'old_arccat_id', 'new_arccat_id',
        'old_annotation', 'new_annotation', 'old_observ', 'new_observ', 'review_obs', 'expl_id',
        'the_geom', 'review_status_id', 'field_date', 'field_user', 'is_validated'
    ],
    'Table review_audit_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('review_audit_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('review_audit_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('review_audit_arc', 'old_y1', 'float8', 'Column old_y1 should be float8');
SELECT col_type_is('review_audit_arc', 'new_y1', 'float8', 'Column new_y1 should be float8');
SELECT col_type_is('review_audit_arc', 'old_y2', 'float8', 'Column old_y2 should be float8');
SELECT col_type_is('review_audit_arc', 'new_y2', 'float8', 'Column new_y2 should be float8');
SELECT col_type_is('review_audit_arc', 'old_arc_type', 'varchar(18)', 'Column old_arc_type should be varchar(18)');
SELECT col_type_is('review_audit_arc', 'new_arc_type', 'varchar(18)', 'Column new_arc_type should be varchar(18)');
SELECT col_type_is('review_audit_arc', 'old_matcat_id', 'varchar(30)', 'Column old_matcat_id should be varchar(30)');
SELECT col_type_is('review_audit_arc', 'new_matcat_id', 'varchar(30)', 'Column new_matcat_id should be varchar(30)');
SELECT col_type_is('review_audit_arc', 'old_arccat_id', 'varchar(30)', 'Column old_arccat_id should be varchar(30)');
SELECT col_type_is('review_audit_arc', 'new_arccat_id', 'varchar(30)', 'Column new_arccat_id should be varchar(30)');
SELECT col_type_is('review_audit_arc', 'old_annotation', 'text', 'Column old_annotation should be text');
SELECT col_type_is('review_audit_arc', 'new_annotation', 'text', 'Column new_annotation should be text');
SELECT col_type_is('review_audit_arc', 'old_observ', 'text', 'Column old_observ should be text');
SELECT col_type_is('review_audit_arc', 'new_observ', 'text', 'Column new_observ should be text');
SELECT col_type_is('review_audit_arc', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_audit_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('review_audit_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('review_audit_arc', 'review_status_id', 'int2', 'Column review_status_id should be int2');
SELECT col_type_is('review_audit_arc', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('review_audit_arc', 'field_user', 'text', 'Column field_user should be text');
SELECT col_type_is('review_audit_arc', 'is_validated', 'int4', 'Column is_validated should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
