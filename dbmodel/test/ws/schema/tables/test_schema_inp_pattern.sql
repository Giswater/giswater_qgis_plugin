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

-- Check table inp_pattern
SELECT has_table('inp_pattern'::name, 'Table inp_pattern should exist');

-- Check columns
SELECT columns_are(
    'inp_pattern',
    ARRAY[
        'pattern_id', 'pattern_type', 'observ', 'tscode', 'tsparameters', 'expl_id', 'log', 'active'
    ],
    'Table inp_pattern should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_pattern', ARRAY['pattern_id'], 'Column pattern_id should be primary key');

-- Check column types
SELECT col_type_is('inp_pattern', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_pattern', 'pattern_type', 'varchar(30)', 'Column pattern_type should be varchar(30)');
SELECT col_type_is('inp_pattern', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('inp_pattern', 'tscode', 'text', 'Column tscode should be text');
SELECT col_type_is('inp_pattern', 'tsparameters', 'json', 'Column tsparameters should be json');
SELECT col_type_is('inp_pattern', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('inp_pattern', 'log', 'text', 'Column log should be text');
SELECT col_type_is('inp_pattern', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('inp_pattern', 'Table inp_pattern should have foreign keys');
SELECT fk_ok('inp_pattern', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_pattern', 'pattern_id', 'Column pattern_id should be NOT NULL');
SELECT col_has_default('inp_pattern', 'active', 'Column active should have default value');
SELECT col_default_is('inp_pattern', 'active', 'true', 'Default value for active should be true');

SELECT * FROM finish();

ROLLBACK;