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

-- Check view v_rpt_comp_nodeinflow_sum
SELECT has_view('v_rpt_comp_nodeinflow_sum'::name, 'View v_rpt_comp_nodeinflow_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_nodeinflow_sum',
    ARRAY[
        'node_id', 'sector_id', 'node_type', 'nodecat_id', 'swnod_type', 'result_id_main',
        'result_id_compare', 'max_latinf_main', 'max_latinf_compare', 'max_latinf_diff', 'max_totinf_main', 'max_totinf_compare',
        'max_totinf_diff', 'latinf_vol_main', 'latinf_vol_compare', 'latinf_vol_diff', 'totninf_vol_main', 'totninf_vol_compare',
        'totninf_vol_diff', 'flow_balance_error_main', 'flow_balance_error_compare', 'flow_balance_error_diff', 'time_days_main', 'time_days_compare',
        'time_hour_main', 'time_hour_compare', 'the_geom'
    ],
    'View v_rpt_comp_nodeinflow_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_latinf_main', 'numeric(12,4)', 'Column max_latinf_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_latinf_compare', 'numeric(12,4)', 'Column max_latinf_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_latinf_diff', 'numeric', 'Column max_latinf_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_totinf_main', 'numeric(12,4)', 'Column max_totinf_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_totinf_compare', 'numeric(12,4)', 'Column max_totinf_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'max_totinf_diff', 'numeric', 'Column max_totinf_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'latinf_vol_main', 'numeric(12,4)', 'Column latinf_vol_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'latinf_vol_compare', 'numeric(12,4)', 'Column latinf_vol_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'latinf_vol_diff', 'numeric', 'Column latinf_vol_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'totninf_vol_main', 'numeric(12,4)', 'Column totninf_vol_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'totninf_vol_compare', 'numeric(12,4)', 'Column totninf_vol_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'totninf_vol_diff', 'numeric', 'Column totninf_vol_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'flow_balance_error_main', 'numeric(12,2)', 'Column flow_balance_error_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'flow_balance_error_compare', 'numeric(12,2)', 'Column flow_balance_error_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'flow_balance_error_diff', 'numeric', 'Column flow_balance_error_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'time_days_main', 'varchar(10)', 'Column time_days_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'time_days_compare', 'varchar(10)', 'Column time_days_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'time_hour_main', 'varchar(10)', 'Column time_hour_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'time_hour_compare', 'varchar(10)', 'Column time_hour_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeinflow_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
