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

-- Check view v_rpt_qualrouting
SELECT has_view('v_rpt_qualrouting'::name, 'View v_rpt_qualrouting should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_qualrouting',
    ARRAY[
        'id', 'result_id', 'poll_id', 'dryw_inf', 'wetw_inf', 'ground_inf',
        'rdii_inf', 'ext_inf', 'int_inf', 'ext_out', 'mass_reac', 'initst_mas',
        'finst_mas', 'cont_error'
    ],
    'View v_rpt_qualrouting should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_qualrouting', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_qualrouting', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_qualrouting', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('v_rpt_qualrouting', 'dryw_inf', 'numeric(12,4)', 'Column dryw_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'wetw_inf', 'numeric(12,4)', 'Column wetw_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'ground_inf', 'numeric(12,4)', 'Column ground_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'rdii_inf', 'numeric(12,4)', 'Column rdii_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'ext_inf', 'numeric(12,4)', 'Column ext_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'int_inf', 'numeric(12,4)', 'Column int_inf should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'ext_out', 'numeric(12,4)', 'Column ext_out should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'mass_reac', 'numeric(12,4)', 'Column mass_reac should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'initst_mas', 'numeric(12,4)', 'Column initst_mas should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'finst_mas', 'numeric(12,4)', 'Column finst_mas should be numeric(12,4)');
SELECT col_type_is('v_rpt_qualrouting', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');

SELECT * FROM finish();

ROLLBACK;
