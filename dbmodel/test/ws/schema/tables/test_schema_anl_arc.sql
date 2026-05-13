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
SELECT has_table('anl_arc'::name, 'Table anl_arc should exist');

-- Check columns
SELECT columns_are(
    'anl_arc',
    ARRAY[
        'id', 'arc_id', 'arccat_id', 'state', 'arc_id_aux', 'expl_id',
        'fid', 'cur_user', 'the_geom', 'the_geom_p', 'descript', 'result_id',
        'node_1', 'node_2', 'sys_type', 'code', 'cat_geom1', 'length',
        'slope', 'total_length', 'z1', 'z2', 'y1', 'y2',
        'elev1', 'elev2', 'losses', 'dma_id', 'presszone_id', 'dqa_id',
        'minsector_id', 'addparam', 'sector_id', 'state_type'
    ],
    'Table anl_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('anl_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('anl_arc', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_arc', 'arc_id_aux', 'varchar(16)', 'Column arc_id_aux should be varchar(16)');
SELECT col_type_is('anl_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_arc', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_arc', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('anl_arc', 'the_geom_p', 'geometry(point, SRID_VALUE)', 'Column the_geom_p should be geometry(point, SRID_VALUE)');
SELECT col_type_is('anl_arc', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_arc', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_arc', 'node_1', 'varchar(16)', 'Column node_1 should be varchar(16)');
SELECT col_type_is('anl_arc', 'node_2', 'varchar(16)', 'Column node_2 should be varchar(16)');
SELECT col_type_is('anl_arc', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('anl_arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('anl_arc', 'cat_geom1', 'float8', 'Column cat_geom1 should be float8');
SELECT col_type_is('anl_arc', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('anl_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('anl_arc', 'total_length', 'numeric(12,3)', 'Column total_length should be numeric(12,3)');
SELECT col_type_is('anl_arc', 'z1', 'float8', 'Column z1 should be float8');
SELECT col_type_is('anl_arc', 'z2', 'float8', 'Column z2 should be float8');
SELECT col_type_is('anl_arc', 'y1', 'float8', 'Column y1 should be float8');
SELECT col_type_is('anl_arc', 'y2', 'float8', 'Column y2 should be float8');
SELECT col_type_is('anl_arc', 'elev1', 'float8', 'Column elev1 should be float8');
SELECT col_type_is('anl_arc', 'elev2', 'float8', 'Column elev2 should be float8');
SELECT col_type_is('anl_arc', 'losses', 'numeric(12,4)', 'Column losses should be numeric(12,4)');
SELECT col_type_is('anl_arc', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('anl_arc', 'presszone_id', 'text', 'Column presszone_id should be text');
SELECT col_type_is('anl_arc', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('anl_arc', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('anl_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('anl_arc', 'state_type', 'int2', 'Column state_type should be int2');

-- Finish
SELECT * FROM finish();

ROLLBACK;
