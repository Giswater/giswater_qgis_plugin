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

-- Check view v_rpt_runoff_qual
SELECT has_view('v_rpt_runoff_qual'::name, 'View v_rpt_runoff_qual should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_runoff_qual',
    ARRAY[
        'id', 'result_id', 'poll_id', 'init_buil', 'surf_buil', 'wet_dep',
        'sweep_re', 'infil_loss', 'bmp_re', 'surf_runof', 'rem_buil', 'cont_error'
    ],
    'View v_rpt_runoff_qual should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_runoff_qual', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_runoff_qual', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_runoff_qual', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('v_rpt_runoff_qual', 'init_buil', 'numeric(12,4)', 'Column init_buil should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'surf_buil', 'numeric(12,4)', 'Column surf_buil should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'wet_dep', 'numeric(12,4)', 'Column wet_dep should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'sweep_re', 'numeric(12,4)', 'Column sweep_re should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'infil_loss', 'numeric(12,4)', 'Column infil_loss should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'bmp_re', 'numeric(12,4)', 'Column bmp_re should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'surf_runof', 'numeric(12,4)', 'Column surf_runof should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'rem_buil', 'numeric(12,4)', 'Column rem_buil should be numeric(12,4)');
SELECT col_type_is('v_rpt_runoff_qual', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');

SELECT * FROM finish();

ROLLBACK;
