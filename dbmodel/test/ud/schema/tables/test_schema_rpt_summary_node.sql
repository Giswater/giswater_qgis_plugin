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
SELECT has_table('rpt_summary_node'::name, 'Table rpt_summary_node should exist');

-- Check columns
SELECT columns_are(
    'rpt_summary_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'epa_type', 'elevation', 'maxdepth',
        'pondedarea', 'externalinf'
    ],
    'Table rpt_summary_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_summary_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_summary_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_summary_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('rpt_summary_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('rpt_summary_node', 'elevation', 'float8', 'Column elevation should be float8');
SELECT col_type_is('rpt_summary_node', 'maxdepth', 'float8', 'Column maxdepth should be float8');
SELECT col_type_is('rpt_summary_node', 'pondedarea', 'float8', 'Column pondedarea should be float8');
SELECT col_type_is('rpt_summary_node', 'externalinf', 'varchar(16)', 'Column externalinf should be varchar(16)');

-- Check foreign keys
SELECT has_fk('rpt_summary_node', 'Table rpt_summary_node should have foreign keys');

SELECT fk_ok('rpt_summary_node', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
