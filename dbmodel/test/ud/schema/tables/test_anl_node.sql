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

--check if table exists
SELECT has_table('anl_arc_x_node'::name, 'Table anl_arc_x_node should exist');

-- check columns names 


SELECT columns_are(
    'anl_arc',
    ARRAY[
        'id', 'node_id', 'nodecat_id','state','num_arc','node_id_aux', 'nodecat_id_aux', 'state_aux',
         'expl_id', 'fid','cur_user', 'the_geom', 'arc_distance','arc_id','descript','result_id', 'total_distance', 
         'sys_type','code', 'cat_geom1', 'top_elev','elev', 'ymax','state_type','sector_id', 'addparam', 'drainzone_id', 'dwzone_id',

    ],
    'Table anl_arc should have the correct columns'
);
-- check columns names
SELECT col_type_is('anl_node', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('anl_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('anl_node', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_node', 'num_arc', 'integer', 'Column num_arc should be integer');
SELECT col_type_is('anl_node', 'node_id_aux', 'varchar(16)', 'Column node_id_aux should be varchar(16)');
SELECT col_type_is('anl_node', 'nodecat_id_aux', 'varchar(30)', 'Column nodecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_node', 'state_aux', 'integer', 'Column state_aux should be integer');
SELECT col_type_is('anl_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_node', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_node', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_node', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
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
SELECT col_type_is('anl_node', 'ymax', 'float8', 'Column ymax should be float8');
SELECT col_type_is('anl_node', 'state_type', 'integer', 'Column state_type should be integer');
SELECT col_type_is('anl_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('anl_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_node', 'drainzone_id', 'integer', 'Column drainzone_id should be integer');
SELECT col_type_is('anl_node', 'dwzone_id', 'integer', 'Column dwzone_id should be integer');

--check defealt values
SELECT col_has_default('anl_node', 'cur_user', 'Column cur_user should have default value');


-- check foreign keys
SELECT has_fk('anl_node', 'Table anl_node should have foreign keys');

SELECT fk_ok('anl_node', 'drainzone_id', 'drainzone', 'drainzone_id', 'Table should have foreign key from drainzone_id to drainzone.drainzone_id');
SELECT fk_ok('anl_node', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');


-- check index

SELECT has_index('anl_node', 'fid', 'Table anl_node should have index on fid');
SELECT has_index('anl_node', 'the_geom', 'Table anl_node should have index on the_geom');
SELECT has_index('anl_node', 'node_id', 'Table anl_node should have index on node_id');
SELECT has_index('anl_node', 'id', 'Table anl_node should have index on id');
--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;