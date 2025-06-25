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
        'id', 'connec_id', 'conneccat_id', 'state', 'connec_id_aux', 'connecat_id_aux', 'state_aux', 'expl_id', 'fid',
        'cur_user', 'the_geom', 'descript', 'result_id', 'dma_id', 'addparam'
    ],
    'Table anl_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_connec', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('anl_connec', 'anl_connec_connec_id', 'Table should have index on connec_id');
SELECT has_index('anl_connec', 'anl_connec_index', 'Table should have spatial index');

-- Check column types
SELECT col_type_is('anl_connec', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_connec', 'connec_id', 'text', 'Column connec_id should be text');
SELECT col_type_is('anl_connec', 'conneccat_id', 'character varying(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('anl_connec', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_connec', 'connec_id_aux', 'text', 'Column connec_id_aux should be text');
SELECT col_type_is('anl_connec', 'connecat_id_aux', 'character varying(30)', 'Column connecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_connec', 'state_aux', 'integer', 'Column state_aux should be integer');
SELECT col_type_is('anl_connec', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_connec', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_connec', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_connec', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('anl_connec', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_connec', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_connec', 'dma_id', 'text', 'Column dma_id should be text');
SELECT col_type_is('anl_connec', 'addparam', 'text', 'Column addparam should be text');

-- Check foreign keys
SELECT hasnt_fk('anl_connec', 'Table anl_connec should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('anl_connec_id_seq', 'Sequence anl_connec_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
