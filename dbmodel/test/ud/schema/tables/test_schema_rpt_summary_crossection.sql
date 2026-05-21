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
SELECT has_table('rpt_summary_crossection'::name, 'Table rpt_summary_crossection should exist');

-- Check columns
SELECT columns_are(
    'rpt_summary_crossection',
    ARRAY[
        'id', 'result_id', 'arc_id', 'shape', 'fulldepth', 'fullarea',
        'hydrad', 'maxwidth', 'barrels', 'fullflow'
    ],
    'Table rpt_summary_crossection should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_summary_crossection', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_summary_crossection', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_summary_crossection', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('rpt_summary_crossection', 'shape', 'varchar(16)', 'Column shape should be varchar(16)');
SELECT col_type_is('rpt_summary_crossection', 'fulldepth', 'float8', 'Column fulldepth should be float8');
SELECT col_type_is('rpt_summary_crossection', 'fullarea', 'float8', 'Column fullarea should be float8');
SELECT col_type_is('rpt_summary_crossection', 'hydrad', 'float8', 'Column hydrad should be float8');
SELECT col_type_is('rpt_summary_crossection', 'maxwidth', 'float8', 'Column maxwidth should be float8');
SELECT col_type_is('rpt_summary_crossection', 'barrels', 'int4', 'Column barrels should be int4');
SELECT col_type_is('rpt_summary_crossection', 'fullflow', 'float8', 'Column fullflow should be float8');

-- Check foreign keys
SELECT has_fk('rpt_summary_crossection', 'Table rpt_summary_crossection should have foreign keys');

SELECT fk_ok('rpt_summary_crossection', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
