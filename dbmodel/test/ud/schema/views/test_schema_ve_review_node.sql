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

-- Check view ve_review_node
SELECT has_view('ve_review_node'::name, 'View ve_review_node should exist');

-- Check view columns
SELECT columns_are(
    've_review_node',
    ARRAY[
        'node_id', 'top_elev', 'ymax', 'node_type', 'matcat_id', 'nodecat_id',
        'annotation', 'observ', 'review_obs', 'expl_id', 'the_geom', 'field_date',
        'field_checked', 'is_validated'
    ],
    'View ve_review_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_review_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('ve_review_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('ve_review_node', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('ve_review_node', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('ve_review_node', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('ve_review_node', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('ve_review_node', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_review_node', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('ve_review_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_review_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_review_node', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('ve_review_node', 'field_checked', 'bool', 'Column field_checked should be bool');
SELECT col_type_is('ve_review_node', 'is_validated', 'int4', 'Column is_validated should be int4');

SELECT * FROM finish();

ROLLBACK;
