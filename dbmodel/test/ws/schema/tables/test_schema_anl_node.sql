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
SELECT has_table('anl_node'::name, 'Table anl_node should exist');

-- Check columns
SELECT columns_are(
    'anl_node',
    ARRAY[
        'id', 'node_id', 'nodecat_id', 'state', 'num_arcs', 'node_id_aux',
        'nodecat_id_aux', 'state_aux', 'expl_id', 'fid', 'cur_user', 'the_geom',
        'arc_distance', 'arc_id', 'descript', 'result_id', 'total_distance', 'sys_type',
        'code', 'cat_geom1', 'top_elev', 'elev', 'depth', 'state_type',
        'sector_id', 'losses', 'dma_id', 'presszone_id', 'dqa_id', 'minsector_id',
        'demand', 'addparam', 'family', 'builtdate'
    ],
    'Table anl_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('anl_node', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_node', 'num_arcs', 'int4', 'Column num_arcs should be int4');
SELECT col_type_is('anl_node', 'node_id_aux', 'varchar(16)', 'Column node_id_aux should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id_aux', 'varchar(30)', 'Column nodecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_node', 'state_aux', 'int4', 'Column state_aux should be int4');
SELECT col_type_is('anl_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_node', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_node', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('anl_node', 'arc_distance', 'numeric(12,3)', 'Column arc_distance should be numeric(12,3)');
SELECT col_type_is('anl_node', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('anl_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_node', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_node', 'total_distance', 'numeric(12,3)', 'Column total_distance should be numeric(12,3)');
SELECT col_type_is('anl_node', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('anl_node', 'code', 'text', 'Column code should be text');
SELECT col_type_is('anl_node', 'cat_geom1', 'float8', 'Column cat_geom1 should be float8');
SELECT col_type_is('anl_node', 'top_elev', 'float8', 'Column top_elev should be float8');
SELECT col_type_is('anl_node', 'elev', 'float8', 'Column elev should be float8');
SELECT col_type_is('anl_node', 'depth', 'float8', 'Column depth should be float8');
SELECT col_type_is('anl_node', 'state_type', 'int4', 'Column state_type should be int4');
SELECT col_type_is('anl_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('anl_node', 'losses', 'numeric(12,4)', 'Column losses should be numeric(12,4)');
SELECT col_type_is('anl_node', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('anl_node', 'presszone_id', 'text', 'Column presszone_id should be text');
SELECT col_type_is('anl_node', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('anl_node', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('anl_node', 'demand', 'float8', 'Column demand should be float8');
SELECT col_type_is('anl_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_node', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('anl_node', 'builtdate', 'date', 'Column builtdate should be date');

-- Finish
SELECT * FROM finish();

ROLLBACK;
