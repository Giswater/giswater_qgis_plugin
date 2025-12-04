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

-- Check table sys_fprocess
SELECT has_table('sys_fprocess'::name, 'Table sys_fprocess should exist');

-- Check columns
SELECT columns_are(
    'sys_fprocess',
    ARRAY[
        'fid', 'fprocess_name', 'project_type', 'parameters', 'source', 'isaudit', 'fprocess_type', 'addparam',
        'except_level', 'except_msg', 'except_table', 'except_table_msg', 'query_text', 'info_msg',
        'function_name', 'active'
    ],
    'Table sys_fprocess should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_fprocess', ARRAY['fid'], 'Column fid should be primary key');

-- Check column types
SELECT col_type_is('sys_fprocess', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('sys_fprocess', 'fprocess_name', 'character varying(250)', 'Column fprocess_name should be character varying(250)');
SELECT col_type_is('sys_fprocess', 'project_type', 'character varying(6)', 'Column project_type should be character varying(6)');
SELECT col_type_is('sys_fprocess', 'parameters', 'json', 'Column parameters should be json');
SELECT col_type_is('sys_fprocess', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_fprocess', 'isaudit', 'boolean', 'Column isaudit should be boolean');
SELECT col_type_is('sys_fprocess', 'fprocess_type', 'text', 'Column fprocess_type should be text');
SELECT col_type_is('sys_fprocess', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('sys_fprocess', 'except_level', 'integer', 'Column except_level should be integer');
SELECT col_type_is('sys_fprocess', 'except_msg', 'text', 'Column except_msg should be text');
SELECT col_type_is('sys_fprocess', 'except_table', 'text', 'Column except_table should be text');
SELECT col_type_is('sys_fprocess', 'except_table_msg', 'text', 'Column except_table_msg should be text');
SELECT col_type_is('sys_fprocess', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('sys_fprocess', 'info_msg', 'text', 'Column info_msg should be text');
SELECT col_type_is('sys_fprocess', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('sys_fprocess', 'active', 'boolean', 'Column active should be boolean');

-- Check constraints
SELECT col_not_null('sys_fprocess', 'fid', 'Column fid should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 