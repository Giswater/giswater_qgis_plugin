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
SELECT has_table('sys_function'::name, 'Table sys_function should exist');

-- Check columns
SELECT columns_are(
    'sys_function',
    ARRAY[
        'id', 'function_name', 'project_type', 'function_type', 'input_params', 'return_type',
        'descript', 'sys_role', 'sample_query', 'source', 'function_alias'
    ],
    'Table sys_function should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_function', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('sys_function', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('sys_function', 'project_type', 'text', 'Column project_type should be text');
SELECT col_type_is('sys_function', 'function_type', 'text', 'Column function_type should be text');
SELECT col_type_is('sys_function', 'input_params', 'text', 'Column input_params should be text');
SELECT col_type_is('sys_function', 'return_type', 'text', 'Column return_type should be text');
SELECT col_type_is('sys_function', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_function', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('sys_function', 'sample_query', 'text', 'Column sample_query should be text');
SELECT col_type_is('sys_function', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_function', 'function_alias', 'text', 'Column function_alias should be text');

-- Check foreign keys
SELECT has_fk('sys_function', 'Table sys_function should have foreign keys');

SELECT fk_ok('sys_function', 'sys_role', 'sys_role', 'id', 'FK sys_role → sys_role.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
