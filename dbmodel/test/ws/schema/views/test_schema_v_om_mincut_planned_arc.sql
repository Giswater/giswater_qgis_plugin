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

-- Check view v_om_mincut_planned_arc
SELECT has_view('v_om_mincut_planned_arc'::name, 'View v_om_mincut_planned_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_planned_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'forecast_start', 'forecast_end', 'the_geom'
    ],
    'View v_om_mincut_planned_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_planned_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_planned_arc', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_om_mincut_planned_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_om_mincut_planned_arc', 'forecast_start', 'timestamp without time zone', 'Column forecast_start should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_planned_arc', 'forecast_end', 'timestamp without time zone', 'Column forecast_end should be timestamp without time zone');
SELECT col_type_is('v_om_mincut_planned_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
