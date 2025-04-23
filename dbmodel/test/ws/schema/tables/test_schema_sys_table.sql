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

-- Check table sys_table
SELECT has_table('sys_table'::name, 'Table sys_table should exist');

-- Check columns
SELECT columns_are(
    'sys_table',
    ARRAY[
        'id', 'descript', 'sys_role', 'criticity', 'context', 'orderby', 'alias', 'notify_action', 
        'isaudit', 'keepauditdays', 'source', 'addparam'
    ],
    'Table sys_table should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_table', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_table', 'id', 'text', 'Column id should be text');
SELECT col_type_is('sys_table', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_table', 'sys_role', 'character varying(30)', 'Column sys_role should be character varying(30)');
SELECT col_type_is('sys_table', 'criticity', 'smallint', 'Column criticity should be smallint');
SELECT col_type_is('sys_table', 'context', 'character varying(500)', 'Column context should be character varying(500)');
SELECT col_type_is('sys_table', 'orderby', 'smallint', 'Column orderby should be smallint');
SELECT col_type_is('sys_table', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('sys_table', 'notify_action', 'json', 'Column notify_action should be json');
SELECT col_type_is('sys_table', 'isaudit', 'boolean', 'Column isaudit should be boolean');
SELECT col_type_is('sys_table', 'keepauditdays', 'integer', 'Column keepauditdays should be integer');
SELECT col_type_is('sys_table', 'source', 'text', 'Column source should be text');
SELECT col_type_is('sys_table', 'addparam', 'json', 'Column addparam should be json');

-- Check constraints
SELECT col_not_null('sys_table', 'id', 'Column id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('sys_table', 'Table sys_table should have foreign keys');
SELECT fk_ok('sys_table', 'sys_role', 'sys_role', 'id', 'FK sys_role should reference sys_role.id');

-- Check triggers
SELECT has_trigger('sys_table', 'gw_trg_typevalue_fk_insert', 'Table sys_table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('sys_table', 'gw_trg_typevalue_fk_update', 'Table sys_table should have gw_trg_typevalue_fk_update trigger');

SELECT * FROM finish();

ROLLBACK; 