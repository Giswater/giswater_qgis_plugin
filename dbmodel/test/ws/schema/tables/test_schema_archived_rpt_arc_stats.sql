/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table archived_rpt_arc_stats
SELECT has_table('archived_rpt_arc_stats'::name, 'Table archived_rpt_arc_stats should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_arc_stats',
    ARRAY[
        'arc_id', 'result_id', 'arc_type', 'sector_id', 'arccat_id', 'flow_max', 'flow_min', 'flow_avg', 'vel_max', 'vel_min',
        'vel_avg', 'headloss_max', 'headloss_min', 'setting_max', 'setting_min', 'reaction_max', 'reaction_min', 'ffactor_max',
        'ffactor_min', 'length', 'tot_headloss_max', 'tot_headloss_min', 'the_geom'
    ],
    'Table archived_rpt_arc_stats should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_arc_stats', ARRAY['arc_id', 'result_id'], 'Columns arc_id, result_id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_arc_stats', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_arc_stats', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_arc_stats', 'arc_type', 'character varying(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('archived_rpt_arc_stats', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_rpt_arc_stats', 'arccat_id', 'character varying(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('archived_rpt_arc_stats', 'flow_max', 'numeric', 'Column flow_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'flow_min', 'numeric', 'Column flow_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_arc_stats', 'vel_max', 'numeric', 'Column vel_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'vel_min', 'numeric', 'Column vel_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');
SELECT col_type_is('archived_rpt_arc_stats', 'headloss_max', 'numeric', 'Column headloss_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'headloss_min', 'numeric', 'Column headloss_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'setting_max', 'numeric', 'Column setting_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'setting_min', 'numeric', 'Column setting_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'reaction_max', 'numeric', 'Column reaction_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'reaction_min', 'numeric', 'Column reaction_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'ffactor_max', 'numeric', 'Column ffactor_max should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'ffactor_min', 'numeric', 'Column ffactor_min should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('archived_rpt_arc_stats', 'tot_headloss_max', 'numeric(12,2)', 'Column tot_headloss_max should be numeric(12,2)');
SELECT col_type_is('archived_rpt_arc_stats', 'tot_headloss_min', 'numeric(12,2)', 'Column tot_headloss_min should be numeric(12,2)');
SELECT col_type_is('archived_rpt_arc_stats', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');

-- Check foreign keys
SELECT hasnt_fk('archived_rpt_arc_stats', 'Table archived_rpt_arc_stats should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
