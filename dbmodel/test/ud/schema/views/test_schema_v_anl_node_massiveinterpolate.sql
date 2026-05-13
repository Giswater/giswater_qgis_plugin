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

-- Check view v_anl_node_massiveinterpolate
SELECT has_view('v_anl_node_massiveinterpolate'::name, 'View v_anl_node_massiveinterpolate should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_node_massiveinterpolate',
    ARRAY[
        'id', 'node_id', 'expl_id', 'fid', 'descript', 'top_elev',
        'elev', 'ymax', 'cur_user', 'the_geom'
    ],
    'View v_anl_node_massiveinterpolate should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_node_massiveinterpolate', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('v_anl_node_massiveinterpolate', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
