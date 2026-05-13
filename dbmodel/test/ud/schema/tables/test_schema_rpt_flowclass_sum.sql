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
SELECT has_table('rpt_flowclass_sum'::name, 'Table rpt_flowclass_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_flowclass_sum',
    ARRAY[
        'id', 'result_id', 'arc_id', 'length', 'dry', 'up_dry',
        'down_dry', 'sub_crit', 'sub_crit_1', 'up_crit', 'down_crit', 'froud_numb',
        'flow_chang'
    ],
    'Table rpt_flowclass_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_flowclass_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_flowclass_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_flowclass_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('rpt_flowclass_sum', 'length', 'numeric(12,4)', 'Column length should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'dry', 'numeric(12,4)', 'Column dry should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'up_dry', 'numeric(12,4)', 'Column up_dry should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'down_dry', 'numeric(12,4)', 'Column down_dry should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'sub_crit', 'numeric(12,4)', 'Column sub_crit should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'sub_crit_1', 'numeric(12,4)', 'Column sub_crit_1 should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'up_crit', 'numeric(12,4)', 'Column up_crit should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'down_crit', 'numeric(12,4)', 'Column down_crit should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'froud_numb', 'numeric(12,4)', 'Column froud_numb should be numeric(12,4)');
SELECT col_type_is('rpt_flowclass_sum', 'flow_chang', 'numeric(12,4)', 'Column flow_chang should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_flowclass_sum', 'Table rpt_flowclass_sum should have foreign keys');

SELECT fk_ok('rpt_flowclass_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
