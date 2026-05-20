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
SELECT has_table('temp_anlgraph'::name, 'Table temp_anlgraph should exist');

-- Check columns
SELECT columns_are(
    'temp_anlgraph',
    ARRAY[
        'id', 'arc_id', 'node_1', 'node_2', 'water', 'flag',
        'checkf', 'length', 'cost', 'value', 'trace', 'isheader',
        'orderby', 'cur_user'
    ],
    'Table temp_anlgraph should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_anlgraph', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_anlgraph', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('temp_anlgraph', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('temp_anlgraph', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('temp_anlgraph', 'water', 'int2', 'Column water should be int2');
SELECT col_type_is('temp_anlgraph', 'flag', 'int2', 'Column flag should be int2');
SELECT col_type_is('temp_anlgraph', 'checkf', 'int2', 'Column checkf should be int2');
SELECT col_type_is('temp_anlgraph', 'length', 'numeric(12,4)', 'Column length should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'cost', 'numeric(12,4)', 'Column cost should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'trace', 'int4', 'Column trace should be int4');
SELECT col_type_is('temp_anlgraph', 'isheader', 'bool', 'Column isheader should be bool');
SELECT col_type_is('temp_anlgraph', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('temp_anlgraph', 'cur_user', 'text', 'Column cur_user should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
