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

-- Check view ve_review_audit_gully
SELECT has_view('ve_review_audit_gully'::name, 'View ve_review_audit_gully should exist');

-- Check view columns
SELECT columns_are(
    've_review_audit_gully',
    ARRAY[
        'id', 'gully_id', 'old_top_elev', 'new_top_elev', 'old_ymax', 'new_ymax',
        'old_sandbox', 'new_sandbox', 'old_matcat_id', 'new_matcat_id', 'old_gully_type', 'new_gully_type',
        'old_gratecat_id', 'new_gratecat_id', 'old_units', 'new_units', 'old_groove', 'new_groove',
        'old_siphon', 'new_siphon', 'old_connec_arccat_id', 'new_connec_arccat_id', 'old_annotation', 'new_annotation',
        'old_observ', 'new_observ', 'review_obs', 'expl_id', 'the_geom', 'review_status_id',
        'field_date', 'field_user', 'is_validated'
    ],
    'View ve_review_audit_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_review_audit_gully', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_review_audit_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('ve_review_audit_gully', 'old_top_elev', 'numeric(12,3)', 'Column old_top_elev should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'new_top_elev', 'numeric(12,3)', 'Column new_top_elev should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'old_ymax', 'numeric(12,3)', 'Column old_ymax should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'new_ymax', 'numeric(12,3)', 'Column new_ymax should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'old_sandbox', 'numeric(12,3)', 'Column old_sandbox should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'new_sandbox', 'numeric(12,3)', 'Column new_sandbox should be numeric(12,3)');
SELECT col_type_is('ve_review_audit_gully', 'old_matcat_id', 'varchar(30)', 'Column old_matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'new_matcat_id', 'varchar(30)', 'Column new_matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'old_gully_type', 'varchar(30)', 'Column old_gully_type should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'new_gully_type', 'varchar(30)', 'Column new_gully_type should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'old_gratecat_id', 'varchar(30)', 'Column old_gratecat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'new_gratecat_id', 'varchar(30)', 'Column new_gratecat_id should be varchar(30)');
SELECT col_type_is('ve_review_audit_gully', 'old_units', 'int2', 'Column old_units should be int2');
SELECT col_type_is('ve_review_audit_gully', 'new_units', 'int2', 'Column new_units should be int2');
SELECT col_type_is('ve_review_audit_gully', 'old_groove', 'bool', 'Column old_groove should be bool');
SELECT col_type_is('ve_review_audit_gully', 'new_groove', 'bool', 'Column new_groove should be bool');
SELECT col_type_is('ve_review_audit_gully', 'old_siphon', 'bool', 'Column old_siphon should be bool');
SELECT col_type_is('ve_review_audit_gully', 'new_siphon', 'bool', 'Column new_siphon should be bool');
SELECT col_type_is('ve_review_audit_gully', 'old_connec_arccat_id', 'varchar(18)', 'Column old_connec_arccat_id should be varchar(18)');
SELECT col_type_is('ve_review_audit_gully', 'new_connec_arccat_id', 'varchar(18)', 'Column new_connec_arccat_id should be varchar(18)');
SELECT col_type_is('ve_review_audit_gully', 'old_annotation', 'text', 'Column old_annotation should be text');
SELECT col_type_is('ve_review_audit_gully', 'new_annotation', 'text', 'Column new_annotation should be text');
SELECT col_type_is('ve_review_audit_gully', 'old_observ', 'text', 'Column old_observ should be text');
SELECT col_type_is('ve_review_audit_gully', 'new_observ', 'text', 'Column new_observ should be text');
SELECT col_type_is('ve_review_audit_gully', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('ve_review_audit_gully', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_review_audit_gully', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_review_audit_gully', 'review_status_id', 'int2', 'Column review_status_id should be int2');
SELECT col_type_is('ve_review_audit_gully', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('ve_review_audit_gully', 'field_user', 'text', 'Column field_user should be text');
SELECT col_type_is('ve_review_audit_gully', 'is_validated', 'int4', 'Column is_validated should be int4');

SELECT * FROM finish();

ROLLBACK;
