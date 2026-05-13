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

-- Check view ve_review_arc
SELECT has_view('ve_review_arc'::name, 'View ve_review_arc should exist');

-- Check view columns
SELECT columns_are(
    've_review_arc',
    ARRAY[
        'arc_id', 'node_1', 'y1', 'node_2', 'y2', 'arc_type',
        'matcat_id', 'arccat_id', 'annotation', 'observ', 'review_obs', 'expl_id',
        'the_geom', 'field_date', 'field_checked', 'is_validated'
    ],
    'View ve_review_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_review_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('ve_review_arc', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('ve_review_arc', 'y1', 'numeric(12,3)', 'Column y1 should be numeric(12,3)');
SELECT col_type_is('ve_review_arc', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('ve_review_arc', 'y2', 'numeric(12,3)', 'Column y2 should be numeric(12,3)');
SELECT col_type_is('ve_review_arc', 'arc_type', 'varchar(18)', 'Column arc_type should be varchar(18)');
SELECT col_type_is('ve_review_arc', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('ve_review_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('ve_review_arc', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('ve_review_arc', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_review_arc', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('ve_review_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_review_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('ve_review_arc', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');
SELECT col_type_is('ve_review_arc', 'field_checked', 'bool', 'Column field_checked should be bool');
SELECT col_type_is('ve_review_arc', 'is_validated', 'int4', 'Column is_validated should be int4');

SELECT * FROM finish();

ROLLBACK;
