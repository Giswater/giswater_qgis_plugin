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

-- Check table
SELECT has_table('selector_rpt_compare_tstep'::name, 'Table selector_rpt_compare_tstep should exist');

-- Check columns
SELECT columns_are(
    'selector_rpt_compare_tstep',
    ARRAY[
        'timestep', 'cur_user'
    ],
    'Table selector_rpt_compare_tstep should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_rpt_compare_tstep', 'timestep', 'varchar(100)', 'Column timestep should be varchar(100)');
SELECT col_type_is('selector_rpt_compare_tstep', 'cur_user', 'text', 'Column cur_user should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
