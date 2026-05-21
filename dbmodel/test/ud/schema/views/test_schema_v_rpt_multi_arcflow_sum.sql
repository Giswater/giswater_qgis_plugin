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

-- Check view v_rpt_multi_arcflow_sum
SELECT has_view('v_rpt_multi_arcflow_sum'::name, 'View v_rpt_multi_arcflow_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_multi_arcflow_sum',
    ARRAY[
        'id', 'arc_id', 'result_id', 'arc_type', 'arccat_id', 'sector_id',
        'the_geom', 'swarc_type', 'max_flow', 'time_days', 'time_hour', 'max_veloc',
        'mfull_flow', 'mfull_depth', 'max_shear', 'max_hr', 'max_slope', 'day_max',
        'time_max', 'min_shear', 'day_min', 'swartime_minc_type'
    ],
    'View v_rpt_multi_arcflow_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'swarc_type', 'varchar(18)', 'Column swarc_type should be varchar(18)');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'max_flow', 'numeric', 'Column max_flow should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'time_days', 'text', 'Column time_days should be text');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'time_hour', 'text', 'Column time_hour should be text');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'max_veloc', 'numeric', 'Column max_veloc should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'mfull_flow', 'numeric', 'Column mfull_flow should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'mfull_depth', 'numeric', 'Column mfull_depth should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'max_shear', 'numeric', 'Column max_shear should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'max_hr', 'numeric', 'Column max_hr should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'max_slope', 'numeric', 'Column max_slope should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'day_max', 'text', 'Column day_max should be text');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'time_max', 'text', 'Column time_max should be text');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'min_shear', 'numeric', 'Column min_shear should be numeric');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'day_min', 'text', 'Column day_min should be text');
SELECT col_type_is('v_rpt_multi_arcflow_sum', 'swartime_minc_type', 'text', 'Column swartime_minc_type should be text');

SELECT * FROM finish();

ROLLBACK;
