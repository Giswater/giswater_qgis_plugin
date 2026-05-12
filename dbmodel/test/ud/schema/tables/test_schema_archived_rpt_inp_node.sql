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

-- Check table
SELECT has_table('archived_rpt_inp_node'::name, 'Table archived_rpt_inp_node should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_inp_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'ymax', 'elev', 'node_type', 'nodecat_id', 'epa_type',
        'sector_id', 'state', 'state_type', 'annotation', 'y0', 'ysur', 'apond', 'the_geom', 'expl_id',
        'addparam', 'parent', 'arcposition', 'fusioned_node', 'age', 'hour_flood', 'max_rate',
        'flooding_time_days', 'flooding_time_hour', 'tot_flood', 'max_ponded', 'hour_surch', 'max_height',
        'min_depth', 'max_latinf', 'max_totinf', 'inflow_time_days', 'inflow_time_hour', 'latinf_vol',
        'totinf_vol', 'flow_balance_error', 'other_info', 'aver_depth', 'max_depth', 'max_hgl',
        'depth_time_days', 'depth_time_hour', 'flow_freq', 'avg_flow', 'max_flow', 'total_vol', 'poll_id',
        'value', 'aver_vol', 'avg_full', 'ei_loss', 'max_vol', 'max_full', 'storagevol_time_days',
        'storagevol_time_hour', 'max_out'
    ],
    'Table archived_rpt_inp_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_inp_node', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_inp_node', 'id', 'integer', 'Column id should be integer (integer)');
SELECT col_type_is('archived_rpt_inp_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'node_id', 'integer', 'Column node_id should be int4');
SELECT col_type_is('archived_rpt_inp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('archived_rpt_inp_node', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('archived_rpt_inp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('archived_rpt_inp_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'sector_id', 'integer', 'Column sector_id should be int4');
SELECT col_type_is('archived_rpt_inp_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_rpt_inp_node', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('archived_rpt_inp_node', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('archived_rpt_inp_node', 'y0', 'numeric(12,4)', 'Column y0 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'ysur', 'numeric(12,4)', 'Column ysur should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'apond', 'numeric(12,4)', 'Column apond should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('archived_rpt_inp_node', 'expl_id', 'integer', 'Column expl_id should be int4');
SELECT col_type_is('archived_rpt_inp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('archived_rpt_inp_node', 'parent', 'varchar(16)', 'Column parent should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'arcposition', 'int2', 'Column arcposition should be int2');
SELECT col_type_is('archived_rpt_inp_node', 'fusioned_node', 'text', 'Column fusioned_node should be text');
SELECT col_type_is('archived_rpt_inp_node', 'age', 'integer', 'Column age should be int4');
SELECT col_type_is('archived_rpt_inp_node', 'hour_flood', 'numeric(12,4)', 'Column hour_flood should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_rate', 'numeric(12,4)', 'Column max_rate should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'flooding_time_days', 'varchar(10)', 'Column flooding_time_days should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'flooding_time_hour', 'varchar(10)', 'Column flooding_time_hour should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'tot_flood', 'numeric(12,4)', 'Column tot_flood should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_ponded', 'numeric(12,4)', 'Column max_ponded should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'hour_surch', 'numeric(12,4)', 'Column hour_surch should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_height', 'numeric(12,4)', 'Column max_height should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'min_depth', 'numeric(12,4)', 'Column min_depth should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_latinf', 'numeric(12,4)', 'Column max_latinf should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_totinf', 'numeric(12,4)', 'Column max_totinf should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'inflow_time_days', 'varchar(10)', 'Column inflow_time_days should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'inflow_time_hour', 'varchar(10)', 'Column inflow_time_hour should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'latinf_vol', 'numeric(12,4)', 'Column latin_vol should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'totinf_vol', 'numeric(12,4)', 'Column totinf_vol should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'flow_balance_error', 'numeric(12,2)', 'Column flow_balance_error should be numeric(12,2)');
SELECT col_type_is('archived_rpt_inp_node', 'other_info', 'varchar(12)', 'Column other_info should be varchar(12)');
SELECT col_type_is('archived_rpt_inp_node', 'aver_depth', 'numeric(12,4)', 'Column aver_depth should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_depth', 'numeric(12,4)', 'Column max_depth should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_hgl', 'numeric(12,4)', 'Column max_hgl should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'depth_time_days', 'varchar(10)', 'Column depth_time_days should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'depth_time_hour', 'varchar(10)', 'Column depth_time_hour should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'flow_freq', 'numeric(12,4)', 'Column flow_freq should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'avg_flow', 'numeric(12,4)', 'Column avg_flow should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_flow', 'numeric(12,4)', 'Column max_flow should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'total_vol', 'numeric(12,4)', 'Column total_vol should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_node', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'aver_vol', 'numeric(12,4)', 'Column aver_vol should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'avg_full', 'numeric(12,4)', 'Column avg_full should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'ei_loss', 'numeric(12,4)', 'Column ei_loss should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_vol', 'numeric(12,4)', 'Column max_vol should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'max_full', 'numeric(12,4)', 'Column max_full should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_node', 'storagevol_time_days', 'varchar(10)', 'Column storagevol_time_days should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'storagevol_time_hour', 'varchar(10)', 'Column storagevol_time_hour should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_node', 'max_out', 'numeric(12,4)', 'Column max_out should be numeric(12,4)');


-- Check indexes
SELECT has_index('archived_rpt_inp_node', 'archived_rpt_inp_node_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;