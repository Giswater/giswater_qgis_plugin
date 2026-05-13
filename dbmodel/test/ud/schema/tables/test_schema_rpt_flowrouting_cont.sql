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
SELECT has_table('rpt_flowrouting_cont'::name, 'Table rpt_flowrouting_cont should exist');

-- Check columns
SELECT columns_are(
    'rpt_flowrouting_cont',
    ARRAY[
        'id', 'result_id', 'dryw_inf', 'wetw_inf', 'ground_inf', 'rdii_inf',
        'ext_inf', 'ext_out', 'int_out', 'stor_loss', 'initst_vol', 'finst_vol',
        'cont_error', 'evap_losses', 'seepage_losses'
    ],
    'Table rpt_flowrouting_cont should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_flowrouting_cont', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_flowrouting_cont', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_flowrouting_cont', 'dryw_inf', 'numeric(12,4)', 'Column dryw_inf should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'wetw_inf', 'numeric(12,4)', 'Column wetw_inf should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'ground_inf', 'numeric(12,4)', 'Column ground_inf should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'rdii_inf', 'numeric(12,4)', 'Column rdii_inf should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'ext_inf', 'numeric(12,4)', 'Column ext_inf should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'ext_out', 'numeric(12,4)', 'Column ext_out should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'int_out', 'numeric(12,4)', 'Column int_out should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'stor_loss', 'numeric(12,4)', 'Column stor_loss should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'initst_vol', 'numeric(12,4)', 'Column initst_vol should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'finst_vol', 'numeric(12,4)', 'Column finst_vol should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'evap_losses', 'numeric(6,4)', 'Column evap_losses should be numeric(6,4)');
SELECT col_type_is('rpt_flowrouting_cont', 'seepage_losses', 'numeric(6,4)', 'Column seepage_losses should be numeric(6,4)');

-- Check foreign keys
SELECT has_fk('rpt_flowrouting_cont', 'Table rpt_flowrouting_cont should have foreign keys');

SELECT fk_ok('rpt_flowrouting_cont', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
