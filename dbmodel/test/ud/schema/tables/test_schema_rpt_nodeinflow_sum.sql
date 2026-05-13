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
SELECT has_table('rpt_nodeinflow_sum'::name, 'Table rpt_nodeinflow_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_nodeinflow_sum',
    ARRAY[
        'id', 'result_id', 'node_id', 'swnod_type', 'max_latinf', 'max_totinf',
        'time_days', 'time_hour', 'latinf_vol', 'totinf_vol', 'flow_balance_error', 'other_info'
    ],
    'Table rpt_nodeinflow_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_nodeinflow_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_nodeinflow_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_nodeinflow_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('rpt_nodeinflow_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('rpt_nodeinflow_sum', 'max_latinf', 'numeric(12,4)', 'Column max_latinf should be numeric(12,4)');
SELECT col_type_is('rpt_nodeinflow_sum', 'max_totinf', 'numeric(12,4)', 'Column max_totinf should be numeric(12,4)');
SELECT col_type_is('rpt_nodeinflow_sum', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('rpt_nodeinflow_sum', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');
SELECT col_type_is('rpt_nodeinflow_sum', 'latinf_vol', 'numeric(12,4)', 'Column latinf_vol should be numeric(12,4)');
SELECT col_type_is('rpt_nodeinflow_sum', 'totinf_vol', 'numeric(12,4)', 'Column totinf_vol should be numeric(12,4)');
SELECT col_type_is('rpt_nodeinflow_sum', 'flow_balance_error', 'numeric(12,2)', 'Column flow_balance_error should be numeric(12,2)');
SELECT col_type_is('rpt_nodeinflow_sum', 'other_info', 'varchar(12)', 'Column other_info should be varchar(12)');

-- Check foreign keys
SELECT has_fk('rpt_nodeinflow_sum', 'Table rpt_nodeinflow_sum should have foreign keys');

SELECT fk_ok('rpt_nodeinflow_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
