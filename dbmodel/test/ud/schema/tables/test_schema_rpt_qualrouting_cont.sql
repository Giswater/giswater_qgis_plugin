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
SELECT has_table('rpt_qualrouting_cont'::name, 'Table rpt_qualrouting_cont should exist');

-- Check columns
SELECT columns_are(
    'rpt_qualrouting_cont',
    ARRAY[
        'id', 'result_id', 'poll_id', 'dryw_inf', 'wetw_inf', 'ground_inf',
        'rdii_inf', 'ext_inf', 'int_inf', 'ext_out', 'mass_reac', 'initst_mas',
        'finst_mas', 'cont_error'
    ],
    'Table rpt_qualrouting_cont should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_qualrouting_cont', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_qualrouting_cont', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_qualrouting_cont', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('rpt_qualrouting_cont', 'dryw_inf', 'numeric(12,4)', 'Column dryw_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'wetw_inf', 'numeric(12,4)', 'Column wetw_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'ground_inf', 'numeric(12,4)', 'Column ground_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'rdii_inf', 'numeric(12,4)', 'Column rdii_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'ext_inf', 'numeric(12,4)', 'Column ext_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'int_inf', 'numeric(12,4)', 'Column int_inf should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'ext_out', 'numeric(12,4)', 'Column ext_out should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'mass_reac', 'numeric(12,4)', 'Column mass_reac should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'initst_mas', 'numeric(12,4)', 'Column initst_mas should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'finst_mas', 'numeric(12,4)', 'Column finst_mas should be numeric(12,4)');
SELECT col_type_is('rpt_qualrouting_cont', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_qualrouting_cont', 'Table rpt_qualrouting_cont should have foreign keys');

SELECT fk_ok('rpt_qualrouting_cont', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
