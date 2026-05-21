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
SELECT has_table('rpt_arc'::name, 'Table rpt_arc should exist');

-- Check columns
SELECT columns_are(
    'rpt_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'resultdate', 'resulttime', 'flow',
        'velocity', 'fullpercent'
    ],
    'Table rpt_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_arc', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('rpt_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('rpt_arc', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('rpt_arc', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('rpt_arc', 'flow', 'float8', 'Column flow should be float8');
SELECT col_type_is('rpt_arc', 'velocity', 'float8', 'Column velocity should be float8');
SELECT col_type_is('rpt_arc', 'fullpercent', 'float8', 'Column fullpercent should be float8');

-- Check foreign keys
SELECT has_fk('rpt_arc', 'Table rpt_arc should have foreign keys');

SELECT fk_ok('rpt_arc', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');
SELECT fk_ok('rpt_arc', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
