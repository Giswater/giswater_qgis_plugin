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

-- Check table anl_connec
SELECT has_table('anl_connec'::name, 'Table anl_connec should exist');

-- Check columns
SELECT columns_are(
    'anl_connec',
    ARRAY[
        'id', 'connec_id', 'conneccat_id', 'state', 'connec_id_aux', 'connecat_id_aux', 'state_aux', 'expl_id', 'fid', 'cur_user',
        'the_geom', 'descript', 'result_id', 'dma_id', 'addparam', 'dwfzone_id', 'drainzone_id'
    ],
    'Table anl_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_connec', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('anl_connec', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('anl_connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('anl_connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('anl_connec', 'state', 'interger', 'Column state should be interger');
SELECT col_type_is('anl_connec', 'connec_id_aux', 'varchar(16)', 'Column connec_id_aux should be varchar(16)');
SELECT col_type_is('anl_connec', 'connecat_id_aux', 'varchar(30)', 'Column connecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_connec', 'state_aux', 'interger', 'Column state_aux should be interger');
SELECT col_type_is('anl_connec', 'expl_id', 'interger', 'Column expl_id should be interger');
SELECT col_type_is('anl_connec', 'fid', 'interger', 'Column fid should be interger');
SELECT col_type_is('anl_connec', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_connec', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('anl_connec', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_connec', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_connec', 'dma_id', 'text', 'Column dma_id should be text');
SELECT col_type_is('anl_connec', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('anl_connec', 'dwfzone_id', 'interger', 'Column dwfzone_id should be interger');
SELECT col_type_is('anl_connec', 'drainzone_id', 'interger', 'Column drainzone_id should be interger');

-- Check default values
SELECT col_has_default('anl_connec', 'cur_user', 'Column cur_user should have default value');

-- Check foreign keys
SELECT has_fk('anl_connec', 'Table anl_connec should have foreign keys');

SELECT fk_ok('anl_connec', 'drainzone_id', 'drainzone', 'drainzone_id', 'Table should have foreign key from drainzone_id to drainzone.drainzone_id');
SELECT fk_ok('anl_connec', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');

-- Check indexes
SELECT has_index('anl_connec', 'connec_id', 'Table should have index on connec_id');
SELECT has_index('anl_connec', 'the_geom', 'Table should have index on the_geom');
SELECT has_index('anl_connec', 'id', 'Table should have index on id');

-- Check triggers

-- Check rules

-- Finish
SELECT * FROM finish();

ROLLBACK;