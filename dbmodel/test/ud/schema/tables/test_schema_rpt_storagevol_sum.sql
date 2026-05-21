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
SELECT has_table('rpt_storagevol_sum'::name, 'Table rpt_storagevol_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_storagevol_sum',
    ARRAY[
        'id', 'result_id', 'node_id', 'aver_vol', 'avg_full', 'ei_loss',
        'max_vol', 'max_full', 'time_days', 'time_hour', 'max_out'
    ],
    'Table rpt_storagevol_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_storagevol_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_storagevol_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_storagevol_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('rpt_storagevol_sum', 'aver_vol', 'numeric(12,4)', 'Column aver_vol should be numeric(12,4)');
SELECT col_type_is('rpt_storagevol_sum', 'avg_full', 'numeric(12,4)', 'Column avg_full should be numeric(12,4)');
SELECT col_type_is('rpt_storagevol_sum', 'ei_loss', 'numeric(12,4)', 'Column ei_loss should be numeric(12,4)');
SELECT col_type_is('rpt_storagevol_sum', 'max_vol', 'numeric(12,4)', 'Column max_vol should be numeric(12,4)');
SELECT col_type_is('rpt_storagevol_sum', 'max_full', 'numeric(12,4)', 'Column max_full should be numeric(12,4)');
SELECT col_type_is('rpt_storagevol_sum', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('rpt_storagevol_sum', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');
SELECT col_type_is('rpt_storagevol_sum', 'max_out', 'numeric(12,4)', 'Column max_out should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_storagevol_sum', 'Table rpt_storagevol_sum should have foreign keys');

SELECT fk_ok('rpt_storagevol_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
