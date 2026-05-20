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
SELECT has_table('anl_gully'::name, 'Table anl_gully should exist');

-- Check columns
SELECT columns_are(
    'anl_gully',
    ARRAY[
        'id', 'gully_id', 'gullycat_id', 'state', 'gully_id_aux', 'gratecat_id_aux',
        'state_aux', 'expl_id', 'fid', 'cur_user', 'the_geom', 'descript',
        'result_id', 'dma_id', 'addparam', 'dwfzone_id', 'drainzone_id'
    ],
    'Table anl_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_gully', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_gully', 'gully_id', 'varchar(16)', 'Column gully_id should be varchar(16)');
SELECT col_type_is('anl_gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('anl_gully', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_gully', 'gully_id_aux', 'varchar(16)', 'Column gully_id_aux should be varchar(16)');
SELECT col_type_is('anl_gully', 'gratecat_id_aux', 'varchar(30)', 'Column gratecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_gully', 'state_aux', 'int4', 'Column state_aux should be int4');
SELECT col_type_is('anl_gully', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_gully', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_gully', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_gully', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('anl_gully', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_gully', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_gully', 'dma_id', 'text', 'Column dma_id should be text');
SELECT col_type_is('anl_gully', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_gully', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('anl_gully', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');

-- Check foreign keys
SELECT has_fk('anl_gully', 'Table anl_gully should have foreign keys');

SELECT fk_ok('anl_gully', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'FK dwfzone_id → dwfzone.dwfzone_id');
SELECT fk_ok('anl_gully', 'drainzone_id', 'drainzone', 'drainzone_id', 'FK drainzone_id → drainzone.drainzone_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
