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

-- Check table anl_node
SELECT has_table('anl_node'::name, 'Table anl_node should exist');

-- Check columns
SELECT columns_are(
    'anl_node',
    ARRAY[
        'id', 'node_id', 'nodecat_id', 'state', 'num_arcs', 'node_id_aux', 'nodecat_id_aux', 'state_aux', 'expl_id', 'fid',
        'cur_user', 'the_geom', 'arc_distance', 'arc_id', 'descript', 'result_id', 'total_distance', 'sys_type', 'code',
        'cat_geom1', 'top_elev', 'elev', 'depth', 'state_type', 'sector_id', 'losses', 'dma_id', 'presszone_id', 'dqa_id',
        'minsector_id', 'demand', 'addparam', 'family', 'builtdate'
    ],
    'Table anl_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_node', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('anl_node', 'anl_node_fprocesscat_id_index', 'Table should have index on fid');
SELECT has_index('anl_node', 'anl_node_index', 'Table should have spatial index');
SELECT has_index('anl_node', 'anl_node_node_id_index', 'Table should have index on node_id');

-- Check column types
SELECT col_type_is('anl_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('anl_node', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_node', 'num_arcs', 'integer', 'Column num_arcs should be integer');
SELECT col_type_is('anl_node', 'node_id_aux', 'character varying(16)', 'Column node_id_aux should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id_aux', 'character varying(30)', 'Column nodecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_node', 'state_aux', 'integer', 'Column state_aux should be integer');
SELECT col_type_is('anl_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_node', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_node', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('anl_node', 'arc_distance', 'numeric(12,3)', 'Column arc_distance should be numeric(12,3)');
SELECT col_type_is('anl_node', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('anl_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_node', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_node', 'total_distance', 'numeric(12,3)', 'Column total_distance should be numeric(12,3)');
SELECT col_type_is('anl_node', 'sys_type', 'character varying(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('anl_node', 'code', 'text', 'Column code should be text');
SELECT col_type_is('anl_node', 'cat_geom1', 'double precision', 'Column cat_geom1 should be double precision');
SELECT col_type_is('anl_node', 'top_elev', 'double precision', 'Column top_elev should be double precision');
SELECT col_type_is('anl_node', 'elev', 'double precision', 'Column elev should be double precision');
SELECT col_type_is('anl_node', 'depth', 'double precision', 'Column depth should be double precision');
SELECT col_type_is('anl_node', 'state_type', 'integer', 'Column state_type should be integer');
SELECT col_type_is('anl_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('anl_node', 'losses', 'numeric(12,4)', 'Column losses should be numeric(12,4)');
SELECT col_type_is('anl_node', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('anl_node', 'presszone_id', 'text', 'Column presszone_id should be text');
SELECT col_type_is('anl_node', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('anl_node', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('anl_node', 'demand', 'double precision', 'Column demand should be double precision');
SELECT col_type_is('anl_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_node', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('anl_node', 'builtdate', 'date', 'Column builtdate should be date');

-- Check foreign keys
SELECT hasnt_fk('anl_node', 'Table anl_node should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('anl_node_id_seq', 'Sequence anl_node_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
