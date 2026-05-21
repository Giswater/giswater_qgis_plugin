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

-- Check view v_rpt_comp_node_hourly
SELECT has_view('v_rpt_comp_node_hourly'::name, 'View v_rpt_comp_node_hourly should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_node_hourly',
    ARRAY[
        'node_id', 'sector_id', 'top_elev', 'result_id_main', 'result_id_compare', 'time_main',
        'time_compare', 'demand_main', 'demand_compare', 'demand_diff', 'head_main', 'head_compare',
        'head_diff', 'press_main', 'press_compare', 'press_diff', 'quality_main', 'quality_compare',
        'quality_diff', 'the_geom'
    ],
    'View v_rpt_comp_node_hourly should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_node_hourly', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_node_hourly', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'time_main', 'varchar(100)', 'Column time_main should be varchar(100)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'time_compare', 'varchar(100)', 'Column time_compare should be varchar(100)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'demand_main', 'numeric', 'Column demand_main should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'demand_compare', 'numeric', 'Column demand_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'demand_diff', 'numeric', 'Column demand_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'head_main', 'numeric', 'Column head_main should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'head_compare', 'numeric', 'Column head_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'head_diff', 'numeric', 'Column head_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'press_main', 'numeric', 'Column press_main should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'press_compare', 'numeric', 'Column press_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'press_diff', 'numeric', 'Column press_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'quality_main', 'numeric(12,4)', 'Column quality_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'quality_compare', 'numeric(12,4)', 'Column quality_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_node_hourly', 'quality_diff', 'numeric', 'Column quality_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node_hourly', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
