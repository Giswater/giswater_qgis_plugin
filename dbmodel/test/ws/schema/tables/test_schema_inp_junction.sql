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
SELECT has_table('inp_junction'::name, 'Table inp_junction should exist');

-- Check columns
SELECT columns_are(
    'inp_junction',
    ARRAY[
        'node_id', 'demand', 'pattern_id', 'peak_factor', 'emitter_coeff', 'init_quality',
        'source_type', 'source_quality', 'source_pattern_id'
    ],
    'Table inp_junction should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_junction', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_junction', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_junction', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_junction', 'peak_factor', 'numeric(12,4)', 'Column peak_factor should be numeric(12,4)');
SELECT col_type_is('inp_junction', 'emitter_coeff', 'float8', 'Column emitter_coeff should be float8');
SELECT col_type_is('inp_junction', 'init_quality', 'float8', 'Column init_quality should be float8');
SELECT col_type_is('inp_junction', 'source_type', 'varchar(18)', 'Column source_type should be varchar(18)');
SELECT col_type_is('inp_junction', 'source_quality', 'float8', 'Column source_quality should be float8');
SELECT col_type_is('inp_junction', 'source_pattern_id', 'varchar(16)', 'Column source_pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_junction', 'Table inp_junction should have foreign keys');

SELECT fk_ok('inp_junction', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('inp_junction', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
