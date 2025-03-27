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

-- Check table inp_times
SELECT has_table('inp_times'::name, 'Table inp_times should exist');

-- Check columns
SELECT columns_are(
    'inp_times',
    ARRAY[
        'id', 'duration', 'hydraulic_timestep', 'quality_timestep', 'rule_timestep', 'pattern_timestep',
        'pattern_start', 'report_timestep', 'report_start', 'start_clocktime', 'statistic'
    ],
    'Table inp_times should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_times', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_times', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_times', 'duration', 'integer', 'Column duration should be integer');
SELECT col_type_is('inp_times', 'hydraulic_timestep', 'varchar(10)', 'Column hydraulic_timestep should be varchar(10)');
SELECT col_type_is('inp_times', 'quality_timestep', 'varchar(10)', 'Column quality_timestep should be varchar(10)');
SELECT col_type_is('inp_times', 'rule_timestep', 'varchar(10)', 'Column rule_timestep should be varchar(10)');
SELECT col_type_is('inp_times', 'pattern_timestep', 'varchar(10)', 'Column pattern_timestep should be varchar(10)');
SELECT col_type_is('inp_times', 'pattern_start', 'varchar(10)', 'Column pattern_start should be varchar(10)');
SELECT col_type_is('inp_times', 'report_timestep', 'varchar(10)', 'Column report_timestep should be varchar(10)');
SELECT col_type_is('inp_times', 'report_start', 'varchar(10)', 'Column report_start should be varchar(10)');
SELECT col_type_is('inp_times', 'start_clocktime', 'varchar(10)', 'Column start_clocktime should be varchar(10)');
SELECT col_type_is('inp_times', 'statistic', 'varchar(18)', 'Column statistic should be varchar(18)');

-- Check foreign keys

-- Check triggers
SELECT has_trigger('inp_times', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_times', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_times', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;