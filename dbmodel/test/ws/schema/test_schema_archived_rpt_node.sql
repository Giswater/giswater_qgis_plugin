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

-- Check table archived_rpt_node
SELECT has_table('archived_rpt_node'::name, 'Table archived_rpt_node should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'demand', 'head', 'press', 'other', 'time', 'quality'
    ],
    'Table archived_rpt_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_node', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_node', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('archived_rpt_node', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('archived_rpt_node', 'demand', 'numeric', 'Column demand should be numeric');
SELECT col_type_is('archived_rpt_node', 'head', 'numeric', 'Column head should be numeric');
SELECT col_type_is('archived_rpt_node', 'press', 'numeric', 'Column press should be numeric');
SELECT col_type_is('archived_rpt_node', 'other', 'character varying(100)', 'Column other should be varchar(100)');
SELECT col_type_is('archived_rpt_node', 'time', 'character varying(100)', 'Column time should be varchar(100)');
SELECT col_type_is('archived_rpt_node', 'quality', 'numeric(12,4)', 'Column quality should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('archived_rpt_node', 'Table archived_rpt_node should have foreign keys');
SELECT fk_ok('archived_rpt_node', ARRAY['result_id'], 'rpt_cat_result', ARRAY['result_id'], 'Table should have foreign key from result_id to rpt_cat_result.result_id');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_rpt_node_id_seq1', 'Sequence archived_rpt_node_id_seq should exist'); -- TODO: rename sequence without the number and change the test

SELECT * FROM finish();

ROLLBACK;
