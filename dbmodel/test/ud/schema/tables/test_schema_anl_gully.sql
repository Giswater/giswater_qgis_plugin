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
SELECT has_table('anl_gully'::name, 'Table anl_gully should exist');

-- check columns names 


SELECT columns_are(
    'anl_gully',
    ARRAY[
        'id', 'gully_id', 'gullycat_id','state','gully_id_aux', 'gratecat_id_aux', 'state_aux', 'expl_id', 'fid','cur_user', 'the_geom', 'descript',
         'result_id', 'dma_id', 'addparam','dwfzone_id', 'drainzone_id'
    ],
    'Table anl_gully should have the correct columns'
);

SELECT col_is_pk('anl_gully', 'id', 'Column id should be primary key');
-- check columns names
SELECT col_type_is('anl_gully', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_gully', 'gully_id', 'varchar(16)', 'Column gully_id should be varchar(16)');
SELECT col_type_is('anl_gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('anl_gully', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_gully', 'gully_id_aux', 'varchar(16)', 'Column gully_id_aux should be varchar(16)');
SELECT col_type_is('anl_gully', 'gratecat_id_aux', 'varchar(30)', 'Column gratecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_gully', 'state_aux', 'integer', 'Column state_aux should be integer');
SELECT col_type_is('anl_gully', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_gully', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_gully', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_gully', 'the_geom', 'geometry(Point, 25831)', 'Column the_geom should be geometry(Point, 25831)');
SELECT col_type_is('anl_gully', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_gully', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_gully', 'dma_id', 'text', 'Column dma_id should be text');
SELECT col_type_is('anl_gully', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_gully', 'dwfzone_id', 'integer', 'Column dwfzone_id should be integer');
SELECT col_type_is('anl_gully', 'drainzone_id', 'integer', 'Column drainzone_id should be integer');

--check defealt values
SELECT col_has_default('anl_gully', 'cur_user', 'Column cur_user should have default value');


-- check foreign keys
SELECT has_fk('anl_gully', 'Table anl_gully should have foreign keys');

SELECT fk_ok('anl_gully', 'drainzone_id', 'drainzone', 'drainzone_id', 'Table should have foreign key from drainzone_id to drainzone.drainzone_id');
SELECT fk_ok('anl_gully', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');


-- check index

SELECT has_index('anl_gully', 'anl_gully_gully_id', ARRAY['gully_id'], 'Table anl_gully should have index on gully_id');
SELECT has_index('anl_gully', 'anl_gully_index', ARRAY['the_geom'], 'Table anl_gully should have index on the_geom');
SELECT has_index('anl_gully', 'anl_gully_pkey', ARRAY['id'], 'Table anl_gully should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;