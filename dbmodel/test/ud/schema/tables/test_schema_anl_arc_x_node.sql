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
SELECT has_table('anl_arc_x_node'::name, 'Table anl_arc_x_node should exist');

-- Check columns
SELECT columns_are(
    'anl_arc_x_node',
    ARRAY[
        'id', 'arc_id', 'node_id', 'arccat_id', 'state', 'expl_id',
        'fid', 'cur_user', 'the_geom', 'the_geom_p', 'descript', 'result_id'
    ],
    'Table anl_arc_x_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_arc_x_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_arc_x_node', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('anl_arc_x_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('anl_arc_x_node', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('anl_arc_x_node', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_arc_x_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_arc_x_node', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_arc_x_node', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_arc_x_node', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('anl_arc_x_node', 'the_geom_p', 'geometry(point, SRID_VALUE)', 'Column the_geom_p should be geometry(point, SRID_VALUE)');
SELECT col_type_is('anl_arc_x_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_arc_x_node', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
