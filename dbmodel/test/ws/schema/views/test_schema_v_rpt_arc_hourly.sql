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

-- Check view v_rpt_arc_hourly
SELECT has_view('v_rpt_arc_hourly'::name, 'View v_rpt_arc_hourly should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_arc_hourly',
    ARRAY[
        'id', 'arc_id', 'sector_id', 'result_id', 'flow_units', 'quality_units',
        'flow', 'vel', 'headloss', 'setting', 'ffactor', 'time',
        'diameter', 'the_geom'
    ],
    'View v_rpt_arc_hourly should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_arc_hourly', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_arc_hourly', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_arc_hourly', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_arc_hourly', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_arc_hourly', 'flow_units', 'text', 'Column flow_units should be text');
SELECT col_type_is('v_rpt_arc_hourly', 'quality_units', 'text', 'Column quality_units should be text');
SELECT col_type_is('v_rpt_arc_hourly', 'flow', 'numeric', 'Column flow should be numeric');
SELECT col_type_is('v_rpt_arc_hourly', 'vel', 'numeric', 'Column vel should be numeric');
SELECT col_type_is('v_rpt_arc_hourly', 'headloss', 'numeric', 'Column headloss should be numeric');
SELECT col_type_is('v_rpt_arc_hourly', 'setting', 'numeric', 'Column setting should be numeric');
SELECT col_type_is('v_rpt_arc_hourly', 'ffactor', 'numeric', 'Column ffactor should be numeric');
SELECT col_type_is('v_rpt_arc_hourly', 'time', 'varchar(100)', 'Column time should be varchar(100)');
SELECT col_type_is('v_rpt_arc_hourly', 'diameter', 'numeric(12,3)', 'Column diameter should be numeric(12,3)');
SELECT col_type_is('v_rpt_arc_hourly', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
