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

-- Check table rpt_inp_node
SELECT has_table('rpt_inp_node'::name, 'Table rpt_inp_node should exist');

-- Check columns
SELECT columns_are(
    'rpt_inp_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'elev', 'node_type', 'nodecat_id', 'epa_type', 'sector_id', 'state',
        'state_type', 'annotation', 'demand', 'the_geom', 'expl_id', 'pattern_id', 'addparam', 'nodeparent', 'arcposition',
        'dma_id', 'presszone_id', 'dqa_id', 'minsector_id', 'age', 'builtdate'
    ],
    'Table rpt_inp_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_inp_node', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('rpt_inp_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('rpt_inp_node', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('rpt_inp_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('rpt_inp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('rpt_inp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('rpt_inp_node', 'node_type', 'character varying(30)', 'Column node_type should be character varying(30)');
SELECT col_type_is('rpt_inp_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('rpt_inp_node', 'epa_type', 'character varying(16)', 'Column epa_type should be character varying(16)');
SELECT col_type_is('rpt_inp_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('rpt_inp_node', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('rpt_inp_node', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('rpt_inp_node', 'annotation', 'character varying(254)', 'Column annotation should be character varying(254)');
SELECT col_type_is('rpt_inp_node', 'demand', 'double precision', 'Column demand should be double precision');
SELECT col_type_is('rpt_inp_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('rpt_inp_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('rpt_inp_node', 'pattern_id', 'character varying(16)', 'Column pattern_id should be character varying(16)');
SELECT col_type_is('rpt_inp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('rpt_inp_node', 'nodeparent', 'character varying(16)', 'Column nodeparent should be varchar(16)');
SELECT col_type_is('rpt_inp_node', 'arcposition', 'smallint', 'Column arcposition should be smallint');
SELECT col_type_is('rpt_inp_node', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('rpt_inp_node', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('rpt_inp_node', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('rpt_inp_node', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('rpt_inp_node', 'age', 'integer', 'Column age should be integer');
SELECT col_type_is('rpt_inp_node', 'builtdate', 'date', 'Column builtdate should be date');

-- Check default values
SELECT col_has_default('rpt_inp_node', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('rpt_inp_node', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('rpt_inp_node', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_is_null('rpt_inp_node', 'node_id', 'Column node_id should be NULL');

-- Check foreign keys
SELECT has_fk('rpt_inp_node', 'Table rpt_inp_node should have foreign keys');
SELECT fk_ok('rpt_inp_node', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id should reference rpt_cat_result.result_id');

-- Check indexes
SELECT has_index('rpt_inp_node', 'rpt_inp_node_epa_type', 'Should have index on epa_type');
SELECT has_index('rpt_inp_node', 'rpt_inp_node_index', 'Should have index on the_geom');
SELECT has_index('rpt_inp_node', 'rpt_inp_node_node_id', 'Should have index on node_id');
SELECT has_index('rpt_inp_node', 'rpt_inp_node_node_type', 'Should have index on node_type');
SELECT has_index('rpt_inp_node', 'rpt_inp_node_nodeparent', 'Should have index on nodeparent');
SELECT has_index('rpt_inp_node', 'rpt_inp_node_result_id', 'Should have index on result_id');

SELECT * FROM finish();

ROLLBACK;