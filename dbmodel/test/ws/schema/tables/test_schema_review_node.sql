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

-- Check table review_node
SELECT has_table('review_node'::name, 'Table review_node should exist');

-- Check columns
SELECT columns_are(
    'review_node',
    ARRAY[
        'node_id', 'top_elev', 'depth', 'nodecat_id', 'annotation', 'observ', 'review_obs',
        'expl_id', 'the_geom', 'field_checked', 'is_validated', 'field_date'
    ],
    'Table review_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('review_node', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('review_node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('review_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('review_node', 'depth', 'numeric(12,3)', 'Column depth should be numeric(12,3)');
SELECT col_type_is('review_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('review_node', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('review_node', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('review_node', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('review_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('review_node', 'field_checked', 'boolean', 'Column field_checked should be boolean');
SELECT col_type_is('review_node', 'is_validated', 'integer', 'Column is_validated should be integer');
SELECT col_type_is('review_node', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');

-- Check constraints
SELECT col_not_null('review_node', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;