/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table review_arc
SELECT has_table('review_arc'::name, 'Table review_arc should exist');

-- Check columns
SELECT columns_are(
    'review_arc',
    ARRAY[
        'arc_id', 'arccat_id', 'annotation', 'observ', 'review_obs', 'expl_id', 
        'the_geom', 'field_checked', 'is_validated', 'field_date'
    ],
    'Table review_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('review_arc', ARRAY['arc_id'], 'Column arc_id should be primary key');

-- Check column types
SELECT col_type_is('review_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('review_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be character varying(30)');
SELECT col_type_is('review_arc', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('review_arc', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('review_arc', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('review_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('review_arc', 'field_checked', 'boolean', 'Column field_checked should be boolean');
SELECT col_type_is('review_arc', 'is_validated', 'integer', 'Column is_validated should be integer');
SELECT col_type_is('review_arc', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');

-- Check constraints
SELECT col_not_null('review_arc', 'arc_id', 'Column arc_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 