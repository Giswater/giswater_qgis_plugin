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

-- Check view v_rpt_comp_flowclass_sum
SELECT has_view('v_rpt_comp_flowclass_sum'::name, 'View v_rpt_comp_flowclass_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_flowclass_sum',
    ARRAY[
        'arc_id', 'sector_id', 'arc_type', 'arccat_id', 'result_id_main', 'result_id_compare',
        'length_main', 'length_compare', 'length_diff', 'dry_main', 'dry_compare', 'dry_diff',
        'up_dry_main', 'up_dry_compare', 'up_dry_diff', 'down_dry_main', 'down_dry_compare', 'down_dry_diff',
        'sub_crit_main', 'sub_crit_compare', 'sub_crit_diff', 'sub_crit_1_main', 'sub_crit_1_compare', 'sub_crit_1_diff',
        'up_crit_main', 'up_crit_compare', 'up_crit_diff', 'the_geom'
    ],
    'View v_rpt_comp_flowclass_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'result_id_main', 'varchar(30)', 'Column result_id_main should be varchar(30)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'result_id_compare', 'varchar(30)', 'Column result_id_compare should be varchar(30)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'length_main', 'numeric(12,4)', 'Column length_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'length_compare', 'numeric(12,4)', 'Column length_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'length_diff', 'numeric', 'Column length_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'dry_main', 'numeric(12,4)', 'Column dry_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'dry_compare', 'numeric(12,4)', 'Column dry_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'dry_diff', 'numeric', 'Column dry_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_dry_main', 'numeric(12,4)', 'Column up_dry_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_dry_compare', 'numeric(12,4)', 'Column up_dry_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_dry_diff', 'numeric', 'Column up_dry_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'down_dry_main', 'numeric(12,4)', 'Column down_dry_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'down_dry_compare', 'numeric(12,4)', 'Column down_dry_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'down_dry_diff', 'numeric', 'Column down_dry_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_main', 'numeric(12,4)', 'Column sub_crit_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_compare', 'numeric(12,4)', 'Column sub_crit_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_diff', 'numeric', 'Column sub_crit_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_1_main', 'numeric(12,4)', 'Column sub_crit_1_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_1_compare', 'numeric(12,4)', 'Column sub_crit_1_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'sub_crit_1_diff', 'numeric', 'Column sub_crit_1_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_crit_main', 'numeric(12,4)', 'Column up_crit_main should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_crit_compare', 'numeric(12,4)', 'Column up_crit_compare should be numeric(12,4)');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'up_crit_diff', 'numeric', 'Column up_crit_diff should be numeric');
SELECT col_type_is('v_rpt_comp_flowclass_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
