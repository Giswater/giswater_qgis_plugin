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
SELECT has_table('sys_message'::name, 'Table sys_message should exist');

-- Check columns
SELECT columns_are(
    'sys_message',
    ARRAY[
        'id', 'error_message', 'hint_message', 'log_level', 'show_user', 'project_type',
        'source', 'message_type'
    ],
    'Table sys_message should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_message', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('sys_message', 'error_message', 'text', 'Column error_message should be text');
SELECT col_type_is('sys_message', 'hint_message', 'text', 'Column hint_message should be text');
SELECT col_type_is('sys_message', 'log_level', 'int2', 'Column log_level should be int2');
SELECT col_type_is('sys_message', 'show_user', 'bool', 'Column show_user should be bool');
SELECT col_type_is('sys_message', 'project_type', 'text', 'Column project_type should be text');
SELECT col_type_is('sys_message', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_message', 'message_type', 'varchar(50)', 'Column message_type should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
