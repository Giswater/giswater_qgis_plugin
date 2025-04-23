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

-- Check table sys_function
SELECT has_table('sys_function'::name, 'Table sys_function should exist');

-- Check columns
SELECT columns_are(
    'sys_function',
    ARRAY[
        'id', 'function_name', 'project_type', 'function_type', 'input_params', 'return_type',
        'descript', 'sys_role', 'sample_query', 'source'
    ],
    'Table sys_function should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_function', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_function', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('sys_function', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('sys_function', 'project_type', 'text', 'Column project_type should be text');
SELECT col_type_is('sys_function', 'function_type', 'text', 'Column function_type should be text');
SELECT col_type_is('sys_function', 'input_params', 'text', 'Column input_params should be text');
SELECT col_type_is('sys_function', 'return_type', 'text', 'Column return_type should be text');
SELECT col_type_is('sys_function', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_function', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('sys_function', 'sample_query', 'text', 'Column sample_query should be text');
SELECT col_type_is('sys_function', 'source', 'text', 'Column source should be text');

-- Check constraints
SELECT col_not_null('sys_function', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('sys_function', 'function_name', 'Column function_name should be NOT NULL');
SELECT col_is_unique('sys_function', ARRAY['function_name', 'project_type'], 'Columns function_name, project_type should be unique');

-- Check foreign keys
SELECT has_fk('sys_function', 'Table sys_function should have foreign keys');
SELECT fk_ok('sys_function', 'sys_role', 'sys_role', 'id', 'FK sys_role should reference sys_role.id');

SELECT * FROM finish();

ROLLBACK;