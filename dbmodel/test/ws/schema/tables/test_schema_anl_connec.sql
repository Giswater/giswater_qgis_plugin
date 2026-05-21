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
SELECT has_table('anl_connec'::name, 'Table anl_connec should exist');

-- Check columns
SELECT columns_are(
    'anl_connec',
    ARRAY[
        'id', 'connec_id', 'conneccat_id', 'state', 'connec_id_aux', 'connecat_id_aux',
        'state_aux', 'expl_id', 'fid', 'cur_user', 'the_geom', 'descript',
        'result_id', 'dma_id', 'addparam'
    ],
    'Table anl_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_connec', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('anl_connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('anl_connec', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_connec', 'connec_id_aux', 'varchar(16)', 'Column connec_id_aux should be varchar(16)');
SELECT col_type_is('anl_connec', 'connecat_id_aux', 'varchar(30)', 'Column connecat_id_aux should be varchar(30)');
SELECT col_type_is('anl_connec', 'state_aux', 'int4', 'Column state_aux should be int4');
SELECT col_type_is('anl_connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_connec', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_connec', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('anl_connec', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('anl_connec', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_connec', 'dma_id', 'text', 'Column dma_id should be text');
SELECT col_type_is('anl_connec', 'addparam', 'text', 'Column addparam should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
