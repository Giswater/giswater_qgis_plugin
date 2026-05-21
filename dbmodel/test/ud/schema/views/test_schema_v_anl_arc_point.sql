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

-- Check view v_anl_arc_point
SELECT has_view('v_anl_arc_point'::name, 'View v_anl_arc_point should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_arc_point',
    ARRAY[
        'id', 'arc_id', 'arc_type', 'state', 'arc_id_aux', 'fprocesscat_id',
        'expl_name', 'the_geom_p'
    ],
    'View v_anl_arc_point should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_arc_point', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_arc_point', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_anl_arc_point', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_anl_arc_point', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('v_anl_arc_point', 'arc_id_aux', 'varchar(16)', 'Column arc_id_aux should be varchar(16)');
SELECT col_type_is('v_anl_arc_point', 'fprocesscat_id', 'int4', 'Column fprocesscat_id should be int4');
SELECT col_type_is('v_anl_arc_point', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_anl_arc_point', 'the_geom_p', 'geometry(point, SRID_VALUE)', 'Column the_geom_p should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
