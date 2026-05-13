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
SELECT has_table('rpt_outfallflow_sum'::name, 'Table rpt_outfallflow_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_outfallflow_sum',
    ARRAY[
        'id', 'result_id', 'node_id', 'flow_freq', 'avg_flow', 'max_flow',
        'total_vol'
    ],
    'Table rpt_outfallflow_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_outfallflow_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_outfallflow_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_outfallflow_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('rpt_outfallflow_sum', 'flow_freq', 'numeric(12,4)', 'Column flow_freq should be numeric(12,4)');
SELECT col_type_is('rpt_outfallflow_sum', 'avg_flow', 'numeric(12,4)', 'Column avg_flow should be numeric(12,4)');
SELECT col_type_is('rpt_outfallflow_sum', 'max_flow', 'numeric(12,4)', 'Column max_flow should be numeric(12,4)');
SELECT col_type_is('rpt_outfallflow_sum', 'total_vol', 'numeric(12,4)', 'Column total_vol should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_outfallflow_sum', 'Table rpt_outfallflow_sum should have foreign keys');

SELECT fk_ok('rpt_outfallflow_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
