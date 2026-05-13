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
SELECT has_table('rpt_summary_subcatchment'::name, 'Table rpt_summary_subcatchment should exist');

-- Check columns
SELECT columns_are(
    'rpt_summary_subcatchment',
    ARRAY[
        'id', 'result_id', 'subc_id', 'area', 'width', 'imperv',
        'slope', 'rg_id', 'outlet'
    ],
    'Table rpt_summary_subcatchment should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_summary_subcatchment', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_summary_subcatchment', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_summary_subcatchment', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('rpt_summary_subcatchment', 'area', 'float8', 'Column area should be float8');
SELECT col_type_is('rpt_summary_subcatchment', 'width', 'float8', 'Column width should be float8');
SELECT col_type_is('rpt_summary_subcatchment', 'imperv', 'float8', 'Column imperv should be float8');
SELECT col_type_is('rpt_summary_subcatchment', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('rpt_summary_subcatchment', 'rg_id', 'varchar(16)', 'Column rg_id should be varchar(16)');
SELECT col_type_is('rpt_summary_subcatchment', 'outlet', 'varchar(16)', 'Column outlet should be varchar(16)');

-- Check foreign keys
SELECT has_fk('rpt_summary_subcatchment', 'Table rpt_summary_subcatchment should have foreign keys');

SELECT fk_ok('rpt_summary_subcatchment', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
