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
SELECT has_table('inp_pattern'::name, 'Table inp_pattern should exist');

-- Check columns
SELECT columns_are(
    'inp_pattern',
    ARRAY[
        'pattern_id', 'pattern_type', 'observ', 'tscode', 'tsparameters', 'expl_id',
        'log', 'active'
    ],
    'Table inp_pattern should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_pattern', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_pattern', 'pattern_type', 'varchar(30)', 'Column pattern_type should be varchar(30)');
SELECT col_type_is('inp_pattern', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('inp_pattern', 'tscode', 'text', 'Column tscode should be text');
SELECT col_type_is('inp_pattern', 'tsparameters', 'json', 'Column tsparameters should be json');
SELECT col_type_is('inp_pattern', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('inp_pattern', 'log', 'text', 'Column log should be text');
SELECT col_type_is('inp_pattern', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('inp_pattern', 'Table inp_pattern should have foreign keys');

SELECT fk_ok('inp_pattern', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
