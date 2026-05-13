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
SELECT has_table('temp_table'::name, 'Table temp_table should exist');

-- Check columns
SELECT columns_are(
    'temp_table',
    ARRAY[
        'id', 'fid', 'text_column', 'geom_point', 'geom_line', 'geom_polygon',
        'cur_user', 'addparam', 'expl_id', 'macroexpl_id', 'sector_id', 'macrosector_id',
        'geom_multicurve'
    ],
    'Table temp_table should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_table', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_table', 'fid', 'int2', 'Column fid should be int2');
SELECT col_type_is('temp_table', 'text_column', 'text', 'Column text_column should be text');
SELECT col_type_is('temp_table', 'geom_point', 'geometry(point, SRID_VALUE)', 'Column geom_point should be geometry(point, SRID_VALUE)');
SELECT col_type_is('temp_table', 'geom_line', 'geometry(linestring, SRID_VALUE)', 'Column geom_line should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('temp_table', 'geom_polygon', 'geometry(multipolygon, SRID_VALUE)', 'Column geom_polygon should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('temp_table', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('temp_table', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('temp_table', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('temp_table', 'macroexpl_id', 'int4', 'Column macroexpl_id should be int4');
SELECT col_type_is('temp_table', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_table', 'macrosector_id', 'int4', 'Column macrosector_id should be int4');
SELECT col_type_is('temp_table', 'geom_multicurve', 'geometry(multicurve, SRID_VALUE)', 'Column geom_multicurve should be geometry(multicurve, SRID_VALUE)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
