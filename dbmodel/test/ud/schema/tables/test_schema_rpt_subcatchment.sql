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
SELECT has_table('rpt_subcatchment'::name, 'Table rpt_subcatchment should exist');

-- Check columns
SELECT columns_are(
    'rpt_subcatchment',
    ARRAY[
        'id', 'result_id', 'subc_id', 'resultdate', 'resulttime', 'precip',
        'losses', 'runoff'
    ],
    'Table rpt_subcatchment should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_subcatchment', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('rpt_subcatchment', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_subcatchment', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('rpt_subcatchment', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('rpt_subcatchment', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('rpt_subcatchment', 'precip', 'float8', 'Column precip should be float8');
SELECT col_type_is('rpt_subcatchment', 'losses', 'float8', 'Column losses should be float8');
SELECT col_type_is('rpt_subcatchment', 'runoff', 'float8', 'Column runoff should be float8');

-- Check foreign keys
SELECT has_fk('rpt_subcatchment', 'Table rpt_subcatchment should have foreign keys');

SELECT fk_ok('rpt_subcatchment', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');
SELECT fk_ok('rpt_subcatchment', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
