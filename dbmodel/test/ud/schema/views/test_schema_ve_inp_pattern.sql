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

-- Check view ve_inp_pattern
SELECT has_view('ve_inp_pattern'::name, 'View ve_inp_pattern should exist');

-- Check view columns
SELECT columns_are(
    've_inp_pattern',
    ARRAY[
        'pattern_id', 'pattern_type', 'observ', 'tsparameters', 'expl_id', 'log',
        'active'
    ],
    'View ve_inp_pattern should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_pattern', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ve_inp_pattern', 'pattern_type', 'varchar(30)', 'Column pattern_type should be varchar(30)');
SELECT col_type_is('ve_inp_pattern', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_inp_pattern', 'tsparameters', 'text', 'Column tsparameters should be text');
SELECT col_type_is('ve_inp_pattern', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_inp_pattern', 'log', 'text', 'Column log should be text');
SELECT col_type_is('ve_inp_pattern', 'active', 'bool', 'Column active should be bool');

SELECT * FROM finish();

ROLLBACK;
