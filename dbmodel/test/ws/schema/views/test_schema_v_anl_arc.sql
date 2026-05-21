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

-- Check view v_anl_arc
SELECT has_view('v_anl_arc'::name, 'View v_anl_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_arc',
    ARRAY[
        'id', 'arc_id', 'arc_type', 'state', 'arc_id_aux', 'fprocesscat_id',
        'expl_name', 'the_geom', 'result_id', 'descript'
    ],
    'View v_anl_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_anl_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_anl_arc', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('v_anl_arc', 'arc_id_aux', 'varchar(16)', 'Column arc_id_aux should be varchar(16)');
SELECT col_type_is('v_anl_arc', 'fprocesscat_id', 'int4', 'Column fprocesscat_id should be int4');
SELECT col_type_is('v_anl_arc', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_anl_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('v_anl_arc', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('v_anl_arc', 'descript', 'text', 'Column descript should be text');

SELECT * FROM finish();

ROLLBACK;
