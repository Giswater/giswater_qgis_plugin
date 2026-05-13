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
SELECT has_table('rpt_summary_arc'::name, 'Table rpt_summary_arc should exist');

-- Check columns
SELECT columns_are(
    'rpt_summary_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'epa_type',
        'length', 'slope', 'roughness'
    ],
    'Table rpt_summary_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_summary_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_summary_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_summary_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('rpt_summary_arc', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('rpt_summary_arc', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('rpt_summary_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('rpt_summary_arc', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('rpt_summary_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('rpt_summary_arc', 'roughness', 'float8', 'Column roughness should be float8');

-- Check foreign keys
SELECT has_fk('rpt_summary_arc', 'Table rpt_summary_arc should have foreign keys');

SELECT fk_ok('rpt_summary_arc', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
