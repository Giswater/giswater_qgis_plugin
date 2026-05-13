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

-- Check view v_rpt_arc_compare_timestep
SELECT has_view('v_rpt_arc_compare_timestep'::name, 'View v_rpt_arc_compare_timestep should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_arc_compare_timestep',
    ARRAY[
        'id', 'arc_id', 'result_id', 'flow', 'velocity', 'fullpercent',
        'resultdate', 'resulttime', 'the_geom'
    ],
    'View v_rpt_arc_compare_timestep should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_arc_compare_timestep', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'flow', 'float8', 'Column flow should be float8');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'velocity', 'float8', 'Column velocity should be float8');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'fullpercent', 'float8', 'Column fullpercent should be float8');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('v_rpt_arc_compare_timestep', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
