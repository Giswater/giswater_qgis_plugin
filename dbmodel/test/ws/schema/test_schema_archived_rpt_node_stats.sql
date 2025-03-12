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

-- Check table archived_rpt_node_stats
SELECT has_table('archived_rpt_node_stats'::name, 'Table archived_rpt_node_stats should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_node_stats',
    ARRAY[
        'node_id', 'result_id', 'node_type', 'sector_id', 'nodecat_id', 'top_elev', 'demand_max', 'demand_min', 'demand_avg',
        'head_max', 'head_min', 'head_avg', 'press_max', 'press_min', 'press_avg', 'quality_max', 'quality_min', 'quality_avg',
        'the_geom'
    ],
    'Table archived_rpt_node_stats should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_node_stats', ARRAY['node_id', 'result_id'], 'Columns node_id, result_id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_node_stats', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('archived_rpt_node_stats', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_node_stats', 'node_type', 'character varying(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('archived_rpt_node_stats', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_rpt_node_stats', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('archived_rpt_node_stats', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'demand_max', 'numeric', 'Column demand_max should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'demand_min', 'numeric', 'Column demand_min should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'demand_avg', 'numeric(12,2)', 'Column demand_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_node_stats', 'head_max', 'numeric', 'Column head_max should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'head_min', 'numeric', 'Column head_min should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'head_avg', 'numeric(12,2)', 'Column head_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_node_stats', 'press_max', 'numeric', 'Column press_max should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'press_min', 'numeric', 'Column press_min should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'press_avg', 'numeric(12,2)', 'Column press_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_node_stats', 'quality_max', 'numeric', 'Column quality_max should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'quality_min', 'numeric', 'Column quality_min should be numeric');
SELECT col_type_is('archived_rpt_node_stats', 'quality_avg', 'numeric(12,2)', 'Column quality_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_node_stats', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');

-- Check foreign keys
SELECT has_fk('archived_rpt_node_stats', 'Table archived_rpt_node_stats should have foreign keys');
SELECT fk_ok('archived_rpt_node_stats', ARRAY['result_id'], 'rpt_cat_result', ARRAY['result_id'], 'Table should have foreign key from result_id to rpt_cat_result.result_id');

-- Check triggers

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
