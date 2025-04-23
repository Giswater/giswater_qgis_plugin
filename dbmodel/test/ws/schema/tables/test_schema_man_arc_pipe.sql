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

-- Check table man_arc_pipe
SELECT has_table('man_arc_pipe'::name, 'Table man_arc_pipe should exist');

-- Check columns
SELECT columns_are(
    'man_arc_pipe',
    ARRAY[
        'arc_id', 'pipe_param_1'
    ],
    'Table man_arc_pipe should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_arc_pipe', ARRAY['arc_id'], 'Column arc_id should be primary key');

-- Check column types
SELECT col_type_is('man_arc_pipe', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('man_arc_pipe', 'pipe_param_1', 'text', 'Column pipe_param_1 should be text');

-- Check not null constraints
SELECT col_not_null('man_arc_pipe', 'arc_id', 'Column arc_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_arc_pipe', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');

-- Check indexes
SELECT has_index('man_arc_pipe', 'man_arc_pipe_arc_id_index', 'Should have index on arc_id');

SELECT * FROM finish();

ROLLBACK;