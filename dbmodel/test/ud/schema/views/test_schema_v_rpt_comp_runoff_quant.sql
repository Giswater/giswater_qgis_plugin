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

-- Check view v_rpt_comp_runoff_quant
SELECT has_view('v_rpt_comp_runoff_quant'::name, 'View v_rpt_comp_runoff_quant should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_runoff_quant',
    ARRAY[
        'id', 'result_id', 'initsw_co', 'total_prec', 'evap_loss', 'infil_loss',
        'surf_runof', 'snow_re', 'finalsw_co', 'finals_sto', 'cont_error'
    ],
    'View v_rpt_comp_runoff_quant should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_runoff_quant', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'initsw_co', 'numeric(12,4)', 'Column initsw_co should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'total_prec', 'numeric(12,4)', 'Column total_prec should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'evap_loss', 'numeric(12,4)', 'Column evap_loss should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'infil_loss', 'numeric(12,4)', 'Column infil_loss should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'surf_runof', 'numeric(12,4)', 'Column surf_runof should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'snow_re', 'numeric(12,4)', 'Column snow_re should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'finalsw_co', 'numeric(12,4)', 'Column finalsw_co should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'finals_sto', 'numeric(12,4)', 'Column finals_sto should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_runoff_quant', 'cont_error', 'numeric(16,4)', 'Column cont_error should be numeric(16,4)');

SELECT * FROM finish();

ROLLBACK;
