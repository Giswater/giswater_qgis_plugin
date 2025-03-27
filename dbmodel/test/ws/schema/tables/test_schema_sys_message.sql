/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table sys_message
SELECT has_table('sys_message'::name, 'Table sys_message should exist');

-- Check columns
SELECT columns_are(
    'sys_message',
    ARRAY[
        'id', 'error_message', 'hint_message', 'log_level', 'show_user', 'project_type', 'source'
    ],
    'Table sys_message should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_message', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_message', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('sys_message', 'error_message', 'text', 'Column error_message should be text');
SELECT col_type_is('sys_message', 'hint_message', 'text', 'Column hint_message should be text');
SELECT col_type_is('sys_message', 'log_level', 'smallint', 'Column log_level should be smallint');
SELECT col_type_is('sys_message', 'show_user', 'boolean', 'Column show_user should be boolean');
SELECT col_type_is('sys_message', 'project_type', 'text', 'Column project_type should be text');
SELECT col_type_is('sys_message', 'source', 'text', 'Column source should be text');

-- Check default values
SELECT col_default_is('sys_message', 'log_level', '1', 'Column log_level should default to 1');
SELECT col_default_is('sys_message', 'show_user', 'true', 'Column show_user should default to true');
SELECT col_default_is('sys_message', 'project_type', 'utils', 'Column project_type should default to utils');

-- Check constraints
SELECT col_not_null('sys_message', 'id', 'Column id should be NOT NULL');
SELECT col_has_check('sys_message', 'log_level', 'Column log_level should have check constraint');

-- Check triggers
SELECT has_trigger('sys_message', 'gw_trg_typevalue_fk', 'Table sys_message should have gw_trg_typevalue_fk trigger');

SELECT * FROM finish();

ROLLBACK;