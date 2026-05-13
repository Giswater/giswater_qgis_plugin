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

-- Check view v_rpt_comp_nodesurcharge_sum
SELECT has_view('v_rpt_comp_nodesurcharge_sum'::name, 'View v_rpt_comp_nodesurcharge_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_nodesurcharge_sum',
    ARRAY[
        'node_id', 'sector_id', 'node_type', 'nodecat_id', 'swnod_type', 'result_id_main',
        'result_id_compare', 'hour_surch_main', 'hour_surch_compare', 'hour_surch_diff', 'max_height_main', 'max_height_compare',
        'max_height_diff', 'min_depth_main', 'min_depth_compare', 'min_depth_diff', 'the_geom'
    ],
    'View v_rpt_comp_nodesurcharge_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'hour_surch_main', 'numeric(12,4)', 'Column hour_surch_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'hour_surch_compare', 'numeric(12,4)', 'Column hour_surch_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'hour_surch_diff', 'numeric', 'Column hour_surch_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'max_height_main', 'numeric(12,4)', 'Column max_height_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'max_height_compare', 'numeric(12,4)', 'Column max_height_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'max_height_diff', 'numeric', 'Column max_height_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'min_depth_main', 'numeric(12,4)', 'Column min_depth_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'min_depth_compare', 'numeric(12,4)', 'Column min_depth_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'min_depth_diff', 'numeric', 'Column min_depth_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodesurcharge_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
