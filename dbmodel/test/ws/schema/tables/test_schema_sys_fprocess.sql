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
SELECT has_table('sys_fprocess'::name, 'Table sys_fprocess should exist');

-- Check columns
SELECT columns_are(
    'sys_fprocess',
    ARRAY[
        'fid', 'fprocess_name', 'project_type', 'parameters', 'source', 'isaudit',
        'fprocess_type', 'addparam', 'except_level', 'except_msg', 'except_table', 'except_table_msg',
        'query_text', 'info_msg', 'function_name', 'active'
    ],
    'Table sys_fprocess should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_fprocess', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('sys_fprocess', 'fprocess_name', 'varchar(250)', 'Column fprocess_name should be varchar(250)');
SELECT col_type_is('sys_fprocess', 'project_type', 'varchar(6)', 'Column project_type should be varchar(6)');
SELECT col_type_is('sys_fprocess', 'parameters', 'json', 'Column parameters should be json');
SELECT col_type_is('sys_fprocess', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_fprocess', 'isaudit', 'bool', 'Column isaudit should be bool');
SELECT col_type_is('sys_fprocess', 'fprocess_type', 'text', 'Column fprocess_type should be text');
SELECT col_type_is('sys_fprocess', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('sys_fprocess', 'except_level', 'int4', 'Column except_level should be int4');
SELECT col_type_is('sys_fprocess', 'except_msg', 'text', 'Column except_msg should be text');
SELECT col_type_is('sys_fprocess', 'except_table', 'text', 'Column except_table should be text');
SELECT col_type_is('sys_fprocess', 'except_table_msg', 'text', 'Column except_table_msg should be text');
SELECT col_type_is('sys_fprocess', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('sys_fprocess', 'info_msg', 'text', 'Column info_msg should be text');
SELECT col_type_is('sys_fprocess', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('sys_fprocess', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
