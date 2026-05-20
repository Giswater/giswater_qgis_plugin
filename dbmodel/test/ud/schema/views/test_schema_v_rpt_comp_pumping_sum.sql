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

-- Check view v_rpt_comp_pumping_sum
SELECT has_view('v_rpt_comp_pumping_sum'::name, 'View v_rpt_comp_pumping_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_pumping_sum',
    ARRAY[
        'arc_id', 'sector_id', 'arc_type', 'arccat_id', 'result_id_main', 'result_id_compare',
        'percent_main', 'percent_compare', 'percent_diff', 'num_startup_main', 'num_startup_compare', 'num_startup_diff',
        'min_flow_main', 'min_flow_compare', 'min_flow_diff', 'avg_flow_main', 'avg_flow_compare', 'avg_flow_diff',
        'max_flow_main', 'max_flow_compare', 'max_flow_diff', 'vol_ltr_main', 'vol_ltr_compare', 'vol_ltr_diff',
        'powus_kwh_main', 'powus_kwh_compare', 'powus_kwh_diff', 'timoff_min_main', 'timoff_min_compare', 'timoff_min_diff',
        'timoff_max_main', 'timoff_max_compare', 'timoff_max_diff', 'the_geom'
    ],
    'View v_rpt_comp_pumping_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_pumping_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'percent_main', 'numeric(12,4)', 'Column percent_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'percent_compare', 'numeric(12,4)', 'Column percent_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'percent_diff', 'numeric', 'Column percent_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'num_startup_main', 'int4', 'Column num_startup_main should be int4');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'num_startup_compare', 'int4', 'Column num_startup_compare should be int4');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'num_startup_diff', 'int4', 'Column num_startup_diff should be int4');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'min_flow_main', 'numeric(12,4)', 'Column min_flow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'min_flow_compare', 'numeric(12,4)', 'Column min_flow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'min_flow_diff', 'numeric', 'Column min_flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'avg_flow_main', 'numeric(12,4)', 'Column avg_flow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'avg_flow_compare', 'numeric(12,4)', 'Column avg_flow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'avg_flow_diff', 'numeric', 'Column avg_flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'max_flow_main', 'numeric(12,4)', 'Column max_flow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'max_flow_compare', 'numeric(12,4)', 'Column max_flow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'max_flow_diff', 'numeric', 'Column max_flow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'vol_ltr_main', 'numeric(12,4)', 'Column vol_ltr_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'vol_ltr_compare', 'numeric(12,4)', 'Column vol_ltr_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'vol_ltr_diff', 'numeric', 'Column vol_ltr_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'powus_kwh_main', 'numeric(12,4)', 'Column powus_kwh_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'powus_kwh_compare', 'numeric(12,4)', 'Column powus_kwh_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'powus_kwh_diff', 'numeric', 'Column powus_kwh_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_min_main', 'numeric(12,4)', 'Column timoff_min_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_min_compare', 'numeric(12,4)', 'Column timoff_min_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_min_diff', 'numeric', 'Column timoff_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_max_main', 'numeric(12,4)', 'Column timoff_max_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_max_compare', 'numeric(12,4)', 'Column timoff_max_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'timoff_max_diff', 'numeric', 'Column timoff_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_pumping_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
