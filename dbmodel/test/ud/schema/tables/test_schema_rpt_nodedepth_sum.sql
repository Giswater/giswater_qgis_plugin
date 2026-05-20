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
SELECT has_table('rpt_nodedepth_sum'::name, 'Table rpt_nodedepth_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_nodedepth_sum',
    ARRAY[
        'id', 'result_id', 'node_id', 'swnod_type', 'aver_depth', 'max_depth',
        'max_hgl', 'time_days', 'time_hour'
    ],
    'Table rpt_nodedepth_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_nodedepth_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_nodedepth_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_nodedepth_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('rpt_nodedepth_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('rpt_nodedepth_sum', 'aver_depth', 'numeric(12,4)', 'Column aver_depth should be numeric(12,4)');
SELECT col_type_is('rpt_nodedepth_sum', 'max_depth', 'numeric(12,4)', 'Column max_depth should be numeric(12,4)');
SELECT col_type_is('rpt_nodedepth_sum', 'max_hgl', 'numeric(12,4)', 'Column max_hgl should be numeric(12,4)');
SELECT col_type_is('rpt_nodedepth_sum', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('rpt_nodedepth_sum', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');

-- Check foreign keys
SELECT has_fk('rpt_nodedepth_sum', 'Table rpt_nodedepth_sum should have foreign keys');

SELECT fk_ok('rpt_nodedepth_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
