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

-- Check view v_om_mincut_current_arc
SELECT has_view('v_om_mincut_current_arc'::name, 'View v_om_mincut_current_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_current_arc',
    ARRAY[
        'id', 'result_id', 'work_order', 'arc_id', 'the_geom'
    ],
    'View v_om_mincut_current_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_current_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_current_arc', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_om_mincut_current_arc', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_om_mincut_current_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_om_mincut_current_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
