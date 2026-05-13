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

-- Check view v_rpt_comp_arcflow_sum
SELECT has_view('v_rpt_comp_arcflow_sum'::name, 'View v_rpt_comp_arcflow_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_arcflow_sum',
    ARRAY[
        'arc_id', 'sector_id', 'arc_type', 'arccat_id', 'swarc_type', 'result_id_main',
        'result_id_compare', 'max_flow_main', 'max_flow_compare', 'max_flow_diff', 'max_veloc_main', 'max_veloc_compare',
        'max_veloc_diff', 'mfull_flow_main', 'mfull_flow_compare', 'mfull_flow_diff', 'mfull_depth_main', 'mfull_depth_compare',
        'mfull_depth_diff', 'max_shear_main', 'max_shear_compare', 'max_shear_diff', 'max_hr_main', 'max_hr_compare',
        'max_hr_diff', 'max_slope_main', 'max_slope_compare', 'max_slope_diff', 'day_max_main', 'day_max_compare',
        'time_max_main', 'time_max_compare', 'min_shear_main', 'min_shear_compare', 'min_shear_diff', 'day_min_main',
        'day_min_compare', 'time_min_main', 'time_min_compare', 'time_days_main', 'time_days_compare', 'time_hour_main',
        'time_hour_compare', 'the_geom'
    ],
    'View v_rpt_comp_arcflow_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'arc_id', 'varchar', 'Column arc_id should be varchar');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'swarc_type', 'varchar(18)', 'Column swarc_type should be varchar(18)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_flow_main', 'numeric(12,4)', 'Column max_flow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_flow_compare', 'numeric(12,4)', 'Column max_flow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_flow_diff', 'numeric', 'Column max_flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_veloc_main', 'numeric(12,4)', 'Column max_veloc_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_veloc_compare', 'numeric(12,4)', 'Column max_veloc_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_veloc_diff', 'numeric', 'Column max_veloc_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_flow_main', 'numeric(12,4)', 'Column mfull_flow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_flow_compare', 'numeric(12,4)', 'Column mfull_flow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_flow_diff', 'numeric', 'Column mfull_flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_depth_main', 'numeric(12,4)', 'Column mfull_depth_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_depth_compare', 'numeric(12,4)', 'Column mfull_depth_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'mfull_depth_diff', 'numeric', 'Column mfull_depth_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_shear_main', 'numeric(12,4)', 'Column max_shear_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_shear_compare', 'numeric(12,4)', 'Column max_shear_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_shear_diff', 'numeric', 'Column max_shear_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_hr_main', 'numeric(12,4)', 'Column max_hr_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_hr_compare', 'numeric(12,4)', 'Column max_hr_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_hr_diff', 'numeric', 'Column max_hr_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_slope_main', 'numeric(12,4)', 'Column max_slope_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_slope_compare', 'numeric(12,4)', 'Column max_slope_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'max_slope_diff', 'numeric', 'Column max_slope_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'day_max_main', 'varchar(10)', 'Column day_max_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'day_max_compare', 'varchar(10)', 'Column day_max_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_max_main', 'varchar(10)', 'Column time_max_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_max_compare', 'varchar(10)', 'Column time_max_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'min_shear_main', 'numeric(12,4)', 'Column min_shear_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'min_shear_compare', 'numeric(12,4)', 'Column min_shear_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'min_shear_diff', 'numeric', 'Column min_shear_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'day_min_main', 'varchar(10)', 'Column day_min_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'day_min_compare', 'varchar(10)', 'Column day_min_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_min_main', 'varchar(10)', 'Column time_min_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_min_compare', 'varchar(10)', 'Column time_min_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_days_main', 'varchar(10)', 'Column time_days_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_days_compare', 'varchar(10)', 'Column time_days_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_hour_main', 'varchar(10)', 'Column time_hour_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'time_hour_compare', 'varchar(10)', 'Column time_hour_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_arcflow_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
