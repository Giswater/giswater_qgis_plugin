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

-- Check view v_rpt_comp_condsurcharge_sum
SELECT has_view('v_rpt_comp_condsurcharge_sum'::name, 'View v_rpt_comp_condsurcharge_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_condsurcharge_sum',
    ARRAY[
        'arc_id', 'sector_id', 'arc_type', 'arccat_id', 'result_id_main', 'result_id_compare',
        'both_ends_main', 'both_ends_compare', 'both_ends_diff', 'upstream_main', 'upstream_compare', 'upstream_diff',
        'dnstream_main', 'dnstream_compare', 'dnstream_diff', 'hour_nflow_main', 'hour_nflow_compare', 'hour_nflow_diff',
        'hour_limit_main', 'hour_limit_compare', 'hour_limit_diff', 'the_geom'
    ],
    'View v_rpt_comp_condsurcharge_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'arc_id', 'varchar', 'Column arc_id should be varchar');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'both_ends_main', 'numeric(12,4)', 'Column both_ends_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'both_ends_compare', 'numeric(12,4)', 'Column both_ends_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'both_ends_diff', 'numeric', 'Column both_ends_diff should be numeric');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'upstream_main', 'numeric(12,4)', 'Column upstream_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'upstream_compare', 'numeric(12,4)', 'Column upstream_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'upstream_diff', 'numeric', 'Column upstream_diff should be numeric');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'dnstream_main', 'numeric(12,4)', 'Column dnstream_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'dnstream_compare', 'numeric(12,4)', 'Column dnstream_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'dnstream_diff', 'numeric', 'Column dnstream_diff should be numeric');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_nflow_main', 'numeric(12,4)', 'Column hour_nflow_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_nflow_compare', 'numeric(12,4)', 'Column hour_nflow_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_nflow_diff', 'numeric', 'Column hour_nflow_diff should be numeric');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_limit_main', 'numeric(12,4)', 'Column hour_limit_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_limit_compare', 'numeric(12,4)', 'Column hour_limit_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'hour_limit_diff', 'numeric', 'Column hour_limit_diff should be numeric');
SELECT col_type_is('v_rpt_comp_condsurcharge_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
