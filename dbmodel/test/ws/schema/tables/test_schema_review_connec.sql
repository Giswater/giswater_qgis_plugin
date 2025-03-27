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

-- Check table review_connec
SELECT has_table('review_connec'::name, 'Table review_connec should exist');

-- Check columns
SELECT columns_are(
    'review_connec',
    ARRAY[
        'connec_id', 'conneccat_id', 'annotation', 'observ', 'review_obs', 'expl_id', 
        'the_geom', 'field_checked', 'is_validated', 'field_date'
    ],
    'Table review_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('review_connec', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('review_connec', 'connec_id', 'character varying(16)', 'Column connec_id should be character varying(16)');
SELECT col_type_is('review_connec', 'conneccat_id', 'character varying(30)', 'Column conneccat_id should be character varying(30)');
SELECT col_type_is('review_connec', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('review_connec', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('review_connec', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_connec', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('review_connec', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('review_connec', 'field_checked', 'boolean', 'Column field_checked should be boolean');
SELECT col_type_is('review_connec', 'is_validated', 'integer', 'Column is_validated should be integer');
SELECT col_type_is('review_connec', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');

-- Check constraints
SELECT col_not_null('review_connec', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 