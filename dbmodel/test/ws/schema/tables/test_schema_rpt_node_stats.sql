/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table rpt_node_stats
SELECT has_table('rpt_node_stats'::name, 'Table rpt_node_stats should exist');

-- Check columns
SELECT columns_are(
    'rpt_node_stats',
    ARRAY[
        'node_id', 'result_id', 'node_type', 'sector_id', 'nodecat_id', 'top_elev', 'demand_max', 'demand_min', 'demand_avg', 
        'head_max', 'head_min', 'head_avg', 'press_max', 'press_min', 'press_avg', 'quality_max', 'quality_min', 'quality_avg', 'the_geom'
    ],
    'Table rpt_node_stats should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_node_stats', ARRAY['node_id', 'result_id'], 'Columns node_id, result_id should be primary key');

-- Check column types
SELECT col_type_is('rpt_node_stats', 'node_id', 'character varying(16)', 'Column node_id should be character varying(16)');
SELECT col_type_is('rpt_node_stats', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('rpt_node_stats', 'node_type', 'character varying(30)', 'Column node_type should be character varying(30)');
SELECT col_type_is('rpt_node_stats', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('rpt_node_stats', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('rpt_node_stats', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('rpt_node_stats', 'demand_max', 'numeric', 'Column demand_max should be numeric');
SELECT col_type_is('rpt_node_stats', 'demand_min', 'numeric', 'Column demand_min should be numeric');
SELECT col_type_is('rpt_node_stats', 'demand_avg', 'numeric(12,2)', 'Column demand_avg should be numeric(12,2)');
SELECT col_type_is('rpt_node_stats', 'head_max', 'numeric', 'Column head_max should be numeric');
SELECT col_type_is('rpt_node_stats', 'head_min', 'numeric', 'Column head_min should be numeric');
SELECT col_type_is('rpt_node_stats', 'head_avg', 'numeric(12,2)', 'Column head_avg should be numeric(12,2)');
SELECT col_type_is('rpt_node_stats', 'press_max', 'numeric', 'Column press_max should be numeric');
SELECT col_type_is('rpt_node_stats', 'press_min', 'numeric', 'Column press_min should be numeric');
SELECT col_type_is('rpt_node_stats', 'press_avg', 'numeric(12,2)', 'Column press_avg should be numeric(12,2)');
SELECT col_type_is('rpt_node_stats', 'quality_max', 'numeric', 'Column quality_max should be numeric');
SELECT col_type_is('rpt_node_stats', 'quality_min', 'numeric', 'Column quality_min should be numeric');
SELECT col_type_is('rpt_node_stats', 'quality_avg', 'numeric(12,2)', 'Column quality_avg should be numeric(12,2)');
SELECT col_type_is('rpt_node_stats', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');

-- Check constraints
SELECT col_not_null('rpt_node_stats', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('rpt_node_stats', 'result_id', 'Column result_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('rpt_node_stats', 'Table rpt_node_stats should have foreign keys');
SELECT fk_ok('rpt_node_stats', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id should reference rpt_cat_result.result_id');

-- Check indexes
SELECT has_index('rpt_node_stats', 'rpt_node_stats_demand_avg', 'Index rpt_node_stats_demand_avg should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_demand_max', 'Index rpt_node_stats_demand_max should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_demand_min', 'Index rpt_node_stats_demand_min should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_geom', 'Index rpt_node_stats_geom should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_head_avg', 'Index rpt_node_stats_head_avg should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_head_max', 'Index rpt_node_stats_head_max should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_head_min', 'Index rpt_node_stats_head_min should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_press_avg', 'Index rpt_node_stats_press_avg should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_press_max', 'Index rpt_node_stats_press_max should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_press_min', 'Index rpt_node_stats_press_min should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_quality_avg', 'Index rpt_node_stats_quality_avg should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_quality_max', 'Index rpt_node_stats_quality_max should exist');
SELECT has_index('rpt_node_stats', 'rpt_node_stats_quality_min', 'Index rpt_node_stats_quality_min should exist');

SELECT * FROM finish();

ROLLBACK; 