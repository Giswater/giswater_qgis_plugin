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
SELECT has_table('inp_shortpipe'::name, 'Table inp_shortpipe should exist');

-- Check columns
SELECT columns_are(
    'inp_shortpipe',
    ARRAY[
        'node_id', 'minorloss', 'bulk_coeff', 'wall_coeff', 'custom_dint', 'head',
        'pattern_id', 'demand', 'demand_pattern_id', 'emitter_coeff'
    ],
    'Table inp_shortpipe should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_shortpipe', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_shortpipe', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('inp_shortpipe', 'bulk_coeff', 'float8', 'Column bulk_coeff should be float8');
SELECT col_type_is('inp_shortpipe', 'wall_coeff', 'float8', 'Column wall_coeff should be float8');
SELECT col_type_is('inp_shortpipe', 'custom_dint', 'int4', 'Column custom_dint should be int4');
SELECT col_type_is('inp_shortpipe', 'head', 'float8', 'Column head should be float8');
SELECT col_type_is('inp_shortpipe', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('inp_shortpipe', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('inp_shortpipe', 'demand_pattern_id', 'varchar(16)', 'Column demand_pattern_id should be varchar(16)');
SELECT col_type_is('inp_shortpipe', 'emitter_coeff', 'float8', 'Column emitter_coeff should be float8');

-- Check foreign keys
SELECT has_fk('inp_shortpipe', 'Table inp_shortpipe should have foreign keys');

SELECT fk_ok('inp_shortpipe', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
