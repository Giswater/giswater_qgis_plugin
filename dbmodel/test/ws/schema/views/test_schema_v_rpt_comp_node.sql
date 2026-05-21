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

-- Check view v_rpt_comp_node
SELECT has_view('v_rpt_comp_node'::name, 'View v_rpt_comp_node should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_node',
    ARRAY[
        'node_id', 'node_type', 'sector_id', 'nodecat_id', 'result_id_main', 'result_id_compare',
        'top_elev', 'demand_max_main', 'demand_max_compare', 'demand_max_diff', 'demand_min_main', 'demand_min_compare',
        'demand_min_diff', 'demand_avg_main', 'demand_avg_compare', 'demand_avg_diff', 'head_max_main', 'head_max_compare',
        'head_max_diff', 'head_min_main', 'head_min_compare', 'head_min_diff', 'head_avg_main', 'head_avg_compare',
        'head_avg_diff', 'press_max_main', 'press_max_compare', 'press_max_diff', 'press_min_main', 'press_min_compare',
        'press_min_diff', 'press_avg_main', 'press_avg_compare', 'press_avg_diff', 'quality_max_main', 'quality_max_compare',
        'quality_max_diff', 'quality_min_main', 'quality_min_compare', 'quality_min_diff', 'quality_avg_main', 'quality_avg_compare',
        'quality_avg_diff', 'the_geom'
    ],
    'View v_rpt_comp_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_comp_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_node', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_max_main', 'numeric', 'Column demand_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_max_compare', 'numeric', 'Column demand_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_max_diff', 'numeric', 'Column demand_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_min_main', 'numeric', 'Column demand_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_min_compare', 'numeric', 'Column demand_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_min_diff', 'numeric', 'Column demand_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'demand_avg_main', 'numeric(12,2)', 'Column demand_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'demand_avg_compare', 'numeric(12,2)', 'Column demand_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'demand_avg_diff', 'numeric', 'Column demand_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_max_main', 'numeric', 'Column head_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_max_compare', 'numeric', 'Column head_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_max_diff', 'numeric', 'Column head_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_min_main', 'numeric', 'Column head_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_min_compare', 'numeric', 'Column head_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_min_diff', 'numeric', 'Column head_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'head_avg_main', 'numeric(12,2)', 'Column head_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'head_avg_compare', 'numeric(12,2)', 'Column head_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'head_avg_diff', 'numeric', 'Column head_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_max_main', 'numeric', 'Column press_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_max_compare', 'numeric', 'Column press_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_max_diff', 'numeric', 'Column press_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_min_main', 'numeric', 'Column press_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_min_compare', 'numeric', 'Column press_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_min_diff', 'numeric', 'Column press_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'press_avg_main', 'numeric(12,2)', 'Column press_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'press_avg_compare', 'numeric(12,2)', 'Column press_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'press_avg_diff', 'numeric', 'Column press_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_max_main', 'numeric', 'Column quality_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_max_compare', 'numeric', 'Column quality_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_max_diff', 'numeric', 'Column quality_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_min_main', 'numeric', 'Column quality_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_min_compare', 'numeric', 'Column quality_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_min_diff', 'numeric', 'Column quality_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'quality_avg_main', 'numeric(12,2)', 'Column quality_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'quality_avg_compare', 'numeric(12,2)', 'Column quality_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_node', 'quality_avg_diff', 'numeric', 'Column quality_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
