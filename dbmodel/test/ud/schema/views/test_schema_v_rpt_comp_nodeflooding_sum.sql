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

-- Check view v_rpt_comp_nodeflooding_sum
SELECT has_view('v_rpt_comp_nodeflooding_sum'::name, 'View v_rpt_comp_nodeflooding_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_nodeflooding_sum',
    ARRAY[
        'node_id', 'sector_id', 'node_type', 'nodecat_id', 'result_id_main', 'result_id_compare',
        'hour_flood_main', 'hour_flood_compare', 'hour_flood_diff', 'max_rate_main', 'max_rate_compare', 'max_rate_diff',
        'tot_flood_main', 'tot_flood_compare', 'tot_flood_diff', 'max_ponded_main', 'max_ponded_compare', 'max_ponded_diff',
        'time_days_main', 'time_days_compare', 'time_hour_main', 'time_hour_compare', 'the_geom'
    ],
    'View v_rpt_comp_nodeflooding_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'hour_flood_main', 'numeric(12,4)', 'Column hour_flood_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'hour_flood_compare', 'numeric(12,4)', 'Column hour_flood_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'hour_flood_diff', 'numeric', 'Column hour_flood_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_rate_main', 'numeric(12,4)', 'Column max_rate_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_rate_compare', 'numeric(12,4)', 'Column max_rate_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_rate_diff', 'numeric', 'Column max_rate_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'tot_flood_main', 'numeric(12,4)', 'Column tot_flood_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'tot_flood_compare', 'numeric(12,4)', 'Column tot_flood_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'tot_flood_diff', 'numeric', 'Column tot_flood_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_ponded_main', 'numeric(12,4)', 'Column max_ponded_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_ponded_compare', 'numeric(12,4)', 'Column max_ponded_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'max_ponded_diff', 'numeric', 'Column max_ponded_diff should be numeric');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'time_days_main', 'varchar(10)', 'Column time_days_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'time_days_compare', 'varchar(10)', 'Column time_days_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'time_hour_main', 'varchar(10)', 'Column time_hour_main should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'time_hour_compare', 'varchar(10)', 'Column time_hour_compare should be varchar(10)');
SELECT col_type_is('v_rpt_comp_nodeflooding_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
