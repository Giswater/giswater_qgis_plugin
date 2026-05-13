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
SELECT has_table('anl_polygon'::name, 'Table anl_polygon should exist');

-- Check columns
SELECT columns_are(
    'anl_polygon',
    ARRAY[
        'id', 'pol_id', 'pol_type', 'state', 'expl_id', 'fid',
        'cur_user', 'the_geom', 'result_id', 'descript'
    ],
    'Table anl_polygon should have the correct columns'
);

-- Check column types
SELECT col_type_is('anl_polygon', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('anl_polygon', 'pol_id', 'varchar(16)', 'Column pol_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'pol_type', 'varchar(30)', 'Column pol_type should be varchar(30)');
SELECT col_type_is('anl_polygon', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('anl_polygon', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('anl_polygon', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('anl_polygon', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_polygon', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('anl_polygon', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'descript', 'text', 'Column descript should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
