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

-- Check view v_rpt_comp_nodedepth_sum
SELECT has_view('v_rpt_comp_nodedepth_sum'::name, 'View v_rpt_comp_nodedepth_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_nodedepth_sum',
    ARRAY[
        'node_id', 'sector_id', 'node_type', 'nodecat_id', 'swnod_type', 'result_id_main',
        'result_id_compare', 'aver_depth_main', 'aver_depth_compare', 'aver_depth_diff', 'max_depth_main', 'max_depth_compare',
        'max_depth_diff', 'max_hgl_main', 'max_hgl_compare', 'max_hgl_diff', 'time_days_main', 'time_days_compare',
        'time_hour_main', 'time_hour_compare', 'the_geom'
    ],
    'View v_rpt_comp_nodedepth_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'aver_depth_main', 'numeric(12,4)', 'Column aver_depth_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'aver_depth_compare', 'numeric(12,4)', 'Column aver_depth_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'aver_depth_diff', 'numeric', 'Column aver_depth_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_depth_main', 'numeric(12,4)', 'Column max_depth_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_depth_compare', 'numeric(12,4)', 'Column max_depth_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_depth_diff', 'numeric', 'Column max_depth_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_hgl_main', 'numeric(12,4)', 'Column max_hgl_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_hgl_compare', 'numeric(12,4)', 'Column max_hgl_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'max_hgl_diff', 'numeric', 'Column max_hgl_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'time_days_main', 'varchar(10)', 'Column time_days_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'time_days_compare', 'varchar(10)', 'Column time_days_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'time_hour_main', 'varchar(10)', 'Column time_hour_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'time_hour_compare', 'varchar(10)', 'Column time_hour_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodedepth_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
