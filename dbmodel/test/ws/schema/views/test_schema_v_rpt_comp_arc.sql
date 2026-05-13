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

-- Check view v_rpt_comp_arc
SELECT has_view('v_rpt_comp_arc'::name, 'View v_rpt_comp_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_comp_arc',
    ARRAY[
        'arc_id', 'arc_type', 'sector_id', 'arccat_id', 'main_result', 'compare_result',
        'flow_max_main', 'flow_max_compare', 'flow_max_diff', 'flow_min_main', 'flow_min_compare', 'flow_min_diff',
        'flow_avg_main', 'flow_avg_compare', 'flow_avg_diff', 'vel_max_main', 'vel_max_compare', 'vel_max_diff',
        'vel_min_main', 'vel_min_compare', 'vel_min_diff', 'vel_avg_main', 'vel_avg_compare', 'vel_avg_diff',
        'headloss_max_main', 'headloss_max_compare', 'headloss_max_diff', 'headloss_min_main', 'headloss_min_compare', 'headloss_min_diff',
        'setting_max_main', 'setting_max_compare', 'setting_max_diff', 'setting_min_main', 'setting_min_compare', 'setting_min_diff',
        'reaction_max_main', 'reaction_max_compare', 'reaction_max_diff', 'reaction_min_main', 'reaction_min_compare', 'reaction_min_diff',
        'ffactor_max_main', 'ffactor_max_compare', 'ffactor_max_diff', 'ffactor_min_main', 'ffactor_min_compare', 'ffactor_min_diff',
        'diameter_main', 'diameter_compare', 'diameter_diff', 'the_geom'
    ],
    'View v_rpt_comp_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_comp_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_comp_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_comp_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc', 'main_result', 'varchar(30)', 'Column main_result should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc', 'compare_result', 'varchar(30)', 'Column compare_result should be varchar(30)');
SELECT col_type_is('v_rpt_comp_arc', 'flow_max_main', 'numeric', 'Column flow_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_max_compare', 'numeric', 'Column flow_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_max_diff', 'numeric', 'Column flow_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_min_main', 'numeric', 'Column flow_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_min_compare', 'numeric', 'Column flow_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_min_diff', 'numeric', 'Column flow_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'flow_avg_main', 'numeric(12,2)', 'Column flow_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_arc', 'flow_avg_compare', 'numeric(12,2)', 'Column flow_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_arc', 'flow_avg_diff', 'numeric', 'Column flow_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_max_main', 'numeric', 'Column vel_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_max_compare', 'numeric', 'Column vel_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_max_diff', 'numeric', 'Column vel_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_min_main', 'numeric', 'Column vel_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_min_compare', 'numeric', 'Column vel_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_min_diff', 'numeric', 'Column vel_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'vel_avg_main', 'numeric(12,2)', 'Column vel_avg_main should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_arc', 'vel_avg_compare', 'numeric(12,2)', 'Column vel_avg_compare should be numeric(12,2)');
SELECT col_type_is('v_rpt_comp_arc', 'vel_avg_diff', 'numeric', 'Column vel_avg_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_max_main', 'numeric', 'Column headloss_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_max_compare', 'numeric', 'Column headloss_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_max_diff', 'numeric', 'Column headloss_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_min_main', 'numeric', 'Column headloss_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_min_compare', 'numeric', 'Column headloss_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'headloss_min_diff', 'numeric', 'Column headloss_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_max_main', 'numeric', 'Column setting_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_max_compare', 'numeric', 'Column setting_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_max_diff', 'numeric', 'Column setting_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_min_main', 'numeric', 'Column setting_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_min_compare', 'numeric', 'Column setting_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'setting_min_diff', 'numeric', 'Column setting_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_max_main', 'numeric', 'Column reaction_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_max_compare', 'numeric', 'Column reaction_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_max_diff', 'numeric', 'Column reaction_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_min_main', 'numeric', 'Column reaction_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_min_compare', 'numeric', 'Column reaction_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'reaction_min_diff', 'numeric', 'Column reaction_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_max_main', 'numeric', 'Column ffactor_max_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_max_compare', 'numeric', 'Column ffactor_max_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_max_diff', 'numeric', 'Column ffactor_max_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_min_main', 'numeric', 'Column ffactor_min_main should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_min_compare', 'numeric', 'Column ffactor_min_compare should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'ffactor_min_diff', 'numeric', 'Column ffactor_min_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'diameter_main', 'numeric(12,3)', 'Column diameter_main should be numeric(12,3)');
SELECT col_type_is('v_rpt_comp_arc', 'diameter_compare', 'numeric(12,3)', 'Column diameter_compare should be numeric(12,3)');
SELECT col_type_is('v_rpt_comp_arc', 'diameter_diff', 'numeric', 'Column diameter_diff should be numeric');
SELECT col_type_is('v_rpt_comp_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
