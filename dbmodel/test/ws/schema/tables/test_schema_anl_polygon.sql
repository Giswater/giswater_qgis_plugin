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

-- Check table anl_polygon
SELECT has_table('anl_polygon'::name, 'Table anl_polygon should exist');

-- Check columns
SELECT columns_are(
    'anl_polygon',
    ARRAY[
        'id', 'pol_id', 'pol_type', 'state', 'expl_id', 'fid', 'cur_user', 'the_geom', 'result_id', 'descript'
    ],
    'Table anl_polygon should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('anl_polygon', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('anl_polygon', 'anl_polygon_index', 'Table should have spatial index');
SELECT has_index('anl_polygon', 'anl_polygon_pol_id', 'Table should have index on pol_id');

-- Check column types
SELECT col_type_is('anl_polygon', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('anl_polygon', 'pol_id', 'character varying(16)', 'Column pol_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'pol_type', 'character varying(30)', 'Column pol_type should be varchar(30)');
SELECT col_type_is('anl_polygon', 'state', 'integer', 'Column state should be integer');
SELECT col_type_is('anl_polygon', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('anl_polygon', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('anl_polygon', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('anl_polygon', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('anl_polygon', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('anl_polygon', 'descript', 'text', 'Column descript should be text');

-- Check foreign keys
SELECT hasnt_fk('anl_polygon', 'Table anl_polygon should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('anl_polygon_id_seq', 'Sequence anl_polygon_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
