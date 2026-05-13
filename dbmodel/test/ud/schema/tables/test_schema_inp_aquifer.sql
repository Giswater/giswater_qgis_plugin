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
SELECT has_table('inp_aquifer'::name, 'Table inp_aquifer should exist');

-- Check columns
SELECT columns_are(
    'inp_aquifer',
    ARRAY[
        'aquif_id', 'por', 'wp', 'fc', 'k', 'ks',
        'ps', 'uef', 'led', 'gwr', 'be', 'wte',
        'umc', 'pattern_id'
    ],
    'Table inp_aquifer should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_aquifer', 'aquif_id', 'varchar(16)', 'Column aquif_id should be varchar(16)');
SELECT col_type_is('inp_aquifer', 'por', 'numeric(12,4)', 'Column por should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'wp', 'numeric(12,4)', 'Column wp should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'fc', 'numeric(12,4)', 'Column fc should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'k', 'numeric(12,4)', 'Column k should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'ks', 'numeric(12,4)', 'Column ks should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'ps', 'numeric(12,4)', 'Column ps should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'uef', 'numeric(12,4)', 'Column uef should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'led', 'numeric(12,4)', 'Column led should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'gwr', 'numeric(12,4)', 'Column gwr should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'be', 'numeric(12,4)', 'Column be should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'wte', 'numeric(12,4)', 'Column wte should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'umc', 'numeric(12,4)', 'Column umc should be numeric(12,4)');
SELECT col_type_is('inp_aquifer', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_aquifer', 'Table inp_aquifer should have foreign keys');

SELECT fk_ok('inp_aquifer', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
