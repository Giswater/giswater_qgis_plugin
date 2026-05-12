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

-- Check table temp_table
SELECT has_table('temp_table'::name, 'Table temp_table should exist');

-- Check columns
SELECT columns_are(
    'temp_table',
    ARRAY[
        'id', 'fid', 'text_column', 'geom_point', 'geom_line', 'geom_polygon', 'cur_user', 
        'addparam', 'expl_id', 'macroexpl_id', 'sector_id', 'macrosector_id', 'geom_multicurve'
    ],
    'Table temp_table should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_table', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_table', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_table', 'fid', 'smallint', 'Column fid should be smallint');
SELECT col_type_is('temp_table', 'text_column', 'text', 'Column text_column should be text');
SELECT col_type_is('temp_table', 'geom_point', 'geometry(Point,25831)', 'Column geom_point should be geometry(Point,25831)');
SELECT col_type_is('temp_table', 'geom_line', 'geometry(LineString,25831)', 'Column geom_line should be geometry(LineString,25831)');
SELECT col_type_is('temp_table', 'geom_polygon', 'geometry(MultiPolygon,25831)', 'Column geom_polygon should be geometry(MultiPolygon,25831)');
SELECT col_type_is('temp_table', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('temp_table', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('temp_table', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('temp_table', 'macroexpl_id', 'integer', 'Column macroexpl_id should be integer');
SELECT col_type_is('temp_table', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('temp_table', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('temp_table', 'geom_multicurve', 'geometry(MultiCurve,25831)', 'Column geom_multicurve should be geometry(MultiCurve,25831)');

-- Check default values
SELECT col_has_default('temp_table', 'id', 'Column id should have a default value');
SELECT col_default_is('temp_table', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK; 