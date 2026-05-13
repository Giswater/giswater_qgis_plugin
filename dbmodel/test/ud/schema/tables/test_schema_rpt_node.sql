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
SELECT has_table('rpt_node'::name, 'Table rpt_node should exist');

-- Check columns
SELECT columns_are(
    'rpt_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'resultdate', 'resulttime', 'flooding',
        'depth', 'head', 'inflow'
    ],
    'Table rpt_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_node', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('rpt_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('rpt_node', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('rpt_node', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('rpt_node', 'flooding', 'float8', 'Column flooding should be float8');
SELECT col_type_is('rpt_node', 'depth', 'float8', 'Column depth should be float8');
SELECT col_type_is('rpt_node', 'head', 'float8', 'Column head should be float8');
SELECT col_type_is('rpt_node', 'inflow', 'numeric(12,3)', 'Column inflow should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('rpt_node', 'Table rpt_node should have foreign keys');

SELECT fk_ok('rpt_node', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');
SELECT fk_ok('rpt_node', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
