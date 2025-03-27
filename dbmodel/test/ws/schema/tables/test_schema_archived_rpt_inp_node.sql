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

-- Check table archived_rpt_inp_node
SELECT has_table('archived_rpt_inp_node'::name, 'Table archived_rpt_inp_node should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_inp_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'elev', 'node_type', 'nodecat_id', 'epa_type', 'sector_id', 'state',
        'state_type', 'annotation', 'demand', 'the_geom', 'expl_id', 'pattern_id', 'addparam', 'nodeparent', 'arcposition',
        'dma_id', 'presszone_id', 'dqa_id', 'minsector_id', 'age'
    ],
    'Table archived_rpt_inp_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_inp_node', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_inp_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('archived_rpt_inp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('archived_rpt_inp_node', 'node_type', 'character varying(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'epa_type', 'character varying(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('archived_rpt_inp_node', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('archived_rpt_inp_node', 'annotation', 'character varying(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('archived_rpt_inp_node', 'demand', 'double precision', 'Column demand should be double precision');
SELECT col_type_is('archived_rpt_inp_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_rpt_inp_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'pattern_id', 'character varying(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('archived_rpt_inp_node', 'nodeparent', 'character varying(16)', 'Column nodeparent should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'arcposition', 'smallint', 'Column arcposition should be smallint');
SELECT col_type_is('archived_rpt_inp_node', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'presszone_id', 'text', 'Column presszone_id should be text');
SELECT col_type_is('archived_rpt_inp_node', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('archived_rpt_inp_node', 'age', 'integer', 'Column age should be integer');

-- Check foreign keys
SELECT has_fk('archived_rpt_inp_node', 'Table archived_rpt_inp_node should have foreign keys');
SELECT fk_ok('archived_rpt_inp_node', ARRAY['result_id'], 'rpt_cat_result', ARRAY['result_id'], 'Table should have foreign key from result_id to rpt_cat_result.result_id');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_rpt_inp_node_id_seq', 'Sequence archived_rpt_inp_node_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
