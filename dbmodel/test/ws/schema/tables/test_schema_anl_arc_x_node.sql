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

-- Check table anl_arc_x_node
SELECT has_table('anl_arc_x_node'::name, 'Table anl_arc_x_node should exist');

-- Check columns
SELECT columns_are(
    'anl_arc_x_node',
    ARRAY[
        'id', 'arc_id', 'node_id', 'arccat_id', 'state', 'expl_id', 'fid', 'cur_user', 'the_geom', 'the_geom_p',
        'descript', 'result_id'
    ],
    'Table anl_arc_x_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_arc_x_node', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('anl_arc_x_node', 'anl_arc_x_node_arc_id', 'Table should have index on arc_id');
SELECT has_index('anl_arc_x_node', 'anl_arc_x_node_index', 'Table should have spatial index');
SELECT has_index('anl_arc_x_node', 'anl_arc_x_node_node_id', 'Table should have index on node_id');

-- Check column types
SELECT col_type_is('anl_arc_x_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_arc_x_node', 'arc_id', 'text', 'Column arc_id should be text');
SELECT col_type_is('anl_arc_x_node', 'node_id', 'text', 'Column node_id should be text');
SELECT col_type_is('anl_arc_x_node', 'arccat_id', 'character varying(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('anl_arc_x_node', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_arc_x_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_arc_x_node', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_arc_x_node', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_arc_x_node', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('anl_arc_x_node', 'the_geom_p', 'geometry(Point,25831)', 'Column the_geom_p should be geometry(Point,25831)');
SELECT col_type_is('anl_arc_x_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_arc_x_node', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');

-- Check foreign keys
SELECT hasnt_fk('anl_arc_x_node', 'Table anl_arc_x_node should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('anl_arc_x_node_id_seq', 'Sequence anl_arc_x_node_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
