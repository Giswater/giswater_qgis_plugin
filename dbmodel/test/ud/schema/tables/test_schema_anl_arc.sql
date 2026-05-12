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

SELECT has_table('anl_arc'::name, 'Table anl_arc should exist');
-- check columns names 


SELECT columns_are(
    'anl_arc',
    ARRAY[
        'id', 'arc_id', 'arccat_id', 'state', 'arc_id_aux', 'expl_id', 'fid','cur_user', 'the_geom', 'the_geom_p', 'descript',
         'result_id', 'node_1', 'node_2','sys_type', 'code', 'cat_geom1', 'length', 'slope', 'total_length', 'z1','z2', 'y1', 'y2', 'elev1',
          'elev2', 'dma_id', 'addparam', 'sector_id', 'drainzone_id', 'dwfzone_id', 'omunit_id'
    ],
    'Table anl_arc should have the correct columns'
);
-- primary key
SELECT col_is_pk('anl_arc', 'id', 'Column id should be primary key');

--column types
SELECT col_type_is('anl_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('anl_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be character varying(30)');
SELECT col_type_is('anl_arc', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_arc', 'arc_id_aux', 'character varying(16)', 'Column arc_id_aux should be character varying(16)');
SELECT col_type_is('anl_arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_arc', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_arc', 'cur_user', 'character varying(50)', 'Column cur_user should be character varying(50)');
SELECT col_type_is('anl_arc', 'the_geom', 'geometry(linestring, 25831)', 'Column the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('anl_arc', 'the_geom_p', 'geometry(point, 25831)', 'Column the_geom_p should be geometry(point, 25831)');
SELECT col_type_is('anl_arc', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_arc', 'result_id', 'character varying(16)', 'Column result_id should be character varying(16)');
SELECT col_type_is('anl_arc', 'node_1', 'character varying(16)', 'Column node_1 should be character varying(16)');
SELECT col_type_is('anl_arc', 'node_2', 'character varying(16)', 'Column node_2 should be character varying(16)');
SELECT col_type_is('anl_arc', 'sys_type', 'character varying(30)', 'Column sys_type should be character varying(30)');
SELECT col_type_is('anl_arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('anl_arc', 'cat_geom1', 'float8', 'Column cat_geom1 should be float8');
SELECT col_type_is('anl_arc', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('anl_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('anl_arc', 'total_length', 'numeric(12, 3)', 'Column total_length should be numeric(12, 3)');
SELECT col_type_is('anl_arc', 'z1', 'float8', 'Column z1 should be float8');
SELECT col_type_is('anl_arc', 'z2', 'float8', 'Column z2 should be float8');
SELECT col_type_is('anl_arc', 'y1', 'float8', 'Column y1 should be float8');
SELECT col_type_is('anl_arc', 'y2', 'float8', 'Column y2 should be float8');
SELECT col_type_is('anl_arc', 'elev1', 'float8', 'Column elev1 should be float8');
SELECT col_type_is('anl_arc', 'elev2', 'float8', 'Column elev2 should be float8');
SELECT col_type_is('anl_arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('anl_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_arc', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('anl_arc', 'drainzone_id', 'integer', 'Column drainzone_id should be integer');
SELECT col_type_is('anl_arc', 'dwfzone_id', 'integer', 'Column dwfzone_id should be integer');
SELECT col_type_is('anl_arc', 'omunit_id', 'integer', 'Column omunit_id should be integer');

-- Check check default values
SELECT col_has_default('anl_arc', 'cur_user', 'Column cur_user should have default value');

-- check foreign keys

SELECT has_fk('anl_arc', 'Table anl_arc should have foreign keys');

SELECT fk_ok('anl_arc', 'drainzone_id', 'drainzone', 'drainzone_id', 'Table anl_arc should have foreign key from drainzone_id to drainzone.drainzone_id');
SELECT fk_ok('anl_arc', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table anl_arc should have foreign key from dwfzone_id to dwfzone.dwfzone_id');

-- check index

SELECT has_index('anl_arc', 'anl_arc_arc_id', ARRAY['arc_id'], 'Table anl_arc should have index on arc_id');
SELECT has_index('anl_arc', 'anl_arc_index', ARRAY['the_geom'], 'Table anl_arc should have index on the_geom');
SELECT has_index('anl_arc', 'anl_arc_pkey', ARRAY['id'], 'Table anl_arc should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;