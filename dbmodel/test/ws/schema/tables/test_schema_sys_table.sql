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
SELECT has_table('sys_table'::name, 'Table sys_table should exist');

-- Check columns
SELECT columns_are(
    'sys_table',
    ARRAY[
        'id', 'descript', 'sys_role', 'project_template', 'context', 'orderby',
        'alias', 'notify_action', 'isaudit', 'keepauditdays', 'source', 'addparam',
        'provider_config'
    ],
    'Table sys_table should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_table', 'id', 'text', 'Column id should be text');
SELECT col_type_is('sys_table', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_table', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('sys_table', 'project_template', 'jsonb', 'Column project_template should be jsonb');
SELECT col_type_is('sys_table', 'context', 'varchar(500)', 'Column context should be varchar(500)');
SELECT col_type_is('sys_table', 'orderby', 'int2', 'Column orderby should be int2');
SELECT col_type_is('sys_table', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('sys_table', 'notify_action', 'json', 'Column notify_action should be json');
SELECT col_type_is('sys_table', 'isaudit', 'bool', 'Column isaudit should be bool');
SELECT col_type_is('sys_table', 'keepauditdays', 'int4', 'Column keepauditdays should be int4');
SELECT col_type_is('sys_table', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_table', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('sys_table', 'provider_config', 'jsonb', 'Column provider_config should be jsonb');

-- Check foreign keys
SELECT has_fk('sys_table', 'Table sys_table should have foreign keys');

SELECT fk_ok('sys_table', 'sys_role', 'sys_role', 'id', 'FK sys_role → sys_role.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
