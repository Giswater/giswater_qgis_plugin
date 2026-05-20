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
SELECT has_table('man_arc_pipe'::name, 'Table man_arc_pipe should exist');

-- Check columns
SELECT columns_are(
    'man_arc_pipe',
    ARRAY[
        'arc_id', 'pipe_param_1'
    ],
    'Table man_arc_pipe should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_arc_pipe', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('man_arc_pipe', 'pipe_param_1', 'text', 'Column pipe_param_1 should be text');

-- Check foreign keys
SELECT has_fk('man_arc_pipe', 'Table man_arc_pipe should have foreign keys');

SELECT fk_ok('man_arc_pipe', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
