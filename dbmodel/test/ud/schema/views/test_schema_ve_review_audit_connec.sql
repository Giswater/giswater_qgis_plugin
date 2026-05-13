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

-- Check view ve_review_audit_connec
SELECT has_view('ve_review_audit_connec'::name, 'View ve_review_audit_connec should exist');

-- Check view columns
SELECT columns_are(
    've_review_audit_connec',
    ARRAY[
        'id', 'connec_id', 'old_y1', 'new_y1', 'old_y2', 'new_y2',
        'old_connec_type', 'new_connec_type', 'old_matcat_id', 'new_matcat_id', 'old_connecat_id', 'new_connecat_id',
        'old_annotation', 'new_annotation', 'old_observ', 'new_observ', 'review_obs', 'expl_id',
        'the_geom', 'review_status_id', 'field_date', 'field_user', 'is_validated'
    ],
    'View ve_review_audit_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_review_audit_connec', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_review_audit_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('ve_review_audit_connec', 'old_y1', 'numeric(12,3)', 'Column old_y1 should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_connec', 'new_y1', 'numeric(12,3)', 'Column new_y1 should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_connec', 'old_y2', 'numeric(12,3)', 'Column old_y2 should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_connec', 'new_y2', 'numeric(12,3)', 'Column new_y2 should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_connec', 'old_connec_type', 'varchar(18)', 'Column old_connec_type should be varchar(18)');
SELECT col_type_is('ve_review_audit_connec', 'new_connec_type', 'varchar(18)', 'Column new_connec_type should be varchar(18)');
SELECT col_type_is('ve_review_audit_connec', 'old_matcat_id', 'varchar(30)', 'Column old_matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_connec', 'new_matcat_id', 'varchar(30)', 'Column new_matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_connec', 'old_connecat_id', 'varchar(30)', 'Column old_connecat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_connec', 'new_connecat_id', 'varchar(30)', 'Column new_connecat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_connec', 'old_annotation', 'text', 'Column old_annotation should be text');
SELECT col_type_is('ve_review_audit_connec', 'new_annotation', 'text', 'Column new_annotation should be text');
SELECT col_type_is('ve_review_audit_connec', 'old_observ', 'text', 'Column old_observ should be text');
SELECT col_type_is('ve_review_audit_connec', 'new_observ', 'text', 'Column new_observ should be text');
SELECT col_type_is('ve_review_audit_connec', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('ve_review_audit_connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_review_audit_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_review_audit_connec', 'review_status_id', 'int2', 'Column review_status_id should be int2');
SELECT col_type_is('ve_review_audit_connec', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('ve_review_audit_connec', 'field_user', 'text', 'Column field_user should be text');
SELECT col_type_is('ve_review_audit_connec', 'is_validated', 'int4', 'Column is_validated should be int4');

SELECT * FROM finish();

ROLLBACK;
