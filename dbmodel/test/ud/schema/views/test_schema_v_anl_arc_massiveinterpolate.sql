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

-- Check view v_anl_arc_massiveinterpolate
SELECT has_view('v_anl_arc_massiveinterpolate'::name, 'View v_anl_arc_massiveinterpolate should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_arc_massiveinterpolate',
    ARRAY[
        'id', 'arc_id', 'expl_id', 'fid', 'descript', 'cur_user',
        'the_geom'
    ],
    'View v_anl_arc_massiveinterpolate should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('v_anl_arc_massiveinterpolate', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
