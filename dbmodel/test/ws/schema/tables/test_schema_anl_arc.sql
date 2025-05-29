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

-- Check table anl_arc
SELECT has_table('anl_arc'::name, 'Table anl_arc should exist');

-- Check columns
SELECT columns_are(
    'anl_arc',
    ARRAY[
        'id', 'arc_id', 'arccat_id', 'state', 'arc_id_aux', 'expl_id', 'fid', 'cur_user', 'the_geom', 'the_geom_p',
        'descript', 'result_id', 'node_1', 'node_2', 'sys_type', 'code', 'cat_geom1', 'length', 'slope', 'total_length',
        'z1', 'z2', 'y1', 'y2', 'elev1', 'elev2', 'losses', 'dma_id', 'presszone_id', 'dqa_id', 'minsector_id',
        'addparam', 'sector_id'
    ],
    'Table anl_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_arc', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('anl_arc', 'anl_arc_arc_id', 'Table should have index on arc_id');
SELECT has_index('anl_arc', 'anl_arc_index', 'Table should have spatial index');

-- Check column types
SELECT col_type_is('anl_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('anl_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('anl_arc', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_arc', 'arc_id_aux', 'integer', 'Column arc_id_aux should be integer');
SELECT col_type_is('anl_arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_arc', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_arc', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('anl_arc', 'the_geom_p', 'geometry(Point,25831)', 'Column the_geom_p should be geometry(Point,25831)');
SELECT col_type_is('anl_arc', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_arc', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_arc', 'node_1', 'integer', 'Column node_1 should be integer');
SELECT col_type_is('anl_arc', 'node_2', 'integer', 'Column node_2 should be integer');
SELECT col_type_is('anl_arc', 'sys_type', 'character varying(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('anl_arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('anl_arc', 'cat_geom1', 'double precision', 'Column cat_geom1 should be double precision');
SELECT col_type_is('anl_arc', 'length', 'double precision', 'Column length should be double precision');
SELECT col_type_is('anl_arc', 'slope', 'double precision', 'Column slope should be double precision');
SELECT col_type_is('anl_arc', 'total_length', 'numeric(12,3)', 'Column total_length should be numeric(12,3)');
SELECT col_type_is('anl_arc', 'z1', 'double precision', 'Column z1 should be double precision');
SELECT col_type_is('anl_arc', 'z2', 'double precision', 'Column z2 should be double precision');
SELECT col_type_is('anl_arc', 'y1', 'double precision', 'Column y1 should be double precision');
SELECT col_type_is('anl_arc', 'y2', 'double precision', 'Column y2 should be double precision');
SELECT col_type_is('anl_arc', 'elev1', 'double precision', 'Column elev1 should be double precision');
SELECT col_type_is('anl_arc', 'elev2', 'double precision', 'Column elev2 should be double precision');
SELECT col_type_is('anl_arc', 'losses', 'numeric(12,4)', 'Column losses should be numeric(12,4)');
SELECT col_type_is('anl_arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('anl_arc', 'presszone_id', 'text', 'Column presszone_id should be text');
SELECT col_type_is('anl_arc', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('anl_arc', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('anl_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_arc', 'sector_id', 'integer', 'Column sector_id should be integer');

-- Check foreign keys
SELECT hasnt_fk('anl_arc', 'Table anl_arc should have no foreign keys');
-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('anl_arc_id_seq', 'Sequence anl_arc_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
