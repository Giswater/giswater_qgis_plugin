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
SELECT has_table('review_audit_node'::name, 'Table review_audit_node should exist');

-- Check columns
SELECT columns_are(
    'review_audit_node',
    ARRAY[
        'id', 'node_id', 'old_top_elev', 'new_top_elev', 'old_depth', 'new_depth',
        'old_nodecat_id', 'new_nodecat_id', 'old_annotation', 'new_annotation', 'old_observ', 'new_observ',
        'review_obs', 'expl_id', 'the_geom', 'review_status_id', 'field_date', 'field_user',
        'is_validated'
    ],
    'Table review_audit_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('review_audit_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('review_audit_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('review_audit_node', 'old_top_elev', 'numeric(12,3)', 'Column old_top_elev should be numeric(12,3)');
SELECT col_type_is('review_audit_node', 'new_top_elev', 'numeric(12,3)', 'Column new_top_elev should be numeric(12,3)');
SELECT col_type_is('review_audit_node', 'old_depth', 'numeric(12,3)', 'Column old_depth should be numeric(12,3)');
SELECT col_type_is('review_audit_node', 'new_depth', 'numeric(12,3)', 'Column new_depth should be numeric(12,3)');
SELECT col_type_is('review_audit_node', 'old_nodecat_id', 'varchar(30)', 'Column old_nodecat_id should be varchar(30)');
SELECT col_type_is('review_audit_node', 'new_nodecat_id', 'varchar(30)', 'Column new_nodecat_id should be varchar(30)');
SELECT col_type_is('review_audit_node', 'old_annotation', 'text', 'Column old_annotation should be text');
SELECT col_type_is('review_audit_node', 'new_annotation', 'text', 'Column new_annotation should be text');
SELECT col_type_is('review_audit_node', 'old_observ', 'text', 'Column old_observ should be text');
SELECT col_type_is('review_audit_node', 'new_observ', 'text', 'Column new_observ should be text');
SELECT col_type_is('review_audit_node', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_audit_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('review_audit_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('review_audit_node', 'review_status_id', 'int2', 'Column review_status_id should be int2');
SELECT col_type_is('review_audit_node', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('review_audit_node', 'field_user', 'text', 'Column field_user should be text');
SELECT col_type_is('review_audit_node', 'is_validated', 'int4', 'Column is_validated should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
