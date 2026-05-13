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
SELECT has_table('node_add'::name, 'Table node_add should exist');

-- Check columns
SELECT columns_are(
    'node_add',
    ARRAY[
        'node_id', 'result_id', 'max_depth', 'max_height', 'flooding_rate', 'flooding_vol'
    ],
    'Table node_add should have the correct columns'
);

-- Check column types
SELECT col_type_is('node_add', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('node_add', 'result_id', 'text', 'Column result_id should be text');
SELECT col_type_is('node_add', 'max_depth', 'numeric(12,2)', 'Column max_depth should be numeric(12,2)');
SELECT col_type_is('node_add', 'max_height', 'numeric(12,2)', 'Column max_height should be numeric(12,2)');
SELECT col_type_is('node_add', 'flooding_rate', 'numeric(12,2)', 'Column flooding_rate should be numeric(12,2)');
SELECT col_type_is('node_add', 'flooding_vol', 'numeric(12,2)', 'Column flooding_vol should be numeric(12,2)');

-- Check foreign keys
SELECT has_fk('node_add', 'Table node_add should have foreign keys');

SELECT fk_ok('node_add', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
