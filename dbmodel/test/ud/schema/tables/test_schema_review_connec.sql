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
SELECT has_table('review_connec'::name, 'Table review_connec should exist');

-- Check columns
SELECT columns_are(
    'review_connec',
    ARRAY[
        'connec_id', 'y1', 'y2', 'connec_type', 'matcat_id', 'conneccat_id',
        'annotation', 'observ', 'review_obs', 'expl_id', 'the_geom', 'field_checked',
        'is_validated', 'field_date'
    ],
    'Table review_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('review_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('review_connec', 'y1', 'numeric(12,3)', 'Column y1 should be numeric(12,3)');
SELECT col_type_is('review_connec', 'y2', 'numeric(12,3)', 'Column y2 should be numeric(12,3)');
SELECT col_type_is('review_connec', 'connec_type', 'varchar(18)', 'Column connec_type should be varchar(18)');
SELECT col_type_is('review_connec', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('review_connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('review_connec', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('review_connec', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('review_connec', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('review_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('review_connec', 'field_checked', 'bool', 'Column field_checked should be bool');
SELECT col_type_is('review_connec', 'is_validated', 'int4', 'Column is_validated should be int4');
SELECT col_type_is('review_connec', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');

-- Finish
SELECT * FROM finish();

ROLLBACK;
