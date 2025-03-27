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

-- Check table arc_add
SELECT has_table('arc_add'::name, 'Table arc_add should exist');

-- Check columns
SELECT columns_are(
    'arc_add',
    ARRAY[
        'arc_id', 'flow_max', 'flow_min', 'flow_avg', 'vel_max', 'vel_min', 'vel_avg',
        'tot_headloss_max', 'tot_headloss_min', 'result_id'
    ],
    'Table arc_add should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('arc_add', 'arc_id', 'Column arc_id should be primary key');

-- Check column types
SELECT col_type_is('arc_add', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('arc_add', 'flow_max', 'numeric(12,2)', 'Column flow_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'flow_min', 'numeric(12,2)', 'Column flow_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_max', 'numeric(12,2)', 'Column vel_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_min', 'numeric(12,2)', 'Column vel_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');
SELECT col_type_is('arc_add', 'tot_headloss_max', 'numeric(12,2)', 'Column tot_headloss_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'tot_headloss_min', 'numeric(12,2)', 'Column tot_headloss_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'result_id', 'text', 'Column result_id should be text');

-- Check foreign keys
SELECT hasnt_fk('arc_add', 'Table arc_add should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
