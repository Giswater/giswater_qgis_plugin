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

-- Check table selector_rpt_compare_tstep
SELECT has_table('selector_rpt_compare_tstep'::name, 'Table selector_rpt_compare_tstep should exist');

-- Check columns
SELECT columns_are(
    'selector_rpt_compare_tstep',
    ARRAY[
        'timestep', 'cur_user'
    ],
    'Table selector_rpt_compare_tstep should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_rpt_compare_tstep', ARRAY['timestep', 'cur_user'], 'Columns timestep, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_rpt_compare_tstep', 'timestep', 'character varying(100)', 'Column timestep should be character varying(100)');
SELECT col_type_is('selector_rpt_compare_tstep', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_rpt_compare_tstep', 'cur_user', '"current_user"()', 'Column cur_user should default to "current_user"()');

-- Check constraints
SELECT col_not_null('selector_rpt_compare_tstep', 'timestep', 'Column timestep should be NOT NULL');
SELECT col_not_null('selector_rpt_compare_tstep', 'cur_user', 'Column cur_user should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 