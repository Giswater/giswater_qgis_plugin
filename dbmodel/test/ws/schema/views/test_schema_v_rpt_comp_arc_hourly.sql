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

-- Check view v_rpt_comp_arc_hourly
SELECT has_view('v_rpt_comp_arc_hourly'::name, 'View v_rpt_comp_arc_hourly should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_arc_hourly',
    ARRAY[
        'arc_id', 'sector_id', 'result_id_main', 'result_id_compare', 'time_main', 'time_compare',
        'flow_main', 'flow_compare', 'flow_diff', 'vel_main', 'vel_compare', 'vel_diff',
        'headloss_main', 'headloss_compare', 'headloss_diff', 'setting_main', 'setting_compare', 'setting_diff',
        'ffactor_main', 'ffactor_compare', 'ffactor_diff', 'diameter_main', 'diameter_compare', 'diameter_diff',
        'the_geom'
    ],
    'View v_rpt_comp_arc_hourly should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_arc_hourly', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'time_main', 'varchar(100)', 'Column time_main should be varchar(100)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'time_compare', 'varchar(100)', 'Column time_compare should be varchar(100)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'flow_main', 'numeric', 'Column flow_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'flow_compare', 'numeric', 'Column flow_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'flow_diff', 'numeric', 'Column flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'vel_main', 'numeric', 'Column vel_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'vel_compare', 'numeric', 'Column vel_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'vel_diff', 'numeric', 'Column vel_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'headloss_main', 'numeric', 'Column headloss_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'headloss_compare', 'numeric', 'Column headloss_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'headloss_diff', 'numeric', 'Column headloss_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'setting_main', 'numeric', 'Column setting_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'setting_compare', 'numeric', 'Column setting_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'setting_diff', 'numeric', 'Column setting_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'ffactor_main', 'numeric', 'Column ffactor_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'ffactor_compare', 'numeric', 'Column ffactor_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'ffactor_diff', 'numeric', 'Column ffactor_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'diameter_main', 'numeric(12,3)', 'Column diameter_main should be numeric(12,3)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'diameter_compare', 'numeric(12,3)', 'Column diameter_compare should be numeric(12,3)');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'diameter_diff', 'numeric', 'Column diameter_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc_hourly', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
