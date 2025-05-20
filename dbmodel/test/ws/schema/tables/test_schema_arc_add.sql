/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Table existence
SELECT has_table('arc_add'::name, 'Table arc_add should exist');

-- Columns check (order matters)
SELECT columns_are(
    'arc_add',
    ARRAY[
        'arc_id', 'result_id',
        'flow_max', 'flow_min', 'flow_avg',
        'vel_max', 'vel_min', 'vel_avg',
        'tot_headloss_max', 'tot_headloss_min',
        'mincut_connecs', 'mincut_hydrometers',
        'mincut_length', 'mincut_watervol', 'mincut_criticity',
        'pipe_capacity'
    ],
    'Table arc_add should have the correct columns'
);

-- PK
SELECT col_is_pk('arc_add', 'arc_id', 'Column arc_id should be primary key');

-- Types
SELECT col_type_is('arc_add', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('arc_add', 'result_id', 'text', 'Column result_id should be text');
SELECT col_type_is('arc_add', 'flow_max', 'numeric(12,2)', 'Column flow_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'flow_min', 'numeric(12,2)', 'Column flow_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_max', 'numeric(12,2)', 'Column vel_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_min', 'numeric(12,2)', 'Column vel_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');
SELECT col_type_is('arc_add', 'tot_headloss_max', 'numeric(12,2)', 'Column tot_headloss_max should be numeric(12,2)');
SELECT col_type_is('arc_add', 'tot_headloss_min', 'numeric(12,2)', 'Column tot_headloss_min should be numeric(12,2)');
SELECT col_type_is('arc_add', 'mincut_connecs', 'integer', 'Column mincut_connecs should be integer');
SELECT col_type_is('arc_add', 'mincut_hydrometers', 'integer', 'Column mincut_hydrometers should be integer');
SELECT col_type_is('arc_add', 'mincut_length', 'numeric(12,3)', 'Column mincut_length should be numeric(12,3)');
SELECT col_type_is('arc_add', 'mincut_watervol', 'numeric(12,3)', 'Column mincut_watervol should be numeric(12,3)');
SELECT col_type_is('arc_add', 'mincut_criticity', 'numeric(12,3)', 'Column mincut_criticity should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('arc_add', 'Table arc_add should have foreign keys');
SELECT fk_ok('arc_add', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');

SELECT * FROM finish();

ROLLBACK;
